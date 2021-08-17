Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB93EF2A8
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhHQT30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT30 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 15:29:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD623C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso1038203wmc.3
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RsHH2A8GC2vw+aiPc22LoLczFGWh1HflTg0nGjIdxAk=;
        b=tSJlIhAI7s76ByUKQtXPmrnGELX31mkBQnVXXV6fvCm0VWSHM5cYqa8vG2m7xF5pUj
         nDygEA+LrCaTErodlCKQrcZtiwyIlkR4CFF2nzrJNyMj+E5wIuZm27374Nts0L3MFAu5
         w6YutBOhLsfTIk8X5RNtTdkBsdS/jEYNAnZsWUeApZlmxW+ceijZLrIuXiQFcIIffYIM
         c2P5KFHrqnvTVghQpF+PGVKPKJdKBEwFOdulMflado6nFeMg8FERG05CIz1ACiuAdGPC
         5Kc3g19f0/E1CFlZ/qnGlLuQ1qeZmNxi0A64DAgoH52KXFjxy+DyyF8Z88z4073G85hf
         mUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RsHH2A8GC2vw+aiPc22LoLczFGWh1HflTg0nGjIdxAk=;
        b=dW+wN6zsRPOxe+rVeap6S01ZBgO748JgvOv8P0hsfTRdFR9NPpU3pcLQwEhoZTTgpT
         TjE7E75m/qgToZ1RgQC5wVlIVldtupnLPWkFp9/DPbJOssLsF6HV1+IWdJbPRT+tJBdU
         0u0r3oimVeKLbwzQNPqUT+I/OWZTKr/rMXKVcMvzuz9EEj4eprRkCxw0lZhvzwvzVU3R
         m9RbAyNqvhzhUlYQ/py3jbVrh9Tn8MqgFbRQdYvyDqN2HcDgeNiuWWZmgUPhg7FY/7On
         nvyMjA8KAucrB4u5D2Dq8kk24G5N2jq8pzxRkRnX56rAjvbcbyvAXTEjIuW0K7f9nTjJ
         P5VQ==
X-Gm-Message-State: AOAM532zYY9DOreR2cQU6nvF4MVAPTcr6Bn72BWvmlBLkHagRPmCqkjo
        gI6h+wN52tZU6yLUH8s+vYqAJsQvh2k=
X-Google-Smtp-Source: ABdhPJxIzoRK77OTwVFhAYQIfgGy5BmuPkqfJGjuZNvHk3WHDkSWxIYuDXoJkfPKGG0z2ZS4PefeGA==
X-Received: by 2002:a1c:720f:: with SMTP id n15mr4987633wmc.14.1629228531483;
        Tue, 17 Aug 2021 12:28:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e6sm3120388wme.6.2021.08.17.12.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: improve same wq polling
Date:   Tue, 17 Aug 2021 20:28:11 +0100
Message-Id: <8cb428cfe8ade0fd055859fabb878db8777d4c2f.1629228203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629228203.git.asml.silence@gmail.com>
References: <cover.1629228203.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move earlier the check for whether __io_queue_proc() tries to poll
already polled waitqueue, and do the same for the second poll entry, if
any. Shouldn't really matter, but at least it would have a more
predictable behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 202517860c83..1be7af620395 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5064,8 +5064,13 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	if (unlikely(pt->nr_entries)) {
 		struct io_poll_iocb *poll_one = poll;
 
+		/* double add on the same waitqueue head, ignore */
+		if (poll_one->head == head)
+			return;
 		/* already have a 2nd entry, fail a third attempt */
 		if (*poll_ptr) {
+			if ((*poll_ptr)->head == head)
+				return;
 			pt->error = -EINVAL;
 			return;
 		}
@@ -5075,9 +5080,6 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		 */
 		if (!(poll_one->events & EPOLLONESHOT))
 			poll_one->events |= EPOLLONESHOT;
-		/* double add on the same waitqueue head, ignore */
-		if (poll_one->head == head)
-			return;
 		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
 		if (!poll) {
 			pt->error = -ENOMEM;
-- 
2.32.0

