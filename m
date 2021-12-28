Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32B84808C6
	for <lists+io-uring@lfdr.de>; Tue, 28 Dec 2021 12:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhL1L0c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Dec 2021 06:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhL1L0b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Dec 2021 06:26:31 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79869C061574;
        Tue, 28 Dec 2021 03:26:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a9so37692126wrr.8;
        Tue, 28 Dec 2021 03:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OKkueDwCwEF+cqPVoTURbXkr2Ps39czU8l1nd/tBauI=;
        b=S7UiqpAigrV/OO8Qr159GCBG27b7VonKIbjlvQ0H/VkuUJhQ9iuOpDSiC/arydO3XJ
         02Efj8RZ7FirsvLNwwe+62DWzTpE7lJlvK8G1qS4CAJDMMLdXuotwWi/8UtEPsUmp1Nr
         WxccogvNbQnS6dTgePAAzWi/e4a60VxOGHt7bFdbKJa6+lMMQib6y+oPwV2ZWWmdqL/l
         p5pGW7na1DgkDXKWWwObItmERJDbk4Rkxz2va/YKnribdiZHIcOUFhM1Zb6YRW3QfkMI
         YMU7b1QxTh+N57c642G1FtkNHKp9TQSXSQWVnmTSKmMyrkOnbDCknc/v91/m49ccJ1nf
         Bp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OKkueDwCwEF+cqPVoTURbXkr2Ps39czU8l1nd/tBauI=;
        b=Nq4EzUnBxmqTDSfFzux4BxQ2Lyt32N8Nzldu44KFVqA+9kSuOtGMnr4kMhralD2Noe
         Bl4NZT65bbV49uQTahitl1hIJWdkpJRT9AdLEOfn/qraCnzkQWaOjt02q8CAR4OnylEU
         2NTlQSpS02WwQGBHgZ0Bcvyi1k3IEYI8wS3GpPAKjOIvUcGXa2pqCfdHN66BxHuWANYF
         z9gF5DbBzAnMjRlq+MK0eOf23N0UqcntS0Go9SB/rq3GNNsDxP0DaYpHhE4qfd34420x
         TMCpFh9l4DOuHz7HfHCtvQr8EK2nckAAB+YjWNS3xid5gHorRrwZ7daQxI8iFCzGZhqM
         d7CA==
X-Gm-Message-State: AOAM530jFFHEmWQmGUTJ8cTfU0Oo15kingmWhK2NgrIymKhz55/q4Ni6
        OrcRuWw4Z4JI2LrWD5I4888=
X-Google-Smtp-Source: ABdhPJw9WReDcdp9vGFm+WMi0sI9xKTeumWkHdL06/dGDZKguTbonGLcSFSZfptU12FAghZrJBYd+g==
X-Received: by 2002:a5d:64cc:: with SMTP id f12mr15934549wri.145.1640690790066;
        Tue, 28 Dec 2021 03:26:30 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.140])
        by smtp.gmail.com with ESMTPSA id m17sm22195431wmq.31.2021.12.28.03.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 03:26:29 -0800 (PST)
Message-ID: <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
Date:   Tue, 28 Dec 2021 11:24:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
 <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
 <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
 <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/24/21 19:52, Eric W. Biederman wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
[...]
>> FWIW, I worked it around in io_uring back then by breaking the
>> dependency.
> 
> I am in the middle of untangling the dependencies between ptrace,
> coredump, signal handling and maybe a few related things.

Sounds great

> Do folks have a reproducer I can look at?  Pavel especially if you have
> something that reproduces on the current kernels.

A syz reproducer was triggering it reliably, I'd try to revert the
commit below and test:
https://syzkaller.appspot.com/text?tag=ReproC&x=15d3600cb00000

It should hung a task. Syzbot report for reference:
https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e


commit 1d5f5ea7cb7d15b9fb1cc82673ebb054f02cd7d2
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Oct 29 13:11:33 2021 +0100

     io-wq: remove worker to owner tw dependency

     INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
           Not tainted 5.15.0-rc5-syzkaller #0
     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
     Call Trace:
      context_switch kernel/sched/core.c:4940 [inline]
      __schedule+0xb44/0x5960 kernel/sched/core.c:6287
      schedule+0xd3/0x270 kernel/sched/core.c:6366
      schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
      do_wait_for_common kernel/sched/completion.c:85 [inline]
      __wait_for_common kernel/sched/completion.c:106 [inline]
      wait_for_common kernel/sched/completion.c:117 [inline]
      wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
      io_worker_exit fs/io-wq.c:183 [inline]
      io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
      ...

> As part of that I am in the process of guaranteeing all of the coredump
> work happens in get_signal so nothing of io_uring or any cleanup
> anywhere else runs until the coredump completes.
> 
> I haven't quite posted the code for review because it's the holidays.
> But I am aiming at v5.17 or possibly v5.18, as the code is just about
> ready.

-- 
Pavel Begunkov
