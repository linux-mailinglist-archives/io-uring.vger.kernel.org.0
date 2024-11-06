Return-Path: <io-uring+bounces-4469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 719209BDA90
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 01:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01BDD1F23B1D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 00:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D01558BC;
	Wed,  6 Nov 2024 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bi/9XPii"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB19A42A8C;
	Wed,  6 Nov 2024 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854207; cv=none; b=XRwqNjsf9pl6FoNZUMU1nZZ6M2gAFjmhpiTDEf6I/3wPuz7mPM6RY2TN3Nk3MP02g3ANeiaouZur20DJiF0MJkEHBj6evs4jqvvacI0E3yhifNOZXjzzGuxDEMxn4HBVJF+AIFl5d1+A82fH7keU39wmLDlH5jiOnN+lVfALizI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854207; c=relaxed/simple;
	bh=Z62WIyBoNKAEl+pO3cSHbvwiwEV5ilOvfB/VbLW5nmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c/mbzFupalTVsPMtQKqfbyOa3W+ickxLJJM9BX8DPM8I15oBl9NWsUveK0fmppSHgb2p/eE7hEAPXSjzANWsoBUcu17Osz5BK6VC1XBtqGmgyXFebm8zyxatSX4cCPMYT+f7VcTd2iI1Qdny2FTcf12NQzDlCkgAmEYgs97hzD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bi/9XPii; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5cec9609303so4599705a12.1;
        Tue, 05 Nov 2024 16:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730854204; x=1731459004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zhrN3xLVlJVXZHT25fhmfd5DZ5uwyoKVymtFZiMnSlY=;
        b=Bi/9XPiiDrHKUiGokaz9vQB6tf3SR5ljC1Pzgl52vILnIGuwr4CqzggawKYjra625N
         o/GATEUsrme2gSsUzOh4ffcgeG7sttNj01VA6LtL5PelnEMkIinnP0pghDvKCYTfhvP8
         HiauGkwXdGnMsI9Y/RzWNd9iBa2Bi0Lh+Uu/5spkDRLbNmH3+/oLstxaIUepZh5Tkaon
         Fzoh/jZPY7EGjhp6uC9BTyfyHHWNwuVUYeSm3pKaAN1Ap++cuPy9MP5nnqMT/gPTMACw
         MgGy3TG7WpL7UNHjvUWzHTlv32ucDmPUgeQmL+C3nrqbD86vZU3PydKYib1wYLwy239M
         rkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730854204; x=1731459004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhrN3xLVlJVXZHT25fhmfd5DZ5uwyoKVymtFZiMnSlY=;
        b=gHqF1uOih43AXNzHzbWbOef/UAT/sdBbhA6pVw9JW7vHSLI0GJOOn3dTbNu77rlAU5
         lfufQfBMABSnqaLizFWzRSAfR50s3MgL+swzvmUk9jnsWTmc6YFhQ3SLJRomevskDu27
         +2zVCJGh/BANmVu5IzboWfCwGogD2gnixTfs3Zuncyy5ZwxdecCrOjtE1SeaTyk5Xsr1
         fMphlYPFAXd5yjFK8kudI7J3M/pYCDs22lXUjZChuTVRlB7niaZL6ro0lK4b/Ksncczp
         MCcYl+M1Y6OyF45mSG/JJ0dG57vBQ8YMM6ic0QL81tobZMSaUnndk3JSAnnijzcWLoW8
         CGTg==
X-Forwarded-Encrypted: i=1; AJvYcCUkVVdT04e/J81YHlB1+7I6GohRM6g6NC5pCRr/zwyGsgGS5BcZsUGOZqM70Vx8XhFuwF1t2rQL@vger.kernel.org, AJvYcCVBOulNlDNrIOHG2XW9tdkG5/wNChxCYmOxZZ1ZhYZwgeyaaZzUr++au2HT47avkUTB3OYhfy7reQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz6SkQV26Db7XcZUeViq1NPQPa9dyv7kPyEyQqZNhQ8ayCSTZf
	XpyHzwkKtsNdHnppfD2HcdCSfRJRBrp3vSgOSiCVwmGmEEMVI1Qq
X-Google-Smtp-Source: AGHT+IFvVAuKI/Yq3ttNE4CyE+2jbXQgb5hV1FuXks+mjUFQ1w9P5qj03cVnDor9Y27w2LjjKdDsnA==
X-Received: by 2002:a05:6402:90e:b0:5c9:1b50:1a5c with SMTP id 4fb4d7f45d1cf-5cbbf89cb8amr26712715a12.9.1730854203663;
        Tue, 05 Nov 2024 16:50:03 -0800 (PST)
