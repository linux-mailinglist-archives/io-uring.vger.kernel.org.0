Return-Path: <io-uring+bounces-788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE3D869F8C
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDF08B23BD1
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4BF4D59F;
	Tue, 27 Feb 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jxl6E9Zx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE203D988
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059936; cv=none; b=EgQDhI3i7PbLOwM0b/7ESDezuONtnvgnU0R7RPK6x3xBsnNFuYr9JygzJDUKJeDDjBHKeN1JhJV+Iqx2tztbvy+tOIA3R3YQmGvuMfssmcyBG3dr2D+cYDmiZN/Y6ob+g4riTzVTT+JR+lblONowKzViB6Y62roKwFuK12rEVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059936; c=relaxed/simple;
	bh=srMU7n+sXIFcrgdUEN3TXNnawtJORwd7jO7WIFzhWjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haMTC2VhQ9Xo4IV2e6s1Xt85wS8zFdv+oVMZDe3dGHhq+KtIzmwtR2Fv3Eppwz6h5tMlCcojEEYuxgTGe5N7TGnYzctlsASxjvmWSzvjMgNFjwUggr7nUsVq73eta3mGoff9RCVxmPvZokXfmnen91a0jiAazxzoHpnmtQ5w6/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jxl6E9Zx; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-58962bf3f89so1611689a12.0
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059934; x=1709664734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNuK0EUNkoiUg4kijOvZTjdBLy+N5AN1n6F7lAul+9A=;
        b=jxl6E9ZxYpG3HMjRWKjbDB/u5ILWo6eZQjHN+dbPlfnNtsmnX+FB9qSAQvlOZg8OEY
         cKeOyfjjMV8Oy86YE1VsdprYkvPaZv1uBiCknWTZKxDXcLDWdL0P2RM4vq1mgUAMZkYD
         YUWuJbVR4OlQqobcZa0ARMBwinVZzbfghUOi+R5qisNGIb4e4CgXYnYJxKdkcbJJ74+N
         VHt+dLcAXeu8V1vphaQ3O1amNJ4wb4nnnwkHz8an+nMryHVeLvsEWfAh6/Cxp7qNtxae
         wHBC1MtDznH8JfZnCneAxJBiuHpbyJ1GK/TpI5rckiEfzoLhL31HHRLc7kX3clzAioE9
         LCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059934; x=1709664734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNuK0EUNkoiUg4kijOvZTjdBLy+N5AN1n6F7lAul+9A=;
        b=ad79hXy6Mgj1yojoaPeo9TzfI6Rl2DiZmNleLO9IbSxWHZkKJ4UP0V09k0zYgWk+Hs
         ERmAeBeY2bRHYVzoL0RVCCWKu0a1cBGmJqQ1V7sDvFIUFYy2xR4eVBgd19+v02K6HgiL
         kXBsXofoYJE7tkW+0M6J8zdznNdSoPnQ0zPsE7jflRvFlqF7Dx4pNtnzJ6x12wOF5F55
         laxMY28cW4+hXshXkR7W2/y9pVv13XSjbR8bcErmCDNEHJKjaZv3IUhV680buCnWU3E+
         LulT6avMGAgjddK1TS2/PBuA6jESS7nlb8Lmdyc+VgsrkfIgvbvwXwful8jRMyf99EvE
         WsfQ==
X-Gm-Message-State: AOJu0YxalZvV9t4jdbmGodyuib/JD53Z/LLKZGy3lQo2AZEtK9tbWC/6
	YFYpI5y1tECsRjAk1Fa5zULizvOqlQCZ5G6eFfCCX+D/AJYuJq4LProQO2ktbRS34w9orkOkaN1
	w
X-Google-Smtp-Source: AGHT+IG+FLmSxXYmrMN8IcDHqYpoxpDOs64yEH5Qct/8U1iYdSPGKzIkbF36wa/yikdH1T4HorKBBA==
X-Received: by 2002:a17:902:a70c:b0:1db:94a9:f9f0 with SMTP id w12-20020a170902a70c00b001db94a9f9f0mr11594441plq.2.1709059934255;
        Tue, 27 Feb 2024 10:52:14 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902eb0500b001dc1e53ca32sm1860721plb.38.2024.02.27.10.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:52:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: avoid redundant -ENOBUFS on recv multishot retry
Date: Tue, 27 Feb 2024 11:51:10 -0700
Message-ID: <20240227185208.986844-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227185208.986844-1-axboe@kernel.dk>
References: <20240227185208.986844-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we know if the buffer list is empty upfront, there's no point
doing a retry for that case. This can help avoid a redundant -ENOBUFS
which would terminate the multishot receive, requiring the app to
re-arm it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9fe2a11f3554..ef91a1af6ba6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -716,6 +716,11 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
 		io_recv_prep_retry(req);
+
+		/* buffer list now empty, no point trying again */
+		if (req->flags & REQ_F_BL_EMPTY)
+			goto enobufs;
+
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
@@ -724,6 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
 		}
+enobufs:
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			*ret = mshot_retry_ret;
 		else
-- 
2.43.0


