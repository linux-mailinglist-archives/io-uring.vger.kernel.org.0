Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FEC3AA62F
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 23:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhFPVfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 17:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbhFPVfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 17:35:52 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3869CC061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 14:33:44 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t140so4133702oih.0
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ps+mzs5onslHDI+dnpIhDM2BoX/zDh+U15SPZVGxthY=;
        b=fs1u292toXegX6Dp8U7cg3JRI3hbuN3+WAUqzu10THK3OimialhN7XUz5BlF2KyXHq
         oACx9zopI58jrzEpOUvhWvD9ctWIjpWtmOKji0DsqJwayP+a1AiLd0o9VahRuybItjZU
         gVe6dZJek6EXrdJVBOKCuhDI9LjusqnIDMpyFkrEZOUccjlttFvAocjyDjsYpgwiMEHM
         ywR/A+SmFZ/2Z1IMTRzyrRip1fxqByYthP026VvIN6BsJmgorQuEfEAZIBzaGDjg+ZIp
         in1rXWJkaGy8LLsL+9vikNVX2PwEmKc3AFbr3aSym/FMg8j1KbKDpIF8snSXI7QR/eqH
         AGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ps+mzs5onslHDI+dnpIhDM2BoX/zDh+U15SPZVGxthY=;
        b=tvMCmAcbggIiy1pbRtyc314K+MBcVRA/2E+Gy15mG60LcG5bYjmuvc8z8sYisn/0eM
         aCs22Gws5fTGfBavEAx3wYE5+SWAs/Lp6uFBwPMnF2rVYZDV9HRZbq6EWB2m6Z4EC0KW
         uBt4qq0wgJlTPNFVflrm6ANidX7MgYCQFrax2shvTKNH9HrAuTCyyEoqgKJN6fb/OHoA
         0MkO0I5TuJ8lznkii6ZWpIehp/981REXiRhx8wCZQyhQyWqxJ3UAEXr9146dHL1ulBBX
         2K6h9+zUQp3ZPGQr8LdoSrBssPOJzJfvqtCRcHF6esYbJ1xnXzhEly877M6jjFXee9ud
         Qafg==
X-Gm-Message-State: AOAM533C0H5S115padJBaV2xZLwEYEeUQb28lcuLHGh+isWVB1S9NYZT
        5+6XwmyMQO52dTss2x3hwh8baQ==
X-Google-Smtp-Source: ABdhPJxbTgygjwtlJlyhjRove7EZLhFcq+1y0tGdv/rzKLdZMwW5VwB/5HHx7HaMCjxrOVoLLjbGQw==
X-Received: by 2002:aca:4dc3:: with SMTP id a186mr8360124oib.63.1623879223473;
        Wed, 16 Jun 2021 14:33:43 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m10sm702536oig.9.2021.06.16.14.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 14:33:43 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Olivier Langlois <olivier@trillion01.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
 <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
 <20210615193532.6d7916d4@gandalf.local.home>
 <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
 <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
 <237f71d5-ee6e-247c-c185-e4e6afbd317c@kernel.dk>
 <1cf91b2f760686678acfbefcc66309cd061986d5.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <902fdad6-4011-07fc-ea0e-5bac4e34d7bc@kernel.dk>
Date:   Wed, 16 Jun 2021 15:33:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cf91b2f760686678acfbefcc66309cd061986d5.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 3:30 PM, Olivier Langlois wrote:
> On Wed, 2021-06-16 at 13:02 -0600, Jens Axboe wrote:
>> On 6/16/21 1:00 PM, Olivier Langlois wrote:
>>> On Wed, 2021-06-16 at 06:49 -0600, Jens Axboe wrote:
>>>>
>>>> Indeed, that is what is causing the situation, and I do have them
>>>> here.
>>>> Olivier, you definitely want to fix your mail setup. It confuses
>>>> both
>>>> MUAs, but it also actively prevents using the regular tooling to
>>>> pull
>>>> these patches off lore for example.
>>>>
>>> Ok, I will... It seems that only my patch emails are having this
>>> issue.
>>> I am pretty sure that I can find instances of non patch emails
>>> going
>>> making it to the lists...
>>
>> The problem is that even if they do make it to the list, you can't
>> use eg b4 to pull them off the list.
>>
> Jens,
> 
> I am unfamiliar with the regular tooling and eg b4 (which I assume are
> part of the regular tooling) so I am not fully understanding everything
> you say.

Sorry, I could have been more clear. b4 is a tool that pulls patches off
lists managed by lore.kernel.org, and I use it quite often to avoid
manually saving emails and applying. It'll collect reviews etc as well,
and I integrate it with git. That means, if you send a patchset of 3
patches with a cover letter, if I like the series I just do:

$ git b4 <message id of cover>

and it applies it for me, adding links, reviews, etc.

> My take away from all this is that it is very important that my patches
> do reach the lists and I commit to put the necessary efforts to make
> that happen.

Yes. Both for tooling, but also so that non-cc'ed people see it and can
reply.

> My last email was simply myself starting diagnose where my problem
> could be outloud.
> 
> Steven did mention that he wasn't seeing the Message-Id field in my
> patch emails. I'm very grateful for this clue!
> 
> My main email client is Gnome Evolution (when Message-Id is present in
> my mails) and I do the following to send out patches:
> 
> 1. git format-patch -o ~/patches HEAD^
> 2. Edit patch file by adding recipients listed by
> scripts/get_maintainer.pl
> 3. cat patch_file | msmtp -t -a default

Why not just use git send-email? That's literally what that is for. It's
what I use to send out patches.

> The weird thing is that when I have noticed that my patches weren't
> making it to the lists, I started to Cc myself to receive a copy of the
> patch. When I inspect the copy header, it contains the Message-Id field
> but it might be the receiving email client that on reception does add
> the missing field so I don't know exactly what is happening.
> 
> you have my word. Next patch I send, it will be make it to the lists.
> 
> thx a lot for your comprehension and your assistance!

Thanks for sending out patches!

-- 
Jens Axboe

