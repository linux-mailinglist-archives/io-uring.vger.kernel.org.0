Return-Path: <io-uring+bounces-7157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0008BA6B9B4
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 12:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81CA73B511B
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 11:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736DE1F17EB;
	Fri, 21 Mar 2025 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yMIVhXf5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0081FAD2F
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555839; cv=none; b=J58g+2USJcHe54IpzrXIOkjZFuRj+d8GToHzOYz7hMhR7jYAoQAWmfEknjz/MDlUKd6JSF5axx9yzn8NdHtcyyiOMt87xRdUqq+fGbhAASReuX0deOe0UJb2Kyea7rb9pEBInBY6jRsISUziUryZSJVv60gUnRfWCNS9wTx62YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555839; c=relaxed/simple;
	bh=m2vc6ZJ6JSH7alaxCXpXJz+S+m3RfjPoDbd/zOWr3bo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBJFUd1yIB1LeVj6mIyYGeRGv0FRYh9mru4BmSnMlZOaUB5knd7wZ0ISAvgQTcHERvIM3AJXWq701fuhVtdakeXNf9wvDoV/8NoPDOXzZfONvTdl/W8IuDEuBVcAqxZYOhy38BGsw8OwV+lGuf//ieaJ3XCnYm0llvYN13tTgrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yMIVhXf5; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85e15dc8035so38246939f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 04:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742555837; x=1743160637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=59LLzW7ToEBWUOpkdwZSTFFdcnkJr66vbvUK+dy5Qmk=;
        b=yMIVhXf5Mqo0ShzlMSrLXH6x1Nw8VmuZ9KYMVOt2NxSaRM0Gxn1aIxizXWYQoDV9zN
         PGxZqsAYKFXHUkas/DChYcxMgMLKYV8kvbJZZZqA0+yhTFhFxzG11ipFt+q+nogS7ON4
         Qa4/Jfc9bdNyGCsMHNYzle4Kl6vbKm6il2Mo4Qg8h0mu2ZetP2I8lWM4ybBqQIxy1uRI
         wme/cqL3NANjczAY0ejYgJNj+3ro5tD4vIeKpw/x1L2ope5wirAimi4/e++xYOfwEsJ8
         1I35Af6oBXry9iOgHAmzr/UrOwSS3mu8Yu44lphJUF2dYr0uOFhYVLBbzn9bqW3SA+IP
         wlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742555837; x=1743160637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59LLzW7ToEBWUOpkdwZSTFFdcnkJr66vbvUK+dy5Qmk=;
        b=TNc7Kl/TYYXWMoWZaC+dzd3DEBgiw0lDd72j1zy9qLzcnv8Klr95dimC3pkltXpBxY
         HafFWaDyQ2iNs2EHaE70UaY07EGnrFmt60PQ6n9HderMJmeIbNrkSd94r7SATLr9jVdt
         qnNn9eDFSJ9qU1C9zw6LMkyE/nAooRqYYg9U8DiZzqVysbr6dlz1dHswbHaTcUpn14I+
         wXh112ix9RNl18mqxRq2uF4OA4FOE9DRMG/HryB9g3GBdF8dbe+bREOBBLQoIiakympb
         t8IPQrRjpTX14A+1TSHVhh3eZ7Ajn4g8CMpWmQLJQgC7kdWabEDlL9TnogfmInsjdh9I
         gU1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUg4JK/pX2vleMAgvGggdmlNUtRua6x89q7HKD4PLQBhlB2Pg2Lo0QRfZaRkUTLIPE3nLzUM2cDdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXbmybnNFsnN+P2hIzFdFcV58H0GZeU41JMT68vuj3JSBkH5ea
	iJPWOqhS4+MC7H0bUtDxUCkcT1/6SgeM31YMBGUPnlK8wy+mA6Sz6988icSzW6SDv4nJD+mY997
	i
X-Gm-Gg: ASbGncsmNrme/9UhU4M6mT0bl79ozDp0C34eth5JvG74ZUMg8TCrPOglPvNn4WxZ1l2
	v8XvNh8B7n7dmzDMmRQSpB9nRtAlAU7YuhJ2ZdPjiRkppK4obIjIT/xmXhi1eTtVT8LB25kPzJY
	bxztyOcW6fv+7c4c04a6KoelUR/syC4RNcizjaBQg3O+Sz3Q6nP+F7MxnYZCtlzAzuKehFBP5/5
	oqPb33dpXm673P4amXdMX5MXYYYLRQ3CDd+jlxvf+RI+iVxhIIPieHuOqwDTAspJyfP+i7wLKLU
	x8jupvYY/1rp31Vyse+XoFovifY7650J42vElzGsTQ==
X-Google-Smtp-Source: AGHT+IFjSZ3fb43kry5hTLE5e6mSs3SJ1Pz758OOHDAPWAP28kapByaxuk0gb0pJL8JPkKgr4JClUA==
X-Received: by 2002:a05:6602:1356:b0:85d:b7a3:b850 with SMTP id ca18e2360f4ac-85e2ca55c90mr318446239f.5.1742555836923;
        Fri, 21 Mar 2025 04:17:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdb3ae2sm382359173.5.2025.03.21.04.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 04:17:16 -0700 (PDT)
Message-ID: <812ae44c-28e9-40a8-a6f0-b9517c55e513@kernel.dk>
Date: Fri, 21 Mar 2025 05:17:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 5/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
To: Pavel Begunkov <asml.silence@gmail.com>,
 Sidong Yang <sidong.yang@furiosa.ai>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <20250319061251.21452-6-sidong.yang@furiosa.ai>
 <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>
 <Z9xAFpS-9CNF3Jiv@sidongui-MacBookPro.local>
 <c9a3c5bb-06ca-48ee-9c04-d4de07eb5860@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9a3c5bb-06ca-48ee-9c04-d4de07eb5860@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 4:28 AM, Pavel Begunkov wrote:
> On 3/20/25 16:19, Sidong Yang wrote:
>> On Thu, Mar 20, 2025 at 12:01:42PM +0000, Pavel Begunkov wrote:
>>> On 3/19/25 06:12, Sidong Yang wrote:
>>>> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
>>>> with uring cmd, it uses import_iovec without supporting fixed buffer.
>>>> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
>>>> IORING_URING_CMD_FIXED.
>>>
>>> Looks fine to me. The only comment, it appears btrfs silently ignored
>>> IORING_URING_CMD_FIXED before, so theoretically it changes the uapi.
>>> It should be fine, but maybe we should sneak in and backport a patch
>>> refusing the flag for older kernels?
>>
>> I think it's okay to leave the old version as it is. Making it to refuse
>> the flag could break user application.
> 
> Just as this patch breaks it. The cmd is new and quite specific, likely
> nobody would notice the change. As it currently stands, the fixed buffer
> version of the cmd is going to succeed in 99% of cases on older kernels
> because we're still passing an iovec in, but that's only until someone
> plays remapping games after a registration and gets bizarre results.
> 
> It's up to btrfs folks how they want to handle that, either try to fix
> it now, or have a chance someone will be surprised in the future. My
> recommendation would be the former one.

I'd strongly recommend that the btrfs side check for valid flags and
error it. It's a new enough addition that this should not be a concern,
and silently ignoring (currently) unsupported flags rather than erroring
them is a mistake.

Sidong, please do send a patch for that so it can go into 6.13 stable
and 6.14 to avoid any confusion in this area in the future.

-- 
Jens Axboe

