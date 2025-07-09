Return-Path: <io-uring+bounces-8638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04302AFF315
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 22:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46C185A84B2
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 20:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD7F243378;
	Wed,  9 Jul 2025 20:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uz1fpJ/3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154F021ADA2
	for <io-uring@vger.kernel.org>; Wed,  9 Jul 2025 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752093272; cv=none; b=YVdFI2iRU5gjTjVgB8P1tC30MKYvzftFp4SibmYnpkLmBiNWmuk/jZBrpFLvTsaVWaSxjRZbqv4So8bEWSH+YtBVCXayvWfgWl/fP7RpUMMezA8La01a07x1Go1X6no9faxCHfKJi/Ha+so0QnFrRas4o+VUneLVN2lhL8W6cio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752093272; c=relaxed/simple;
	bh=6h/dlGWTEZZ3y997x0pPpJcAnIG01aVk7y4qD2Dbk+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq7WXCj70hUyNght53tvkD/Syy4vTKkHBMLb7bM14VB0+TiA9QY8HAXXpbayBaYofmKlmUoV5y9Hiq/QMLG0T5ythW0wzcADP+mFsdSeQApYEBwnY7V7F5izR3p8y3lxnC9rsrwBd7vanzJHnFPoYcvOcKcQxKZqcYCeBEeOZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uz1fpJ/3; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3dda399db09so2456665ab.3
        for <io-uring@vger.kernel.org>; Wed, 09 Jul 2025 13:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752093268; x=1752698068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNy0JEnDx3Kunb8w/ZZGFvDhfE4ugz6j5icXdA8KK80=;
        b=Uz1fpJ/3ZXftg/RWzbkmpUL60VAvdUNzsjJc31e6jM59cIWHUW/yaafL+4ihEVTShH
         BHtTX3UUXnhh4mMiH7ilN97MO2FmXYw7pd582sF+Wwj0SbRQx32mefNz6XFhylfVuSYF
         4l1llYy03hAwA71POUGfp4ORAMr0CVFWZNcxHap7CGeAhbK/StjHNSc9pWm6umnaD+fm
         9udkwBTfBQWUjuvJteUOARlLzDAiCFnh53f5t/xuvR7IIiIi+epKBifouzJIFYyUES9P
         SbkPhWbgfbgCJ+HoB1l36Vre3EwFSwlOv9Y8w+gzlKG/ikr9ZX7fh4lF2eRR1RmSPrf2
         wn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752093268; x=1752698068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNy0JEnDx3Kunb8w/ZZGFvDhfE4ugz6j5icXdA8KK80=;
        b=llo3spHbggDKLBj6dPEyjUY9hvsMcQ3oxB/kD10BHTMQVR2vG/BAc7GFDUasx4bt5U
         0Vur81dhHoNl3wFpi3EBz8gBo7sfshZLcPjzj42Lc5WRE+vU4RKYg8tpBhb0U8MAtGLq
         qnWbgOjNRBJxK8hGaA9JEw1vyW7kHG8EqwIPjtMuGDlUPrrO4h8Qem9CAkJxMSgH6+49
         10an/I1B8zMR6wqqiQfB5DOQh4tVV6QG+EfPkbbDDFGgaXu/ol7rmLw4VUYuoaVpEsFj
         YBFykKwvF31inZV/vaDJiAIGkuKxKGH3equfU5k2JctvQapYX5PZ5ohi/EO+48yefOIz
         SDZQ==
X-Gm-Message-State: AOJu0Yy/SWBQItltF6s9pPvIhb4lScT7qW7mv+4dEI8kMW/vz7sQsdzw
	aknHt3Tmpu6QJaFEufjYeWwlY5TLC1kiM7oBloURVbLvPBbgfFRIha+Naa0ySb73oxAkQqAVIHU
	vFZfk
