class Validators {
  static int minPasswordLength = 6;

  static String? validateMobile(String? value) {
    value = value?.trim();

    if (value?.startsWith('92') == true && value?.length == 12) {
      return null;
    }

    return 'Invalid Phone Number';
  }

  static String? validatePhrase(String? value) {
    value = value?.trim() ?? '';

    if (value.split(' ').length == 12) {
      return null;
    }

    return 'Recovery Phrase must be at-least 12 digits';
  }

  static String? validateCNIC(String? value) {
    String pattern = r'(^[0-9]{13}$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return 'CNIC number is required';
    } else if (!regExp.hasMatch(value ?? '')) {
      return 'CNIC number is invalid';
    }
    return null;
  }

  static String? validateName(String? value) {
    value = value?.trim();

    final regex = RegExp(r'^[^\s]+$');

    if (value == null || value.isEmpty) {
      return 'Please provide a name';
    } else if (!regex.hasMatch(value)) {
      return 'Please provide a valid name';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    // Define a regular expression for validating an Email
    final regex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (value == null || value.isEmpty) {
      return 'Please provide an email';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  static String? validateFullName(String? value) {
    value = value?.trim();

    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return 'Please provide a name';
    } else if (!regExp.hasMatch(value!)) {
      return 'Enter valid name';
    }
    return null;
  }

  static String? validateNonEmptyString(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please provide a value';
    }

    return null;
  }

  static String? validateDropDown(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please select at least one value';
    }

    return null;
  }

  static String? validateOrganizationName(String? value) {
    value = value?.trim();

    String pattern = r'(^[a-zA-Z ]*$)';

    RegExp regExp = RegExp(pattern);

    if (value?.isEmpty ?? true) {
      return 'Organization name is required';
    } else if (value!.isEmpty) {
      return 'Please enter a valid Organization name';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid Organization name';
    }
    return null;
  }

  static String? validateVerifyNumber(String? value) {
    value = value?.trim();

    if (value?.isEmpty ?? true) {
      return 'Enter number is required';
    } else if (value!.isEmpty) {
      return 'Please enter a valid verify number';
    } else if (value.length < 14) {
      return 'Number should have 10 digits only';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    value = value?.trim();

    if (value != null && value.isNotEmpty) {
      return null;
    }

    return 'Please select a location';
  }

  static String? validateNumber(String? value) {
    value = value?.trim();

    if (value != null && value.isNotEmpty) {
      try {
        double.parse(value);

        return null;
      } catch (e) {
        return 'Please return a valid number';
      }
    }

    return 'Please provide a number';
  }

  static String? validatePassword(String? password) {
    password = password?.trim() ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  static String? validateNewPassword(String? password) {
    password = password?.trim() ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }

    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
    );

    if (regex.hasMatch(password)) return null;

    return 'Password should be alpha numeric, contains at-least one upper and one lower class alphabet';
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    password = password?.trim();
    confirmPassword = confirmPassword?.trim();

    if (password != confirmPassword) {
      return 'Password & Confirm Password do not match';
    }

    return validatePassword(confirmPassword);
  }

  static String? validateBalanceAmount(
    String? userAmount,
    String? currentBalance,
  ) {
    userAmount = userAmount?.trim(); // Remove leading/trailing whitespaces

    if (userAmount == null || userAmount.isEmpty) {
      return 'Amount Required';
    }

    if (currentBalance == null || currentBalance.isEmpty) {
      return 'Not Enough Balance';
    }

    try {
      BigInt userAmountBigInt = BigInt.parse(
          (double.parse(userAmount) * 100000000).toStringAsFixed(0));
      BigInt currentBalanceBigInt = BigInt.parse(
          (double.parse(currentBalance) * 100000000).toStringAsFixed(0));

      if (userAmountBigInt > currentBalanceBigInt) {
        return 'Not Enough Wallet Balance';
      } else {
        return null;
      }
    } catch (e) {
      return 'Invalid Amount';
    }
  }
}
