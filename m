Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF226ECCBF
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 15:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjDXNMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 09:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjDXNMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 09:12:06 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364484C02;
        Mon, 24 Apr 2023 06:11:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-94f7a0818aeso637131066b.2;
        Mon, 24 Apr 2023 06:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682341890; x=1684933890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hB4vLmqrAXEhyPqrrPRPZhEi6PPe2q2jqKi/upKeICI=;
        b=NFTZ1T3/fhl+ELYxJt5m7QlLgyW7FMdMcEPW8i70HoUu2QGWb9vh5PtQxwWFYg8+cz
         4t4hSZywST5aRR8PJPeyuR11kfnmO4RMMErTL+fPww3phz9C3Y/PMehuumKYQ6Fj6kQe
         9IHhUrkfAOxknppvA1ufe5J+G8GGj0G2fRzhp+kEJt1qosX0/ZnE0gWWph5Vvr2mxMI4
         SfbbGTr/mbzFy7w+jxiKgN2oz1LHVR8XuIQ4N+zPFmGPt+keA/rcCMc1FVfanujAkWjo
         ES+jzOyUNxS5uYY4vlkaiES+v64aeFwj3v3AMlheDZs1+hrEZE6ike7rt4gLSCWjrfNb
         fLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682341890; x=1684933890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hB4vLmqrAXEhyPqrrPRPZhEi6PPe2q2jqKi/upKeICI=;
        b=aS+lpMsHPU4Ayi9RSZfwe5jR9O3Z0r/H0niJn43cax9vM6DQYpR1zonn2eJbNW5Ah2
         MqXy/83Lhds7EAH+lqNwszxy1bNkIkKF8scm6NSmvYvBNllnOAsPsCDl3MtkSSc9l6FT
         BYtpYn0ZCJgMtKOUuj67BXliGfyjBizC08AwOvdJzofU1nMOs/qi0AsIj0zfNi50CTLd
         krYObfouFsHhHNZRoA2FsmiIm4Hy8CctjuIgzn6njbzlcPICR+dc2XR+FyU77TQwwyEH
         zo7qWMXtq35R91Lf1bByEPLfYyAP2rJswg5eA2aLZNP49hYag97YZUI+yMyH9gfKg4+S
         GI2Q==
X-Gm-Message-State: AAQBX9et3fwE4NEU6NGFad2/6Gm9ZZrHNruREEnZbQSewuRX6tRHy72r
        O3cl+6mQtXYXCAqisMzY8Kc=
X-Google-Smtp-Source: AKy350ZrV2ic3Cd14zH2ns65MgJDj0xcYyOudCju37d1qjFdKSsjZqSZ80eCWYnhfh5st3f3QooGaQ==
X-Received: by 2002:a17:906:81d1:b0:94a:62e7:70e1 with SMTP id e17-20020a17090681d100b0094a62e770e1mr9367950ejx.68.1682341890502;
        Mon, 24 Apr 2023 06:11:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:6e5a])
        by smtp.gmail.com with ESMTPSA id w27-20020a17090633db00b0094ed0370f8fsm5598217eja.147.2023.04.24.06.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 06:11:30 -0700 (PDT)
Message-ID: <cacd6e47-15ff-e17f-2e22-f6d5eb007b59@gmail.com>
Date:   Mon, 24 Apr 2023 14:01:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in __io_fill_cqe_req /
 io_timeout
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000d7848305fa0fd413@google.com>
 <CACT4Y+bVUkaoyp5OdzGLipof0b1+ec8xwqS+8cgvObuV0BUc5g@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACT4Y+bVUkaoyp5OdzGLipof0b1+ec8xwqS+8cgvObuV0BUc5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/23 08:37, Dmitry Vyukov wrote:
> On Mon, 24 Apr 2023 at 09:19, syzbot
> <syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    3a93e40326c8 Merge tag 'for-linus' of git://git.kernel.org..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1280071ec80000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f7350c77b8056a38
>> dashboard link: https://syzkaller.appspot.com/bug?extid=cb265db2f3f3468ef436
>> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/2122926bc9fe/disk-3a93e403.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/8392992358bc/vmlinux-3a93e403.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/6398a2d19a7e/bzImage-3a93e403.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
> 
> I did not fully grasp what happens here, but it looks suspicious.
> The comment in io_timeout() says that it computes "events that need to
> occur for this timeout event to be satisfied". But if the range is
> racing, it marks a random set of events?

Right, it's random in a good bunch of cases. There has never been
a fixed semantics for how it's supposed to work, i.e. cqe caching
infra should have changed it back in the day.

The good news, I don't think anyone uses it, and the worst case
scenario is userspace hangs on waiting. I'll drop data_race() /
spinlocks to make syzbot happy and would also say that we need
to deprecate and eventually to root it out.


>> ==================================================================
>> BUG: KCSAN: data-race in __io_fill_cqe_req / io_timeout
>>
>> read-write to 0xffff888108bf8310 of 4 bytes by task 20447 on cpu 0:
>>   io_get_cqe_overflow io_uring/io_uring.h:112 [inline]
>>   io_get_cqe io_uring/io_uring.h:124 [inline]
>>   __io_fill_cqe_req+0x6c/0x4d0 io_uring/io_uring.h:137
>>   io_fill_cqe_req io_uring/io_uring.h:165 [inline]
>>   __io_req_complete_post+0x67/0x790 io_uring/io_uring.c:969
>>   io_req_complete_post io_uring/io_uring.c:1006 [inline]
>>   io_req_task_complete+0xb9/0x110 io_uring/io_uring.c:1654
>>   handle_tw_list io_uring/io_uring.c:1184 [inline]
>>   tctx_task_work+0x1fe/0x4d0 io_uring/io_uring.c:1246
>>   task_work_run+0x123/0x160 kernel/task_work.c:179
>>   get_signal+0xe5c/0xfe0 kernel/signal.c:2635
>>   arch_do_signal_or_restart+0x89/0x2b0 arch/x86/kernel/signal.c:306
>>   exit_to_user_mode_loop+0x6d/0xe0 kernel/entry/common.c:168
>>   exit_to_user_mode_prepare+0x6a/0xa0 kernel/entry/common.c:204
>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>>   syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
>>   do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> read to 0xffff888108bf8310 of 4 bytes by task 20448 on cpu 1:
>>   io_timeout+0x88/0x270 io_uring/timeout.c:546
>>   io_issue_sqe+0x147/0x660 io_uring/io_uring.c:1907
>>   io_queue_sqe io_uring/io_uring.c:2079 [inline]
>>   io_submit_sqe io_uring/io_uring.c:2340 [inline]
>>   io_submit_sqes+0x689/0xfe0 io_uring/io_uring.c:2450
>>   __do_sys_io_uring_enter io_uring/io_uring.c:3458 [inline]
>>   __se_sys_io_uring_enter+0x1e5/0x1b70 io_uring/io_uring.c:3392
>>   __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3392
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd

-- 
Pavel Begunkov