X-Gm-Gg: ASbGncsa6z/E/C9xlAh5rLeqBKuVb91hoVQMkD1SKbm5Ab35WsCqCuETBQShmAajQOc
	7AmMYSeVNkgb8BxiScPvwY2l2vzV2aEwDR/5sG/LVeGM0XyQ8ayRNxc5XGIasFA3QUGX/h5N85f
	0qmau7C3hAnuiPjDrRXiFAhJGRegK5IHdbjwxdUbN5Hb8dpenXgGkb5XGsIQ8sSpda7nJKLAoBG
	gHFKJpvu2XJ1/t8aNjxK0jDStrHd54TZx+RsW/KsT1TL55Q6C75V1poede+jBdh7x2wRQzEOIn8
	s3wkIudojLsp0vg0lqQny5ngZHK1XIUNND33XxX7p8hR
X-Google-Smtp-Source: AGHT+IGCUMm4Gul/S6MKPDYOEyRqqQOm19ukcC2VoT5F/CVDYJjJulL4Le0Hfto0ZbwEPKJ8ApQy2Q==
X-Received: by 2002:a05:6e02:17cb:b0:3dd:be49:9278 with SMTP id e9e14a558f8ab-3e166f331c6mr37405395ab.0.1752093268269;
        Wed, 09 Jul 2025 13:34:28 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246229f5fsm125965ab.50.2025.07.09.13.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 13:34:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: allow multishot receive per-invocation cap
Date: Wed,  9 Jul 2025 14:32:42 -0600
Message-ID: <20250709203420.1321689-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250709203420.1321689-1-axboe@kernel.dk>
References: <20250709203420.1321689-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an application is handling multiple receive streams using recv
multishot, then the amount of retries and buffer peeking for multishot
and bundles can process too much per socket before moving on. This isn't
directly controllable by the application. By default, io_uring will
retry a recv MULTISHOT_MAX_RETRY (32) times, if the socket keeps having
data to receive. And if using bundles, then each bundle peek will
potentially map up to PEEK_MAX_IMPORT (256) iovecs of data. Once these
limits are hit, then a requeue operation will be done, where the request
will get retried after other pending requests have had a time to get
executed.

Add support for capping the per-invocation receive length, before a
requeue condition is considered for each receive. This is done by setting
sqe->mshot_len to the byte value. For example, if this is set to 1024,
then each receive will be requeued by 1024 bytes received.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 144788bea009..c0a5bd358bd0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,6 +75,7 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
+	unsigned			mshot_len;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -87,9 +88,11 @@ struct io_sr_msg {
 enum sr_retry_flags {
 	IORING_RECV_RETRY	= (1U << 15),
 	IORING_RECV_PARTIAL_MAP	= (1U << 14),
+	IORING_RECV_MSHOT_CAP	= (1U << 13),
 
 	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
-	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
+	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP |
+				  IORING_RECV_MSHOT_CAP,
 };
 
 /*
@@ -199,7 +202,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->flags &= ~IORING_RECV_RETRY_CLEAR;
-	sr->len = 0; /* get from the provided buffer */
+	sr->len = sr->mshot_len;
 }
 
 static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg,
@@ -787,13 +790,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
+	sr->mshot_len = 0;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
 			return -EINVAL;
-		if (req->opcode == IORING_OP_RECV && sr->len)
-			return -EINVAL;
+		if (req->opcode == IORING_OP_RECV)
+			sr->mshot_len = sr->len;
 		req->flags |= REQ_F_APOLL_MULTISHOT;
 	}
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
@@ -834,6 +838,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				      issue_flags);
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
+		if (sr->mshot_len && *ret >= sr->mshot_len)
+			sr->flags |= IORING_RECV_MSHOT_CAP;
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
@@ -864,10 +870,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
-			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
+			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY &&
+			    !(sr->flags & IORING_RECV_MSHOT_CAP)) {
 				return false;
+			}
 			/* mshot retries exceeded, force a requeue */
 			sr->nr_multishot_loops = 0;
+			sr->flags &= ~IORING_RECV_MSHOT_CAP;
 			if (issue_flags & IO_URING_F_MULTISHOT)
 				*ret = IOU_REQUEUE;
 		}
@@ -1080,7 +1089,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 1)
+		if (*len)
+			arg.max_len = *len;
+		else if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(*len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);
-- 
2.50.0


