Return-Path: <io-uring+bounces-8597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 831A4AF6666
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C81D7B1636
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C92243964;
	Wed,  2 Jul 2025 23:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCIU2Dj4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0283236A9F
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751500177; cv=none; b=MvxGQO1Vt7dOJv7U7mK+NGFLtK8IYzE4OuuirzuDOtNSbRWyHFbfElhsqM38gTzOUn3ZGU003WPpVH1OxFrj6CwLhB5YG7OsOJAac9t0q6kBxJAyOZpXnUcMY5ipqt65P6svZlfPOox8m1HLPpNmmIjxDJEjSY4DUyMO40hoE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751500177; c=relaxed/simple;
	bh=Rpzvgj/pRw7LkLuhQ/dYOJQtG8FVSRKw6Xjna6/A+fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SgRJ6GXFT/hS3vd5gq1DouE64LumJ622/ZscW/T7x91V2ear/hZPZifpXp/AqxgOb+Vc4PZXtxv8BgyEXKqh171HpsRydBfDYVW3gtPXdQP+BlhEaUfjVd+WsKeNCs59G+1iy3nVUksNpyjBBQKITZGUK5VOldwWIBCDvzWC9OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCIU2Dj4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2349f096605so61304865ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751500175; x=1752104975; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iplCMGc+jBfBNFTKXiL4tUS+f9Ffyd+rLQ3Z3pnpf+c=;
        b=mCIU2Dj4QskL3s0wT3yRjLF4sNMDBWxTm0OiTG9JqXqjG3keQI6bX0jP/n286P2DW3
         JIf78DSiDNeuyTgOQBxX/pBgBTLYRce7WdVUMyAfSR7SBdVCcKeNmn1eX8rCnU0obVoX
         beEY2E7j6hpf68DE/U+2xH7hgBj4UCMVBj2dr3uXwZreiTKIjQWCsFH0kGmORNhEshdh
         vegAn+m1pxEatBIq8vvCKxcW4s4vMyvVN+3Kj3PqYN1TGGdMomfEKkZh+rkAwCES0fQQ
         foeJe+PxXDR1GyWlwAFw4vPjVfetA+784q0eudEzyCKuFF6Hr6A3YSHnQbk0OMS+gziw
         kNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751500175; x=1752104975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iplCMGc+jBfBNFTKXiL4tUS+f9Ffyd+rLQ3Z3pnpf+c=;
        b=kEeoVSVTNgae58fOpnp5z6nQFWkhvNeUA5ynlm5k67/Y1rEmtGq3NLOongsgLjBp2x
         PELcs0yogRIS+72cvMM3MiyML7AHu5i7JuU/opp1mcYSIs22QN6PIwJbwOmOObsRDgPf
         JB98a/YAQ6U8eJr9nv39VEOFBpQ6yLwLR56kE9JLk8AH8FL/uSTDOKN9czeFReMl8qdH
         yjfF8g92slAZcenMsdMHIl6CJFCfMa7ng4YllkXS4TkGn0RkojWLzBS+Rw01PiGV6Q5D
         AfEE+/zrs5dbgNO20YjKTG0FKDEwIHvdQvo5zhg+xo82OT1SojKbIDNFvt7T3yZoJ0N0
         05WA==
X-Forwarded-Encrypted: i=1; AJvYcCWjiZyggRe224pUoTmtsSh22Q+rKkxVqg7Vk1CJe2DEoXp5yLNvLW0Ga9cyiqhPAktf2qL9STVNnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnczM/z5f3Q4XpcJ2A/8K9ahA0lFXaAXraWrVPDZQ5Ka0hLkfD
	NX/La3iQZWmnFYsz1gkzg3HjFDyJ6zIx5NApsyXp35a0E1kJKl4IiJUs
X-Gm-Gg: ASbGncscuhCDz3SkkRyio7b2AQBBkUq1HkjSCG2FVii6q+Dg2Zc/NtJGKCnBYUIwk3t
	fi45AjJoL5wcEcJEvZagCphV/m1LueTRhXJNntw1RlKad7TjIgB4owCgLj7Af+rWCTfFq8agCkf
	gopMcTz0guOkj4cTP/2xkUpHPx1tti8/EJHdyKqyadAFoMkJZYL+VscTUjd1qQp6oj0k5iLOKyJ
	/uf0uKruli0Xs56mo7oRLpcF13bnjPuCVJCYivOjYrD44Vvn4VxT5ER1yc3Zmmyv/+CkaLjmnrH
	04eL6XyK8x4R9daHntiefy9VbD941YDS5nnwsOjZ3dF/WRJzql6HPW8TozWE/qLkHNGO0CtUOTH
	E/twKwsg=
X-Google-Smtp-Source: AGHT+IFeuKAJrhH1vUxTbXDtNoBhXumRIne7p/YiBBiGTd2IVq94pPkCC+C788CKX3q57CYF5W+ABA==
X-Received: by 2002:a17:902:ccc8:b0:235:e942:cb9d with SMTP id d9443c01a7336-23c6e500895mr62788065ad.17.1751500175102;
        Wed, 02 Jul 2025 16:49:35 -0700 (PDT)
Received: from [192.168.225.141] ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3bc6b8sm136989965ad.203.2025.07.02.16.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:49:34 -0700 (PDT)
Message-ID: <c64ace7d-7c8e-4847-a378-b3cf6bf622fc@gmail.com>
Date: Thu, 3 Jul 2025 00:51:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] zcrx huge pages support Vol 1
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <01e5a711-fe8b-4d5c-b8c6-325fe2d67dff@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <01e5a711-fe8b-4d5c-b8c6-325fe2d67dff@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 00:12, David Wei wrote:
> On 2025-07-02 07:29, Pavel Begunkov wrote:
>> Use sgtable as the common format b/w dmabuf and user pages, deduplicate
>> dma address propagation handling, and use it to omptimise dma mappings.
>> It also prepares it for larger size for NIC pages.
>>
>> v4: further restrict kmap fallback length, v3 isn't be generic
>>      enough to cover future uses.
>>
>> v3: truncate kmap'ed length by both pages
>>
>> v2: Don't coalesce into folios, just use sg_alloc_table_from_pages()
>>      for now. Coalescing will return back later.
>>
>>      Improve some fallback copy code. Patch 1, and Patch 6 adding a
>>      helper to work with larger pages, which also allows to get rid
>>      of skb_frag_foreach_page.
>>
>>      Return copy fallback helpers back to pages instead of folios,
>>      the latter wouldn't be correct in all cases.
>>
>> Pavel Begunkov (6):
>>    io_uring/zcrx: always pass page to io_zcrx_copy_chunk
>>    io_uring/zcrx: return error from io_zcrx_map_area_*
>>    io_uring/zcrx: introduce io_populate_area_dma
>>    io_uring/zcrx: allocate sgtable for umem areas
>>    io_uring/zcrx: assert area type in io_zcrx_iov_page
>>    io_uring/zcrx: prepare fallback for larger pages
>>
>>   io_uring/zcrx.c | 241 +++++++++++++++++++++++++-----------------------
>>   io_uring/zcrx.h |   1 +
>>   2 files changed, 128 insertions(+), 114 deletions(-)
>>
> 
> What did you use to test this patch series or will that come with vol 2?

I used my libuirng example with different areas types but didn't
do anything in terms of benchmarking. This series only improves
iommu, and I don't care too much about that.

-- 
Pavel Begunkov


