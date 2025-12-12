Return-Path: <io-uring+bounces-11023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 61850CB858E
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 09:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55089300EE49
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 08:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13C72989B5;
	Fri, 12 Dec 2025 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PJQA6Dmf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193D419258E
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765529945; cv=none; b=aZ91ETIoWW2aDY1Y56gb09wtQYPDbfODV9m2o4H//iVsOryyPLqkZn0rApYI/lPq+uhHSxrZpUpPYT2XArHjE4LMOEwPGvGpXK2N9iTNkXXZB2TUfM6PvtRc0q0UR2EaobSR1TOhkvm9/SF32fjwixhq5exkPvaW94Wa1ZaOSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765529945; c=relaxed/simple;
	bh=Lig0LqSoxrsMIPZOVo41vDENsNaV3wyO/82LYNDFXkM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GvsnJl4DEbRI0+ZvPaNQbF/p87D9DgZolu72fFKrG9klBp4IcI7b0OShCPt/QxbCrz3SnMPBU5G/ndBGXtWd4GrEyRRzhwYVb3gUurqi475s1uF3GtA/b9EKXvEgEW23T8j9/5q61QmEJW3qWHkttwaDXh35gV4oo9fgfVA6M/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PJQA6Dmf; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-29808a9a96aso12599575ad.1
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 00:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765529941; x=1766134741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u1xQgbothloxarLneTHB92ruyodVZcrboELr7LaPYJU=;
        b=PJQA6Dmf3PcYBJUaxTPjEUBqemz9SPVuHe1EUHeeHxg77ELhgDjw2IFGWbQRlesiGL
         YN1K23KmAHPYlv/YqgJYGuo6ccNuKuvcFZGM84LD8bdHSKKp3rcpVVXFq9QHRQjuSrVQ
         HzX7LQyjSdAJfb4VInG4nLXUyVpl9IYZFc/4fH6FCpQxHnrkL5PFlsqeZzfPFbmp9j0F
         noItJKD2fZDnUEDMmDviO5dj05kNZ0dORuTnmZq+3QzkEoMiSy1s9cZddH1HKVhgZOYh
         rSFota3gMBlygWgfpospG2fpAkLVpaYmKupQCA54F200cseDVLjSCBzCPROLvuCtxIcx
         FXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765529941; x=1766134741;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1xQgbothloxarLneTHB92ruyodVZcrboELr7LaPYJU=;
        b=JLWrcZh2B21kijUBQxOq+YPpeBPTEswc14b89TD+uVm5Y6DULZEQpWSa5UGvpJqhKv
         yYUDbZm5fSIP1R1yPFcQOg4g774KW8OyYmWm/TwMDqV5rAjJHqEV8I6ZMJ7Q5O/ydBJ5
         oUY+uOhOnO/FMygP4dUjrWx+OG4NknNeKKmfnJBz570OxPvFNMDFHeghHxy63+ybkAFx
         ymtvXvlojZHDwOrZr/rNK1HHJOObbwMIt1nCBhNmgV3xcSC6s0aJmEAEtTIIpo8y1uD2
         OqfwDShqYATU0A2r4G+3cWm7IAmwvgtsGC+IgNlzvtp0Rf0MEDsYgT1juyClj8r9BWIW
         4rrw==
X-Forwarded-Encrypted: i=1; AJvYcCVIYVX9Q58BzVY7UwkhXj0KBnmbpmCgZTWC7YiSZWvyB5dJPNKd6wvOIvGg/QA0rNzOAnlneWNVUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGstS0s/66oivkJDoqaUxWvFEDaMuLXAXlWjH42lVuHwUG03fO
	zRGnpA8JSfKVlDkoX1eyGcn6k/xRfrO0hS9a9/rcqaftRF/pkgKFxtz/boFNbDgA+Sw=
