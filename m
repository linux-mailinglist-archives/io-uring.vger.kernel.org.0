Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71423533301
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiEXVhg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241932AbiEXVhf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E197C173
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:34 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f4so2059165pgf.4
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFlSgwalLl9Cqqe5Co3myKgHH6/YZh8N+CMAW+ZAMNg=;
        b=xQWqNFPWnNQ0KF2DbcrJOR7uKh+7q9FROlmdyJ9Lreet5/Txv+SAwgiFDE+1FMKaGN
         UCXvTO4wLYa2LY4WRh0jpYiA+tqLUAEwT0MN6n0abKooWYrS1THhnLqfXpGkxE8JJrJY
         caD30JtbdF0fS3KxhHT7tXrXNE3KToPt4r3VGh9eZvdv7H4vsWa4N8VYefBVQ9b/7Ips
         OoMtTN0PqMiGt2wURepl5FqhLi5xONur5ZQR3RC83dmAWtGVPJ0tYBOXb4eztGSGbsuW
         XMH4xGDYoimvjdHJvm9Uy1meR1bg4U1sezqbRexNZvY1y/nmylNoXEx2ouCZsAtEm0SG
         yelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFlSgwalLl9Cqqe5Co3myKgHH6/YZh8N+CMAW+ZAMNg=;
        b=f5d0V/4kzQzuKMc2la/0GiDDAMX6s7zpw60DxN+hCDAit7utgECCOKl8r1y4teUEXg
         GA6B6zacSBPHbSzo1sH6I8b2MsScbEIWjiHSfG10oFp6TnXPGpSFZWWGcJNvr8CSw/mq
         xxzq83cyQQAcsr9g7UX1uDkCMmb03gvpDEJzWwPXp94f/El7v1lWKMs9CVoBM9FcMrI3
         G6YwpBcN02j4LBm6L9RwLam9y0MNNx7u74K8hC2Q7oigihN475QYwgr1vnwa4gSf3Ox5
         nUsVQhCb9UQYXjTosSoblwX4wybVF3oC2YbPlbTC77zD40l1+qwFmiV4w+BOxAkK+14b
         CnOg==
X-Gm-Message-State: AOAM533LZ9Gt8pGMkZp4vKrh3MQeYDGzYYYTgbNmU/1XDrb0rvM4AIqG
        pLfDTyVxNKrlmmO1/4lXlu3DE2k/Rd3i1A==
X-Google-Smtp-Source: ABdhPJxMs/PxayFSYBW5gtC2pSWVH/jdBZRHLGkNAp/eHjCelgq7k8nT1c+GjuVnt+bhnZUS6ZdU9Q==
X-Received: by 2002:a63:e047:0:b0:3c6:bf87:3ab3 with SMTP id n7-20020a63e047000000b003c6bf873ab3mr25368422pgj.373.1653428253557;
        Tue, 24 May 2022 14:37:33 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: make prep and issue side of req handlers named consistently
Date:   Tue, 24 May 2022 15:37:23 -0600
Message-Id: <20220524213727.409630-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Almost all of them are, the odd ones out are the poll remove and the
files update request. Name them like the others, which is:

io_#cmdname_prep	for request preparation
io_#cmdname		for request issue

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c3991034b26a..01a96fcdb7c6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7390,7 +7390,7 @@ static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 }
 
-static int io_poll_update_prep(struct io_kiocb *req,
+static int io_poll_remove_prep(struct io_kiocb *req,
 			       const struct io_uring_sqe *sqe)
 {
 	struct io_poll_update *upd = &req->poll_update;
@@ -7454,7 +7454,7 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
+static int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_cancel_data cd = { .data = req->poll_update.old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
@@ -7983,7 +7983,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_rsrc_update_prep(struct io_kiocb *req,
+static int io_files_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
@@ -8038,7 +8038,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_POLL_ADD:
 		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:
-		return io_poll_update_prep(req, sqe);
+		return io_poll_remove_prep(req, sqe);
 	case IORING_OP_FSYNC:
 		return io_fsync_prep(req, sqe);
 	case IORING_OP_SYNC_FILE_RANGE:
@@ -8068,7 +8068,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_CLOSE:
 		return io_close_prep(req, sqe);
 	case IORING_OP_FILES_UPDATE:
-		return io_rsrc_update_prep(req, sqe);
+		return io_files_update_prep(req, sqe);
 	case IORING_OP_STATX:
 		return io_statx_prep(req, sqe);
 	case IORING_OP_FADVISE:
@@ -8334,7 +8334,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_poll_add(req, issue_flags);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_update(req, issue_flags);
+		ret = io_poll_remove(req, issue_flags);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
 		ret = io_sync_file_range(req, issue_flags);
-- 
2.35.1

