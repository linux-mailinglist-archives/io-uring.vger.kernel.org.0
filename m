Return-Path: <io-uring+bounces-1694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4624C8B8049
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 21:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74F721C224EC
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 19:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C522184122;
	Tue, 30 Apr 2024 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="btMH2YTN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B94184136
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714504009; cv=none; b=lKaKFJ1t8eh3hrXkESR+ZAaD8vDvQElNtQbYfvdRxxq/cDe+JWYRe44npdrs0rhiPYc3N78KQbaZBg6wnYHR+H/PRHGJYu09eAaUkbSoirLCgQ0hvJ8o+82tvcdT2231iON3rA5jNGNIzmGM+60LJnhLkS+9WgvvVgHHOeHpGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714504009; c=relaxed/simple;
	bh=kqCpqVD3fKPawSAe4eCQG6scfO9gN9QcxUVAHtPb8GM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jCCOW4ff/nzI9BZU7axq7m2gmBsC6A32ptY5MEmY2J6uNd/i8Yw5aU5sOMS2hCq//nilehvHmAcZkZUgoOFekI8H6gchWlFkxwZ+v6AFXvjJE/J1V5rnROdn9CdaIr1Ph6dLqwdJfIMlwFnmkNj/s+f82vC9lH3YzLV3NRhGW9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=btMH2YTN; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7dee034225eso8058039f.2
        for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 12:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714504008; x=1715108808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B6aQbt9j4alf3zYqcjnQFCjLTd04ILNOyprtbEPvcog=;
        b=btMH2YTNZAWw9qH9egTI5ezKIxUXZ89groZBcGcSh1MWQVS3Yh2BJUGaT9XkgUzIZb
         BpvxmX4ExiTYged+nZZz5DTR8+Q0ETGDFENO1oXABlNJuniUBtXm83F8808ufFOMjzWg
         Aq8VKNZNRupgX8xsNX9kcq/fgX+f8u56iwWRl1nIwyRPu1zBGTHtMR1Nt01dVTymjV8C
         vwRbjGVqJa2PY4/FuCW69QrtqWXJzuzZJ7OnuIGv1jhNOIBIGHpAuW4RDA6zyKZ77WiJ
         ncQnhfZSC1xK+vdfQgnRxTwwxVt8jaVUS7nke+6c6NYrQOQY4rzAY4/rdrvBf6ydHEUo
         0RuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714504008; x=1715108808;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6aQbt9j4alf3zYqcjnQFCjLTd04ILNOyprtbEPvcog=;
        b=HEbBQzbKf8rANdG5WzJolNJgu9TkOuzBap005EXS0yAVl/HHuGH19nRa2ppdyALaGA
         RtUAGn0hVLf4SPIzY14RaU2ZavLVZhvluBtlvxVIn29QoKmE2D1IbrWBtbcUWoyAQono
         78ax4ejXI8yhoUwKUF7PEnh3RhB1q7EKGz7OfVzcCggr0gFhidKTXymdIgdf4Xis1KMH
         J2f1Z6AVbiA0rsesLGUlElB/7fayr2PdvaCxL8VUQbbJ+960KmHdrk0Dbhj6OJ3r+dj8
         LdIgY/RnSX/lgf4KbvGVZVghaON31NE6oa6Fpp24MYcP2qnVddOb9mtg+476Y8DvocU5
         JPXA==
X-Gm-Message-State: AOJu0YwHkM2MFOMkxusennT4WgoznHHJuqu1k57YLlaaffxWICpve/mZ
	4AIqZyaiW/6sPqhYv0RmeZ/Vn+nADkylDuhfCElHL/BKfs6OHUMaH2s1XV9RzTX6G9f1Byp0KxU
	F
X-Google-Smtp-Source: AGHT+IF8omNTVmPX5/d2qlpmFblnyKUM1Uupe7G/5/0uagGeUlcvjgFbJzmqQsbicPIeafZhZYIp9A==
X-Received: by 2002:a05:6602:168f:b0:7de:dc52:18b6 with SMTP id s15-20020a056602168f00b007dedc5218b6mr931792iow.2.1714504007707;
        Tue, 30 Apr 2024 12:06:47 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id bm14-20020a05663842ce00b004880d1a7b0esm81597jab.16.2024.04.30.12.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 12:06:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1714488419.git.asml.silence@gmail.com>
References: <cover.1714488419.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] LAZY_WAKE misuse fixes
Message-Id: <171450400653.20246.16760152045958444437.b4-ty@kernel.dk>
Date: Tue, 30 Apr 2024 13:06:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 30 Apr 2024 16:42:29 +0100, Pavel Begunkov wrote:
> LAZY_WAKE can't be used with requests for which users expect >1 CQE,
> otherwise wait(nr=2) may get stuck waiting for a tw that will never
> arrive. Fix up invalid use of LAZY_WAKE with sendzc.
> 
> Pavel Begunkov (2):
>   io_uring/net: fix sendzc lazy wake polling
>   io_uring/notif: disable LAZY_WAKE for linked notifs
> 
> [...]

Applied, thanks!

[1/2] io_uring/net: fix sendzc lazy wake polling
      commit: ef42b85a5609cd822ca0a68dd2bef2b12b5d1ca3
[2/2] io_uring/notif: disable LAZY_WAKE for linked notifs
      commit: 19352a1d395424b5f8c03289a85fbd6622d6601a

Best regards,
-- 
Jens Axboe




