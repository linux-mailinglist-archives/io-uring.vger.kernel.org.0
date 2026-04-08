Return-Path: <io-uring+bounces-13006-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGwlENqs1mmZHAgAu9opvQ
	(envelope-from <io-uring+bounces-13006-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1AC3C317B
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5566430143D2
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 19:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5735F37757D;
	Wed,  8 Apr 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dpJICX/+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8961F91D6
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676630; cv=none; b=Nu66CIGj2+qouhU+B4/sKU96/GpRNjOAYi2hEFI0pNMLjwGOhnzcmiTtxmt2bZxKhDgOQ0bigTr9pvtNdfSgUZ/0WyN7coi6TyeD6/EeGAhNXj+f4yOOrX88ZvBw3OIOtfuQrf9cUBQe0+r8vL5DLBZVJDjUR7cM0G0Z4LtbW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676630; c=relaxed/simple;
	bh=aiZ8tHSs1F1o2Vumv//Zpq120qd9fWWHDdLM4I7EZgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD2EfzRJ8c4FfqxFrQMWUGf9GxB8Gm6Ddajvdb6OKIsJ7C2ML3D9YQH1+rB04XwwE/M++9H43/+tPiszNQwUQ/qzhcSgs30hPDyIYpCVF4X9jzuLnUwx+g76DczocDBAVZzA4xw0WkMbehwyXSMSf2sz/omhmPmavKyui60zLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dpJICX/+; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4670464029eso69853b6e.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775676627; x=1776281427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAB5+iHz5cmNbPYTXpPAU7ZTsN7RFi8R1TQvvTK9Wuw=;
        b=dpJICX/+dK9s3oa2ye5QFdyVvJL1YQdXgoC1dHghvr5u+8vQ8qok/kCaQZOltRBxRP
         e1WVT16ljChlPnNWbISZ9g3DH2D9jUqGAhA8U2faZnaYpP/z6BMMcE3EGBduw+wcgMx+
         lb0iuw8f7XqDAQubfhHUxzLsPheC5Rhgqz6rOnSX3aTyYknP0gH4HR+rQf7xQTLyn4qW
         s/6TtJkyx/XKGSOHIDOwiVb7FNkR63vs+ZAeYIhNyW56BayEOQpquyGihbP2361sU8Kd
         P20dYIZXoQjWNx3J9iGCQzj4XnwkDosWRowtEKCfwgkSsMMLVH9CUZZOhjw4CmDG6iAv
         hD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676627; x=1776281427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GAB5+iHz5cmNbPYTXpPAU7ZTsN7RFi8R1TQvvTK9Wuw=;
        b=oCoaCU21hPTvfnpAukXrgQIi150aj07CAsh+1iN2LDD5uOmc/JrdHaWVIWGPViw6Wa
         JG+XpvOHwzfjFQ+r3FbGiMzacP3VV7d0MhonawF30yzTLT44kXbf0nd1tRAx2lVgcp0B
         bNMRB4DLsB8OSNuko4oNY0gTfCeF3ksL5G8j323sHnO6UsVh0JnbZdWG7TwAotOSRcCI
         1CPpkr43FoTsEsQHEP3MVoqQLwJYuRFzynwWNi17ZJc5b71Y7LzTz4RsauIjsNQ5YD0I
         a+d300xMXpkkE/4P2szrPzFSOXFt8fipI9lwrl6pSwhisbXfJ2speEtPM1YEikDCd5Cq
         r/Kw==
X-Gm-Message-State: AOJu0Yy1DoIyb2U28vPhK3e+gfSvQdgCYfnWY5u8FPWpksIn9+jWqFYJ
	7wrmegaIEJGNVlPlWZRCE3y7l5bjTeqksJeW4Igi9Hmd3UuVK+MWxW7JH9Zjb4sRN91oid6vA3T
	08KHu
X-Gm-Gg: AeBDieurtXqt4JsXtHCvA2u/D66cqnGFYe49BVKzc8jOHdxvkU8Uj7oMEwNYSRXMW9v
	S2in3cKOgp3uSa5OtN4dlAjwqGBWaP0hd7cKSESD0mBB4oBKhCHyWbWxJ1rUuqJc6/VixCnEHzn
	1ViYrBRacOf5PaY8eYhWZflBjX0TwUNEZ8fvVOqR0R1PCQ9P7HjuDZ5ucC7IT1yB+TNmyvR60EF
	EAVZw3nQxgVjD4BPhozxJF8GzvbQUBsX8YOqyJks2gRRgB3avoweSEM/TvecFD+W+1q4gOjQu23
	TaJzaOQ8OsoP6k7ygFS38wDZlsG1qhsZdt5n7kDnREXFnE6t4Ybwxm/TWnV/oX/I3EX9FSv9i6o
	0meLiuEkgir8qJPHqJPD1uVm/Umib2GINn5fgExSRvjOxZXvp+CdRy22Hmyf/9TgoXrYyl5rNrE
	PiarNqkbrVhTAVbySD0+aWepkzSgXUWWRBMXKSnJZ3gKXqWmQgNSfFLtdNJ8CgySLNOiA=
X-Received: by 2002:a05:6808:5087:b0:467:f36d:a08a with SMTP id 5614622812f47-47721a78833mr612017b6e.5.1775676627207;
        Wed, 08 Apr 2026 12:30:27 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25a55asm17486812fac.10.2026.04.08.12.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 12:30:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/register: don't get a reference to the registered ring fd
Date: Wed,  8 Apr 2026 13:27:40 -0600
Message-ID: <20260408193023.397746-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408193023.397746-1-axboe@kernel.dk>
References: <20260408193023.397746-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13006-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 7F1AC3C317B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This isn't necessary and was only done because the register path isn't a
hot path and hence the extra ref/put doesn't matter, and to have the
exit path be able to unconditionally put whatever file was gotten
regardless of the type.

In preparation for sharing this code with the main io_uring_enter(2)
syscall, drop the reference and have the caller conditionally put the
file if it was a normal file descriptor.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 8 ++++----
 io_uring/rsrc.c     | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 35432471a550..95cfa88dc621 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -941,7 +941,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 /*
  * Given an 'fd' value, return the ctx associated with if. If 'registered' is
  * true, then the registered index is used. Otherwise, the normal fd table.
- * Caller must call fput() on the returned file, unless it's an ERR_PTR.
+ * Caller must call fput() on the returned file if it isn't a registered file,
+ * unless it's an ERR_PTR.
  */
 struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 {
@@ -958,8 +959,6 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 			return ERR_PTR(-EINVAL);
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
 		file = tctx->registered_rings[fd];
-		if (file)
-			get_file(file);
 	} else {
 		file = fget(fd);
 	}
@@ -1038,6 +1037,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 				ctx->buf_table.nr, ret);
 	mutex_unlock(&ctx->uring_lock);
 
-	fput(file);
+	if (!use_registered_ring)
+		fput(file);
 	return ret;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2d8be5edbbf6..cb12194b35e8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1291,7 +1291,8 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	if (src_ctx != ctx)
 		mutex_unlock(&src_ctx->uring_lock);
 
-	fput(file);
+	if (!registered_src)
+		fput(file);
 	return ret;
 }
 
-- 
2.53.0


