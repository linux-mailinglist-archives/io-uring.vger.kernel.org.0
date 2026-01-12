Return-Path: <io-uring+bounces-11591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B3184D13ACF
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F5BE312875B
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4D62E7F3A;
	Mon, 12 Jan 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IcEo26o4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166752DCF72
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231153; cv=none; b=m5NnP4Djar2C4F61LbK4lkyzSNFdkJIk4RbS/RHc0HNihNnQvndT5W7mxnX8PkNdM1B2JtL+A3f3cTikpP+78ofZyaaco1Pd1iITXjvBodJFpAC5fKTHLT5Z1z4YVthiKlObTbzkkkuMJ3vZDff3oTbnfQQC0L7BY0mVeIXhvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231153; c=relaxed/simple;
	bh=fGqTGYtKwBEt+HMI2JOOF2klPEAyVMD1QyCHQyHMuWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl903unKMG5wXOURXbJVO3FXyx6aLYfhNejKTpQRHMrstH2QoAwj8DHKFmgmMHJBdi7HsowapfkOTEhowYgjvqSTBtFt8+FKVQHOrJom7Lw6DKtkk0KrW1KbIKUU4A4aiSXFTFPKaxtsZbWvtwPnuoq51MnAnDeRU+gDVrUvI44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IcEo26o4; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-455ddb90934so1988159b6e.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231151; x=1768835951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpHToMu4MpMh68bBIm/bOWUNczdHiDTk3E5ai1CQP4Y=;
        b=IcEo26o4Lbin6bBtPfOkdOkiCZyVl5N5pWqHSG3lGRlZJ3QyUbazZ8STL+PnHdL1TV
         OQ23rj4+KK3r7o8Pq0s6PTaekLpCODyKVxacSTAT6E26goIgF0mFbRNS0qyNdmW5U9xq
         AmuI2nANIujtdvyZ7OgTZUmaZJT82RQSJiWNQ+PsmItVPuOxcqXaky4xb+/6vreAp+3z
         90nSkxgAjA3+tMDLO3noM19raIEIBl0xzzPJUfEuXrQLNCM0gPDwec5nP+dHoQ8EYwfi
         yZ7CZJ3LAEvloO8zfuFFlYKGSdAGzqOVFgVtfur9/xEdsOI5GIA35Rf25jUdaFQ1JNhn
         Yhgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231151; x=1768835951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BpHToMu4MpMh68bBIm/bOWUNczdHiDTk3E5ai1CQP4Y=;
        b=Vkv47yQvltPV4cqtxeRlGR4N8GTmNG6PuCGwL4ftTe+t2rABE6eWPTZSzFwkBaRM+0
         LeOJzH2RQAAnRjejonHREbGMc9C/E19amxif6eevBfqD4352RJ7rlYlNkb1JPpfLAfq+
         Eet7Sq1sBJKdiwIuGZC8ztfXxQdOi8bH4goAzACwDHs8kbzaTeqIh9fwG2deA47ujNuL
         5YQ0xVPHcBRSIqpUj5fm0s0l0BTQ1kfdiGY8JR3pu66yS50Q0JIsZZoQPKi8pVEDkr+y
         yXfQyLEPJUYCpCbibfsAoYQVFdL2P/ywp511nBFoKHWJ42ONlmATUm2eEF8+V6N0UtJU
         cQQA==
X-Gm-Message-State: AOJu0YwySYfsfCXWY/p8Y9BiKcvsep3NGtVdBrxEurBfzmDYEB3XcWsC
	TTeFKxHRQzR1G+DEaiCr2TrftxKe61xJX9qOHSrAJ/EvgJhE3K5Z1RRvNijegrWodw6r/7pxOAN
	1CmYy
X-Gm-Gg: AY/fxX48HNMsOB97i7A/Ge1d1obdS5RyYgb0aez2LCaF73j0JdZQwnUooTWxiiktEDS
	AXX2YOgChuq/sUJNOvDtwkSyKJ3n2gJ2juzBMOXQ7hc+AnqBAVagBeqcUGwXL7QvDwWLQZceCjV
	omS1P612T2ujz1gg0Ks8sxPTMLGqN+I8M0aJBWFiO+uCyGVBq4sleJuA1AacmGqxVqgGXgUWLlB
	uu2ghMcauLmheVso2O52I1ziTPvEAstZc/oLwVHGt+qKYqeSoVVsKylmyCYt87w3AkNs8Ta7vEz
	9aCf17Tety79h5y9kzV1oJRBYlwkTNwqms/wwGiTNSJ97Ggdsp3ZcWUMlQrz+LqsL3PokcFurCH
	n7xsBEIWwCUvdA0sW6g5rdr8I2vvGSEC8YXGBhwV+BZnNEwROpmcjvpCPlrabYwFz+Zu2vLPSii
	8QFwJiWQ==
X-Google-Smtp-Source: AGHT+IFcNg4zvZwjLaw/XxHQf4tgVf9pLHBGy88ycndzVaFQ3Yd9gmVCmEAqTnO7RydPmiJ6gQ4yhA==
X-Received: by 2002:a05:6808:150c:b0:43f:64bc:8b7e with SMTP id 5614622812f47-45a6bd8812amr8874615b6e.15.1768231150665;
        Mon, 12 Jan 2026 07:19:10 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/register: have io_parse_restrictions() set restrictions enabled
Date: Mon, 12 Jan 2026 08:14:42 -0700
Message-ID: <20260112151905.200261-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than leave this to the caller, have io_parse_restrictions() set
->registered = true if restrictions have been enabled. This is in
preparation for having finer grained restrictions.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 2611cf87ecf8..4b711c3966a8 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -150,6 +150,7 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 		}
 	}
 	ret = nr_args;
+	restrictions->registered = true;
 err:
 	kfree(res);
 	return ret;
@@ -174,7 +175,6 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
 		return ret;
 	}
-	ctx->restrictions.registered = true;
 	return 0;
 }
 
-- 
2.51.0


