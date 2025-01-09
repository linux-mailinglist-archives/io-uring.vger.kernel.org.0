Return-Path: <io-uring+bounces-5787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C83B5A07DAA
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 17:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFBBF168010
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 16:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185BA221DA0;
	Thu,  9 Jan 2025 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hA87lGiW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C260221D9F;
	Thu,  9 Jan 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736440471; cv=none; b=gh31tqfKvuZYndNVSygVSHGjc1bKrrOXKXwpsqYzLgEw+7/3WpPezTzzD4oq5MkyDCo+xyVtg/MyaFHnJAtie3f4Nggp2WrZBYTsfDKth9jpb40Zza/wDs/+tHbMuymcVBMVzWB2hcfdGAnMTBguXC9W+KNfv/Ai8mmXDH+aaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736440471; c=relaxed/simple;
	bh=ueFL1CBryXUlfftmzQLzDSzQEITm2NofTaEk6ZjBUMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VM8BtWKcyzjKxthB8VhqgbziNJXtkm6KmdOX9QIbG/LYPrCUu1G8+GkGdcMd5g7++z644YHiy5RegPaXhOxcJEssw70hEipIYcllCPGXJkyAcW/8c5I9F1q1mQ8a6vkYPbhCUNUcFCEHPg1ayi462mF01gaiwiuKieg9e+GFR2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hA87lGiW; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so2158662a12.2;
        Thu, 09 Jan 2025 08:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736440467; x=1737045267; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PbCAHwTNJcPmiKkw7sa8F/shTPtNkn2gNNvE+XP3WqY=;
        b=hA87lGiW5ior+QJkb87wUsTDMPufz5IgI73WfsBZVpEuV0hS2gcswBUkvOfQIX0HEm
         uuWmOrvWArpRtMnzTKytJsV3mBDRV881mnaovX8q13OmcsUuMl3doEmFDgpy/Xn/ouSj
         xfetn6uw92dVmwPNMKotu9HnqBcZXV0ceTQUvbvtMeRq09msrb8bvkAURLPPXD+aK/77
         jSUHD08VAv3PLViJEtREsyZl9uyo4usHkDivb/rhZSXRW4dOaj9wNtuAcNP3YOE6rIPE
         sAFc752NEpIFwMd/xFZ/epcasas/2ILJV62SUUdxVpaNbErsQHFX0KaZ01XlJRfalgqE
         KOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736440467; x=1737045267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbCAHwTNJcPmiKkw7sa8F/shTPtNkn2gNNvE+XP3WqY=;
        b=fnpTxfi/y+0VQSV8dSMJLKDS/V60/1FKxZ8URzBxf7S30IabSMklDWjxlnWvj97Qtq
         Fgyi7V+0oiX2LCQZUeVkht4Rr0x5YaiZCAuL9dU9thXpmuYzox6bBoxRXHUHhqKL47ka
         oUT8GnB2tZHaqEfwQl5SkZrnciCCCCoQlDNdEmKlG3Qhhi8FMI4opOxcq2b1fmsbBDKA
         ru1iDnEhRi/V5igesPF0lMnQOykB27hUiUSINa1AmjbQ8G/x+OI1eTuoliPNkTMUxVMY
         rmCMAcxt8bFwfADB+fcaMR+WpcyyB1Fs0LQ9q9y4IqQ2wJD36OJ9n1bVAGnvqBZ0wfDO
         lx6A==
X-Forwarded-Encrypted: i=1; AJvYcCVA6UQlwYbhpdP8qR1cu14QAzfH/5nKOpz6/XGri3kvud3EgbJgwZmRosSDr7mFqBoPPHCRtCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCKJinpv69EnN8Dad/BoEf751MO92Ubfwq5siM6EHQj+v9s82M
	0IEM25sZgOZNqdYGwqUcKxf3N9U49m/LQYYLYR67wa1/lBJtvvRf
X-Gm-Gg: ASbGncveMNLKN0y5wwD5HMZbCrCfXVuZYhgqsgXDd4K8GfrXphL0JLGlfq1ZmTUpCMj
	OXAKUv5edQ/neaJlVhodT+MTe6hYHrub1MDOyTjc18OW/6QlHkBm0DIlA/FkGb5pZrnmysf0lbW
	AyatAVbGyQ9dmdHMsar8M44oB89NS4YrBGs3kOD5kSMkXp+wJwZBCMF3IX38VhKANYOJ88o2zt9
	HJFkSt0FIbW/Fo3q/pIJi4Yp3rI3FoQSgx1RGHMpEwqOYn4wnubsSlDQp+qaU6vgxaK
X-Google-Smtp-Source: AGHT+IG0STaExcIhY50fQB53bCM9txNpPuKVYuktCIMEB+K2/5IDBL/77O2bYHYTXOgHx48oUtKYZQ==
X-Received: by 2002:a05:6402:538d:b0:5d3:d7ae:a893 with SMTP id 4fb4d7f45d1cf-5d972e48691mr7311332a12.25.1736440467052;
        Thu, 09 Jan 2025 08:34:27 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::46? ([2620:10d:c092:600::1:140d])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046a05asm764043a12.67.2025.01.09.08.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 08:34:26 -0800 (PST)
