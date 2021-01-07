Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837EC2EE98D
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 00:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbhAGXEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 18:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbhAGXEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 18:04:46 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB90C0612F4
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 15:04:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q75so6897709wme.2
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 15:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G02S9I5vxqpBGrbGqDxbcmhbR6Svg76DMXx02kfXZD8=;
        b=optijkQUq/kZSjbX3a5mIoUHezCfGFahazZfn5bVhjTvtRmTcTYivzrNEepF6AtMeW
         ZtGa1sPz4Q7N9cIWLkgONk/YWC16Da1NBIxw07O71g06tH1fvWhyhp/WH5VX1nlaU8xK
         KcViaUp0xAQM4Uxm9yqNfoPqvv+pjOEyKAX7USOhqwmzr/v8j8/wRySYsiPWY3qZqmlH
         lsf52d9VoiVPmA9Inug6Y+EjMhwjldYgL8R6ptTcEtd6Kpl+YXwDCA2QsRmMDnqVzQsR
         6mclpzYcdXDeRwAXRGp84v7J2XTXODv3zxHxBxov01W4Kho2S1uFX6ogtj/c2O/LCc7S
         TQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G02S9I5vxqpBGrbGqDxbcmhbR6Svg76DMXx02kfXZD8=;
        b=AG2sRPKhErD1oJGzeSHjvgwZIhtiZh9C3e4Y4j0woXuis0IM5ceFDgymHjBGRvwNx8
         DfL0nbm440mFiUnAwhHTD83j33e8zc8/r9tBRkJg9jb/qV+/SnN9yfxaZfW9plJO+3t8
         JU2WFRjDmDTMi5FlJgMMO3bR+e4XLWxCWGvggfj0B5l9XzKJQiz3V5Qx4/gEPlVgcpXX
         3fSY/5M8GgDvVkuS7xR5RMwO8O/NufmNZOnDiqTR8mfqfPm8KIfP8SX93nmReVrTcxSf
         ZAXJWLDX7K7CMSqoJF1GyKsZ28APrLsqAxM/Z4dyDVo0JTFjR8diuDeBedPzdJQQJLj/
         A1HQ==
X-Gm-Message-State: AOAM531cAPBOKI74bceB6G2dbtEBbrx12ExYdI9dNysVKY1tJxxHVAoC
        38s2myPYsvjmo+BjMfIj3oyjZkLeU88UVQ==
X-Google-Smtp-Source: ABdhPJyCanRQL0MTPS7Om5S4+klW4cqK+9NOpbXBUK0T+uNrbYJKlDzA2Aozypr/LjVALyrl3d1uNQ==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr619362wma.22.1610060644160;
        Thu, 07 Jan 2021 15:04:04 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id h4sm10005678wrt.65.2021.01.07.15.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 15:04:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] src/queue: refactor io_uring_get_sqe()
Date:   Thu,  7 Jan 2021 23:00:27 +0000
Message-Id: <0d1447abc76a1664f663f019497dbcd8b92116e3.1610060400.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline __io_uring_get_sqe() and clean up ugly naming left from it being
a macro at some point.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 16bd86b..768e34f 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -371,19 +371,6 @@ int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr)
 	return __io_uring_submit_and_wait(ring, wait_nr);
 }
 
-static inline struct io_uring_sqe *
-__io_uring_get_sqe(struct io_uring_sq *sq, unsigned int __head)
-{
-	unsigned int __next = (sq)->sqe_tail + 1;
-	struct io_uring_sqe *__sqe = NULL;
-
-	if (__next - __head <= *(sq)->kring_entries) {
-		__sqe = &(sq)->sqes[(sq)->sqe_tail & *(sq)->kring_mask];
-		(sq)->sqe_tail = __next;
-	}
-	return __sqe;
-}
-
 /*
  * Return an sqe to fill. Application must later call io_uring_submit()
  * when it's ready to tell the kernel about it. The caller may call this
@@ -394,8 +381,15 @@ __io_uring_get_sqe(struct io_uring_sq *sq, unsigned int __head)
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
+	unsigned int head = io_uring_smp_load_acquire(sq->khead);
+	unsigned int next = sq->sqe_tail + 1;
+	struct io_uring_sqe *sqe = NULL;
 
-	return __io_uring_get_sqe(sq, io_uring_smp_load_acquire(sq->khead));
+	if (next - head <= *sq->kring_entries) {
+		sqe = &sq->sqes[sq->sqe_tail & *sq->kring_mask];
+		sq->sqe_tail = next;
+	}
+	return sqe;
 }
 
 int __io_uring_sqring_wait(struct io_uring *ring)
-- 
2.24.0

