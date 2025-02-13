Return-Path: <io-uring+bounces-6414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6FBA34AA8
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:49:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFD723BC6B7
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD244242929;
	Thu, 13 Feb 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGIDYItv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C45242934;
	Thu, 13 Feb 2025 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739464029; cv=none; b=aPQICNeVg8B21YgAe8swvasH68kWOVxLGBsnPkjt1cRX2qcdyzF7VDDnCwAlhPlM4Wrw0zqMVI82/xzc4RdYYW+59Xr3NwQgUr82pQESB6DbPNbMX1c1fYmmsvU726NNlZnqAq13KaBBXbhcQrnYq8jNcv6ifJE3eRWD76UvmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739464029; c=relaxed/simple;
	bh=GkD2TLtcUNdRy1RtTr6S+B59bd600sPDfnr83dD5Eq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hlmMZhcJeLwQpSGEMzqyE2zvHdwmVmseHilCLijN9ozRKHAh+/QlPj3e1tPn2JSJn+djwMuwReCyP1z5ZnhHzGA1nuGXdmExrOZ81+6ucaeJjn6CJy2+xhnAjSdauTAoD9lgxABpsmmrQj1vpC2jltcR+WwUiowoPe2CaHmNeOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGIDYItv; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso4446255a12.0;
        Thu, 13 Feb 2025 08:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739464026; x=1740068826; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JdOnZs1INoH5NyAQ/g3Et1WZjU4KHFjpe+26IpMFKII=;
        b=fGIDYItv3S7okahWElnMLtST96NjCaFenXpdldile6DxVNIflzepy8gGdruyIv8Szd
         Gx1cpX6aAaknCHST4qrfciOoQ3UezY0BXITtm1gsKd+bv1R8Etedbpzafxe9nlKpfXJW
         g7e54X21ZLrALAY5sNljj5vmIgXTR2UBn9jrbwYWsuBnPpxjP87W1iXs2DPQXm0y+Nm/
         7+0+Yj/cwnAYEHXexwrfcCltIl17pjb3KCZZtYygXjZzno8Rdl41fp7hX40XchwE7NBT
         BlgvqHZhV6KpPNwF9XFt1RAafIa2PB2AjfrxHlWtNgkEpNiE9uOi0WUf13HKasqTI7k0
         vBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739464026; x=1740068826;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdOnZs1INoH5NyAQ/g3Et1WZjU4KHFjpe+26IpMFKII=;
        b=j2UVx2r3lPr1XifPuRw5s7PmvzO0OrXEhltP5mXp5c05Oj8FbBB31oyxGAPvyT0VnX
         lw2rkI/r/ZXHNE4sAW5itP/ecOWmmIlo2Pp3FhjLG9GwEFnKGk2byMt1OdtJge6P857h
         EkjQ0/XP923187EQZjbec5RMLdZ/GHo9jRv4DkbnNq1FCh84aTKaZSvLYHp1WxkN5JLe
         qjHtl0/o9G512rixexEVUZ85C/EtwIgoozPZg25QTVyUS1HVp6LwDJ059zdZ7C4J1dzR
         yywU4YjWFHpXI+C15kOZk1K1iHOOQfOxLTYyXm6kX0eb7+t39NGk6Im64V2AJtd0t3FS
         /9cg==
X-Forwarded-Encrypted: i=1; AJvYcCVmB6E0LASSntIHBweUwWl/k9Y9l7UllVoLf+siVnBfyWIR3DyeNAJITU+DfEpEM5A0939KNYUVkHEZawKa@vger.kernel.org, AJvYcCWa11B21MjuZOohzY0WJTYwWdcAlfYB9DgHuQYSArnpXVzhMkm3x29R0k1Xl2mMXtdcBuCprDHA4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzefistXKxs389f4q8MO8IQoa/KBLup6o6pYSq3tdNH9DvVPGkd
	PUJNqhIxl1BPist80C+d9v9v/eSYh4p7fy1olp+C9pL6geMrv8xTytrKfw==
