Return-Path: <io-uring+bounces-6166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ADFEA2134C
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEFBA1884669
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC7A1DED68;
	Tue, 28 Jan 2025 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyCqBod9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE91E3DF8
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097768; cv=none; b=eQFYHalz4+Aw/7Kb82MDCPQXsTSvapMLHOal3/4E3X8jHJAm2lK8dQ/aXvFPgIzSZO8iP6XDrlq7HVNZbxk4CMFlMd/IpSqJ6c9ze4VvEKIL4IVSKWLdAObtyU4g/48msvZuAfIPTLBM1qxN3NkcMbn1aGZyJyXiOu9pqkZu6DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097768; c=relaxed/simple;
	bh=G89uTDmjVTBwd3oqLRdDQbthTcZr9iA74w9GyUFjhKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0nmRGn7Murv2SxaYmxLDcdJIMDYzm6yPVBK9PKilEh47j06oBYxHTKXDhnwrGdUlFBVXLeX2ZjkpVGK+D3qo3ciSMVcPpv34tOuQ6OY6uddehkh6n6KJxulh/8I7LW1oKgxz7/DUUK8CUwEdNq1CaTGP8BBHWSV/uaKaDtt24g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyCqBod9; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso11651966a12.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097764; x=1738702564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHLMgshqmUgVFXmp0Q6jE7DQ2VG4whANWGboCX6tX0w=;
        b=GyCqBod9r449Tjxk00Y7PSyRjunei3IBJzdOyfWTRJLF2cieNKj9QBGOUg77uiL8Dx
         D7v8ALScny7s8EGwlU1DCLR0wS/qYvAbnfUXNjfiNa4up75phaHVt+p1wST7AiymuUkN
         8Xu0fw43lZrFLhGJz23/6C48D3Olrm5JfMR7zRE7+dssAXqFiP0oJSjxWqiiWAXwEP31
         BgaUx1fS/Wo/KG1boErLmebZLq/Kzlk9aZUo1L9L+Tudq659ge1jrCMqBWAA8IvGAWam
         V+d8TVI4/FqDuWT0FIujzsm5VYE/8jJ26monzfH9cPlt6n9rqyLaPJ3ErV0asrF+sKqj
         K8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097764; x=1738702564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHLMgshqmUgVFXmp0Q6jE7DQ2VG4whANWGboCX6tX0w=;
        b=hDFvDA8grZ+0GuXWguU47uWgZPzxouzTSCTpMc+qAL418bmfZseR5FxDLtEAGDZP+n
         LCrh3TzfaLeRAroUXSghpbYjlmBmcfJtz7G6qX3wzZ+YkhDIOTT4KUBo1LnuDNeMhGYY
         GDEByvXXfF+k94GgqT6Pg3EYffrR7ikkohZqNv8El2B7Xn/FWXS0jJh+HQborIDU/d8y
         3hWJZAwc08SyBb9WDgmJk+hmS383uta+xfrGDMf0TcN1Mgo6nBm4Nt/9xJQGUOVWmo1D
         HPEH/VpTIn3J0N9qQHDjSyEubCLb1++JP7/GU4SydLebd3uF++qF4o0qx6DMNB4Ud69H
         S4dA==
X-Gm-Message-State: AOJu0YwVB6I3acRGgnTByFm181KN+imFfzQ0P0rnLG3qYvxF0qECMnms
	ZX0r8LGnFEojJf5JJOz8P2U7Lh3V4yF1n3paluTKY5fNPC7AVVpIRT+W0w==
X-Gm-Gg: ASbGncu6Z6rQY0oWwD469kdQ1a1/rHH24rHuMvqIsZqeLBkd29Gwcd6k0x712MoxWsr
	PYvTz5zGELPO+4yP1Iuz27HXEk1WQtEH4AxxbqoH91HqBEyl9H4/r3qR46u/zRTFUMWOF9AzUzJ
	ZNGn9wyvMOKUeC2ePNYYqik2pxNiRVpGuR6BhQTNwkGM0AcCKd8JeVxSUmWdHmm8dOk7qfSFL8N
	hpWfS+vaELoM2f5gxwgoWAAnc5nDQGN3wwUnQtfKoJ9lchekFu191/GRGWQW2bddRcR/gitCBcl
	pJnN5+oTdx0zC1qEDcdUzrnxGkdV
X-Google-Smtp-Source: AGHT+IHFxYwJh3WYQxn9406xWIFZV2ORPMusAuABXv77NzpiK95WrLIBbQnbV8YSDD1HRvr4KHHTnQ==
X-Received: by 2002:a05:6402:1eca:b0:5d2:723c:a577 with SMTP id 4fb4d7f45d1cf-5dc5efc4eb5mr426071a12.14.1738097763851;
        Tue, 28 Jan 2025 12:56:03 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring/net: clean io_msg_copy_hdr()
Date: Tue, 28 Jan 2025 20:56:13 +0000
Message-ID: <6a5d4f7a96b10e571d6128be010166b3aaf7afd5.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Put msg->msg_iov into a local variable in io_msg_copy_hdr(), it reads
better and clearly shows the used types.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e72205802055f..dedf274fc049a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -280,11 +280,12 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			ret = -EINVAL;
 			goto ua_end;
 		} else {
+			struct iovec __user *uiov = msg->msg_iov;
+
 			/* we only need the length for provided buffers */
-			if (!access_ok(&msg->msg_iov[0].iov_len, sizeof(__kernel_size_t)))
+			if (!access_ok(&uiov->iov_len, sizeof(uiov->iov_len)))
 				goto ua_end;
-			unsafe_get_user(iov->iov_len, &msg->msg_iov[0].iov_len,
-					ua_end);
+			unsafe_get_user(iov->iov_len, &uiov->iov_len, ua_end);
 			sr->len = iov->iov_len;
 		}
 		ret = 0;
-- 
2.47.1


