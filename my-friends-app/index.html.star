<!DOCTYPE html>
<html>

<head>
	<title></title>
	<script>
		(function ($, kendo, undefined) {

			var NS = ".replyRating",
				PREFIX = "Reply",
				WIDGET = kendo.ui.Widget,
				PROXY = $.proxy,
				STAR = "li",
				SELECT = "select",
				CHANGE = "change",
				MOUSEOVER = "mouseover",
				MOUSELEAVE = "mouseleave",
				CLICK = "click",
				REPLY_RATING = "reply-rating";

			var Rating = WIDGET.extend({
				init: function (element, options) {
					var that = this;

					WIDGET.fn.init.call(that, element, options);

					element = that.element;
					options = that.options;

					element.addClass(REPLY_RATING)
						.on(MOUSEOVER + NS, STAR, PROXY(that._mouseover, that))
						.on(MOUSELEAVE + NS, PROXY(that._mouseleave, that))
						.on(CLICK + NS, STAR, PROXY(that._select, that));
					element.find(STAR).addClass(options.starEmptyClass);

					that.value(options.value);
				},

				options: {
					prefix: PREFIX,
					name: "Rating",
					starEmptyClass: "reply-rating-star-empty",
					starFullClass: "reply-rating-star-full",
					value: null
				},

				events: [
      MOUSEOVER,
      MOUSELEAVE,
      SELECT,
      CHANGE
    ],

				value: function (value) {
					var that = this;

					if (value === undefined) {
						return that._currentValue;
					} else {
						that._currentValue = value;
						that._render(value);
					}
				},

				_mouseover: function (e) {
					var that = this,
						star = $(e.currentTarget),
						value = star.data('value');

					that._render(value);
					that.trigger(MOUSEOVER, {
						value: value,
						item: star
					});
				},

				_mouseleave: function () {
					var that = this;

					that._render(that.value());
					that.trigger(MOUSELEAVE);
				},

				_select: function (e) {
					var that = this,
						star = $(e.currentTarget),
						value = star.data('value');

					that.value(value);
					that.trigger(SELECT, {
						value: value,
						item: star
					});
					that.trigger(CHANGE);
				},

				_render: function (value) {
					var that = this,
						opt = that.options,
						star = that.element.find(STAR + '[data-value="' + value + '"]');

					if (value === null || value === undefined || star.length === 0) {
						that.element.find(STAR).removeClass(opt.starFullClass).addClass(opt.starEmptyClass);
					} else {
						star.prevAll(STAR).removeClass(opt.starEmptyClass).addClass(opt.starFullClass);
						star.removeClass(opt.starEmptyClass).addClass(opt.starFullClass);
						star.nextAll(STAR).removeClass(opt.starFullClass).addClass(opt.starEmptyClass);
					}
				},

				destroy: function () {
					var that = this;

					that.element.off(NS);

					WIDGET.fn.destroy.call(that);
				}
			});

			kendo.ui.plugin(Rating, kendo.ui, PREFIX);

		})(window.jQuery, window.kendo);

		jQuery(function ($) {

			var viewModel,
				ratingWidget;

			ratingWidget = $('.star-rating').kendoReplyRating({
				mouseover: function (e) {
					var title = e.item.attr('title');
					$('.star-hover').text(" - " + e.value + ": " + title);
				},
				mouseleave: function () {
					$('.star-hover').text("");
				}
			}).data('kendoReplyRating');

			viewModel = kendo.observable({
				rating: null
			});

			kendo.bind($('body'), viewModel);
		});
	</script>
</head>

<body>
	<ul class="star-rating" data-bind="value: rating">
		<li data-value="1" title="One"></li>
		<li data-value="2" title="Two"></li>
		<li data-value="3" title="Three"></li>
		<li data-value="4" title="Four"></li>
		<li data-value="5" title="Five"></li>
	</ul>
	<span class="star-hover"></span>
	<div class="paragraph">
		<label>Current rating:</label>
		<input type="number" data-bind="value: rating" />
	</div>
</body>

</html>