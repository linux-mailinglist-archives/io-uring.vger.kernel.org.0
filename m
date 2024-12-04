Return-Path: <io-uring+bounces-5238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EADA9E43FE
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF96B164320
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E28818B483;
	Wed,  4 Dec 2024 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmzmQp/I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C5523919E;
	Wed,  4 Dec 2024 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339044; cv=none; b=G7Ns/P5GLNZa+ov8uqI9sTVg7RqhD7Y9Nl6S40JdX6fEMDiCCyXMmAXjM1qhEqHx6JGsfXEqxVUkCge9yw2o8MOsWvpYPJ4HNmwTlcoOzpL+PvBp/FIYmXSRMCiAa+LLtwl93/lXb91Lk1Oy4g31VgZ7DK7NqBikxPnnwN90Qzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339044; c=relaxed/simple;
	bh=sJn3Rno8qeOzzSDTd3+0Cs5Nok+JYgrO/Cg+ECdLQ8w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gevqyH1SQehQRwS50P0+gkW6twl6SvYH9+9cHdG95JAd5Dahe+aBuSvYOB1iFbrzQCi90HTgyC6wK+h8PJK0UVHicrpIQUwaqIvFA272GhyrsXDFMIxMMuErousmIsG0vW+GthmBEhOzbVGOXXprQgS5+uXo8paBUMsgAD/8r2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmzmQp/I; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9e8522445dso8555166b.1;
        Wed, 04 Dec 2024 11:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733339041; x=1733943841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pD+HQ1TjfymXG6MBRw8plT+pxpsHhjuKNShxYj58J9Y=;
        b=PmzmQp/I5474U5H8LT4uRTL4xpg58uwndOyAVAsdn11RKndYwKJgn1x8wRxZiVeFYv
         qBVDjjv1iuvLlp98WnMbXEF46tI7L/X+EpxmVPS0G3C8lEZQP3Mi6mLpnBCxlN58FCyM
         cTI1/NZtHf3YZcsRtSCIbyngxKyXLhgHpIbo6t4BBScBD52/b/z6U6kPbB+nEAjlbeDN
         h/NQ00gQdsFucfzJUDQHzj7yqs2XeCdiwwe8ASeo22lzhD24VvUnNyAfH0XJjLQWWjTg
         j+xJfkW177jnzhTrI5E4GseqwqpN9OJlk+jm09CZ3k6di4UdlEU/C7yYsHY4YLa1Heo1
         tNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339041; x=1733943841;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pD+HQ1TjfymXG6MBRw8plT+pxpsHhjuKNShxYj58J9Y=;
        b=ur3xXZcjhgULaD2HZP9nJh09lTXL1fiABrrGSMqbpQXa0Loh7UiJ/jRq1ga8ajLdXr
         cZLzY5AIEZwd+Q4epwDt77fuGICu1vj4bU1F203RErpJnluhqa5liBMcHacuxUL+PMye
         RDhe6e4MeF29zjztlE4+fVPszfY0ZNxzYU529qKEKnbwvuvtnJMn2xADkPvtBB3GscjG
         KdPohHx0IEzrDtEpqNqDKeky/h3/39Uv677sASqdVX9wSTySFCnswfnuZFjsCWgtEHRK
         mrb9yN0Tn+g0/n0eMBM229nK9d8nwqa7iqVO/mQWwdSEuXq6lB7QC2La46DEq65/zQH4
         Z0bw==
X-Forwarded-Encrypted: i=1; AJvYcCXL8RdVCDvRhjhZy9C5uPLTz0osgrtIxCB4WBGLT2kNbZN4RDLwa+vAgpUuzYVo1cDupNwcoW9uwQ==@vger.kernel.org, AJvYcCXXiOJXNHad6xki+XrfIEJGdgso/7hp7tAJEd4PbDED6Bzpo4PQ/QCeleo9R0tkNCZsy3M/rTpD@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg9r2Y/W6jkCD1uFfKggLX3iyaKM991KqTlfyP6jPWXRZen71E
	9pORM74tM2Homuy/r3N+HGvmvXfotT49rFTDXq7qzxU8ibPxbV8Z
X-Gm-Gg: ASbGncuIAWZt2fjJzEkgK6WvznTegwDvCFQV4BnSHDs4aI98vrs4PRVtp4oA4jGhJc8
	7djEmB22a4uPhVZX8LwG+lNZ3Lk7LlHINAUmwS9JRwOerbdvP2ULjPmIIovam9U8r++1QerEADi
	NuPCQb9dJ5Tpc8DvK4u0Nps6tdgofeV7ZPk2lP06e6cHdJUOko9JyXO4g7E6nsA2Qb+IS/ifo3F
	ZMhFVzoNRONrz0iHl9+dA83Upk9U6a6wvstVhC+IHu58Rdu9KYo3Oqg9YSBTA==
X-Google-Smtp-Source: AGHT+IFIVnk2CjiChgIvMsUKAQo4VnKJHXeG5SCk/uWi5CI/IV/CDHRCVHZHJHztwB7C0uHpNRV2KQ==
X-Received: by 2002:a17:906:30c2:b0:aa5:3023:bae5 with SMTP id a640c23a62f3a-aa5f7d1fbb9mr579070166b.21.1733339041053;
        Wed, 04 Dec 2024 11:04:01 -0800 (PST)
