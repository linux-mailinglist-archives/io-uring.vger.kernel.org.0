Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B74FC7FE
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 01:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiDKXLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Apr 2022 19:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiDKXLm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Apr 2022 19:11:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7870913F5C
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:27 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso836182pjf.5
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DAOYZJC0q2r2aVhS/c1ZWD/XWpJyDZU9mIITzJRRoV4=;
        b=fuYMjdma0Er5fhdSyyhGhsCJlkfFcGkUgCrnnzOBONQx+Kb52omvICOcgQQGsgaY9n
         iDqStCzQz9f6kCWMiidtcFK98MOjlBCMt4/QitHiVUv2szTT7ZBK1cJHNQAaX0/+AVBV
         E9aO+58h+BrEF+sjIQ/JQbQKkdrLVsbaXM2YR6sff5BD+FZteTr2x+jw5bkf7N0uZqR5
         svyRk/sURWOBwyormLcgyp5X5dinMixwCgHG6cShIjJX2OKuInyp7pxVALTAICm4nQYk
         L/RRAy20WZSPNYDQ2WUF1r7bg+EtJ3tQogO/t3t/rYBzha586MmCGQKVuraczukzzJbF
         wudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DAOYZJC0q2r2aVhS/c1ZWD/XWpJyDZU9mIITzJRRoV4=;
        b=eOLFX/SjvCAywKwlpjQbdd1+h9MWSSYeIiFiYcDmtGZ/IK+AdLM/SoaZceMRB6gdAV
         ex3WztaobHkqRG9T3g4RWBQxiUs2ZFq+5Whsb2zfM19s1PYtT+xOwrq3eFQfMla8Bcu0
         hhD858cpBUHZ+GKSzQNIb5KCHeJaPOG0Onn+gqLePhmEeDCo6TSjmKhror+L4FBfpIDl
         jskkuccm+dhd+AOiKqKdAZGzqffqHhN4zOjiyY2rx8sFqSdmSppUwDb7sDqsg/jTM0Nt
         YJcBeXNh2QWX2vWfQOcxC+TQBaBCcdFzptuknZXUyxRTqYT5fUTTTrfArgtuhf0wzIgi
         uSoQ==
X-Gm-Message-State: AOAM531MAEBUmul1pYSCsgL9QoQ5UAnj/MLNuld5SdpaMdor8WXMnjTV
        Qo7jQBFf2mCOvf0ADUwqS1ZpGWZnAFB54g==
X-Google-Smtp-Source: ABdhPJyTIy8Dc28kesiyG0IUytQKNAE4O4A1GjfuIlzEjj1uOhb24AVxDuB2nHRfwxEui2sIpNkKEw==
X-Received: by 2002:a17:902:da8f:b0:156:9cc4:1b07 with SMTP id j15-20020a170902da8f00b001569cc41b07mr35099189plx.20.1649718566570;
        Mon, 11 Apr 2022 16:09:26 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a631045000000b0039d942d18f0sm191614pgq.48.2022.04.11.16.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:09:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: stop using io_wq_work as an fd placeholder
Date:   Mon, 11 Apr 2022 17:09:15 -0600
Message-Id: <20220411230915.252477-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411230915.252477-1-axboe@kernel.dk>
References: <20220411230915.252477-1-axboe@kernel.dk>
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

There are two reasons why this isn't the best idea:

- It's an odd area to grab a bit of storage space, hence it's an odd area
  to grab storage from.
- It puts the 3rd io_kiocb cacheline into the hot path, where normal hot
  path just needs the first two.

Use 'cflags' for joint fd/cflags storage. We only need fd until we
successfully issue, and we only need cflags once a request is done and is
completed.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 12 ++++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 04d374e65e54..dbecd27656c7 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -155,7 +155,6 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
-	int fd;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3a97535d0550..38e62b1c6297 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -907,7 +907,11 @@ struct io_kiocb {
 
 	u64				user_data;
 	u32				result;
-	u32				cflags;
+	/* fd initially, then cflags for completion */
+	union {
+		u32			cflags;
+		int			fd;
+	};
 
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
@@ -7090,9 +7094,9 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
-		req->file = io_file_get_fixed(req, req->work.fd, issue_flags);
+		req->file = io_file_get_fixed(req, req->fd, issue_flags);
 	else
-		req->file = io_file_get_normal(req, req->work.fd);
+		req->file = io_file_get_normal(req, req->fd);
 	if (req->file)
 		return true;
 
@@ -7630,7 +7634,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
-		req->work.fd = READ_ONCE(sqe->fd);
+		req->fd = READ_ONCE(sqe->fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
-- 
2.35.1

