Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF1D3A7229
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhFNWlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:41:15 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40885 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFNWlO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:41:14 -0400
Received: by mail-wr1-f44.google.com with SMTP id y7so16109597wrh.7
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Mbs4aKS06IZB+TfbxZSxhmpyU33xxQ8V3Cs1/lVqiZQ=;
        b=durPPVJj5VCcQPE5ppl8Cex8sthgYZxH83XfV6zo0h5FtrZ/vQ/clnE3hQr3M6o39G
         PwIKlwvhnhDJcJCp1ZBZD0I1JYkfxGtDq57pHq5aYOZY9CzGgdZHOZ7hBHkUCJJrTNlh
         FqHqQsrSEKc2M6VNqscsacxGN0luEhDgqUOatiHqCdrgQOS+3VoXVgWY2iyh2V7YTsKg
         40Qf03T4Bijkvp2/QGHtoWYFF1jSfbRavyMlX1xCmHKqi6OjSGJL+cUJ2duXKABx7URG
         Lh9xOiu3YV1T66qMzYEGfIKltTNYlMh0Jv5Q1/OTsqVxPITKnXzQvuuTVBZZjD+UCRGH
         ZRyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mbs4aKS06IZB+TfbxZSxhmpyU33xxQ8V3Cs1/lVqiZQ=;
        b=E4JNG35s0mcrvtPYMofTzgkxhWSBiSCFRbAP36mLB2m+5GeSt4F78WDjI0odSWA3tv
         SqyzW0Cn4ASHvixQ2bvXCCz657jhZ2OlhmbL99dmvMg0FlhwanI/dDwAjWSdjZzGURku
         nI4stS8RXQpF27RFKvNzfREBCRjTNNJCn8H6zjQ/rljMwA8586IxuD619FrX0ItpE/4m
         F0lJDtMWOyn3x88QqNV0xq9NUBIsADzEBcITca6cw5iXPpgkFoQnzWqoNXG7c4M/UC5P
         SQuuQMkCXjvGLjs+e5BDI6uexlfSCoWLEnv043/j1tcCXlDtuRriBAFzXl/1oncP5zdH
         9jgQ==
X-Gm-Message-State: AOAM532Ovfs1HUtObndtKQDLbM2gqeWyOa72aearxMzEcl8WirJ6m9o7
        EVhT5Z78Agh9KFLo9tDQotYWyKIWt/SzxUEt
X-Google-Smtp-Source: ABdhPJz8IONYMMOpm/9LfPCh7IrGDFXfwQPeXhU/PU/ZulcUHEyxacqa6Wpb9wcruWrFuIrvUoa4pQ==
X-Received: by 2002:adf:b19a:: with SMTP id q26mr1086284wra.401.1623710278047;
        Mon, 14 Jun 2021 15:37:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/12] io_uring: small io_submit_sqe() optimisation
Date:   Mon, 14 Jun 2021 23:37:26 +0100
Message-Id: <1579939426f3ad6b55af3005b1389bbbed7d780d.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

submit_state.link is used only to assemble a link and not used for
actual submission, so clear it before io_queue_sqe() in io_submit_sqe(),
awhile it's hot and in caches and queueing doesn't spoil it. May also
potentially help compiler with spilling or to do other optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fbf3b2149a4c..9c73991465c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6616,8 +6616,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			io_queue_sqe(head);
 			link->head = NULL;
+			io_queue_sqe(head);
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
-- 
2.31.1

