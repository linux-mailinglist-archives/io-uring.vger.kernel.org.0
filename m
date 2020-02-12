Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF69215B1C8
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBLUZU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 15:25:20 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40779 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgBLUZU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 15:25:20 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so3774897iop.7
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sb0/VPxdG1KxirMSLE8xiqZicgQ/tOUSIgVpAOZHrKs=;
        b=ojpdY/sxnyF86kPZskwLqr8XxvJbuA2ylJpK1UUfDKvwjcqDuem0s5U532B9+62q2Y
         hQYOnbS3KPyBmmEPdRJ7l4aJWs70mTTSMZDs/d5grZGxe6K5h5B49iHufkZ4XjGWPBtQ
         obOeLaU0WFC9df2Vbb/XJVhoRoL8t1TOheig5Lcx0q9Lb5OmAiK4Dw23yNPonfmSAAZR
         5X/wC8WyKJK80LlPVdEWJGjMSiQcryrjeHCLMRHg1Phc58fNxQeDPdamsGiLnVazuWmy
         fXCSWM5WQdaQqHAFM6iEg1JuypXwZgr3vQzPz6dXs7WBtSl3RvEeh9itoAx1Y+ITT7E7
         EP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sb0/VPxdG1KxirMSLE8xiqZicgQ/tOUSIgVpAOZHrKs=;
        b=PhAmH40wfg5tq2JYRU4sfQBOamVmEStrdsMY23UiqNiedFA+WAkE1cNfpEFyksBRK1
         xtonkKxEeBCAp7pWJHXbCXDSW60tPd7+DYKj9X8DtUIHZD1cIVX5pr3yeKagx/sWhPGW
         7MCvMV+VG7b+QSylH2mbPM/NI37762tVcHoC006zkw/KeWq9f5AZRaN5r/14zZBSdZ4p
         QX0+W+VqpeFyPA6Z/Erk69UaAfEk/c/MaZ7lGQwu2PgrC6Sa/EMz6oYGPqZ63vKDOCKb
         e5EWGEsBxCGiRDkMQAGSOpze5qgML8zgR8HsEmQQvicwVnqsG9VgXtyfoNhYNbcB5atz
         B4tg==
X-Gm-Message-State: APjAAAWkmM2o73CHD1s3I7/bY/1DH669Rc94I5tUjnzzsH9FtCRzW4si
        gtBp3JkYRxGBp8FRTeg5c9RVpkLmMpg=
X-Google-Smtp-Source: APXvYqyEGXTkqecYJf1JqMYhEUFtmPCE4Vch9D5qBa+ceZ3ZVzItITHLFFvM1OlzaMViAr2K7UPaYw==
X-Received: by 2002:a5d:878c:: with SMTP id f12mr19392365ion.164.1581539118339;
        Wed, 12 Feb 2020 12:25:18 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 203sm37938ilb.42.2020.02.12.12.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 12:25:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: store io_kiocb in wait->private
Date:   Wed, 12 Feb 2020 13:25:13 -0700
Message-Id: <20200212202515.15299-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212202515.15299-1-axboe@kernel.dk>
References: <20200212202515.15299-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store the io_kiocb in the private field instead of the poll entry, this
is in preparation for allowing multiple waitqueues.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d4e20d59729..08ffeb7df4f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3625,8 +3625,8 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_poll_iocb *poll = wait->private;
-	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
 
@@ -3749,7 +3749,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	/* initialized the list so that we can do list_empty checks */
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
-	poll->wait.private = poll;
+	poll->wait.private = req;
 
 	INIT_LIST_HEAD(&req->list);
 
-- 
2.25.0

