Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10C4394C2C
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 14:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhE2MUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 08:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2MUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 08:20:03 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3DCC061574;
        Sat, 29 May 2021 05:18:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v12so5861996wrq.6;
        Sat, 29 May 2021 05:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aQ0PcCKnwAUdxr6VX93r8yx+bfxXLRxGv7//nhcAdvc=;
        b=rO32vlDRLJyjZnp8NMw0108B7w9uyswIyaD3A6qbcj//qOJe1V21KUUt/2RVOvnOhK
         XhSAvK3UD9b5k1bHaEsDRmRMRpB3L/HPjvGxoFKiLma+nY6kgWlFTfD8I4CIOeD+GMHJ
         ozwRq3TYf4BzMIE+H/e35hc3bYZAfIq6UwcxkX2IbuNWNhCrIe1UvpBuaBmWureu5ebs
         dpEuvyHUVBAXIijBmVnpnoaEB4xe1hE8agFHbhCPKCJHUG+i92PYQR9MrLWnL2wkjsJl
         EHXzTh78lAh7NeZAvJSrzediYXScnKl7f76sSQvbcv38M5oUWLsunILi2lKyYcYndNAR
         BkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQ0PcCKnwAUdxr6VX93r8yx+bfxXLRxGv7//nhcAdvc=;
        b=a8KXGpSp5vbqgMctiKqxoByZqlwdDLOPU8229TDxDdR/fkKEt5C2jfgIPUjmP68Ykc
         hwa7urHXQSMkLT37tW2lcO5ipkTcEbowrFwRWGWottoBABBV+ki1txSTQUcjRuUL5YTU
         x/rpUoA9uKT8jliI05V4DjFpSMPlKv1Z1lSgVeWKAvIwDxawVQy250n2RIG6+x0BFkEY
         KrriK7e2AafezrytnCCEUp0IEa/aZ/q2IacrvNRuYxE3gn8HdVTe9bvlBjcX8DvGQqEd
         gg6iMdTHZM4HQLZBYlRnyvwSTnxEYKaIlOYY2DGdwNZJKgdDj9iFguxQIOyLPkLnkfK0
         PuRw==
X-Gm-Message-State: AOAM532m3GaKSVhQcEr2p5RvQyyCIGSm/j6nMXVLr16OzKvN9xP9Swey
        oy/bRYWexcmpHe9FgXkF5hGArn+UltY=
X-Google-Smtp-Source: ABdhPJzK/leMmNeHfmQFLK56xMId3sHa10ZiaXBcNI2udTNgfy4vHLhkBJDD4E2OQ6UyefZGgw3ukg==
X-Received: by 2002:a5d:64e4:: with SMTP id g4mr13504638wri.366.1622290705357;
        Sat, 29 May 2021 05:18:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id c6sm10240302wrt.20.2021.05.29.05.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 05:18:24 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
To:     Olivier Langlois <olivier@trillion01.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
 <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
 <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
 <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
 <2285bf713be951917f9bec40f9cc45045990cc71.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <867a29df-2ac8-9e51-a912-3123c046a4eb@gmail.com>
Date:   Sat, 29 May 2021 13:18:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2285bf713be951917f9bec40f9cc45045990cc71.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 6:19 PM, Olivier Langlois wrote:
> On Wed, 2021-05-26 at 12:18 -0400, Olivier Langlois wrote:
>>>
>>> If that gets changed, could be also include the personality id and
>>> flags here,
>>> and maybe also translated the opcode and flags to human readable
>>> strings?
>>>
>> If Jens and Pavel agrees that they would like to see this info in the
>> traces, I have no objection adding it.
>>
> I need to learn to think longer before replying...
> 
> opcode in readable string:
> If Jens and Pavel agrees to it, easy to add

Don't mind having them, may be useful, but let's leave stringification
to the userspace, values are well defined so shouldn't be a problem

liburing maybe?

> 
> flags:
> You have my support that it is indeed a very useful info to have in the
> submit_sqe trace when debugging with traces
> 
> flags in readable string:
> After thinking about it, I wouldn't do it. Converting a bitmask of
> flags into a string isn't that complex but it isn't trivial neither.
> This certainly adds a maintenance burden every time the flags would be
> updated. I wouldn't want that burden on my shoulders.
> 
> 

-- 
Pavel Begunkov
