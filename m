Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8641C287
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245426AbhI2KS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbhI2KSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:44 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F8C061774
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k24so2185666pgh.8
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64oltCodKf44bJxLNVzYR4wYlpdw5wVyn85onY1bk3o=;
        b=RhopWrkUShn7Qiemgj6TKPrdW/UAYUSYvmTIeW6E+lxJAOwt7TvzjMzU80GY3P9KXo
         nRYIVqufGL81S51JfJRTmQG1qNCCTsx2cYEl+sXc5vopr40NammyKtfqBI/phgofuZzg
         j1LxrQsLzH1bpmI1n2Dgz/btFQxQKGHGR3RG/4xOmZpdn5EHb+Db/2KrjWvXw2tlXi/C
         zer5B2YXNPKBcU3rD08EQCX4Gk+10ckd0i7Q3wVikrhNQO9nC1A1XLF6Ejk4HDGgInlX
         zLSpX/NT8mQ7owcUTkkwKOpSZCk98k0Sivw4bYfp0MPY0LIPRfOXyQ2gVncO+xNVUIx5
         IMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64oltCodKf44bJxLNVzYR4wYlpdw5wVyn85onY1bk3o=;
        b=iIBtXCnQSDGDxvcIwp3t2zIqjG17IJ9jS2EmrKfyZYX3oAxhTS19JMM1sCLINOE/4B
         CsN01KDUiTWFdZGeg4kbd40efbSkXToWPY+1HJt7oBV2BouvQ0fVSe0a+ZwVx0C1O7YA
         SKR9e9wxACriWWeWpyGEC1AjWxnAuZdvwRUZ1WL2E18jJ/dRi/ney4A0ksiJKD0CCyFO
         z6CIeGVtN3d9GzvrW/hyIA93V5xSCYDAnAg/KexdUMH27HPBZ9yCG18VzkftAzX1dlK+
         c8//QKvf71K1SMSi3f1/qqBobbkb/QvOgm0KYj/M2Fuww4hrEAcJKB0s8KQ6Vq9p8lzO
         6EBA==
X-Gm-Message-State: AOAM5313mTfuM7T4m6W4V75LAENx5PO+Ifaw+AcQWOkQzBtrCqkotWs5
        12pEeRaVW5AIH/wUo+G12vOtaKtQ+ZN3S41Q460w94fS
X-Google-Smtp-Source: ABdhPJxEstP15BWa7y/cdGvF7wgeqlonZgjaF9OJx+qpwFq0jvvEv+IodkEsRdNuFq9yYWkh8gb3fg==
X-Received: by 2002:a63:4606:: with SMTP id t6mr8759385pga.388.1632910622868;
        Wed, 29 Sep 2021 03:17:02 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:17:02 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 2/6] Add kernel error header `src/kernel_err.h`
Date:   Wed, 29 Sep 2021 17:16:02 +0700
Message-Id: <20210929101606.62822-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We take the `include/linux/err.h` file from Linux kernel with a bit
modification.

The purpose of this file is to use `PTR_ERR()`, `ERR_PTR()`, and
similar stuff to implement the kernel style return value which is
discussed at [1].

The small modification summary:
  1) Add `__must_check` attribute macro.
  2) `#include <liburing.h>` to take the `uring_likely` and
     `uring_unlikely` macros.

This file is licensed under the GPL-2.0.

Link: https://github.com/axboe/liburing/issues/443 [1]
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/kernel_err.h | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 src/kernel_err.h

diff --git a/src/kernel_err.h b/src/kernel_err.h
new file mode 100644
index 0000000..b9ea5fe
--- /dev/null
+++ b/src/kernel_err.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ERR_H
+#define _LINUX_ERR_H
+
+#include <linux/types.h>
+
+#include <asm/errno.h>
+
+#include <stdbool.h>
+#include <liburing.h>
+
+/*
+ * Kernel pointers have redundant information, so we can use a
+ * scheme where we can return either an error code or a normal
+ * pointer with the same return value.
+ *
+ * This should be a per-architecture thing, to allow different
+ * error and pointer decisions.
+ */
+#define MAX_ERRNO	4095
+
+#ifndef __ASSEMBLY__
+
+#define IS_ERR_VALUE(x) uring_unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
+ */
+#define __must_check __attribute__((__warn_unused_result__))
+
+static inline void * __must_check ERR_PTR(long error)
+{
+	return (void *) error;
+}
+
+static inline long __must_check PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline bool __must_check IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline bool __must_check IS_ERR_OR_NULL(const void *ptr)
+{
+	return uring_unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
+}
+
+/**
+ * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
+ * @ptr: The pointer to cast.
+ *
+ * Explicitly cast an error-valued pointer to another pointer type in such a
+ * way as to make it clear that's what's going on.
+ */
+static inline void * __must_check ERR_CAST(const void *ptr)
+{
+	/* cast away the const */
+	return (void *) ptr;
+}
+
+static inline int __must_check PTR_ERR_OR_ZERO(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+
+#endif /* #ifndef __ASSEMBLY__ */
+
+#endif /* #ifndef _LINUX_ERR_H */
-- 
2.30.2

