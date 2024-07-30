Return-Path: <io-uring+bounces-2599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F63694113A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 13:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 080F01F21A75
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 11:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953DC19307A;
	Tue, 30 Jul 2024 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrjjWaJD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA818C336
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 11:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722340539; cv=none; b=VKOyzXTAXZes31iedeBwzw+To6IXWfzTExttSSfKv2xvru3AWpT12tTwhUMpzLs3IJbVaM/F9NSKKSYCtq8UY5A/vd4fy6fVb+VC0nRhStFtw/Y8GGYc/9WebyBaNIw97yFMsiGKBMsLxowxJdrC4muDkfBM71wLitXrElgll+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722340539; c=relaxed/simple;
	bh=1d0RmadovggvD9VtdQy1ldZci5m0qY9LA0sydkmb4k4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLx1+evb1vlXiddziWgu1PfW0fmVPLBcY/JZQkrUqEkF2L3rJr50mO4OoD5UTHNwXdQWVjHHmcm5DplUq0kZ8BSzrd8SXBsOeqaFNAcZmaEjVPHee4UK2LKOY3gxfCvz/vFKToUOT8nZR5CqrwE9N4LEBH8xyEpWG8OmLijKz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrjjWaJD; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efbc57456so4706066e87.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 04:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722340536; x=1722945336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WvMj7iZx7oW64VS78EdH5EjPzhUi2pueakmSjKQ3NwQ=;
        b=SrjjWaJDnlM62hxH8L+l1P2r70K+r6q4p8dqcZlIXMVVWN/AWIR59iKEqMWHP7/hay
         EsT1med5gBg9bjBpHnBO0HVzqenL1BeZhLDGVkbdJoL0qr1EdGNlCP1EE4+W3R3mXndO
         FmQPCj924pXMYpvD+ySkHqN8cXd4TSJbMEHJH/nq1/bu8SbentzK9ZIDMUW4yygsNZov
         nQ4a+YSytfrJZkl+xr/RNGLY+IGso78FdMJ7RaCcHsopd4N7Gt7hty30dC9O2jUWJRuY
         wNE2LGrzcv/wgimR1jMfIyF2ub3DIzx/6xrwi23EXLmmCt39HH8CYBnBD8CEb5hEhS5I
         zczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722340536; x=1722945336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvMj7iZx7oW64VS78EdH5EjPzhUi2pueakmSjKQ3NwQ=;
        b=PHdkQmV32/wsgm9f8TeyNz/TZSliLua6uxwWimo3dVUNtpNUfja71wJQhg4aaAextj
         tFpkHuSxgqsQKgABGvQFXCZCmKBXCCp2U75pNcmmP8kwxOAuDfWd11vTMieITIdJ4q2Y
         ilnHle96HDprKh/K3mmlm6/p2lmdEp8SrUT0f8VBI3IefZn0GtX/l2mQ32g6KK6nrNe9
         7lWzgyZGaZxsp+TJw4AP0gMXJs+aci0uL44htKzxngeebgvYc9DMrHzyuh8tU8Y+m7DV
         wr+Z/3kXT/2MsFla3Trw5TyYiSKehx4zyHWbJYfOukyh0GJZx1CqM0z5y4nvjRYQF1EM
         6Dag==
X-Gm-Message-State: AOJu0YzXUTvsSgr5px3XjgYtOGIqby6rXJCG8xj0PWM+iGhp9qVfHQow
	LYQ77qRXeodkL0wGJ5JSE5FFbJjUdQEBObMXNXYcykT/tPhB8Etx6LRIEg==
X-Google-Smtp-Source: AGHT+IG6pdtKqmIEvCHSOqyCOEEMtL9BbrvkjgskD+CwIUWJJnPeMy4cqg58gulApiIbmaehjSDQMw==
X-Received: by 2002:a05:6512:2209:b0:52e:fada:eff3 with SMTP id 2adb3069b0e04-5309b269c61mr8199536e87.11.1722340535608;
        Tue, 30 Jul 2024 04:55:35 -0700 (PDT)
