Return-Path: <io-uring+bounces-6666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7EC2A41F7C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A2BB16C201
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D414523BD1B;
	Mon, 24 Feb 2025 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PHk8hAx2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A45223BD03
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400900; cv=none; b=qj3jVoHC/rD8R8+IB9tx2/holmZj9B3cDkq++HvFJlEbLP5+eZ15+eP5Jp4rDLYB4oYngwvxxCLu3/l01tWgUQFGzkszaqOLjbZpgFpVLIP1Xt4y55Fuv+4KdIpRtQmHFhLFTIYBapmn4yxJqxN1/VbHNPsk056x1tyd0FO7Be8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400900; c=relaxed/simple;
	bh=oVCREMHKNF3VZ4lqmQYHZWqPemM+41W2yecYx/7O4+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeYQanMNBVWJh9tNzGjPTjsl0lTaOePd8fm990c3yesS2ufgtWR0mJVS0dia5xbtToduf2HF37vFyVR/IXGukq2iyzUESDWLQPXXQl4JWSEDqYiq5kyiSiC2Iz5v65WbQCOt62duwWnhln71q04OmSGc35UZ5G4+c8i2cSf78Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PHk8hAx2; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e058ca6806so7931000a12.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400897; x=1741005697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mU08h0wsEkVVxTM0lrp99OqQ0vO1MRMeRbUk8WqQxRE=;
        b=PHk8hAx2BipczMtel5+vOyM4ucu/OO6jEPOIbCHYXx2IN4G6VjP/lICu+o1n5tEVwZ
         F5VTIVDLTSUULPZ0Cp93Iv3yZn6b2UpnXHRzqTecYAOCQ0/CQTyn6X/TXmTndXMyyKvr
         v/MIklCAN1Lwf4exypOZtGqBfc06ct/eJNGRcX08bS4uNBQT0lDcNRk8/Yg5/wPVn0lO
         s4GAfWNjM5eoYI5RRfs62VruVeBDTM6k+t3HQ6lH1JXfsKU2UVHVe3BTXE7M57xANMe0
         vFBqmeklLiC9u6ep/d8a+nmtiVxXn6go3McK71tqu31HMfL36NZ+xd51ycGMXfx5TSUc
         2k6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400897; x=1741005697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mU08h0wsEkVVxTM0lrp99OqQ0vO1MRMeRbUk8WqQxRE=;
        b=VQN2YZD/rWVLjmNHYmK6q0cLcXy24nITwcKrf9APY75hFupD4eQhIkdr19ptWqNU/w
         HvOVVF+Lfyw6jOhsrKP8df6BcfKjK1Ik1ufE2q0LOrp+HoMwHDgMQDGgfBY9uyXAG3J8
         KMDsHDW0AMPL5Glrd7g85ZBpdHitFf73CebQFfinrTPUK0lBe0VuHwrD+f6kpog2NNbx
         KV8zmYuQDOb1cBD5vL5qXwX/7ql5rH8HqhU9b/gL6cwAlQwmHjSkMQK4NHurqJ9FWcn2
         0Ju4fq2br+p5cGzXAUIjkmXKYj8bEW9f/Wb/vg5QuxMrDmFM9Ot77wazHE0jv8I9oQqp
         fIdA==
X-Gm-Message-State: AOJu0YxJj/Xp6bK0q81iXZOOmOHlWwZrsFvaidrpFIkUD7zBpGQMZTWt
	owQVaj1f8GPWGUxvxGeLcxM7xZc+3FbJxvBWjJZmP3EftVO7NjSouNUs5Q==
X-Gm-Gg: ASbGncuOngzXvHtJysP5YnXxOd0utmObBTizh6mw8SR5iDjX5tVRSV76psOLzhaK6cX
	8ifGQTmsaruKQPvjAQxoWfrxFRTza/Ogg18T6b5BqaFF0mz6wj1Hr3ktga7odq1BROpF6Kz1Sj1
	eBTHKfMU8lyAXyObnO1SWaH3/5hQpPxpw9dWeD3Pchd3nKNiKSPYhRbk85Y2g7xrCqT/G/NL3U8
	jsuLtUHH+kD9F3cMDmG6hYTdbNYo/MPm5ao1AW1hdGixwfnar3CWSIsdI+Qa7J359MdRdvQIRvk
	pKrSTeAd6Q==
X-Google-Smtp-Source: AGHT+IFfFl5rvFzaSY4b+pE8rGRPqeFkxNe3KpGY6aOZ0sSIjny6yzJe0g55OXxePzSE2jNGhsvchg==
X-Received: by 2002:a05:6402:360d:b0:5de:5025:2bd9 with SMTP id 4fb4d7f45d1cf-5e0b70e95demr11894575a12.11.1740400897036;
        Mon, 24 Feb 2025 04:41:37 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:36 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 6/6] io_uring/net: use io_is_compat()
Date: Mon, 24 Feb 2025 12:42:24 +0000
Message-ID: <fff93d9d08243284c5db5d546be766a82e85c130.1740400452.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740400452.git.asml.silence@gmail.com>
References: <cover.1740400452.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use io_is_compat() for consistency.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d22fa61539a3..e795253632d1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -325,7 +325,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
-	if (unlikely(req->ctx->compat)) {
+	if (io_is_compat(req->ctx)) {
 		struct compat_msghdr cmsg;
 
 		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE);
@@ -436,10 +436,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->buf_list = NULL;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		sr->msg_flags |= MSG_CMSG_COMPAT;
-#endif
+
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG)
@@ -725,7 +724,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
-	if (unlikely(req->ctx->compat)) {
+	if (io_is_compat(req->ctx)) {
 		struct compat_msghdr cmsg;
 
 		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST);
@@ -837,10 +836,9 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		sr->msg_flags |= MSG_CMSG_COMPAT;
-#endif
+
 	sr->nr_multishot_loops = 0;
 	return io_recvmsg_prep_setup(req);
 }
@@ -1367,10 +1365,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		zc->msg_flags |= MSG_CMSG_COMPAT;
-#endif
+
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG_ZC)
-- 
2.48.1


