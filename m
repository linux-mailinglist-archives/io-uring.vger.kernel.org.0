Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4731817C3B0
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCFRIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 12:08:16 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42868 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgCFRIQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 12:08:16 -0500
Received: by mail-io1-f68.google.com with SMTP id q128so2759460iof.9
        for <io-uring@vger.kernel.org>; Fri, 06 Mar 2020 09:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kz7F9w9m8ZO7isygce7jzuADVkhqvNGk0rHiKeOUV28=;
        b=hhZWK8fZp6R2bJvjZm23pEpYCjXEl/tKqzpidDMouyXr4lZ+/ttOlxzS+d2fVI1CAd
         NNe5rbe4pQn/syiH0qRCT2B3SuO2YlNr1kGOt7hBpTU6DQMOXPw0jfXk/eX2hUJP9pN8
         fM3rWBCs1PUa2Enu+2sYp6VVjf1XKdl/40vwGgNcjOkUkCTfXb41faAnaAdQD91hNiAj
         ydVMUkgqJjUV4icfpRXWDoTUY54reM1oXnJVos5vYQU+S/avOxxVkCrF28lmw3NKBVO4
         1BZGTvTEoNMJoS00OkujrzyMY7jbIaK70i80bL5ebuROi7tiNoRSTTVa2x7g0JW3SSHx
         JZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kz7F9w9m8ZO7isygce7jzuADVkhqvNGk0rHiKeOUV28=;
        b=r80HG6ExPz52Uby/1D18e/m3S3/3QGZleFbPHGKwUxHd6H0h44OpvDxMnmHvK/b8GG
         BCuZIKRCQO+61MSI0rHYXs3/K6E0zqV7FGSzCP1FyYi9jNXzSWnWM+8D2YVY62mJEa29
         fNK37thel4a4DMjxmSjBNsN7BQVjfoXCAXxb8LH4cio0EViI6MSHcV/WEWf4zDFI/2dt
         xxfZxP+M1ouj701YGbYZF+v2A3Tsf4+2gbRV/ZgTWkzipUDhb7d5o3rAGIkwDQ262ngr
         vm+h76dMX6mXLaKvODwQOXLbIIRYyCxnQ2715FjX3M9Qn+bch/Ti8AQCkw5w4IvQkv/z
         uizg==
X-Gm-Message-State: ANhLgQ2xarLx5BBjNQuqubhl35Xku+wE+ZFWu3+tSUtndOAf2eKHqIuB
        8qTnCn/musd/Wfbo/OAGkoI1Rg==
X-Google-Smtp-Source: ADFU+vvePiQDyDOClLaaJfWxLjUd6Wuore2UNcMCRYiANtgsUDZ0ItNn/czzA9dx6XLBxVdITYoMfA==
X-Received: by 2002:a6b:3c13:: with SMTP id k19mr3868711iob.25.1583514495003;
        Fri, 06 Mar 2020 09:08:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w16sm11673783ilq.5.2020.03.06.09.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 09:08:14 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
From:   Jens Axboe <axboe@kernel.dk>
To:     paulmck@kernel.org, Jann Horn <jannh@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        the arch/x86 maintainers <x86@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <00000000000067c6df059df7f9f5@google.com>
 <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
 <CAG48ez3DUAraFL1+agBX=1JVxzh_e2GR=UpX5JUaoyi+1gQ=6w@mail.gmail.com>
 <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
 <CAG48ez07bD4sr5hpDhUKe2g5ETk0iYb6PCWqyofPuJbXz1z+hw@mail.gmail.com>
 <20200306164443.GU2935@paulmck-ThinkPad-P72>
 <11921f78-c6f2-660b-5e33-11599c2f9a4b@kernel.dk>
Message-ID: <944a495e-8e4c-4efd-3560-565603bef3ac@kernel.dk>
Date:   Fri, 6 Mar 2020 10:08:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <11921f78-c6f2-660b-5e33-11599c2f9a4b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/20 10:00 AM, Jens Axboe wrote:
> On 3/6/20 9:44 AM, Paul E. McKenney wrote:
>> On Fri, Mar 06, 2020 at 04:36:20PM +0100, Jann Horn wrote:
>>> On Fri, Mar 6, 2020 at 4:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 3/6/20 7:57 AM, Jann Horn wrote:
>>>>> +paulmck
>>>>>
>>>>> On Wed, Mar 4, 2020 at 3:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 3/4/20 12:59 AM, Dmitry Vyukov wrote:
>>>>>>> On Fri, Feb 7, 2020 at 9:14 AM syzbot
>>>>>>> <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot found the following crash on:
>>>>>>>>
>>>>>>>> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
>>>>>>>> git tree:       upstream
>>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
>>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
>>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
>>>>>>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>>>>>>>
>>>>>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>>>>>
>>>>>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>>>>>> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com
>>>>>>>
>>>>>>> +io_uring maintainers
>>>>>>>
>>>>>>> Here is a repro:
>>>>>>> https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt
>>>>>>
>>>>>> I've queued up a fix for this:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=9875fe3dc4b8cff1f1b440fb925054a5124403c3
>>>>>
>>>>> I believe that this fix relies on call_rcu() having FIFO ordering; but
>>>>> <https://www.kernel.org/doc/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.html#Callback%20Registry>
>>>>> says:
>>>>>
>>>>> | call_rcu() normally acts only on CPU-local state[...] It simply
>>>>> enqueues the rcu_head structure on a per-CPU list,
>>
>> Indeed.  For but one example, if there was a CPU-to-CPU migration between
>> the two call_rcu() invocations, it would not be at all surprising for
>> the two callbacks to execute out of order.
>>
>>>>> Is this fix really correct?
>>>>
>>>> That's a good point, there's a potentially stronger guarantee we need
>>>> here that isn't "nobody is inside an RCU critical section", but rather
>>>> that we're depending on a previous call_rcu() to have happened. Hence I
>>>> think you are right - it'll shrink the window drastically, since the
>>>> previous callback is already queued up, but it's not a full close.
>>>>
>>>> Hmm...
>>>
>>> You could potentially hack up the semantics you want by doing a
>>> call_rcu() whose callback does another call_rcu(), or something like
>>> that - but I'd like to hear paulmck's opinion on this first.
>>
>> That would work!
>>
>> Or, alternatively, do an rcu_barrier() between the two calls to
>> call_rcu(), assuming that the use case can tolerate rcu_barrier()
>> overhead and latency.
> 
> If the nested call_rcu() works, that seems greatly preferable to needing
> the rcu_barrier(), even if that would not be a showstopper for me. The
> nested call_rcu() is just a bit odd, but with a comment it should be OK.
> 
> Incremental here I'm going to test, would just fold in of course.

Been running for a few minutes just fine, I'm going to leave the
reproducer beating on it for a few hours. But here's the folded in
final:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=fae702294a6a0774ceb3cf250be79e7fe207250a

-- 
Jens Axboe