X-Gm-Gg: AY/fxX43OYIiJCcs8ZexXPIRzY+oxCeFHa/UoaR5ya0dyfaSDVOrIWRso7ycOofj1Rg
	IFQzPWW+Ed2VsCXDXI6NDFsf8Ee/BfJvk77mgejFfouVkEqKV+sRWP9ZeyUmE8lEQDghcV0V1MG
	2LEyl9jznXOQNrhBtBIkqUbnEmzWaZ2z4kXLmxFHBgpAGg2n5YE1LmdPdHcMoY5VDREwKOSGA08
	btBtmbnWICI7cNlMN8meVgBBMjyW7OVlT7s7xVy0IWq3mv4IJuWShfls2dbQ/UKdIRlzXPJeN+/
	GXrVhsoekilpgcQV6H3J70dZSgxHF3Z5dWm0TYKQGa+M3ITzQALp3ku1KHdZXcNd/BeIxK9y44A
	0FQBDd7xqR+Gsekpf7+lJ3iaTuzGtpA9ozG+JdZjjSEfRWk5WJyPk3aDdnqomHLrYGMH8x8mt8H
	7offgUJEhUDgsflL+yGYLTSq4FpQcTHJH3SiR/SpaTKoBsvhjqHQ==
X-Google-Smtp-Source: AGHT+IH5FTDn8i1xn0rlsANc0F5jSSd1Qwf1hA2ZlTorg/VsnGduGEYj/xvEQ0zR9ZQdKbHyEtt82A==
X-Received: by 2002:a17:903:2bcb:b0:28e:aacb:e702 with SMTP id d9443c01a7336-29f23dfdda5mr17611585ad.2.1765529941115;
        Fri, 12 Dec 2025 00:59:01 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38c74sm48269385ad.31.2025.12.12.00.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 00:59:00 -0800 (PST)
Message-ID: <38972bbc-fb6f-42c5-bd17-b19db134dfad@kernel.dk>
Date: Fri, 12 Dec 2025 01:58:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
From: Jens Axboe <axboe@kernel.dk>
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
Content-Language: en-US
In-Reply-To: <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 10:11 PM, Jens Axboe wrote:
> On 12/11/25 7:12 PM, Fengnan Chang wrote:
>>
>>
>> ? 2025/12/12 09:53, Jens Axboe ??:
>>> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>>>> Oh, we can't add nr_events == iob.nr_reqs check, if
>>>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>>>> iob.nr_reqs will be 0, this may cause io hang.
>>> Indeed, won't work as-is.
>>>
>>> I do think we're probably making a bigger deal out of the full loop than
>>> necessary. At least I'd be perfectly happy with just the current patch,
>>> performance should be better there than we currently have it. Ideally
>>> we'd have just one loop for polling and catching the completed items,
>>> but that's a bit tricky with the batch completions.
>>
>> Yes, ideally one loop would be enough, but given that there are also
>> multi_queue ctx, that doesn't seem to be possible.
> 
> It's not removing the double loop, but the below could help _only_
> iterate completed requests at the end. Rather than move items between
> the current list at the completion callback, have a separate list just
> for completed requests. Then we can simply iterate that, knowing all of
> them have completed. Gets rid of the ->iopoll_completed as well, and
> then we can move the poll_refs. Not really related at all, obviously
> this patch should be split into multiple pieces.
> 
> This uses a lockless list. But since the producer and consumer are
> generally the same task, that should not add any real overhead. On top
> of the previous one I sent. What do you think?

Ran some quick testing, as one interesting case is mixing slower and
faster devices. Let's take this basic example:

t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1 -t1 -n2 /dev/nvme32n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1

where nvme32n1 is about 1.27M IOPS, and the other 3 do about 3.3M IOPS,
and we poll 2 devices with each IO thread. With the current kernel, we
get:

IOPS=5.18M, BW=2.53GiB/s, IOS/call=31/32
IOPS=5.19M, BW=2.53GiB/s, IOS/call=31/31
IOPS=5.17M, BW=2.53GiB/s, IOS/call=31/31

and with the two patches we get:

IOPS=6.54M, BW=3.19GiB/s, IOS/call=31/31
IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31
IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31

or about a 25% improvement. This is mostly due to the issue you
highlighted, where you end up with later completions (that are done)
being stuck behind waiting on a slower completion.

Note: obviously 1 thread driving multiple devices for polling could
still be improved, and in fact it does improve if we simply change -c32
to something lower. The more important case is the one you identified,
where different completion times on the same device will hold
completions up. Multi device polling is just an interesting way to kind
of emulate that, to an extent.

This effect is (naturally) also apparent in the completion latencies as
well, particularly in the higher percentiles.

Ran peak testing too, and it's better all around than before.

-- 
Jens Axboe

