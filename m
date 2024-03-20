Return-Path: <io-uring+bounces-1147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A01C880903
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30D1D1C2281F
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EB42582;
	Wed, 20 Mar 2024 01:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="meDzAHuj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1E747F
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897784; cv=none; b=AkHKS3fCEFa54MIQDYAtXZ23F0FIpnpJ5lebJzXzEom9MTVmhuvg8ErlGDANiyfKpjR3u5p23NXh3so1LPTR7xLVvFrlRikrSspcbVBLpFIPFplrtxHogkMLB6BmW1+91KeVHmKRmDIBUEkX+mVeSAFUEpCqXauBCdu8qca4HGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897784; c=relaxed/simple;
	bh=3t3JhBqwsUniiYPwfPjuNoMmoS8+rDgD/SutkzOPmQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkkZPUSJf2CAnnfetc+HLwp5IDF8H67IbxosZ3wtgaGFpnS/JjYXmJj1gyD4OIw15di1HDeUSoF+HXg2CdSymyE8ImfSyz5tMPhs/T9O4WWmNEQjrEct9AOh5U5+/VaxCsDn7qr0AhqS1ZVc8WgvafxIysUlSajSXeAYwPe1pHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=meDzAHuj; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so2010495a91.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897781; x=1711502581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e10G5Hj/0YjRZ1wjbOIQLq1rOF/sLBwi2jZonL4N32Y=;
        b=meDzAHuj8rZkNqLjtKvMBMRBXJ7eAr2IuIKptRpoTHloGPqzEvQJiMonje09TV+veQ
         FYPi4kPuoabHXOPB4zBrzR3FHDjrv/ayGQzxhVwI7EOko2A5IS/bmCY1i0bs8KMgyRj2
         VCJiWLo+29rUT84nQX8mpPTs4xfLzW12UBsYxFchx5aCX77EaHZsGC5cd+TNDipjjVYa
         ViFweTy6YlwLyota/SqgIIiYqVyHpaCfBGNGdYZUa04fCoxf0F5fbcDLVaRqXuuDYqjn
         2O6qwIZ+AoMM7XyAjyRF63WAX6H8mxkJT5nNTvrBOFtoOiyXOberRjBk+QWr0dgzkZb7
         WP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897781; x=1711502581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e10G5Hj/0YjRZ1wjbOIQLq1rOF/sLBwi2jZonL4N32Y=;
        b=u31v+VLUqGO2/z9O+8s90bMYOIIAtRk99+CUEGRSY1KM14OhTgqYfAK0oYiHiBrovQ
         pBQhZD8auwsETxorKWiupTX/mQsnhgdMTDU5C5IRRM9hj7HwXjlzcf70c7y062n7ROQE
         GFNTv5suh+s6AgMpZnGEjrNYdxWempPZrUfVvk1NEJrGmjgDCNriqcyi3ksh9UC3D/NX
         pvLoNOjE1NsZW+2SnIk976CIFQcF9F+Wmmccln8Z9vjerDR0ZiUBiLzfL44AfucP48+D
         5xXesP0VxTXnoTwBkEUcyW/tI6dilMx6m50/S34UX35PHtqIvD4+7zliQJV6rauprRUm
         /jlg==
X-Gm-Message-State: AOJu0YyNOqeQjCYgWWNwVLx+S9FaO+K9lcxs71mREIk738eoADLiA4ye
	/vnuFd83Prm31UrGe6jeCrg9BJfB25LoIotvsJCnJ80ahWQ70rFJnmdCrRoL/xMyhSi3uQtPMFT
	4
X-Google-Smtp-Source: AGHT+IGAQi/8nmIjvauLwK271B0tDlm+Z89ao4GPvs2Ay+RXYaZ9dDScACS/5Yhziz997XdRNePcEA==
X-Received: by 2002:a05:6a00:731c:b0:6e7:7e2a:839e with SMTP id lq28-20020a056a00731c00b006e77e2a839emr1929153pfb.2.1710897781592;
        Tue, 19 Mar 2024 18:23:01 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:22:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/15] io_uring/net: unify cleanup handling
Date: Tue, 19 Mar 2024 19:17:31 -0600
Message-ID: <20240320012251.1120361-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that recv/recvmsg both do the same cleanup, put it in the retry and
finish handlers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index ff22f6cc859e..2389bb1cc050 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -690,10 +690,16 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req)
+static inline void io_recv_prep_retry(struct io_kiocb *req,
+				      struct io_async_msghdr *kmsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	if (kmsg->free_iov) {
+		kfree(kmsg->free_iov);
+		kmsg->free_iov = NULL;
+	}
+
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
@@ -725,7 +731,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req);
+		io_recv_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
@@ -734,10 +740,9 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
 		}
-		if (issue_flags & IO_URING_F_MULTISHOT)
+		*ret = io_setup_async_msg(req, kmsg, issue_flags);
+		if (*ret == -EAGAIN && issue_flags & IO_URING_F_MULTISHOT)
 			*ret = mshot_retry_ret;
-		else
-			*ret = -EAGAIN;
 		return true;
 	}
 
@@ -748,6 +753,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	return true;
 }
 
@@ -931,11 +937,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	if (mshot_finished)
-		io_req_msg_cleanup(req, kmsg, issue_flags);
-	else if (ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg, issue_flags);
-
 	return ret;
 }
 
@@ -1037,11 +1038,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
 		goto retry_multishot;
 
-	if (ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg, issue_flags);
-	else if (ret != IOU_OK && ret != IOU_STOP_MULTISHOT)
-		io_req_msg_cleanup(req, kmsg, issue_flags);
-
 	return ret;
 }
 
-- 
2.43.0


