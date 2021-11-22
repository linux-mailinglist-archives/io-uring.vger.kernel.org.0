Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64D4595CC
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 20:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhKVT4l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 14:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbhKVT4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 14:56:40 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0139C061714
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 11:53:33 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id i9so13826032ilu.1
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 11:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYWRo4OnMSjtGg0tX+Mk+QuvsqmMl0X/zqqUxoDxPuQ=;
        b=qoIiOgAz8Ked6kslZpQ1ZXKr3ZWose+cMbN8e9bUt2W9tM31pFZfHHWfthnKAumbo/
         1iP0vPgfFO1apG/C8gEGIo6yTpnJ6JPgdrRwSgIAqStCoogmfCmweTHT/YQQ469eLX23
         T8Y3uvEi8+aNAfk3DCwP1TzSgZHmy0qJS7/uXfgkgcGEtpsWhdMTngaYY9BXV/61i+a9
         SW3V5XEHG8wSYxT+88+G0ie4lIJuZ7yx4a4nP+IW2R8k4nXEHpHA/nr+9jVYIUaUwrL5
         QBGPVGnUUFY7x+w4KS7oAAv5gRkF+1rM3ZekVRyRutgpFYSnbxMpoeLU9UOr6l6yh2zs
         LMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYWRo4OnMSjtGg0tX+Mk+QuvsqmMl0X/zqqUxoDxPuQ=;
        b=itS1l4UbvdM9zJDjqnqjrAzEvx0yOyLlld0tM9X39yVBW0sE5qhHEMm5Pk1FM4a7WT
         Z7LZuCf7ynHCbORkGweRKaWFUFrCS4KZyTVtZqQdraEec5870UHCSrKOnFpHEZRLcW3h
         JUhsTJoC4Jd3beANBlkkWLUtNjJ6jl1T9gvLcn4IRJCEL8Y/lxleFlMFQ9MIX/uBzfb2
         FCl1TjReTdLyq3pMW55sMoNS57SeeZkHABWfC/Luwywfipb0VG/i+XVWv+i/SprL4i42
         1hRh9Pz28FozPZe8QbRlrrLXOoXM9as8wrp8gdJQqIvH65/rQt7sriN6A7x+3A8KorDm
         xKLQ==
X-Gm-Message-State: AOAM533nMCyvb0racXTzhziQeJbpyHLVo6HNFb3gmb+HSfeXgaUQmBGT
        7wlak7VN36gUmEfcLUxadvBjaA==
X-Google-Smtp-Source: ABdhPJwP3wYrRTZQJ8HHrsPBlUltYe5Z5Bf7eDFAFZOy32OsoOlu2fOqGFaq9YOGEZF+8WYUctP5NQ==
X-Received: by 2002:a05:6e02:1563:: with SMTP id k3mr21659500ilu.256.1637610813112;
        Mon, 22 Nov 2021 11:53:33 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a25sm5389768ioa.24.2021.11.22.11.53.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 11:53:32 -0800 (PST)
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     David Hildenbrand <david@redhat.com>,
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
Date:   Mon, 22 Nov 2021 12:53:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/22/21 11:26 AM, David Hildenbrand wrote:
> On 22.11.21 18:55, Andrew Dona-Couch wrote:
>> Forgive me for jumping in to an already overburdened thread.  But can
>> someone pushing back on this clearly explain the issue with applying
>> this patch?
> 
> It will allow unprivileged users to easily and even "accidentally"
> allocate more unmovable memory than it should in some environments. Such
> limits exist for a reason. And there are ways for admins/distros to
> tweak these limits if they know what they are doing.

But that's entirely the point, the cases where this change is needed are
already screwed by a distro and the user is the administrator. This is
_exactly_ the case where things should just work out of the box. If
you're managing farms of servers, yeah you have competent administration
and you can be expected to tweak settings to get the best experience and
performance, but the kernel should provide a sane default. 64K isn't a
sane default.

> This is not a step into the right direction. This is all just trying to
> hide the fact that we're exposing FOLL_LONGTERM usage to random
> unprivileged users.
> 
> Maybe we could instead try getting rid of FOLL_LONGTERM usage and the
> memlock limit in io_uring altogether, for example, by using mmu
> notifiers. But I'm no expert on the io_uring code.

You can't use mmu notifiers without impacting the fast path. This isn't
just about io_uring, there are other users of memlock right now (like
bpf) which just makes it even worse.

We should just make this 0.1% of RAM (min(0.1% ram, 64KB)) or something
like what was suggested, if that will help move things forward. IMHO the
32MB machine is mostly a theoretical case, but whatever .

-- 
Jens Axboe

