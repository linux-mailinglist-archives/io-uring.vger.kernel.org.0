Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38566370B19
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 12:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhEBKe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 06:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhEBKe6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 06:34:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4058C06174A;
        Sun,  2 May 2021 03:34:06 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so4108163wmq.1;
        Sun, 02 May 2021 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vX3Dh54TACjc7hpqnVwn0ERaoUoL5d3ElTKH1eHs/Dc=;
        b=VKJ/JT96xR7eU6Rz0lsQ/7osA6Y2Vc5J29ekRhi/CQg0Hgan1VbqKiKazy95OAGXyh
         fJ4pOesq88yy02CQboO1Nrn84k/ZqxkJGgTaQNKkgHaUB6HS6Z8GbTvg0PNyTVXzOeyk
         acfnynFT4lInoS9wfwY20YHLpsSiiTLkU0Vo0bpDzIFHtEmSQRpNbNXiK/jXEq1zf/pK
         Q5Ov5IHM4W6rSvWijmdgRbtM/sH1yJTYiW4edDTWMlt0DU3iYidDp+8St4HB06TuXJsD
         JiEfa5o8jBqQTECIdPDcbhqQSPIoRJG6JzqQRst7AGEIn9agVVTgsbk8N+ryPFMg93/l
         YjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vX3Dh54TACjc7hpqnVwn0ERaoUoL5d3ElTKH1eHs/Dc=;
        b=gjuL2++THz9HI7Y+SpWHQ9Mdr0jNM8yWhBVx8RPsnHWhlh9M41yaiqXZAHryqG3AjP
         LS7kUyBpKL6yLUkNeI8jot6itjivnSKfljRzI0PDLq9VrZfRo+RnGnh8nEMna1y/61Of
         xhCLgZiiwbrrxUz9dslqzafEATyiHY03HPce1nY3TaV4VbdYVZojln4yIYvt0p5LDXmN
         PoiYpgm6BB0UoN//IJZNTLzk0RIwkLzOxsaqUrsP/VPV/seCR9GLXwtTYdS7UWeUCa+r
         Wf8hBChYJdP3fnMfoY336GNbbWiwh3aAicjLeYb9zeq5VcyLPtyaz/zuXPZ9HaHO5bHo
         vhnw==
X-Gm-Message-State: AOAM5327RwwBRXayxNX8QQsvrQat3o2R5hX9onhFOmFefPYP0nx2fhJt
        afmndU+HOqyBR2R8TGT4Eyw=
X-Google-Smtp-Source: ABdhPJyphmJ5Sr9jTcUgZU5/20y7iif5g3lknxy6ce1sSt3xC4t6VcjeqwgZdYRY2CSGL7otD1ViuA==
X-Received: by 2002:a05:600c:4fd0:: with SMTP id o16mr4265974wmq.107.1619951645433;
        Sun, 02 May 2021 03:34:05 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.156])
        by smtp.gmail.com with ESMTPSA id q12sm8420515wrx.17.2021.05.02.03.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 03:34:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
References: <0000000000000c97e505bdd1d60e@google.com>
 <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com>
 <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com>
 <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
Message-ID: <12e84e19-a803-25e3-7d15-d105b56d15b6@gmail.com>
Date:   Sun, 2 May 2021 11:33:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 4:02 PM, Palash Oswal wrote:
> On Fri, Apr 30, 2021 at 8:03 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/30/21 3:21 PM, Palash Oswal wrote:
>>> On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
>>>> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
>>>> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
>>>> userspace arch: riscv64
>>>> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> There was so many fixes in 5.12 after this revision, including sqpoll
>> cancellation related... Can you try something more up-to-date? Like
>> released 5.12 or for-next
>>
> 
> The reproducer works for 5.12.

Tried 5.12, 

[  245.467397] INFO: task iou-sqp-2018:2019 blocked for more than 122 seconds.
[  245.467424] Call Trace:
[  245.467432]  __schedule+0x365/0x960
[  245.467444]  schedule+0x68/0xe0
[  245.467450]  io_uring_cancel_sqpoll+0xdb/0x110
[  245.467461]  ? wait_woken+0x80/0x80
[  245.467472]  io_sq_thread+0x1c6/0x6c0
[  245.467482]  ? wait_woken+0x80/0x80
[  245.467491]  ? finish_task_switch.isra.0+0xca/0x2e0
[  245.467497]  ? io_wq_submit_work+0x140/0x140
[  245.467506]  ret_from_fork+0x22/0x30
[  245.467520] INFO: task iou-sqp-2052:2053 blocked for more than 122 seconds.
[  245.467536] Call Trace:
[  245.467539]  __schedule+0x365/0x960
[  245.467545]  schedule+0x68/0xe0
[  245.467550]  io_uring_cancel_sqpoll+0xdb/0x110
[  245.467559]  ? wait_woken+0x80/0x80
[  245.467568]  io_sq_thread+0x1c6/0x6c0
[  245.467577]  ? wait_woken+0x80/0x80
[  245.467586]  ? finish_task_switch.isra.0+0xca/0x2e0
[  245.467591]  ? io_wq_submit_work+0x140/0x140

> 
> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe

However, there is a bunch patches fixing sqpoll cancellations in
5.13, all are waiting for backporting. and for-next doesn't trigger
the issue for me.

Are you absolutely sure b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
does hit it?

> commit on for-next tree
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
> and the reproducer fails.

-- 
Pavel Begunkov
