Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A3249330F
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348806AbiASCmq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344650AbiASCmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:46 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC4C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:45 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id a18so956021ilq.6
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dg6o5VFX9udmT/tH7LPHAq7w6IwhPDZ9EVYww8T3l0c=;
        b=6lUS1Bc6cb5WDXJdmYxcQKLs4JHO0eKmKmW+8gHNXjP2nIcrGROvyd+veSf30mhKHz
         C56FifL9M9wAhlmkKsP4Iqt60JNmquc6M9YjgexXHODoEsBVzqiV7dTLl0KC6x11e2N/
         /Ev4iK3HSJTccvrsCwdlobihfJHXX8bKEYEzPzuIoQEfVAHTVPMDcjkqYZ01MoPYuqEy
         RqiLR3nPjxqfzaZ85NIbO+J1sg6mZoP5mLNJ+Rf/kLNltnUCjkm04D91XdjqZrBXYiKy
         9m7+HpqSA6xaknhVPPCuBUvL8KohjR2G4BVapZEVblIUBWtGFZbBe3W2uH+lu/tAGgUR
         T9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dg6o5VFX9udmT/tH7LPHAq7w6IwhPDZ9EVYww8T3l0c=;
        b=r9FYSBdT2A9P/jtwS2gzl8udhXcGwrNfQA+XI5AFKgeKSbFTpKkimRrsRwFAZ6+s7s
         NxYP4kzRnt1LQaTWnzw78KjruRWD/FiuQVmcIWhRKgQQTCQG4t5XUTFJfSW7m/gxhcG3
         2YgK5nAEQnV8O22+7pAQJEFyBTwylX+Mc+2GCb1TPbizYUB4RXi/cbgOSUu76owXOfXc
         K1ySaKwsAyrJfKCRS297AuRRrJB2hjpsDQyB0YoJLHtcwWN5t7YWEpPHrRQNdNDqg3Js
         zTzpVytWRdijgdcwHMVTDesHcGrxeuoeowd/AWa5PMEsExRiXS5pE2SViH0h+em8HL4H
         JVJQ==
X-Gm-Message-State: AOAM5326NeQ1X2KVwLUsaHpOyTGCB8NuadzaamC0eY03U5vf/X2DV/Vn
        f0Iw898Qi0hHORaUJwR4xVuif2wUGFw/UA==
X-Google-Smtp-Source: ABdhPJwYfa13R2eS/r27EcleCg/11IOmf0T3QrGhSuat5ZWwT3kgCoy2KRF7BifvzqwJIOvdusgaHQ==
X-Received: by 2002:a05:6e02:1569:: with SMTP id k9mr15459990ilu.290.1642560165156;
        Tue, 18 Jan 2022 18:42:45 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io-wq: remove useless 'work' argument to __io_worker_busy()
Date:   Tue, 18 Jan 2022 19:42:36 -0700
Message-Id: <20220119024241.609233-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use 'work' anymore in the busy logic, remove the dead argument.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5c4f582d6549..f8a5f172b9eb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -405,8 +405,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
  * Worker will start processing some work. Move it to the busy list, if
  * it's currently on the freelist
  */
-static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
-			     struct io_wq_work *work)
+static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	if (worker->flags & IO_WORKER_F_FREE) {
@@ -556,7 +555,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 */
 		work = io_get_next_work(acct, worker);
 		if (work)
-			__io_worker_busy(wqe, worker, work);
+			__io_worker_busy(wqe, worker);
 
 		raw_spin_unlock(&wqe->lock);
 		if (!work)
-- 
2.34.1

