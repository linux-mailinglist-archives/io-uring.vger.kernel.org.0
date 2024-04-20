Return-Path: <io-uring+bounces-1598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDE68ABBBC
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64D9CB20DC4
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207E6200CD;
	Sat, 20 Apr 2024 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iEXd1H1d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1C1C6AD
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619975; cv=none; b=MXQqxZu+UajaSulSpxxqx3f9EGl+RnNiBMShu1qRUG1K03GnjmWaYBksEYYao/i+Pmvn9rqduxt1ye4qv/wRYnr5wa84SY0LZWo2QWBLkTViyywEm8QoUze5+tvYLPVFBloRaQHEe/mbzFZPDNiL5xsWQ0h+elR/yZYi5g/qFjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619975; c=relaxed/simple;
	bh=oJw5EzDVx/dmOCawavEWxKsWWt81olYKRkyzuzjvX44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEv9uf8j4X4rKtHxEWRWuypZ+y9HbMWezXVdU9HTwSY4pG3bqJYltVDknkLaQmQztQ3ol3wi6bn5HfTo268gAs2RztSKRM8BF2LoFUPRpl/wBrUOOBrr8wNvDdqWngZ1x+oZJy1z10AX7d5x0D/khtxT+e9pX+c/CM6HPrdM0SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iEXd1H1d; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2a58d2e5be8so723551a91.0
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619971; x=1714224771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tklnKug3hQ8ywNTEYriTbnu9sFUy/MamRSTdfmmWv8=;
        b=iEXd1H1dAp0rkSI4bIPjXUWtKCuGd0cOzNA2xeVNs4gC+uYHJQlk/6dXOfN05CkK/W
         cQK3XiiSPcnKBc1bz3lBdT3cSLpQHvohyZ3lYfKv7PI61qyFd0KUj1W5w+bvKrP802Kn
         5EwEyD/rCMdgUUA5937Et9L+8qBfGlu2AZ1BXEGaliXzAkxfUHxONOYqUhZ88nI9yN3e
         Wv+y16b145MsuBGtUg5eZB1Ay34e5CLMQJc7dzxcW2yit7GS2zy/usLxl4hb2id6D0Yz
         QfioWpP1ESOyaltv0IJ3Uczi6PiFtiBiRJWIMyDma9KeXhIRzeV9tuLbhPCk0hgq0rB5
         2N4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619971; x=1714224771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tklnKug3hQ8ywNTEYriTbnu9sFUy/MamRSTdfmmWv8=;
        b=p/lCZ5UNrFe8dpCl6vuuEBWyeXnFVjHIhTnrG3iFQk1bJV8kjTszyNDlxO668jxIaL
         azHV+wy3ZJYHS3RvZSZRZx9bDUjfI2xjJ4bp9Edk/t4zrxwsQxjZfu86q8DenAxafMMR
         cw2BZ7Q79UkMOVPAlcofD49DEaj8EhVUUOz0Q5udDIKglehVgMNLcLQySTtHfeplNG6D
         xKs04UvEdtKLR5FzLYxbqzmwvs2LE+4jG1/Zxo/VF+g3gnDp3FtEwjUgdD4TxM8VsJf1
         2g2C5GI3D9y3zVjpge/gD8/D2xIS3UbpDIxeVsjsvlvL3lxu5PYAfLL1ZwKJ+OsE4e2t
         F+LA==
X-Gm-Message-State: AOJu0Yzlh1QtlDEIXh9c5Gou14nKS/Zb4+HhzyW0XF+MUIOcUqSXF1Lq
	yHDHupii9l5EGpm0nT8wXAhDsad4Aj5bN0gj/Jt4sH78zN4cG/4/eL9ovQxHTYojBf/q4ApiwFP
	D
X-Google-Smtp-Source: AGHT+IF7WpbNpWyTyXus/GP42HxlOMfRKojvUXbkLXKl5bwHWfYcEQtYdX6SbhoCqveMz+EBHrdoPg==
X-Received: by 2002:a05:6a20:3f24:b0:1aa:a384:5e73 with SMTP id az36-20020a056a203f2400b001aaa3845e73mr5833195pzb.0.1713619970715;
        Sat, 20 Apr 2024 06:32:50 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/net: add generic multishot retry helper
Date: Sat, 20 Apr 2024 07:29:43 -0600
Message-ID: <20240420133233.500590-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240420133233.500590-2-axboe@kernel.dk>
References: <20240420133233.500590-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just moving io_recv_prep_retry() higher up so it can get used
for sends as well, and rename it to be generically useful for both
sends and receives.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a1da8a2ebf15..dc310f0bfe4c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -185,6 +185,17 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 	return 0;
 }
 
+static inline void io_mshot_prep_retry(struct io_kiocb *req,
+				       struct io_async_msghdr *kmsg)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	req->flags &= ~REQ_F_BL_EMPTY;
+	sr->done_io = 0;
+	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
+}
+
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -658,17 +669,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_recvmsg_prep_setup(req);
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req,
-				      struct io_async_msghdr *kmsg)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-
-	req->flags &= ~REQ_F_BL_EMPTY;
-	sr->done_io = 0;
-	sr->len = 0; /* get from the provided buffer */
-	req->buf_index = sr->buf_group;
-}
-
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -694,7 +694,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req, kmsg);
+		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
-- 
2.43.0


