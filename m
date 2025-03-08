Return-Path: <io-uring+bounces-7038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC72A57CB5
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 19:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C5B316E39C
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA441BEF74;
	Sat,  8 Mar 2025 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7eyDo4h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5121E833E
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741458039; cv=none; b=EnrseA3dgGPzIwapyrMGwK8ze65N3pe/rliHX8kgDvSBDNK51+ZzXWz9NTNbBqr3EBrNt/Sny8Z2hzZeOZWk/PCPKRoo8SiMzDWbR0DiqCz192Gw684cuNOPQ93xO1+G9AFGP3dznz929MA3WeEeOuxMPO2tYxeQd5JYgt+GELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741458039; c=relaxed/simple;
	bh=eKI4CNfw+Un9JI5NjwS2dF642iBE1NppaO7/zJ4+ODg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZO6yM1KiOgBbrFjl0xvRWUTkwHWhcX/p5cJ1DqhCE4r/JfIJVoYJh04Z8oDLbiEzCxWtAUA1f+OeBmEUhGAIQpynrHVLEiinF3X1g1X7tXYxqqglXhFV0rZP0dKmTPukztdIODYQsPhBA9L0mtFWqs54TwIVz/KsZIgufKa/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7eyDo4h; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-391342fc0b5so2121201f8f.3
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 10:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741458035; x=1742062835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHtI3zjETOX+dxjpVJDV/mP/O/NE7jIdOc9TfcQD+4w=;
        b=U7eyDo4hXUqjvL9EhR9N19YKkp9kMONjRCj4KKvPgjEmdp0FUzvr/ovayEy47Ytedk
         IJQNX/P7i5R3hsqlPS+1/bQKRg2TeMg+xKE7j3qyvHyCSIFjuONdH2j8/5HSrsfmDHgU
         67pwjPQtzYqUnnzLZImNAyPrdS7Az9SpN7bWhUCAK6uRsk8Wna42Pwtl9OL44w7lZYeZ
         n5HTjcRDCQ9PALIVe9x4v7dc/NNbjnrOrv7RSPFhhnGkv3XKyXWrI78srbsHt/AfS8ib
         2JvyZ//B9Aygrs9CTRjdsaqfAIphZnPDUmGLbL4rqV+urOV8OI97lyTBsJxT/PSZJf4E
         dLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741458035; x=1742062835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHtI3zjETOX+dxjpVJDV/mP/O/NE7jIdOc9TfcQD+4w=;
        b=sqhqqUQW/XidtQuV9JgVGGuxLzPuksa236vibbc6sfBnG0CK6p00luCJBggFKJ6//B
         ZUNQcH9QKQIWddA3KwPHH/OdXnreYuPNNU2A3P1ro+zzx+ozoGic1ynuQ9EbxODUURu0
         8ruV2sr0M0Cr4BohmuEvx2EWeBRTEbE5kWPW5dpbJdwed9eTvn1atVMaNyiz6PaGof+x
         C4oKtxlaO4O29+fc9PKzFeSOjtS5ZwW1kZ+ixNbTSCrRaw3d6cKwPAfB8Gj1fj+bf1Z5
         PGyJmabaxQa0OoQ2fTYZ2lYxQf2Bl6+ZLAJ09gf9Wg9fEWUGt9WSFBp8CZZ06elUqp07
         UXEA==
X-Gm-Message-State: AOJu0YwACbKHVAkK4R43OBeFlK1IDGgRsdHz9l1xzLhmW1fy3WqQt9lv
	j6wTrxa1ihfeHPaqV+E9P7x2IQKg8+pAcz2EGffQaAoBZIjd2a4aKdzTLg==
X-Gm-Gg: ASbGnctS4rhYiUmWwpnzOA1Q4/O6ML+QbNXEk1Hqbb6hIS0+3vVwGKqo5lg3qgOa1mW
	aN6CF5b9v537cBKN6sBX/WfSSBglbiQdKl/DrEvLiY+TETPGpK9QqEfDYvOCB4TFTlJRbhSAtse
	wgHiaouo1FGSuRH6yAoCiVy59UOJwfnRnRbUdcWa42dRzWvpAg5nfo5LTObfaC8wKv6iUXJxDK0
	ogq87UGfs9HfboikPWVZ1/7iOFIsDD94qg7CBGUz9UNiOy+Q1ipE3G968gA6fK2rrxRoMfsEuRV
	DtboAr2dEIaU24BiG6YRd4vvVlD3Gp3R/X2xD0v1QuDJK/f7YTQ9Kh1ejg==
X-Google-Smtp-Source: AGHT+IFZzovaKBaS/tCUpZY1zf8kQe4pKuQFeb081e+x7vKxKgbhPfIw1JTLt25OV3T+iDF0fosnhA==
X-Received: by 2002:a05:6000:18a4:b0:390:ffd0:4142 with SMTP id ffacd0b85a97d-39132d5a5d8mr7037526f8f.26.1741458035477;
        Sat, 08 Mar 2025 10:20:35 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c106a1asm9472996f8f.100.2025.03.08.10.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 10:20:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: rely on io_prep_reg_vec for iovec placement
Date: Sat,  8 Mar 2025 18:21:16 +0000
Message-ID: <08ed87ca4bbc06724373b6ce06f36b703fe60c4e.1741457480.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741457480.git.asml.silence@gmail.com>
References: <cover.1741457480.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All vectored reg buffer users should use io_import_reg_vec() for iovec
imports, since iovec placement is the function's responsibility and
callers shouldn't know much about it, drop the offset parameter from
io_prep_reg_vec() and calculate it inside.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c  | 4 +---
 io_uring/rsrc.c | 8 ++++----
 io_uring/rsrc.h | 3 +--
 io_uring/rw.c   | 3 +--
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b8dbadf445f..1e36a72e4008 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1513,12 +1513,10 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
-		unsigned iovec_off = kmsg->vec.nr - uvec_segs;
 		int ret;
 
 		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter, req,
-					&kmsg->vec, uvec_segs, iovec_off,
-					issue_flags);
+					&kmsg->vec, uvec_segs, issue_flags);
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter = io_sg_from_iter;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0e413e910f3d..607b09bd8374 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1349,11 +1349,11 @@ static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
 
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned iovec_off,
-			unsigned issue_flags)
+			unsigned nr_iovs, unsigned issue_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
+	unsigned iovec_off;
 	struct iovec *iov;
 	unsigned nr_segs;
 
@@ -1366,6 +1366,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
 
+	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 	nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
 
@@ -1377,8 +1378,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		nr_segs += nr_iovs;
 	}
 
-	if (WARN_ON_ONCE(iovec_off + nr_iovs != vec->nr) ||
-	    nr_segs > vec->nr) {
+	if (nr_segs > vec->nr) {
 		struct iou_vec tmp_vec = {};
 		int ret;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 43f784915573..b52242852ff3 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,8 +65,7 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			unsigned issue_flags);
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned iovec_off,
-			unsigned issue_flags);
+			unsigned nr_iovs, unsigned issue_flags);
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4861b876f48e..246b22225919 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -390,11 +390,10 @@ static int io_rw_import_reg_vec(struct io_kiocb *req,
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned uvec_segs = rw->len;
-	unsigned iovec_off = io->vec.nr - uvec_segs;
 	int ret;
 
 	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
-				uvec_segs, iovec_off, issue_flags);
+				uvec_segs, issue_flags);
 	if (unlikely(ret))
 		return ret;
 	iov_iter_save_state(&io->iter, &io->iter_state);
-- 
2.48.1


