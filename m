Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E50934B207
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhCZWOv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCZWOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:14:50 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B2CC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:14:50 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 125-20020a4a1a830000b02901b6a144a417so1629958oof.13
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gbbaSGWQI1dnr2q05scQHcs8XmgSsnu2DZSsX9rkEi8=;
        b=1AwtqGkshgIkEFWLGZA6tJmJ3/E3mfKoGYWDyXOPzpCSauS4Q7TlVQ5gaSfAAdLRrl
         CiBhtyn0eI0Q56WwMfkxhy4Ojd5MZvmiWiadpPrWwzXUrn7WPC4ZseXOE/DYkWNClNKJ
         4bBCebbLs2Y/mUR86McWyXC1pLcWl3M464RwExUkPe9wFBEFDz0+ZLqVAz/Iwu1mAnv6
         3Mi8pP2jyNKCi3IwkPu5l8ArbSLDSVdtCmj/HItpp2sonNI89hNoT678mC7bW/yyUwdL
         7ufUVJ0kLD6ElkFycM9as1kM3h/KZ23OCwcUi9r61tNmiwkAjUvtvEugIAuUpGmwg7WK
         BE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gbbaSGWQI1dnr2q05scQHcs8XmgSsnu2DZSsX9rkEi8=;
        b=NMu7ekyJXO/iaPsmwb2jlqPAqTEQ1bJ7YneK0TnXuWS6rvXmGHbYbnE9qnfcT60gdg
         /JbueFpnasp/TFM4R3DaniwFtaLzdXgS3UB8rlOJe4zVPCC+dEoB0pcHOwGC2VDlbYcl
         rq8l4BoZoxA1AIddxKzpv21d695BIexjBF5usOszEEeZWKHeT62gRwfmSTFpHcgVUGNM
         hOSwaUXRGfYLK0o+Tb/xW43Kx1jLNmlIvxis0q6GwRHmjfmOOc3a6Wb0p35KvnseRuCQ
         YhBV/LSomw2NC6W9W0qKfUfJVxuWVjukle0PCixSItxNa1VzelOOYEs5nAEdV8nCTscn
         rmUw==
X-Gm-Message-State: AOAM531B8nzfyCQ6i/Iub22z+E3lt5TchA9D0+m0puS2ggE+gXyGOTm2
        UdIGDMUJzNtWCLz1KFhXoOM9iw==
X-Google-Smtp-Source: ABdhPJy1a1jZjihdkJMQQ6cs0GrdtABV5sPoJd8izmGPvImmrTeAhO/1UuT+puDyPVE/eCG66kXq2g==
X-Received: by 2002:a4a:d48b:: with SMTP id o11mr12774991oos.2.1616796889782;
        Fri, 26 Mar 2021 15:14:49 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id c12sm958644oou.26.2021.03.26.15.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:14:49 -0700 (PDT)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal
 thread
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-3-axboe@kernel.dk> <m1wntty7yn.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
Date:   Fri, 26 Mar 2021 16:14:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1wntty7yn.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 2:29 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> We go through various hoops to disallow signals for the IO threads, but
>> there's really no reason why we cannot just allow them. The IO threads
>> never return to userspace like a normal thread, and hence don't go through
>> normal signal processing. Instead, just check for a pending signal as part
>> of the work loop, and call get_signal() to handle it for us if anything
>> is pending.
>>
>> With that, we can support receiving signals, including special ones like
>> SIGSTOP.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io-wq.c    | 24 +++++++++++++++++-------
>>  fs/io_uring.c | 12 ++++++++----
>>  2 files changed, 25 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index b7c1fa932cb3..3e2f059a1737 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -16,7 +16,6 @@
>>  #include <linux/rculist_nulls.h>
>>  #include <linux/cpu.h>
>>  #include <linux/tracehook.h>
>> -#include <linux/freezer.h>
>>  
>>  #include "../kernel/sched/sched.h"
>>  #include "io-wq.h"
>> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>>  		if (io_flush_signals())
>>  			continue;
>>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>> -		if (try_to_freeze() || ret)
>> +		if (signal_pending(current)) {
>> +			struct ksignal ksig;
>> +
>> +			if (fatal_signal_pending(current))
>> +				break;
>> +			if (get_signal(&ksig))
>> +				continue;
>                         ^^^^^^^^^^^^^^^^^^^^^^
> 
> That is wrong.  You are promising to deliver a signal to signal
> handler and them simply discarding it.  Perhaps:
> 
> 			if (!get_signal(&ksig))
>                         	continue;
> 			WARN_ON(!sig_kernel_stop(ksig->sig));
>                         break;

Thanks, updated.

-- 
Jens Axboe

