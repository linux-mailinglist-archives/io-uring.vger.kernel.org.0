Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93072675A24
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjATQjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjATQjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:39:06 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06CCCC3D
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:03 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s3so7431216edd.4
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Bd7WzrL7kKhumT1kMbsawZVX+I9bzaB968/+2/A8XE=;
        b=Y04ro4SBmR05q53HdPxCefG9Yg2zZ45apbEUvdZ2zcEns1YMWl8IvK3TOr+XvnNumQ
         BaGode/BQf7CyNZyRYMF6I2QbLAyeW5ejbLjCjuQZMFTecB8DLi20TyYgLThYlBBcp3r
         9KmOJxRAeT6dTf9zlD+cki9GARQH8fBj+JKnazqltb+upADYNzc5/QEgAxnRFwHbrZzF
         fFTc1PgU0vd5QxItqrn8cP9VgIlZ3MuXzHzuA7f22fgCtM7D6BwRVySROf7xcjvw4Z3z
         dRFJMTZRBFn4NgKDozXCP/dFN3NaNeJQ9zOnDDvOPvrn+30JscTbai6ugHMo6Gbgpo74
         bx9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Bd7WzrL7kKhumT1kMbsawZVX+I9bzaB968/+2/A8XE=;
        b=1AhjTM5OcIre/o1VKm/ypyfZs4vO8EFlNbfug1ZkrBkkbLdmbjBQcksxhnlYMborBw
         AB6aA0kV54FFNdbXNpnNA18vz8GabASBCtkC25ZRUXN7VuFAVHCzHh0CCSDjoTCQbYHx
         5eIdXOtfxe9aichUgtlB8Q838SXWgGsjuA+qfxwFbOajdoX47fGHhwmPtk4lA62eio8P
         OGE8/RTKtMol7nMC2VJojt0IVwe4kvl9y8wBdqtNzedUai0R081/pq/OUqLc0hmp+wES
         UXgAqVoyV5MqTvaf3+ymdwjZNV5cj4/sEUuw/pTS80JC/+U3EWaPAGQEpYGvoEk695Q8
         +MxA==
X-Gm-Message-State: AFqh2krsXsrM83T4VD2h2SHYYB5I8eZcT4ENI5dDyuhmgoLTnapYkrbF
        k+lkbyOJi9Gadea6khKh78BXJkkCFNM=
X-Google-Smtp-Source: AMrXdXsQQWQIoCqFitua1AiDAxsTSKJGSMNIdBACMS2J7g7ESeXTS7atEPfc65QJ6TPRSjX2WsoqYw==
X-Received: by 2002:a05:6402:f07:b0:493:b55d:d7f2 with SMTP id i7-20020a0564020f0700b00493b55dd7f2mr18768845eda.14.1674232741427;
        Fri, 20 Jan 2023 08:39:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id t27-20020a170906179b00b008762e2b7004sm4702124eje.208.2023.01.20.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:39:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 v2 2/3] io_uring/msg_ring: fix remote queue to disabled ring
Date:   Fri, 20 Jan 2023 16:38:06 +0000
Message-Id: <cea5de1b04583dfd5bddace9cb99fc1b3dacd535.1674232514.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674232514.git.asml.silence@gmail.com>
References: <cover.1674232514.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
it's not always safe to use ->submitter_task. Disallow posting msg_ring
messaged to disabled rings. Also add task NULL check for loosy sync
around testing for IORING_SETUP_R_DISABLED.

Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/msg_ring.c | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..0a4efada9b3c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3674,7 +3674,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
 	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
@@ -3868,7 +3868,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 		return -EBADFD;
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task)
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bb868447dcdf..15602a136821 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -69,6 +69,10 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+
+	if (unlikely(!task))
+		return -EOWNERDEAD;
 
 	init_task_work(&msg->tw, func);
 	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
@@ -114,6 +118,8 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_exec_remote(req, io_msg_tw_complete);
@@ -206,6 +212,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (target_ctx == ctx)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 	if (!src_file) {
 		src_file = io_msg_grab_file(req, issue_flags);
 		if (!src_file)
-- 
2.38.1

