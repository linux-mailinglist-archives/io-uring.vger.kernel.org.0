Return-Path: <io-uring+bounces-8302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E543AD4373
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 22:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A16B3A5056
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50CE264A77;
	Tue, 10 Jun 2025 20:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qlxma1rE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368A1AF0C8
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585888; cv=none; b=noRdHTJoQCoIeIEVZEjgI1zEGy7DgdEoF+vVkKyvWeDhCZQNZ3WnWMED4kg+iJKxMpp1EjcTMFkhIMQp6LbCsrrwGaCkE7ZsvQdKAwzwXYZjZNo6Y1mmUQxoIlexa2ZeE6ra5f6jRr1n+WrzCo7P0ESLnGuj7EFQoczA7honChU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585888; c=relaxed/simple;
	bh=bLl4sfmdbloKYoV1oO7+4ZYfwJCLBoJIeKinAZvXNTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cG/vYESLfRZqp9rItxqJ8ZtCE4aBIjhNEq4CqDOd5ti7RK55Sw0VOIOKW4kgLAnlYf21j59gfaJae53qtg8rRTnC3KkZgamrxtdUtLL5fj+4RmRMrsQ/PsI3nRmaDnAUtYWN6kHtyDs5BSbeEDCZioct6GZoJh95iwTT2pnYlPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qlxma1rE; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-875b52a09d1so27807939f.0
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 13:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749585882; x=1750190682; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VqQtA4MmKk0w6NnjcEvo7w7mNMeRdsLUpT+FfH57D7E=;
        b=qlxma1rEy9ZL0FcF1SpJyu4qVJuFR/CBai0KDJZm57snpHtjmPJjlG30R9yuFzHjTW
         DnbJTYby9qEjWGoXvBYrtXqT7IBNCewa5oFoAcyN0eGwE6ZrUdfGJifXtjQnvdGig0o0
         opKCxxdILYofTU/aoiXX/zo7UGZ6rz0ve0bmXRAZMBbbWHlYps1kdBNsjmRk6LKUkK+i
         GqQfBRzYH0/beKTciInd2Pm/imy8UN9s2o0dAEoZbU65vnoWAtPjbKpFHNg3lz7q5BLd
         Z3cXZ24LsV3OSmO0ghXpoDLWuc6d0TjVZVJvbiBQygYLmOnJzF/i4liTkT3DpHdp1ZT8
         SJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585882; x=1750190682;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VqQtA4MmKk0w6NnjcEvo7w7mNMeRdsLUpT+FfH57D7E=;
        b=nvohTudjZ9SeOpXzvnwSDiS/WES0OQwbmhcRy6ul/nOOyA93E/L6JK7rTaG/31Tyh+
         MzI0F5ssM/nlxTNxFjSyQpZ4OVk51ATgyvvsRXSMBFwGI5N+9IJE5OFxxj7P1dcwXykx
         SNrHuZFJb6shrbRXVPsznqF6p/rN5VNbeTgGnsEcRoB51cWsCrH1LnkWMqOH5zhbjYr2
         2Dl1qpCDaB7YBCW2Q8g9lxTqxC8GR+cShZqWnIML0PwnviTfepfj+SNohipzkUoByPlS
         FF8cPsmVVD02g7I/9+HqaimO2GpPnSWfo8RY1KDz6BFlxkBG9uyu9FmJntpxhcmC0Mnc
         gUdg==
X-Forwarded-Encrypted: i=1; AJvYcCW+662S6Bh15GPV/wSr2tmnosbzPNL16dK0aXhHQK1We14k9zms8/NdjyfhiT/5oztfFlJkxsgmHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFDx7K0xdWG68AuIfrR6znUnWRct961rKFl88JH6nRKm+7sb5a
	8eg2hKeOtmrxeSfRc9CmJNSJxldKeE4NbymAmQvkICLujtVSWFWEHYy0+0/Gc3cwiXY=
X-Gm-Gg: ASbGnctQFLGNCYZu8bTpho6/fpEj+VmiPeV9Et9KMkJAnu/zXtlrO3qhX1MRxgvmDGj
	PkEcORFjV5Yf8FAOJSNDaOZbHUJdGmB9vzgYCoI7SrdRmxh2twoQqSehsVaaKwmmuidoU4uW511
	gQ1xww2fkFSv+8hr/+EltnShZbyCKCTLV87/1nQ/GxcLumWV2fuDupbuNQ2XCLqn5PouTUnPBL5
	HKZ/G3wChGoDDj2LZJjRZVxa1FYMrhXiwe1e9a06YnVw2Wws8WqlpxK23oXCjvJgbYkgQF0+dnv
	lpZsceAcNBJMhGn/PWGwXTqXRY3IbHiotebEtkIek7nPqnDTOaZDmivNcdM=
X-Google-Smtp-Source: AGHT+IFjnpaLl8kD6SaM0WKJDRkuBVNr3GoDl6wqiW9wqyJYhH2Lk+cg8DvulY2bvA3EwW4FsNUwUQ==
X-Received: by 2002:a05:6602:3719:b0:873:1cc0:ae59 with SMTP id ca18e2360f4ac-875bc3b9c6dmr113697839f.5.1749585882640;
        Tue, 10 Jun 2025 13:04:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5012a90b5acsm61515173.24.2025.06.10.13.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 13:04:42 -0700 (PDT)
Message-ID: <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>
Date: Tue, 10 Jun 2025 14:04:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: consistently use rcu semantics with sqpoll
 thread
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: superman.xpt@gmail.com, Keith Busch <kbusch@kernel.org>
References: <20250610193028.2032495-1-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250610193028.2032495-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 1:30 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> It is already dereferenced with rcu read protection, so it needs to be
> annotated as such, and consistently use rcu helpers for access and
> assignment.

There are some bits in io_uring.c that access it, which probably need
some attention too I think. One of them a bit trickier.

-- 
Jens Axboe


