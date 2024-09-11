Return-Path: <io-uring+bounces-3151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52534975B7D
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812721C21EF3
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266151BB684;
	Wed, 11 Sep 2024 20:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mRtOeuwN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF901BAEF6
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085595; cv=none; b=roy9SqpZY/Q1enhPvBUk56YEJ6fiYOJD03RDl+rQyuzXf67quYfVUhyd8f4RpE4iWCITPPwuE9h490ymNrZRELmDDBdv0LMMK5kmBLzFaW6aHbx2GNOm4LcH6OALG56IjxElca5Fen4jkXOfKbszuAONj0CTQS/g77htyRUho6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085595; c=relaxed/simple;
	bh=HD5k0rZHivMsGNPIioCz6VNien9HKGbb9ifdMZUz+0Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ucxBzbdl2w1FJXAjF+Qf3B5KnGCSYMuFKYa3a5A1OAbPGEwJ4ITijnUeUGNzH6/IpGeE2h1Bg40e3I6WLFKCzh8sMZcjStKD2NFRnLrWd0os8flEsXrlTiHE5MgRUvgTp4LJPuHyzx/hWsVDnpgCod4k0P8W8oTJNhlAKs8fJTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mRtOeuwN; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82d07f32eeaso9038939f.2
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726085591; x=1726690391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WB3D49Otu78GuhVZPkUPorFM+wp9Oud6mLaU6p67Lw=;
        b=mRtOeuwNHW15yvbft1wXc9vwWDcBVMsIFS/7xDfKjhuNeNa4axBjD8A1VP1MjDC1i2
         kJRAhC6z5dQLmUk6AXTSzvY7LP8+AqjAp7fRlqOt/91Q9kXaasPdJ7nSCbM7GXsEi3tp
         3sibOGKXbhMtiHOZnoP7GzlsDLsFJUf+PDX8I7F1/ZuNDQ/1dlimWGjW1pEliCNjOC7B
         akrzUqq3vIZBiEadOGh7CTpiGBAW9y6i8YVGgkoOLy+zvoo44xxJZ09viZ3C4igos7Tx
         Ex6yNkjXVN/2gUGldpLBot+GBSROq/yGQzjarvvONGbyev/o3Bef/AU2QN1JQ68j13yE
         9gIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085591; x=1726690391;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WB3D49Otu78GuhVZPkUPorFM+wp9Oud6mLaU6p67Lw=;
        b=cHPOr3XKGFPlM6J1irLjHZEqkAzl1cuz4P/LaFn2QY7EKKdNxQnutqJBt/HmwVixTF
         6t/6CAqpdqIGR0TpLXP62eE/yE4YtfaMt3TzVAnrbCVe3V/wvQGkqOR+48j2vi3Jlrti
         VHY1uXnvmbTt6aqEpR6b3vAxJwSQYQHQH7FRJf4R00zunf/CJK0UQoecL3SljvDHvDHt
         XDAavl0RoZ+ozpA6SC6JVsfjT0dZYZ8oqDridfP4WE1gjCF+uJUkuUyVKULAUh6aYg2A
         L0IUv0YF1setG+h4Y2C2kjp/D6nIKLT7rLsF/gZiNLMxCUU5MU0o9cW6Fn8MZ0S4oa9v
         dJrg==
X-Gm-Message-State: AOJu0YyS5Y42kDFIVMU9AJEdP+8zvKnWrfNZopWhKvaO79G3iObH5UcQ
	j6kBRHDlpKcodnWJVlyDDPh4A/3JGjNVrzR9dg9KlZPAbMiW/Z7mrFkYx4+WHmfBuQdWec+KiuO
	9m1Q=
X-Google-Smtp-Source: AGHT+IE75C+qDteoU/bOnE4TTdLGy+rEdtwloFkTTWfZl8nVdGST1cwLnS8b2shnVJKtJ/oMhiBFqA==
X-Received: by 2002:a05:6602:13d0:b0:82a:a454:6306 with SMTP id ca18e2360f4ac-82d1f8c7252mr99625839f.1.1726085591622;
        Wed, 11 Sep 2024 13:13:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa736e4a4sm281939339f.28.2024.09.11.13.13.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 13:13:11 -0700 (PDT)
Message-ID: <6154fb38-3d51-446b-a9ff-918133c142b3@kernel.dk>
Date: Wed, 11 Sep 2024 14:13:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Provide more efficient buffer registration
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
References: <20240911200705.392343-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20240911200705.392343-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/24 2:03 PM, Jens Axboe wrote:
> Hi,
> 
> Pretty much what the subject line says, it's about 25k to 40k times
> faster to provide a way to duplicate an existing rings buffer
> registration than it is manually map/pin/register the buffers again
> with a new ring.
> 
> Patch 1 is just a prep patch, patch 2 adds refs to struct
> io_mapped_ubuf, and patch 3 finally adds the register opcode to allow
> a ring to duplicate the registered mappings from one ring to another.
> 
> This came about from discussing overhead from the varnish cache
> project for cases with more dynamic ring/thread creation.

Ignore this one, it was an old version... I'll send a v2 in a bit.

-- 
Jens Axboe


