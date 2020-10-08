Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C84287617
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 16:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgJHObg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 10:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbgJHObg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 10:31:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F0C061755
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 07:31:34 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b1so1588119iot.4
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 07:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LyHt3eHI3FIkwwqq5kMI+6YnXizAfuknUcS9blSJyB4=;
        b=kV9TEZeZrl54zCtQdEFyo/yZFKFfOeG7Mi0bVbLpjOIokEixlWwymnVtOLEi5be8cF
         NkiwTHlf4wCr4lmHW+9rAdCWTdNk7PEH1fXU7tmNjNLHXYgelJov8SwRtHdBS3Xco9tb
         2ldlTtse6/Rnj7bZh5Bj69FUO6VCbkEix47Iub0KIkWK1ZW+EBlKrgkMvdu7HmxWa9Un
         AkQwlcmt2Vv7SrxLE+52k9waAMGfePYmKjuZDltsGW7ZRED1kSe1an4EOYIWX0fgwPn5
         P3QD9zF1RrbOohbOaNKIH81jFDGBva2VemnU9ryEQw/b63JjTtiadk5kdVUcE8g51wZZ
         1oDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LyHt3eHI3FIkwwqq5kMI+6YnXizAfuknUcS9blSJyB4=;
        b=uoMi5lfKUEw1VDcWC6D33A9jQ51y9Wq7Wct760nnMqJIKgq3R+vj2E7wdhXyUnCo4R
         NUt4WSE70Wt7KxyAcmNcwXPG9r47h8HQpuCHN8fPDew0iXYm1zdSbAvLoua8nZ8yF7/M
         JJy2OPTj8fBgvHz5rAYCLNVV/o3/xI+UvLgN8pJs4+jWOyORFOP+Vd+V4T8aAw0oMFjS
         UjTmPCVcJL9xH1vKd4X9LVJFgiOigpspyrhTrnjn4lCUJwS+Km2ef/n2p9fxhwtETAQ7
         dfltZXUd9lZf4fWL2AVDmS3Nt0PdIfTtP6Lom2W3wQMs9Hzt/16xNElldqLL8cVF1FYC
         moNg==
X-Gm-Message-State: AOAM532iMSLEIxUsrfzLYhBnO34qPuz9nr6RlKUmD3QH2NgQK1xd9U5H
        PymVkI6eOhwys0b3tiUspyObRA==
X-Google-Smtp-Source: ABdhPJw4TCvOOkcz7Kx+5hv1trcKHXw3V2bSggLr4MesAGwoJN23UfU1kto3Qwkp1eolvc+GPmkKrg==
X-Received: by 2002:a6b:ef0e:: with SMTP id k14mr6117594ioh.131.1602167493818;
        Thu, 08 Oct 2020 07:31:33 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r16sm2763624iln.58.2020.10.08.07.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:31:33 -0700 (PDT)
Subject: Re: [PATCH 3/6] kernel: split syscall restart from signal handling
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-4-axboe@kernel.dk> <20201008142135.GH9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de00f13d-9ff0-6955-5d37-557f044ce2aa@kernel.dk>
Date:   Thu, 8 Oct 2020 08:31:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008142135.GH9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 8:21 AM, Oleg Nesterov wrote:
> On 10/05, Jens Axboe wrote:
>>
>> Move the restart syscall logic into a separate generic entry helper,
>> and handle that part separately from signal checking and delivery.
>>
>> This is in preparation for being able to do syscall restarting
>> independently from handling signals.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  arch/x86/kernel/signal.c     | 32 ++++++++++++++++++--------------
>>  include/linux/entry-common.h | 14 ++++++++++++--
>>  kernel/entry/common.c        | 11 ++++++++---
>>  3 files changed, 38 insertions(+), 19 deletions(-)
> 
> Can't we avoid this patch and the and simplify the change in
> exit_to_user_mode_loop() from the next patch? Can't the much more simple
> patch below work?
> 
> Then later we can even change arch_do_signal() to accept the additional
> argument, ti_work, so that it can use ti_work & TIF_NOTIFY_SIGNAL/SIGPENDING
> instead of test_thread_flag/task_sigpending.

Yeah I guess that would be a bit simpler, maybe I'm too focused on
decoupling the two. But if we go this route, and avoid sighand->lock for
just having TIF_NOTIFY_SIGNAL set, then that should be functionally
equivalent as far as I'm concerned.

I'll make the reduction, I'd prefer to keep this as small/simple as
possible initially.

-- 
Jens Axboe

