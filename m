Return-Path: <io-uring+bounces-7593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5858A94D18
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 09:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D711C3B3846
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 07:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8132C202F7E;
	Mon, 21 Apr 2025 07:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KhUEgEbB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B6F20E01F
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220274; cv=none; b=QHr8/TU9wy/RA87BCKxm4cDGdv+HZjzcPT7cZgnbyz5QYDSRGZtKPZ55F9pKRjNy/SgAflyBfNBenhJlFkd7UDtCq4QfuhTuNw2XluUaP5k077wGCrT9wm83bAt4CMt8jgZlvoEBOKcl4yX0dQczAckdy+OOB7A5CBs7T7kcWpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220274; c=relaxed/simple;
	bh=0FauDIlDWk4Zj930vewIXEmh8klMdzuqz7C1A+2ewnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdrXZyd4EIWIzS7IDd/C9JbQ6j4asWH4K9Qh/r2KvYO8gK3Q9sxIpxMGsnR4x+3PWOBxhbLgbsvsB4+pa5roblyZICHnFNbzaUg3Mq3ZymYTrRJIY1aQIyrOC03GMHlgNJl6PENUoiLq3SMjgmpe+vWHrrrb8rbFIzNLxUcnEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KhUEgEbB; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso5391047a12.0
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745220270; x=1745825070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDd6I1e5kZWpE2AMVdjDsc6E+agEhE/ADzVedW1AH8I=;
        b=KhUEgEbB/cL/WujlvfDyx6TpCcG0TkJbifEc0X0pytGjV7x9IJwb1z4mc+COm+4Lt1
         Aj9KhODnpqcxvZwjIVnkAZ0DuRU2VrBUDK3k+U7W1sQ0SyH4LXikfICyaR/LnPc/ak+X
         qVv8ixJ2rtLE/SWPOupXIeaG7ch1h0O0tPSExJMRIoW9iacKlm6n5pkTXk5g2MPqj4QU
         AUqFIkHr/LFLfaCvc2BBdghP8ZoPMzCSMB/fyZ7WBw4YKz5tPgmIl2NLZRbqqYD8C08o
         IQ7fElzVlEYFnON2LGAwICM+bE0SVeNUjsN8MUYM0Uak/h3l+/N5dkB4nADpPPUJCSCt
         DaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745220270; x=1745825070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TDd6I1e5kZWpE2AMVdjDsc6E+agEhE/ADzVedW1AH8I=;
        b=g0eIqwp4v8k4O3cDVu2FhjDjiVoqACpLesuJZNJDLRlTnGlTDjhGeMtyABMJt/tC7w
         XltNTheJX14l2EclDi+xdAOEakBWDtHU0qmwW3A3b3BUREWRO+1oCUobZUE0gMynR1+A
         3ADWG3Y3DlGMI/zPW6RhSGyX9mIajebQEqkrJi72/3einknPdjCuiUEffF9XTrdY5+fV
         z5Y0bkhT2Fuc72iD/q2EBLLCCzWHJywfJJGVuIqa2vr3xw436bhMo+aje2rrlEAvcDCy
         HMOfQodbBzSs6jusXC4FWy2ztdDdEWZBkHOxgqbC9DDsjUlNAo9UFIcxVee5Q3bpQxay
         Yt4g==
X-Gm-Message-State: AOJu0YzjhiCVz9+g0WSunnyWN2luFsr4vCAUmN75872VnNTZM0E7QQu+
	T00zFEBUvR6SyceFkM4CWhD2df2ykQkAtSpcIx63HmDJg0e33iffrx6w6A==
X-Gm-Gg: ASbGncsYNtazq8JUwAlL55qHxOrkdKLP71ugsbHpV4IMlyir022vbbGxEtJuq07+Zbx
	qaNvqDmtmNxvZUVBDV8BWIYth4ATiekYsf6JmGHpSimWHYCWT9cACa1qUCUkdqjL4yDE23CvsHR
	8f/GWWZyVzuegwN4a4woQv7g7eW4cnV5eNALIsJ6pLrtTK3/bFvqMCpxdTHMZZ1pWEECc+yNXHc
	tYJ96VPmc3btmjsoZN7XMU8uIsnBPd+tTdXueqYMvz1Q/iKp4lav0Y1o8pNb9hZQPfrrVehoS3S
	XM8ciTCiNaLF3pl0HAb53gJbFd0WoOWXoaGhB1tGBqAR0unsM2y0A7J01v+ahHTZ
X-Google-Smtp-Source: AGHT+IH5jguPWKriEU07nS1qAoLZ9JMzLFGRQTLo3IKmATsRN+pcWZwAGe9h3yyeUPmWB1MtcipDqA==
X-Received: by 2002:a05:6402:13ca:b0:5e8:bf18:587 with SMTP id 4fb4d7f45d1cf-5f62855c745mr8129312a12.16.1745220270283;
        Mon, 21 Apr 2025 00:24:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625a5ec5bsm4175562a12.81.2025.04.21.00.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 00:24:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2 3/4] examples/zcrx: constants for request types
Date: Mon, 21 Apr 2025 08:25:31 +0100
Message-ID: <c562d397d5983909de8c6c5685d1471a73b00256.1745220124.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745220124.git.asml.silence@gmail.com>
References: <cover.1745220124.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of hard coding user_data, name request types we need and use
them.

Reviewed-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 5b06bb4c..e5c3c6ec 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -43,6 +43,14 @@ static long page_size;
 #define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
 
+#define REQ_TYPE_SHIFT	3
+#define REQ_TYPE_MASK	((1UL << REQ_TYPE_SHIFT) - 1)
+
+enum request_type {
+	REQ_TYPE_ACCEPT		= 1,
+	REQ_TYPE_RX		= 2,
+};
+
 static int cfg_port = 8000;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
@@ -136,7 +144,7 @@ static void add_accept(struct io_uring *ring, int sockfd)
 	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
 
 	io_uring_prep_accept(sqe, sockfd, NULL, NULL, 0);
-	sqe->user_data = 1;
+	sqe->user_data = REQ_TYPE_ACCEPT;
 }
 
 static void add_recvzc(struct io_uring *ring, int sockfd, size_t len)
@@ -146,7 +154,7 @@ static void add_recvzc(struct io_uring *ring, int sockfd, size_t len)
 	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
 	sqe->ioprio |= IORING_RECV_MULTISHOT;
 	sqe->zcrx_ifq_idx = zcrx_id;
-	sqe->user_data = 2;
+	sqe->user_data = REQ_TYPE_RX;
 }
 
 static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
@@ -217,12 +225,16 @@ static void server_loop(struct io_uring *ring)
 	io_uring_submit_and_wait(ring, 1);
 
 	io_uring_for_each_cqe(ring, head, cqe) {
-		if (cqe->user_data == 1)
+		switch (cqe->user_data & REQ_TYPE_MASK) {
+		case REQ_TYPE_ACCEPT:
 			process_accept(ring, cqe);
-		else if (cqe->user_data == 2)
+			break;
+		case REQ_TYPE_RX:
 			process_recvzc(ring, cqe);
-		else
+			break;
+		default:
 			t_error(1, 0, "unknown cqe");
+		}
 		count++;
 	}
 	io_uring_cq_advance(ring, count);
-- 
2.48.1


