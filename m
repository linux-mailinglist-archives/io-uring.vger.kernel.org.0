Return-Path: <io-uring+bounces-8622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22317AFD5E0
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 20:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB1C13AE7FE
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 18:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032F921A92F;
	Tue,  8 Jul 2025 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GeUAyRbX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E272E762C
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997624; cv=none; b=SPvmCbHy/EylbPSqTOiNau0Fv+cIqvtgpxEooPuBVO26+TpcWcwrdm0BRLxT+C5Ma4OY2aTPy89kbDQUOMO0NgVPLiC3wtjDtCCGAqFZhrT1JWlrz4jn5iW/OJlcT2ejfvX+wlU0nwZG4nh9bPjUkn29zSqP9eC4CkH/LMESJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997624; c=relaxed/simple;
	bh=rCBhpKjv1f2KIm5q4qurc8E90xbqUc6S32DDYtDWYFo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=C5E5TylahXQz5SIBjxANFZWWK9XljosJGl8ubD6+MgFMLP6e+ahHnNIQwtaDfDXs2731fskphij2acPeTPqOvDjnAwXIf2DAcCTRFS7hYhRxPqIni2QcGAgpUqz3qx+fMMfYtk9GKHr8fjRYF95neBX2oqm9UloxWx2BIVmWiNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GeUAyRbX; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86d029e2bdeso5639239f.1
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 11:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751997619; x=1752602419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbCpSHeXG+vUyluJ776oPNZrFehgq8aY2PjMYQYkZcU=;
        b=GeUAyRbXCcA6qI54KDIKP8AS7Y7TPU4Ty10RMJI24kCrE1Z6oRvr/XNRx7fxGJfb/F
         YPoqEh7F9bL/sEX0Tm84y/Hl30MwMt9OMxUNUE1bzMz1xiVZYeHXnWoCn2bdeU7Uafko
         rv5H5j/E4G1003RAu1jxCLYwrTV/bK059vM+NUntb2Vm1Pu7hynHk4HfLyMP9ku6aKap
         l/nyQlwyRNZAy0pB1qyS8DiVlKfF4490yY0CVfMotkqhQdTWQKu39ISzAH/jeRe95QGv
         oVy/Um50se3V2RwK/hA/ER/q7MG4diwFDATiRP4UlnKOhs7Ne96YFzBwAtoEm67hIrF0
         LYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751997619; x=1752602419;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbCpSHeXG+vUyluJ776oPNZrFehgq8aY2PjMYQYkZcU=;
        b=oVKgfA4/miZdH2eamppd2BDmdgiJ7GXsXVhBEmNpHzov/VU74tffnwTU+J+PqoQmaK
         dbILeRiUYJDznBgem21h9nbbbRwHUaeqKsGoVr3q51ROyBIqE+paAvU9jkLeyU7aToPt
         2zyDJOui7bNxrcFwQcKY3adKXAYAJdTBxHZ0nupqYRVRLu3Ux6QqcbfsAcR/faJ+gRiv
         Xe8cT7Z92BGzLVnDLlCULGove+jNnxDcC3Js02IOPtj70+dFYloqPNfZ41poNBky28YU
         sTm+SwdCshoWunH6+KBtjQzSPI51jaOBduKSgbDexOHbiHPRIqqblVOucCAEPx9vFf21
         vb4Q==
X-Gm-Message-State: AOJu0YzvwF1BaA3Vz90SIAnloJCkbedyU40w+lXTOWJAdE0+bGJ5U/vs
	YRDO/p+Qw/FD5/xYJxQoo5bzwtVpm0gsXkW8YuNc3JOLsXTqR8MOAzXFPMgJHwG+mtWN3EgQzkD
	eUNym
X-Gm-Gg: ASbGncs74iByeKfLDBNlMAt+FxxoKCR83ganEn2ss96kgJZC3aO9KSc5S1mXXytAmr+
	qbcN47vNLdQKmVQ2ljZ1nVQjnr5dwdidQMj4yySwelTS8w7UckmPdG3xSrGC/uzukzWajNF17oB
	QMeTXXXcSf9lchkuWAG2+4myHsahF7q+qsk+whcpjDXBZz38r9aVa7WS683udwXBV+Mr18RO/68
	wVpUIKF+tnGfrxWMqo5cYzFw+SOway/4f3MNnszYtGf2Wb80UAg1f2zqoJ8KrZZdacwpG98s0ij
	pbiqKYUnSmDyYGTXd4dWieh4sohIL/K6uKNcqiOKoQfSCwq/G8vT
X-Google-Smtp-Source: AGHT+IHoJExOI73ZX+iz3iWpKFXmWJZ4nuXDNZ20n8JKWhBK9/dsGhsfZiuySkZMk4zlUVuMpzvFtA==
X-Received: by 2002:a5e:dd44:0:b0:876:4204:b63d with SMTP id ca18e2360f4ac-8794c5d5790mr297840539f.8.1751997617718;
        Tue, 08 Jul 2025 11:00:17 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b59c72bbsm2276958173.38.2025.07.08.11.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 11:00:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
Subject: Re: [PATCH v4 0/6] zcrx huge pages support Vol 1
Message-Id: <175199761613.1185853.1372594719643202772.b4-ty@kernel.dk>
Date: Tue, 08 Jul 2025 12:00:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 02 Jul 2025 15:29:03 +0100, Pavel Begunkov wrote:
> Use sgtable as the common format b/w dmabuf and user pages, deduplicate
> dma address propagation handling, and use it to omptimise dma mappings.
> It also prepares it for larger size for NIC pages.
> 
> v4: further restrict kmap fallback length, v3 isn't be generic
>     enough to cover future uses.
> 
> [...]

Applied, thanks!

[1/6] io_uring/zcrx: always pass page to io_zcrx_copy_chunk
      commit: e9a9ddb15b092eb4dc0d34a3e043e73f2510a6b0
[2/6] io_uring/zcrx: return error from io_zcrx_map_area_*
      commit: 06897ddfc523cea415bd139148c5276b8b61b016
[3/6] io_uring/zcrx: introduce io_populate_area_dma
      commit: 54e89a93ef05d1a7c9996ff12e42eeecb4f66697
[4/6] io_uring/zcrx: allocate sgtable for umem areas
      commit: b84621d96ee0221e0bfbf9f477bbec7a5077c464
[5/6] io_uring/zcrx: assert area type in io_zcrx_iov_page
      commit: 1b4dc1ff0a8887c2fbb83a48e87284375ab4b02a
[6/6] io_uring/zcrx: prepare fallback for larger pages
      commit: e67645bb7f3f48e0dd794ca813ede75f61e1b31b

Best regards,
-- 
Jens Axboe




