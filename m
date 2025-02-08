Return-Path: <io-uring+bounces-6324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE86A2D68F
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 15:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B11813AA331
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 14:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371B4246336;
	Sat,  8 Feb 2025 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7u3u9MY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5F20328;
	Sat,  8 Feb 2025 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739024176; cv=none; b=suvCCan7Pk7Xb1+0hQI5XF4v3mLHGCMbzmgUTmYVEWnD4FgjRcjl+9g81511QQzPatV6cPHM4+XN47XJRQnYC3y9tMK/1M21/n2SmClam0dd0W9Lgy2qfUOVFzXqlL4BKUU/LBh6vFalac2no9RE/MeJddvfAYbb1Ui044RAF2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739024176; c=relaxed/simple;
	bh=mMQkiSYxsOkokKPVwELVj64oYiRRvApUjw4yegTNtIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OK9iAkqCChyWZcavQnh0JXOaGlutY5Vp09UL5EAPLi8+uewGPam7WCQR5kpNmA8qNUTFrBD0i1clqI7rDavPGDSvAiKrGGUipbRYBhivkbMMqjcNEyEdmNv6rfnx9L9bgaGHyLhP8PDdLRLhXLNwaS+jfZuyluJuSpwfFd7w8i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m7u3u9MY; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso7811124a12.0;
        Sat, 08 Feb 2025 06:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739024173; x=1739628973; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JP7oevjeaQ2JOzrFUNOl33Q9xA+PaD/iG6wAR4rt2EM=;
        b=m7u3u9MYsK7W7ZKwhLxEVRmi93yDw1P/jsnBL7tan5HsJO3Of7mVXvwwVMBSY8gxM9
         b8X/2VACjTBPuqQ016oWS3jngq4msQ+tJUrBZsqlCrPCuRq+SaokWD5vSI9JFUpkUCVo
         p8XuMaJiSV1eHmJJUXVeFQGEtavtK8UqVi639+lLVzTTUswGlq4nhcp/I/ygqWWGRaBp
         JvQdol0IDxeDFzSruJsRBQqUHT78UXT3OS8Up3FZRFcr9rQGLhJ8o5r0uM0T/I9IMHMn
         W1WW72O7akfyb8angNp0zeTgvKH9NoIT0ajY9ZDVoe+/cnN2aRYxfVwuM2jOYzxipRNL
         WpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739024173; x=1739628973;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JP7oevjeaQ2JOzrFUNOl33Q9xA+PaD/iG6wAR4rt2EM=;
        b=f0XJpgb9VII8wunEGU/eUHkhjLJFA4oMHm3WY85MlqqisiINhSgay9bEyrUu7gbYMo
         OhK+A7Znsm7E3kKFVLU74W46AptNYiKR4NO66/iAHmyKV6GRX+Y6gNpkYuHCwJ/8egPk
         b2snPeS7ZJePf02C03IVUZrv3Wm1GMmToLCzrh45H5x6y7GRJAc5k9sZiR2s6PMW14oC
         8SV/ZgA2FFSiwGOlt3HOuYrxfuuP0q7FBF1xIOlDwMox+oM7BhK2KlA/AylT2T72Full
         zBPHVcnovQuIDILNGhQthe6nJnxPd62yRnvxzeWFgRQ+CHmqsBcKgLuDjy2faNvIgSVt
         NdWg==
X-Forwarded-Encrypted: i=1; AJvYcCWHOu1NrDb+enJNEXRcG7tLzbKU7z15pE4N+a6Rt7G1ttQnnKLE+zo9vb5WBuEso45Qk6Pmx7LOHA==@vger.kernel.org, AJvYcCXpCZxFB6d7bHhfonPW/aJzs17lfSsw1510Fse/4fkSdzW6AYjVGmOZniNUDL6M/ye31jdF2lOKvSjESkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Hl2usf8rRlYfJtTCnxtDvXd/cNJUG5ywi5DQztk0vIW32HcY
	tZY6UFf07mB6nxnvLt+i9r+vI0hfBr0WQx2AXsfB3wMgjo+CSwM5
