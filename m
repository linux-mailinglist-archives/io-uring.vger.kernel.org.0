Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1A7A051B
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbjINNL4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 09:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbjINNL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 09:11:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C188F1BEB;
        Thu, 14 Sep 2023 06:11:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99c1d03e124so123028066b.2;
        Thu, 14 Sep 2023 06:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694697110; x=1695301910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36c5xEyuxfzi0ay83YGLiPfPwufpy3IfUuDa9s5F6cQ=;
        b=edCtyQCdZ2bzm+5SSw9UiaLQ7mQloTZVoonGZFf17jRWPOaHWrT1LFlnKRwkpscOP5
         1gM00a9QvTtQWLU8EME3n3aDzbiO3IpuwK/kEpX/0CIGz915EV6Bk4HXU3p7STsFYk3M
         R735Ld9cx95bBM3/OAH3MSEq3jnHuezmmFEr17pJgSkzkZHOud1EH78PqYDVLM/3Rl4t
         L10QQrWi/6s+1A4mReDJeQfzaDMHwxTYfut3TjrPpgU2ePlKCn2durNp6s8jmg8KUx6m
         lg+U+R/z4Ej0szZP8mPHwYhU6oNgkaCj0l366G9BfndTFLdl+YGcTglQoocw79cl1iIa
         ZumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694697110; x=1695301910;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36c5xEyuxfzi0ay83YGLiPfPwufpy3IfUuDa9s5F6cQ=;
        b=DGzJA5JrL8X1U1W5zcEygRGcrvBonU9cQhijQhsPYo44KWs50P6PiNRRYheAFK7H78
         Lf85rhv8BpfklMGzRtZetD4EdUH21JZ899tlR0Mt5H8ua570Lf4t2GQMGOac1Q3QVXt2
         Hobn+YLef4eAh96AcMTUCL/P3KDf2lFrB4/+sGaM+RPQH0IqjwodzzYFflFR1kTH36ZU
         O4Sn6t+RO5IvkiHGfpbd8kUKoOEFzB7/ICvmFrQYF49Nf2URy3M5QWP6uBgueWUeciPy
         IC2JoIVPAjcZbP457FVOGz2w0NBjgQDCqtCDVxFsTQgNi0YPkzAaH/PChcd9fraYVgcz
         bAWw==
X-Gm-Message-State: AOJu0Yw22JOwmWo5Cn3xIWO+GLbDmd+mquFQa5lfOaazB52vxiWbb6xf
        XsPQZaQl2Y8rkOKPufCZ1XE=
X-Google-Smtp-Source: AGHT+IEOcu1IIrbkMQ1YJ7kL5jM5Irg8B4R6jEP7P/E2CGEzD3zZgbGPTMZrZM3JlQu/k2hQovG/wA==
X-Received: by 2002:a17:906:5397:b0:9a1:d29c:6aa9 with SMTP id g23-20020a170906539700b009a1d29c6aa9mr4746450ejo.11.1694697109787;
        Thu, 14 Sep 2023 06:11:49 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id qx15-20020a170906fccf00b009a5f1d15644sm982584ejb.119.2023.09.14.06.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:11:49 -0700 (PDT)
Message-ID: <df1fbf71-f50d-c523-c9b2-e0f6ea011d61@gmail.com>
Date:   Thu, 14 Sep 2023 14:09:52 +0100
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CANpmjNPY7eD100LNcRJLocprTBuZrZ48hH6FPjMzhPSe6UMy0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 14:07, Marco Elver wrote:
> On Wed, 13 Sept 2023 at 14:13, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 9/13/23 12:29, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com
>>>
>>> ==================================================================
>>> BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
>>>
>>> write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
>>>    io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
>>>    schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
>>>    io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
>>>    ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
>>>    ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>>>
>>> read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
>>>    io_wq_get_acct io_uring/io-wq.c:168 [inline]
>>>    io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
>>>    io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914
>>
>> 1) the worst case scenario we'll choose a wrong type of
>> worker, which is inconsequential.
>>
>> 2) we're changing the IO_WORKER_F_RUNNING bit, but checking
>> for IO_WORKER_F_BOUND. The latter one is set at the very
>> beginning, it would require compiler to be super inventive
>> to actually hit the problem.
>>
>> I don't believe it's a problem, but it'll nice to attribute
>> it properly, READ_ONCE?, or split IO_WORKER_F_BOUND out into
>> a separate field.
> 
> It's a simple bit flag set & read, I'd go for READ_ONCE() (and
> WRITE_ONCE() - but up to you, these bitflag sets & reads have been ok
> with just the READ_ONCE(), and KCSAN currently doesn't care if there's
> a WRITE_ONCE() or not).
> 
>> value changed: 0x0000000d -> 0x0000000b
> 
> This is interesting though - it says that it observed 2 bits being
> flipped. We don't see where IO_WORKER_F_FREE was unset though.

__io_worker_busy() clears it, should be it. I assume syz just
missed another false data race with this one. After init only
the worker thread should be changing the flags AFAIR

-- 
Pavel Begunkov
