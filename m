Return-Path: <io-uring+bounces-6619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2EAA3FE88
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 19:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE182175C32
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4002505D0;
	Fri, 21 Feb 2025 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsTCZITu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077753AC;
	Fri, 21 Feb 2025 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740161676; cv=none; b=pqdK76xYWm0k5R/DJxAdSps4jAxEDSQif1aigRhorEYx6S8RTibQe0Y0DWSxl1kt2VWItGmXr78JWZUdgQZD3AKfDdKDFrgsQ2ut7B4feexXDhUch0XxroXS4r4eriD2p/ELZN8Ep+A1Rp3+joNdoR6Qr0FkksuYyipIvdOoOls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740161676; c=relaxed/simple;
	bh=HSH5qzrSGTHrY9ISSbPxVOXxkHRL0OZSbE8/aDvkAJ8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ndS+Bvs3DprcZUo8bSUn3lIMhThKKSS8u9fKh5V5WyVJ99NmxPV3TASV7B4mMPaAwBHvDPIFZbDK2dCnaN23oaeQZi2pgdhoVW4uQILgNCKl3Lclzw5mDFsJ1rbsHDWXZNBO7mT/yZ0uEcYh/spgc6+s2gVl64beRiobTz3Zk3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lsTCZITu; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5fc016cbbe8so1398022eaf.0;
        Fri, 21 Feb 2025 10:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740161674; x=1740766474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u6CRfnUjB0eZfb0Gmcq7tLrNe2JUmdux46QRbwYNXpo=;
        b=lsTCZITuBaFzoNa83uIV+LRs94qAl0viSFojTzVPz8QKXJuK6koKJTd+rZJAjLQars
         eaKFSuNMicKIh2EQohlXzYW6FCqh04w45BiJgbkOLE99LfFCw6FvE8yImwlWufbTI1Wl
         gOJ37dB77ID7h4w4TGCU3C3zbDjLxZ10H63ZfOYBA/1LvmwLS3tdx4a29J2nKIGUzOcY
         pCuUXDNKShh5LwhuPejqfUn1rRS2nZ6jZ6zZvT7QPbuPxnMzOcvSaciWtWyibw4e/9Yv
         GJmyKInUpYC2Tc1Olg2PIFkUiH12+VMf9w1taM1z6NxBndlItRAKwN1ej1zFB87sYC9l
         Q1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740161674; x=1740766474;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6CRfnUjB0eZfb0Gmcq7tLrNe2JUmdux46QRbwYNXpo=;
        b=G+ZgskXGda5U9CdEJyDKCsrbT7KdSrFMG9MCRGwrxHcEfF2KIValKXHIXg4rIG/yzn
         DVWBVOOyYEeJ2psx964V80ssSIL0a0ETHxFPpVfy4SGM40fAAtWZ3hbky99Qi3XoiyUJ
         OwILry0a3GSGeS685Bq+//sJ2gi6PcSvA+ZI82151DLCzC9fOQDopK6QUIiaDyOM9CJV
         26xtCaEFhbkhiflCyVedxtLfAUp2RUwuB9nv1SKm1jS6ML9Te/TBp+wu6bV/VSMb/U71
         nSwrxnK8d0Eujh+UH7EPqD5KFggM9uTcJu40qGfkv/nt8zkV9UQDXfYHYAZq4cQsOTjA
         FwGA==
X-Forwarded-Encrypted: i=1; AJvYcCVzjOlc6O+iFMVaKCJDqZBTaYPJupgg1qN/r/I0vZBROXhIUYLepMWMtHbqnR7btPvBEWvtyvN37UBHTOW7@vger.kernel.org, AJvYcCW4U+dAzTYK4YEfw2PMcdFDEX5lEhYRqkUMRjNmzSohOb24HYjaM3vVZi6FYxNPAdU/I5a62RQBNUWSJ9hI2w==@vger.kernel.org, AJvYcCX0Z/PHFNZ/HQ7jUcqzWLTwfRvyxjI0vzhVyk3TjcpYLwUpX6I9aWjEyQ6CNCXDrXO7v9ubJNFfnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwikF1QbBFY1ZN41e/UMviWfeTYeIhI/x0cbK8fQK1rsstfe1YM
	Rss0hjdgp3BBtqe0LE/3sdGLtzq8fhV480FNGRKqCaXhzjTn57kDr7YHE80Xp3w=
X-Gm-Gg: ASbGnctsluPXTwzhnytfSRpcnQxdyyLn2QiglADYLU4Z5OLYuWDaqzXFTzD+OQYyStC
	hZvd3qOio/6H5LtCQQiNX+sQ3JpFm69DByfgTpBEYMzrvoVQaupgzRBs5/QB+OywfOKZTuxEu5y
	RIBYscRt45Lr7BRxaocisezTtJL1z057HMD5v8Jb9NxKqyh+vpAKpzEA4qL9IKvtHjKv3xjiusy
	q/5O+G5MPLcaMPAXha1OSui1QUvJb3im/Ztud0u2W95C0lktDyQMdjQQpsZoXA4JkU4LCQH4uh+
	fASiZcnDyUi7nsJlG6QMRAn7uSDKqRkVPKGKj5+rvxlehskRuKYzgWusFXmDo33yX8RU1HZYsUo
	PYMev133gQg5R8UQ6pl4=
X-Google-Smtp-Source: AGHT+IE169sIyHtEKqT02FuRHlGY4p/TmdjYNQmliPaHlKB4khYMS73I6vHGeqlu1BtIsNZPqMYlKQ==
X-Received: by 2002:a05:6820:260d:b0:5fc:92b3:2b03 with SMTP id 006d021491bc7-5fd1949807fmr3219809eaf.1.1740161673711;
        Fri, 21 Feb 2025 10:14:33 -0800 (PST)
Received: from ?IPV6:2600:1702:4eb1:8c10:3167:4d82:8858:3dfb? ([2600:1702:4eb1:8c10:3167:4d82:8858:3dfb])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fd046ef5adsm1165647eaf.15.2025.02.21.10.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 10:14:32 -0800 (PST)
Message-ID: <36f0a3fe-5a5c-46f2-84ae-d08c0f68cea3@gmail.com>
Date: Fri, 21 Feb 2025 12:14:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
From: Moinak Bhattacharyya <moinakb001@gmail.com>
To: Bernd Schubert <bernd@bsbernd.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
 <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
Content-Language: en-US
In-Reply-To: <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

s/liburing/libfuse/

On 2/21/25 12:13 PM, Moinak Bhattacharyya wrote:
> I don't have the modifications to libfuse. What tree are you using for 
> the uring modifications? I dont see any uring patches on the latest 
> master liburing.
>>> It is possible, for example set FOPEN_PASSTHROUGH_FD to
>>> interpret backing_id as backing_fd, but note that in the current
>>> implementation of passthrough_hp, not every open does
>>> fuse_passthrough_open().
>>> The non-first open of an inode uses a backing_id stashed in inode,
>>> from the first open so we'd need different server logic depending on
>>> the commands channel, which is not nice.
> I wonder if we can just require URING registered FDs (using 
> IORING_REGISTER_FILES). I think io_uring does checks on the file 
> permissions when the FD is registered.


