import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PermissionShowResponse {
  List<Category> category;
  List<Service> service;
  List<Customer> customer;
  List<Booking> booking;
  List report;
  List user;
  List role;
  List<ExpenseTypes> expenseTypes;
  List<Expense> expenses;
  List<Quotation> quotation;
  List mailing;
  List templates;
  List marketing;
  List settings;

  PermissionShowResponse(
      {this.category,
      this.service,
      this.customer,
      this.booking,
      this.report,
      this.user,
      this.role,
      this.expenseTypes,
      this.expenses,
      this.quotation,
      this.mailing,
      this.templates,
      this.marketing,
      this.settings});

  PermissionShowResponse.fromJson(Map<String, dynamic> json) {
    if (json['Category'] != null) {
      category = new List<Category>();
      json['Category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }

    if (json['Service'] != null) {
      service = new List<Service>();
      json['Service'].forEach((v) {
        service.add(new Service.fromJson(v));
      });
    }

    if (json['Customer'] != null) {
      customer = new List<Customer>();
      json['Customer'].forEach((v) {
        customer.add(Customer.fromJson(v));
      });
    }

    if (json['Booking'] != null) {
      booking = new List<Booking>();
      json['Booking'].forEach((v) {
        booking.add(Booking.fromJson(v));
      });
    }

    if (json['Report'] != null) {
      report = new List();
      json['Report'].forEach((v) {
        report.add(v);
      });
    }

    if (json['User'] != null) {
      user = new List();
      json['User'].forEach((v) {
        user.add(v);
      });
    }

    if (json['Role'] != null) {
      role = new List();
      json['Role'].forEach((v) {
        role.add(v);
      });
    }

    if (json['Expense Types'] != null) {
      expenseTypes = new List<ExpenseTypes>();
      json['Expense Types'].forEach((v) {
        expenseTypes.add(ExpenseTypes.fromJson(v));
      });
    }

    if (json['Expenses'] != null) {
      expenses = new List<Expense>();
      json['Expenses'].forEach((v) {
        expenses.add(Expense.fromJson(v));
      });
    }

    if (json['Quotation'] != null) {
      quotation = new List<Quotation>();
      json['Quotation'].forEach((v) {
        quotation.add(Quotation.fromJson(v));
      });
    }

    if (json['Mailing'] != null) {
      mailing = new List();
      json['Mailing'].forEach((v) {
        mailing.add(v);
      });
    }

    if (json['Templates'] != null) {
      templates = new List();
      json['Templates'].forEach((v) {
        templates.add(v);
      });
    }

    if (json['Marketing'] != null) {
      marketing = new List();
      json['Marketing'].forEach((v) {
        marketing.add(v);
      });
    }

    if (json['Settings'] != null) {
      settings = new List();
      json['Settings'].forEach((v) {
        settings.add(v);
      });
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      if (this.category != null) {
        data['Category'] = this.category.map((v) => v.toJson()).toList();
      }

      if (this.service != null) {
        data['Service'] = this.service.map((v) => v.toJson()).toList();
      }

      if (this.customer != null) {
        data['Customer'] = this.customer.map((v) => v.toJson()).toList();
      }

      if (this.booking != null) {
        data['Booking'] = this.booking.map((v) => v.toJson()).toList();
      }

      if (this.report != null) {
        data['Report'] = this.report.map((v) => v.toJson()).toList();
      }

      if (this.user != null) {
        data['User'] = this.user.map((v) => v.toJson()).toList();
      }

      if (this.role != null) {
        data['Role'] = this.role.map((v) => v.toJson()).toList();
      }

      if (this.expenseTypes != null) {
        data['ExpenseTypes'] =
            this.expenseTypes.map((v) => v.toJson()).toList();
      }

      if (this.expenses != null) {
        data['Expenses'] = this.expenses.map((v) => v.toJson()).toList();
      }

      if (this.quotation != null) {
        data['Quotation'] = this.quotation.map((v) => v.toJson()).toList();
      }

      if (this.mailing != null) {
        data['Mailing'] = this.mailing.map((v) => v.toJson()).toList();
      }

      if (this.templates != null) {
        data['Templates'] = this.templates.map((v) => v.toJson()).toList();
      }

      if (this.marketing != null) {
        data['Marketing'] = this.marketing.map((v) => v.toJson()).toList();
      }

      if (this.settings != null) {
        data['Settings'] = this.settings.map((v) => v.toJson()).toList();
      }

      return data;
    }
  }
}

class Category {
  int create;
  int read;
  int update;
  int delete;

  Category({this.create, this.read, this.update, this.delete});

  Category.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    data['update'] = this.update;
    data['delete'] = this.delete;
    return data;
  }
}

class Service {
  int create;
  int read;
  int update;
  int delete;

  Service({this.create, this.read, this.update, this.delete});

  Service.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    data['update'] = this.update;
    data['delete'] = this.delete;
    return data;
  }
}

class Customer {
  int create;
  int read;
  int update;
  int delete;
  int viewInvoice;

  Customer(
      {this.create, this.read, this.update, this.delete, this.viewInvoice});

  Customer.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
    viewInvoice = json['view invoice'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    data['update'] = this.update;
    data['delete'] = this.delete;
    data['view invoice'] = this.viewInvoice;
    return data;
  }
}

class Booking {
  int create;
  int read;
  int update;
  int delete;
  int viewInvoice;

  Booking({this.create, this.read, this.update, this.delete, this.viewInvoice});

  Booking.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
    viewInvoice = json['view invoice'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    data['update'] = this.update;
    data['delete'] = this.delete;
    data['view invoice'] = this.viewInvoice;

    return data;
  }
}

class Quotation {
  int create;
  int read;

  Quotation({this.create, this.read});

  Quotation.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    return data;
  }
}

class ExpenseTypes {
  int create;
  int read;
  int update;

  ExpenseTypes({this.create, this.read, this.update});

  ExpenseTypes.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;
    data['update'] = this.update;

    return data;
  }
}

class Expense {
  int create;
  int read;

  Expense({this.create, this.read});

  Expense.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['read'] = this.read;

    return data;
  }
}
