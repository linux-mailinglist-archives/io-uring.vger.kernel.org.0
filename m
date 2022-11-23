Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8B635BDD
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiKWLfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiKWLfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:05 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E76D11DA22
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e11so16037127wru.8
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MIExCVbcFv8WjOmUdmSVgU/bQB8FiUSuBIUeZkm1cg=;
        b=Ib4e4whjwYqacZE24sQmkCI/pWXU05PF8y8hK0CMqL+G9bckIKNJfWSuUvubIKTsss
         XTOhRzeIBVvmNBBRGwtfbkL0AIcSkhU97gq4x9D2xUKmEb04o7rIaPymsApW5QweOSUE
         qvPEK4FmEVH2XaAhMEBX4R3crML6uv5+FMknj2pOqzhPakq/pw03IQlvUTqM2hUBJsjj
         w2Ln2mH8ZP0Cc/8SDeIKysHbKRRa/AjFcfR8l+dLisYPeDj5SoPTRZqAN7NihId6dVcP
         zxRlVYneom4Q/RX0q+e2hjKIu8qIVMZeeEICgu6NupikhQIU1V5n5ZAPJJ06qtjXF0SF
         vUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MIExCVbcFv8WjOmUdmSVgU/bQB8FiUSuBIUeZkm1cg=;
        b=1xczrT7youjLR+9LS2mr60XgJn8DbuSqqR9ueITgq71OIKtRxc7G9zKn4bUxE1YV0w
         oHM9UHQC6IiN3y2nlJc/8iS2+gnsuJ8TNWarkcuBN8QFJtVzKRrCqa2nywTOisXhFpxz
         MRBa3lcgdDmWKdKljHIDrM6OJtBCEHwh82ARaINcpFNLNalSSbc3k8kKpeidYGK2GtV8
         rTaecXAp9Mvlirheoaft2dgVLr9bR6EBux+URJweZuU6xeC3uCapr5LcR+rL5U1RBtK7
         22b1ON6oKPs48ruXtuFnvtvvs+abYFz4KL3NY2kdRBBosOQQzp9ny5mEaA4EW4ugjDkM
         iHJg==
X-Gm-Message-State: ANoB5pk2WkpAdYs1C33u+xBwgDqM1SqyH8zZ+RPFVQHswAA+SGRvytNz
        R8aJlRb1kMT7NbmL6TvDgKmnvHkL9Vk=
X-Google-Smtp-Source: AA0mqf4t85piBUIJ93/jKQye6OrD1XSJjcRiiMy7+3OsRm1SGhKlURpPsRiIP3rTYCONjdoZb7gcCg==
X-Received: by 2002:a5d:6088:0:b0:22e:5149:441d with SMTP id w8-20020a5d6088000000b0022e5149441dmr16987066wrt.661.1669203302938;
        Wed, 23 Nov 2022 03:35:02 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/7] io_uring: hold locks for io_req_complete_failed
Date:   Wed, 23 Nov 2022 11:33:37 +0000
Message-Id: <70760344eadaecf2939287084b9d4ba5c05a6984.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
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

A preparation patch, make sure we always hold uring_lock around
io_req_complete_failed(). The only place deviating from the rule
is io_cancel_defer_files(), queue a tw instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2087ada65284..a4e6866f24c8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -861,9 +861,12 @@ inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 }
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
+	__must_hold(&ctx->uring_lock)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
@@ -1614,6 +1617,7 @@ static u32 io_get_sequence(struct io_kiocb *req)
 }
 
 static __cold void io_drain_req(struct io_kiocb *req)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
@@ -2847,7 +2851,7 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
-		io_req_complete_failed(de->req, -ECANCELED);
+		io_req_task_queue_fail(de->req, -ECANCELED);
 		kfree(de);
 	}
 	return true;
-- 
2.38.1

