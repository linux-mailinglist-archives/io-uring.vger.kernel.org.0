Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5851530F
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378215AbiD2SAF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379492AbiD2SAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:02 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC3DC3EA0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h8so10501669iov.12
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=ANSdOQBfNC+EGBHg0Z/jq/GBVmfJWecx0nxkmfQJqa0g6c9ccqE83M85O6r4iyJn7X
         wIsH6nixXpf6hWeivaZuNnuLhT8IyS352k1RLFL2gOhp/30di9zj71O+g74cO6VAfIm/
         rAkx/hpeD4JW0rOcX3AEW2Q7FaPCFiZx44Y+M+Jjz3kgV/cjFZD3YFGa674T3ce38Bpr
         MDnZBLpB0heoYi9WYtQ0qOhDm+FLE7n/vvbyoK+KWaFvGArlNFU95A6AuUOpjlh79IBr
         6z6YFu/fEkDSFGYqwyHioLO5fMBgyPthMS6nXcIiAdklFebPJz2O5D/ngUIImskwvEDe
         Wrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=dj1sADFqRvZ/wByhdI7QvkkAuR6gXFkN20e70IB4897CDTvn1exwwp0j1BSqh13ML4
         SfeZSoirZzBl58V5gC1PyYWDNxsLQOQcJJCG88i1WvX/K3RjWLOLbbX77jYHfPLxb9tq
         QaeaWNVpk0BSzAXHDqrwdgSG5UfwGciFgYvYneU8fVp0/zbswNYzkfH70GOpMlnvZy2h
         or6HmsLIfL3yDDo1KcxigLjTB+ecCiOIadOfJAGtkzfjshvxSuHKkmV9RyRIUO4a8Zjl
         aXecsnYR6WOLFMLhKvwKoEpyS7T3RBB4+dm+XbmYl/3JyuOiCPiP9ZzTidvZDPWTmjNj
         Xvbw==
X-Gm-Message-State: AOAM533J1Xn8uJlXuDIFzowh6YUNrg5bSKm2Rdvrkn4JVdOkNCL32YaW
        joXTOvi68PLa8vKIhOSVXM5AXpHAJYWSMA==
X-Google-Smtp-Source: ABdhPJzGIfMJPT40x7tvcVqyglPrUIMDEPjpZjEhiuZe9uwjwF6zzpEAUVb/3rgMI3UyjvgDmI9j8w==
X-Received: by 2002:a05:6638:1352:b0:321:547b:daa2 with SMTP id u18-20020a056638135200b00321547bdaa2mr219273jad.128.1651255002887;
        Fri, 29 Apr 2022 10:56:42 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] io_uring: kill io_rw_buffer_select() wrapper
Date:   Fri, 29 Apr 2022 11:56:27 -0600
Message-Id: <20220429175635.230192-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After the recent changes, this is direct call to io_buffer_select()
anyway. With this change, there are no wrappers left for provided
buffer selection.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 19dfa974ebcf..cdb23f9861c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3599,12 +3599,6 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ERR_PTR(-ENOBUFS);
 }
 
-static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
-					unsigned int issue_flags)
-{
-	return io_buffer_select(req, len, req->buf_index, issue_flags);
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
@@ -3612,7 +3606,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 	struct compat_iovec __user *uiov;
 	compat_ssize_t clen;
 	void __user *buf;
-	ssize_t len;
+	size_t len;
 
 	uiov = u64_to_user_ptr(req->rw.addr);
 	if (!access_ok(uiov, sizeof(*uiov)))
@@ -3623,7 +3617,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3645,7 +3639,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3701,7 +3695,8 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
+			buf = io_buffer_select(req, &sqe_len, req->buf_index,
+						issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
-- 
2.35.1

