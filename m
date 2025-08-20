Return-Path: <io-uring+bounces-9102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C44CB2DE65
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB2D41775C2
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906E11A9F87;
	Wed, 20 Aug 2025 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViR3ztcX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07417A309;
	Wed, 20 Aug 2025 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697814; cv=none; b=qCjIXxDUX6LzoAccO/N2pSU/dFx9tx9mMxPckWab2/5Eo1wCLssx82WqJz6u++f6dGeLrpSrIPASu4qvQqKfdyukAc42CU3ea+ntkCt4nhXbsd2diCSVhtt+5bzSxuS3tmgOBwB/y+Zhl2+t8Lp4kdY11tsVu0tMeNxPP2+bKic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697814; c=relaxed/simple;
	bh=dMvgYaXjumQ1VdyVAztFC4jmSWiILQ0PT5qCK7OBCIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oK2nTmDk00ejRFz25KH88DvCfohfwOVlZJjmar/NGek32bUjRye8T2JR3JMP7mDZlVvfQdxv6+44aQZaW5Q1NcV7g3kVHpG9uma7BdWPJGY71c/FMClelvJ+T96EVNRuVD0nbpcC87jpn9rX5BnbR6VjEXyYuQw4bvablzU6PV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViR3ztcX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so39884165e9.3;
        Wed, 20 Aug 2025 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755697811; x=1756302611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eBy4+jOy550+2s+ORoaxR2PvHEe/JGkfvCohbhnR2vA=;
        b=ViR3ztcXusjtJnGAVKnu2oIr6HrazFnn6fxzaKJAkZCwQAKUSLo8blirAdSWY5CWsv
         OSvtoZaoI6yQAYakZH1cSx5ixXYGDSw8y/+EEE7iH0AmW2GWAVx7JoShNIwx9P7+b0rF
         5mezcXAy9ATdmLUWXeFTghU6KPf3AskzsygxlLBSLkr1uJIGc8l/DRnDeZN/II6IqUTp
         ruLAIdxlcktYcEPdNEBUWHZlfX8ZpQSIa/RwfPQeM0hb4nVb6OAV41MBk4+OE1gweXwE
         yPUvGUj0ByCIT6YWFL97F2/pZG8AIRnuFyO7TGHVIKiewFocVMrrPRmypNLzhKFCXFm8
         wtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697811; x=1756302611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBy4+jOy550+2s+ORoaxR2PvHEe/JGkfvCohbhnR2vA=;
        b=caYoYllpTSgYkOaQzfYVDScy17znsKqtY0ThNa5wgDpl+TRU0D2DLmUQV+G1zF5NjS
         vRW60Tu1MHiEbQCnpK9CeWIdv/+DzQ6KVQYVsSzBER3m4EGgVXzhPkPIskOlD2dKithl
         IF8i4D1HON2qQbk8zfDG10dlqNaO6k8CjB6jC5lsS6s0xgsj1ZJmm3Ri3zE6cXtIsMp9
         SI/GO6IuKYJPmtvfl3H+cBGxYTHQ4Y2BucpgN6+BsSig8J5wrEgjKNHrXSgxOAH1oGwG
         EkEx0GA77Kju+WUHm+esWwa9IvxHeMxCt26n1BoEucxZlkDi30D/o/OiP+/6769+PRjK
         M3Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUD+S40CPBD9ToWBP6fWd/WJHNR77j0igIvkwNDiaghRaBScAXYHOL7wd2Hvw4qPZ2H8Z9RWMV+XpG56aXk@vger.kernel.org, AJvYcCWWVeO7/w8GZQKejIqVKwq2Cb1kVr71ddUjchwEDAHCEG3QiB3nk6yr7y90XYa4XZEcZxGIM3lz@vger.kernel.org, AJvYcCXinSeqwTjxIgd0kmBlcJe7mRZ2aRVPASaY9fqsqd8E57JB1pq4ho7YFrw+RwsNMwz3sdFFy6zxmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEjHEQyPwwc3+ZW4KCc0h9YWmeijm9Yc3nOSPoZmxdvRkVaAai
	xQ3jbRNuSHuDlFKZ3xgyE4FSrwD2iiPDG3j4s/WR/A0AugQTv5A1Htrv
