Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34A4216F6
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhJDTFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbhJDTFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2A1C06174E
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f9so6318284edx.4
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LvDWyJd7gs5JraUpAVqs0jGLLiIsJfzKW7qd52vYhn0=;
        b=WOL6My7MuTMQRRrRV60fAMgS91v7H6ZibP6C+HBGXQnFxgo9Z8YR7bs0nzaDQHurtj
         /ww6iyB1gn1540PvVdolXfhND9MzdFAQNPNAkPjAepKLZ3CY7tXbF4QTKLKyer13VFcP
         r7ae5TNLi9qw28kLXWoyDSzr2yaSdYXdvYi+ldfWLraiOluvPTmPu3QqudzB9V+virpm
         UIS5QXnYFm56OniAaylJG+f6EslQp2+q5jWvLFwKQ0q3ajIINqGnvHYN3A3/m9tOon6T
         C/2InQUAnjJ+Fnd2ND33zsm4BpBYtJ2Vjg4UveOWAa2UHp3ELYuQiPZds1QQ12QQ0l1g
         pRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LvDWyJd7gs5JraUpAVqs0jGLLiIsJfzKW7qd52vYhn0=;
        b=wTjz5fbiXzx8w4xw3koV//GIAkU7bllMP4uotaCEyVZAFPQdVBb5qQyBMwTM8YRjdl
         2pFrXksBZbOM4l+5vBE3m2Ip5GOqULK84zuLwAkNrw+CtZv/tgVpnVRj+AzwbT06/mzS
         Q5bPVQq0KEGnX/z4b5mPSkJ50UjtW6wHmLJZzjq77aKsnI7owYLcTp8ZSiA9nWWFfyAs
         giQQhGLVsmiU4ruCfSmR0ceITomUL5Ld0X44K+8vCiFtQAuSetWJAKWj116cveFyN0KO
         XSRkVnMoegOUZGDWJ63a1v+JMobyDeebJ4wDuQZ4AYDS2g6mYVS4LcvLpJ6ec3ONu8Qe
         ZD4Q==
X-Gm-Message-State: AOAM5320Gf1KylKQs0TIW/oC64W6EjtR6jOZA3ytB3hqeFPyayPzmSEz
        0K5vuAwLWzR+n8LB2mzTShjafKNforg=
X-Google-Smtp-Source: ABdhPJwSN10nQ7/E8DXYzsbDtBkRYno/NbvZVSGVwgPBoh64M7fKadagDmeWQjJcfz+IPstSkaK7Yg==
X-Received: by 2002:a17:906:1901:: with SMTP id a1mr19659269eje.129.1633374238779;
        Mon, 04 Oct 2021 12:03:58 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 12/16] io_uring: remove struct io_completion
Date:   Mon,  4 Oct 2021 20:02:57 +0100
Message-Id: <5299bd5c223204065464bd87a515d0e405316086.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We keep struct io_completion only as a temporal storage of cflags, Place
it in io_kiocb, it's cleaner, removes extra bits and even might be used
for future optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1e93c0b1314c..9f12ac5ec906 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -684,11 +684,6 @@ struct io_hardlink {
 	int				flags;
 };
 
-struct io_completion {
-	struct file			*file;
-	u32				cflags;
-};
-
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -847,22 +842,20 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
-		/* use only after cleaning per-op data, see io_clean_op() */
-		struct io_completion	compl;
 	};
 
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
-
 	u16				buf_index;
+	unsigned int			flags;
+
+	u64				user_data;
 	u32				result;
+	u32				cflags;
 
 	struct io_ring_ctx		*ctx;
-	unsigned int			flags;
-	atomic_t			refs;
 	struct task_struct		*task;
-	u64				user_data;
 
 	struct percpu_ref		*fixed_rsrc_refs;
 	/* store used ubuf, so we can prevent reloading */
@@ -870,13 +863,13 @@ struct io_kiocb {
 
 	/* used by request caches, completion batching and iopoll */
 	struct io_wq_work_node		comp_list;
+	atomic_t			refs;
 	struct io_kiocb			*link;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
-
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
 	struct io_wq_work		work;
@@ -1831,11 +1824,8 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
 static inline void io_req_complete_state(struct io_kiocb *req, long res,
 					 unsigned int cflags)
 {
-	/* clean per-opcode space, because req->compl is aliased with it */
-	if (io_req_needs_clean(req))
-		io_clean_op(req);
 	req->result = res;
-	req->compl.cflags = cflags;
+	req->cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
 }
 
@@ -2321,7 +2311,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 						    comp_list);
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+					req->cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-- 
2.33.0

