Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E6834AB84
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCZP3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhCZP3g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:29:36 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD39C0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:29:33 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v26so5765861iox.11
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=77VWnbkqjOeQ+Q68SYbTBjzvDSMphM8I7bFnWwC9w+g=;
        b=OEQnzqpF0Hexv8ugCa0UYyj6CoA9HrLplF0qh0DVNVcPM1CLKZpgYQwYxjII8kiorP
         m6SRbo5w7csLtzUz6VxZF/d9uHGHt3V3QvVhoy5CD5koMjHS+sfdjSpLA7ESpJiay9pA
         miqBAvjtXBnmPuwh6qSgIMC7EFkwaU3sUEynuKy69KGbPunEoFuB6rZN4frOYwXn+Jxm
         iO1ATd8ilesgG2esVCvB9Ii/kVZs+P3Wru+AYjfseTQKQvCB8B2UD+OGYaX4Fe/UTLmp
         KU7pO4etJFvZYD8snZT11YY6I2kZOrvMqbGDt6vJIn8PWY8kPeVHZc63Wm+e+GAI5jb/
         XOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=77VWnbkqjOeQ+Q68SYbTBjzvDSMphM8I7bFnWwC9w+g=;
        b=gyNV/iy41rgWu0SKL2DcckMmDEOSQNeoyZa6Qz+ED7WuxYbBUfbHRtA8mB0jqbie4I
         EgeVGAmnDzmLpfaqNvPh7yHGPSuonlj3k8PwpU9EGFP92aVxO5OS20OBeHiVWo2YSKih
         ihssfzWB0Oc74qXdsKvDfc7khSk7Zqwhe6m9VhqxP0/2F6yAwq9yr8OLOpiwNyOlNIfC
         qVXOJYEGNPxjns2bld26DY77pgJgis4pUAoCKVtx7IfJM8nlgeMKZgG6PcJfRB6llR3M
         1xwj2UKjh6eb0q4XaqGoRmA8wGPD/XKwjmJT9X98znLOSeGqjRtrHRT42WIOUicHaKk4
         55hQ==
X-Gm-Message-State: AOAM533c+Vj8t3znJARomkqZn4hS+2gG0nE+ST+tfkIixZztocYQAu9b
        u76zaBOe1eE2wo2varE3LnlD2g==
X-Google-Smtp-Source: ABdhPJy2wFPdh9LY+OZYJpFDla9njzVmShvYhV4Hb81y4LCsEbhdp1nrNiL5Zd3QB6tlocO5q7v1Pw==
X-Received: by 2002:a05:6602:1207:: with SMTP id y7mr10758082iot.23.1616772572869;
        Fri, 26 Mar 2021 08:29:32 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x20sm4537794ilc.88.2021.03.26.08.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:29:32 -0700 (PDT)
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
To:     Stefan Metzmacher <metze@samba.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
 <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
 <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <58f67a8b-166e-f19c-ccac-157153e4f17c@kernel.dk>
Date:   Fri, 26 Mar 2021 09:29:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 9:23 AM, Stefan Metzmacher wrote:
> Am 26.03.21 um 16:01 schrieb Jens Axboe:
>> On 3/26/21 7:48 AM, Oleg Nesterov wrote:
>>> Jens, sorry, I got lost :/
>>
>> Let's bring you back in :-)
>>
>>> On 03/25, Jens Axboe wrote:
>>>>
>>>> With IO threads accepting signals, including SIGSTOP,
>>>
>>> where can I find this change? Looks like I wasn't cc'ed...
>>
>> It's this very series.
>>
>>>> unmask the
>>>> SIGSTOP signal from the default blocked mask.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  kernel/fork.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>> index d3171e8e88e5..d5a40552910f 100644
>>>> --- a/kernel/fork.c
>>>> +++ b/kernel/fork.c
>>>> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>>>>  	tsk = copy_process(NULL, 0, node, &args);
>>>>  	if (!IS_ERR(tsk)) {
>>>>  		sigfillset(&tsk->blocked);
>>>> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
>>>> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
>>>
>>> siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.
>>
>> Ah thanks.
>>
>>> To remind, either way this is racy and can't really help.
>>>
>>> And if "IO threads accepting signals" then I don't understand why. Sorry,
>>> I must have missed something.
>>
>> I do think the above is a no-op at this point, and we can probably just
>> kill it. Let me double check, hopefully we can just remove this blocked
>> part.
> 
> Is this really correct to drop in your "kernel: stop masking signals in create_io_thread()"
> commit?
> 
> I don't assume signals wanted by userspace should potentially handled in an io_thread...
> e.g. things set with fcntl(fd, F_SETSIG,) used together with F_SETLEASE?

I guess we do actually need it, if we're not fiddling with
wants_signal() for them. To quell Oleg's concerns, we can just move it
to post dup_task_struct(), that should eliminate any race concerns
there.

-- 
Jens Axboe