X-Gm-Gg: ASbGncusfbBJYlQ1wAX4rfov7ynrYR9YCYjlHoGlxH361GmIu/rh9TwJ1dWzfXJv4TS
	DiMwDsk3aB+JaO1g4rVabe1tqI4nDvbMafOehJN2chxo/CzCevUw1gKvCc0kMd71zlPdd8rcF/G
	5GYFZXh3U1rKniYinaAlam/+ZPSBWV2GAfJ056SIdj67B3nSQqXDWs0Z2ufIbSUfaa7maJTrrYK
	hyBaeXGdspxr5YeD+OkQnNin5iNrj8iA/0Av5L3hMHJtvu/mdNKAzyUQ8ViRvai7V3yHm7ZL6JL
	CeXpIisg9P5Clpp7M2F2cN/yMA==
X-Google-Smtp-Source: AGHT+IGzFM3oSduCFjlX+ZFNKj71Yzhl697XZtw9iQ2cVFTebGeM4ceGpukDg3ltyN1KdLUlCYdcog==
X-Received: by 2002:a17:906:f582:b0:ab3:a18e:c8b6 with SMTP id a640c23a62f3a-ab789b05c00mr664712966b.10.1739024172370;
        Sat, 08 Feb 2025 06:16:12 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7a98974aasm62140966b.47.2025.02.08.06.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 06:16:11 -0800 (PST)
Message-ID: <b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com>
Date: Sat, 8 Feb 2025 14:16:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] ublk zero-copy support
To: Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, axboe@kernel.dk,
 Bernd Schubert <bernd@bsbernd.com>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora> <Z6YTfi29FcSQ1cSe@kbusch-mbp>
 <Z6bvSXKF9ESwJ61r@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6bvSXKF9ESwJ61r@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/8/25 05:44, Ming Lei wrote:
> On Fri, Feb 07, 2025 at 07:06:54AM -0700, Keith Busch wrote:
>> On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
>>> On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
>>>>
>>>> The previous version from Ming can be viewed here:
>>>>
>>>>    https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
>>>>
>>>> Based on the feedback from that thread, the desired io_uring interfaces
>>>> needed to be simpler, and the kernel registered resources need to behave
>>>> more similiar to user registered buffers.
>>>>
>>>> This series introduces a new resource node type, KBUF, which, like the
>>>> BUFFER resource, needs to be installed into an io_uring buf_node table
>>>> in order for the user to access it in a fixed buffer command. The
>>>> new io_uring kernel API provides a way for a user to register a struct
>>>> request's bvec to a specific index, and a way to unregister it.
>>>>
>>>> When the ublk server receives notification of a new command, it must
>>>> first select an index and register the zero copy buffer. It may use that
>>>> index for any number of fixed buffer commands, then it must unregister
>>>> the index when it's done. This can all be done in a single io_uring_enter
>>>> if desired, or it can be split into multiple enters if needed.
>>>
>>> I suspect it may not be done in single io_uring_enter() because there
>>> is strict dependency among the three OPs(register buffer, read/write,
>>> unregister buffer).
>>
>> The registration is synchronous. io_uring completes the SQE entirely
>> before it even looks at the read command in the next SQE.
> 
> Can you explain a bit "synchronous" here?

I'd believe synchronous here means "executed during submission from
the submit syscall path". And I agree that we can't rely on that.
That's an implementation detail and io_uring doesn't promise that,
but even now it relies on not using certain features like drain and
the async flag.
  
> In patch 4, two ublk uring_cmd(UBLK_U_IO_REGISTER_IO_BUF/UBLK_U_IO_UNREGISTER_IO_BUF)
> are added, and their handlers are called from uring_cmd's ->issue().
> 
>>
>> The read or write is asynchronous, but it's prep takes a reference on
>> the node before moving on to the next SQE..
> 
> The buffer is registered in ->issue() of UBLK_U_IO_REGISTER_IO_BUF,
> and it isn't done yet when calling ->prep() of read_fixed/write_fixed,
> in which buffer is looked up in ->prep().

I believe we should eventually move all such binding to ->issue
to be consistent with file handling. Not super happy about either
of those, but that's the kinds of problems coming from supporting
links.

-- 
Pavel Begunkov


