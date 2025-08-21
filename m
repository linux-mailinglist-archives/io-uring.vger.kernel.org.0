Return-Path: <io-uring+bounces-9136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 298FCB2EB1A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7004A248DB
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032052D8DD1;
	Thu, 21 Aug 2025 02:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BjphlLEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B482D8781
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742113; cv=none; b=iXdn0YBejwnPpHi0nGu/nGyfRtZNAkPNW3yfoc9yFMAKQfEVfOzTNpSTcjFx7zyxXgkXPS+Ldg+C7YcL9PXcMzAh4YboHq6Do6GQtLBj3wy0bkuOG7gIQQ6DCqHa5YoiVQmWJWYnskUcPAdIr2I6sJMM3BNZxwEhY4u7iuP7XT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742113; c=relaxed/simple;
	bh=e8023kmzGEll9DAOZ+l1i+GuGS7FlBsqZvu7RaYkM4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxHDiQwJR3M+Th47DUAM6GW8qHa89siRX4hzhpdZ1rkuTpdo6xMKrYLWKbAGiv0zxOj60TDtslZJGUtAuSgkMaAYeLzuXJ1iw/xDGTpj1EzCvyoZVKqxOvy2rwaiKCX1zzpZCPXijP7b0sKGZDx6hzvbDu22/nYf0e8E/2I1e4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BjphlLEW; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-244581cc971so6082855ad.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742109; x=1756346909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWjraEvlSdt2slKt6iFUjY/OgcsITqmRT2JXDLANG9M=;
        b=BjphlLEWSMMOtvo4bNBFnO1knrhilvO93eV5mswZCPluG54j4jtwnI7O1UVRgnRFHd
         MwY8GDpkpHwVBQ1YTHjOd6Un5vD9/xWL25acnz8+XL1qPeqVIy7Lw7LoesKnoarzw26e
         kdMZfbIFhumGQi+oibOE3FUR95JeN6ZSG7ZDw+O4M1L4FjiasDFd8XURzo6CmsCwSaHU
         xOk7e8DUsO8PgIPzjlLYrLIScATrjIXC02/b8xMvee7Xt1z1uWZML8yH2JfEr7i7088y
         i7SaR5OcOavzw9qa7huA25MW335q5OGz4yEzKBpOdHY+WP0MVtLk/Oy/NPO+QcLIb9a3
         yXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742109; x=1756346909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWjraEvlSdt2slKt6iFUjY/OgcsITqmRT2JXDLANG9M=;
        b=mf5kpaxS0tjoQrhR1XoT7+IBknGbFb3O0uCjrl35dmILlXP2ciYoxcl/DTdDzdZPne
         EdLQXWvwbXQF1Ogv2TnepH2DjalA1w3VCYPBO3AcnSFr5RiH2XNvUvzkfxjxaudG9gLc
         TK1Xy3Ml7ZDnP+kLShoQqp+32cmaF9XnXs0aIBEWltf11N1vdo1p8j1njCwkAqcNR3XN
         0DY/U0/U2xeHd3+hBI0baOHhWvp97Azd1wajQXaVOdnFxcFtKKkLGePYqu4/eR3bcMVH
         tFOX3nIoiXl0kHNbvrSzvZrXxlAyT73n98Rz6TeLdn5Zj8JrO+nP/Oi0A9u6mECvNW0U
         qGLw==
X-Gm-Message-State: AOJu0Yxf1j6jzJronYFSp9qawLLXogVGtxyvcXNAwpdxvYoq0vfQ8JH/
	UNPGMm/Xn24YFPrMVjIDOPMOJLx4zpkiRZesoRiFInw3Ia2bRzmqNHKuj6vrxlVIIPkxuscOOUI
	2kTpf
