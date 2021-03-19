Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8A342355
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSR1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhCSR1H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:07 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99119C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so7731573wml.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wxUYFCwgUSQbvVMBpgiLxne1qk6T7ffxdoVsbbHNt+Q=;
        b=o4tBCFd/aan8wljE6jbnLWUs6Azac4y4JzoguffmY5dfsXbMEsYjyrTEmLiidospUd
         5RVCY5sMI+HCQf22Qxg1MCCRtvXQ4Hf3WWO/vKbxwhs9Iy3xwutaSXvggNWTNCR2QiHq
         LqX+WsZSZ2vM4WLVO7K1DAa/s+BXL7OBWENdaaUe1BdJUHAwGr1lJnGVIMrzcdsMQ7m7
         KolPjaAT6BYZWN4Tdopa3uTD9Zea8EjBj0T6sNrnWHbba/F/5yKWvhOZoyIbh7XA8wxe
         u0kvqj+6F0JraJA36EMRNeiZaBybyb8x/Gd2QTrwnfEGSAiCEJwayI0qauaF3ohWO6j7
         FyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxUYFCwgUSQbvVMBpgiLxne1qk6T7ffxdoVsbbHNt+Q=;
        b=A+BxkN+xhd3iS2XhOMAX8iAILc7hPgB8PVP0b1EHGOf+Npld637gzmsk5+dVuFr4PW
         aSM/J3vbXG4b2tiSIjbigT1PsWlUAjQ1k9jJcAtlgjOVGhG+Gs4c26qN5YhxL+gn1dEj
         lQ5naIXQq5CAnAL5tCGzK27OlPLt3qz9zpE3eWjttNq9Rt7y2XzX9+nBNI+udSzZ8sIF
         Ae3Be3FdNRLJXdQJndgXH6tiUc+dpJpuMB5634WnTjGCmnruYtkuxp+8qpE6r9kJcUV6
         Aqta5HS5uCZIN11n6WTvEMjxE+3/8IRmxOCM+4yCOZ1qehXTL6WFLiTTyU+aw9fLnvwl
         DeqQ==
X-Gm-Message-State: AOAM530QRxTxq+ED2MbdMkY+DjKy/8mvpq1K/dM9NOCDQMXubuCjYERT
        TYx9Ad3e8cms6lszPzyPs24=
X-Google-Smtp-Source: ABdhPJx2xmk/1OTjxwPnz3MORcdA+YLa/Cm7R3d5jZNyz/2saQPvO1GMFhGFEE4hU+dX2U+S9gu3hw==
X-Received: by 2002:a05:600c:1913:: with SMTP id j19mr4604661wmq.155.1616174825358;
        Fri, 19 Mar 2021 10:27:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/16] io_uring: abolish old io_put_file()
Date:   Fri, 19 Mar 2021 17:22:43 +0000
Message-Id: <dd9b87e6ce4a04d6577b9a7649f753936af9a373.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_put_file() doesn't do a good job at generating a good code. Inline
it, so we can check REQ_F_FIXED_FILE first, prioritising FIXED_FILE case
over requests without files, and saving a memory load in that case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b3484cedf1f1..d7b4cbe2ac3a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1716,10 +1716,9 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return state->reqs[state->free_reqs];
 }
 
-static inline void io_put_file(struct io_kiocb *req, struct file *file,
-			  bool fixed)
+static inline void io_put_file(struct file *file)
 {
-	if (!fixed)
+	if (file)
 		fput(file);
 }
 
@@ -1727,8 +1726,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
-	if (req->file)
-		io_put_file(req, req->file, (flags & REQ_F_FIXED_FILE));
+	if (!(flags & REQ_F_FIXED_FILE))
+		io_put_file(req->file);
 	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
 		     REQ_F_INFLIGHT)) {
 		io_clean_op(req);
@@ -3647,7 +3646,8 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
-	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
@@ -3683,7 +3683,8 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	if (sp->len)
 		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
 
-	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
@@ -5967,8 +5968,8 @@ static void io_clean_op(struct io_kiocb *req)
 			}
 		case IORING_OP_SPLICE:
 		case IORING_OP_TEE:
-			io_put_file(req, req->splice.file_in,
-				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
+			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
+				io_put_file(req->splice.file_in);
 			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
-- 
2.24.0

