Return-Path: <io-uring+bounces-3601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3300A99A977
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D51E2282AAA
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 17:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840741BDA8F;
	Fri, 11 Oct 2024 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UdZkgn65"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE6B1BDA8D
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728666511; cv=none; b=Bb7Z7LTa2TuN0DACpSjD5wwB9l+qBG4vWfnKmF59/Ab6UdY8pp/3fQyP58bFB9C+j5sxr6LztpFfUps+ZBmIQ5MD160V9YUObhW1qhtG2g7nFxMerFBuMg4T9vIJ7CfFpjr/qrLVsXu6o6cEIh0OgXK6kZbZRD4xj82/IX3/0ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728666511; c=relaxed/simple;
	bh=EvIzdmbi0RMS+oivuy9a1VIs2ypctJaNPjYi7wwOb/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdWQIrvwxqMOyrhTxwLnHxfxRFVXo+CK/PTjeafAxATDNvDbgLB9Eh5heGB+rYzzaM+ICS+5rg3spje1aJL10o4t62S6EIMUJiMvS0lrLksKEMTVfDwC6Xsc9PkXDVhMcXUL0Xur2sLU06Bh6QkODL2foLWsIR2YjFBFJwvLyxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UdZkgn65; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-837b92bd007so56392139f.2
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 10:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728666508; x=1729271308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zWsbC5zYwFjIQpjAKyMSFH5NvTQw8vDDAjcLz2511K4=;
        b=UdZkgn65UoMZ1uslnTC5IMQZBgcMWhxMmQQBMy5Ux4+y62gxZfz6N6/xM3n3ajx2Aa
         lxb1OYpve/VkU5xLvoxRyMv6yHoBsIgit7b1muGRHWWZsnPG8S1snGsvG463nKGpyga7
         QRVd9LVDxJHKZaBLqyepLoEryoFAA6RjTREg/fXXkLTyVhkgHae/BWNXemOmnP0C5MGN
         Ym/fTVyHt0jNqJp2nCPt/+IcWYTGkKOFNd39omf04bQajnorcZLKZ7oKKJss1C7m5ASW
         Cj90Alo00V6FxZ8KyH1C+UTNbTJS6nFdmb1p0NNnR7+yaErPP2opgQJ5Ow+Kb7wTJHQh
         l8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728666508; x=1729271308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWsbC5zYwFjIQpjAKyMSFH5NvTQw8vDDAjcLz2511K4=;
        b=m3v/EYIDOrA0HzaV5N9BJkZouwzzabVwFllZLtszCqsok5N0iL0fiy/+cljIXOQ3Cq
         uWKfyoUAyOA1pxYKKBZlUd/hRh6e6b49Lm7Ms+eJt8K9e3JudXWLEUD/sVNof2GMOmm6
         mO/fbwCHOclnyE7eXDYsKUbsh1lSXerCJH/0LO55+5JRoyoASilXBq9+KtLi3DwqrggD
         wdYWhPlqRSfDgO4ao25fgejgzu/x9/uPhWC7n5gMGmZPBSTzecCYZ+H2EtC51ekvM3G5
         vWAO15y2bc7Zx/eegC7mOTjuNqg7f0zVuvrLJRap2qnlrr9Zl9OAs81QdZTuiZmCt5Ll
         Fn6g==
X-Forwarded-Encrypted: i=1; AJvYcCXmIk81Qo1C9FiVfduvk0/FOzPVqWjuJw+s1Zr9AfyU0SPfHdQR1ybKZm8HHM+1/U44z+xL2WlW1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz62/BRvHEHn3uL44fcrYN4I+QIdZq0rBdotvVTc/+ZHkAELRqi
	sBXq/5cbt/tIHGlz4C7cMlhcDZAAeDyeKhduqkyfMO/SjxmeYT//Fnd9sePr2cQ=
X-Google-Smtp-Source: AGHT+IHFPvgcQvxvJOZSrVRCZbyxjluKSsk/HoPp/vuJuEff6o04MxOCGz5P4UynejEHp6ALDdoREw==
X-Received: by 2002:a05:6602:640b:b0:82c:e233:15bf with SMTP id ca18e2360f4ac-83a64ce3d46mr24956339f.6.1728666508526;
        Fri, 11 Oct 2024 10:08:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354b9932absm77655639f.31.2024.10.11.10.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 10:08:27 -0700 (PDT)
Message-ID: <5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk>
Date: Fri, 11 Oct 2024 11:08:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Christoph Hellwig <hch@lst.de>, =?UTF-8?Q?Javier_Gonz=C3=A1lez?=
 <javier.gonz@samsung.com>
Cc: Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
 asml.silence@gmail.com, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
 vishak.g@samsung.com
References: <20241004123027.GA19168@lst.de>
 <20241007101011.boufh3tipewgvuao@ArmHalley.local>
 <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp>
 <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
 <CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com>
 <20241010070736.de32zgad4qmfohhe@ArmHalley.local>
 <20241010091333.GB9287@lst.de>
 <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
 <20241011090224.GC4039@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241011090224.GC4039@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/24 3:02 AM, Christoph Hellwig wrote:
>>> As mentioned probably close to a dozen times over this thread and it's
>>> predecessors:  Keeping the per-file I/O hint API and mapping that to
>>> FDP is fine.  Exposing the overly-simplistic hints to the NVMe driver
>>> through the entire I/O stack and locking us into that is not.
>>
>> I don't understand the "locking us into that" part.
> 
> The patches as submitted do the two following two things:
> 
>  1) interpret the simple temperature hints to map to FDP reclaim handles
>  2) add a new interface to set the temperature hints per I/O
> 
> and also rely on an annoying existing implementation detail where the I/O
> hints set on random files get automatically propagated to the block
> device without file system involvement.
> 
> This means we can't easily make the nvme driver actually use smarter
> hints that expose the actual FDP capabilities without breaking users
> that relied on the existing behavior, especially the per-I/O hints that
> counteract any kind of file system based data placement.
> 

I think that last argument is a straw man - for any kind of interface
like this, we've ALWAYS just had the rule that any per-whatever
overrides the generic setting. Per IO hints would do the same thing. Is
this a mess if a user has assigned a file hint and uses other per IO
hints on that very same file and they differ? Certainly, but that's
really just the user/app being dumb. Or maybe being smart, as this
particular one block is always hot in the file (yeah contrived case).

The point is, if you mix and match per-io hints and per-file hints, then
you're probably being pretty silly and nobody should do that. I don't
think this is a practical concern at all.

-- 
Jens Axboe

