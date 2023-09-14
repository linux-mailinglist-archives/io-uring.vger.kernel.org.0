Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DBC7A0649
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 15:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbjINNmI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbjINNmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 09:42:06 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FFA1FE7;
        Thu, 14 Sep 2023 06:42:02 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99c1d03e124so126899866b.2;
        Thu, 14 Sep 2023 06:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694698920; x=1695303720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3AnNEBsec3afCGlq3dUBzEeyBfYmC/hjtLTOZ5dx1hU=;
        b=kEcIR9Hkx7QWpnd0SpNo4sk4lz0A5VzuM9pEoUXckkiI909zmjMgQfbY2QyysSwhHL
         QZHcUTqpzFUdScryrtchlW5BFygmDB8mZQtkPd73mLMu/O2+3qZrr41OUCUtAKgNVq5t
         rHa/aWdKRCqCUa+E8XULxIhSxe3a5cznc2ABPFjRr+a1aY8tTV3+BqPQSihf+hXPlX2B
         0o6bwMAMGlCqs+h54B+JPL+zJP+XRpDJH+3jt6qUBcKTYZAfLF79TbKyB6efppyDpSw2
         bfTJAhljMmluMdDNtAjd7n8o5AJKOF+19tuIg/9pWkpr38VVqDB0xNqor9ZOe4rJA7AY
         F0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694698920; x=1695303720;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3AnNEBsec3afCGlq3dUBzEeyBfYmC/hjtLTOZ5dx1hU=;
        b=mJjJ2R32mmkyc7C5R+gpp1uXztltDk0OWeZZVQHrz4vH1Lh4k8+NFLLnA64IiSUKRV
         y91YYzxZy//ri5EM9PzO4HzZfGZVxT72C2sfiU7JW92foHEjasI+Ki7x6RqXbYzlMW3c
         avJxsqYB0Ag/YAp/ajGFyNPqu88tXIa+qIgwfiLsQCbwh4QYpBm2KuV2ktxkVEZyAEl6
         7dpmPZkkDf0Hu1yEY25pmmvxhff52vf6rpt9wruenw3nwSP5PiEn8bDMtTrwIHJXB9gT
         KCzM60Q5lnuuwkoYtHsKumjGrnFthxiRj++eD6wJohv5v9+x3SrszRD0HUU0PZdWm899
         vieQ==
X-Gm-Message-State: AOJu0YxS5UaBs38Wm84Z8WNf76/7evD6nDAZOJCYpuBrsXvHJcKgagu7
        3tIMXsncF/+IweH8pZmS1GKyOcsr8CE=
X-Google-Smtp-Source: AGHT+IGM61deCcOC+bIxnxFa50Za11fr0N790uEEcHkMnb5DbWdz2MLz8KAN78R/3isAOi0g7mxSDg==
X-Received: by 2002:a17:906:76d3:b0:9a1:abae:8d30 with SMTP id q19-20020a17090676d300b009a1abae8d30mr4931014ejn.47.1694698919994;
        Thu, 14 Sep 2023 06:41:59 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id lg13-20020a170906f88d00b009ad88839665sm1044972ejb.70.2023.09.14.06.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:41:59 -0700 (PDT)
Message-ID: <2ce1374c-c400-17c1-767d-dcc010b3be08@gmail.com>
Date:   Thu, 14 Sep 2023 14:39:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in
 io_wq_activate_free_worker / io_wq_worker_running
Content-Language: en-US
To:     Marco Elver <elver@google.com>
Cc:     syzbot <syzbot+a36975231499dc24df44@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000fc6ba706053be013@google.com>
 <4e400095-7205-883b-c8fd-4aa95a1b6423@gmail.com>
 <CANpmjNPY7eD100LNcRJLocprTBuZrZ48hH6FPjMzhPSe6UMy0A@mail.gmail.com>
 <df1fbf71-f50d-c523-c9b2-e0f6ea011d61@gmail.com>
 <CANpmjNOL_YauUAxB_uEP-kHOJ5TyFOnZF26f5UhsLaq75mkKnA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CANpmjNOL_YauUAxB_uEP-kHOJ5TyFOnZF26f5UhsLaq75mkKnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/23 14:25, Marco Elver wrote:
> On Thu, 14 Sept 2023 at 15:11, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 9/13/23 14:07, Marco Elver wrote:
>>> On Wed, 13 Sept 2023 at 14:13, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 9/13/23 12:29, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
>>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>
>>>>> Downloadable assets:
>>>>> disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz
>>>>>
>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>> Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com
>>>>>
>>>>> ==================================================================
>>>>> BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
>>>>>
>>>>> write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
>>>>>     io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
>>>>>     schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
>>>>>     io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
>>>>>     ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
>>>>>     ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>>>>>
>>>>> read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
>>>>>     io_wq_get_acct io_uring/io-wq.c:168 [inline]
>>>>>     io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
>>>>>     io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914
>>>>
>>>> 1) the worst case scenario we'll choose a wrong type of
>>>> worker, which is inconsequential.
>>>>
>>>> 2) we're changing the IO_WORKER_F_RUNNING bit, but checking
>>>> for IO_WORKER_F_BOUND. The latter one is set at the very
>>>> beginning, it would require compiler to be super inventive
>>>> to actually hit the problem.
>>>>
>>>> I don't believe it's a problem, but it'll nice to attribute
>>>> it properly, READ_ONCE?, or split IO_WORKER_F_BOUND out into
>>>> a separate field.
>>>
>>> It's a simple bit flag set & read, I'd go for READ_ONCE() (and
>>> WRITE_ONCE() - but up to you, these bitflag sets & reads have been ok
>>> with just the READ_ONCE(), and KCSAN currently doesn't care if there's
>>> a WRITE_ONCE() or not).
>>>
>>>> value changed: 0x0000000d -> 0x0000000b
>>>
>>> This is interesting though - it says that it observed 2 bits being
>>> flipped. We don't see where IO_WORKER_F_FREE was unset though.
>>
>> __io_worker_busy() clears it, should be it. I assume syz just
>> missed another false data race with this one. After init only
>> the worker thread should be changing the flags AFAIR
> 
> The data races reported are very real, i.e. it only reports if it
> actually observes _real_ concurrency. I guess the question is if these

That's what I'm saying, I assume that syz is not completely
analytical and triggering a race is subject to execution
randomness, and races with IO_WORKER_F_FREE are harder to hit
for syzkaller.

> are benign or not. If benign, you can choose to annotate with

Yes, it is, just like the one in the report

> READ/WRITE_ONCE [1], data_race, or leave as is (ignoring this report
> should not make it re-report any time soon).
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt

-- 
Pavel Begunkov
