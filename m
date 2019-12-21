Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B22128B68
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 21:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfLUUN3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 15:13:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38658 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfLUUN3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 15:13:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so12693709wrh.5;
        Sat, 21 Dec 2019 12:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=IPb0f46TBXzjUkxbWwMcHMGBOuxd6Z8GMYX8VmjPUUah+NIZ9qM3HRbwA8as3RTuDq
         Ax56SHBcl4ibr2e5FabDpi1/0q9qDJmIm6d0E7TvdKtk/cRTK58A3RmMP/eKp83Qg2nF
         8HjSsTeizWNcEHOWL0iCpBQnqNbjOOwSjn8mqeEdqs5NRAGkVJ3ymi5Ps1L/guRdpX4Z
         dN3Mdyd3JUjkrs0jT2DW4/AlJaEIpqEAqOfPxP9KNniSPk0QHKVb+uxiUITT7jKHXill
         dvk+IXyM3Q9lxZZXNLDRCB3wXixuOpz2Zd1OQjbqroix4aTD1xrRmkDqlXU9AmcexnQK
         J4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=bLagN+mIGmivmS9eOXwYijih+qnrU4tYkG5SXQ/EZKGnuL0PKGLf7qN3WHDOKSxvkf
         mjKYMvJ0OoxZukCU1lmJ+3YEKNMgn9R23Y5OHs5NLvR4h6GVQv2ZmGJqAlzoGrPcCLCq
         LhfQaRbVD5gfPwJpoebz5ZtrUgF9CTYyxerLhiiDtSfknR9+X3du4Qii68SgNeEc9hYh
         0gLFINwE+A4RSwoOxRublF0ECVesRFYPu27Oa8neg+TsERLDnPxZ1zInzLwZdkfdadju
         6CSkZxqTJXwgDsiM55DBPSbqB43uZBJNyWw2gucfiBVlWwTV93BiAZxwIL4nLfFr6+QD
         GoeA==
X-Gm-Message-State: APjAAAW6JIKKbrJozgRXEjuCyxa1TtRCkXKGp4vuHjytQQfG9eBI4xP8
        Qgj3072HNjeKRJjf7mEtv3I=
X-Google-Smtp-Source: APXvYqyKf+ui3sASJscSsnCp7XE//P3QBdJDh6Aov4YcWQUdRC9vN5TRzcTNnT4kJLoWaL0LdoQ/qQ==
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr20564731wrr.32.1576959206814;
        Sat, 21 Dec 2019 12:13:26 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id l7sm14470821wrq.61.2019.12.21.12.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 12:13:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v3 1/2] pcpu_ref: add percpu_ref_tryget_many()
Date:   Sat, 21 Dec 2019 23:12:53 +0300
Message-Id: <8f663b99e6f30dc51d41456771d4a94567ab31f4.1576958402.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576958402.git.asml.silence@gmail.com>
References: <cover.1576958402.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add percpu_ref_tryget_many(), which works the same way as
percpu_ref_tryget(), but grabs specified number of refs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---
 include/linux/percpu-refcount.h | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 390031e816dc..22d9d183950d 100644
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
- * Increment a percpu refcount unless its count already reached zero.
+ * Increment a percpu refcount  by @nr unless its count already reached zero.
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