X-Gm-Gg: ASbGncuQ74zgPMuo8G6RuvbmUzkVBMoZKwWVqWE+J7WNVrne+bwI9knrgRVCkcEAmuw
	RNwiNBJAv0qwcHCytpT3opdag/d5Vka+9nLGkH/x/ME6pgQMn6vRHPhGTM2VM0SxphphG3tLcuv
	sCNCUIM3/MlUtGT/8khO6guLtz9uXgue6vnyfbxKJherv4MCqp7S562llS5xsjMhAurQmGZihVE
	4HJwClKOwnKoueJKahm4go6aid8LyTlCh6feIjdNJ0yeLlAyseb0kXETPe5hWcXJ5mTwzbpgDJT
	TzgKwagTughbesdEMRz/5iyKZUSb556XLm+9eXwaFvw1gu2AOLxdP/9vcUzEG8RKXhnLhV/RLVS
	7+VUkQMQdtP9EMcuLGNvlqZx5jq4rluK/vo9E2AcOdLBuxOzxbvwXoaU=
X-Google-Smtp-Source: AGHT+IFdQ3wLI4MGcZ93YlSdYTeoAmiyN+/gD0DLVcCnFemnvTq4l1fLPv7+rWpJrqyIX0UXaACR6g==
X-Received: by 2002:a05:600c:b86:b0:459:d9a2:e927 with SMTP id 5b1f17b1804b1-45b4acff99cmr16103705e9.5.1755697810679;
        Wed, 20 Aug 2025 06:50:10 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f7e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c90cc4sm36949085e9.16.2025.08.20.06.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 06:50:10 -0700 (PDT)
Message-ID: <cbbb4ce9-146d-4491-afd5-7ba54e13a724@gmail.com>
Date: Wed, 20 Aug 2025 14:51:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 08/23] eth: bnxt: set page pool page order
 based on rx_page_size
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <51c3dd0a3a8aab6175e2915d94f7f7aece8e74d3.1755499376.git.asml.silence@gmail.com>
 <CAHS8izOs_m9nzeqC5yXiW9c1etDug4NUoGowPzzPRbB4UFL_bQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOs_m9nzeqC5yXiW9c1etDug4NUoGowPzzPRbB4UFL_bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 20:43, Mina Almasry wrote:
> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> If user decides to increase the buffer size for agg ring
>> we need to ask the page pool for higher order pages.
>> There is no need to use larger pages for header frags,
>> if user increase the size of agg ring buffers switch
>> to separate header page automatically.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> [pavel: calculate adjust max_len]
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> index 5307b33ea1c7..d3d9b72ef313 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -3824,11 +3824,13 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
>>          pp.pool_size = bp->rx_agg_ring_size / agg_size_fac;
>>          if (BNXT_RX_PAGE_MODE(bp))
>>                  pp.pool_size += bp->rx_ring_size / rx_size_fac;
>> +
>> +       pp.order = get_order(bp->rx_page_size);
>>          pp.nid = numa_node;
>>          pp.netdev = bp->dev;
>>          pp.dev = &bp->pdev->dev;
>>          pp.dma_dir = bp->rx_dir;
>> -       pp.max_len = PAGE_SIZE;
>> +       pp.max_len = PAGE_SIZE << pp.order;
> 
> nit: I assume this could be `pp.max_len = bp->rx_ring_size;` if you
> wanted, since bnxt is not actually using the full compound page in the
> case that bp->rx_ring_size is not a power of 2. Though doesn't matter
> much, either way:

Yeah, thought it's cleaner to derive it from order in case
sth about rx_page_size changes again and it was already
overlooked once, and it's pow2 anyway

-- 
Pavel Begunkov


