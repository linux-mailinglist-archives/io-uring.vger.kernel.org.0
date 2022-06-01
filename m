Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D853AF67
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiFAUya (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 16:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiFAUy1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 16:54:27 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8F92122B7
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 13:54:13 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e2so3941759wrc.1
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 13:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=N/bHeAMd6NGzZjtDbxCO9VCF0HtJQ4cd7weGRP/mJWs=;
        b=g0ckxtJ/lfzIHFDH2Bfqo0e9kj8rspBpJ/pTaEAw0M0iEEoc05Yjg126GyqkHjKenQ
         TAY/skHRrHL11Mhc7ACQ3/+ZDxLPIeQRcbjMN2EWO9DBf4SYI78pvHM9CRHgpPfrXyUM
         XqRxbZENd6Kdfa7sqHZP3OWE/z4cXIqtlxwCJIee0VhQSuqjsQhO29mNfN381I30LsGn
         NIsc/2TVyhoIs8ByteCKg/CbOus7TiswSeYjtrdoQD2vvsn5y5FIQOgceWmlHKdc8RZ8
         sTsSBe+pP8ZNVyFDUnjnmY+nbMJhnTebwxP3YY+Hq6rrDXvmY+D9mAajlJxkKFFpeU8r
         +Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N/bHeAMd6NGzZjtDbxCO9VCF0HtJQ4cd7weGRP/mJWs=;
        b=RSSFj69OKcANH4GnMOhk9fcic0ppYoKPFZ/MeixZemjHOWjdbUBJppxWk4BPvO8QMW
         g4vHqyA/8eislvPZ++fnYgFw9LfyyQkr4Y3bGS6T4OhzgFbk+ot+0XkD6LOpyxRcKq9Q
         eLDsnvXRExTvnQoAD26NlVKXnZWX/wtHxIwFkAQl5stvhg/ZbUVgNKOlwz2V5u5g4Z+z
         UfT6O6alDth8Na2CEQ74UYE27/wWaXe0/ohCG8D/+frww9yIdHutbmdMaOdgRdjpvIyX
         UGsxF046WU3g3YRbu0I7Wtn3BXce/w2pn2GSD3xqYHiXeMLOkVN28oq6vqhZFMxVuGZw
         h57Q==
X-Gm-Message-State: AOAM533i4MFVk0c7HzvO10wpTIWBEa3WXPLDRb/awE1T7WkF/2JOSvyA
        0zAvp6g7NRn/fy236AKbI3CxIEOJut6+Osl/
X-Google-Smtp-Source: ABdhPJxwsmY0YfBR+h4ePMbZoRJA/cv9GoJQ7Kwyoh2ERvwhs3BSUuYywt1GE5IDJ+mqMIUKJEcyaQ==
X-Received: by 2002:a5d:5046:0:b0:210:20ba:843b with SMTP id h6-20020a5d5046000000b0021020ba843bmr700697wrt.447.1654110634218;
        Wed, 01 Jun 2022 12:10:34 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id i12-20020a7bc94c000000b0039736892653sm2944092wml.27.2022.06.01.12.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 12:10:33 -0700 (PDT)
Message-ID: <ca0248b3-2080-3ea2-6a09-825d084ac005@kernel.dk>
Date:   Wed, 1 Jun 2022 13:10:32 -0600
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
 <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk>
 <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
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

On 6/1/22 12:52 PM, Linus Torvalds wrote:
> On Wed, Jun 1, 2022 at 11:34 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> But as a first step, let's just mark it deprecated with a pr_warn() for
>> 5.20 and then plan to kill it off whenever a suitable amount of relases
>> have passed since that addition.
> 
> I'd love to, but it's not actually realistic as things stand now.
> epoll() is used in a *lot* of random libraries. A "pr_warn()" would
> just be senseless noise, I bet.

I mean only for the IORING_OP_EPOLL_CTL opcode, which is the only epoll
connection we have in there. It'd be jumping the gun to do it for the
epoll_ctl syscall for sure... And I really have no personal skin in that
game, other than having a better alternative. But that's obviously a
long pole type of deprecation.

> No, there's a reason that EPOLL is still there, still 'default y',
> even though I dislike it and think it was a mistake, and we've had
> several nasty bugs related to it over the years.
> 
> It really can be a very useful system call, it's just that it really
> doesn't work the way the actual ->poll() interface was designed, and
> it kind of hijacks it in ways that mostly work, but the have subtle
> lifetime issues that you don't see with a regular select/poll because
> those will always tear down the wait queues.
> 
> Realistically, the proper fix to epoll is likely to make it explicit,
> and make files and drivers that want to support it have to actually
> opt in. Because a lot of the problems have been due to epoll() looking
> *exactly* like a regular poll/select to a driver or a filesystem, but
> having those very subtle extended requirements.
> 
> (And no, the extended requirements aren't generally onerous, and
> regular ->poll() works fine for 99% of all cases. It's just that
> occasionally, special users are then fooled about special contexts).

It's not an uncommon approach to make the initial adoption /
implementation more palatable, though commonly then also ends up being a
mistake. I've certainly been guilty of that myself too...

> In other words, it's a bit like our bad old days when "splice()" ended
> up falling back to regular ->read()/->write() implementations with
> set_fs(KERNEL_DS). Yes, that worked fine for 99% of all cases, and we
> did it for years, but it also caused several really nasty issues for
> when the read/write actor did something slightly unusual.

Unfortunately that particular change I just had to deal with, and
noticed that we're up to more than two handfuls of fixes for that and I
bet we're not done. Not saying it wasn't the right choice in terms of
sanity, but it has been more painful than I thought it would be.

> So I may dislike epoll quite intensely, but I don't think we can
> *really* get rid of it. But we might be able to make it a bit more
> controlled.
> 
> But so far every time it has caused issues, we've worked around it by
> fixing it up in the particular driver or whatever that ended up being
> triggered by epoll semantics.

The io_uring side of the epoll management I'm very sure can go in a few
releases, and a pr_warn_once() for 5.20 is the right choice. epoll
itself, probably not even down the line, though I am hoping we can
continue to move people off of it. Maybe in another 20 years :-)

-- 
Jens Axboe

