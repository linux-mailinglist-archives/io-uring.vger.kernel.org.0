Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109C237029B
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 23:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhD3VFy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 17:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbhD3VFy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 17:05:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAC3C06138B;
        Fri, 30 Apr 2021 14:05:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d11so14158010wrw.8;
        Fri, 30 Apr 2021 14:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4AFQFdYIK2aHm1d5xFyje/tGT6Iuc52lwDSkAKiwQ+0=;
        b=T7Clnp0nW+dl1zkqChEKs3pKarwzuucCmhLXTyDQDkSQgn823ebNRcK6CGXdLrueJh
         2JSQqctkyVfO32WId5f4qMJULZC8/UwNz4ZHeE0dlh/I1vTUYYtQbKWStcK88wWva0oK
         O6+sqUwigxN7zrsJXATlgGi6sArWmbI5SBTglVCtTzoRXrVi5UgsV2DV/7EnnbkM9goQ
         t7p+qNNVixGc4b8WD8tMng7x+Mv8h3vouwpEUj+hHG3Ci1Zf/ApDHQzx3E991D9+9k5T
         lypYVkn7+Cw7wRYHo65pGSnJbMgGG2nS9DwXorZqXBGuYH3jO6xUfi6e0c9jtSndf6J0
         l7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4AFQFdYIK2aHm1d5xFyje/tGT6Iuc52lwDSkAKiwQ+0=;
        b=SP2XN6kCHXpAFUbzV7KK2j+PUy58pT7l8UMSB/yPFRdXWm3FbyPuCpX+yTVye7m50N
         VF4UsK9bTnES9Nya1RircZFQCe85p3Yqz4zwNBOZUujEBnQbIFebC0y76aWCMrqd82N4
         xebATBpVCpil5UkdYIksMO0k4w3THUkOvxF9StuZacmZnsLUZ5VX/+zWeOnIJ+X9w5fO
         oiaXfpKZZmUMbgrYyhOFd2qT51dQ9/uF2jdARO+nmU0FTjKG5jTR0FSzrIt3ChPDuIRU
         Vplk9DkBa8PgxOaN8W3Tykd/iAHYBMrKwXBRe+nDMw4QsgK56aoT+L3M56ZftjoYPhTF
         r3mw==
X-Gm-Message-State: AOAM531trenLUjncXYDT47lFLBlwrkd6O815NX994x8RDUXNifJaMm6G
        3uyTpMhNyH8lJBwR1JaNOYo=
X-Google-Smtp-Source: ABdhPJwAjh2UP9hVb62pJ4UiJuGK/XfSrZhDaWcnN/VAqrY5Tx8p4w1UhRTw2xZmFmHfI8xCwvqcJw==
X-Received: by 2002:adf:d091:: with SMTP id y17mr9356684wrh.107.1619816704466;
        Fri, 30 Apr 2021 14:05:04 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id h5sm14025866wmq.23.2021.04.30.14.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 14:05:03 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
From:   Pavel Begunkov <asml.silence@gmail.com>
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
 <d350afac-eef2-c33f-e435-fe0ec7ffd1cf@gmail.com>
Message-ID: <9a7c2040-e26f-1c59-b7e9-25784d5b854e@gmail.com>
Date:   Fri, 30 Apr 2021 22:04:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <d350afac-eef2-c33f-e435-fe0ec7ffd1cf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 7:34 PM, Pavel Begunkov wrote:
> On 4/30/21 4:02 PM, Palash Oswal wrote:
>> On Fri, Apr 30, 2021 at 8:03 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 4/30/21 3:21 PM, Palash Oswal wrote:
>>>> On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
>>>>> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
>>>>> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
>>>>> userspace arch: riscv64
>>>>> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> There was so many fixes in 5.12 after this revision, including sqpoll
>>> cancellation related... Can you try something more up-to-date? Like
>>> released 5.12 or for-next
>>>
>>
>> The reproducer works for 5.12.
>>
>> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
>> commit on for-next tree
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
>> and the reproducer fails.
> 
> Can't reproduce. Does it hang as in the original's report dmesg?
> Can you paste logs?

and `uname -r` if you could

> 
> #syz test: git://git.kernel.dk/linux-block io_uring-5.13
> 

-- 
Pavel Begunkov
