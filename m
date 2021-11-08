Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1244984F
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbhKHPci (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbhKHPce (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:32:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F38AC061570;
        Mon,  8 Nov 2021 07:29:49 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z21so18732654edb.5;
        Mon, 08 Nov 2021 07:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yz97IpeFpwc9+DNcdYyZdaeXGfHaLdiWkq+8v639/Rw=;
        b=PhWjwa2bCRi2BKn0eStvKOTC4dHEcPfntNX3eREBmeaa5MX/k1KcJE3anx8VTDC/hw
         86nadGldCaZDpcr57UBa3CYK6N2v1MsTfX0vKJdMvP7M4b3eKb8GQKzzgf9RB1jhWLA8
         RDqMmTWvjoiOr40Clxm6vN2CeIUGS/G4zPvBT0Q0x8uoMWhWICwNhRdyQiYywOVVpsOh
         R1E/I8TQ838TMAsPVEoGjYu5M66JbDEFLZsSuXUExtt+MqG3Awz1pSPviqNveBLE+RcX
         Mr3ioUoQIn23CSpCX1AUp72EYl+V2w38f/GtKcwnd+9CTp2OKkjd6rsF+R3ocbNkuNgs
         RePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yz97IpeFpwc9+DNcdYyZdaeXGfHaLdiWkq+8v639/Rw=;
        b=V4iZ1uzKGkXkB3l1XYFlm8YkXr5dXUZ6p61OfFks4pYqU7Cex1L7bNWc5ldStRgAN8
         g6HyOc+48T88J+GOQwRVTOF3JeREoQoW4oeDgFHUwlSHOsXE7dqHbBPujQ2yx3jmMM1S
         +dqYKB+QlbbtVFba34//5/IyGpQtY4qXOupqhumzEq/aU3nyYfAadNTF+d31dTY4P0lc
         rt3leAGKFIZAa6gZBTlWIBaLMACggknD45o9Ute/DpP8i8BxAfXB9ucDJYSVQjApy/+Y
         YHx2KPZ79I0/zTlFG9ioyqdFZ01HIPvZf8j/RCZlhNGgA2gUqAZX8ElUehES64M+4VQo
         CcDA==
X-Gm-Message-State: AOAM531gqYotNM4l13aAUQyO0lqog5Am4U6jXE4hgNc1koGGTIZ2RClr
        LjtFceY1+K6P0kb6cp1tLrA=
X-Google-Smtp-Source: ABdhPJxL39ya53bOKchi7nsoBX9CFctZZEuChf18wtn+iKJ9e3KMd0rXGWtcDBYazqUdxJYlX0oeFA==
X-Received: by 2002:a05:6402:289f:: with SMTP id eg31mr30557edb.192.1636385388111;
        Mon, 08 Nov 2021 07:29:48 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.239])
        by smtp.gmail.com with ESMTPSA id sa17sm1630374ejc.123.2021.11.08.07.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:29:47 -0800 (PST)
Message-ID: <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
Date:   Mon, 8 Nov 2021 15:29:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>,
        syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com> <YYLAYvFU+9cnu+4H@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YYLAYvFU+9cnu+4H@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/3/21 17:01, Lee Jones wrote:
> Good afternoon Pavel,
> 
>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>>
>> Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
>>
>> Tested on:
>>
>> commit:         bff2c168 io_uring: don't retry with truncated iter
>> git tree:       https://github.com/isilence/linux.git truncate
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>
>> Note: testing is done by a robot and is best-effort only.
> 
> As you can see in the 'dashboard link' above this bug also affects
> android-5-10 which is currently based on v5.10.75.
> 
> I see that the back-port of this patch failed in v5.10.y:
> 
>    https://lore.kernel.org/stable/163152589512611@kroah.com/
> 
> And after solving the build-error by back-porting both:
> 
>    2112ff5ce0c11 iov_iter: track truncated size
>    89c2b3b749182 io_uring: reexpand under-reexpanded iters
> 
> I now see execution tripping the WARN() in iov_iter_revert():
> 
>    if (WARN_ON(unroll > MAX_RW_COUNT))
>        return
> 
> Am I missing any additional patches required to fix stable/v5.10.y?

Is it the same syz test? There was a couple more patches for
IORING_SETUP_IOPOLL, but strange if that's not the case.


fwiw, Jens decided to replace it with another mechanism shortly
after, so it may be a better idea to backport those. Jens,
what do you think?


commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Sep 10 11:18:36 2021 -0600

     iov_iter: add helper to save iov_iter state

commit cd65869512ab5668a5d16f789bc4da1319c435c4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Sep 10 11:19:14 2021 -0600

     io_uring: use iov_iter state save/restore helpers


-- 
Pavel Begunkov
