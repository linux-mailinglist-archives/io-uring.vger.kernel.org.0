Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EF253ACDD
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 20:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiFASec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 14:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiFASeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 14:34:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212E5AEE0B
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 11:34:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p10so3489093wrg.12
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6jxhcpTLpQpqCQ/lMlRKurhSE4dRhSroUWCFgRV4rcY=;
        b=dq/Xmr0z1mGM/nWziaVBE2/R1ChQWKm6869lhr9mndyYXqPwJTWvoFMDrfJ06/L3NF
         23+j343I9DMFynv2l5ve1+R/8D7pGzFO/VY6TYYhZIc4lb0Jz8i/CGMsCCz2chOedwx4
         CGLujttfEf+3T8ntYzvOCVuue486Hzvlm3yRTOAGrsEkI5AvRQulMIhC9NayNO4BQR6B
         2MJmpWGJXh6fIHLiXTWMYZ79cCKP8H/iEnEwWOMej3/pgXsdX2MJF0iS41kFP7CoPwys
         H7OJ+XZ1Pm2Ywo43jaEnLrOT0nRtm54ufAsU6/QH+hUQ7omHxx7eJL2aAdTS3dMh+1qz
         u0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6jxhcpTLpQpqCQ/lMlRKurhSE4dRhSroUWCFgRV4rcY=;
        b=sfSthgcuxBnZ/yzqh11zAmuGwIDjgkwJ+0ST7SznzGxyoyMAJ2TWq7RK7ZTpPvyGOH
         P4rih7x4/zGIrBHwbDx2jifLYUxdqKj7sCikZijbERz3qneivFpDHrrLmwZbhY9Xu2Jt
         rjGAkOySl+mZOUad91LrRy2rbCukfoKc829Jb3Ltg8XgQBHnH9SnI2DONBP95JGZo7TY
         qrC75swijfIgWJjTrhbVEhdyLpgIbD598vbgsYh2n8iDB73Q7kQI7jhZ63/6onTjQ9+e
         lYq7WZm6IwGO1x17MhGIlWoGmE5WeC7ObkGtch+Ff70aiUQJ6P0MDzNWupJYv1fyJrVl
         D3PQ==
X-Gm-Message-State: AOAM530080i79N9mopuf60+ApftXP1mMKbi58L6aaUnOt6AwpWQzvDcA
        WF6gMCdV96Nv413XtTY5uEHNT/aQbIZw3Shj
X-Google-Smtp-Source: ABdhPJz4VJWt9TIZpVk97WSzf+XHoTPocjk0ADtWubRc6QBfSsvq9olSLG6P9JCmb6sdQOnXnBSgKQ==
X-Received: by 2002:a05:6000:1847:b0:20f:c628:5884 with SMTP id c7-20020a056000184700b0020fc6285884mr622739wri.526.1654108468563;
        Wed, 01 Jun 2022 11:34:28 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id o34-20020a05600c512200b003944821105esm3489370wms.2.2022.06.01.11.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 11:34:27 -0700 (PDT)
Message-ID: <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk>
Date:   Wed, 1 Jun 2022 12:34:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
 <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org>
 <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
 <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk>
 <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/22 12:28 PM, Linus Torvalds wrote:
> On Wed, Jun 1, 2022 at 11:21 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Of the added opcodes in io_uring, that one I'm actually certain never
>> ended up getting used. I see no reason why we can't just deprecate it
>> and eventually just wire it up to io_eopnotsupp().
>>
>> IOW, that won't be the one holding us back killing epoll.
> 
> That really would be lovely.
> 
> I think io_uring at least in theory might have the potential to _help_
> kill epoll, since I suspect a lot of epoll users might well prefer
> io_uring instead.
> 
> I say "in theory", because it does require that io_uring itself
> doesn't keep any of the epoll code alive, but also because we've seen
> over and over that people just don't migrate to newer interfaces
> because it's just too much work and the old ones still work..
> 
> Of course, we haven't exactly helped things - right now the whole
> EPOLL thing is "default y" and behind a EXPERT define, so people
> aren't even asked if they want it. Because it used to be one of those
> things everybody enabled because it was new and shiny and cool.
> 
> And sadly, there are a few things that epoll really shines at, so I
> suspect that will never really change ;(

I think there are two ways that io_uring can help kill epoll:

1) As a basic replacement as an event notifier. I'm not a huge fan of
   these conversions in general, as they just swap one readiness
   notifier for another one. Hence they don't end up taking full
   advantage of that io_uring has to offer. But they are easy and event
   libraries obviously often take this approach.

2) From scratch implementations or actual adoptions in applications will
   switch from an epoll driven readiness model to the io_uring
   completion model. These are the conversion that I am the most excited
   about, as the end up using the (imho) better model that io_uring has
   to offer.

But as a first step, let's just mark it deprecated with a pr_warn() for
5.20 and then plan to kill it off whenever a suitable amount of relases
have passed since that addition.

-- 
Jens Axboe

