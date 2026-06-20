const mongoose = require('mongoose');

const productSchema = new mongoose.Schema(
  {
    // Which business owner owns this product
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    // Core fields
    name: {
      type: String,
      required: [true, 'Product name is required'],
      trim: true,
    },

    category: {
      type: String,
      default: 'General',
      trim: true,
    },

    quantity: {
      type: Number,
      required: true,
      default: 0,
      min: [0, 'Quantity cannot be negative'],
    },

    unit: {
      type: String,
      default: 'pcs',   // kg, litre, packet, box, pcs, etc.
    },

    // Pricing
    costPrice: {
      type: Number,
      default: 0,
      min: 0,
    },

    salePrice: {
      type: Number,
      default: 0,
      min: 0,
    },

    // Status: is this product currently being sold?
    status: {
      type: String,
      enum: ['not-sold', 'sold'],
      default: 'not-sold',
    },

    // Date product was first purchased / added
    dateAdded: {
      type: Date,
      default: Date.now,
    },

    // Optional: alert when stock falls below this
    lowStockThreshold: {
      type: Number,
      default: 5,
    },
  },
  {
    timestamps: true,   // adds createdAt and updatedAt automatically
  }
);

// Virtual: profit margin per unit
productSchema.virtual('profit').get(function () {
  return this.salePrice - this.costPrice;
});

// Case-insensitive name search index per user
productSchema.index({ userId: 1, name: 1 });

module.exports = mongoose.model('Product', productSchema);