Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17DA319669
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhBKXNe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhBKXNc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:13:32 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560A6C06178A
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:14 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i9so7310845wmq.1
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X/gVY8mRnvJvVFFMtMzT82VIpSEN8ubmzNvLMj8g6iI=;
        b=aZtutq+q5Vz7RbUbuCWF0f0jAoRmvLEzPZ4Ez54A/9bFa8an8udRAt80FTd7AxR/2J
         vbYd5rG7SPhBvSEhwz9nu+FY6zHz14GYDtqvFhdS10ebI7Zx/zKx4sQG/dk67OaxtQ1W
         mfPAnMFDdlOJC2Ixjw7QA9uRBNpHmC/usFjX+s2Gfy4MEfer/qgH61DW8CiLdQrxZKXc
         sV2a9lSuyti9VSxK4C9/pEADgf+D0bMlcIzaUV4mhTYOK2ySsjkpdcYV/E/FiiZDU8/X
         FZchjID0KCQoHt27JRNCgmY98g2ZSE9vrRSGP7gRPwp3VvfcsXzIiIz8+FG9MkqhOqxS
         Xq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X/gVY8mRnvJvVFFMtMzT82VIpSEN8ubmzNvLMj8g6iI=;
        b=ZqHBnCkFbBqwLuNbtBKS3lCSnw4yCk1BHp1IO/HWktUz24rSkToouI+PMboqBfRDIo
         KnDNHNohU3L/wwqgthgIbSs6cZjDwjn6IjhgG/b4gJe4kz7GR2YrENpasS7NTNWfbRGQ
         sEDUiIYqjSBQ1EzV0KtrmEvnmGl6QRKxR4VyRDWZhnqVuBEczSnQStUNqSRcR3uae/DA
         /i7IeEVveXovGW++/iARBQioEVMNlH4q7JMxKmXO3qSwvi9ZopvTGnPDHMr7frgX9DTv
         IGnidIZVDZulvndbMjLjaJnGZVSi/Gy2aOby1iDxlBwyk39ohtG8lnpha+6bTBrr68JU
         sBCg==
X-Gm-Message-State: AOAM531qCpY5wWuQNjMGLgMk8H6m/SM7DBXeMG3ZyC6ryPoDrCcpnntK
        UcxS3RSIKgAykFybrxGhgXQ=
X-Google-Smtp-Source: ABdhPJzUWYQHHMDgoydbgZek0CRFXIZLt2rfBhdZkamGPwOSBDToXL2TVdlMBpXE0MCyIl09Q2DZeg==
X-Received: by 2002:a1c:67c3:: with SMTP id b186mr256663wmc.24.1613085133119;
        Thu, 11 Feb 2021 15:12:13 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 5/5] src/queue: fix no-error with NULL cqe
Date:   Thu, 11 Feb 2021 23:08:16 +0000
Message-Id: <b25fe433cc381227e620ccf7e84ccdeb0c733e33.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
References: <cover.1613084222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Can happen that _io_uring_get_cqe() returns success without filled cqe,
and it's ok, especially for wait_n=0. Fix up error code for functions
that always want to have a valid CQE on success.

Also don't do cq_ring_needs_flush() check in a some weird place,
mainstream it together with wait_nr testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h |  4 +++-
 src/queue.c            | 10 +---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 90403bc..27c5a14 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -601,7 +601,9 @@ static inline int io_uring_wait_cqe_nr(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned wait_nr)
 {
-	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL);
+	int ret = __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL);
+
+	return (ret || *cqe_ptr) ? ret : -EAGAIN;
 }
 
 /*
diff --git a/src/queue.c b/src/queue.c
index 4fb4ea7..0b09a9c 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -93,7 +93,6 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 
 	do {
 		bool need_enter = false;
-		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 		unsigned nr_available;
 		int ret;
@@ -101,14 +100,7 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
 		if (err)
 			break;
-		if (!cqe && !to_wait && !data->submit) {
-			if (!cq_ring_needs_flush(ring)) {
-				err = -EAGAIN;
-				break;
-			}
-			cq_overflow_flush = true;
-		}
-		if (data->wait_nr > nr_available || cq_overflow_flush) {
+		if (data->wait_nr > nr_available || cq_ring_needs_flush(ring)) {
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
 			need_enter = true;
 		}
-- 
2.24.0

