Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1ACC7A0880
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbjINPGG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 11:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240666AbjINPGE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 11:06:04 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8681FE6;
        Thu, 14 Sep 2023 08:05:59 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-401b393ddd2so12115145e9.0;
        Thu, 14 Sep 2023 08:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694703958; x=1695308758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sSn0alw097ErbRI2s3YE8lYCXo+UM6cYYH+DKOhV4LA=;
        b=Ic+XjHhPXZ1YUrtnU+QdwSYUXLtr3o0DirM8NNCwVDkkoUvOvtVEQQ721UpVJ29i1o
         Yfc+4Kn1Mn1VaH5l4UEeeYlk0yymwCJZHab0IxzcOwtv50yIUxnMsIvQ3SqP3TW3e3Uw
         VJKOVAp8t6DXmQaKuRa9E1XhioofP3L+xVZGeRGdhdZiSiM5yH61tvYY58aTToW3DIPY
         HNC67fKE/tk+Act98ela/CJJao0lCNNs8+Z+06Re5ZN2TlgS4+AxA+/9WqjJ1R8dcrCV
         lk/x5Izsp6nF2kSo0nvoELt+bckPswZOYJdgriboXClSV/5ETIAxc1x4OtfdfauStYOP
         9KGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694703958; x=1695308758;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSn0alw097ErbRI2s3YE8lYCXo+UM6cYYH+DKOhV4LA=;
        b=Pf1q4qSHX/7CbVTa7qGnhapjb3jb6iUKhmfnz8bc9wocSNieuFO5U/bEmI/m8977bf
         DzGRaedsCznEse5vyWIsMusSuEy+0yS41MuQDEgWY5G+LZsLGeJYLiua8btDvagiJFMe
         oKE/OnpgO9T/cqkA316a+vt3fXGGaNPWx3YYOtTjlpySSNuWOM4bl3Tsvu0yZRx7M9vh
         WwsYISH9/or35GVLl3C2z1ny85sQlkzDNTgsu9CC597Qu8Ky9VrP63WaVlmoaj5yG9eu
         MSwLxTNmDs7t+MK9/PCF4fq6ZunIKxqJujl3x8Zhoj3oefhvmYi3eoM7dGMJb8VRBYk1
         kHXQ==
X-Gm-Message-State: AOJu0YwJwFe68tDjyVnOwsdyCkphNu5QrD7oryhkgdYY2JfBT9dMfBcF
        EOlOwq3nEa5KwxoRAwMBchA=
X-Google-Smtp-Source: AGHT+IEXehxJ12j3k6xE5squhZYLViJCjNHxgPrZOndg/9/+eE11NNcBwiPXEx7kjzcyAO5qe6ExFg==
X-Received: by 2002:adf:ee08:0:b0:319:8c35:37b with SMTP id y8-20020adfee08000000b003198c35037bmr5297720wrn.7.1694703957568;
        Thu, 14 Sep 2023 08:05:57 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id a9-20020aa7d909000000b0052889d090bfsm1031987edr.79.2023.09.14.08.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 08:05:57 -0700 (PDT)
Message-ID: <d1285714-a6ad-688a-1adf-6a41771aa301@gmail.com>
Date:   Thu, 14 Sep 2023 16:03:49 +0100
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
 <864c84f9-5acc-132d-0cd8-826d041cff96@gmail.com>
In-Reply-To: <864c84f9-5acc-132d-0cd8-826d041cff96@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/23 15:06, Pavel Begunkov wrote:
> On 9/13/23 14:10, Pavel Begunkov wrote:
>> On 9/13/23 13:11, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    0bb80ecc33a8 Linux 6.6-rc1
>>> git tree:       upstream
>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d1eb78680000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
>>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16613002680000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13912e30680000
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot-assets/eeb0cac260c7/disk-0bb80ecc.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/a3c360110254/vmlinux-0bb80ecc.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/22b81065ba5f/bzImage-0bb80ecc.xz
>>>
>>> The issue was bisected to:
>>>
>>> commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Thu Aug 24 22:53:32 2023 +0000
>>>
>>>      io_uring: add option to remove SQ indirection
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15892e30680000
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17892e30680000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13892e30680000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
>>> Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
>>>
>>> ================================================================================
>>> UBSAN: array-index-out-of-bounds in io_uring/net.c:189:55
>>> index 3779567444058 is out of range for type 'iovec [8]'
>>> CPU: 1 PID: 5039 Comm: syz-executor396 Not tainted 6.6.0-rc1-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
>>> Call Trace:
>>>   <TASK>
>>>   __dump_stack lib/dump_stack.c:88 [inline]
>>>   dump_stack_lvl+0x125/0x1b0 lib/dump_stack.c:106
>>>   ubsan_epilogue lib/ubsan.c:217 [inline]
>>>   __ubsan_handle_out_of_bounds+0x111/0x150 lib/ubsan.c:348
>>>   io_setup_async_msg+0x2a0/0x2b0 io_uring/net.c:189
>>
>> Which is
>>
>> /* if were using fast_iov, set it to the new one */
>> if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
>>      size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
>>      async_msg->msg.msg_iter.__iov = &async_msg->fast_iov[fast_idx];
>> }
>>
>> The bisection doesn't immediately make sense, I'll try
>> it out
> 
> #syz test: https://github.com/isilence/linux.git netmsg-init-base
> 
> First just test upstream because I'm curious about reproducibility

#syz test: https://github.com/isilence/linux.git  syz-test/netmsg-init-base

-- 
Pavel Begunkov
