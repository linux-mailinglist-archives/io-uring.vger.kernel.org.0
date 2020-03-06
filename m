Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED08517C1E1
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFPed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 10:34:33 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34418 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgCFPed (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 10:34:33 -0500
Received: by mail-io1-f68.google.com with SMTP id h131so1770867iof.1
        for <io-uring@vger.kernel.org>; Fri, 06 Mar 2020 07:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i4gZAHKM5OgHpwpoUr8vvAtzzBGa02whKHhEoVE9mEM=;
        b=G9n5QPlMISshbixsE+ie6E13cNyBLXq6JKRGFjB4EP/S6Zrh0gMhC1EgqWO1uaiM9I
         nmFP2D+ghRJwsNVvev4DcCCKo4U/OO9W5LMqH9qt/4nrlcK3KfPYLN32uN/SaEuFAykQ
         ouTmEboOt7VPd5B+wOtqh90mgfJ4d4GPVkSrF9VjtdnE5O7AcPRidOQ11uwJWcXC6UOn
         tezGudUm9cWHg6X/3E9T/SpNy+JO5Rc4FMSj7NGmcPtue0uuMEBch6sE4fn4gc0pmeTY
         8fcT0U5DxWtmiohEecpi1xqc8Fp4NiWAx3cxckUL3p/bynqs1q7MuEGMqxEkKaK5R1vZ
         JiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i4gZAHKM5OgHpwpoUr8vvAtzzBGa02whKHhEoVE9mEM=;
        b=QDh/KQXwXu8S+bSeY7/xn9H74Wggyh3a1XyCIzMM+/1yBZ3RHFWzhjPBpt6XG6BLE0
         M0XyWOMQyQer6g/w+8Dq2lp3QM/S9mnsei1m/IxaU07cUu0K70ERwRedE7fgP84F9vUb
         KOBHgOkdsHYG+w7wsceFKsZV6af9JGoAQNJNMdeeVTRhF8INBMw6UR1klo6pdPOJoZKy
         FWac53uBdHoxhk6mLlJLIrN196ohh312YJXFkMei3AeMhmbcx9mXCuJlVz4gnb6b/sap
         LlT6vMrCapyQxAxyeRkOd1gjeHCUKo7x3E8BmqKyc5v+LvzZ9/8z88phaHmH/+ZXIeK8
         QMtw==
X-Gm-Message-State: ANhLgQ27kB16DaZwX9Hllz87IgQaFJw1XnxBntzfYla6w5cmwVEMhGIK
        i0D3zW6aevua69h7YStJ23b1GA==
X-Google-Smtp-Source: ADFU+vug7Cj8FKlRvlPKGAirleW76RbGogy3OvOy3tIjfeIbCVJ6CH/wBoqBqQPyQv9Ge53C1LIRCA==
X-Received: by 2002:a05:6638:e8b:: with SMTP id p11mr3464609jas.11.1583508870767;
        Fri, 06 Mar 2020 07:34:30 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l17sm11448757ilc.49.2020.03.06.07.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 07:34:30 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
To:     Jann Horn <jannh@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
Date:   Fri, 6 Mar 2020 08:34:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3DUAraFL1+agBX=1JVxzh_e2GR=UpX5JUaoyi+1gQ=6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/20 7:57 AM, Jann Horn wrote:
> +paulmck
> 
> On Wed, Mar 4, 2020 at 3:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 3/4/20 12:59 AM, Dmitry Vyukov wrote:
>>> On Fri, Feb 7, 2020 at 9:14 AM syzbot
>>> <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
>>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>>>
>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com
>>>
>>> +io_uring maintainers
>>>
>>> Here is a repro:
>>> https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt
>>
>> I've queued up a fix for this:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=9875fe3dc4b8cff1f1b440fb925054a5124403c3
> 
> I believe that this fix relies on call_rcu() having FIFO ordering; but
> <https://www.kernel.org/doc/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.html#Callback%20Registry>
> says:
> 
> | call_rcu() normally acts only on CPU-local state[...] It simply
> enqueues the rcu_head structure on a per-CPU list,
> 
> Is this fix really correct?

That's a good point, there's a potentially stronger guarantee we need
here that isn't "nobody is inside an RCU critical section", but rather
that we're depending on a previous call_rcu() to have happened. Hence I
think you are right - it'll shrink the window drastically, since the
previous callback is already queued up, but it's not a full close.

Hmm...

-- 
Jens Axboe