Received: from [192.168.42.131] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5998e7164sm773104266b.125.2024.12.04.11.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 11:04:00 -0800 (PST)
Message-ID: <2a9d89e3-94ba-4707-8e7b-726c2eeb5bfc@gmail.com>
Date: Wed, 4 Dec 2024 19:04:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
 <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
 <9ed60db4-234c-4565-93d6-4dac6b4e4e15@davidwei.uk>
 <CAHS8izND0V4LbTYrk2bZNkSuDDvm2gejAB07f=JYtCBKvSXROQ@mail.gmail.com>
 <20241115151428.6f1e1aba@kernel.org>
 <6e687570-c7b7-4c22-a601-d7ea6d620afe@gmail.com>
Content-Language: en-US
In-Reply-To: <6e687570-c7b7-4c22-a601-d7ea6d620afe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/24 15:26, Pavel Begunkov wrote:
> On 11/15/24 23:14, Jakub Kicinski wrote:
>> On Thu, 14 Nov 2024 12:56:14 -0800 Mina Almasry wrote:
>>> But I've been bringing this up a lot in the past (and offering
>>> alternatives that don't introduce this overloading) and I think this
>>> conversation has run its course. I'm unsure about this approach and
>>> this could use another pair of eyes. Jakub, sorry to bother you but
>>> you probably are the one that reviewed the whole net_iov stuff most
>>> closely. Any chance you would take a look and provide direction here?
>>> Maybe my concern is overblown...
>>
>> Sorry I haven't read this code very closely (still!?) really hoping
>> for next version to come during the merge window when time is more
>> abundant :S
>>
>>  From scanning the quoted context I gather you're asking about using
>> the elevated ->pp_ref_count for user-owned pages? If yes - I also
>> find that part.. borderline incorrect. The page pool stats will show
>> these pages as allocated which normally means held by the driver or
>> the stack. Pages given to the user should effectively leave the pool.
> 
> It can't just drop all net_iov refs here, otherwise the buffer might
> be returned back to page pool and reused while the user still reading
> the data. We can't even be smart in the release callback as it might
> never get there and be reallocated purely via alloc.cache. And either
> way, tunneling all buffers into ->release_netmem would be horrible
> for performance, and it'd probably even need a check in
> page_pool_recycle_in_cache().
> 
> Fixing it for devmem TCP (which also holds a net_iov ref while it's
> given to user, so we're not unique here) sounds even harder as
> they're stashed in a socket xarray page pool knows nothing about,
> so it might need some extra counting on top?
> 
> This set has a problem with page_pool_alloc_frag*() helpers, so
> we'd either need to explicitly chip away some bits from ->pp_ref_count
> or move user counting out of net_iov and double the cost of one
> of the main sources of overhead, and then being very inventive
> optimising it in the future, but that won't solve the "should
> leave the pool" problem.
> 
> If it's just stats printing, it should be quite easy to fix
> for the current set, ala some kind of "mask out bits responsible
> for user refs". And I don't immediately have an idea of how to
> address it for devmem TCP.
> 
> Also note, that if sth happens with io_uring or such, those
> "user" refs are going to be dropped by the kernel off a page
> pool callback, so it's not about leaking buffers.
> 
>> So I'm guessing this is some optimization.
>> Same for patch 8.
> 
> This one will need some more explanation, otherwise it'd be a guess
> game. What is incorrect? The overall approach or some implementation
> aspect? It's also worth to note that it's a private queue, stopping
> the napi attached to it shouldn't interfere with other queues and
> users in the system, that's it assuming steering configured right.
> 
>> But let me not get sucked into this before we wrap up the net-next PR..

Jakub, there is hardly anything I can do with the series if you veto it
but remain silent on any details. It appears you've had some private
conversations with David I wasn't privy to. And it's hard to tell but it
sounds that your ask number (1) is that it should be able to serve
multiple page pools in parallel. And (2), you don't like something in
regards to refcounting.

(2) As I explained in the previous message, I can separate refcounting
to get rid of the io_uring ref bias, but it's not going to help with
"elevated ->pp_ref_count for user-owned pages" IIUC what you meant
here. Moreover, devmem is suffering from the same thing, and if you
feel like it's really a big deal, we should revert devmem TCP, which
would undesirable, or somehow solve it otherwise.

Another problem is performance, it doubles refcounting, which is just
not acceptable, so I'd need to do something about it. For example,
the syscall part of the path, ala recv(2), would do something like:

for (i = 0; i < nr_frags; i++) {
	niov = skb->frags[i].netmem;

	// for each user ref we also take a kernel ref so that
	// the net_iov is not reallocated while the user space reads data.
	atomic_inc(io_uring->user_refs[idx(niov)]);
	atomic_inc(net_iov->pp_ref_count);
	post_completion();
}

One way out would be to steal frags from an skb together with a
reference it holds.

bool steal_frag_refs = !skb->cloned;
for (i = 0; i < nr_frags; i++) {
	niov = skb->frags[i].netmem;

	atomic_inc(io_uring->user_refs[idx(niov)]);
	if (!steal_frag_refs)
		atomic_inc(net_iov->pp_ref_count);
	post_completion();
}
// we reused the frag refs, so took it away from core net
if (steal_frag_refs)
	skb->nr_frags = 0;

Does that sound reasonable to you? Or do you have any other suggestions?

(1) is also doable, but that can't be done without performance penalties,
or specifically it'll tie hands from many future optimisations for more
or less same reasons why page pools are not shared and can't be pulled
from by mulitple CPUs in parallel. For example, if you think that
page_pool_napi_local() is a good optimisation, then it'd also make
sense to optimise user refcounts in a similar fashion.

Perhaps, it can have a fast path that assumes a single page pool, assume
that the state when there are multiple pp's is transient, and do some
additional sync at queue restart and/or pp init/destroy callbacks when
switching between 1 -> many and many -> 1, which would likely need
to briefly stop the queue / napi in one way or another. Does that
sound reasonable?

-- 
Pavel Begunkov


