require 'test_helper'

class UserUpgradesControllerTest < ActionDispatch::IntegrationTest
  context "The user upgrades controller" do
    context "new action" do
      should "render for a self upgrade" do
        @user = create(:user)
        get_auth new_user_upgrade_path, @user

        assert_response :success
      end

      should "render for a gift upgrade" do
        @recipient = create(:user)
        get_auth new_user_upgrade_path(user_id: @recipient.id), create(:user)

        assert_response :success
      end

      should "render for an anonymous user" do
        get new_user_upgrade_path

        assert_response :success
      end
    end

    context "show action" do
      context "for a completed upgrade" do
        should "render for a self upgrade" do
          @user_upgrade = create(:self_gold_upgrade, status: "complete")
          get_auth user_upgrade_path(@user_upgrade), @user_upgrade.purchaser

          assert_response :success
        end

        should "render for a gift upgrade for the purchaser" do
          @user_upgrade = create(:gift_gold_upgrade, status: "complete")
          get_auth user_upgrade_path(@user_upgrade), @user_upgrade.purchaser

          assert_response :success
        end

        should "render for a gift upgrade for the recipient" do
          @user_upgrade = create(:gift_gold_upgrade, status: "complete")
          get_auth user_upgrade_path(@user_upgrade), @user_upgrade.recipient

          assert_response :success
        end

        should "render for the site owner" do
          @user_upgrade = create(:self_gold_upgrade, status: "complete")
          get_auth user_upgrade_path(@user_upgrade), create(:owner_user)

          assert_response :success
        end

        should "be inaccessible to other users" do
          @user_upgrade = create(:self_gold_upgrade, status: "complete")
          get_auth user_upgrade_path(@user_upgrade), create(:user)

          assert_response 403
        end
      end

      context "for a pending upgrade" do
        should "render" do
          @user_upgrade = create(:self_gold_upgrade, status: "pending")
          get_auth user_upgrade_path(@user_upgrade), @user_upgrade.purchaser

          assert_response :success
        end
      end
    end

    context "create action" do
      mock_stripe!

      context "for a self upgrade" do
        context "to Gold" do
          should "create a pending upgrade" do
            @user = create(:member_user)

            post_auth user_upgrades_path(user_id: @user.id), @user, params: { upgrade_type: "gold" }, xhr: true
            assert_response :success

            @user_upgrade = @user.purchased_upgrades.last
            assert_equal(@user, @user_upgrade.purchaser)
            assert_equal(@user, @user_upgrade.recipient)
            assert_equal("gold", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end

        context "to Platinum" do
          should "create a pending upgrade" do
            @user = create(:member_user)

            post_auth user_upgrades_path(user_id: @user.id), @user, params: { upgrade_type: "platinum" }, xhr: true
            assert_response :success

            @user_upgrade = @user.purchased_upgrades.last
            assert_equal(@user, @user_upgrade.purchaser)
            assert_equal(@user, @user_upgrade.recipient)
            assert_equal("platinum", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end

        context "from Gold to Platinum" do
          should "create a pending upgrade" do
            @user = create(:member_user)

            post_auth user_upgrades_path(user_id: @user.id), @user, params: { upgrade_type: "gold_to_platinum" }, xhr: true
            assert_response :success

            @user_upgrade = @user.purchased_upgrades.last
            assert_equal(@user, @user_upgrade.purchaser)
            assert_equal(@user, @user_upgrade.recipient)
            assert_equal("gold_to_platinum", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end
      end

      context "for a gifted upgrade" do
        context "to Gold" do
          should "create a pending upgrade" do
            @recipient = create(:member_user)
            @purchaser = create(:member_user)

            post_auth user_upgrades_path(user_id: @recipient.id), @purchaser, params: { upgrade_type: "gold" }, xhr: true
            assert_response :success

            @user_upgrade = @purchaser.purchased_upgrades.last
            assert_equal(@purchaser, @user_upgrade.purchaser)
            assert_equal(@recipient, @user_upgrade.recipient)
            assert_equal("gold", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end

        context "to Platinum" do
          should "create a pending upgrade" do
            @recipient = create(:member_user)
            @purchaser = create(:member_user)

            post_auth user_upgrades_path(user_id: @recipient.id), @purchaser, params: { upgrade_type: "platinum" }, xhr: true
            assert_response :success

            @user_upgrade = @purchaser.purchased_upgrades.last
            assert_equal(@purchaser, @user_upgrade.purchaser)
            assert_equal(@recipient, @user_upgrade.recipient)
            assert_equal("platinum", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end

        context "from Gold to Platinum" do
          should "create a pending upgrade" do
            @recipient = create(:gold_user)
            @purchaser = create(:member_user)

            post_auth user_upgrades_path(user_id: @recipient.id), @purchaser, params: { upgrade_type: "gold_to_platinum" }, xhr: true
            assert_response :success

            @user_upgrade = @purchaser.purchased_upgrades.last
            assert_equal(@purchaser, @user_upgrade.purchaser)
            assert_equal(@recipient, @user_upgrade.recipient)
            assert_equal("gold_to_platinum", @user_upgrade.upgrade_type)
            assert_equal("pending", @user_upgrade.status)
            assert_not_nil(@user_upgrade.stripe_id)
            assert_match(/redirectToCheckout/, response.body)
          end
        end
      end
    end
  end
end
