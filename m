Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B91D51606E
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiD3UyL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiD3Ux6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3798449F1F
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id bo5so9574396pfb.4
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3qI04FbggByVTu9dEQOn8xmFLuavob/w/Xw3jCMiF4=;
        b=00zBIMksoXneIvn0U5soC3W3QcckTir5Oq94nXyRySvk9gKl7m/hkajoqOeheXdD2z
         Cty6pnFN3+1x4mEsvW1P5Crdb8oJp5BVg4PiJ3aiQkbBQI8hu//Iu/BvSYByPGpq0GNI
         QI9OSIPryv0HhsWDNUVdw9rj3N/EnbeBphf91ZTrQawcYqms3UbqX4+K9mFRPrYzHkRE
         oXIQpGxVBgGj07xdAYLsuVT3N+aZ8x3LyaQ+qk0OHg4l9hxtX0cGjnE9ubcAZ16/O62M
         z4YPFSfqYRoYkb9shxDZbpmf0xLzyiEVCiM/ojEYur3VpRC9zRp+vF6M1ybYUKdpfpV6
         ly7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3qI04FbggByVTu9dEQOn8xmFLuavob/w/Xw3jCMiF4=;
        b=KAbH/E2xAzYLJbMR4ZjgkF+uxZNecxIprHPcaMz7bjUT5GkXTHFTz9UQOSuEdlh7eR
         TBinEyO7Rc3k8lJPs3Jh4A3hfyOtDvtx2fNOY8io3fh6NVgAiPiw/GcSVMGomD2QVhsQ
         8BUKjAWfDaVqbwyWdlh9t6iEbst1nFWaqttIRnT7jOuh9t1hOB45RIGJFEBcNgzrtp1U
         EQ5k2AXl4wx4cU5YkrBzMUrS/GWXrf+191UKHYSxpKyaibcjtg6woaNUbXmfSVhwh6M3
         NUDr0jaF//QKJYY7XspIzmIdggrld0NLA0EnRCWd7uBP0RoIyBfSKqLaVfxG+0QbJR2E
         HO6Q==
X-Gm-Message-State: AOAM531J1HG2sWLVPoeCoFBbG6APutWbroIHlJ4jg0Gvw1r7GhOPY75A
        OrCtN1Gx3mnpTeG2hGpsRVErHtLrzkFI7fC1
X-Google-Smtp-Source: ABdhPJxYmSf/Ox2D1gO0lwmkjctHXYsueTT3tsInSlWmVccfZDOhxI9etYr8cYhDBoSk9lKHxC9LbQ==
X-Received: by 2002:a63:87c3:0:b0:3aa:fc1b:3459 with SMTP id i186-20020a6387c3000000b003aafc1b3459mr4103297pge.210.1651351833422;
        Sat, 30 Apr 2022 13:50:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] io_uring: never call io_buffer_select() for a buffer re-select
Date:   Sat, 30 Apr 2022 14:50:17 -0600
Message-Id: <20220430205022.324902-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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

Callers already have room to store the addr and length information,
clean it up by having the caller just assign the previously provided
data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bd2f4d868c2..3b61cf06275d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3588,9 +3588,6 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return u64_to_user_ptr(kbuf->addr);
-
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
@@ -3630,8 +3627,9 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
+	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
-	iov[0].iov_len = (compat_size_t) len;
+	req->rw.len = iov[0].iov_len = (compat_size_t) len
 	return 0;
 }
 #endif
@@ -3652,8 +3650,9 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
+	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
-	iov[0].iov_len = len;
+	req->rw.len = iov[0].iov_len = len;
 	return 0;
 }
 
@@ -3661,10 +3660,8 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    unsigned int issue_flags)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		struct io_buffer *kbuf = req->kbuf;
-
-		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov[0].iov_len = kbuf->len;
+		iov[0].iov_base = u64_to_user_ptr(req->rw.addr);
+		iov[0].iov_len = req->rw.len;
 		return 0;
 	}
 	if (req->rw.len != 1)
@@ -3678,6 +3675,13 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
+static inline bool io_do_buffer_select(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return false;
+	return !(req->flags & REQ_F_BUFFER_SELECTED);
+}
+
 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 				       struct io_rw_state *s,
 				       unsigned int issue_flags)
@@ -3700,10 +3704,11 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 	sqe_len = req->rw.len;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
 			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
+			req->rw.addr = (unsigned long) buf;
 			req->rw.len = sqe_len;
 		}
 
@@ -5943,7 +5948,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
@@ -6005,12 +6010,13 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
+		sr->buf = buf;
 	}
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-- 
2.35.1

