Return-Path: <io-uring+bounces-730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 295E88676BF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 14:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB9A81F220B0
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 13:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCB87FBAA;
	Mon, 26 Feb 2024 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sfNPcL2v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED821AACC
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708954693; cv=none; b=ptzq6Mr0vg2TVUoBGQBDX7eKGRJPOcQq1heYksGh/PU7Pkf0BFzTMjV0YreJhVo0T0BOWT2+kuIjVIjVZkA6FntxFD72w5Ro98aoFrkxAqf8eEPLVJ/oSLDtibEa+oKPKP6X+ZIh9Cj5LE2zLPVhXGXnIxnW7tcmXRtuhqF4yFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708954693; c=relaxed/simple;
	bh=umU7ozqlX84vE+8ekyhfBNQftPh1b0y1vjKUBvj6HGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXw2zIAKNJO2sm7H87KnrTwdO2At/8F0MMhvWfg/UVgec8vp57dX9dCxmKkyPSozFHuY/fdFQlje8mvmWY0hinTDqJMROQo5obr2ZGOExqlLJbCezJIQVlhQukhaPNpwkqiqDN/DrDlatPRdGz7mqjtYMDfdnUcfdA0Bbri7LaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sfNPcL2v; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso1503567a12.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 05:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708954688; x=1709559488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y29K3a9HmK85XuwdpCfrzTUQd/fHWQnDJ6Znm1786ds=;
        b=sfNPcL2v782O6It/17F8ADutzWoEZ77bmeExo1ILu0Ccf1qj3sBISpqeQRctvZAIRE
         kRbNaac1BoVNZGpP911WIRgPhu66If1J0+fOKuD64KAWDVDmQFYlogs+6NhqDgXpOBgo
         kqjs+Uc+MQ37GHJA+QM5xozS3Cos3F1TDgjToEIXC/eE1j1rFIcEHQsXjwZQlcrKumR7
         V5rr0UyKfuaD7ZOJJl65enqiTYXpVwCWT0C/RQGaG4MRkzSsyj03j+vsDkc/3vFVuAeg
         A09i0xcq7h5+C7K7Z+2p83SsDDaMoO0vwkSk1B0CO2/iTtdmwkD/kytU9bHNJcFwLJBU
         H+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708954688; x=1709559488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y29K3a9HmK85XuwdpCfrzTUQd/fHWQnDJ6Znm1786ds=;
        b=NAi2sjnLTAA9FeVFCoxxpZG8uLRywQ8H92yz7fNT+J6gdwvddFtsIEczR3bmCfuHPz
         KuA+43inY9anFfXOp0N6U8nmECymtkUfjNa37H46IsylM8ro0fT1rYmvGeLRXtCL76er
         b5qHax0Y/XySlANZCQJ3qbzVdeZWRma2N178NhCT3hGf28OS4qfyqgbIVbFhDM68HKhh
         HVPnrac6RvlZr06/u/rano9UPa932a+Rl0DcacRmA2bUzepwSNBnUOjTSEXosKjdxoiW
         vgElZ9zpdafeZmMjv+6V4dFikoCeiqn6jurAw3KBMSwWREO7PILHgaFS3ZZhz5+8/Hiz
         plEg==
X-Gm-Message-State: AOJu0YyLLN1wo2Df693Jkld9AGxOyFTiUzzz/JgfOw6FchFyJoMdoAuX
	Sz5X+mMy23edQzutqJQYU8IFPBXWKBtpsuMw1MF2qggD3LQYgXt07pgMZZAojLB0HBMNGN2l7Pf
	Q
X-Google-Smtp-Source: AGHT+IHQFSF0gbolFeSKT7L230+n9VU7Lce+LkB9HH24hy+Q58xXIHBGjG+DdUVxVqkdNbli4UZUDg==
X-Received: by 2002:a05:6a21:6d9d:b0:1a0:f8b1:5d10 with SMTP id wl29-20020a056a216d9d00b001a0f8b15d10mr4623073pzb.2.1708954688567;
        Mon, 26 Feb 2024 05:38:08 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jh5-20020a170903328500b001dcada71593sm1007771plb.273.2024.02.26.05.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 05:38:08 -0800 (PST)
Message-ID: <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
Date: Mon, 26 Feb 2024 06:38:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 3:47 AM, Dylan Yudaken wrote:
> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This works very much like the receive side, except for sends. The idea
>> is that an application can fill outgoing buffers in a provided buffer
>> group, and then arm a single send that will service them all. For now
>> this variant just terminates when we are out of buffers to send, and
>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>> set, as per usual for multishot requests.
>>
> 
> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
> described, unless I'm missing something?

How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
try again" where multishot is "send data from this buffer group, and
keep sending data until it's empty". Hence it's the mirror of multishot
on the receive side. Unless I'm misunderstanding you somehow, not sure
it'd be smart to add special meaning to MSG_WAITALL with provided
buffers.

> I actually could imagine it being useful for the previous patches' use
> case of queuing up sends and keeping ordering,
> and I think the API is more obvious (rather than the second CQE
> sending the first CQE's data). So maybe it's worth only
> keeping one approach?

And here you totally lost me :-)

-- 
Jens Axboe


