Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378864E499B
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 00:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiCVXUf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 19:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiCVXUe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 19:20:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B62126F
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 16:19:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j13so6855078plj.8
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=WmrigXfyWisx9mQwKesRtNEic81SwbjjcQMry0tIamk=;
        b=1XIv1Z3Sr17f62+kRtuJzkl9262URTp0Hp6jAQfRDbgmzJuE9kC5FuvTX+rv8H4qdU
         kThB/+sCSwRw+lRw9qXRX7IicxI5DwdfAJ/KBM3t6bpveC30h4gT88Q7xRsESA8vQXWy
         LGt/rMRT1YmV2DjFjNfCEKpLEvb3O1RagN3cSKgT7GghwdNHsxuuzbGVQ2smlimhGNjR
         H5fnsAZF8rO6YxdpbmyXu/73DUH5+wDkUn2TNO0a0PG1D7G3AbQES/j+QzPCJjDg8GlP
         Sv8Pa8nJRxfB05NwkiDvEwHg6L78fIj6m4W385h5Em7MzSuYGSHAIVFsqVtOX8eGHkwB
         CH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=WmrigXfyWisx9mQwKesRtNEic81SwbjjcQMry0tIamk=;
        b=VsSd/z9ztlMHYZhUWdFiVU5VNdy368RH0P49a+u2ofwAoaNS674/n0K0FsJVKiOYzW
         npfIe75DRmFIR2b60x0Tjk8ss/kDFgdXynE1lz5HgOqwXuu+0MEfJrr1inFhkNxQ+gIx
         SpLYFPDJDfspQWXL/y82LFQXG3G08Ud0Z4oXAPFpBNFR2VbsbpN1RkJVL3tdfUxofhQq
         sXglYmY/3fYmJEicPR6ch73Z7g73fanXkJlXkwsrjnMSRoXrgDulh+/q3Q9P3vK+awSm
         N0leG5qeOxw9jBEIz2CuCLqWVt2KypxnbxcnSUF7hMj7nsKLKpFkYQ1b8LZPpLfDD36a
         gsQA==
X-Gm-Message-State: AOAM533+7aozCsDsywPlsQvej5lW7Ldrw873974UmDzhtrrLtPJ9qsCj
        Tg4F5ND82m2QJgvDQQAXnzd2n049hEASk2r8
X-Google-Smtp-Source: ABdhPJwN+snJzsUMNVX3hlm34JKN888rJkqg3fZbsV0HewDOpgpd1GT3d+FK1CaKOt6sBdY5tWdfPA==
X-Received: by 2002:a17:902:7c94:b0:14d:77d2:a72e with SMTP id y20-20020a1709027c9400b0014d77d2a72emr20816153pll.153.1647991144844;
        Tue, 22 Mar 2022 16:19:04 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s15-20020a17090a880f00b001c6b0114038sm3792069pjn.4.2022.03.22.16.19.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 16:19:04 -0700 (PDT)
Message-ID: <bcac46ed-a7d3-1008-4d5b-27d4643b18bf@kernel.dk>
Date:   Tue, 22 Mar 2022 17:19:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't recycle provided buffer if punted to async
 worker
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only really need to recycle the buffer when going async for a file
type that has an indefinite reponse time (eg non-file/bdev). And for
files that to arm poll, the async worker will arm poll anyway and the
buffer will get recycled there.

In that latter case, we're not holding ctx->uring_lock. Ensure we take
the issue_flags into account and acquire it if we need to.

Fixes: b1c62645758e ("io_uring: recycle provided buffers if request goes async")
Reported-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b12bbb5f0cf7..245610494c3e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1386,7 +1386,7 @@ static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
-static void io_kbuf_recycle(struct io_kiocb *req)
+static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -1395,6 +1395,9 @@ static void io_kbuf_recycle(struct io_kiocb *req)
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
 
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_lock(&ctx->uring_lock);
+
 	lockdep_assert_held(&ctx->uring_lock);
 
 	buf = req->kbuf;
@@ -1402,6 +1405,9 @@ static void io_kbuf_recycle(struct io_kiocb *req)
 	list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	req->kbuf = NULL;
+
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_unlock(&ctx->uring_lock);
 }
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
@@ -6259,7 +6265,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req);
+	io_kbuf_recycle(req, issue_flags);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
 	if (ret || ipt.error)
@@ -7509,7 +7515,6 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		 * Queued up for async execution, worker will release
 		 * submit reference when the iocb is actually submitted.
 		 */
-		io_kbuf_recycle(req);
 		io_queue_async_work(req, NULL);
 		break;
 	case IO_APOLL_OK:

-- 
Jens Axboe

