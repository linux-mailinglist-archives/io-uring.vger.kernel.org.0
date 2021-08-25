Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960E3F7503
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240761AbhHYMY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 08:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbhHYMY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 08:24:27 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE3C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:41 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so4176794wme.1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+aqoAiI0NK8PDPAHU16L5TNSpHokr3q/ADb4gPTJZl0=;
        b=LEJ5RvYqsLm9ddMcNCZLKKS8KFfbWnGK3B9Ly3PZmX9DWReLXdyOKdZd3azG3obvxJ
         RxdsH955lmoe8syzRmCyALmjLepayPrld7uYfYDQiEa4Hp6h/kCfIhvxVoFXCaxof1RS
         pF5DfsyuMoZj2AZ4Ufz8E6GQ9S3byOcckhFnVBTpxoYx0uLSaos9MC3Fhy4w4W5u5Np9
         q0Kbu7PFVLLqMTO4iJ4ouF4GqNcaUY1MvRYwgzWTao07drvWf5XL5uADqTuhs1x6k8Qj
         r2JQz5KzU5phLJHee/NdYxKBQzsyna55mN76IrWpqztYrYz+PiFa5n9aBucSt3Dg7AMf
         WEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+aqoAiI0NK8PDPAHU16L5TNSpHokr3q/ADb4gPTJZl0=;
        b=HBro1f9e6hSPcnOvmnvRRDCBkAQIcAq7MOO8cEMUl0GZDyQsBo263M/J4W1cu68ptb
         stuYcD+/a2feOXopgsuhQZJw0nrEt5H1TRC+XSld5ciMc7b1ICsSPCgHIhV2xJw6aU/d
         OADiSSnglpNT5tlM+gYzsqGqqYhzIg03pA2enCe3Csrt7N19QEkSAAGmbGDvV0QPoz1y
         zxHpJ0euXB18d212sDnwUfQlhElYn0CTqWMFWwXVc9u7mAe5hyHPDXJeD68nBfsc7sfx
         74eBoER8CRa697Z5dgAjfagz60ZSupf/7ZX7UW+KIeh+FoeLQKRTwzU9ezrl+vj61t96
         w4lw==
X-Gm-Message-State: AOAM5313gTQK7J0CrCAjmyocKpEKXpVDJz4S1ps+qrmuSAizMk+PPQ1I
        yI7Zv5axDBl4rwRv0iWKS4w=
X-Google-Smtp-Source: ABdhPJxSOO3QCtfLLz5OPytxWv+iaFwfk5kQxSDIpDYRmMZA1jWDR6/mCDWpzPGJMRmDVxLGHsOlIg==
X-Received: by 2002:a05:600c:154d:: with SMTP id f13mr8861723wmg.153.1629894220333;
        Wed, 25 Aug 2021 05:23:40 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id l12sm5226199wms.24.2021.08.25.05.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:23:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] liburing.h: add a multipoll helper
Date:   Wed, 25 Aug 2021 13:23:01 +0100
Message-Id: <b795d577590abd84f435381f02363551e7fd13b4.1629893954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629893954.git.asml.silence@gmail.com>
References: <cover.1629893954.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper for preparing a multipoll request and use it in a test.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h   | 7 +++++++
 test/poll-mshot-update.c | 3 +--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index f073e25..d20dd25 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -323,6 +323,13 @@ static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
 	sqe->poll32_events = poll_mask;
 }
 
+static inline void io_uring_prep_poll_multishot(struct io_uring_sqe *sqe,
+						int fd, unsigned poll_mask)
+{
+	io_uring_prep_poll_add(sqe, fd, poll_mask);
+	sqe->len = IORING_POLL_ADD_MULTI;
+}
+
 static inline void io_uring_prep_poll_remove(struct io_uring_sqe *sqe,
 					     void *user_data)
 {
diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index 6bf4679..75ee52f 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -70,8 +70,7 @@ static int arm_poll(struct io_uring *ring, int off)
 		return 1;
 	}
 
-	io_uring_prep_poll_add(sqe, p[off].fd[0], POLLIN);
-	sqe->len = IORING_POLL_ADD_MULTI;
+	io_uring_prep_poll_multishot(sqe, p[off].fd[0], POLLIN);
 	sqe->user_data = off;
 	return 0;
 }
-- 
2.32.0

