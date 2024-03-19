Return-Path: <io-uring+bounces-1142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECF6880838
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 00:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0E3C1C2100A
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 23:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E961E532;
	Tue, 19 Mar 2024 23:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UxOPFDJo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D872DF9F
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 23:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710891436; cv=none; b=ZPCRqqH6sRwnHo+XgL9SoRsM9Y4yKYrH5ZwrOKmwnZAEV/7vOdViEB8hezbz05gA2YDtobBdrOdDC/ygnEDPy6fyINjdpMM4n+EIpl8Rcvr/03LG3kmhlMaGPWzKkAudO9HpYWEr+Uhi1vPV3sWmgBQTnNbarMENnOOiMxr1MwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710891436; c=relaxed/simple;
	bh=j/jzpT2R/XSq/5XZzd1z7XbZ7pBSyrVyj75vprI3RZA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SeY7X6Xb3atJX2ZRy/D+0WX1R0FiQPZgUTN1ti7r9mNawcmwYqxlT2CNXFsHoZH0DXfETX0tAz/I1C3vDnyNORhEkoELfm6nL3zC/L1LNz6GdNeVCmBx24d9ikKAonqEqOhioeTvm43LSJJMNAgrd9eoGb0Buzsl/sE56p7oyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UxOPFDJo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e694337fffso1529341b3a.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 16:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710891431; x=1711496231; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONtcVAM8ymLZmuEFfFo62IsSxljWnnDZmoY4WSuTPM8=;
        b=UxOPFDJovfh7TIzrKGTUVG10RkgjqAd2MnFWkRbd043G27qb2wvcL5/0RI/pxC5AK3
         joJW7IWPSrhhMRteF4XioUyr9NdWc3tD+QTkaOW6n/Fosbre7lFL37+qHlktgkqL8hh7
         UWRrtQF49cB0qBQLnb/4UdqbmOa8xVFkoEAOt23hRaDm3rT4WUqBdPgCSnrXanaPL+dd
         ngX9gHQDjiV798++dMQlDknpkaOyMl0EevaWv8EXa3CpywooVIjfKqOVktCWkjiFZPGV
         eVYTzrKcv5FKoElp70nhuuWh/BuvQMxUFclX4/MBCZRHBWOZqqwvNZeymghJh80yh0Qe
         ZWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710891431; x=1711496231;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ONtcVAM8ymLZmuEFfFo62IsSxljWnnDZmoY4WSuTPM8=;
        b=NctbHTzU7PH7uHOmfsaNI94YRqCzmkYcmWKgNl1+vUewd1aF4HqCOyjaXACkl7Varl
         TOuMc+p19rg45AvgXovEFIDKTSPbMC711TK2rnsFapoJ4TOYKr5SkwMUodP7W8RQDrqN
         ZUX1GdWK2kEeAGecel2OYKM4SPri3U6ciHxVpbXt8hAevZaiDHstp6Z4BvMVPBVJbXEe
         XU+ZUjjk7yk4/IdEHVPuIU6PFGfJtN7BE2Im1CTCke2xdQQa/s0pL774sUszS1Vg0I3h
         ZvRNLgkowpfSQxOy9Xdk8GEpGYoRiHIdzhb3MOXkK0QVR1J3eGeWbgLiSJJ5hH8ZL4ZW
         QCPw==
X-Gm-Message-State: AOJu0YyiCR2cC9MpT3EhAi4vn8tAOOUEEbKplXGuGR7tRDnCh4GZXmh9
	rFC23BC8LWtRkxRkWsgJ8FbhJgoYi0/Z93dSaDAO1ocUvbe1ERGoX5enRgpkW71o8xyAjcBaQlv
	M
X-Google-Smtp-Source: AGHT+IGgTVX90lPUsiFXw2cCUnlpr7CxEDKOuOR0wB1wrSScueL/H64VWvFrcuFeJwHPfoqQBGVlVQ==
X-Received: by 2002:a17:903:24f:b0:1dd:7d66:bfc0 with SMTP id j15-20020a170903024f00b001dd7d66bfc0mr17502387plh.4.1710891430903;
        Tue, 19 Mar 2024 16:37:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b001dddb6c0971sm12119967ple.17.2024.03.19.16.37.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 16:37:10 -0700 (PDT)
Message-ID: <7366e668-7083-4924-af43-5d5ba66fb76a@kernel.dk>
Date: Tue, 19 Mar 2024 17:37:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: drop unused 'fast_iov_one' entry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Doesn't really matter at this point, as the fast_iov entries dominate
the size of io_async_msghdr. But that may not always be the case, so
drop this unused member. It turns out it got added in a previous commit,
but never actually used for anything.

Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.h b/io_uring/net.h
index 191009979bcb..9d7962f65f26 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -10,7 +10,6 @@ struct io_async_msghdr {
 	union {
 		struct iovec		fast_iov[UIO_FASTIOV];
 		struct {
-			struct iovec	fast_iov_one;
 			__kernel_size_t	controllen;
 			int		namelen;
 			__kernel_size_t	payloadlen;

-- 
Jens Axboe