Received: from [192.168.42.143] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acab260besm630272166b.4.2024.07.30.04.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 04:55:35 -0700 (PDT)
Message-ID: <54ef8248-29ac-4c0e-b224-8515b4c604cc@gmail.com>
Date: Tue, 30 Jul 2024 12:56:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v7 0/2] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20240723055622epcas5p119f4befb453407a7ac756c1cee582ced@epcas5p1.samsung.com>
 <20240723055616.2362-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240723055616.2362-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 06:56, Chenliang Li wrote:
> Registered buffers are stored and processed in the form of bvec array,
> each bvec element typically points to a PAGE_SIZE page but can also work
> with hugepages. Specifically, a buffer consisting of a hugepage is
> coalesced to use only one hugepage bvec entry during registration.
> This coalescing feature helps to save both the space and DMA-mapping time.
> 
> However, currently the coalescing feature doesn't work for multi-hugepage
> buffers. For a buffer with several 2M hugepages, we still split it into
> thousands of 4K page bvec entries while in fact, we can just use a
> handful of hugepage bvecs.
> 
> This patch series enables coalescing registered buffers with more than
> one hugepages. It optimizes the DMA-mapping time and saves memory for
> these kind of buffers.

Doesn't apply, please rebase on top of io_uring-6.11.

iter->nr_segs = bvec->bv_len;

seems your tree is missing the fix you sent before


> 
> Testing:
> 
> The hugepage fixed buffer I/O can be tested using fio without
> modification. The fio command used in the following test is given
> in [1]. There's also a liburing testcase in [2]. Also, the system
> should have enough hugepages available before testing.
> 
> Perf diff of 8M(4 * 2M hugepages) fio randread test:
> 
> Before          After           Symbol
> .....................................................
> 5.88%                           [k] __blk_rq_map_sg
> 3.98%           -3.95%          [k] dma_direct_map_sg
> 2.47%                           [k] dma_pool_alloc
> 1.37%           -1.36%          [k] sg_next
>                  +0.28%          [k] dma_map_page_attrs
> 
> Perf diff of 8M fio randwrite test:
> 
> Before          After           Symbol
> ......................................................
> 2.80%                           [k] __blk_rq_map_sg
> 1.74%                           [k] dma_direct_map_sg
> 1.61%                           [k] dma_pool_alloc
> 0.67%                           [k] sg_next
>                  +0.04%          [k] dma_map_page_attrs
> 
> The first patch prepares for adding the multi-hugepage coalescing
> by storing folio_shift and folio_mask into imu, the 2nd patch
> enables the feature.
> 
> ---
> 
> Changes since v5:
> - Reshuffle the patchset to avoid unused funtion warnings.
> - Store head page of the folio and use folio offset to get rid of
>    branching on bvec setups.
> - Add restrictions for non border-aligned folios.
> - Remove unnecessary folio_size field in io_imu_folio_data struct.
> 
> v5 : https://lore.kernel.org/io-uring/20240708021426.2217-1-cliang01.li@samsung.com/T/#t
> 
> [1]
> fio -iodepth=64 -rw=randread -direct=1 -ioengine=io_uring \
> -bs=8M -numjobs=1 -group_reporting -mem=shmhuge -fixedbufs -hugepage-size=2M \
> -filename=/dev/nvme0n1 -runtime=10s -name=test1
> 
> [2]
> https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u
> 
> Chenliang Li (2):
>    io_uring/rsrc: store folio shift and mask into imu
>    io_uring/rsrc: enable multi-hugepage buffer coalescing
> 
>   io_uring/rsrc.c | 149 +++++++++++++++++++++++++++++++++++-------------
>   io_uring/rsrc.h |  10 ++++
>   2 files changed, 118 insertions(+), 41 deletions(-)
> 
> 
> base-commit: ad00e629145b2b9f0d78aa46e204a9df7d628978

-- 
Pavel Begunkov

