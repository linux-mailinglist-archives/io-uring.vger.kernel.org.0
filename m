Return-Path: <io-uring+bounces-9120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BF7B2E4E0
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D66C47A6DAE
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC01C3EA8D;
	Wed, 20 Aug 2025 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zoyauW0h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E208279794
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714380; cv=none; b=vDu2Nug3clxPIyGmhpeYbg3d+LrscaefhPtetRyYDazg/j3dSafEsAZR1gXZ0tCvP1Oby32qcBngSAunvN+2QaNGwgPkyk0sfpLOKBImmVNcV6e70oaPDDA47lP/zfedI83I7bDnP+hx2DR0GltT9gPxlgWe09uZQRIfy6pfq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714380; c=relaxed/simple;
	bh=k9zC8jCqGiOZTDNqnjg5GYEkWYy90Ky7FoJ5NsolfTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCFagzypGFveTF/mUV5g6JgohLNA9+kv6r8UUsyh7kQiZFp5/zxFKgPeNEMXdg6b8xwP2hacvCh3dgDQsoIX5pyUE+wWcnMeRJ+Dt0g37mEggny2Pn0N2kdr+wskHREctNc1E3wt1M2z71oTt0m4paE7XZs1mjO8FivsFYhSTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zoyauW0h; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-61bf1542ecbso495619eaf.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714377; x=1756319177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M40n/BUfkgRBa5XF6Y5Y0IByYdInq+GhZJgiFClyFN0=;
        b=zoyauW0h4YkpgjYvxjZaYllIey2Db0ur94qaFEdB6S10vhBAUwY72YYS2Lu7jmkp17
         U8wmO4F6kKgryBF5FbwLvpGjKziLs0eE0uKT4oS3ZKlXSpfdEhAW81X9gxKC1rKP3uNs
         9Z0ssSJ9ByE9aPTgF89BF3ik5xA4d1efPQNL9vTuX5KraLHYmcQhYy768QyyelHCCwCG
         PF9XB+pgQmY8Z8EeyBuV43UBIr8L9cl57PO5ngv3Ag3Bh6lEvSk1THJ7MYWyBMNa9iHm
         X3Jn6/br8hl6rH7WMtgrpp92TP3ytcociagMKwhNHICvNGv8t4gBqT2xvcHnt6FzQuCT
         R3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714377; x=1756319177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M40n/BUfkgRBa5XF6Y5Y0IByYdInq+GhZJgiFClyFN0=;
        b=lf+lXpjWq/Jdp2f5TUTvj4TzwL7XtpVs0Db43jy840gD7O35bo4o5oxYjPEyP673L4
         6mRUju2pxc54sSh8VGJRsQMfCeija2fg538QDnBnAMpEAm7zoByXCGbEgf3yo2djZfVp
         WlN1Xcm3FJLCYivdSkFKuZZfgFPwd9yjAJ4Nv/l6gMSxVY2n93gSPfZxtdD4p9oyczsD
         kNjSmKrlJ3BZFhYb/dAtkixUS5mK4CQxrwRuSl0v9+7XD0V9L3Q0MYkEpMmMR0wkgA8A
         pKiAfRRtpAtwt8zZIjeAJq9HUr8DP4J38INMwwiCyUVN949sctYvRuy5+8UckM1g+k2i
         6JbA==
X-Gm-Message-State: AOJu0YzP9VIIZPolDbYFI1BsIYCmwMj5MXDY66Pxu66iMveuSOex18+E
	NgUGyUxCygoZjKPSdivLG7ik1enA9bLctgbmAUixTwlXp8EsNP5wDHz+fD1UTN3AnJK/cLa2Yaq
	OgRAx
