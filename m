Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12A816897D
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgBUVqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:17 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45434 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgBUVqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:16 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so1628209pgk.12
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6IYHHyt4avenWSErlKgGcF4FUcgHTghpjSRoECGMQM=;
        b=F/f+fTq6F/HiXTC1gjIk4xZu53pag6zU+kMz7N2g3Tnt4ryB2zmU7xbI+dA9Zrx5ft
         PG/p07li6AKOF5OvHKgyb3rr1Q5ojYjvue3/yFW3MpeSJLGSpafffexpPs3CMvIspqER
         UThNAWDvXGS0ANKKN132h4Sa87JVvai2F6IzuhSp6JWZtpKorGa1hCt00aCpFhF3Ufca
         rvSeqU8cPxzoBgmweTis2j2BL5EhMYcopS35lje2wUkV32ewV+zZeKNWiMslv4iwYiYv
         wYjIAGRkMBgJ4LysGiCxfJ3FPFLcwwQatnIseSjHdAiBgI77BqzIwGTYGavwLL35m8tu
         /UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6IYHHyt4avenWSErlKgGcF4FUcgHTghpjSRoECGMQM=;
        b=siwxs6nYdrWUOsuLS3zHetjQ6Zg4J661Teci5EcgocW0cTwoyUHwfGaZsr+UI0ISuw
         DzD5pWa3KAjgDLDugBiR50jUxRgwtTdncErZ5QbheYAdWbSdimZXrBlymTnLI0VMmVDn
         gEvXqI4s5+xlkW3/Ban9f+tqU8kKPdVo4a7Zo0OBVuVP1OOAv5J6NNC+ypaa+lBA71o9
         IEgsnjNDE4Q0eDB+2ROvEwDs7E+pA1mjJmPHefn29lGMm686s8qzYyGNRcmcw/UEPDB/
         pZVXjyfxfBL8KXrhPwgtkgw8TyN6Q7su9H5O9xNR9gbHUsBQdgxsnvLcKOOMkO/wl3nI
         GW7w==
X-Gm-Message-State: APjAAAXu3ojfg4TBIGdlnJLVGByd4Djoh5UMYdVir4nSEtRGNURrCrtl
        wWMUH4NqMleorLRArWWv44oxOAuFuTg=
X-Google-Smtp-Source: APXvYqxpkvr/LzFSNyj3j7TOSI6dHJMhSA0NUN6toogViSGeaXuM39EdL6cHfk+tKXIIEX4gNBOa6g==
X-Received: by 2002:a63:6202:: with SMTP id w2mr35155738pgb.154.1582321574825;
        Fri, 21 Feb 2020 13:46:14 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring: store io_kiocb in wait->private
Date:   Fri, 21 Feb 2020 14:46:03 -0700
Message-Id: <20200221214606.12533-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
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
index c15f8d6bc329..634e5b2d822d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3635,8 +3635,8 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_poll_iocb *poll = wait->private;
-	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
 
@@ -3759,7 +3759,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	/* initialized the list so that we can do list_empty checks */
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
-	poll->wait.private = poll;
+	poll->wait.private = req;
 
 	INIT_LIST_HEAD(&req->list);
 
-- 
2.25.1

