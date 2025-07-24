Return-Path: <io-uring+bounces-8785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7926CB0FFDC
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 07:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BA46189A1B3
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 05:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2696137750;
	Thu, 24 Jul 2025 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TunvNPw6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F12A1BB
	for <io-uring@vger.kernel.org>; Thu, 24 Jul 2025 05:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753334227; cv=none; b=Ancjn8yboW78XWQOHg6rcSf02jxTnTFSj0Vbig4Ia5tuGoj4DgJLvhW6OkTaIzgtyzOLWZItmunrJNTMe4+V+JZWqMQIghiCsYVYES64DH26zHpbSpnstVbTktbKW9J1ASefblrNDIpVoYz4AT5ynbalHHB3ek1nRAXppbv9igc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753334227; c=relaxed/simple;
	bh=oJFqD7rlReLoiUusJRpOd0wXZsROrmyxKzq/ICTfJk4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a4uy0PKwiSKHWR1N5wDnRUf60M0YkmZwhdMBsen4eigKRdIJN7t8kVtncXulMTZ335o88di9WhEuwO1xXlFzZzbe63zZAdnQySJ9tMwJekBFbY+Epy7Gp2NWKhHgXWGbSol1Z5LmwUERkENLccTABKFGMh8IxUGXTS/pUyGhypE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TunvNPw6; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-31e41cfa631so701513a91.2
        for <io-uring@vger.kernel.org>; Wed, 23 Jul 2025 22:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753334225; x=1753939025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eizLOvkL2PmaA61TFnBvulc3GoWQyqcKkCIzuZt7vOA=;
        b=TunvNPw6GKqRGutqYYrNQWmjFrEAdcCzeNLwpL3jG+EyJOA/yBv+vThZGZm3E9d8cs
         Xg+R1FQ1N1+DQivVjRgMOA6G+qNpHzlzDsHqO0GeXz3YGisAljgbLlRegcW6bTeWEyxn
         +DRKiwtMDFNWyhJ4t1TUEWcndXQJMunHXTCdvSGu37N8Txt4SXxlMHLO/cvf/NO/p5yH
         MVU8TusiBHZnHeEMW1J/Bjz4omCL14FzSR5lsm1WjzJN06bihMY7pQ57mBIj5KmIfxBY
         eIoV7KIK2gGhWjG4J8k76tjCkdwGILHEjfs6lW1pdvtx7M3At2dHhAe8jnBUDUpPLta8
         WUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753334225; x=1753939025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eizLOvkL2PmaA61TFnBvulc3GoWQyqcKkCIzuZt7vOA=;
        b=q2Oo3z+x8S/U93xq/BILg9mk1HQHwswvgcjPLpEZtF15KiuhNnayONgLwt6J4WfxUl
         GOQiAS2SzEtiPaPSDlAY4RqwyxnI+sqplQ+ItEgtJ7aDP9kvkb9tl7vpUp/m2JmCw51k
         qcbzkmZ+/RlTVGf75JXggu9yMG1AL96ZtOfpwJmNnC7Q+BZd1KjIoIxqVIaAyNkjeA8f
         DNv5/BK9pQQFesU6hw+1wjbW4Z9PIZZAf3M9FTUHT0gmhR/4tTmw7+668NPQJCKYPUbA
         5h+ZqrxAK3VvgmZ7V3TCcy/iNc3cBCKTW56j9fF0w2JuiN1FJYSuGa0j7MYcht215iQv
         C4DA==
X-Gm-Message-State: AOJu0Yx2Tvmn4rGL8fHVI47+IiPBb+Hw+lIaq9WuAAZfj3rMpydhsBnV
	N03YQmNpViOihDdZOTBPC97ZBZ+cDhTWHuHEDAhBGm5wZ8lu9GoMVrVmd2Y/qxmEwS4=
X-Gm-Gg: ASbGncssFKoCHX+vqVih3noni6eLSF48oweuvtYW1By4TbIrgIF65jKK19JfkYPD8c0
	aPL+WJexy3EkC/I696Ky2VX2Ksp2RANM7bhZmFsWgyFWSS+kz7gxcYeUHrVvEonKpiUPSbK4oU5
	XVjp5U2mcD2ZoKHZ+lbKk5+sB0hp/LQgMbke3fZueaP2N8MSj6MxwsG4qAKlovIQJ5s8j2GEats
	M4qKtLdmnsu4JaTV6p4Hcue0WmRRA0nuTAgQIADboCkYbs/9hz1/LTQc+uARyRccjDfBPY1vd+O
	s83HxbWA1tyo+BHogFmIJv32ryGi1AX4vQkjYt+ci/+IlrQPrPNbaxf+6LUDKrjPFx+yHNsQO19
	oJTIWyzHzDyNsdjdaQazDFRXc0/87KIUfmScdmyzybEoHbhswdkyoqpOT12L8WN/3qSegDdB1zp
	Q1rJroQs8SaFJ3/qA=
X-Google-Smtp-Source: AGHT+IHxuMYk4YJdbnvtcXntyAp7Cz58aGysWesVrMXxGgrWPsNCy5r7H8Yd2gvVkWlcHqoriFjcuQ==
X-Received: by 2002:a17:90b:3945:b0:313:f883:5d36 with SMTP id 98e67ed59e1d1-31e5079125fmr6666419a91.1.1753334225258;
        Wed, 23 Jul 2025 22:17:05 -0700 (PDT)
Received: from localhost.localdomain (syn-072-130-199-032.res.spectrum.com. [72.130.199.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31e6628d974sm387537a91.15.2025.07.23.22.17.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 22:17:04 -0700 (PDT)
From: norman.maurer@googlemail.com
X-Google-Original-From: norman_maurer@apple.com
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH] io_uring/net: Allow to do vectorized send
Date: Wed, 23 Jul 2025 19:16:43 -1000
Message-Id: <20250724051643.91922-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Norman Maurer <norman_maurer@apple.com>

At the moment you have to use sendmsg for vectorized send. While this works it's suboptimal as it also means you need to allocate a struct msghdr that needs to be kept alive until a submission happens. We can remove this limitation by just allowing to use send directly.

Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/net.c                | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8a0e70ee2fd..6957dc539d83 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -392,12 +392,16 @@ enum io_uring_op {
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
  *				will be	contiguous from the starting buffer ID.
+ *
+ * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
+ * 				to allow vectorized send operations.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
+#define IORING_SEND_VECTORIZED		(1U << 5)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index ba2d0abea349..d4a59f5461ed 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -382,6 +382,10 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
+
+	if (sr->flags & IORING_SEND_VECTORIZED)
+               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
+
 	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 }
 
@@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
+        if (req->opcode != IORING_OP_SEND && req->opcode != IORING_OP_SEND_ZC && sr->flags & IORING_SEND_VECTORIZED)
+                return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-- 
2.39.5 (Apple Git-154)