Message-ID: <eb0b843e-6da3-46a6-bf51-1c56f5919933@gmail.com>
Date: Thu, 9 Jan 2025 16:35:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 14/20] io_uring/zcrx: dma-map area for the
 device
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-15-dw@davidwei.uk>
 <CAHS8izMKM_if=jZj3Cw0XAaKrfhX31EoqzRR9Dh+7MbiUkUS1w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMKM_if=jZj3Cw0XAaKrfhX31EoqzRR9Dh+7MbiUkUS1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 20:23, Mina Almasry wrote:
> On Tue, Dec 17, 2024 at 4:38 PM David Wei <dw@davidwei.uk> wrote:
...
>> +
>> +               if (unlikely(niov_idx >= area->nia.num_niovs))
>> +                       continue;
>> +               niov_idx = array_index_nospec(niov_idx, area->nia.num_niovs);
>> +
>> +               niov = &area->nia.niovs[niov_idx];
>> +               if (!io_zcrx_put_niov_uref(niov))
>> +                       continue;
> 
> I have a suspicion that uref is now redundant in this series, although

It's not. You can't lose track of buffers given to the user. It plays
a similar role to devmem's ->sk_user_frags, think what happens if you
don't have it and don't track buffers in any other way.

> I'm not 100% sure. You seem to acquire a uref and pp_ref in tandem in
> io_zcrx_recv_frag and drop both in tandem in this function, which
> makes me think the uref maybe is redundant now.
> 
> io_zcrx_copy_chunk acquires a uref but not a pp_ref. I wonder if
> copy_chunk can do a page_pool_ref_netmem() instead of a uref, maybe

It takes both references.

> you would be able to make do without urefs at all. I have not looked
> at the copy fallback code closely.

If we're talking about optimisations, there is a way I described
and going to pursue, but that's not for the initial set.

>> +
>> +               netmem = net_iov_to_netmem(niov);
>> +               if (page_pool_unref_netmem(netmem, 1) != 0)
>> +                       continue;
>> +
>> +               if (unlikely(niov->pp != pp)) {
> 
>  From niov->pp != pp I surmise in this iteration one io_zcrx_area can
> serve niovs to multiple RX queues?

It should, but the main goal was rather to support multiple pools
per queue because of queue api shortcomings, even if it almost
never happens.

> The last 5 lines or so is basically doing  what page_pool_put_netmem()
> does, except there is a pp != niov->pp check in the middle. Can we
> call page_pool_put_netmem() directly if pp != niov->pp? It would just
> reduce the code duplication a bit and reduce the amount of custom
> reffing code we need to add for this mp.

Right, that sub path is basically page_pool_put_netmem(). Can be
replaced, but it's not going to de-duplicate code as the path is
shared with page_pool_mp_return_in_cache(). And it'd likely bloat
the binary a bit, though it's not that important.

>> +                       continue;
>> +               }
>> +
>> +               page_pool_mp_return_in_cache(pp, netmem);
> 
> So if niov->pp != pp, we end up basically doing a
> page_pool_put_netmem(), which is the 'correct' way to return a netmem
> to the page_pool, or at least is the way to return a netmem that all
> the other devmem/pages memory types uses. However if niov->pp == pp,
> we end up page_pool_mp_return_in_cache(), which is basically the same
> as page_pool_put_unrefed_netmem but skips the ptr_ring, so it's
> slightly faster and less overhead.

Jumping through the loops is surely not great, but there are bigger
semantical reasons. page_pool_put_netmem() has always been called by
users from the outside, this one is off the page pool allocation path.
For example, it'd nest io_uring with ptr_ring, which is not a bug and
not so bad, but that's something you'd need to always consider while
patching generic page pool. On top with the ptr_ring path in there,
either providers would need to make implicit assumptions that it'd
never happen, which is shabby, or the code should be prepared to that.
I'd say it should be more convenient to have a separate and simple
for all that.

We can play with the API more, hopefully after it's merged, but
just replacing it with page_pool_put_netmem() would do a disservice.

> I would honestly elect to page_pool_put_netmem() regardless of
> niov->pp/pp check. Sure it would be a bit more overhead than the code
> here, but it would reduce the custom pp refing code we need to add for
> this mp and it will replenish the ptr_ring in both cases, which may be
> even faster by reducing the number of times we need to replenish. We
> can always add micro optimizations like skipping the ptr_ring for
> slightly faster code if there is evidence there is significant perf
> improvement.
> 
>> +       } while (--entries);
>> +
>> +       smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
>> +       spin_unlock_bh(&ifq->rq_lock);
>> +}
>> +
...
>> +static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
>> +{
>> +       if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
>> +               return false;
>> +
>> +       if (page_pool_unref_netmem(netmem, 1) == 0)
> 
> Check is redundant, AFAICT. pp would never release a netmem unless the
> pp refcount is 1.

Good catch, it was applied to v10

-- 
Pavel Begunkov


