Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6304012BD63
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 12:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfL1LNn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 06:13:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43052 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfL1LNm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 06:13:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so28333467wre.10;
        Sat, 28 Dec 2019 03:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=BaHAUPx+4KshLERmtGWu41IFl51q0SA9VBlPqlEA72NfKzWAQHE1Ajioq3dAxUXnNS
         Yqd8ws/vsXQXDCFYiobkLscDXb56/cxBiPgQIk4qMZBFeSlyugKt5PKSywVZu5STZJy8
         /3fvrCXOBS6rrcPoNzhmuQrTvaVDFCc5WdZyYWjsECP7UK+dez21MXz/IS1E+vS8ZU6A
         NLoOKbifFbssMtUdDucMZ7zs1lwEB9gubRJPlIYQSxtT/8aDrTZmWIkiHQpUtDNg6+e/
         v00kUGXHLrwNrHdtpPOMwWIo2aADULmrweBTjqytrqe2dkjmjQTWITT/lcbqupJybwqL
         1zTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ncxg9b/1MfJvBW44JauWnlBevZqV28zJC8M4jJXK7AU=;
        b=NElM8GodMPaEGDdRPP6SiNl7Xr9tl2FfLrnkQbjiBuXSF74ja8eNMdWg40apisqlxb
         ErTo70xzTmZKRXKQ5bzsu1KLO+FufP5nutvZua0vpdyjhptgn1Dl4uP9w45h2ox9Hzam
         ZhPt9GGJE4IPMx6TRHjZouR0w7DK+PZFlcSn9F4pCuiVjZKna4vLMb+jdwq4z9Xfx0rL
         6r7PY9RMvhZr/bni4tGLawGnXFab6uGqa8FiJvy7Qdk1E1viwmcMZHv0fcAmH4Xw/R8S
         555DzFrzQXB1Gq5FHl9lAbtV9zoHyBZprxtk2Ixtk9mi4zcMM5ys+NYGIcpJlSnf0TWW
         pM1g==
X-Gm-Message-State: APjAAAUmZgc61ds3uuun+ofxljovcTP8d+wUzugonGNZEAx7VIh9lYoG
        bxsIaf2ilVj8O7nfp/tQeKk=
X-Google-Smtp-Source: APXvYqxeq20SHzRUQ8hiISSOX/ARks7467N/F1xiBr4hbPZ4EfZEVbuBLR4Tw5V9CaBXOOFcoAYNNw==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr59751007wrp.17.1577531620651;
        Sat, 28 Dec 2019 03:13:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q11sm37432622wrp.24.2019.12.28.03.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 03:13:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v4 1/2] pcpu_ref: add percpu_ref_tryget_many()
Date:   Sat, 28 Dec 2019 14:13:02 +0300
Message-Id: <9db688ebaea49de5e794d082aca351cc278ed2ed.1577528535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577528535.git.asml.silence@gmail.com>
References: <cover.1577528535.git.asml.silence@gmail.com>
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

