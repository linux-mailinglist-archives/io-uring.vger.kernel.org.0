Return-Path: <io-uring+bounces-1143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1507F88083C
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 00:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 475311C215DC
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 23:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8905FBAC;
	Tue, 19 Mar 2024 23:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ws0tEBLI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED9B5F860
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 23:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710891468; cv=none; b=dByGV+ddOokcHBOUf6na8w+aI6D0bcn8x1V3ncCZ8DUtVTjZJQEsPaQARc08o2Rxvtkkqd5ol9dDosf43v/6MPUq44LNM6ipFE0UlSu21mW5hcga31mnOOEAZ/ZbQfH86t73B3yCXYKqWfDBZe0l6lgOLlD+UMswhkR/pcM2/cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710891468; c=relaxed/simple;
	bh=coMKpKDhZAmrgtsRUldyrUqZWhqGEDmW5XLDE0MCGZU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jFVFd42kevGTkweF2JCJgwEsRxpUU6Mr8g9myvFsAZ9+oshU5keXb9S+y1k2yMqcAafyk/GMNKDQjbm2ERUt2EYx7ulfNJ9VcRgbgeR8nhqtO8dcGtiTHVJN53BEcX/zIE3pxNnrrJhCtqrhoUFi4cnYaU/VeZwjc2TgluvM5UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ws0tEBLI; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so1979780b3a.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 16:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710891464; x=1711496264; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BQYED8UdIX4uXMBBv0eqd6iCC9NP8lqwvKp2Bu9xxU=;
        b=Ws0tEBLI2bdT6VizX157x06Qt0a85zd+bCT0+UjLX+Js3kcyWlPVsg+mzVlE7JXRx2
         KmM00BiEgIW+ZVvpygBHW4B6ibTatNqasdRL8L8fNJ/BHOQ7V9XqrMTULOO1ZtsEPdCv
         dIELJYw4JFWz6lH9lpvgWSoOGGKYSc2MzJfnvLnszOjIC7fnNPqPkwTbSCNF4/t1R03O
         JNDeVl4BvQM1URUNCPA1yAgXFIPl/MMWavJcO2C6etKNO+V+8Jhv+LOzPdA8hCrqa7ns
         1/C9AyDX081lwDlxvZ1Gk6fcGR4BFcUQwkhi/Z5rpJCaAqws31zBhaPH4CHdNiGb4/Xc
         oS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710891464; x=1711496264;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2BQYED8UdIX4uXMBBv0eqd6iCC9NP8lqwvKp2Bu9xxU=;
        b=hZJtIBT4CV0Zfr6RONehczD1tb8Gz+h9C9CJAH4pQcLr2x8aYYYc6ShZcx3f6qDpjq
         8ZNinpcOSrmjpoaE/Fe+cQCOL1ewLdnn43F0bbKczm8qjQfKb+0IH+kaJOxqcJgMm2aG
         p5jT2sjwtLlboWINtLqtej5vYizhbP+2wIT/aLEtcOYnYfxTr1R26SIcVBcfQzyBt1oo
         qbkqcJh5lh16GMIVaeHXGVZqwegWIH5qHJQdwAaZM/zLTNc6woLn5pFs8K8rSUmSQGPQ
         BlC9u3XNDIR5m2YCqfhvE2cpJ0l5Pk8pd1V3sZ6E8njDVqjdotmULxZXHKdCbED7gChw
         BNHw==
X-Gm-Message-State: AOJu0YzWTqF2m7EwpTfIL9keur68b/vyX16byZJPlzmEKmtuVO1F4KfP
	ad4/zUizfOI0SVNFpBQG/IKp5SkWIx13k87n3mqxzMNfqoJjGKMw54jpiEQEKMBdaEtoX3JFx07
	3
X-Google-Smtp-Source: AGHT+IHinWvi8Ynxo4BO1GwfxsNaJKAtiPPKn+5rFDIC6hY01kwaL6HaxB18jdPnN7ikrXtwM7oS5g==
X-Received: by 2002:a17:902:ce85:b0:1db:f23f:676c with SMTP id f5-20020a170902ce8500b001dbf23f676cmr130438plg.0.1710891463927;
        Tue, 19 Mar 2024 16:37:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b001dddb6c0971sm12119967ple.17.2024.03.19.16.37.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 16:37:43 -0700 (PDT)
Message-ID: <72a3ccac-b97c-4e62-acd7-dc4f306eba50@kernel.dk>
Date: Tue, 19 Mar 2024 17:37:43 -0600
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
Subject: [PATCH] io_uring/alloc_cache: shrink default max entries from 512 to
 128
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In practice, we just need to recycle a few elements for (by far) most
use cases. Shrink the total size down from 512 to 128, which should be
more than plenty.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index bf2fb26a6539..138ad14b0b12 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -4,7 +4,7 @@
 /*
  * Don't allow the cache to grow beyond this size.
  */
-#define IO_ALLOC_CACHE_MAX	512
+#define IO_ALLOC_CACHE_MAX	128
 
 struct io_cache_entry {
 	struct io_wq_work_node node;

-- 
Jens Axboe


