Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8673394C37
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 14:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhE2MgO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 08:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2MgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 08:36:12 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94AFC061574;
        Sat, 29 May 2021 05:34:32 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id z137-20020a1c7e8f0000b02901774f2a7dc4so7853816wmc.0;
        Sat, 29 May 2021 05:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3FYpwpZdT27V0UXnwECKImopls1luW46Yv6jOC96tCw=;
        b=G5SfrkrykmEOwni6svyqp3ckzbMOl5jrS7NcxVnuDiwFadLWxqcs7yeJJjqHnGg0pp
         a+pjN8A/k6zp6oQRNHkKluJiXvte7+FuoXndQfs9lkpCU9PwV6M6TI9c555n1KP/+HIR
         20zkFSB1s/JzPSkJaVR7UxNfPLOc/+oDQqBqwDQsK2u2mp96x1x/wwDBsnGnSgl+Jm8G
         g6l2YjQzZbEK9BcNcdrmujeOReSjaKkHxqhNKKueFbrNLEdershT576LJZbmEzAljJ3U
         bexoRcwFFNNue1FwolH9SsYMj2WW+ndzq8Di/shAwfxZEe6LSuYa2EmtMEdyvrYSZCj3
         TgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3FYpwpZdT27V0UXnwECKImopls1luW46Yv6jOC96tCw=;
        b=KJjBcIoqBwFjas0Ivrnk0/ukIaL2TF5jb8L/4tLlQsS8j/UY8AZ2FQ85mWqN/6Uyrs
         HfN7/n78LsdUd2SWjWnvYgFZRuiFLWlZkJ9QUxwAiz/HL+aMIhuNpH3EV+IeKN+S6crc
         VvjdG/nEQpW6v111y5ZU+MrNMbv7pBymXwuMtBLNoLw8xQQNT0A44ANC/rQQrFP8svKS
         xoZXP/CscQyKmjd9VZ4H/QUIlM4RJPX8kkUehnU2LWImkW5fYKMC7av68IFqqLokr0u8
         1W86TmPAUSgjCA82y2TrIHJRgsV9Ui4YP/OVBm1WTqn+4W6bHvoF7bFLAaPEzj1pCkWb
         TaUw==
X-Gm-Message-State: AOAM532d7MWXA8R9ScmW+n6RQhMB3mHe6bxfeStzX1ryTMwuHP5ojuQy
        L8Z316Jk4zTABoWb1ew+H6OXY9HxmgU=
X-Google-Smtp-Source: ABdhPJyFqFf0E9MqYT0ckM4WyiGKxrt0bNHQaibhkDZoqBugyZ0VG3vB5GUh8UdJ7kOX6us0Mg28Xg==
X-Received: by 2002:a1c:6457:: with SMTP id y84mr11910727wmb.81.1622291671115;
        Sat, 29 May 2021 05:34:31 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id n6sm8574058wmq.34.2021.05.29.05.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 05:34:30 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Pavel Begunkov <asml.silence@gmail.com>
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
 <6fd74635-d3a8-7319-bcc6-c2c1de9c87ee@gmail.com>
Message-ID: <503d26c8-232c-cae9-71f7-e47655473fb1@gmail.com>
Date:   Sat, 29 May 2021 13:34:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6fd74635-d3a8-7319-bcc6-c2c1de9c87ee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/21 1:30 PM, Pavel Begunkov wrote:
> On 5/28/21 11:42 PM, Steven Rostedt wrote:
>> On Wed, 26 May 2021 12:18:37 -0400
>> Olivier Langlois <olivier@trillion01.com> wrote:
>>
>>>> If that gets changed, could be also include the personality id and
>>>> flags here,
>>>> and maybe also translated the opcode and flags to human readable
>>>> strings?
>>>>   
>>> If Jens and Pavel agrees that they would like to see this info in the
>>> traces, I have no objection adding it.
>>>
>>> Still waiting input from Steven Rostedt which I believe is the trace
>>> system maintainer concerning the hash-ptr situation.
>>>
>>> I did receive an auto-respond from him saying that he was in vacation
>>> until May 28th...
>>
>> Yep, I'm back now.
>>
>> Here's how it works using your patch as an example:
>>
>>>  	TP_fast_assign(
>>>  		__entry->ctx		= ctx;
>>> +		__entry->req		= req;
>>
>> The "__entry" is a structure defined by TP_STRUCT__entry() that is located
>> on the ring buffer that can be read directly by user space (aka trace-cmd).
>> So yes, that value is never hashed, and one of the reasons that tracefs
>> requires root privilege to read it.
>>
>>>  		__entry->opcode		= opcode;
>>>  		__entry->user_data	= user_data;
>>>  		__entry->force_nonblock	= force_nonblock;
>>>  		__entry->sq_thread	= sq_thread;
>>>  	),
>>>  
>>> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
>>> -			  __entry->ctx, __entry->opcode,
>>> -			  (unsigned long long) __entry->user_data,
>>> -			  __entry->force_nonblock, __entry->sq_thread)
>>> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, non block %d, "
>>> +		  "sq_thread %d",  __entry->ctx, __entry->req,
>>> +		  __entry->opcode, (unsigned long long)__entry->user_data,
>>> +		  __entry->force_nonblock, __entry->sq_thread)
>>>  );
>>
>> The TP_printk() macro *is* used when reading the "trace" or "trace_pipe"
>> file, and that uses vsnprintf() to process it. Which will hash the values
>> for %p (by default, because that's what it always did when vsnprintf()
>> started hashing values).
>>
>> Masami Hiramatsu added the hash-ptr option (which I told him to be the
>> default as that was the behavior before that option was created), where the
>> use could turn off the hashing.
>>
>> There's lots of trace events that expose the raw pointers when hash-ptr is
>> off or if the ring buffers are read via the trace_pip_raw interface.
>>
>> What's special about these pointers to hash them before they are recorded?
> 
> io_uring offers all different operations and has internal request/memory
> recycling, so it may be an easy vector of attack in case of some
> vulnerabilities found, but nothing special. As that's the status quo,
> I wouldn't care, let's put aside my concerns and print them raw.

edit: not print obviously, have but have them raw in __entry

-- 
Pavel Begunkov
