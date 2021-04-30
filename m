Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B19370095
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhD3SfS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 14:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhD3SfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 14:35:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D120CC06174A;
        Fri, 30 Apr 2021 11:34:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x7so71595872wrw.10;
        Fri, 30 Apr 2021 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V8gNbiKMd9vR2lotk+I4mHAAy2TLQwns7YwXyMfj7WY=;
        b=PklpdvWF9TgOVuMxwbHQGSZyoXm0cI7nMafu4HGQ20l3ZxhaokfI1mQGOyuj5lUOOq
         leRmdjeSoYZ1AZkWea5bk8GZDryOBiRS0NB+JQqitB3opyGrb80eHuu9/39Ch0QE5zQq
         BzWAZDrmOO5bXmgz+iZkwczOoRjonO9MWauY3y8Xq1KJ+sqCqakxLMsOo4Jy4eDWLd94
         657wbQzTvGKRSx4RJyIbDckIbl5us+XMR2hjhyCc0AbLw2JdaZsfwclnFW3L+zgK7Udd
         q/Q59djr+S66VuPaacs7iYSot4cIcm/T3gFFmvTL9FA+Mm4Aup7Kpsij1ywuuXFeHUWE
         m+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V8gNbiKMd9vR2lotk+I4mHAAy2TLQwns7YwXyMfj7WY=;
        b=M9fzM6KgG6ubTOsbBeqQzCrchl/GIErUI0S4LTLBUy8hCgmzrArzoNG9WbOdiu0vBB
         w2u2mEjJIH8wQTzuYiYrPqWHxnt4m0hTzoe0PuVLyLi9NREP7vuyChRB2+wxgYyWmKVM
         gy8ya6+uiCG9JLgbMfEOjK+b159dIUfHNwncZfYvyAO2+tTdNCzDYbXbfRHvWTFMK8aV
         0oF+HJuqfI703MUvb3WxcoTqyQuwnRQIAUidb8wfVoj50W9FtrTS12HkxcyXVf+hacoO
         ICvgWOhAnRi7+By9qj/EyCsK+BE54mOuZG3/P1ZIlAu8jANfQ8UHXMTKxw6+lDGDUYdo
         Fu/w==
X-Gm-Message-State: AOAM531j62etuqYw1chLWU+6YZG3Ai9xRIDBp/CmxXWzIOYRvKkKLPHx
        cfVrqF4F1+FZ0FCLmuPqWKM=
X-Google-Smtp-Source: ABdhPJyDjaMKUnrl3jjbkkUDlDryHn0azmOklQvkpua1zmQHBH/xW6wqPX9GBy/jhX0zrqM2kGNpmQ==
X-Received: by 2002:adf:c5d4:: with SMTP id v20mr8725403wrg.421.1619807667603;
        Fri, 30 Apr 2021 11:34:27 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id r13sm3479459wrn.2.2021.04.30.11.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:34:27 -0700 (PDT)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d350afac-eef2-c33f-e435-fe0ec7ffd1cf@gmail.com>
Date:   Fri, 30 Apr 2021 19:34:22 +0100
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
> 
> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
> commit on for-next tree
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
> and the reproducer fails.

Can't reproduce. Does it hang as in the original's report dmesg?
Can you paste logs?

#syz test: git://git.kernel.dk/linux-block io_uring-5.13

-- 
Pavel Begunkov
