Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9893128A55
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfLUQPz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:15:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46502 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfLUQPz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:15:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so12252743wrl.13;
        Sat, 21 Dec 2019 08:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=FvbhtHCQgtXGCh0eEOrpAGnUQAHGTua77oXGFZMlB/Knx7xIX4j1W+VcsDf0DQDD3b
         gzE1/AAo9arZxTvFR+aL5S0jhkYSkLRD3bhg9dc4V0Hm9gN9qxprcfx8PdBhrm+7nXgP
         ArEQ7o3eXDa19NMivu5L6x9rQYe5KP+qoS/GluYXLi5aw/DUmb9dv7t9npAd+MzsUpwz
         2vOiegH0NDh/1AVZEBgdpVZBhWB2H3Ap6+5kDewD72EWC41sFqTlxj0QXrgZ5ILr/3KF
         KyRgvFq6eeUcQpUzC7GlVL09mn5wQZ0VywvnNMfOBTjIl6eVJ1TyGKKs6/84qPOzlYts
         CDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=q8X/+UvVVxBDrxJAe9lHq5QNRUwG9Vv0f116zHZCKNzVOUgtTDJ8gBsQCDSLd/29u8
         +iEAmzbftdNPMrPoXTgsNnkIS8FQkgqqcmWh14J2dqUkKfCkUcfodV06GcE10I87GPqN
         DfQ+YY45VYRCnfh30vuYwRxfpIUpIJGdjcjVhilEbuciNLouAyUkomYls15imM7cx/oE
         seIBiOmGySV08AncOx2HWhAbWjYKEiRK69iZjKM4mx8ZpqfAfF1ITbntxUIQlhavNF2G
         Xe/G0R6F8lYYnFwkjbzX1HAMinHk1uF0A3zpcYi74tn39pEgOxz4lMEK4KfiwxO1hiC6
         ++2g==
X-Gm-Message-State: APjAAAWkszYnsIZRr40wqAHE5oKbY2+qRMKLuZ2AR+c7iRWzLicRV59U
        c+sLl2kDegUBH8Z3IMW3K2kIfdrY
X-Google-Smtp-Source: APXvYqxrzyzYC6Y1N+YHHEEkvhDK0BrWWh6xXx+kUghp19fm6ofUk41tzkf4PJRly//bpLKR8zDM/A==
X-Received: by 2002:adf:c147:: with SMTP id w7mr22034564wre.389.1576944953116;
        Sat, 21 Dec 2019 08:15:53 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id o129sm13831260wmb.1.2019.12.21.08.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:15:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 1/3] pcpu_ref: add percpu_ref_tryget_many()
Date:   Sat, 21 Dec 2019 19:15:07 +0300
Message-Id: <8f663b99e6f30dc51d41456771d4a94567ab31f4.1576944502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576944502.git.asml.silence@gmail.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
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

