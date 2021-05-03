Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86283713BD
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 12:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhECKq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 06:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhECKq2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 06:46:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BFCC06174A;
        Mon,  3 May 2021 03:45:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n2so5064231wrm.0;
        Mon, 03 May 2021 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CIFshGooUaaV2myZRcB/yBy/Ci9EHmfy/WmpGw13goE=;
        b=mip3Qf0U2lZUELW2ocfz6r8j+/8sAYud/ndpff7RbzAX7QhkPPb0636WUFNp/oHTma
         7zLIh+s49IjrHp8hQKvvBTPJL4wpTsXBOX62OZ1agy2sR9IIJBacXC4O0VqQ7ReMS+WS
         7xXv7mt8O/wbV6qNv4P7WXsJbJ9o30KpBPBzLyU+QD8QPeTP+QmGHBZAser1iPTubpBU
         0bmbN05AW/ns/fkBGWbM4/p8puw7Uro7RtRwwAzNVCKeoTsQGnqd6alGKClBxu68iGy4
         2ceUUmp2Ta0T/BBSDujFYTJ3LbHm4kzph6CrvKWf5/IephQ8HBRvBPd8XkqZOeY27fk1
         J9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CIFshGooUaaV2myZRcB/yBy/Ci9EHmfy/WmpGw13goE=;
        b=LCmDoyATfVGRYRep358KyDNJrxticXFPpoLxmTJvqzYmzERumgj/knu8+JWLUcFh6k
         TFmnAUzW8qvvI/NThZq1UeuFZsK3RkzuD3T3ZMIDFLmbwDA+2kdQiFtG/aSlwI55n65j
         JQWqN3ktckDe+VMkWkfJx5h1+e2Vr/6EArg1S0wr76bzW6i4yq/lI+aVtbTZMTfu1Y0Y
         DB9XEYNAvLvhnjGBJoWBadGubm2xCBmKgg2AwAXB6x/JNeSpBvJhIMvep3IqnYUH4Cyy
         WwZWIo4opBC21zp3yDBq+YiBLpcpgJoN02KrRSNkRyOWrIIes0wrWigZqOfDK4heVdEu
         lmWg==
X-Gm-Message-State: AOAM531N8JF7qzE2++BUTNSp0cJUtRK3Nf7m5LaGKJv/amXLQtQ5UfvB
        XgTL1PoCMuQrs0lpZCpK6h8=
X-Google-Smtp-Source: ABdhPJwM/U7znsng8urh2Ji7fU0M55EqgIsxWVGnWn22C7rTr9N8VvO2lAnLmup/ZsvG1v2sxmPwug==
X-Received: by 2002:a05:6000:1863:: with SMTP id d3mr8852476wri.126.1620038732261;
        Mon, 03 May 2021 03:45:32 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id p10sm12511600wre.84.2021.05.03.03.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 03:45:31 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
References: <0000000000000c97e505bdd1d60e@google.com>
 <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com>
 <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <d5844c03-fa61-d256-be0d-b40446414299@gmail.com>
 <CAGyP=7e-3QtS-Z3KoAyFAbvm4y+9=725WR_+PyADYDi8HYxMXA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <af911546-72e4-5525-6b31-1ad1f555799e@gmail.com>
Date:   Mon, 3 May 2021 11:45:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7e-3QtS-Z3KoAyFAbvm4y+9=725WR_+PyADYDi8HYxMXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/21 5:41 AM, Palash Oswal wrote:
> On Mon, May 3, 2021 at 3:42 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> The test might be very useful. Would you send a patch to
>> liburing? Or mind the repro being taken as a test?
> 
> Pavel,
> 
> I'm working on a PR for liburing with this test. Do you know how I can

Perfect, thanks

> address this behavior?

As the hang is sqpoll cancellations, it's most probably
fixed in 5.13 + again awaits to be taken for stable.

Don't know about segfaults, but it was so for long, and
syz reproducers are ofthen faults for me, and exit with 0
in the end. So, I wouldn't worry about it.

> root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
> Running test sqp[   15.310997] Running test sqpoll-cancel-hang:
> oll-cancel-hang:
> [   15.333348] sqpoll-cancel-h[305]: segfault at 0 ip 000055ad00e265e3 sp]
> [   15.334940] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03 46
> All tests passed
> 
> root@syzkaller:~/liburing/test# ./sqpoll-cancel-hang
> [   13.572639] sqpoll-cancel-h[298]: segfault at 0 ip 00005634c4a455e3 sp]
> [   13.576506] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03 46
> [   23.350459] random: crng init done
> [   23.352837] random: 7 urandom warning(s) missed due to ratelimiting
> [  243.090865] INFO: task iou-sqp-298:299 blocked for more than 120 secon.
> [  243.095187]       Not tainted 5.12.0 #142
> [  243.099800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable.
> [  243.105928] task:iou-sqp-298     state:D stack:    0 pid:  299 ppid:  4
> [  243.111044] Call Trace:
> [  243.112855]  __schedule+0xb1d/0x1130
> [  243.115549]  ? __sched_text_start+0x8/0x8
> [  243.118328]  ? io_wq_worker_sleeping+0x145/0x500
> [  243.121790]  schedule+0x131/0x1c0
> [  243.123698]  io_uring_cancel_sqpoll+0x288/0x350
> [  243.125977]  ? io_sq_thread_unpark+0xd0/0xd0
> [  243.128966]  ? mutex_lock+0xbb/0x130
> [  243.132572]  ? init_wait_entry+0xe0/0xe0
> [  243.135429]  ? wait_for_completion_killable_timeout+0x20/0x20
> [  243.138303]  io_sq_thread+0x174c/0x18c0
> [  243.140162]  ? io_rsrc_put_work+0x380/0x380
> [  243.141613]  ? init_wait_entry+0xe0/0xe0
> [  243.143686]  ? _raw_spin_lock_irq+0xa5/0x180
> [  243.145619]  ? _raw_spin_lock_irqsave+0x190/0x190
> [  243.147671]  ? calculate_sigpending+0x6b/0xa0
> [  243.149036]  ? io_rsrc_put_work+0x380/0x380
> [  243.150694]  ret_from_fork+0x22/0x30
> 
> Palash
> 

-- 
Pavel Begunkov