X-Gm-Gg: ASbGncu2pOHzJLpOcrotXVlqAsiCB2oe+Sp/bT9o6SA/KtYxIbwTqtfvF/tARB9TOG1
	Pn1QZdwu+Simi2Vx2hCNURiPds8bSZwHYYhkxdAW99lP2icbPIbAQAqDKq+snmwfMnftZUBLkhQ
	OrV9GwVHtFAbbDh9jxw4Ay/m4K4DtO0deAyhcyvJ+BXYP7yjJZZJ8pExUQLgMiWK9tmYW0Ds11L
	6f070oGNM8jU3dxHu1eUFsQlZ2qzI9p99hXQJk48dbJcK4NQBhFtXRSX1XGPoAKq3T0w/cXfVRN
	dsXtbvaId+w76X2NWaXjcjpIhWX8lngoamUjA6DFJqUy/iB1
X-Google-Smtp-Source: AGHT+IEhSK8SQ8uEcDFgfnGzZYwcVqWBti4yjb/MW/JXSJ8hpxqHmEfdK9dkyXFYrWw60xJoxhhtqQ==
X-Received: by 2002:a05:6402:27d4:b0:5de:5a85:2f1f with SMTP id 4fb4d7f45d1cf-5decb688397mr3643406a12.7.1739464024381;
        Thu, 13 Feb 2025 08:27:04 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1cb7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece2709ffsm1409748a12.60.2025.02.13.08.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 08:27:03 -0800 (PST)
Message-ID: <8ab1ca13-bf33-4e2e-9e37-13e469a6ee71@gmail.com>
Date: Thu, 13 Feb 2025 16:28:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
Cc: Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
 <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
 <Z60s3ryl5UotleV-@kbusch-mbp>
 <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
 <49382366-c561-44cb-8acb-7241d0b95dd2@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49382366-c561-44cb-8acb-7241d0b95dd2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 23:55, Jens Axboe wrote:
> On 2/12/25 4:46 PM, Caleb Sander Mateos wrote:
>> On Wed, Feb 12, 2025 at 3:21?PM Keith Busch <kbusch@kernel.org> wrote:
>>>
>>> On Wed, Feb 12, 2025 at 03:07:30PM -0800, Caleb Sander Mateos wrote:
>>>>
>>>> Yes, we completely agree. We are working on incorporating Keith's
>>>> patchset now. It looks like there is still an open question about
>>>> whether userspace will need to enforce ordering between the requests
>>>> (either using linked operations or waiting for completions before
>>>> submitting the subsequent operations).
>>>
>>> In its current form, my series depends on you *not* using linked
>>> requests. I didn't think it would be a problem as it follows an existing
>>> pattern from the IORING_OP_FILES_UPDATE operation. That has to complete
>>> in its entirety before prepping any subsequent commands that reference
>>> the index, and using links would get the wrong results.
>>
>> As implementers of a ublk server, we would also prefer the current
>> interface in your patch series! Having to explicitly order the
>> requests would definitely make the interface more cumbersome and
>> probably less performant. I was just saying that Ming and Pavel had
>> raised some concerns about guaranteeing the order in which io_uring
>> issues SQEs. IORING_OP_FILES_UPDATE is a good analogy. Do we have any
>> examples of how applications use it? Are they waiting for a
>> completion, linking it, or relying on io_uring to issue it
>> synchronously?
> 
> Yes it's a good similar example - and I don't think it matters much
> how it's used. If you rely on its completion before making progress AND
> you set flags like IOSQE_ASYNC or LINK/DRAIN that will make it go async
> on purposes, then yes you'd need to similarly link dependents on it. If
> you don't set anything that forces it to go async, then it WILL complete
> inline - there's nothing in its implementation that would cause it
> needing to retry. Any failure would be fatal.
> 
> This is very much the same thing with the buf update / insertion, it'll
> behave in exactly the same way. You could argue "but you need to handle
> failures" and that is true. But if the failure case is that your
> consumer of the buffer fails with an import failure, then you can just
> as well handle that as you can the request getting failed with
> -ECANCELED because your dependent link failed.

That should be fine as long as the kernel reserves the ability
to change the order, i.e. in case of an error the implementation
will need to fall back to proper ordering like linking. It might
need a flag from io_uring whether you should ever attempt the
unordered version not to get a perf regression down the road
from submitting it twice.

For the unregistration though it'd likely need proper ordering
with the IO request in case it fails.

-- 
Pavel Begunkov


