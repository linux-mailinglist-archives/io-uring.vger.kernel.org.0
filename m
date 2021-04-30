Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A062F36FD5A
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 17:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhD3PIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhD3PIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 11:08:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C97C06174A;
        Fri, 30 Apr 2021 08:07:51 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so13095922wrw.8;
        Fri, 30 Apr 2021 08:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M7gQZmUaO0DyjkDODO4hWn3dhrX6FcyHyLJwu6zc/Cw=;
        b=SttFwgn8EGbJj6Jj0y/d9T5Gu2vSR2xrcfBPPCSLYxVOXLFSyJuwfw31GId4mapp8S
         3TsNUGGSQMqBCjuBYB+jX070kQaf4LBT5hI/2n4e5kJRwlU+bOSy4VGoHQTnH1bWCe+5
         GP8t8ve44SLzIEzCTONpWrKCs79gFlU5vanRIChQa+ilal3fuLbTMpW+SmcAbiWJSm88
         WzsJBCI4EC7Bcssa2p00pkHGEA8vkb71s/2P7HMETx8A0EK1/pGqCs1cGRs2IZG8OSV/
         GLt8iWwWJPKLX73hWGiI3CFxM1lgyOUengC9jKKhthLt412YGuYkESpTTT8DQukpNSGA
         fSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M7gQZmUaO0DyjkDODO4hWn3dhrX6FcyHyLJwu6zc/Cw=;
        b=Hm4lLH3Abc0/3FbTl8E8WMjowmQx+Nu0/DTliO+wu9RXHGn6Sh48T+MOetYiw+macS
         krflKYgZnz8i+RnErz5/+nvt+MJYf2O9gV9srDqJkVJbxm7Fy6U2XKe8+1RV0oKfFTcq
         CY3WItzoyTnDS2YW1+ii/VBjuF+Ryt64xtrBYdf2bx0B2opQpHDyDuLzXF/0jH3CgM5f
         UUepwYOSsZB7K8d1Gy+A2wEAOLCTm4vo42wZjUQFcvYW9FABPTNIHF672HQIG12/z05F
         ZatM7+9GqFZNY1Q0WcRDuZUVUYUmHQ6NqFOSmc0Zz5gO78itCB/Q62Xp/+YfzUAOFBF8
         G10g==
X-Gm-Message-State: AOAM533YpPavev8WtHWd4Whcg0hSJl8NwWgaporGWOPE1oX8EfIS9Btq
        0ZWfwXLCtUJPBmQrlOBEDMR4Y5oMdzM=
X-Google-Smtp-Source: ABdhPJwVsJ/r9GHPT3Ux8wnOMHBcolxMriWFi8LI8eWn30QdZOZnOLKCv0dCMiEGilPsMrMw8vG91w==
X-Received: by 2002:adf:d1e6:: with SMTP id g6mr7512229wrd.130.1619795270026;
        Fri, 30 Apr 2021 08:07:50 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id y5sm3188621wmj.25.2021.04.30.08.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 08:07:49 -0700 (PDT)
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
Message-ID: <6d682c9d-a3ec-ec74-c8be-89e1ea5e24ca@gmail.com>
Date:   Fri, 30 Apr 2021 16:07:44 +0100
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

Ok, any chance you have syz repro as well? it's easier to read

> 
> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
> commit on for-next tree
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
> and the reproducer fails.

-- 
Pavel Begunkov
