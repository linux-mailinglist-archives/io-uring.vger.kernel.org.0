Return-Path: <io-uring+bounces-8652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F779B0282C
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 02:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AA0D3B684B
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 00:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18152211F;
	Sat, 12 Jul 2025 00:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i5Kjyy+1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A7D2566
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278636; cv=none; b=YIv1n+um+YjHicCxzROWslfS/64b83VbAEtrGacNkAC1T7TVvIf6hIebolsBZM58Z62TDmJ72FS1qBIaoHMSkiTbOcahh6dbu9YAh2TstB3E44Fsddl3VvO1mT+jnDYXmLlkArmJpYrb14G0gW7BXYmkf30UvAchCgNEPltxINQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278636; c=relaxed/simple;
	bh=mmiRy/UdFTfu7SfplaSofzbeL8IqzMAIgcCHy9JNsN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk1qLvWIXIhb7mz6dD8oSKtbufeRGh+fgFe1F3e3Sf5QNtvu60cBDyLv2jFkZ6/5XC9yhqQHj/whLTXf4I/9qJQp6iBnZJk52CGWiX++Sib4BMatCtUDGDtfIHFL60epMjGBWHuBrQLY78kbhaeMkI5KNpvk5lrjMhos7Xgolxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i5Kjyy+1; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-86d0c598433so87569539f.3
        for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 17:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752278632; x=1752883432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYr1XPtiHdf6CBMwpcV7AbGYvoTEu6R7VDhYd/dLNK0=;
        b=i5Kjyy+17m5gfJUtLQAg+FMqu8kWu0Dom63JdWSJhkAu8iC9dgp+D3BPdy/HrP0aXF
         ahs8z/llp+0k7o2YNrcJVWIwOaA+kCoQjEI9toazw6Z25Qz/uKR2313wL/Ai2UQsk47E
         isr4PzGjNhVNVYHK1DE72DEKBiWH53Q6nQVIER5YlwiLuOkMjKeKjrUrpi9LSamMpm6Y
         /YmB3Bag3nQIqWw46BBiVZU+EmttvQ1T5eK6eCWb03hty5k97XTf7CQJVX2cb6toS57h
         dyR52+DIai1Lc7I/bESW/OHuJVjLReljYkoJxtmNMTe/J/KgDnxD803YMmXXB4rXZGlE
         905w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278632; x=1752883432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYr1XPtiHdf6CBMwpcV7AbGYvoTEu6R7VDhYd/dLNK0=;
        b=bjw+ybR3CKapdEcLzrZaZ9+L0WGZeIjLzUUBAZkRWfDoHHJOq+iIpKDME0mAnXX/p2
         I4CJjdovFpiBb8dOw1+lrgAVkTYNT9IqNz2ZU1z3C4/XIhi2N+XqdGbua2H1bMX8mGtL
         KkoPN+BXi8lsnzt3ebrsOd3k8QRcloyZIv/xUwpL+YrKYzyaMMln+PHXV2cd9X2vRqni
         ie3KEJ8rUN9V+mVojdn+IPJXF8GcTlO7maWzK1FjoUN5NoMK2wBgCl+WtbuKk5j8SYgI
         7WNuRCo952kf7vjt75WyYKYZm++//lGFMWlTtxej98PerYTNNmSG0owCoAFxEML1xMel
         arWw==
X-Gm-Message-State: AOJu0YwXyrdp4ve3eArocUEDxxAj4keOlXoWd2nUcRUDOiGZ65Kr78ps
	gAa5wO6+sWBnJ6VTdGeqOW07LZX/RjIJfbKZERCBfj6EsAUA439YnJCaEXrrF7j6pFOWeg2RWmN
	7SoAK
X-Gm-Gg: ASbGncvurdF1u4mbd79HlsD6D7icaGGWIqbwWQgPgCBIshMMqYzLgGuPNF4/Rzm/pZj
	dqd+qXRUzys6YW2wfZQ2IcZI5TbFbUK3EDwtqD1vLT7WDLXbaPRQpSVi+22krloVvgukSC343JE
	toY3VYtRqJLK4gTgXAeeju/MSWnRKsdFSi4A+Yxu8JKOTNMtWtiRkUDCMXZYGvU9L+4Ex1fjktP
	XIiEY1XnO9FAfX6jzO0oyAUSagByc4iquMd1AeauqQKWCHoh8SBtuRW2HEMNVZQioyCXLuePgRp
	NehMtPwN9dHjDZtCZzyyHiaEO9Bl0065NyKmOngcRP9DczwpWOPj3lviV3nO3cDSrlnDw3SYNAr
	jlM5yhw==
X-Google-Smtp-Source: AGHT+IGKoPUFn9w6LtP/PFtmbyp+xtCoKgMC4/9jM/niwrxSy+PMSQ0aPr1Z6LydLSKOpxmYQdPqaQ==
X-Received: by 2002:a05:6602:4804:b0:873:1cc0:ae59 with SMTP id ca18e2360f4ac-879787fc64emr628604939f.5.1752278632312;
        Fri, 11 Jul 2025 17:03:52 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc12eb9sm129810439f.24.2025.07.11.17.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 17:03:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add IORING_CQE_F_POLLED flag
Date: Fri, 11 Jul 2025 17:59:25 -0600
Message-ID: <20250712000344.1579663-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250712000344.1579663-1-axboe@kernel.dk>
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_CQE_F_POLLED is set in cqe->flags for a completion, then that
request had to go through the poll machinery before it could be
completed. For a read/recv type operation, that meant the fd/socket was
originally empty when the request was submitted. For a write/send type
operation, it means that the socket/pipe/file was full when the initial
attempt was made to execute it. This can be used for backpressure
signaling, sending back information to the application on the state of
the file or socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 6 ++++++
 io_uring/io_uring.c           | 3 +++
 io_uring/io_uring.h           | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8a0e70ee2fd..7f2613ee9a5b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -483,12 +483,18 @@ struct io_uring_cqe {
  *			other provided buffer type, all completions with a
  *			buffer passed back is automatically returned to the
  *			application.
+ * IORING_CQE_F_POLLED	If set, the operation was completed after being through
+ *			the poll machinery. For a write/send, this meant the
+ *			socket was full when the operation was attempted. For
+ *			a read operation, the socket/fd was empty when it was
+ *			initially attempted.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
 #define IORING_CQE_F_BUF_MORE		(1U << 4)
+#define IORING_CQE_F_POLLED		(1U << 5)
 
 #define IORING_CQE_BUFFER_SHIFT		16
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..292ac416dfbe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -891,6 +891,9 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
+	if (req->flags & REQ_F_POLL_WAKE)
+		cflags |= IORING_CQE_F_POLLED;
+
 	/*
 	 * If multishot has already posted deferred completions, ensure that
 	 * those are flushed first before posting this one. If not, CQEs
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dc17162e7af1..d837e02d26b2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -235,6 +235,8 @@ static inline void req_set_fail(struct io_kiocb *req)
 
 static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 {
+	if (req->flags & REQ_F_POLL_WAKE)
+		cflags |= IORING_CQE_F_POLLED;
 	req->cqe.res = res;
 	req->cqe.flags = cflags;
 }
-- 
2.50.0


