Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403AF4595F1
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 21:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhKVUL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 15:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240038AbhKVUL6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 15:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637611731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wx9owdJOrmjGXLWEhFvkrVgkkHwU/2JlwqTvYXsyeFw=;
        b=TqxE3/VE9R+psUEWcF3Rizu94GU0aTW5u+zs4gdvyD6NaeYokSLZPzVRvq6s0ck19ZDgSu
        5qhogR8oIOWDIKv11GMFRqKYPKlw4Qu6aX2gz3+qNxsSanrbmLrUmBZTBVxDkKJ4mXQ4Zm
        NFGwDk64KV2HndjqSBZ8eazclo/5m44=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-WDHU1P6mOVmfUv-A13TDWQ-1; Mon, 22 Nov 2021 15:08:50 -0500
X-MC-Unique: WDHU1P6mOVmfUv-A13TDWQ-1
Received: by mail-wm1-f70.google.com with SMTP id ay34-20020a05600c1e2200b00337fd217772so405352wmb.4
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 12:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=wx9owdJOrmjGXLWEhFvkrVgkkHwU/2JlwqTvYXsyeFw=;
        b=HgEo8jGwuneQYg8TbKCIhZ5NXr/rZXNIi9z/hUMGQfxgli/9oPs/Bg577l7P9BW3ss
         brIh4/wk1VOg7M/KvBKUxLEXaZ1DqfXs8XzrreW0rARFJGw8pBgocSNdfgWwj3Eds6hO
         48o6IQ7ZpRa2J7F4uTg5vBH2MwI7XHQJEG5hdJYomJldcz4JbsUrJAKD4zar8H3qyAPU
         oGk6zBhBXYPJlyWgONERaAfHRR6TO0JHnLbmnQ7P3n2dWjesxziD5GyDaIUvwldQKeLM
         miJKcWDkBg+YLlxo2nWVzK+ptJMkMAwSe7jYE9hF6NSQ9g2flQZUx6p9MOjlaIAmTsJV
         M1PQ==
X-Gm-Message-State: AOAM531n9PbHGAOLc+gpX/dvoIbnuAa5gDsLgqHSUu3DgUIlqERfKipt
        aofE6wNABvPY0PrfOiRW070j491V5V95SCcU3Zy28Azf/ofOzCMErYLFoCdDjAxii46aJ1tWBym
        P3GHw1AYKCUwQHxAnd5I=
X-Received: by 2002:a1c:4c19:: with SMTP id z25mr33463177wmf.177.1637611728815;
        Mon, 22 Nov 2021 12:08:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4rF1zQh8IxxZ21UD3M7noCmiFkX9+K7yUl3FtS0Rnvm9Mdu8ZgNai9WbpFa7URCgixu8GMQ==
X-Received: by 2002:a1c:4c19:: with SMTP id z25mr33463131wmf.177.1637611728568;
        Mon, 22 Nov 2021 12:08:48 -0800 (PST)
Received: from [192.168.3.132] (p5b0c667b.dip0.t-ipconnect.de. [91.12.102.123])
        by smtp.gmail.com with ESMTPSA id l5sm24227434wms.16.2021.11.22.12.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 12:08:47 -0800 (PST)
Message-ID: <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
Date:   Mon, 22 Nov 2021 21:08:47 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22.11.21 20:53, Jens Axboe wrote:
> On 11/22/21 11:26 AM, David Hildenbrand wrote:
>> On 22.11.21 18:55, Andrew Dona-Couch wrote:
>>> Forgive me for jumping in to an already overburdened thread.  But can
>>> someone pushing back on this clearly explain the issue with applying
>>> this patch?
>>
>> It will allow unprivileged users to easily and even "accidentally"
>> allocate more unmovable memory than it should in some environments. Such
>> limits exist for a reason. And there are ways for admins/distros to
>> tweak these limits if they know what they are doing.
> 
> But that's entirely the point, the cases where this change is needed are
> already screwed by a distro and the user is the administrator. This is
> _exactly_ the case where things should just work out of the box. If
> you're managing farms of servers, yeah you have competent administration
> and you can be expected to tweak settings to get the best experience and
> performance, but the kernel should provide a sane default. 64K isn't a
> sane default.

0.1% of RAM isn't either.

> 
>> This is not a step into the right direction. This is all just trying to
>> hide the fact that we're exposing FOLL_LONGTERM usage to random
>> unprivileged users.
>>
>> Maybe we could instead try getting rid of FOLL_LONGTERM usage and the
>> memlock limit in io_uring altogether, for example, by using mmu
>> notifiers. But I'm no expert on the io_uring code.
> 
> You can't use mmu notifiers without impacting the fast path. This isn't
> just about io_uring, there are other users of memlock right now (like
> bpf) which just makes it even worse.

1) Do we have a performance evaluation? Did someone try and come up with
a conclusion how bad it would be?

2) Could be provide a mmu variant to ordinary users that's just good
enough but maybe not as fast as what we have today? And limit
FOLL_LONGTERM to special, privileged users?

3) Just because there are other memlock users is not an excuse. For
example, VFIO/VDPA have to use it for a reason, because there is no way
not do use FOLL_LONGTERM.

> 
> We should just make this 0.1% of RAM (min(0.1% ram, 64KB)) or something
> like what was suggested, if that will help move things forward. IMHO the
> 32MB machine is mostly a theoretical case, but whatever .

1) I'm deeply concerned about large ZONE_MOVABLE and MIGRATE_CMA ranges
where FOLL_LONGTERM cannot be used, as that memory is not available.

2) With 0.1% RAM it's sufficient to start 1000 processes to break any
system completely and deeply mess up the MM. Oh my.


No, I don't like this, absolutely not. I neither like raising the
memlock limit as default to such high values nor using FOLL_LONGTERM in
cases where it could be avoided for random, unprivileged users.

But I assume this is mostly for the records, because I assume nobody
cares about my opinion here.

-- 
Thanks,

David / dhildenb

