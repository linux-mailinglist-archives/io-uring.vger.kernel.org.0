Return-Path: <io-uring+bounces-6172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1BEA21490
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 23:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F62F3A8958
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 22:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4081DF731;
	Tue, 28 Jan 2025 22:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O/lQEL3w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857B8199249
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 22:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738104144; cv=none; b=cV4Rp3uqPSvH/7paKV2fJUywaW0iKECm6WnBYvU4b6JPFuTG8HjUa/WEzAwdrs5f0NS8aA9dNESQ/+2xx1jxppTXUeAhOxsBdZbPrzYBvsrbLdxhyIyIMVZORdCM8BEFp31OOv/EyElANlIcclEbL0vs1AvLiGO44gsk7iOV8v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738104144; c=relaxed/simple;
	bh=L4XBHvNDQ7sCCJNrX+RLAu3zkY1R3ThZPWfV/jjKgqI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uS3lIW06qsUK30VXTyM/SM2ETxD/Rt7PmRQ+Hv+IacRIyP3PdM7+PzXJcMIzKz+dmm/RQMYrc1u4yIRpwGtlHTP0cKcGywfbbKq+DNFnHf+CfiT1Nqw6yH8Y0CAbsNkoGDewXQGOO0mRe1iTjfI+cYCjOLmHiiced8ByJilSxBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O/lQEL3w; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844e1020253so162993239f.3
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 14:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738104140; x=1738708940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDr7mvA6qXuI8ecd2hGGyikjS3j70t0C4vorISC6PkA=;
        b=O/lQEL3wCtMDnOyprCiue0eBBOZsj0j1UcwXUwnfOBGce1CO+rneuwH96SnHRcRpYn
         DjEc/XACEQ3qVAiKlJS/VHFsj8dBOUYCyC/DOcxb0vWROT/qeMrZn63CSgxzKNIddL97
         TAtje58QhXIdUP+yzrLvp2V8nrTwei2iB3WQ15WMtvUGmWAXT7B4nsHKpNK3aLKgT3M1
         EYb0IKyT9Zf9Ugi89aY/3xesmb6NBaoDP74touXb9XsFKYHHap1vmk7KQA0ggU1T4b5v
         qjFUdKjwv71hoz/3whEq+1rHxrNrEVWie8ToExUn5V/AU724QL+I7ovaJMc1HBeE73HL
         x7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738104140; x=1738708940;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDr7mvA6qXuI8ecd2hGGyikjS3j70t0C4vorISC6PkA=;
        b=vZ4Mr+FXlQrUHohhRpfPuvkS+Gq40/f6RqVnYfjTplqC1T2mF6LS5w0KLquTugdl1K
         FBlMFtNIGIfeA2+6bF+LznPOFDNSzGISaBEzQBrvjqkUmQh/zvH2eggA/oFrvvDVspPQ
         mn3uzEHnQAZcWGX46NSIrg1rglW/pSLqD8MWK96NgIFRknkBOt4JlaHtlZwSxHVqWYZT
         YE8mGMx+crEo2QcVyfkrCSzTMjLcLfeKR689PX+csWxQndcyGRJfUDPEj4ggxchiLU6o
         2t+VsWWdGDhYSmjEzLJEv70GWAKOsoMGzMELN+7gxh0qxVqX8+lDjl40Km5ToRK6xAoi
         TLow==
X-Gm-Message-State: AOJu0YzRP045/+CdavxGWPicci1mQL1MUxkcwKsKs0GemAfmPjV7N69g
	EM26UYlQWsbvsJrsX1MUU2XFdcNvAN4BPvn1omGI2/fM0FjfCLLvomxB+Yi812cirH0e+8B6pOI
	8
X-Gm-Gg: ASbGncvg5tWDDXj+ds2u+Qa6CRgfODkfKgSkyUgsVZfreRw0z9Rc79zv7nPqmFjveF8
	spUKBXi46uOuJ1CHS2NzLhzlXyZ1VSo1RWmyIgTdANLag20RXRxgysJNKBaKmX3XkO8CaklztL0
	hAICnAZELFJxMknqJ45pII6Bh6YQwub+z6EcUtAAzJ5H3yZHvxXu+T4ORwQvPKn7J4F32IM6zBC
	ae4QQAdtLcvZV6ha8FPPsANgN778YicQ3vXDnw/tgnpTBkHmT6uvG+A/k5rI4j8WnqBAx4l2Ltf
	0Ko6g2g=
X-Google-Smtp-Source: AGHT+IFrGFDRkWyRK1Ll0AnPaEVaK867BtHc9qVzSx1uv/YqV3BeyEbYOlQn7ORdlsLfs2GDXs9Bpw==
X-Received: by 2002:a05:6602:358e:b0:847:5b61:63b2 with SMTP id ca18e2360f4ac-85427e0a829mr109523339f.12.1738104139951;
        Tue, 28 Jan 2025 14:42:19 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da4d013sm3394145173.74.2025.01.28.14.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 14:42:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/8] alloc cache and iovec assorted cleanups
Message-Id: <173810413927.69132.17593138906559835044.b4-ty@kernel.dk>
Date: Tue, 28 Jan 2025 15:42:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 28 Jan 2025 20:56:08 +0000, Pavel Begunkov wrote:
> A bunch of patches cleaning allocation caches and various bits
> related to io vectors.
> 
> Pavel Begunkov (8):
>   io_uring: include all deps for alloc_cache.h
>   io_uring: dont ifdef io_alloc_cache_kasan()
>   io_uring: add alloc_cache.c
>   io_uring/net: make io_net_vec_assign() return void
>   io_uring/net: clean io_msg_copy_hdr()
>   io_uring/net: extract io_send_select_buffer()
>   io_uring: remove !KASAN guards from cache free
>   io_uring/rw: simplify io_rw_recycle()
> 
> [...]

Applied, thanks!

[1/8] io_uring: include all deps for alloc_cache.h
      commit: 299276502d41cd86376f47b7e087d017eaa0f914
[2/8] io_uring: dont ifdef io_alloc_cache_kasan()
      commit: 16ac51a0a7aa051fd3b82fa077597488b5572d41
[3/8] io_uring: add alloc_cache.c
      commit: d19af0e9366298aa60afc0fb51ffcbd6205edcee
[4/8] io_uring/net: make io_net_vec_assign() return void
      commit: fefcb0dcd02fd34f808e91b13ce25f9847e52eb9
[5/8] io_uring/net: clean io_msg_copy_hdr()
      commit: 2b350f756b7acf84afab31d65ce6e3d496213ae5
[6/8] io_uring/net: extract io_send_select_buffer()
      commit: 86e62354eef16993834be5bd218d38ec96c47f16
[7/8] io_uring: remove !KASAN guards from cache free
      commit: 0d124578fed92cadeaca47d734da782beacdc1a7
[8/8] io_uring/rw: simplify io_rw_recycle()
      commit: d1fdab8c06791945d9454fb430951533eba9e175

Best regards,
-- 
Jens Axboe




