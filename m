Return-Path: <io-uring+bounces-1334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C628924F8
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 21:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA6671F226D1
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 20:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C776513B2BF;
	Fri, 29 Mar 2024 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nYM6/V5T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1313AA3C
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711743170; cv=none; b=SH/pXEvrLMNP33Wryil1/MRdb8zXuSa0ZJi1YlUVbPjrFj9V5y7RvpGxorY5/O+igAXePX0813x9QTvIKp78WpShXGbn0ZNv5Z5GDy58+8oOp5QlnxVYiHEI8CLSl4dcj5lqYqFcZVM11JvChEW7O0HpEmRizveo+Klwj1J1CIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711743170; c=relaxed/simple;
	bh=ZOc31Chv9GMzFMptACL4IWPv63UmYAghUAlkMAAqqNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVDjOhjE0XW4y0ta07XTKNuUziNTTSuYdHCz7U9iZxbrUlOQhvsKfYCMtALOylBr2phHCWvfcSB72XlaR+5yN76VAU962/74daqILIMSiPxvdSr2d55ZKCJF+Hi+rG8lctXyorxet3Meus9TsHef1uu2Uvr93q39sJ2U0thPeEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nYM6/V5T; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ea729f2e38so419901b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711743168; x=1712347968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=nYM6/V5TEO5HhpSa7N9Y1/dPkxIZoL9mvJLJF2NbgiJOwpmZIst/QZA+4swRe0Rus8
         RGGoIK9Ols+LX7KbUYY19BiftNMOpLOLywrHChBqt6wyRbR03T3ezyatDPXMY9g7GqHS
         qF4+8tyoL6IE8vVOTCd5leYUhQIFs/oK7LcB+SOHNDOkPz6es3jTnhWUQnrwzErjrboD
         wFDlae/wn/uTjoMSpbIGOBXGkYpUUoyrKi71PZR9t0Vj/qYgd7abTlQQ1Kp/cNZSES9n
         zxhqIUMBzlbxymymFpwuTw4SyVxSOGBeWnWxaa27MChjc+3/a9sH9PxUbV3a093XSsab
         vfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711743168; x=1712347968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=sLX2LZit6s4dIcSVlM/xaXG7Hpr/NG5f+aWfsDzVNEyDANdxfpmzm3DnVY7JoSBLcj
         yYNTvbqYQSx7DD2CtUlsJw1hXNioyMLRmt+GlCGLkU872xjQ5GM1tOmSlQVlHwFsQCg3
         EykIjnrx+vsVbUo42WNPxRSpJAjS2HLRG8Ptx9Y2sAEM7jXpLIhMxG5chcVVGRDF7YTH
         ySR1GAp1kPUlzCCOFX9enq0dGkgaOB3qZL9V1gAfm+j24yYeWItUPdfG/C/4FxDtMOUa
         qRK38eQnC7/7xI32gv5kcIUJGw+6MAXXLctE5gode2C5Dx3/yPEFd5yQseTIvdk+BGPE
         XEGQ==
X-Gm-Message-State: AOJu0YwYd000FmJfgXnwwKSbB+qEdjnu3GqfVvMUyf4x1EJQqNbdgoPt
	00/p0tR5R45f1M/QM7R55ROURuz6OmpzasgucAzduZXw1mZLSUkH4AXYj3rSC2yMGgNCDtwx0ol
	Q
X-Google-Smtp-Source: AGHT+IFtWzjL7WnecHgR7Yj3ZpMbpcbrgJUu6C/tv9xdrMO7em/CpefSa4GW18HWQQSbKlcqmJsVCA==
X-Received: by 2002:a05:6a20:72a8:b0:1a3:c3e6:aef9 with SMTP id o40-20020a056a2072a800b001a3c3e6aef9mr3544438pzk.1.1711743167744;
        Fri, 29 Mar 2024 13:12:47 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:40c6])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006ea90941b22sm3388728pfi.40.2024.03.29.13.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:12:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/msg_ring: cleanup posting to IOPOLL vs !IOPOLL ring
Date: Fri, 29 Mar 2024 14:09:29 -0600
Message-ID: <20240329201241.874888-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240329201241.874888-1-axboe@kernel.dk>
References: <20240329201241.874888-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the posting outside the checking and locking, it's cleaner that
way.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index cd6dcf634ba3..d1f66a40b4b4 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -147,13 +147,11 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
 		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
 			return -EAGAIN;
-		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-			ret = 0;
-		io_double_unlock_ctx(target_ctx);
-	} else {
-		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-			ret = 0;
 	}
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
+		ret = 0;
+	if (target_ctx->flags & IORING_SETUP_IOPOLL)
+		io_double_unlock_ctx(target_ctx);
 	return ret;
 }
 
-- 
2.43.0


