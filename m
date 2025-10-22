Return-Path: <io-uring+bounces-10113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1E2BFCDD5
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27620500F3C
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC62347FC7;
	Wed, 22 Oct 2025 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lh2GNXrc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC934D4C4
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761146787; cv=none; b=fZBR1SqjTvM4h1vwNdW9I3CdjVVnPMBXsN/tA7HTCu0ZejqLhNhY13j0gu00QqwN6qDn7EQ0TflXA8bs0inc/AvMggcBZYDOp+CmjbOUnfFKVZbpQNEz6VouM6k98eF+Ru1sQrd8sSnsvqDp+Fd3hQlG9/9yhGRm+MJF8zGgt8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761146787; c=relaxed/simple;
	bh=LRcyThRZzNKckLx/U80TKVewi3+2BXLCTF+fupxbHx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtF79wM3Ztca3mAgB3eszOb/4I3k0omEfUKFuX2bVIJCbmq7o/Vjsp0e6cBV5XyIw2PMsL1uxl3fX04fS+vOtXP47pfu9J5CiEX05RoaAt4Yg/m0y7UZGLI+YNp/NXUrdvOVwUmhM21tE19xEi/rkS39v2V2CZEFpuGhHXyqjQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lh2GNXrc; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-42e2c336adcso30802975ab.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 08:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761146784; x=1761751584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0hKPkWmq5p2r79ibLmLIZ9MOTurUfR2k5+wgsOoKVJ8=;
        b=lh2GNXrcDYpck0RvhTjPE4CTCzTIra30FPm9AAKEFfsmXQ/gbcLx+5np50yJyUMZR4
         vXv5G8o9YD+nAREWabETYOCArE8s2bwdSCUkgfQc0BWMtLD8kSaIkTZVLkuqWrffIt5S
         Sw+UXGg55H7KGEriyf/JaAX6dEK1bsrO3S57u4n12hSgYGNjnxUO1dIcvaVqr7UTQCvy
         V40omi+Zke+dmVHa7GcCkvofDxQbvYZWPafpiiyGanmuMChybPINDWHK2VjZy+32LyzP
         iT3Yi6Itkq4QSzLKOd9IIZi0JfeyBeQKhh4FXrMOqC1kYYSXLJ54+OQSCSyhb2A8ZA5s
         1Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761146784; x=1761751584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hKPkWmq5p2r79ibLmLIZ9MOTurUfR2k5+wgsOoKVJ8=;
        b=fgbujm3cBCvNHENZj+RrtqqzTATxqrIeXyzzyWpnz5DaJLb2mXPcItI9xz7zHrFqDg
         yuDTXtbhu2CEjNCpTRkK/OUDwLvGYu4PY8WYaCgWnasgRQFITNFiRoTBYnkdO3K4iZmX
         hakwlZIXuJVX6cEDvKeoxbZhidh75ny3h3I2XHwSqgrmzrzt9fBTKiUITr1gulmN7bud
         xK63oDVxg59TAR08LZHk8nGe9yzqz6ZEVVaPo44J14fg7xtkrzKaFfK71yEawL2bNb2Q
         jDcrsA3KPi6kgxXUbfYtPPgZMfwXcBxcd8lzYecxL9L9ui4Hm6e39pgvzoYlk/Es9VeN
         emjQ==
X-Gm-Message-State: AOJu0YzqkPnDiyGa0YRDITNHvs1F8Pwwg9adXG415v6tnKcQ3W7MeGrR
	9JyvSn97zLsXu44uA+TJCfNrw6vQpceJltIZq4Nrbup0BPmEjRvu234G0OqlbKKaI9Y=
X-Gm-Gg: ASbGncubSmd2plcnNPq02e35mYR/LMb6fxClVBNXR7GrTtzHihgdz7vgXxI25Ryhd5o
	505Tk+PF56CTy71zs6UtpfUov9HR1HqDqCdqGJWXgSULS5e8fEw1FG10ftW6u/+zuMldlCfVHU6
	03hsAWHe6OG6CqqC3WU3ulLDiiFUhTjekPpHXsCipZ+zB0lIcEIZZOsvQ82IgkMnOFKLExvxQ7c
	OOYbaoHZQlM7hk9lataVzgPVKogdB+3TakW0DQXOLvCFZA3k+CRb1rMAWRvBV97JVesBjg+tBbc
	SMb++iUsiK9XMqe6xdAT7KBmRszgcX+HO1to3yWEN9QcSYFpfMYfSTKz6W2pt+bpGs7t3Aq+a5l
	VilhY1ssAPASLB/JTp1P7dWCAKdgN95xfBHGNvBESdYz4I8K09nvtVdkY8RNWLY/HnJHu04cRR6
	eoQoPNvPQ=
X-Google-Smtp-Source: AGHT+IH/AJKSnikGo5wNrnUym0lndDFMHlCN0fa2V9GweWa6rnWf9q9FmfmeJXuUbrL+yAPgextAEA==
X-Received: by 2002:a05:6e02:1522:b0:42f:e334:5ec3 with SMTP id e9e14a558f8ab-430c527fc65mr269056205ab.26.1761146783972;
        Wed, 22 Oct 2025 08:26:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a979aa80sm5114331173.64.2025.10.22.08.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:26:23 -0700 (PDT)
Message-ID: <5b78c30d-26de-4e49-9bfa-121c9f40b4e0@kernel.dk>
Date: Wed, 22 Oct 2025 09:26:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: initialize vairable "sqe" to silence build
 warning
To: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev, "kernelci . org bot" <bot@kernelci.org>
References: <20251022150716.2157854-1-mallikarjunst09@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022150716.2157854-1-mallikarjunst09@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 9:07 AM, Mallikarjun Thammanavar wrote:
> clang-17 compiler throws build error when [-Werror,-Wuninitialized] are enabled
> error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]

Already fixed, and as Greg mentioned, this may silence the warning but now it'll
cause a NULL pointer deref instead...

-- 
Jens Axboe


