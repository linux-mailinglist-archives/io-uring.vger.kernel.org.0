Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79F123A10
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLQW3S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:29:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36191 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfLQW3S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:29:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so99388wma.1;
        Tue, 17 Dec 2019 14:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AFQWToDfV8y/8FN4VbHjGOimtg1FB9OBEOTvFpK+Bzw=;
        b=sjZpTO6w1bAurL+6D3h7cUoTUclJJay+9DW8UiAPNuSD0jmLy2ONlz1S775hLLcJ4m
         k+0EJ07pNbCOiUG/XbP5y2dUUREndROEyZhA2J65Jm+EX1qqILSpXnWm98Elx8bF2T5V
         OEJK2rnR9bwDJQaf+zvi/yr58odYerPF8FgFUSpY93nExxwzFQnH0v5i09UKIocHHzAs
         2M0T4hcaYLn4Cw9MKYzMPRmhHAevo5soCRiuhh3Fte74XE0rXD/eY1iivo7J0PO8r9Z1
         GGNFweN4XIa8niOk1Dairshc2FY38gFx0EI12Ycz4sme809qNSjsn9rRt5gcN0AuFD0B
         EkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFQWToDfV8y/8FN4VbHjGOimtg1FB9OBEOTvFpK+Bzw=;
        b=EutkOCp9xe2HaYe3J8CWt5eaaz7qcu4rw//zABGf4pGwlsKlhDFM1Ou50HiVe8NNbE
         XrDONMPoLGHk1xSlDE7IVECWZM4H0A8qEIF4A/b0/TqqlH4+aGxbGAnUkJxmPiYP6qlI
         zLN3wucSIUT+lIuEOv1BwlecvmvMfq0QI4wXS72Q9j7WfC48mfGQRZZ7tnAQOdjlrxYw
         612wjs6QemPW6zEFDYi26IhvExFWX7jQ0jB/kxYNW6TTL4tuBs8M8EDvz21ZATYsHxS0
         qMCMjILIA/FHMuweK+OxzhH7E+8m55yKdwICji3J0aagya3uIOG+kLoPpt/MYmavIrfM
         Ulng==
X-Gm-Message-State: APjAAAWNCd5YywVQZZTY0o1ILdwVwFopaYfPc6v0BBRFHPfGCwtKRf5H
        qCJZ11rhQPK6nk8f3iJEP4k7MxAg
X-Google-Smtp-Source: APXvYqxLgjP7j6MZazpC+1M7zva2yMmtx67mrux2L5S/HutgAXUimc7w31MNXzFN8Ygogsbg15lvDA==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr8568355wmc.78.1576621756503;
        Tue, 17 Dec 2019 14:29:16 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id q68sm306036wme.14.2019.12.17.14.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:29:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pcpu_ref: add percpu_ref_tryget_many()
Date:   Wed, 18 Dec 2019 01:28:38 +0300
Message-Id: <c430d1a603f9ffe01661fc1b3bad6e3101a8b855.1576621553.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576621553.git.asml.silence@gmail.com>
References: <cover.1576621553.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add percpu_ref_tryget_many(), which works the same way as
percpu_ref_tryget(), but grabs specified number of refs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/percpu-refcount.h | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 390031e816dc..19079b62ce31 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -210,15 +210,17 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 }
 
 /**
- * percpu_ref_tryget - try to increment a percpu refcount
+ * percpu_ref_tryget_many - try to increment a percpu refcount
  * @ref: percpu_ref to try-get
+ * @nr: number of references to get
  *
  * Increment a percpu refcount unless its count already reached zero.
  * Returns %true on success; %false on failure.
  *
  * This function is safe to call as long as @ref is between init and exit.
  */
-static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+static inline bool percpu_ref_tryget_many(struct percpu_ref *ref,
+					  unsigned long nr)
 {
 	unsigned long __percpu *percpu_count;
 	bool ret;
@@ -226,10 +228,10 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	rcu_read_lock();
 
 	if (__ref_is_percpu(ref, &percpu_count)) {
-		this_cpu_inc(*percpu_count);
+		this_cpu_add(*percpu_count, nr);
 		ret = true;
 	} else {
-		ret = atomic_long_inc_not_zero(&ref->count);
+		ret = atomic_long_add_unless(&ref->count, nr, 0);
 	}
 
 	rcu_read_unlock();
@@ -237,6 +239,20 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	return ret;
 }
 
+/**
+ * percpu_ref_tryget - try to increment a percpu refcount
+ * @ref: percpu_ref to try-get
+ *
+ * Increment a percpu refcount unless its count already reached zero.
+ * Returns %true on success; %false on failure.
+ *
+ * This function is safe to call as long as @ref is between init and exit.
+ */
+static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+{
+	return percpu_ref_tryget_many(ref, 1);
+}
+
 /**
  * percpu_ref_tryget_live - try to increment a live percpu refcount
  * @ref: percpu_ref to try-get
-- 
2.24.0

