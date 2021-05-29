Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E90D394C32
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 14:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE2McU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 08:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2McU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 08:32:20 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26859C061574;
        Sat, 29 May 2021 05:30:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r10so5839849wrj.11;
        Sat, 29 May 2021 05:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pMPRFMOuX1S89zAsds2EsZdaJitjmQv9CpOdt5WE62Q=;
        b=n5EQefLhrZ+Afr1G8DiDRslG95cp1VRPNpzYUtFeiqbDnB7IhwbF4lwma3r3Zlt1Zo
         FWoxv619QG0WL6AapGcTmvzzd72cObU/uB45Do7pTDuBrII+W5ZMCqY+6/14e7wGgpwA
         fbZlzK42R48S4ElVTFrSSSyseumPvzhcroHHYsVJvqs3Hkt5A3d+gmJGAGcfYYH6KtuJ
         srwRVIejWO2b9tdU4U4I4/8VLcAh1/Phkq0GwymNqlnpUoCKw+gkSgHhzwoFL2We1975
         BY2XIIlbua2zv0LlOQKeLNxfP/6i+wnO4rvL9OZpyydRvM4+V0RcS6hGlMBU547r0NnN
         rkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pMPRFMOuX1S89zAsds2EsZdaJitjmQv9CpOdt5WE62Q=;
        b=Mt0uyPkBAKk+8ipJ64CNDBL+6S1xeI53vZK8lXK+NGg7VKVXqJjS6jJQV2Efhpc0o7
         Szt4zA6pie1k9Eym87ZaiBmQI8VIqG2SOL7+27kBLm/hv2/NsiPj4SVyiD15o1LPypIt
         Gs08QO5KIU3w5H6nR1cV6xDUl51myaF3Ip43wWCzEL6u3YMzuzmug3nqbGh1boXIVEAx
         n3e4rVp3mV+qP3hO0YwF9lWfCa04uaeBLgQALFVCL8c2QvwwdJtemL/O0gHW0WCl1r/y
         VC7ZRdgbkGvRlq0lRnLu8lJXdvsRx+ZeZOGAfsHyHL0YjzBxEmcOyGhfzQHX6me0i1uz
         pH2g==
X-Gm-Message-State: AOAM5334/2MWK4A1hmTCIBqSbNiqpS8HAuzTB9pRuOCBO4LXi6g1CrRd
        zEsUwdznB4lAiXCngyHrm+Zd9VWmOr0=
X-Google-Smtp-Source: ABdhPJzFZ6M5kbZK8tQnnbUxl/+dzM74vM1rwcwyHQrVECYZLUxGxvzdOBCeHsNoc3FbT0fytMsd2Q==
X-Received: by 2002:adf:fa46:: with SMTP id y6mr5098661wrr.194.1622291440090;
        Sat, 29 May 2021 05:30:40 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id z135sm3929333wmc.26.2021.05.29.05.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 05:30:39 -0700 (PDT)
To:     Steven Rostedt <rostedt@goodmis.org>,
        Olivier Langlois <olivier@trillion01.com>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
 <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
 <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
 <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
 <20210528184248.46926090@gandalf.local.home>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
Message-ID: <6fd74635-d3a8-7319-bcc6-c2c1de9c87ee@gmail.com>
Date:   Sat, 29 May 2021 13:30:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210528184248.46926090@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/21 11:42 PM, Steven Rostedt wrote:
> On Wed, 26 May 2021 12:18:37 -0400
> Olivier Langlois <olivier@trillion01.com> wrote:
> 
>>> If that gets changed, could be also include the personality id and
>>> flags here,
>>> and maybe also translated the opcode and flags to human readable
>>> strings?
>>>   
>> If Jens and Pavel agrees that they would like to see this info in the
>> traces, I have no objection adding it.
>>
>> Still waiting input from Steven Rostedt which I believe is the trace
>> system maintainer concerning the hash-ptr situation.
>>
>> I did receive an auto-respond from him saying that he was in vacation
>> until May 28th...
> 
> Yep, I'm back now.
> 
> Here's how it works using your patch as an example:
> 
>>  	TP_fast_assign(
>>  		__entry->ctx		= ctx;
>> +		__entry->req		= req;
> 
> The "__entry" is a structure defined by TP_STRUCT__entry() that is located
> on the ring buffer that can be read directly by user space (aka trace-cmd).
> So yes, that value is never hashed, and one of the reasons that tracefs
> requires root privilege to read it.
> 
>>  		__entry->opcode		= opcode;
>>  		__entry->user_data	= user_data;
>>  		__entry->force_nonblock	= force_nonblock;
>>  		__entry->sq_thread	= sq_thread;
>>  	),
>>  
>> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
>> -			  __entry->ctx, __entry->opcode,
>> -			  (unsigned long long) __entry->user_data,
>> -			  __entry->force_nonblock, __entry->sq_thread)
>> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, non block %d, "
>> +		  "sq_thread %d",  __entry->ctx, __entry->req,
>> +		  __entry->opcode, (unsigned long long)__entry->user_data,
>> +		  __entry->force_nonblock, __entry->sq_thread)
>>  );
> 
> The TP_printk() macro *is* used when reading the "trace" or "trace_pipe"
> file, and that uses vsnprintf() to process it. Which will hash the values
> for %p (by default, because that's what it always did when vsnprintf()
> started hashing values).
> 
> Masami Hiramatsu added the hash-ptr option (which I told him to be the
> default as that was the behavior before that option was created), where the
> use could turn off the hashing.
> 
> There's lots of trace events that expose the raw pointers when hash-ptr is
> off or if the ring buffers are read via the trace_pip_raw interface.
> 
> What's special about these pointers to hash them before they are recorded?

io_uring offers all different operations and has internal request/memory
recycling, so it may be an easy vector of attack in case of some
vulnerabilities found, but nothing special. As that's the status quo,
I wouldn't care, let's put aside my concerns and print them raw.

-- 
Pavel Begunkov
