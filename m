Return-Path: <io-uring+bounces-4648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 702B79C7491
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 250DE1F28C87
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 14:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5042517B401;
	Wed, 13 Nov 2024 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MSddMbKS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B3208A7
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731508778; cv=none; b=Z18SgC2zbBHTNHCO7ETirIXykvPxU13EgsV+g6bapKYjvwFAhiQ0Ny/2kGgmumfL9lIoAogvJpfR2ET286PVu0G02XVPkR+Pz8Z9kK4GiXKSrk7tsWuT/3JvrhpPY/DBiMX78bR8qxg3uyi9Zyqe4PSekRMTl208h5Hxw/fwYDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731508778; c=relaxed/simple;
	bh=DMJLPwoNou7jtBEPug55HGDKK7bUxdP5bG+2X1PZ1ME=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NmGMsQmuxY+65XbPV0ysOR6CjnLjbqqGxvxs8kvzOimkPjNgDubRhEFvy7lOgojyfYzC1FAZKffeltBNUgALQsFTTzJe0GcD2XDbjyQu+vzPa4pNOz54+8tNBXbzHS9C2hamb/rZu9Oy6rv/Hnf4wi8MFiHzbWCBsTt6uIvw6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MSddMbKS; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3e607556c83so4238175b6e.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 06:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731508774; x=1732113574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2j1IHl1RQBGudX7hE1go+XS8Iwq1voc0rhYOPUUkNT0=;
        b=MSddMbKS1QOLjSQv2tEj1F+B5XNPF2jZcAAyiW1RWd1NNS5/86Bw0Oi84a6/i/PIOG
         E3ol6PU1aR5mCL5QNF0ELyda2IB2UWNMfav82/loC2CiyhOWZ8Ft5qw/qUhaxv8bv4fm
         Hvf+4I9rdviIR6BJPqgGsw4RW0qGAPvycxHjzYwRK5Ev8YafDgRcCZG5NOwL54iKXMKi
         OPLj7/JIVo7CoiSKwC3EG/T1TD/Qmr1XIBOojsiQ//37Niqffe2j/DvqIcTHW+fPyVQQ
         4QbhrIoUHd8TV8+XPBLDeUZYOomgrp2KkoDUa+Ewjvvf5yIiQ/q3D63pQKJ4rdok/jgF
         f+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731508774; x=1732113574;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2j1IHl1RQBGudX7hE1go+XS8Iwq1voc0rhYOPUUkNT0=;
        b=GwmTaE5DDKxXZbQPt3/xbG9n+cjv1s3ctEyTkwUr0+tLQGnbVTpWtOaU7pqHXrBO+l
         rLW7UDyunmPH9jTbSM5ZoWJUv5l6TnlGJuPYVzVZ/lSBWO/jnswwRVcedCjrAk+SfHFB
         3KK3+GHipjDRJz6OFshd4yR1lHslTGjZkxOl9AgfAwRTikAsSGUELJGxfGljd2nHFT5M
         xIMFNHJBmYwWEnZ90qpblljQKAEYdRDThq50KgeKEU/PE8fiU+ilCR4zd7XH4jEi6Pld
         OCeRO81tq0+4V9DHJJE1Ea4gam5g5i+vjr2wnLCEo3tLxgdwJEespjWUqhpi3GaQ6Ua0
         ZdFg==
X-Gm-Message-State: AOJu0YzZBtdX10dkCJ/7MnO0EQibiqvoibbAzpuHNqiatV1TCccNBmAg
	N2nsGWYWpV5exlAanZaMFIBux2du8OksSXd9nWTMzWw+KAcx67NB2ez5wj7aH0I=
X-Google-Smtp-Source: AGHT+IG0EF9FQ+Vn1bQ+Bkj3lWJYTkwC5oHh6zDJTtFNePV+7ehiT0KCBI3J1JIzmcSWnKnT6V6VRg==
X-Received: by 2002:a05:6808:2209:b0:3e6:3cdd:b3d1 with SMTP id 5614622812f47-3e794699eedmr17348575b6e.16.1731508774270;
        Wed, 13 Nov 2024 06:39:34 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5ee494fb095sm2934741eaf.6.2024.11.13.06.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 06:39:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: xue01.he@samsung.com
In-Reply-To: <b57f2608088020501d352fcdeebdb949e281d65b.1731468230.git.asml.silence@gmail.com>
References: <b57f2608088020501d352fcdeebdb949e281d65b.1731468230.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix invalid hybrid polling ctx leaks
Message-Id: <173150877277.2234297.71038530080940657.b4-ty@kernel.dk>
Date: Wed, 13 Nov 2024 07:39:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Wed, 13 Nov 2024 03:26:01 +0000, Pavel Begunkov wrote:
> It has already allocated the ctx by the point where it checks the hybrid
> poll configuration, plain return leaks the memory.
> 
> 

Applied, thanks!

[1/1] io_uring: fix invalid hybrid polling ctx leaks
      commit: b9d69371e8fa90fa3ab100f4fcb4815b13b3673a

Best regards,
-- 
Jens Axboe