Received: from [192.168.42.189] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6ac178csm1948953a12.44.2024.11.05.16.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 16:50:03 -0800 (PST)
Message-ID: <3682d8ea-eecd-44b1-a446-473223e689ba@gmail.com>
Date: Wed, 6 Nov 2024 00:50:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/15] net: page pool: add helper creating area from
 pages
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-7-dw@davidwei.uk>
 <CAHS8izMkpisFO1Mx0z_qh0eeAkhsowbyCqKqvcV=JkzHV0Y2gQ@mail.gmail.com>
 <2928976c-d3ea-4595-803f-b975847e4402@gmail.com>
 <CAHS8izOuP6FDFNtEVOQeNnPmAXuqaYaokjkQCVX0SOzcwDM3xg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOuP6FDFNtEVOQeNnPmAXuqaYaokjkQCVX0SOzcwDM3xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/24 23:34, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 11:16 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> Even though Jakub didn't comment on this patch, but he definitely
>> wasn't fond of giving all those headers to non net/ users. I guess

>> I can't please everyone. One middle option is to make the page
>> pool helper more granular, i.e. taking care of one netmem at
>> a time, and moving the loop to io_uring, but I don't think it

                  ^^^

>> changes anything.
>>
> 
> My issue is that these:
> 
> +int page_pool_mp_init_paged_area(struct page_pool *pool,
> +                               struct net_iov_area *area,
> +                               struct page **pages);
> +void page_pool_mp_release_area(struct page_pool *pool,
> 
> Are masquerading as generic functions to be used by many mp but
> they're really io_uring specific. dmabuf and the hugepage provider
> would not use them AFAICT. Would have liked not to have code specific
> to one mp in page_pool.c, and I was asked to move the dmabuf specific
> functions to another file too IIRC.
> 
> These helpers depend on:
> 
> page_pool_set_pp_info: in netmem_priv.h
> net_iov_to_netmem(niov): in netmem.h
> page_pool_dma_map_page: can be put in page_pool/helpers.h?
> page_pool_release_page_dma(pool, netmem):  can be put in page_pool/helpers.h?
> 
> I would prefer moving page_pool_set_pp_info (and the stuff it calls
> into) to netmem.h and removing io_uring mp specific code from
> page_pool.c.

I just already described it above but somewhat less detailed. FWIW,
page_pool_dma_map_page() + page_pool_set_pp_info() has to be combined
into a single function as separately they don't make a good public
API. I can change it this way, but ultimately there is no much
difference, it needs to export functions that io_uring can use.
Does it make a better API? I doubt it, and it can be changed later
anyway. Let's not block the patchset for minor bikeshedding.

...
>>> Instead it uses net_iov-backed-netmem and there is an out of band page
>>> to be managed.
>>>
>>> I think it would make sense to use paged-backed-netmem for your use
>>> case, or at least I don't see why it wouldn't work. Memory providers
>>
>> It's a user page, we can't make assumptions about it, we can't
>> reuse space in struct page like for pp refcounting (unlike when
>> it's allocated by the kernel), we can't use the normal page
>> refcounting.
>>
> 
> You actually can't reuse space in struct net_iov either for your own
> refcounting, because niov->pp_ref_count is a mirror to
> page->pp_ref_count and strictly follows the patterns of that. But
> that's the issue to be discussed on the other patch...

Right, which is why it's used for usual buffer refcounting that
page pool / net stack recognises. It's also not a problem to extend
it for performance reasons, those are internals and can be changed
and there are ways to change it.

>> If that's the direction people prefer, we can roll back to v1 from
>> a couple years ago, fill skbs fill user pages, attach ubuf_info to
>> every skb, and whack-a-mole'ing all places where the page could be
>> put down or such, pretty similarly what net_iov does. Honestly, I
>> thought that reusing common infra so that the net stack doesn't
>> need a different path per interface was a good idea.
>>
> 
> The common infra does support page-backed-netmem actually.

Please read again why user pages can't be passed directly,
if you take a look at struct page and where pp_ref_count and
other bits are, you'll find a huge union.

>>> were designed to handle the hugepage usecase where the memory
>>> allocated by the provider is pages. Is there a reason that doesn't
>>> work for you as well?
>>>
>>> If you really need to use net_iov-backed-netmem, can we put this
>>> weirdness in the provider? I don't know that we want a generic-looking
>>> dma_map function which is a bit confusing to take a netmem and a page.>
>> ...
>>>> +
>>>> +static void page_pool_release_page_dma(struct page_pool *pool,
>>>> +                                      netmem_ref netmem)
>>>> +{
>>>> +       __page_pool_release_page_dma(pool, netmem);
>>>> +}
>>>> +
>>>
>>> Is this wrapper necessary? Do you wanna rename the original function
>>> to remove the __ instead of a adding a wrapper?
>>
>> I only added it here to cast away __always_inline since it's used in
>> a slow / setup path. It shouldn't change the binary, but I'm not a huge
>> fan of leaving the hint for the code where it's not needed.
>>
> 
> Right, it probably makes sense to make the modifications you want on
> the original function rather than create a no-op wrapper to remove the
> __always_inline.

Removing __always_inline from a function deemed hot enough to need
the attribute is not a good idea, not in an unrelated feature
patchset. FWIW, it's not a new practice either. If maintainers will
insist on removing it I'll do.

-- 
Pavel Begunkov

