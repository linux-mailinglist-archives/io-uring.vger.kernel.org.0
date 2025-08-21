Return-Path: <io-uring+bounces-9143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E44CB2EB19
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B2AB56762E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B448F2D8781;
	Thu, 21 Aug 2025 02:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pt6rdjf6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA302D8DB9
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742125; cv=none; b=hY2xfPhXgdbTMDI/8YzeJmjTDnm1prnqWPsJ/pvZJnlyN95rwsFQZjGhOeyIcPtCp8OPibWgz3VG54RUQldzmgPFQFufF3QclQxPQv9Qot945mGdHQWsfoEPbWQBZzmAw7FAlWRkmjyEf+WKbGPBYgQIDDvQBTDT+Hnd2rUFnEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742125; c=relaxed/simple;
	bh=WDzC+PKUhIjy5C6yKysYJQ90ESMgyT8CGQAKQ+w7FEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB8zbCIVKy6dDLX95yvu/MQ3gHVG1GEi5AJ06Wca7uYVH9gwtQW0DOLGEwZLEi53YwI9NFIq9sxJCcC15Mrt/CRGkD4y5b8lM461c5WCrn4vUTOZXAfrXwrpFhUzM8233qiPfPiY7g2f3tv/q72ZSQoU675eR6QzvGwnHcfMeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pt6rdjf6; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32326e202e0so498739a91.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742122; x=1756346922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNkZ3lSl2PmCv9MLZ0OpZQg2wM6gbHDHaES/hVzUQRc=;
        b=Pt6rdjf67plkzCKjTJpm7wT0drxJzhMLCoZ/UkznEVj2pB6GqImgghPe8VE6oAl1GX
         pUSVGD/XeF8ThHsUsUIeQagBJSBuUKtZl9yrU41qXdkqfKF6sBFPRYgp2flhjTpLQrFq
         Py5Ch5gfYRoc5YhOJhUdmqbwEEdxeDOEAhD3kHfEgrQ14dEe2fb+6uynRd1VqvK7mDYo
         hQf6NB+uKy4CTd6qV7B3XBrOzVslKLcA3OMFaT9WlYWHnOOwBP94x/XobGcS3OeUyu/D
         bsgTUG5mTwPV7IV3fs55qO8+064gkD31bJLmAISMHSkRxI4zHhux3wEn0uLOSbCMyOsa
         6r0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742122; x=1756346922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNkZ3lSl2PmCv9MLZ0OpZQg2wM6gbHDHaES/hVzUQRc=;
        b=qMmU3rP8Cm2AwIzNHIUFnltimSJZMlp3SdBWEd76qtuiUqyyMLOfReCZGxvuZRGE2p
         P6ojHR9tk8iJRMq4q7b245Qhpyfb6NFukQju9WC3rghCBBV5vTLXkkP2GDf5dUE1cqWO
         bvylMS02p9xUD22JlRpZPqeGWeFTTEXOaMHWgSMooMNTpvnltxkcntsWlGpUkA4fKEb6
         7z8zA86hdBSfpLEZogyU/0SPM2LGg2jgzaRke074BVvPMCehURy4zVYDlG122JzSCWYQ
         tdOXoZx9IFQQvG7oTbIShV1DxUXW9aN6fEMyeDm+DpUhTygmobgmPzH8eiHBOdcry7DG
         XZVg==
X-Gm-Message-State: AOJu0Ywl9fG9lt6eOTPWeB+Ur4hyLd4AC1wF+TU9y4wTVI8LBsTSQ4Xv
	lestQqCahEyONOI/GnUWHkFQIjGw9a16LXCM4HrxnNzuZQqLoOP6wV4lKAPTPjgfBQcja8GhoPB
	K6OJO
X-Gm-Gg: ASbGncs8c7Frgro3rQGID8R1WtVu8OPiNK2EPLi2t1sbqghdbNiGOdbMgzUQMIOjuYk
	n03fWJbKnzcmGAsOylCT9zl8qP2brjV+3496rwZeokNnAErmQ1QUUUJpiXqdqhPfK5S1H9LWdwi
	wcCIewWoMtO6426IOrRKpLpDiocP+3gB3jBvethRToqSZWuyAGQ326K4h8tJ3l6qrbbFVKycfDP
	9HpU9upk1FCQdZCN9z1jQAP2l5ZVWDWcz0UKw9BP53taCda87j7chSySr0Yo2Hgmp4sipBpRqrA
	WrcmbwLkrThJEq2PbHVKBYuRFIRomjPHoLVofdSSq9/O0IvLC4NAmc164GmAbV6xOeC55Jgnv5u
	txusTusPWm4jqidV+O+OvFSMgOZdr
X-Google-Smtp-Source: AGHT+IHnGw0KsnimMlY+Du0NJmgy2bL6ehrQxM6EKoE5B7BM5O6AUEKarz+SqXx6DgakTC+n8o89aA==
X-Received: by 2002:a17:90b:1651:b0:313:2206:adf1 with SMTP id 98e67ed59e1d1-324ed05978cmr1084060a91.4.1755742122437;
        Wed, 20 Aug 2025 19:08:42 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/12] io_uring/net: use struct io_br_sel->val as the recv finish value
Date: Wed, 20 Aug 2025 20:03:37 -0600
Message-ID: <20250821020750.598432-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
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
index 8cff6a8244c0..a7a4443e3ee7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -845,9 +845,10 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -855,13 +856,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
@@ -869,12 +870,12 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		size_t this_ret = *ret - sr->done_io;
+		size_t this_ret = sel->val - sr->done_io;
 
 		cflags |= io_put_kbufs(req, this_ret, req->buf_list, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
-		if (sr->mshot_len && *ret >= sr->mshot_len)
+		if (sr->mshot_len && sel->val >= sr->mshot_len)
 			sr->flags |= IORING_RECV_MSHOT_CAP;
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -893,7 +894,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, req->buf_list);
+		cflags |= io_put_kbuf(req, sel->val, req->buf_list);
 	}
 
 	/*
@@ -901,8 +902,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
@@ -914,15 +915,15 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
@@ -1092,10 +1093,11 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1240,10 +1242,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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


