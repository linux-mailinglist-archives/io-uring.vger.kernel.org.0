Return-Path: <io-uring+bounces-3964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFC69AE8E5
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C2FDB21410
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB471EB9EA;
	Thu, 24 Oct 2024 14:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c352FhAB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E661DFEF;
	Thu, 24 Oct 2024 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729779976; cv=none; b=eIA0i+BK0B3aqvTTpejlvy3BMmxOxeSHst1j1tHUN1/c+W5ewWeACbhdzN8LKvfq/2W/0q+G4ldTaPLGwhIUEUHNpSTqlqtajBjV5J4DYryuA80fVFV5EE6f0Mw8wWqJOT3VipemLXjeANiN98jFRlJQkQIodLlduQgGnz2NwDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729779976; c=relaxed/simple;
	bh=9zf8G7xE1167pPOhZsXN9s0WzD14vS3NQ1D6cz0hGYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GzwCZRY0DlC5cNwO+mExIk8Im82jx3zCRHCga9Oulup9TCgni4xPern1VfnEczm3viJHGsp5uVuogAZgaq/RhrOFGBBmMaW3/gEnDc69RZLEsj1Kg42Ys31pyvjd0tKu9lEoT3kLgOQCcKybeORuzKtk2b2JZU4kJ+ImsGYz7NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c352FhAB; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a4031f69fso134843466b.0;
        Thu, 24 Oct 2024 07:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729779972; x=1730384772; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JZOo7KmWVazwjQAX6MxDRPx4P6OgsnRlGA/rdXj8KKo=;
        b=c352FhABj0Z2VenPR9b3exEqwuSCpec+ONq4Ptj8niK4ranrytvqUQmf83Nl98Na1E
         DvEgEukt3Ue6OK4bnTwZEzxVgAsDDXBGxpvD5oQNe/LGMcv7fxI3mP0jXBtgcMdS0Q9l
         58/JQyn5Oq3zTOYcdX044ZZfVxYt7zcUKurHK1hU4mx8cslvy7e7EjZbIAQf982Bp2Zc
         c2kRRHUZWNxTOafOjgHIEl/sOdlI8rHLhEO7C54FV9XkmMdbH/zbC6LINpN8sUigYz33
         PlDkAOLz8sgrX58O+qd0sCQx7oLuMnMNWI3u0HCwtj6lcaTjMUQwem0/R5j3fHLfmeq5
         oLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729779972; x=1730384772;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZOo7KmWVazwjQAX6MxDRPx4P6OgsnRlGA/rdXj8KKo=;
        b=K8/aEq+GLjrwLH2e0NdY0n1ws9P85jSKb31Ux9r594Iaup/f1ci6+ldKZ/mxS/MkN/
         Ccx/c4igz04PitYe2rh3TatMa/JgWxddLVXVee8RzF6CVOjDxJxLOobscUkCWmO+klXG
         KvJeHZaT2jmMNRFarlQJyPqqxrkDaSJtO11uYCa/HGj/0fovSUOewi3nbztXOnAaL7zn
         HRMqwpZ9vAjxpJQULlsO6ytMGNttV5S/13o9pyyTRRBLDkpGl/dbvHg2g9F7byMV5nD3
         /iq/1c5PIPsJVeHQrqAttheDApvynM+bvh8WcWD4FZhxCenvlZ3bSA6icZ/9abvgLeH3
         etAg==
X-Forwarded-Encrypted: i=1; AJvYcCVmWhJwXNkcarkmpCpQlxkcnP/zkPMWSXczoxDbyeDXJ5Tt+xjoJwohRkCtDNtqaKhwR9cj0ibrIpgWlYM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9CES7Tf/LGwFVWrw0B1FH+z4UUtVFiNjryq6Mog9w2/yXNHi5
	2Phe8lHx7jNmTHT4mT4nknE/NRN5vrnpdE+HrzOBqj1AZH9oA/6J
X-Google-Smtp-Source: AGHT+IHiJkDrI5NFp2nhdYSrIVehhJxvo8jDoyttdVBo+GG/KU6pLUrF5x17FbaLv0PK3n43kFkPQQ==
X-Received: by 2002:a17:906:da87:b0:a9a:134:9887 with SMTP id a640c23a62f3a-a9ad281593bmr182502566b.41.1729779971964;
        Thu, 24 Oct 2024 07:26:11 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9157366fsm629202966b.181.2024.10.24.07.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:26:11 -0700 (PDT)
