Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF693A721D
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhFNWkN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhFNWkL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D55C061574
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso625524wmc.1
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nezE9w6+UmXMHW3RJ/0e68j6M1Ekl6fKGhCFGQzs7TY=;
        b=MaOPjXsXRlI7RCRxiJtmrU8kX5RhBH0i5yGaHVsKHk1WcrhqA5yCGl6udV5GwdYong
         /NgRVRswsAErEflgmqsl0dW1DrIC32JSWBT0sH1KHKYSSq+GnFoLfivVAHAzbEB+Iu/8
         3g6y7kHbI7/yUrpBY9lBCFXRCHWLwjnUJ3/vzgr+fLWSUJqzcdDF5UADhF1UvoIOXgGl
         m/LLM9S31dTI7kvfw277VHW/zUu0W770W1BOFg+frpKd8Dod+NhqjDHrwgiXWVN4g6yT
         9MNweIwEjkKupuv8QWjor+CixBfKq6TF1Ge0R7KPumgP0l32jiQPISCqO75KohjDhjHJ
         gttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nezE9w6+UmXMHW3RJ/0e68j6M1Ekl6fKGhCFGQzs7TY=;
        b=JARN9Qm+W4lC4J9AFmVNp4uVI9QLqMY+Zn8FDrqk2Hmk3iY5E+qYo1FC4n72rnyeMQ
         qOUBuy0ZoE39TbghKon7URd2eHr8ZC87Sl9Pl0mFS0ZE3BtcyS7B2lzqXyoIkjJg3ork
         k7ZDTaLRPQdz4q4xaFxEaBoPPFjjFxRR8K2t4m1nkEk3OcUqV7GJMWVUU4dmr/S17JIz
         NlZc1w1YOwh9O8oAAY9X7kauFNHoOmDkBvNNcb0T9M5z8rlFuOP8b056IMVni8H1UNIS
         fxou4KecGhSqo+tCNNJYPMSckg2ie/cCrzRN6aCwFSNKZtzclsDZOdh8QQ9Cvs1gQpO0
         kCPw==
X-Gm-Message-State: AOAM5325Ts1qVQH1xI8oyiiCPYBpHPE6aUZfnBvE/W0t/nM3919GS0eo
        cEdRGhNC5STURn+GjbUwEHZM0du/SEPCgbjO
X-Google-Smtp-Source: ABdhPJwHD7epxg3o3FSr5SwGcI1MWqx1eNcdpKFFnloa2ctasyQ+Xp4HkX9IrEtoRTcseANbjYuJZQ==
X-Received: by 2002:a05:600c:4a29:: with SMTP id c41mr19071874wmp.17.1623710271703;
        Mon, 14 Jun 2021 15:37:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/12] io_uring: keep SQ pointers in a single cacheline
Date:   Mon, 14 Jun 2021 23:37:20 +0100
Message-Id: <3ef2411a94874da06492506a8897eff679244f49.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sq_array and sq_sqes are always used together, however they are in
different cachelines, where the borderline is right before
cq_overflow_list is rather rarely touched. Move the fields together so
it loads only one cacheline.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d665c9419ad3..f3c827cd8ff8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -364,6 +364,7 @@ struct io_ring_ctx {
 		 * array.
 		 */
 		u32			*sq_array;
+		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
 		unsigned		sq_thread_idle;
@@ -373,8 +374,6 @@ struct io_ring_ctx {
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
-
-		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
-- 
2.31.1

