Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E89349BF5
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhCYVuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 17:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhCYVuO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 17:50:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A18C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 14:50:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1507953pjv.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 14:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WQol3I8KDADeHPFfgCWBy9/yOmLYynHOdYXdfaAWvrI=;
        b=eFmiQKcrCQ2pUVCzc1+fSr2A17ZRi0O4dsrJoyFpidImI1SHtbGT/9T9KLUbcgwFcN
         xWgL6omSsunAmIbhxOfZdPWkpQNtApo3k2oaaKT0KwubLXKrDgFhervwjtH18OsaLDwL
         1AajzvU0b6nR0zW9ymqbXJnWc3qtXbJuS8s4CzpkiIjG9jE279WVHjOB6z/TRl+80n1/
         iwohZPPvhPLi6jJTxtBiiLL97fAajFhJpNHOTK0/KOXHtngS87+r3LijijqL0dYFPhWs
         /EYl66jklev7oTR0LA21aIqkSyIxlSz4vzVmX5FaoXdx7XEh3wH6HvQ836D9SrFH2aj/
         fgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQol3I8KDADeHPFfgCWBy9/yOmLYynHOdYXdfaAWvrI=;
        b=H2dblVVsN1iwDDyb1Tl0BAW+/grexgL2dDNX5Z+1IRVGIVTxFWpkAOaH+1wXWyGXdL
         EqTUvsSPJNawzoEQnz0kMaCxsqF+Qa3m/tcOh3OZlvIY1c89/a9BImCjMXHW+6Ev9mWH
         qjNhWrcrg1KvtOPCMzIbRs5dM1ipdxnvNtZepWTAXwgHy8xuKMH7zF/rNvU0r/k/NI4p
         FUHHn63Uj+xFV+COR1g6GSuQ6AzpI9jspIb0S0/d+zBDVW7EJgD4ANosAMWwgzyMaK/e
         J4bzYkdET2D9BB/zpq7F+5zlG6b7smMcD48N8a6awnl5ho1JlBQwNY5Cezrc4PNym7S2
         HU/w==
X-Gm-Message-State: AOAM533SHn6gDcx0G9a9jAVIg4JKgwb02IwvhChfgwlgLA8LyEmZXStA
        qtjqJUvbQYyHduylVNg7bHdk6g==
X-Google-Smtp-Source: ABdhPJx7X7qF/yOL5uQuAzpudvBQn+JkZC0b7vSMxL7ADW2s9dxvNKJ5YlWR6JFHov9NKVHfZQRCyg==
X-Received: by 2002:a17:90b:d85:: with SMTP id bg5mr10558372pjb.230.1616709013104;
        Thu, 25 Mar 2021 14:50:13 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t22sm6514889pjw.54.2021.03.25.14.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 14:50:12 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <m1lfab0xs9.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0f24896f-eef5-508f-8177-a6b5abf59cc6@kernel.dk>
Date:   Thu, 25 Mar 2021 15:50:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1lfab0xs9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 2:43 PM, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> On Thu, Mar 25, 2021 at 12:42 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> I don't know what the gdb logic is, but maybe there's some other
>>>> option that makes gdb not react to them?
>>>
>>> .. maybe we could have a different name for them under the task/
>>> subdirectory, for example (not  just the pid)? Although that probably
>>> messes up 'ps' too..
>>
>> Actually, maybe the right model is to simply make all the io threads
>> take signals, and get rid of all the special cases.
>>
>> Sure, the signals will never be delivered to user space, but if we
>>
>>  - just made the thread loop do "get_signal()" when there are pending signals
>>
>>  - allowed ptrace_attach on them
>>
>> they'd look pretty much like regular threads that just never do the
>> user-space part of signal handling.
>>
>> The whole "signals are very special for IO threads" thing has caused
>> so many problems, that maybe the solution is simply to _not_ make them
>> special?
> 
> The special case in check_kill_permission is certainly unnecessary.
> Having the signal blocked is enough to prevent signal_pending() from
> being true. 
> 
> 
> The most straight forward thing I can see is to allow ptrace_attach and
> to modify ptrace_check_attach to always return -ESRCH for io workers
> unless ignore_state is set causing none of the other ptrace operations
> to work.
> 
> That is what a long running in-kernel thread would do today so
> user-space aka gdb may actually cope with it.
> 
> 
> We might be able to support if io workers start supporting SIGSTOP but I
> am not at all certain.

See patch just send out as a POC, mostly, not fully sanitized yet. But
I did try to return -ESRCH from ptrace_check_attach() if it's an IO
thread and ignore_state isn't set:

if (!ignore_state && child->flags & PF_IO_WORKER)
	return -ESRCH;

and that causes gdb to abort at that thread. For the same test case
as in the previous email, you get:

Attaching to process 358
[New LWP 359]
[New LWP 360]
[New LWP 361]
Couldn't get CS register: No such process.
(gdb) 0x00007ffa58537125 in ?? ()

(gdb) bt
#0  0x00007ffa58537125 in ?? ()
#1  0x0000000000000000 in ?? ()
(gdb) info threads
  Id   Target Id             Frame 
* 1    LWP 358 "io_uring"    0x00007ffa58537125 in ?? ()
  2    LWP 359 "iou-mgr-358" Couldn't get registers: No such process.
(gdb) q
A debugging session is active.

	Inferior 1 [process 358] will be detached.

Quit anyway? (y or n) y
Couldn't write debug register: No such process.

where 360 here is a regular pthread created thread, and 361 is another
iou-mgr-x task. While gdb behaves better in this case, it does still
prevent you from inspecting thread 3 which would be totally valid.

-- 
Jens Axboe

