Return-Path: <io-uring+bounces-13122-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YL0JH9nI6GklQQIAu9opvQ
	(envelope-from <io-uring+bounces-13122-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:10:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5257744685C
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF7A63020A71
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569AE3264F1;
	Wed, 22 Apr 2026 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="IUgRpySR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871533D1CAA
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776863185; cv=none; b=h6Xr1RRWtEscb2PHipIHDn6tbuv0N6ye7GjRrqUmTTh0inWtldKcbpiDBkBk22fW6WrD3LVYQOHK2U4ClUhnPDMtrpB5yLJR/rMkjAh5LNG70G2j/XWtW0/dAPwkn32QsYTRkkQP4TNjGYFe1fyEkw+rPj/uQx+Q0J2aaJ6BeyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776863185; c=relaxed/simple;
	bh=b+FPTXNE6x45tP64kbfS7uOIqv1pOPj1nE/+3W+0LaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mgh5k2XA7yA3G2nbCIIQiqRpk9VuaUaCl47sdbxJ/GZ5f8Xbq4OfU9vNp2pi2rI9TfqZc1z48tK5VR1Y21yrV4kW6q1OQt39uBpfGRUECokd1DQU87wGNjFhPoqiJeQXPyC6Us7HcAdbeeQtZYjU1jGIdR7O8Mi+eAjVE/8UbrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=IUgRpySR; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-42fc6923f38so383432fac.1
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 06:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776863181; x=1777467981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=plv2+BMXBiSdZ7uZNMQJg8z2tSUYxRESbubW7ArBy7Q=;
        b=IUgRpySRu1C6Vnf4C8K7W9ZSMSQmv6G8Cp+s/WpjuuW6FuNniAF5osbVNOlbMxjo3B
         3mXv/TD8lP9/oIQTce8Lr6TpPlacTZZrrI2RKQTFHk79qXpi6DiYu57jwwKbqcZJEDEM
         Cw3lVDgZSZm+QoHQ2Nat4TGsRUeLF+w+lt2S4kj7VP9CgjQEVWvrU26xvphjdcjDiJIo
         71kkdCjx2QFSQ30sIcBDxSGKAU0tPLhCSe7cOZphpPFbo0L6PZZ2EjSuJfBuGvnLEoT1
         VcbsHXRc4ia0cUEJ2peqLQ81zpFVzP2KNIG5+JA5oGZ75rz/21upYrjhZfGSzUKBobTD
         lmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776863181; x=1777467981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=plv2+BMXBiSdZ7uZNMQJg8z2tSUYxRESbubW7ArBy7Q=;
        b=cODo+sNSs4Y/kWmum6Iwx6zD/DC7tXdKPtl4fciKPuS6vxoF8Zx3s9m0g0wcIeVyR+
         y3t7LhrA4i549PtWVK5yle6B1KsYXvJ8B78K5OBc+NdkfC5Mrs8r8+C4xxi/xLQcDVz4
         9wyB9ObmygeiF/1yuwhw4GPGHUOIZ5ke1u6BzfQsP+GjjUOzrMnoAgkULsUgbDwJ4XZV
         TrQXQJJ3V4x4cFFaU7HZLNRzPJdADCN1fgyq6J65pHm6mxS8hvr1heqbXhOnNKj0ep/k
         YEastxSDaWV7bTsDrq3wYMDc4YYYdcEBfkwR5V4z54GXy7ajvK+6yJehnQWCrMSEsudk
         1YCA==
X-Gm-Message-State: AOJu0Ywc9+8zniM/ptecHBAjuHzgnaaTyKy6QNPO81KAhs3AS82pMIsX
	xMKR8kHa58mwx0jPRnuVvB4r5P0QMLbJAfAaqaBrqRLmdQzZSFtUjC5HQGlAGqR+1JuGLeQz/zF
	N0M2MFNw=
X-Gm-Gg: AeBDieseN9HzH5CBqeUhGdu8PWTP0rq4bSyD/TSvd3rLlxSS1HqaYCRIdZEGwMEP4j+
	ilU3oSqBvPGPB7rMBQ9KqSjB7K1XDtj7eTkSCTmNrzQx0LyZj5frLbnL125cFUI2/+Uyeva5I4F
	kdf/X+1fyEUovFEru4+Uk6bfXp0zpK72gPiR5J7EvrlloKCadGpYzr9IBCIMc/Cr6CwaoLRis81
	rFr4pnNkG0HvHbEW0hbc6fdSJdmfrLxVLuU2FvaXviWoU7GT58gR4ZUBDCreA2a4sYj+Yshwy3O
	BNgRv2q37PWhsJPH2qfuwgAmS+QJvwZMYYntYNTNS06HSmrOZLZNjiC1GLhyuGIaSIhGp9uf81+
	1DrZYEx0R8hB/S5iAHc6FIiUn4a2f/CLHrFxqaTpc/E4wvb+SZ7X7Dc9opPn1Y66offyn/0miFy
	zNFQsB1RdnSkbD8vek1O0fcUATR4GpDDGOlFlDcqINvbNtkU28+4AmHOX8dWMijTP4RIOwCl0PZ
	pkwlrRMIIhal0uf/lY2
X-Received: by 2002:a05:6870:31a9:b0:42c:7f7c:461c with SMTP id 586e51a60fabf-42c7f7cbf7amr3836194fac.17.1776863180849;
        Wed, 22 Apr 2026 06:06:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42fb269f69bsm3887152fac.12.2026.04.22.06.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 06:06:20 -0700 (PDT)
Message-ID: <2f2c91cb-f20e-44eb-8ba3-2d5b3d649642@kernel.dk>
Date: Wed, 22 Apr 2026 07:06:18 -0600
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
 <fdbf153e-d064-4992-9c99-f6aabac030ba@kernel.dk>
 <2026042236-alienable-lilac-f857@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042236-alienable-lilac-f857@gregkh>
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
	TAGGED_FROM(0.00)[bounces-13122-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 5257744685C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/26 7:03 AM, Greg Kroah-Hartman wrote:
> On Wed, Apr 22, 2026 at 06:40:37AM -0600, Jens Axboe wrote:
>> On 4/22/26 2:11 AM, Greg Kroah-Hartman wrote:
>>> On Tue, Apr 21, 2026 at 08:26:08PM -0600, Jens Axboe wrote:
>>>> On 4/21/26 7:56 PM, Jens Axboe wrote:
>>>>> On 4/21/26 7:17 PM, Jens Axboe wrote:
>>>>>> On 4/21/26 11:39 AM, Jens Axboe wrote:
>>>>>>>
>>>>>>> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
>>>>>>>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
>>>>>>>> virtual address of the io_mapped_region's backing pages directly;
>>>>>>>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
>>>>>>>> just returns 0 -- it takes no page references.
>>>>>>>>
>>>>>>>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
>>>>>>>> each inserted page.  Those references are released when the VMA is torn
>>>>>>>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
>>>>>>>> drops the io_uring-side references, but the pages survive until munmap
>>>>>>>> drops the VMA-side references.
>>>>>>>>
>>>>>>>> [...]
>>>>>>>
>>>>>>> Applied, thanks!
>>>>>>>
>>>>>>> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
>>>>>>>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e
>>>>>>
>>>>>> Actually, I take that back - what prevents the io_mmap_get_region()
>>>>>> in the newly added io_uring_nommu_vm_close() from getting the same
>>>>>> region that we initially referenced the pages from in the nommu
>>>>>> variant of io_uring_mmap()?
>>>>>
>>>>> I think we can get rid of that and simplify the code at the same
>>>>> time. Rather than need to re-lookup the buffer list, we can just iterate
>>>>> the pages mapped in the vma. Since this is a file backed mapping and
>>>>> io_uring doesn't allow remaps, that should always be the same.
>>>>>
>>>>> Greg, can you test this? I will fold this in.
>>>>
>>>> Here's the full patch - the incremental was missing a ')'. And
>>>> for good measure, ensure that the vma size matches the pages in
>>>> the region.
>>>
>>> Yes, this works, thanks!
>>>
>>> Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> I kept your attribution with the changes folded in, it's here
>> since last night:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=io_uring-7.1&id=d0be8884f56b0b800cd8966e37ce23417cd5044e
>>
>> Let me know if that's still fine with you.
> 
> No objection at all, looks fine, thanks.
> 
> And sorry for this, no-mmu is odd, hopefully the 3 users of it and
> io_uring are thankful for this work :)

Basically everything we do in the kernel is a thankless task, so I'm not
expecting someone to send me a box of chocolates. But at least it should
be sorted now!

-- 
Jens Axboe

