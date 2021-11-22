Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89862459707
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 22:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhKVV7i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 16:59:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237016AbhKVV7g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 16:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637618188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5DAe1gdf6Kwi2vx+MSMPnRhHLBKz9idjNkHP8MSJ3s=;
        b=eJzlQTUIrW2h9w5GZAjEgU2F0JskkVAhAvBx6IdSkV0Md978KsxQK31fJ8b3Wl2GcYN3tu
        NTee58HU/CedzjYegLUr8IJ3BqSM0A8RiJOk/pMotCENDY1sZEQWjIlQ6X6DF+9iJB+Jh0
        nJRQRf3l4pgdB6Ig0vv/T/4An95nTQ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-EjdRclQKO4qt-e5Aky5qxQ-1; Mon, 22 Nov 2021 16:56:27 -0500
X-MC-Unique: EjdRclQKO4qt-e5Aky5qxQ-1
Received: by mail-wm1-f71.google.com with SMTP id r129-20020a1c4487000000b00333629ed22dso214283wma.6
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 13:56:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=W5DAe1gdf6Kwi2vx+MSMPnRhHLBKz9idjNkHP8MSJ3s=;
        b=l2XV4GBrsXp/C+cJX7/nuWeLI4KMMgRGnG+Jnhb8I8ybf23TODRZEUXlhHW1qfCFoS
         fhuVtlD+GEKfWMI2fSwuTT/oPV6SlFXxsp5iKSDRrSK7RaNxFoXkylOIVJ8PrxBeWP7W
         qprK/23PCnu7fMg8098M0iu0kfQKtt9vqZs7kq2Ubw06ivEiEYQpMYPY/7DO/DYTFT6L
         SvETAjZQin1yO7lSmQFB9TLQXdDmQi/cgquslyohXc8yThIDc/GykHYlNahtpmOVHQT8
         gn6yfaHpofvNu8BCx8ufzHPslO8EMyOjuij0lZ98dSQ1X5b+XQFvRYK1s9pvGCsP0z3y
         xRDg==
X-Gm-Message-State: AOAM530Uy1/FDkyFta56hcANh8yEbreD4wTf/rJ2i1YUUhMbucUYQ1sf
        rOlsH/3j+GaP4YqfGfsaLft4btzokUGyFpR0uFW9DNdjePiTV8WybRHUwnhrpvFYHC5zWULD/Vf
        CYViP9qXTj9bkfYW39SY=
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr708354wrw.116.1637618186173;
        Mon, 22 Nov 2021 13:56:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKXRB9yEqdwVRzeunUOwgploM8hm0Lx19ZeHTw7CQCkN1pDTfPBIbiiZcU9xqPM8Lk/YdiAw==
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr708315wrw.116.1637618185919;
        Mon, 22 Nov 2021 13:56:25 -0800 (PST)
Received: from [192.168.3.132] (p5b0c667b.dip0.t-ipconnect.de. [91.12.102.123])
        by smtp.gmail.com with ESMTPSA id s8sm10545506wra.9.2021.11.22.13.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 13:56:25 -0800 (PST)
Message-ID: <ffa66565-d546-a2cf-1748-38b9992fd5b8@redhat.com>
Date:   Mon, 22 Nov 2021 22:56:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <3adc55d3-f383-efa9-7319-740fc6ab5d7a@kernel.dk>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <3adc55d3-f383-efa9-7319-740fc6ab5d7a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22.11.21 21:44, Jens Axboe wrote:
> On 11/22/21 1:08 PM, David Hildenbrand wrote:
>> On 22.11.21 20:53, Jens Axboe wrote:
>>> On 11/22/21 11:26 AM, David Hildenbrand wrote:
>>>> On 22.11.21 18:55, Andrew Dona-Couch wrote:
>>>>> Forgive me for jumping in to an already overburdened thread.  But can
>>>>> someone pushing back on this clearly explain the issue with applying
>>>>> this patch?
>>>>
>>>> It will allow unprivileged users to easily and even "accidentally"
>>>> allocate more unmovable memory than it should in some environments. Such
>>>> limits exist for a reason. And there are ways for admins/distros to
>>>> tweak these limits if they know what they are doing.
>>>
>>> But that's entirely the point, the cases where this change is needed are
>>> already screwed by a distro and the user is the administrator. This is
>>> _exactly_ the case where things should just work out of the box. If
>>> you're managing farms of servers, yeah you have competent administration
>>> and you can be expected to tweak settings to get the best experience and
>>> performance, but the kernel should provide a sane default. 64K isn't a
>>> sane default.
>>
>> 0.1% of RAM isn't either.
> 
> No default is perfect, byt 0.1% will solve 99% of the problem. And most
> likely solve 100% of the problems for the important case, which is where
> you want things to Just Work on your distro without doing any
> administration.  If you're aiming for perfection, it doesn't exist.