X-Gm-Gg: ASbGncupjfm158e6FTyispuw2MAGt3nkrSnGp0slZ8T85D8uwt4dNmXQ8bzTz3oEYqq
	9tvzgG+z39Ugrw75nsPEFnATHZLfqQqx3Mc4gjSFJniOLIurXaYMvKpYGSWiRQfW7hUgZ7zSgyp
	YemBfn+unZxPWQD4JHg7U1hbZvZG33m5D//LltoWROZHJGyvDFvg24LTuVRmS/4sLk3S18XeA0f
	tlywd2MNxcFhXUVX2zWt5IhVXUt8GL8oXuneU2o1uhxpEtxZmoGsq/F3XPelpDVGZ9sSU5apROs
	9W0+bak43M35iCW04MWCmqR+sL+O2FKA+UWM1vbgn19G2PBGfOP+ZKvdNWGTBioUlaN4nKzGl8t
	X7Qs2KbK19kTObfqc
X-Google-Smtp-Source: AGHT+IGQa1ASyhNE7VXhNACBDoq4Oh/Ci6xlrzXWSdPzIuX+kM/H7KlAudBWFBv591dOWKjQc6IE6g==
X-Received: by 2002:a05:6808:1a1d:b0:433:fabb:9b19 with SMTP id 5614622812f47-4377af2a73fmr283285b6e.3.1755714377285;
        Wed, 20 Aug 2025 11:26:17 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/net: use struct io_br_sel->val as the recv finish value
Date: Wed, 20 Aug 2025 12:22:53 -0600
Message-ID: <20250820182601.442933-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently a pointer is passed in to the 'ret' in the receive handlers,
but since we already have a value field in io_br_sel, just use that.
This is also in preparation for needing to pass in struct io_br_sel
to io_recv_finish() anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d777a04ff201..432235f27587 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -846,9 +846,10 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  * Returns true if it is actually finished, or false if it should run
  * again (for multishot).
  */
-static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
+static inline bool io_recv_finish(struct io_kiocb *req,
 				  struct io_async_msghdr *kmsg,
-				  bool mshot_finished, unsigned issue_flags)
+				  struct io_br_sel *sel, bool mshot_finished,
+				  unsigned issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags = 0;
@@ -856,13 +857,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (kmsg->msg.msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (*ret > 0 && sr->flags & IORING_RECV_MSHOT_LIM) {
+	if (sel->val > 0 && sr->flags & IORING_RECV_MSHOT_LIM) {
 		/*
 		 * If sr->len hits zero, the limit has been reached. Mark
 		 * mshot as finished, and flag MSHOT_DONE as well to prevent
 		 * a potential bundle from being retried.
 		 */
-		sr->mshot_total_len -= min_t(int, *ret, sr->mshot_total_len);
+		sr->mshot_total_len -= min_t(int, sel->val, sr->mshot_total_len);
 		if (!sr->mshot_total_len) {
 			sr->flags |= IORING_RECV_MSHOT_DONE;
 			mshot_finished = true;
@@ -870,13 +871,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		size_t this_ret = *ret - sr->done_io;
+		size_t this_ret = sel->val - sr->done_io;
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      req->buf_list, issue_flags);
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
-		if (sr->mshot_len && *ret >= sr->mshot_len)
+		if (sr->mshot_len && sel->val >= sr->mshot_len)
 			sr->flags |= IORING_RECV_MSHOT_CAP;
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -895,7 +896,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, req->buf_list, issue_flags);
+		cflags |= io_put_kbuf(req, sel->val, req->buf_list, issue_flags);
 	}
 
 	/*
@@ -903,8 +904,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	 * receive from this socket.
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
-	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
-		*ret = IOU_RETRY;
+	    io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE)) {
+		sel->val = IOU_RETRY;
 		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
@@ -916,15 +917,15 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			sr->flags &= ~IORING_RECV_MSHOT_CAP;
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				*ret = IOU_REQUEUE;
+				sel->val = IOU_REQUEUE;
 		}
 		return true;
 	}
 
 	/* Finish the request / stop multishot. */
 finish:
-	io_req_set_res(req, *ret, cflags);
-	*ret = IOU_COMPLETE;
+	io_req_set_res(req, sel->val, cflags);
+	sel->val = IOU_COMPLETE;
 	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
@@ -1094,10 +1095,11 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
+	sel.val = ret;
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	return ret;
+	return sel.val;
 }
 
 static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
@@ -1242,10 +1244,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
+	sel.val = ret;
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	return ret;
+	return sel.val;
 }
 
 int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.50.1