X-Gm-Gg: ASbGncsbhZJVH/62kdCvvW+cJJ+iLQpOe6aKktbZTDS9vjHoX7YF4H5RyT8sxBcYhmf
	j65FQUS7swgpn52zT/mk2AdkSadLVD0yAjCRAejAmPglO/vAEoRUMJ1gfLiJu8svmuy24Xzn4sO
	LiYIytvZmQ0ZUO3SJODRPiCxb+PKc4gqarMJZU8HmzGABy19EC4i7K5PJYOjYbx9qurQNE7sU/o
	d93U+fj8i1p97u0slkmelKLNQVXHVQxpVtlhFmNAZkhTbfZJMvWYrQGOULtXKsLoJRl/TQNo0aO
	ra5LZ2oGnEamHc8r9MZePlLZSeML5TiRBZFRIiDMO1ICmKlyJYmHJrnoAgOYaE67dFXGiIn2ABZ
	kAjamA8BrtRRRbt3V0Q==
X-Google-Smtp-Source: AGHT+IEBl2ppsuXzesFpi6BhZFV9z1bmpwNsoXfHCZfRdyU4hFblT6wGu9Mh26F8BFXA1TMsRVEVCQ==
X-Received: by 2002:a17:903:acf:b0:242:9be2:f67a with SMTP id d9443c01a7336-245febd55d0mr14717435ad.11.1755742109459;
        Wed, 20 Aug 2025 19:08:29 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/12] io_uring/kbuf: drop 'issue_flags' from io_put_kbuf(s)() arguments
Date: Wed, 20 Aug 2025 20:03:30 -0600
Message-ID: <20250821020750.598432-3-axboe@kernel.dk>
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

Picking multiple buffers always requires the ring lock to be held across
the operation, so there's no need to pass in the issue_flags to
io_put_kbufs(). On the single buffer side, if the initial picking of a
ring buffer was unlocked, then it will have been committed already. For
legacy buffers, no locking is required, as they will simply be freed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  2 +-
 io_uring/kbuf.h     |  5 ++---
 io_uring/net.c      | 14 ++++++--------
 io_uring/rw.c       | 10 +++++-----
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 402363725a66..379ad0d1239e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1007,7 +1007,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res, IO_URING_F_UNLOCKED));
+	io_req_set_res(req, res, io_put_kbuf(req, res));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 723d0361898e..3d01778f378b 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,8 +121,7 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
-				       unsigned issue_flags)
+static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
@@ -130,7 +129,7 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
-					int nbufs, unsigned issue_flags)
+					int nbufs)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
diff --git a/io_uring/net.c b/io_uring/net.c
index d69f2afa4f7a..3da253b80332 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -504,19 +504,18 @@ static int io_net_kbuf_recyle(struct io_kiocb *req,
 }
 
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
-				  struct io_async_msghdr *kmsg,
-				  unsigned issue_flags)
+				  struct io_async_msghdr *kmsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	bool bundle_finished = *ret <= 0;
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, issue_flags);
+		cflags = io_put_kbuf(req, *ret);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret));
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -693,7 +692,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	if (!io_send_finish(req, &ret, kmsg, issue_flags))
+	if (!io_send_finish(req, &ret, kmsg))
 		goto retry_bundle;
 
 	io_req_msg_cleanup(req, issue_flags);
@@ -872,8 +871,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
-				      issue_flags);
+		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && *ret >= sr->mshot_len)
@@ -895,7 +893,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, issue_flags);
+		cflags |= io_put_kbuf(req, *ret);
 	}
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 52a5b950b2e5..ae5229ae7dca 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -576,7 +576,7 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, tw);
@@ -659,7 +659,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		 * from the submission path.
 		 */
 		io_req_io_end(req);
-		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, issue_flags));
+		io_req_set_res(req, final_ret, io_put_kbuf(req, ret));
 		io_req_rw_cleanup(req, issue_flags);
 		return IOU_COMPLETE;
 	} else {
@@ -1057,7 +1057,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret < 0)
 			req_set_fail(req);
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -1065,7 +1065,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1362,7 +1362,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.50.1


