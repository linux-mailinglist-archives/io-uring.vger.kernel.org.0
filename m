Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C849536B4B3
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 16:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhDZOSk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 10:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhDZOSf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 10:18:35 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D956DC061763
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 07:17:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l2so3732483wrm.9
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 07:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc+gvRLU1+x9tbbg1/CIBjcgikBDsduxu17SA5XrO5s=;
        b=gnDAq+lp2K+KjDiNd2XXGzs4+jm+g830Ei+A0ZTJC5d5Vq1C4Onc/L+kPQ9hprgCXA
         8fYux+PeWX5Yb/fY3BWYUhd5R7xGytqu3A7EZWAvrCnSIjlOm8cjkIy26DLzWlxB+bcF
         OQSUfmVSrPAnmYLzDJ8Atwo7cNG6gwhFgvGSfvUyFyUPndyl2RpFa5Jvoio5lv+ygGG+
         oTH9TbDBIxP4j9Cv2zRwXHmA8be57fHbibjEeQhu5to8Uhxbf4xIVtOA1ir/0v/qina1
         uaSCR3GQndoqGTeo/gk7GY9Agk/VmCmusk1VUbsXQKxZeI+Vby22LCLoWA3kutUL5NVl
         vdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc+gvRLU1+x9tbbg1/CIBjcgikBDsduxu17SA5XrO5s=;
        b=QSTiVDk4Nh3SV1V70r3wyUbhsA/41NkCvzyfV5JOkKTWic4VEfwo9oECad3eGslQuX
         A1xRb220coOY01yF2LtglINdg7lXouQicEsqSWT3yNq2wyp7hsvL5m5dW7dX04ZgDVev
         8IzNjc1vVyeoyUEQk3dDDIYRI4aeKrYcSXfYCVrK5/e5tae5BE0a+fm8cdeMUbnAbrql
         i965QNjFroF4XFQxwQUYhnDGfoianvwvVtB6/FOnmX/dy5+78LvBSwlHCMcnoIHGr9Aq
         tjvxw+wpt5aBIIpnAOrj71kCBEoNHb4FJljErEtvfwLt7fNuNMsXQyQkYh+beODkfff/
         dSpA==
X-Gm-Message-State: AOAM532Q0KNDo0xgPUQnQlvSmDphquf1Yg9xWrRi/MMMfR6tFaZeDHGk
        0TMfsFH3xSYNBGW1frfqVmCHjpydsBQ=
X-Google-Smtp-Source: ABdhPJw1N4z1j9tHvj3hIH8OplXnFLBZ0bVmUHfwStmk/+E4vWVaTP+QB2nacg4JZ4JVrETH/6KSJA==
X-Received: by 2002:adf:c002:: with SMTP id z2mr2121195wre.100.1619446671468;
        Mon, 26 Apr 2021 07:17:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id u14sm137625wrq.65.2021.04.26.07.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:17:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13] io_uring: fix NULL reg-buffer
Date:   Mon, 26 Apr 2021 15:17:38 +0100
Message-Id: <830020f9c387acddd51962a3123b5566571b8c6d.1619446608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_import_fixed() doesn't expect a registered buffer slot to be NULL and
would fail stumbling on it. We don't allow it, but if during
__io_sqe_buffers_update() rsrc removal succeeds but following register
fails, we'll get such a situation.

Do it atomically and don't remove buffers until we sure that a new one
can be set.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b578c380e73..863420e184cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8419,7 +8419,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
-	struct io_mapped_ubuf *imu;
 	struct page *last_hpage = NULL;
 	bool needs_switch = false;
 	__u32 done;
@@ -8431,6 +8430,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_mapped_ubuf *imu;
+		int offset = up->offset + done;
 		u64 tag = 0;
 
 		err = io_copy_iov(ctx, &iov, iovs, done);
@@ -8440,28 +8441,27 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
+		err = io_buffer_validate(&iov);
+		if (err)
+			break;
+		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
+		if (err)
+			break;
 
-		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
-		imu = ctx->user_bufs[i];
-		if (imu) {
-			err = io_queue_rsrc_removal(ctx->buf_data, up->offset + done,
-						    ctx->rsrc_node, imu);
-			if (err)
+		i = array_index_nospec(offset, ctx->nr_user_bufs);
+		if (ctx->user_bufs[i]) {
+			err = io_queue_rsrc_removal(ctx->buf_data, offset,
+						    ctx->rsrc_node, ctx->user_bufs[i]);
+			if (unlikely(err)) {
+				io_buffer_unmap(ctx, &imu);
 				break;
+			}
 			ctx->user_bufs[i] = NULL;
 			needs_switch = true;
 		}
 
-		if (iov.iov_base || iov.iov_len) {
-			err = io_buffer_validate(&iov);
-			if (err)
-				break;
-			err = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
-						     &last_hpage);
-			if (err)
-				break;
-			ctx->buf_data->tags[up->offset + done] = tag;
-		}
+		ctx->user_bufs[i] = imu;
+		ctx->buf_data->tags[offset] = tag;
 	}
 
 	if (needs_switch)
-- 
2.31.1

