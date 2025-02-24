Return-Path: <io-uring+bounces-6663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD6CA41F7E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45A0A422411
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E2423BCEA;
	Mon, 24 Feb 2025 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6Uy8dfS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF523BCE5
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400898; cv=none; b=lNPNyZ4jj/l84gm36xIZ1DbHaUUzkCqFBA7pgTIhbYR/ASPv2flqrTwFx27W4IQajJTStVAJZoZGeVkNdMruEEf8U9WZSyHOQtvyzYiaMnxqsjEuYdsV4A3Hl+0A8AVilhZCVhkD/Lnzt5+aTxkd83iqUI0JmNGIzg6yv57MX18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400898; c=relaxed/simple;
	bh=fVQsquoLJ8KcVI0bFbuIav0NyFRfu3+x85NYd6+nHtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUEDyODcG4V7cOX86STLCV6b+0XA/2g9fMIljpg0KCl4hb0RcAw8ZcoKOMC0GzBpJFjhVyTW7345g1w7KdNwaz56vEW3096rZfa+TC4MY6YlxJBiaEsTAxAoCrQyHFS/435WrNqFSE7gz+br8im5IloV3I79KD9G7ZpwgHov8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6Uy8dfS; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5deb1266031so7949307a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400894; x=1741005694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIJ3m0SPWqFKWfkGjvetnixJEAxdceXPEmFpo5d/CKI=;
        b=D6Uy8dfSyP3/BUpdH1XmX27rE+p1csTVJd46Y+95FIf2XLbPBoLbxkb5fvxqAJ64fX
         kpXECJwmQaXG7spO4HqDH6BuKM28gWiPYwmHOWgy25dl94Dm5rL2XS1WhdYWcddtcFAF
         nTtiOfJB01cSpweB7OJCPHeX8jcqk+97XUsCXnQQcYYI3tUBzNtjbJTigc5AWqOkeGEE
         6qmkoPhjbEhdZ/TQ9K3+1R0l63fZu+vTyJL/u/oSHsmkjlWJvvGineQKp0hpKmI2E0kp
         AVxr02mmGNoq9UdpL05wPBRulAoNn++YbGc9XO+UaP/juIekWCWMzkPAXLOARoiEaOSs
         hIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400894; x=1741005694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nIJ3m0SPWqFKWfkGjvetnixJEAxdceXPEmFpo5d/CKI=;
        b=HNGJDPmGfJ93ZHlAePsAYSBoufo3jxcb2IwU3x6/9Sa8Xo933yWX9qWUB/NIBrJk5n
         FjQZDzHvtgLdUByRHIc67tIfA1+gJmLhU8pqmVvRERCKmjnJ/bZ1ft5lQ+o9BaL2yMMf
         G9ZbqxiIVNq7KFDGiLVRclCVUpAAOy39lxO4iITD23OaxHcRyiq56PgslZd57jhGhRj7
         SY7Iu7ZXMqSg7V6rsCGCQ+xyxdnTd5vFUsg6e6NkD+i9H6ZVEAZtJOP7Vd7h8syPirBs
         q7xiDDI63ocaPniyw+6sZHWwVr9mlm0J7beWixLUP2EKJvbwupraeMXfw6Op0mAl/N0q
         4h9g==
X-Gm-Message-State: AOJu0YwOkEMxHj8XBu4Lg1VaJyhCQ3Vdc3z7gPFIBfUyDGHVP/SAQXvp
	nkxSdZ5IpwTGzdxHP3Kkzl7Y3YItWZxUMNg2oVWretWI49kXVjpULVrNuQ==
X-Gm-Gg: ASbGnct//cOmPLYP/BYRFxubKBECPWDMZEbTrU5PCPFyPptR0iHLHj+CZ6EP7flM+dH
	+bQaXjk9D7E5Z8s/u29XdoRvPs6uvqcCDWIdqgUbVyO+wMv6BdfV8CVjJ/zkAK0JAWm5IBDuzzb
	T/XOWTeVMaw6CD494sYcqE5FMQmTOCw1eIXoWM/Zyaqn4+D/MVbG4JwXiosS2z+IEke31PYSGXF
	zVc7xi6Rz1h5x3NFk1GugBUelX5FsRp87vJdKw4qwEg7sb2EwIa7mlYmHVVaZWQY/LqhW58tFp9
	mFi3/G75vw==
X-Google-Smtp-Source: AGHT+IGgtdFXQeoP+g0zKJ4czsSBGE6yJ+i/CSHnkpuAGvVq20GCackL7n2f/r0TX9pugkpSmWKRqA==
X-Received: by 2002:a05:6402:268c:b0:5de:4b81:d3ff with SMTP id 4fb4d7f45d1cf-5e0b70fa016mr13657989a12.13.1740400894235;
        Mon, 24 Feb 2025 04:41:34 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 3/6] io_uring/rw: compile out compat param passing
Date: Mon, 24 Feb 2025 12:42:21 +0000
Message-ID: <2819df9c8533c36b46d7baccbb317a0ec89da6cd.1740400452.git.asml.silence@gmail.com>
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

Even when COMPAT is compiled out, we still have to pass
ctx->compat to __import_iovec(). Replace the read with an indirection
with a constant when the kernel doesn't support compat.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 16f12f94943f..7133029b4396 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -46,7 +46,6 @@ static bool io_file_supports_nowait(struct io_kiocb *req, __poll_t mask)
 	return false;
 }
 
-#ifdef CONFIG_COMPAT
 static int io_iov_compat_buffer_select_prep(struct io_rw *rw)
 {
 	struct compat_iovec __user *uiov;
@@ -63,7 +62,6 @@ static int io_iov_compat_buffer_select_prep(struct io_rw *rw)
 	rw->len = clen;
 	return 0;
 }
-#endif
 
 static int io_iov_buffer_select_prep(struct io_kiocb *req)
 {
@@ -74,10 +72,8 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	if (rw->len != 1)
 		return -EINVAL;
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		return io_iov_compat_buffer_select_prep(rw);
-#endif
 
 	uiov = u64_to_user_ptr(rw->addr);
 	if (copy_from_user(&iov, uiov, sizeof(*uiov)))
@@ -120,7 +116,7 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 		nr_segs = 1;
 	}
 	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
-				req->ctx->compat);
+				io_is_compat(req->ctx));
 	if (unlikely(ret < 0))
 		return ret;
 	if (iov) {
-- 
2.48.1


