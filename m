Return-Path: <io-uring+bounces-1910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B09A8C78CD
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 16:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B70012841A7
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 14:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062961E491;
	Thu, 16 May 2024 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xaubJDsB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578C26ACA
	for <io-uring@vger.kernel.org>; Thu, 16 May 2024 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715871489; cv=none; b=KGx+HiST2SpG4Dnt8cnokw6m4siWqbrrGMDeHL3MUMXJB5GGZ3dE/o/CqmayZpGVcKiD4+UXeUILR7p8PqN/C3Ao42+gk/a+/MvBkhzvxpqsJ0hSFotUNaMJ8iz+xyfHyzuChBW/CPxYOz0VCG2K4KFUI/BqqqPJi3JeQgV9Ffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715871489; c=relaxed/simple;
	bh=G2M1ZNz8TeABHM6N66RwUVX4vjSA+XLg7ApOA4W24Qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVdQ5jIKy3kmauaRr+1soPripuXLjWEGm2OweDAEnKLoCGIoV4zvMD2W8lvaLbn4OEaNhzw5RBJLCW3RuZcrSI4wUPsufqY7sJI3/jmv7Uun1viot91jCWyi/rzvRAEHHPzlWAOWfbhOSHLpQHWsKE8V3nGX0s2u2NZds1anPuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xaubJDsB; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7e1fb2a81fdso4265739f.1
        for <io-uring@vger.kernel.org>; Thu, 16 May 2024 07:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715871485; x=1716476285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2yBFtN2JfPYfTtvkmeAOQH5S0c+hEbimpGgkq7JKJE=;
        b=xaubJDsBg+OHXH07wsRR1vE43itx57mDebn6HC9fyM0oZgEhyu40EbjkjmJYbPx4t0
         tX8PBUBpSRgH3A6zja+A+9tjfm4MHK5W78nghk13wsM2UhtO7lu+UN8B15F/Ol/sZezW
         KK/5SbINlv+n/ykINYz+xCtYAp/M51uC2zvNW9ntZyLIvYaUIFtYfIVUgWOfPh32Gh/P
         QwXe7sOCaO1d/cvFwbNePb9UAeZO7uuolBQHCDa0E7Z3xNJxjf7b4e9hNuEEkuu3iKJI
         EAAM9YF5T8AblmkbtpmlYORa8mFUS+lZZxzUuPZnPOC19NgoNn57Iy4tyBsmJ/bO8g5D
         LqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715871485; x=1716476285;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2yBFtN2JfPYfTtvkmeAOQH5S0c+hEbimpGgkq7JKJE=;
        b=uoR8JTsxHu8jQiU86cLM6fCdjyFaMhSDGx6td/W/VDLKXA0j7Rysh43yFn2wmHR1Bg
         Toi0oayN7cUElQDHXtEbGFK2UgpxIaCXzkb6LVKEW0+JeJpkoa11G/kVB6TPvao5LXmZ
         Vq32JnO8+anxJ12N652rhYXCJygQX3H5CJWeBy+DwMo4b6B7ELqhZdqDzANj388ROtPB
         v4r0jNBnWIxfOp0wBwetO1O8Ky7A7fZyd56MOBXiF/QaQD5zuEqFVuHctxSpUeSgfI+F
         oHI2OpE9NPFhdBMzSLfKh/cdXXQ/kzo9VXp/rT+Pox1NmK5kN6Wb2vywLkdb/M6E3XLE
         kLwA==
X-Forwarded-Encrypted: i=1; AJvYcCWSbe579KrBV5Vn9T2odUWFUeymoVCliuv88YQdZx+xZVTja821h5ARKJmPq7/+pwd06B2pd8u+yCTWqqsTjqS4ZzuxZnqVibU=
X-Gm-Message-State: AOJu0YwTJwIjgO2DC3c9i8dXt4fBfwCNpr+w7JM71XWztSPOHI7/7pZs
	ELxEUn9/KFG9sxbte+62Ti0blJbDkTbXX1RdT8ns66TudHffr8Vd5l2Y6X2nPPs=
X-Google-Smtp-Source: AGHT+IF8ZtqYHTVbu4IQWyfsygl1+ooZh/vXzXPKwJZAlvxTyaUf44TzAJ2DG9c8PTHM0cF2vFAyHA==
X-Received: by 2002:a5e:8704:0:b0:7de:e495:42bf with SMTP id ca18e2360f4ac-7e1b51f3e6amr1940740039f.1.1715871484555;
        Thu, 16 May 2024 07:58:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4893700e498sm4060857173.32.2024.05.16.07.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 07:58:04 -0700 (PDT)
Message-ID: <c99eb326-0b36-4587-b8a2-8956852309be@kernel.dk>
Date: Thu, 16 May 2024 08:58:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Anuj gupta <anuj1072538@gmail.com>, Chenliang Li <cliang01.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
 gost.dev@samsung.com
References: <CGME20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be@epcas5p1.samsung.com>
 <20240514075444.590910-1-cliang01.li@samsung.com>
 <CACzX3AvTUJqmtD+qDhLimGde2WZUuSVa=sY+jYJ8-OB43TkoWw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AvTUJqmtD+qDhLimGde2WZUuSVa=sY+jYJ8-OB43TkoWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/24 8:01 AM, Anuj gupta wrote:
