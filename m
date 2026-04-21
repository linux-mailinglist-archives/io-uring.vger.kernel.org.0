Return-Path: <io-uring+bounces-13081-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBmZIzaC52k+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13081-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:57:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AA343B9D0
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8FFF23012D6E
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356692D9EC2;
	Tue, 21 Apr 2026 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="uEOoc21w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34203D75C4
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779795; cv=none; b=XXxhwLATkI0vYiTOwaDBdDbF34vUarggDHxIVI+OpDg9NnroS3ESI3W0ndSISDHLSkjRsuaHNY7RdjTn93oP2vsoNnYU8aiErCiTmpmh1q3nmNJs/FMOcJQe9KEaOgmUK/L6r0GIEklA+SwtqKcsiK4FJlK4J5Z3Jb5ZWOSmoS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779795; c=relaxed/simple;
	bh=kwEkYRrRFNX0eN6XOFW1EI9iSyT6Ul+9lYyiWz1VI7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEStOnJtQhySCy226cM3ZbWrchG1RYytGmfweXnIY/HToGr5oqM2ePbz23QdlyUNP0kJl15VW7Jfvb8u6di/GXUi2RGhWR5ze7/9RvrNZCfsRFcgyFDJSbN6YT4yyHpfQNKT1efd0oqWJdQf/V0fZij6u7hiN+ftfKGwHh8uUEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uEOoc21w; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-41c4d660b19so1085325fac.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779792; x=1777384592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXWZJlCi6lVrT3A7XmQ8WtNGacpAJYBg7Zlfwo6AzuQ=;
        b=uEOoc21wVClQkxQcmLPW/IDRV4pFyrPNzQpAtYc7oXfDHj69VmAGAtz/ggdQ4HCptl
         f7sMA/wSYfUpyqTkc+K/EjOTfv0+aCKOL2Rq8Xe74elMqhupOTlFW1f/VVgYu4KqflzH
         E0JVz1A/qD7i04jKyOU+WbXRKmOzB5iaqK8AzH511PNPMFzRJU4jg2poxnxxZssroXUd
         wC9h7nQ4d7F1+VCLjoaGPGJQT6rfYrJjC8BcwmV0b5if71T39U8H8KGos7MB2eWpkNbh
         Gg30uTwLAJan8rl9qC0n3ZpyUIYSOaJWJBbiRBT6pfVBdtFESr7W5Ct60y/RMfAoQFm6
         JQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779792; x=1777384592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tXWZJlCi6lVrT3A7XmQ8WtNGacpAJYBg7Zlfwo6AzuQ=;
        b=UrXs4GAE7RlUQUDDxxulmlqAhjLxPr6VCEF+eVbSId1r6E6rXDYW9TOBtQzot3TbJO
         CR04UEBkuHngLF2OTibxlANbw4+pQHOL3zlOq+np7ksqLkWB0Dl1QTa6NMP4UcvhUKGN
         EIujLu3UcrM2RUhJM68BpaiMBYJQRHMGpe+7li9SvLIpPEcZEFcOo/1/1Snz8gl26xXS
         aN/9wHO+tt7QX3UeUXp0C4RAia2ZyiJSNg5WNZKBwdShxnWyjfqmSchteYDGtJDkTkqN
         K70rWb5o4JLoQvAr2nEjA2Ai2ADfbeqbSPNxHiHt4EmCVyLkEhCMZrszSfbIzBFSkBDW
         gzqg==
X-Gm-Message-State: AOJu0YxPH9LdV7047znZ3nWBRsTvfzVmaj8rb+eNfepPzsXCDOqzJAu0
	qtN56MRyh2Mih0Q//amf2a/zGlPMJ0gPREr2j9ZAWaY2iti0ElOMn9JN/ubR3+HAOOConEZeQB/
	fHXslMR0=
X-Gm-Gg: AeBDievEIwXtmvMS+C+ruqN3EZjazrotG460doyHbff+Sx4PMFLenB/6H5TV6rjjDo3
	WmyblYY902qK14as38+xCDKMUD5AOhHc4csWNchr1hRvnhnNinMmfUbPsCxk8xiSfsb1ebjswVU
	LCN0v614RLPOEdkGPu7hhwUeLQs+ZR0y0RnQx0sjoWlten1llyP63D38g1GESq6YUKlYCANv3VM
	jviBJKoWVJCQBA2BcNN6Gl0TDLDioXIm9xYxkfw/x1NMsIOelRfKUbY4OELaiWje/BDP9KiduQZ
	hsyggVqO4KErTxAADu7ZZ6OJapW3tReDJ/pl0T35Ug6FkwIS3d/Zx46soV5m+1w3+Z2XV1mwSrW
	J2fgeHmdLJl20SBlCrAS4cx9PWmHkCdpIZLC5na/cOQVQpMbwQ/CN7cX2joQUNsSeC1T6LUYt3O
	oPP3/37ygxDuF8OFmQ1KZwomsBknTabYpRPfsHAL+Jks6V5fLKuJk2wKK1YMgO+2d0VcUfUfO11
	T/Dm015hkgVSlnYZQ==
X-Received: by 2002:a05:6870:a450:b0:423:cf:daca with SMTP id 586e51a60fabf-42aded18b97mr10209511fac.19.1776779792321;
        Tue, 21 Apr 2026 06:56:32 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/rsrc: use kvfree() for the imu cache
Date: Tue, 21 Apr 2026 07:51:40 -0600
Message-ID: <20260421135626.581917-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13081-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 41AA343B9D0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently anything that requires kvmalloc_flex() for allocations will
not get re-cached, and hence the cache freeing path is correct in that
it always uses kfree() to free the allocated memory. But this seems a
bit fragile as it's something that could get mix should that situation
change, so switch io_free_imu() and io_alloc_cache_free() to use kvfree
as the desctructor.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/alloc_cache.h | 2 +-
 io_uring/rsrc.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 45fcd8b3b824..962b6e2d04cc 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -64,7 +64,7 @@ static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
 static inline void io_cache_free(struct io_alloc_cache *cache, void *obj)
 {
 	if (!io_alloc_cache_put(cache, obj))
-		kfree(obj);
+		kvfree(obj);
 }
 
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c042054c3b5f..650303626be6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -168,7 +168,7 @@ bool io_rsrc_cache_init(struct io_ring_ctx *ctx)
 void io_rsrc_cache_free(struct io_ring_ctx *ctx)
 {
 	io_alloc_cache_free(&ctx->node_cache, kfree);
-	io_alloc_cache_free(&ctx->imu_cache, kfree);
+	io_alloc_cache_free(&ctx->imu_cache, kvfree);
 }
 
 static void io_clear_table_tags(struct io_rsrc_data *data)
-- 
2.53.0