... and my Fedora is already at 16 MiB *sigh*.

And I'm not aiming for perfection, I'm aiming for as little
FOLL_LONGTERM users as possible ;)

> 
>>>> This is not a step into the right direction. This is all just trying to
>>>> hide the fact that we're exposing FOLL_LONGTERM usage to random
>>>> unprivileged users.
>>>>
>>>> Maybe we could instead try getting rid of FOLL_LONGTERM usage and the
>>>> memlock limit in io_uring altogether, for example, by using mmu
>>>> notifiers. But I'm no expert on the io_uring code.
>>>
>>> You can't use mmu notifiers without impacting the fast path. This isn't
>>> just about io_uring, there are other users of memlock right now (like
>>> bpf) which just makes it even worse.
>>
>> 1) Do we have a performance evaluation? Did someone try and come up with
>> a conclusion how bad it would be?
> 
> I honestly don't remember the details, I took a look at it about a year
> ago due to some unrelated reasons. These days it just pertains to
> registered buffers, so it's less of an issue than back then when it
> dealt with the rings as well. Hence might be feasible, I'm certainly not
> against anyone looking into it. Easy enough to review and test for
> performance concerns.

That at least sounds promising.

> 
>> 2) Could be provide a mmu variant to ordinary users that's just good
>> enough but maybe not as fast as what we have today? And limit
>> FOLL_LONGTERM to special, privileged users?
> 
> If it's not as fast, then it's most likely not good enough though...

There is always a compromise of course.

See, FOLL_LONGTERM is *the worst* kind of memory allocation thingy you
could possible do to your MM subsystem. It's absolutely the worst thing
you can do to swap and compaction.

I really don't want random feature X to be next and say "well, io_uring
uses it, so I can just use it for max performance and we'll adjust the
memlock limit, who cares!".

> 
>> 3) Just because there are other memlock users is not an excuse. For
>> example, VFIO/VDPA have to use it for a reason, because there is no way
>> not do use FOLL_LONGTERM.
> 
> It's not an excuse, the statement merely means that the problem is
> _worse_ as there are other memlock users.

Yes, and it will keep getting worse every time we introduce more
FOLL_LONGTERM users that really shouldn't be FOLL_LONGTERM users unless
really required. Again, VFIO/VDPA/RDMA are prime examples, because the
HW forces us to do it. And these are privileged features either way.

> 
>>>
>>> We should just make this 0.1% of RAM (min(0.1% ram, 64KB)) or something
>>> like what was suggested, if that will help move things forward. IMHO the
>>> 32MB machine is mostly a theoretical case, but whatever .
>>
>> 1) I'm deeply concerned about large ZONE_MOVABLE and MIGRATE_CMA ranges
>> where FOLL_LONGTERM cannot be used, as that memory is not available.
>>
>> 2) With 0.1% RAM it's sufficient to start 1000 processes to break any
>> system completely and deeply mess up the MM. Oh my.
> 
> We're talking per-user limits here. But if you want to talk hyperbole,
> then 64K multiplied by some other random number will also allow
> everything to be pinned, potentially.
> 

Right, it's per-user. 0.1% per user FOLL_LONGTERM locked into memory in
the worst case.

-- 
Thanks,

David / dhildenb

