Return-Path: <io-uring+bounces-1343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1077A892BBC
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 16:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95116B2137D
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0943AEBB;
	Sat, 30 Mar 2024 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h1aeUoW5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3038389
	for <io-uring@vger.kernel.org>; Sat, 30 Mar 2024 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711811649; cv=none; b=UpMkIfhbNJXz7lmNB/xSkfi2xrqWoR054BN+4l30aNrslsrquG+DAuGbGdIyYTC64Md1i8+VFoMf/SfxLO5YT2V9t+IimafIe9juX7Vc/nryt6Ywf334sYKsJlAPEaqxel3g8HRGPfE+tfk7nvhPsouvh7L7VaQ1iTYVXnTy728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711811649; c=relaxed/simple;
	bh=LxYGxF0bkCDvg20BPi3wGzP0iMieM7ODrwi/PWAoGGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g8/xRXT9NMj8ISf5kAlaOmB1/UKw79Xgzi19ya023VZ/nt1AZxdLpReIPH4K+4WVKzTbHWRINCJTYYwZBCNjsjGD/J+KvOCsWlQfUkw0lrFt/uZswvUoY5q72Cqc8NkoUI7DJi7nk0+dDbQXncNn3ZXjnL+QxeNg244TN7L+zKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h1aeUoW5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ea895eaaadso656829b3a.1
        for <io-uring@vger.kernel.org>; Sat, 30 Mar 2024 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711811645; x=1712416445; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mrRnoZyriYCPcrKBiyXGE6XIdSITfqoyfsn1F1yuDOc=;
        b=h1aeUoW5GIqVr3tGD5VN5Q4elGKubT8jvVJte9ZGg1EYnB3grdHzQ/lRVY8KUc9Gmg
         6LV07x0hfE/D/7/Tz6XRjB8zS0ACwAobIivJASULICojGhPhbn/lSZyDeo4fSGqaNhuM
         k1D3mxIUJ7nhzHsQM8TlTsnQ3NdISHq9gIWqSlaxcrsNdeJk/2LKiKh+fhWyyNZZ0anm
         jeRyTZrZLkyt2BjFM6whJ9tmiLIYMohV+0BparHpI0gdpHi9vKbLr+UrL0nBligYc+Mf
         aZq5qE5VwrDhQv8G8Bi49YtyZ5IL0H33zrNfISKx7vnj21CqhmmqR7wHE0nkMhZ1Gnbw
         wEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711811645; x=1712416445;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrRnoZyriYCPcrKBiyXGE6XIdSITfqoyfsn1F1yuDOc=;
        b=wynYPuyF06jdY8/ZNWNSA2kOnQP1gsGAfUmRmkXUa+XCJBvhHn9FOTQOWFr+Ju1riA
         vAlCpGm0rc8TrO0vQVJdtl4g6A1M3IbCmq5mJm31+0ZlBM7QGHSVk9MQmpC9libAf2SX
         zrMmHA8kLCcfbFHYfUCvInGCLjxwirDgAJttdvCTbELTvc1hUCyputvxejEDKCWz4SOP
         8BnlMgMdihw60Y2g0TmH8rYi8z5PhmshAzVMOMGMwTyrdF+ktEYOGtpMjx7vq/XSmsC3
         FTX7Xb4Ex8qzozECZ3YBbQb05qkRIyu5P2SPnhzKo4Z3qw2DBjmelAoW5rIEw70fpaYw
         7EoA==
X-Gm-Message-State: AOJu0YwW8iuzwi4Da5ysQQwuBV/XzI3YuBdJzF63OUSIlD887BxOBXA0
	lsn9iAClF+UPKCNZVSrt5pIptNbUG2/QP6RF1c/hX/WUfW4agG/AkyePT+curQk=
X-Google-Smtp-Source: AGHT+IFyjXioQ7fckud/+7q8A49ZHKQmdDsNkgH04Y7ainLfi8T0V/u0SGeWsiKCnV2UISNcNBZqqg==
X-Received: by 2002:a17:902:c255:b0:1de:e8ce:9d7a with SMTP id 21-20020a170902c25500b001dee8ce9d7amr5528194plg.5.1711811645417;
        Sat, 30 Mar 2024 08:14:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u14-20020a170903124e00b001e0e5722788sm5375804plh.17.2024.03.30.08.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 08:14:04 -0700 (PDT)
Message-ID: <92e22da9-be49-4c8e-9aa3-b9f5e5fd87f3@kernel.dk>
Date: Sat, 30 Mar 2024 09:14:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] io_uring: get rid of remap_pfn_range() for mapping
 rings/sqes
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, hannes@cmpxchg.org
References: <20240328233443.797828-1-axboe@kernel.dk>
 <20240328233443.797828-3-axboe@kernel.dk>
 <87bk6w5qfm.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87bk6w5qfm.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 9:50 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Rather than use remap_pfn_range() for this and manually free later,
>> switch to using vm_insert_pages() and have it Just Work.
>>
>> If possible, allocate a single compound page that covers the range that
>> is needed. If that works, then we can just use page_address() on that
>> page. If we fail to get a compound page, allocate single pages and use
>> vmap() to map them into the kernel virtual address space.
>>
>> This just covers the rings/sqes, the other remaining user of the mmap
>> remap_pfn_range() user will be converted separately. Once that is done,
>> we can kill the old alloc/free code.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 136 +++++++++++++++++++++++++++++++++++++++++---
>>  io_uring/io_uring.h |   2 +
>>  2 files changed, 130 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 104899522bc5..982545ca23f9 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2594,6 +2594,33 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
>>  }
>>  
>> +static void io_pages_unmap(void *ptr, struct page ***pages,
>> +			   unsigned short *npages)
>> +{
>> +	bool do_vunmap = false;
>> +
>> +	if (*npages) {
>> +		struct page **to_free = *pages;
>> +		int i;
>> +
>> +		/*
>> +		 * Only did vmap for the non-compound multiple page case.
>> +		 * For the compound page, we just need to put the head.
>> +		 */
>> +		if (PageCompound(to_free[0]))
>> +			*npages = 1;
>> +		else if (*npages > 1)
>> +			do_vunmap = true;
>> +		for (i = 0; i < *npages; i++)
>> +			put_page(to_free[i]);
>> +	}
> 
> Hi Jens,
> 
> wouldn't it be simpler to handle the compound case separately as a
> folio?  Then you folio_put the compound page here and just handle the
> non-continuous case after.

I don't think it makes sense, as we're still dealing with pages for
insertion. Once there's some folio variant of inserting pages, then yeah
I think it'd make sense to unify it. If not, we're doing the page <->
folio transition in one spot anyway.

-- 
Jens Axboe


