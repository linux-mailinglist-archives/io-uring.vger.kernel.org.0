Return-Path: <io-uring+bounces-13120-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAlpAenD6Gm9PwIAu9opvQ
	(envelope-from <io-uring+bounces-13120-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 14:49:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8424462DD
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 14:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DE643071C68
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 12:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD113DE42E;
	Wed, 22 Apr 2026 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="czPWf+Cd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414563DE45A
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 12:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776861645; cv=none; b=TI3thDtSW/dwsy0qQ5U0+sRMwixTiWtqG1hOPfeXZE6YeObSawb/b8XVSdJRBHUEz2Jt7/H3l6vD6GJNHuuilKY2nZOCOw/TtclP8cmC8BuDf2FTNO+/dSH4Ss81voi9FMz6Ovp2yWR37XZ/meXzVX18Z1RvRYDB1sDXKqTZXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776861645; c=relaxed/simple;
	bh=hjP1pOAzJhGbqzG13FUbJcQMyQPsGAzZJFI+3KOX8r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M//ihNIzGlsY8zBenlAGsoHak9BrCfeM17yJaFLhg1fYWhavxgVIEKltqvMPiklcRaV5qwDn/rNRlTByFB1fS0RIHBawrhtC6smv2qR+o1zL6Gv0ha239+2t9c7BpGfWT8O0dcOdFldxzabOW4gKdMn/YjEDavj8oySms9DRbg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=czPWf+Cd; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7dbff06e4a6so5239196a34.1
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 05:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776861639; x=1777466439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Yp2C5JsOdNHQxzoSn4sl52z1fMz054/d0IStqVUGzM=;
        b=czPWf+CdFmrkv3J1Ly3PdFUHU93B5qQ985omtv6R2h5VcwObHppfPXl+XGy8t+NE6Q
         DP/88fAeNyAD1egF75p0yYu7G5mnkW3rg2PGbVgzB9w+zvwzlaSiolsjlUZFfJ5Ec0+E
         0+AVGwJyEXIxQ9xMJkuWBHTj8+AzbxXhX9Da1qDK1MwDp+8Py0bMyA/R+VjSvqRkjZ7d
         NW+Z66UjGPdte8jq9S2Cem9nmHe86Bl5J/jgVsq6w/ta/cxUp5/1QHV4IzsjeQ7vYiL7
         Ytj5FJhhHNY3ftZtn+Pufah/G3YBFZn4ckmJjG3Yychy1ObIAOI3foCPsVVoKZXkf+Uu
         mBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776861639; x=1777466439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Yp2C5JsOdNHQxzoSn4sl52z1fMz054/d0IStqVUGzM=;
        b=JCaGspzm6RbaB/tJs+b9hevxDFKrksZL9//ii0C1iF2g6KHs7e+uRwGnm9P9tuSu29
         u8QFW068ZdH8E9sDNfFpNoFnEIVi4crc6lEhZFu8HsssnvNrSNKsHS8ANNPbH5lBxtXc
         6x0GL9w7CmT0LHBS+z90X1nFo5QiNE0y3hYNR2RGd93OBuz09l1pAsqBhjrWEU+y5hV4
         U/+DQHh/eQgbbvmQFUmjl8qg7eKJecsHhS9zRPJmG7ek4zXF/1qv9XpsLoxjRPF09lAv
         ejTZCzCh9O7j/9dgMovYsWCu57JVuFjU5xI4abv/Jpa+Tdn9215WCKNrwrvOoLcMICfm
         XcWQ==
X-Gm-Message-State: AOJu0YwP8Zz6EDVX3gFH4GNGOhlq2s2LfVBnPQ6hnLVqgrCaplGgnGgI
	ka9NkIvT2TPjVGBEVbi+8XnNpaRkrlRkDeDzBXqT3gujIVdyTeScqoa5mJYAO2jndM0ZDc9EIyM
	dujwIz20=
X-Gm-Gg: AeBDievqwZCU4e6WlvIPGC+ACu2qUYeY9nl8+aD94hMBqn2vyLnzxw0j6gqW3XLivvE
	H7orR8PvHNlRL4tX4ZpXb3t5SpxiulDBLcseUbtRaUr2Sz4h8M8Bm2dYftP7a7FokudUnhMXZR9
	8KFbSmKudyqh/99H6a7k+6A4hPv69Ayju4dSqLen/ji1gSscBVbacZV1trwesE5yApl/frv3htb
	wJ+34NGUX1VxFLCFImBixhQQD5L0YFlVCWl4Zzm0Uub37jY/0V7mWl1Y9PXYHysQWIQjvVFTNzW
	aFa9quJn3N6OZ/WOm0lQgWNOIKQzkzWzhtFP4NNed4voLVT8Nl6BjuwTSmb4kgPjIjXg/OD3HEw
	OY8itFbfwNe04w/r/XaKTRQ3wvptZ5lwruR+aCDg1vvSCpoCIa6GKzks33g8/IKuSiRRmm8qbmw
	98vca+E5+ikOhNOdUCjMFHSCVZuu49DaM49+pnXP/jpbnVfQyeIRtdM/+E4e+ls53C+h+rx2x+C
	SY7dAwmf/rbLUMys+8LUJLuS2GOOQM=
X-Received: by 2002:a05:6820:98a:b0:67e:ae5:732e with SMTP id 006d021491bc7-69462ec6847mr12517592eaf.36.1776861639113;
        Wed, 22 Apr 2026 05:40:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6949127c1e2sm4493721eaf.15.2026.04.22.05.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 05:40:38 -0700 (PDT)
Message-ID: <fdbf153e-d064-4992-9c99-f6aabac030ba@kernel.dk>
Date: Wed, 22 Apr 2026 06:40:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
 <177679318887.642042.703437019420919449.b4-ty@b4>
 <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
 <f1b43e56-4724-4635-b18b-bae2add37936@kernel.dk>
 <9c20876f-1cdb-429a-abb3-5ddbcd8cac00@kernel.dk>
 <2026042205-coroner-animosity-51b2@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042205-coroner-animosity-51b2@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13120-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 4F8424462DD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/26 2:11 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 08:26:08PM -0600, Jens Axboe wrote:
>> On 4/21/26 7:56 PM, Jens Axboe wrote:
>>> On 4/21/26 7:17 PM, Jens Axboe wrote:
>>>> On 4/21/26 11:39 AM, Jens Axboe wrote:
>>>>>
>>>>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
>>>>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
>>>>>> virtual address of the io_mapped_region's backing pages directly;
>>>>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
>>>>>> just returns 0 -- it takes no page references.
>>>>>>
>>>>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
>>>>>> each inserted page.  Those references are released when the VMA is torn
>>>>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
>>>>>> drops the io_uring-side references, but the pages survive until munmap
>>>>>> drops the VMA-side references.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
>>>>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
>>>>
>>>> Actually, I take that back - what prevents the io_mmap_get_region()
>>>> in the newly added io_uring_nommu_vm_close() from getting the same
>>>> region that we initially referenced the pages from in the nommu
>>>> variant of io_uring_mmap()?
>>>
>>> I think we can get rid of that and simplify the code at the same
>>> time. Rather than need to re-lookup the buffer list, we can just iterate
>>> the pages mapped in the vma. Since this is a file backed mapping and
>>> io_uring doesn't allow remaps, that should always be the same.
>>>
>>> Greg, can you test this? I will fold this in.
>>
>> Here's the full patch - the incremental was missing a ')'. And
>> for good measure, ensure that the vma size matches the pages in
>> the region.
> 
> Yes, this works, thanks!
> 
> Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I kept your attribution with the changes folded in, it's here
since last night:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=io_uring-7.1&id=d0be8884f56b0b800cd8966e37ce23417cd5044e

Let me know if that's still fine with you.

-- 
Jens Axboe


