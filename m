Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6627A06E8
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbjINOIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbjINOIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 10:08:39 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B32B1BF8;
        Thu, 14 Sep 2023 07:08:35 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so1221790a12.2;
        Thu, 14 Sep 2023 07:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694700514; x=1695305314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vS85iRC5VjlFXuuBJs32mALQWUlOY8kocFR1NZApNg=;
        b=O/qGZImtdKAvl147uO8ve50lmaUE4AhXQL0LzjLwu/82ZMJzYRSHnD8L3yoZfmRv8u
         y5CKq1WvK3aDc2gq5+pZPwjo+cCePoJ70OymeMfCV7/qR0FWom/IaUaE7GQz3NL4shcL
         NPK0fmN6vAzzvPJdXYTj/ZivHWpPWhN+i+/MirHAwdgFfK6cvvUTTR3LiLgMGn/YB5Iw
         nVnxXEWL82Hw3sPO5FrYS9CL+kXpaoSTbzTp/9qiRc7jtaf+tzLkrc4tf8oVsr3L0hSP
         FTyeHlEdoddhZZzuFbcPDb3ojbBrRRBJG8drO2XjJ5slxQGITh9bamCNOP0/KuAm7TCv
         J2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694700514; x=1695305314;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vS85iRC5VjlFXuuBJs32mALQWUlOY8kocFR1NZApNg=;
        b=GpxDqnAtrSi2ufpj7GYh38QGdPwGUqUSRa3F4bZzSKWNDjZI22Vxi2Xihf7fJr32Xx
         MbfOEjQcVGL3y5b3SAMgyT/frNjUslcbdBo8c6u4MA3mj20pWuFWGS2lQeLTtV9Ukezd
         YMCk4XqXLtFrcyL2ijxqqWp8sFS7OstCr5pVfttBvmi91W2t92i6r8Lg52BUOBYfnT2O
         /9M8pVB1FkpnIF7lKdyyIKqZ1JW1OFayUgDQpIydLT8ptOWsBzJdSQGecQBJ291TzebE
         v82PErHmYYpZo0v5le/KVphsOJ75WqR4pjtTJkv19R2C5HDgj075LG0aTsJGVBj6sGHV
         XjFg==
X-Gm-Message-State: AOJu0YzfKBWkz6dLhI3u+O+NLJlnrhjPKOs3yPY4fcxTjV1GTtSeoiTy
        bIV4cz6nMEP456M5w/cGkTw=
X-Google-Smtp-Source: AGHT+IGTIS/0xvx+9Cfdo7Pu50RL7oezvStXt0n72yit1absunVjLu9LEkylSGNsotyr8oHS2/XGhQ==
X-Received: by 2002:aa7:da56:0:b0:52f:34b3:7c4 with SMTP id w22-20020aa7da56000000b0052f34b307c4mr4917736eds.39.1694700513628;
        Thu, 14 Sep 2023 07:08:33 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id z7-20020aa7cf87000000b0052718577668sm961495edx.11.2023.09.14.07.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 07:08:33 -0700 (PDT)
Message-ID: <864c84f9-5acc-132d-0cd8-826d041cff96@gmail.com>
Date:   Thu, 14 Sep 2023 15:06:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] UBSAN: array-index-out-of-bounds in
 io_setup_async_msg
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     syzbot <syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000002770be06053c7757@google.com>
 <e8d6c6ba-e9f0-45ac-219e-c1427424d31a@gmail.com>
In-Reply-To: <e8d6c6ba-e9f0-45ac-219e-c1427424d31a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 14:10, Pavel Begunkov wrote:
> On 9/13/23 13:11, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    0bb80ecc33a8 Linux 6.6-rc1
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d1eb78680000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16613002680000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13912e30680000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/eeb0cac260c7/disk-0bb80ecc.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/a3c360110254/vmlinux-0bb80ecc.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/22b81065ba5f/bzImage-0bb80ecc.xz
>>
>> The issue was bisected to:
>>
>> commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Thu Aug 24 22:53:32 2023 +0000
>>
>>      io_uring: add option to remove SQ indirection
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15892e30680000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17892e30680000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13892e30680000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
>> Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
>>
>> ================================================================================
>> UBSAN: array-index-out-of-bounds in io_uring/net.c:189:55
>> index 3779567444058 is out of range for type 'iovec [8]'
>> CPU: 1 PID: 5039 Comm: syz-executor396 Not tainted 6.6.0-rc1-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0x125/0x1b0 lib/dump_stack.c:106
>>   ubsan_epilogue lib/ubsan.c:217 [inline]
>>   __ubsan_handle_out_of_bounds+0x111/0x150 lib/ubsan.c:348
>>   io_setup_async_msg+0x2a0/0x2b0 io_uring/net.c:189
> 
> Which is
> 
> /* if were using fast_iov, set it to the new one */
> if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
>      size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
>      async_msg->msg.msg_iter.__iov = &async_msg->fast_iov[fast_idx];
> }
> 
> The bisection doesn't immediately make sense, I'll try
> it out

#syz test: https://github.com/isilence/linux.git netmsg-init-base

First just test upstream because I'm curious about reproducibility


-- 
Pavel Begunkov