Message-ID: <f60116a5-8c35-4389-bbb6-7bf6deaf71c6@gmail.com>
Date: Thu, 24 Oct 2024 15:26:46 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] io_uring: releasing CPU resources when polling
To: Jens Axboe <axboe@kernel.dk>, hexue <xue01.he@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
 <CGME20241024023812epcas5p1e5798728def570cb57679eebdd742d7b@epcas5p1.samsung.com>
 <20241024023805.1082769-1-xue01.he@samsung.com>
 <9bc8f8c4-3415-48bb-9bd1-0996f2ef6669@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9bc8f8c4-3415-48bb-9bd1-0996f2ef6669@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 15:18, Jens Axboe wrote:
> On 10/23/24 8:38 PM, hexue wrote:
>> On 9/25/2024 12:12, Pavel Begunkov wrote:
...
>> When the number of threads exceeds the number of CPU cores,the
>> database throughput does not increase significantly. However,
>> hybrid polling can releasing some CPU resources during the polling
>> process, so that part of the CPU time can be used for frequent
>> data processing and other operations, which speeds up the reading
>> process, thereby improving throughput and optimizaing database
>> performance.I tried different compression strategies and got
>> results similar to the above table.(~30% throughput improvement)
>>
>> As more database applications adapt to the io_uring engine, I think
>> the application of hybrid poll may have potential in some scenarios.
> 
> Thanks for posting some numbers on that part, that's useful. I do
> think the feature is useful as well, but I still have some issues
> with the implementation. Below is an incremental patch on top of
> yours to resolve some of those, potentially. Issues:
> 
> 1) The patch still reads a bit like a hack, in that it doesn't seem to
>     care about following the current style. This reads a bit lazy/sloppy
>     or unfinished. I've fixed that up.
> 
> 2) Appropriate member and function naming.
> 
> 3) Same as above, it doesn't care about proper placement of additions to
>     structs. Again this is a bit lazy and wasteful, attention should be
>     paid to where additions are placed to not needlessly bloat
>     structures, or place members in cache unfortunate locations. For
>     example, available_time is just placed at the end of io_ring_ctx,
>     why? It's a submission side member, and there's room with other
>     related members. Not only is the placement now where you'd want it to
>     be, memory wise, it also doesn't add 8 bytes to io_uring_ctx.
> 
> 4) Like the above, the io_kiocb bloat is, by far, the worst. Seems to me
>     that we can share space with the polling hash_node. This obviously
>     needs careful vetting, haven't done that yet. IOPOLL setups should
>     not be using poll at all. This needs extra checking. The poll_state
>     can go with cancel_seq_set, as there's a hole there any. And just
>     like that, rather than add 24b to io_kiocb, it doesn't take any extra
>     space at all.
> 
> 5) HY_POLL is a terrible name. It's associated with IOPOLL, and so let's
>     please use a name related to that. And require IOPOLL being set with
>     HYBRID_IOPOLL, as it's really a variant of that. Makes it clear that
>     HYBRID_IOPOLL is really just a mode of operation for IOPOLL, and it
>     can't exist without that.
> 
> Please take a look at this incremental and test it, and then post a v9
> that looks a lot more finished. Caveat - I haven't tested this one at
> all. Thanks!
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index c79ee9fe86d4..6cf6a45835e5 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -238,6 +238,8 @@ struct io_ring_ctx {
>   		struct io_rings		*rings;
>   		struct percpu_ref	refs;
>   
> +		u64			poll_available_time;
> +
>   		clockid_t		clockid;
>   		enum tk_offsets		clock_offset;
>   
> @@ -433,9 +435,6 @@ struct io_ring_ctx {
>   	struct page			**sqe_pages;
>   
>   	struct page			**cq_wait_page;
> -
> -	/* for io_uring hybrid poll*/
> -	u64			available_time;
>   };
>   
>   struct io_tw_state {
> @@ -647,9 +646,22 @@ struct io_kiocb {
>   
>   	atomic_t			refs;
>   	bool				cancel_seq_set;
> +	bool				poll_state;

As mentioned briefly before, that can be just a req->flags flag

>   	struct io_task_work		io_task_work;
> -	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
> -	struct hlist_node		hash_node;
> +	union {
> +		/*
> +		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
> +		 * poll
> +		 */
> +		struct hlist_node	hash_node;
> +		/*
> +		 * For IOPOLL setup queues, with hybrid polling
> +		 */
> +		struct {
> +			u64		iopoll_start;
> +			u64		iopoll_end;

And IIRC it doesn't need to store the end as it's used immediately
after it's set in the same function.

> +		};
> +	};
>   	/* internal polling, see IORING_FEAT_FAST_POLL */
>   	struct async_poll		*apoll;
>   	/* opcode allocated if it needs to store data for async defer */
> @@ -665,10 +677,6 @@ struct io_kiocb {
>   		u64			extra1;
>   		u64			extra2;
>   	} big_cqe;
> -    /* for io_uring hybrid iopoll */
> -	bool		poll_state;
> -	u64			iopoll_start;
> -	u64			iopoll_end;
>   };
>   
...

-- 
Pavel Begunkov

