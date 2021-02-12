Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4593731A5FA
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhBLUXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBLUXS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:23:18 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDA7C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:22:38 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o7so421493pgl.1
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m6CeU79EhjnYDhlgG3W7k1hmP5bKjfVhg3irg/iAfgA=;
        b=UFAE/GfACDhJkuaRXm2ZZ4XmeCzidGOte9lghxnq1byEX545fvGKT/3tntj3AstRi8
         fkduy6R+jnIVY+uvrc3FIDkISB01P9KPgZqfK1n2WGZY0yUL870dZ9+6PnvQJzILd/rb
         qB94qlpxWF1v8ypxUUoXg+myfMZ7OwOotrpCmrNyhnnEBoCBa4eLc7/L3pIS5K4DWetx
         sgDupWFHpjQCXCCBjHVZCVpCDeM/hH6o3DhLucW274M1+DLla2my/cw+Jm/ohwTC4F98
         XtR6//HMiFtr4r6aLsVk9r3+6ivNfwoIo98y5abQfGd5RXaNfLHZ2qSOF8slpxYDWCKr
         Ltpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6CeU79EhjnYDhlgG3W7k1hmP5bKjfVhg3irg/iAfgA=;
        b=Jsi21Fa9GH2f5QB6YvEWBElCq+OkPTyf6n47myUOlhJB6IYO83vAJHSxA8K2ec0vs/
         6NPJrBmRaxRJ1fG+rvg8doFxUxNQCo9Zb2VisfnijxB3T/ly5Zc7Q3AYtcTk28GjS7R3
         YcKMYsP8sdZBp6tSNPJ0moU/IxGuvpbYRnzLJFxi9mJDOP+6jtwwJhu9P/ImiWrJG8QY
         goEVaxvQ1O3ULGx5xwM/Xp9XKY2MpiNdbavhA8xZf8tNa0IjqUoX5k1s61gCLWy6f7u9
         MnAcWfNS9x7n98gozdfp4t7a/YX/VgkN0ltf+stP0hK0ZCMn060zKKyyGg+tTvfUtOQb
         Io9Q==
X-Gm-Message-State: AOAM530aZxOg2uT+Drlgp0JAvoGAwRFVDlA0ph831/mCJ8GbOWz9dPFZ
        SBOl9O9oCWArq0dMGPRXtYBxq+AH8K5T7g==
X-Google-Smtp-Source: ABdhPJw9iR+qwPslryK4OhfKG4VW2ZyCM6DSvPW8Hf1/OqEY/ECGudFmOa2r0fDSTEBdkaBLKIEuYQ==
X-Received: by 2002:aa7:86c3:0:b029:1e9:3cb7:49a6 with SMTP id h3-20020aa786c30000b02901e93cb749a6mr3460744pfo.39.1613161357552;
        Fri, 12 Feb 2021 12:22:37 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::16bf? ([2620:10d:c090:400::5:2056])
        by smtp.gmail.com with ESMTPSA id h11sm10020108pfr.201.2021.02.12.12.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:22:37 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
 <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
 <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
 <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk>
 <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb978a7b-bf38-b03f-506a-c0a80f192cad@kernel.dk>
Date:   Fri, 12 Feb 2021 13:22:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 1:15 PM, Linus Torvalds wrote:
> On Fri, Feb 12, 2021 at 12:10 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Right, it's exactly the AF_UNIX dgram case. Working on adding some checks
>> that means we'll catch this sort of thing upfront while testing.
> 
> You might also just add a comment to the IORING_OP_{SEND,RECV}MSG
> cases to the work-flags.
> 
> It doesn't hurt to just mention those kinds of things explicitly.
> 
> Because maybe somebody decides that IO_WQ_WORK_FS is very expensive
> for their workload. With the comment they might then be able to say
> "let's set it only for the AF_UNIX case" or some similar optimization.
> 
> Yeah, it probably doesn't matter, but just as a policy, I think "we
> got this wrong, so let's clarify" is a good idea.

I'll start with the comment, that's certainly the easiest part and
will help catch changes like that in the future. My other idea was
to add a check in path resolution that catches it, for future safe
guards outside of send/recvmsg. That's obviously a separate change
from the comment, but would be nice to have.

-- 
Jens Axboe

