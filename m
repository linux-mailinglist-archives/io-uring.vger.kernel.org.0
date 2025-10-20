Return-Path: <io-uring+bounces-10068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE3DBF27A9
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 18:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9BD004F8786
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 16:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC853176F4;
	Mon, 20 Oct 2025 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l1c9v8Gt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA02F83AE
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978322; cv=none; b=KSgMmvlZJf2Fs4z7I64fMKQWMh184it6bMNBX2qiXacJb1i9/nuHI41m5AaGRS1HnKV9mCPAkBRWBg2/LeSd2Mo51lUwXA7lAbeIcZvtrsa+Ki9I3AyzWT/cdkYO0ODKqFjxttGtqEGr42n/mu48afbb/5sQm8WHspC37UU3wWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978322; c=relaxed/simple;
	bh=CTDuOdRoTTDCj2wNldASjkqmJbodamVmcr+myRXeFqU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VbD3jPDXw2L65GRyUEa5w1eSnuro1wriPpWPi1QqP87W2HZfUJNNQq5Cjl0/tIyzzjoLyseuzGtaJsaB3sTkg+JF3dCM3t0i+ogadG2lzs11iF8kcmmnNx8nvjgSseV+U5SIXZGf7lAIzWUkZfArEE8ooDVTSpwsP9zs+WtZq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l1c9v8Gt; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-940dbb1e343so43847339f.0
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 09:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760978317; x=1761583117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sDKE/HxnQ8H0e5AkFg2hbWmhwYRf/lotLiH+0SN8Es=;
        b=l1c9v8GtI2EBfGQ082XxLtt5sjdVwmB4viqeD+5r0oNHcTt4HHBy4kY/1b6w+kRrpI
         IS2nCNKS1h34MQSKQIMU/1M/dtVIxA1az1LPz8vKiUkpzQuKpHhx0N6W12lMDteJtzIv
         lNkr8kPsAaMzPSqAX0vx+gClUf4YPwLQaBviUSFsHkFLE2LlG9m4z0xZYqQrgTrHIxTG
         7my3HwzzPMrWi4AgyXTKhTxNdEDusUbaUZJQtbPKPAY28WYVhLvs4+AfKrGS39aT4McK
         VEEPpDP0vCWsYd9Io9gQ/FJt/t83y+2Yq4fd5SnMGxeolxtzmfv3MRDtm/3Z8Xy7toCX
         UNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978317; x=1761583117;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sDKE/HxnQ8H0e5AkFg2hbWmhwYRf/lotLiH+0SN8Es=;
        b=OBgtIE/NMPdNpr7A6MqqnMrVboj42nbddTVUMOd8oy106MkQRcTQ1wO3FErsepaBKx
         /ZKtRL66Zswbr71eJ1aLpoIAs0ilhsC3/RHHRnFqBQi3UypD/41ZxYmL2jrEHg06OFgS
         56eNXD5HPCzh2l/RKqRR2sZljjPi9ME/5CJbtwRW8rGYnnmDGX96D7BoJB1ZQ9HpbOQe
         EcT/dhSpmDiR3Phore6cM00PChhl5NJ+HtyjWwVdWjGBXeGsRjQpRA/IWYkSpyHeQ43m
         hnJNbON26jE2xuzOJjpToDpIvotecKyvjzhNhCfgvvZjcXVjVo5r+wp5OG1lnBVzZG24
         Ujkw==
X-Gm-Message-State: AOJu0Yz3w2DxQur3SgNrPixi7jlCv4qklzL3gspZJgNl2FBcyHN3IT+N
	jz1M09OTfQGsdNyOxgniCf8n+O9dDOeXa6/vFVnsnY94K17y8ydJTWKjkymjWpbD1ZGKaSMP6+T
	1wTUFrUY=
X-Gm-Gg: ASbGncv2H7FIcUxcm7Hr4YKFgyLQJU36u1RWKlYEdPcUwvZtw8ie1duPSkxANH0iCNK
	6ZpuxTk/O1ADTtMs5O9rFkp68AaseyoAxZ7jwkU66Tq/qZzziaiX6gJzVKo+edNhoXFmxy4obuZ
	vnpB7b1MJ7NfkyVWzg3xB3OpJ1vsUjq/SC+YlfdosK+JbIQoZ5gi7xMAjEM0Ve0q44iDQl3A6ED
	B1rEfvhiavCYSy72yd0gXwhI2dY6890FmdkNaQ5Cc+znh6UooCcI8Lxg8ZPcWQot+/9rai4k2Re
	f8MeKWjuXvgDiGDteZyzZ6ajGshJc8BNuXLvGiOvBmWyQ47M+253072g/z7VZxngqknOuT6i0oV
	M0ICmk91w4o2M0ShmJaqoMUcZUkaMWe+EPsmFPcDUV1S/2xU1grFbWUGjJ1sZSwLFyNHRrLc08K
	srbg==
X-Google-Smtp-Source: AGHT+IFwjAsF5c62mnQ6bLn+3VQ2TxUaSf5GMVLLXqj7FRggZ2zG9zFrIS7ryghfMoOexXYpLAidgg==
X-Received: by 2002:a05:6e02:154a:b0:42f:a6b7:922b with SMTP id e9e14a558f8ab-430b42f1f24mr238365035ab.7.1760978317486;
        Mon, 20 Oct 2025 09:38:37 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a97909edsm3088855173.57.2025.10.20.09.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 09:38:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] random region / rings cleanups
Message-Id: <176097831629.27956.10207214403028288484.b4-ty@kernel.dk>
Date: Mon, 20 Oct 2025 10:38:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 16 Oct 2025 14:23:16 +0100, Pavel Begunkov wrote:
> Random stuff that will my future changes simpler but flushing it out
> as it looks like a fine cleanup series. It also replaces
> io_create_region_mmap_safe() calls with non-mmap version where
> it's possible, and removes the helper in Patch 7 while handling
> io_register_mem_region() a bit more gracefully.
> 
> Pavel Begunkov (7):
>   io_uring: deduplicate array_size in io_allocate_scq_urings
>   io_uring: sanity check sizes before attempting allocation
>   io_uring: use no mmap safe region helpers on resizing
>   io_uring: remove extra args from io_register_free_rings
>   io_uring: don't free never created regions
>   io_uring/kbuf: use io_create_region for kbuf creation
>   io_uring: only publish fully handled mem region
> 
> [...]

Applied, thanks!

[1/7] io_uring: deduplicate array_size in io_allocate_scq_urings
      commit: 12aced0a551e18f2162091e388c3a36ea75ccb13
[2/7] io_uring: sanity check sizes before attempting allocation
      commit: 284306f6e6045e3f7b932914d1368df90033e87e
[3/7] io_uring: use no mmap safe region helpers on resizing
      commit: 4c53e392a194f2bb37403a5b9bcf8e77401234cc
[4/7] io_uring: remove extra args from io_register_free_rings
      commit: 0c89dbbcadf126920e6f9ebfa64e2538af84fef3
[5/7] io_uring: don't free never created regions
      commit: 6e9752977caa47c200f88d7df1ff114955a03bad
[6/7] io_uring/kbuf: use io_create_region for kbuf creation
      commit: dec10a1ad1d5f9d46e7f6e7c8b414a805e00717c
[7/7] io_uring: only publish fully handled mem region
      commit: 5b6d8a032e807c48a843fb81d9e3d74391f731ea

Best regards,
-- 
Jens Axboe