> On Tue, May 14, 2024 at 1:25?PM Chenliang Li <cliang01.li@samsung.com> wrote:
>>
>> Registered buffers are stored and processed in the form of bvec array,
>> each bvec element typically points to a PAGE_SIZE page but can also work
>> with hugepages. Specifically, a buffer consisting of a hugepage is
>> coalesced to use only one hugepage bvec entry during registration.
>> This coalescing feature helps to save both the space and DMA-mapping time.
>>
>> However, currently the coalescing feature doesn't work for multi-hugepage
>> buffers. For a buffer with several 2M hugepages, we still split it into
>> thousands of 4K page bvec entries while in fact, we can just use a
>> handful of hugepage bvecs.
>>
>> This patch series enables coalescing registered buffers with more than
>> one hugepages. It optimizes the DMA-mapping time and saves memory for
>> these kind of buffers.
>>
>> Testing:
>>
>> The hugepage fixed buffer I/O can be tested using fio without
>> modification. The fio command used in the following test is given
>> in [1]. There's also a liburing testcase in [2]. Also, the system
>> should have enough hugepages available before testing.
>>
>> Perf diff of 8M(4 * 2M hugepages) fio randread test:
>>
>> Before          After           Symbol
>> .....................................................
>> 4.68%                           [k] __blk_rq_map_sg
>> 3.31%                           [k] dma_direct_map_sg
>> 2.64%                           [k] dma_pool_alloc
>> 1.09%                           [k] sg_next
>>                 +0.49%          [k] dma_map_page_attrs
>>
>> Perf diff of 8M fio randwrite test:
>>
>> Before          After           Symbol
>> ......................................................
>> 2.82%                           [k] __blk_rq_map_sg
>> 2.05%                           [k] dma_direct_map_sg
>> 1.75%                           [k] dma_pool_alloc
>> 0.68%                           [k] sg_next
>>                 +0.08%          [k] dma_map_page_attrs
>>
>> First three patches prepare for adding the multi-hugepage coalescing
>> into buffer registration, the 4th patch enables the feature.
>>
>> -----------------
>> Changes since v3:
>>
>> - Delete unnecessary commit message
>> - Update test command and test results
>>
>> v3 : https://lore.kernel.org/io-uring/20240514001614.566276-1-cliang01.li@samsung.com/T/#t
>>
>> Changes since v2:
>>
>> - Modify the loop iterator increment to make code cleaner
>> - Minor fix to the return procedure in coalesced buffer account
>> - Correct commit messages
>> - Add test cases in liburing
>>
>> v2 : https://lore.kernel.org/io-uring/20240513020149.492727-1-cliang01.li@samsung.com/T/#t
>>
>> Changes since v1:
>>
>> - Split into 4 patches
>> - Fix code style issues
>> - Rearrange the change of code for cleaner look
>> - Add speciallized pinned page accounting procedure for coalesced
>>   buffers
>> - Reordered the newly add fields in imu struct for better compaction
>>
>> v1 : https://lore.kernel.org/io-uring/20240506075303.25630-1-cliang01.li@samsung.com/T/#u
>>
>> [1]
>> fio -iodepth=64 -rw=randread(-rw=randwrite) -direct=1 -ioengine=io_uring \
>> -bs=8M -numjobs=1 -group_reporting -mem=shmhuge -fixedbufs -hugepage-size=2M \
>> -filename=/dev/nvme0n1 -runtime=10s -name=test1
>>
>> [2]
>> https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u
>>
>> Chenliang Li (4):
>>   io_uring/rsrc: add hugepage buffer coalesce helpers
>>   io_uring/rsrc: store folio shift and mask into imu
>>   io_uring/rsrc: add init and account functions for coalesced imus
>>   io_uring/rsrc: enable multi-hugepage buffer coalescing
>>
>>  io_uring/rsrc.c | 217 +++++++++++++++++++++++++++++++++++++++---------
>>  io_uring/rsrc.h |  12 +++
>>  2 files changed, 191 insertions(+), 38 deletions(-)
>>
>>
>> base-commit: 59b28a6e37e650c0d601ed87875b6217140cda5d
>> --
>> 2.34.1
>>
>>
> 
> I tested this series by registering multi-hugepage buffers. The coalescing helps
> saving dma-mapping time. This is the gain observed on my setup, while running
> the fio workload shared here.
> 
> RandomRead:
> Baseline        DeltaAbs        Symbol
> .....................................................
> 3.89%            -3.62%            [k] blk_rq_map_sg
> 3.58%            -3.23%            [k] dma_direct_map_sg
> 2.25%            -2.23%            [k] sg_next
> 
> RandomWrite:
> Baseline        DeltaAbs        Symbol
> .....................................................
> 2.46%            -2.31%            [k] dma_direct_map_sg
> 2.06%            -2.05%            [k] sg_next
> 2.08%            -1.80%            [k] blk_rq_map_sg
> 
> The liburing test case shared works fine too on my setup.
> 
> Feel free to add:
> Tested-by: Anuj Gupta <anuj20.g@samsung.com>

It's even more dramatic here, excerpt from profiles:

    32.16%    -25.46%  [kernel.kallsyms]  [k] bio_split_rw
     8.92%     -8.38%  [kernel.kallsyms]  [k] iov_iter_is_aligned
     6.85%     -4.31%  [nvme]             [k] nvme_prep_rq.part.0
    14.71%             [kernel.kallsyms]  [k] __blk_rq_map_sg
     9.49%             [kernel.kallsyms]  [k] dma_direct_map_sg
     8.50%             [kernel.kallsyms]  [k] sg_next

some of it just shifted, but definitely a huge win. This is just using
a single drive, doing about 7GB/sec.

The change looks pretty reasonable to me. I'd love for the test cases to
try and hit corner cases, as it's really more of a functionality test
right now. We should include things like one-off huge pages, ensure we
don't coalesce where we should not, etc.

This is obviously too late for the 6.10 merge window, so there's plenty
of time to get this 100% sorted before the next kernel release.

-- 
Jens Axboe


