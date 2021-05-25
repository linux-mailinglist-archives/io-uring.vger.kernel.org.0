Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEE13909F2
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 21:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhEYTx5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 15:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhEYTx4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 15:53:56 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2110C061574
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 12:52:26 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b25so14551809iot.5
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 12:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pHX3VOrd9+dhkWdPAt0bdVC0sXVQ4HZoZn4NeyyTwiE=;
        b=VKnKMVjPweEwI1CTNqvFI9XC6XjICrCQjczeIABomg1t9UTgdLMtWJ0bVsWlKiSe10
         NnJF2BjXB3N/xdY9qt5TpsuYKeuaxdar3HA2lolOe9RrK8RwZUOwQF187tnGysEn87Bk
         uOaVmfU+i/Z8ISPDU28bvG0ZstO4ucvl2f9bgGzKWcnHqKeyjoksmtl+08q5qJCeTfbY
         s5zjFOuyqc486+ZN1iHrSUqG4LrtSiJ7FK7ZAfqU5Hk9Q9FKZ1WfnNuY6MFUrcaiF9Hg
         sEFC/gDGr3YkngB/Q0i94jfKufU56b0tS3ZGSpatLNlooXePd0J7LQ9jq7+Viw12cJeD
         fRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pHX3VOrd9+dhkWdPAt0bdVC0sXVQ4HZoZn4NeyyTwiE=;
        b=PWxS1i/iZqzxEdwwZax1g7O73QIYTsdp3Ot+zBDm9TjOMWhmeXjSg2TzHpwQnPIZPP
         MXczfMLZIdVRhO9y7WDz7VcxOz8JV/FlTqgqr2tWm+TnMZTpgUwA9VmNvKEHHyXFoOLA
         BPgG81jMzOvm0/nY25XflyFi0Uoumu+hYL8ww4PH2mTTtyRT5f5VS2lDbYlnv+CrKhm4
         NsoSsV4W/96+0cvCgp4rKOgfe6MyeyJDVJ4BU/VCJ28ny0QYZ6cwLGXmlphXQAfi0aBU
         YeJXScHSNZEVPGEObowfBOscX03FxtQ2rkXSeio/V1PqTw4qOogHYve6kdWnLPe+2uW3
         hJCg==
X-Gm-Message-State: AOAM530eRW5FremisCvV1xPEs6E6Lp/yQLK9h/HWGvkqbezKSWesPsvU
        Yg6nXtxmIIN5+NWW7oxbVvIkVg==
X-Google-Smtp-Source: ABdhPJwx/krpoRf5ZTMSJI88z158XVykWbB9MhVJXnvHlV6tBYk3SR1wSR7D/FEuv6ya1xgA4YA6Ng==
X-Received: by 2002:a5d:8d87:: with SMTP id b7mr19325568ioj.46.1621972345794;
        Tue, 25 May 2021 12:52:25 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j15sm13453063ilc.53.2021.05.25.12.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 12:52:25 -0700 (PDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Olivier Langlois <olivier@trillion01.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
 <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de>
 <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
 <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
 <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
 <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
 <17471c9fec18765449ef3a5a4cddc23561b97f52.camel@trillion01.com>
 <CAHk-=whoJCocFsQ7+Sqq=dkuzHE+RXxvRdd4ZvyYqnsKBqsKAA@mail.gmail.com>
 <3df541c3-728c-c63d-eaeb-a4c382e01f0b@kernel.dk>
 <b360ed542526da0a510988ce30545f429a7da000.camel@trillion01.com>
 <4390e9fb839ebc0581083fc4fa7a82606432c0c0.camel@trillion01.com>
 <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5026f7eb-9cf3-065d-009d-fe0fd3e94c2b@kernel.dk>
Date:   Tue, 25 May 2021 13:52:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/21 1:39 PM, Olivier Langlois wrote:
> On Fri, 2021-05-21 at 03:31 -0400, Olivier Langlois wrote:
>>
>> However, I can reproduce it at will with my real program. So as Linus
>> has suggested, I'll investigate by searching where the PF_IO_WORKER is
>> used.
>>
>> I'll keep the list updated if I discover something.
>>
> I think that I am about to stumble into the key to unravel the mystery
> of my core dump generation issue. I am going ask you a quick question
> and it is very likely to trigger an ahah moment...
> 
> To what value is the task_struct mm field is set to for the io-wkr
> threads?
> 
> If I look in the create_io_thread() function, I can see that CLONE_VM
> isn't set...

It definitely should be, what kernel are you looking at? If CLONE_VM
wasn't set, we'd have various issues with requests accessing user mm.

-- 
Jens Axboe

