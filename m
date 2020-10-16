Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A828290716
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 16:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406785AbgJPOXD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 10:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406665AbgJPOXD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 10:23:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE48C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 07:23:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 1so1383015ple.2
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 07:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LHwdoU5xJRXsIFHp7RY/0oU3V0pjRfbeUgAFb2T1xW4=;
        b=g6ZCIcDKP6R4Jph2TfTQkGUh70t6DdoVqS0y/TZvePe5JAvdrqdYp99+bjdZ5ASIR5
         Wu2jxrKI/+NN45SEcyOeKbK12b/qPOWFBETR9q+sTATqpgSbNLOh1nGg3OkJ6LgRQ3W8
         XVjhmnUxyRvN7l29NIsiaygfzCWCfCNIHccQqgrrTexiJVuro9dJ+TFCAV46Oi2lJTla
         haxU9TxVcUcxe0nehaHeIO6BHE1g/B/lQYnhBRu1FlJP19uCqQUjUqjCRCcIeSAQnb8P
         P76VZXN5kE3biSDHBA/mMrOjqSaYdPvp+SLeutRJ5dU9StA+nDEGigPdkrbu2kPj/ciw
         xWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LHwdoU5xJRXsIFHp7RY/0oU3V0pjRfbeUgAFb2T1xW4=;
        b=dvQcbt9RHxk6Bfj8V4ajhh7J92DLzECuaaBK7T4lBp9NBLv2Olvpu1XaQHOggvlG76
         I61fXLDDtQPJEf4XQtmIGiVxU19SDueTY5E77JP8lxjcTgPL9o/SyybKmIzwNC+ZSAQX
         LeYsBD2F5H73JlZTwIhr83hN6jZExhFCN9NJsfz02vYe+ZN9SqAw8TJfpQx2lrBO8MAX
         iMl8mXD9Skf8AhsZnnMNlKW3kY8NZoKWCfWl90RULDkNWFJt/d1ovEZFw+VoQXQLRRzm
         oHdUfVCWqhnfsd4CRP4bJuzPUPhKL9HZPhCLZxtkVpNJkfJjTLWy08rDpxip9+xI/3xd
         BeLQ==
X-Gm-Message-State: AOAM530xgRbRV2CNSjajoggJI6No/KqSGHKqRpp9PTW7nJgBTYD9/XQA
        Mpe3KKt0B4MODu7aOuX77NXkl/Y1MX112/m9
X-Google-Smtp-Source: ABdhPJzJ0RVgSYxH+7F+93XvFAj/08Bjf+7yp4Jr7//ZJrpsUt8SWpsGJCSes2rz6rr7cBp65Qs+Dg==
X-Received: by 2002:a17:902:ec02:b029:d1:fc2b:fe95 with SMTP id l2-20020a170902ec02b02900d1fc2bfe95mr4446705pld.79.1602858180993;
        Fri, 16 Oct 2020 07:23:00 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 66sm2882105pgd.84.2020.10.16.07.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 07:23:00 -0700 (PDT)
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com>
 <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
 <87a6wmv93v.fsf@nanos.tec.linutronix.de>
 <c7da5280-f283-2c89-f6f2-be7d84c3675a@kernel.dk>
 <87d01itg4z.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b04c6c1-28df-4810-8382-f9a418d72267@kernel.dk>
Date:   Fri, 16 Oct 2020 08:22:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87d01itg4z.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 8:11 AM, Thomas Gleixner wrote:
> Jens,
> 
> On Fri, Oct 16 2020 at 07:33, Jens Axboe wrote:
>> On 10/16/20 3:00 AM, Thomas Gleixner wrote:
>> I totally agree, and we're on the same page. I think you'll find that in
>> the past I always carry through, the task_work notification was somewhat
>> of a rush due to a hang related to it. For this particular case, the
>> cleanups and arch additions are pretty much ready to go.
> 
> As we seem to be on the same page with this, let me suggest how this
> should go:
> 
> 1) A cleanup for the task_work_add() mess. This is trivial enough and
>    should go in before rc1.

No problem, I'll get that posted shortly.

> 2) The TIF_NOTIFY_RESUME change is a nice cleanup on it's own and can go
>    before rc1 as well.

Would you mind taking that one? It's good to go.

> 3) Core infrastructure (patch 2 + 3 + 5) of this series
> 
>    Please make the changes I asked for in the generic entry code and
>    moving the handling into get_signal() for everybody else.
> 
>    So get_signal() gains:
> 
>      if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) {
> 	 (test_thread_flag(TIF_NOTIFY_SIGNAL))
> 		tracehook_notify_signal();
> 
>          if (!task_sigpending(current))
>  		return 0;
>      }
> 
>    And with that you don't have to touch do_signal() in any architecture
>    except x86 which becomes:
> 
>    arch_do_signal_or_restart(bool sigpending)

Already did most of this, just need to handle the !CONFIG_GENERIC_ENTRY
for get_signal() and adapt the existing non-generic arch patches to
this.

> 4) Conversion of all architectures which means adding the TIF bit.
> 
>    If the architecture folks are happy, then this can be collected in
>    tip, which would be preferred because then 

Mostly done,
> 
> 5) Cleanups
> 
>    can just go on top.
> 
> Hmm?

Sounds good to me, as long as we keep the existing ordering with
x86/generic TIF_NOTIFY_SIGNAL support being able to move forward
before all archs have acked the arch specific change. Doesn't really
change how I'll get it done, and we're mostly there. Just don't
anything gated on potential slowest common denominator.

-- 
Jens Axboe

