Return-Path: <io-uring+bounces-3579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE76E99980A
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 02:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 999701F20F0C
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 00:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03F67E1;
	Fri, 11 Oct 2024 00:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ASYkN0AG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A01C36
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606951; cv=none; b=pYu8+W8LlERTNWNntrNJKZHWxF5k7PP2gx3/SOpdckSImTcIU5qNMuwe1/mymqQkiE1VXgUPTMMJhgTTTIysqvAmjrqwL/zHdcHPiba76A/jKz4kHFk+Ga60oDeEErXgduNG+a94eDC64NNbiPeTwuLsnkepIjxmmfGbXfEyK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606951; c=relaxed/simple;
	bh=999nR2FilYmlxOQ2mYbr24KR4RiNc4ld59U7cguD/Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ST9jUGFlmcug3Jsy2osf81+LxsWpzLd7c0enI0XHI5F5xrbqWYtaj78aNqhLHHmSe2wiOnvQuuat4QO8Ha26uDQ7Hu8TOOL+pVaXhdaE0WdaKvq6lm1kVzfbaWdPCDjfik3DeE67A87ASaROXDa2706b2GzH1y/e55bLrmduJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ASYkN0AG; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20bb39d97d1so14062245ad.2
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 17:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728606950; x=1729211750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oYQbBoF8wbLfQNdw7pMUc8HDCXr2b8Unz33Rjmmt7h4=;
        b=ASYkN0AGimateeACCN4QVBQGJQwKlJ//tYH7cvHccYv6+uwcc+8AiYW+7UMkol2b5C
         qCsqv1SX9AgOWDzLZ4bmTU9T1RAS93OsfItLBFlfLanYzUB5pyI7DQphYHU9GRUbK1pO
         zJQBO+xCUruRWyJ6JHBL5L7u6YXVcFqKLPSJJlwxA898fjxorbxVCd4xQVh52CoBbUS/
         8E1ii1V33vb+Kr1AAOFutyhtOBtPyXy35mTHc093lYLSlzGvzAq7XDhNmiKo3iAl/gM2
         Uyi8cT0MKH2z4S3rBP9FNjjMIFByiKSqmX725SaM4H4uLVwULh70awkLIz9wk9yWy9jL
         ZIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728606950; x=1729211750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYQbBoF8wbLfQNdw7pMUc8HDCXr2b8Unz33Rjmmt7h4=;
        b=jzOSNF4xoINunW6KG4acP/jeml7IVqfsDK0/SqSGFVhC7Q4ey8gZSKP3B2rgHxJyLh
         eh9qjq8bvmKr0SY2tYysQ4amt9fefDwxdIu30kGidI86mwKI+xgXnGt+f8SHWCXJyjH7
         tQ0badL3pO8RUr/nFZY/nqV6/5BLdpxEyOathzJLAaT02r6DTuNap1vU+nWWToiBRJd+
         eeXND9o6pmJppNYnBGW1Th2GbsI06mq7c6laoJUcSB81Ul+mt7CQjd26xpODXeUjCH5t
         q5xHN8U62deRs4yNHASMGq8ON9CZRR67s0jPYZ/3+A1QVXm8neYOuPpJNRd+ZVxZN7QF
         yqgA==
X-Gm-Message-State: AOJu0YyS+6b+hUMivrDwayLHlW3l1qqKBaMcHZn9121RIuQJMHHdp5Sz
	sNjZw3EwTT8MaoKLUte2GwnvSd1d69METjBQP3uRIE5AcuC9kJvYJQKcamRQxBo=
X-Google-Smtp-Source: AGHT+IERMowZYF1bvYBRDJVUfCxcdYVOBo7gR6+ixBF0ILlrrRaKRJPBB4/uFHNq6anfUVdEaFkaMw==
X-Received: by 2002:a17:902:e546:b0:20b:968e:2583 with SMTP id d9443c01a7336-20ca144e9a3mr11048825ad.2.1728606949718;
        Thu, 10 Oct 2024 17:35:49 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:f60d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c350ee8sm14788085ad.295.2024.10.10.17.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 17:35:49 -0700 (PDT)
Message-ID: <2ff04413-9826-4696-9c8a-7a40cd886aae@davidwei.uk>
Date: Thu, 10 Oct 2024 17:35:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-GB
To: Pedro Tammela <pctammela@mojatatu.com>,
 Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-09 11:21, Pedro Tammela wrote:
> On 09/10/2024 13:55, Mina Almasry wrote:
>> [...]
>>
>> If not, I would like to see a comparison between TCP RX zerocopy and
>> this new io-uring zerocopy. For Google for example we use the TCP RX
>> zerocopy, I would like to see perf numbers possibly motivating us to
>> move to this new thing.
>>
>> [1] https://lwn.net/Articles/752046/
>>
> 
> Hi!
> 
> From my own testing, the TCP RX Zerocopy is quite heavy on the page unmapping side. Since the io_uring implementation is expected to be lighter (see patch 11), I would expect a simple comparison to show better numbers for io_uring.

Hi Pedro, I will add TCP_ZEROCOPY_RECEIVE to kperf and compare in the
next patchset.

> 
> To be fair to the existing implementation, it would then be needed to be paired with some 'real' computation, but that varies a lot. As we presented in netdevconf this year, HW-GRO eventually was the best option for us (no app changes, etc...) but still a case by case decision.

Why is there a need to add some computation to the benchmarks? A
benchmark is meant to be just that - a simple comparison that just looks
at the overheads of the stack. Real workloads are complex, I don't see
this feature as a universal win in all cases, but very workload and
userspace architecture dependent.

As for HW-GRO, whynotboth.jpg?

