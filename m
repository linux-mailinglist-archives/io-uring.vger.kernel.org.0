Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE47F635BDB
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiKWLf1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiKWLfJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:09 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A800FAEBA
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:08 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id b12so15145440wrn.2
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjP9WNNy11R90tHNf8lVvOLzHW5TTZzK32JlDgD+taA=;
        b=U9wjYC4y6qqGvEteKdOk7rZ4HJESVZiG/tl/aMX7MIQQAAb6bEN7YcRWB4BNZRAW6v
         soXZzDDmZ3nx81//5n+0KI6AkauCT7vNJjlip9KQ8dC86pyE0NNyY71M9x5cIubXmPS2
         G45r4b+11S96NQ1UWC3B8HzGqqOtS8M68ZPCpX6JcvxUqIUpzmNd3gNXRwY0DXoGjWmL
         +idjErIHVDu0FVwKVb+FL2hUcXCdo0V+eOtPntIGuVwlV7hRUxBKD1KIF95rLRv5fRZG
         fK4Ss0PqANHNDn05UnigPsOM529jMDx5L5H+e84ZYN/LSbzslaqOr+48c2PK5m3koP6A
         Ftbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjP9WNNy11R90tHNf8lVvOLzHW5TTZzK32JlDgD+taA=;
        b=uD5uo3q90ax5nZCIquI0e7wJnHJT3pNiO7jqyraDkaBH7QtKuF2MSerucnl2tZ6XbX
         70GCUKT7toF+WpkTWIodTpnbi66dzY2PRXmjghtPPGLSOO/G2yZEWGShOvCTTDaw0qGd
         aFe0aKl2TalMERMXOvB9+ut6IeJXuYszaiTfzVGA8z1CbKFB94hjviMtMyD4X2VMysJG
         FXF66IRzZAgCCMepxQpCUcO03W17J9mkfE0RgjLztfDS1WKAmGSOR50pjVawRE5ZHUik
         Z/9aS9f997LzMXLsqqbmhHlm5f8mnaCo5JokD92KNmX7Ik3Owh+R4zBs27wOEYHD7Yo4
         HzkQ==
X-Gm-Message-State: ANoB5pmNcI2LBVxn+N6pEJTTfg7Ggd2qEvcny3EsaXd+ziEaBcIyd+Rd
        W0uDJJLyiy2tH38WQSP6gC9BXZnvoNY=
X-Google-Smtp-Source: AA0mqf6iOCpvwT4MiPSKDWdV53apVtAdjZFBcpeV/QuwMLb2KI8HX2SylbqKry7P0fdHqHJVpKrD0w==
X-Received: by 2002:adf:fe90:0:b0:232:eb2:6a33 with SMTP id l16-20020adffe90000000b002320eb26a33mr10299367wrr.325.1669203306608;
        Wed, 23 Nov 2022 03:35:06 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/7] io_uring: remove iopoll spinlock
Date:   Wed, 23 Nov 2022 11:33:42 +0000
Message-Id: <7e171c8b530656b14a671c59100ca260e46e7f2a.1669203009.git.asml.silence@gmail.com>
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

This reverts commit 85f0e5da546bb215a27103ac8c698b8f60309ee0

io_req_complete_post() should now behave well even in case of IOPOLL, we
can remove completion_lock locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 61c326831949..1ce065709724 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1049,7 +1049,6 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	else if (!pos)
 		return 0;
 
-	spin_lock(&ctx->completion_lock);
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
@@ -1064,11 +1063,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		req->cqe.flags = io_put_kbuf(req, 0);
 		__io_fill_cqe_req(req->ctx, req);
 	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
+
 	if (unlikely(!nr_events))
 		return 0;
 
+	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);
-- 
2.38.1

