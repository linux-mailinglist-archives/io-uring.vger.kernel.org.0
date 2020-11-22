Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE97A2BC69F
	for <lists+io-uring@lfdr.de>; Sun, 22 Nov 2020 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgKVQAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Nov 2020 11:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgKVQAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Nov 2020 11:00:23 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80151C0613CF;
        Sun, 22 Nov 2020 08:00:23 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 1so14996475wme.3;
        Sun, 22 Nov 2020 08:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YhgMZ1gW8n+ppTBOSSiSj13dNRCLzcIfKh3zHOsAmD4=;
        b=YaxS57GK3xepkiT+DcePuH6b/ioHU1Aa2zabX9srvXvlTcSqip+ryJ40pTWzoMC8Mp
         DSuRI+9Gqg/Ue+AS3mA+qoIpt3Ir2sdGcVwbYCQe72lHlb4hfAPtClNRwZub3kSFjD0g
         6HgxodWphiYp2w8bVXpdgUywYxJ95zgDgG+oSisOejikFcRFCJ/TKdXVlNhfwN6BxuWU
         3jLf+Z66CAit618i60F45ArdrR2vN5PKu9M+zgnDA1n873JQZtmpGBlp5LYsyVed/vsB
         zIIJOzT9roJZSKvMCADA2zflb1Eq3+FAYTwpn+oQgMoPh0dC5lrE2qxRWHISW9ARRBir
         BMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YhgMZ1gW8n+ppTBOSSiSj13dNRCLzcIfKh3zHOsAmD4=;
        b=UNYvFUczEBdCjFZh/EOmaAkfjqp1fQRJw4M+vUbwnr6koyIiG4LATOUmsRmV3SI9IC
         1f6u282nPppkAs4Wo3JHmOzXNqNHdr0ad6VGUBrpWIomWtVHKSPB4bNz6pFN/PY8+kjq
         wK/72s3gGViaTdeyfXWxzPndlHJv/NihyA/cZaPt6sUzF5t8dDLkdo44iAWC0SWrmWGe
         J+ZGuzGna3nj0rPWLBnC0X83ay3+xnUPwNqNtf0VFwS140iW6zzZvGQXA3lttiV+La3D
         3RKEtfNFVTru7xnonzffXuf5w7HzVCW13whCjY2up1m2hECfYtpTONmmfIaP02/A87XE
         vWYA==
X-Gm-Message-State: AOAM5304wnMd5C0Xo+qxI4OEKb8st9w5Hrrg13KkKNJCqPIZaDPaioG1
        dJtJ7fCfUaLAWbHrkKnVCjg=
X-Google-Smtp-Source: ABdhPJxbtQQ665YYaTB3b+5OvUiIrWTXg/BrTSvMTF+7IpT/uEClvyhqcTtAWOsGUH8eh/HbYtfxSA==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr11581585wmi.186.1606060822132;
        Sun, 22 Nov 2020 08:00:22 -0800 (PST)
Received: from [192.168.1.118] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id 35sm13807181wro.71.2020.11.22.08.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2020 08:00:21 -0800 (PST)
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
References: <0000000000002bea4605b4a5931d@google.com>
 <20201122030421.2088-1-hdanton@sina.com>
 <20201122092003.7724-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: INFO: task hung in __io_uring_files_cancel
Message-ID: <03db9ac8-f077-ab84-04e6-b83ad6763fe7@gmail.com>
Date:   Sun, 22 Nov 2020 15:57:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201122092003.7724-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/11/2020 09:20, Hillf Danton wrote:
> On Sun, 22 Nov 2020 03:32:01 +0000 Pavel Begunkov wrote:
>> On 22/11/2020 03:04, Hillf Danton wrote:
>>> On Sat, 21 Nov 2020 14:35:15 -0800
>>>> syzbot found the following issue on:
>>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10401726500000
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12401726500000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14401726500000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
>>>> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
>>>>
>>>> INFO: task syz-executor.0:9557 blocked for more than 143 seconds.
>>>>       Not tainted 5.10.0-rc4-next-20201117-syzkaller #0
>>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> task:syz-executor.0  state:D stack:28584 pid: 9557 ppid:  8485 flags:0x00004002
>>>> Call Trace:
>>>>  context_switch kernel/sched/core.c:4269 [inline]
>>>>  __schedule+0x890/0x2030 kernel/sched/core.c:5019
>>>>  schedule+0xcf/0x270 kernel/sched/core.c:5098
>>>>  io_uring_cancel_files fs/io_uring.c:8720 [inline]
>>>>  io_uring_cancel_task_requests fs/io_uring.c:8772 [inline]
>>>>  __io_uring_files_cancel+0xc4d/0x14b0 fs/io_uring.c:8868
>>>>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>>>>  exit_files+0xe4/0x170 fs/file.c:456
>>>>  do_exit+0xb61/0x29f0 kernel/exit.c:818
>>>>  do_group_exit+0x125/0x310 kernel/exit.c:920
>>>>  get_signal+0x3ea/0x1f70 kernel/signal.c:2750
>>>>  arch_do_signal_or_restart+0x2a6/0x1ea0 arch/x86/kernel/signal.c:811
>>>>  handle_signal_work kernel/entry/common.c:145 [inline]
>>>>  exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
>>>>  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:199
>>>>  syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:274
>>>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> RIP: 0033:0x45deb9
>>>> Code: Unable to access opcode bytes at RIP 0x45de8f.
>>>> RSP: 002b:00007fa68397ccf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
>>>> RAX: fffffffffffffe00 RBX: 000000000118bf28 RCX: 000000000045deb9
>>>> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000118bf28
>>>> RBP: 000000000118bf20 R08: 0000000000000000 R09: 0000000000000000
>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
>>>> R13: 00007fff50acc9af R14: 00007fa68397d9c0 R15: 000000000118bf2c
>>>>
>> ...
>>>
>>> Fix 311daef8013a ("io_uring: replace inflight_wait with tctx->wait")
>>> by cutting the pre-condition to wakeup because waitqueue_active()
>>> speaks the language in the East End while atomic_read() may speak
>>> the language in Paris.
>>
>> Your description doesn't help,
> 
> That is what I could find to describe the changs added in
> 311daef8013a, given that waitqueue_active() and atomic_read() IMO are
> primary bricks without natural links prebuilt. I dont think either
> of them could be replaced with another even in 311daef8013a.

There are not linked, but that doesn't make it automatically wrong.
I still don't understand how it fixes the problem, and it's better
to find the root cause because there are similar places that might
still be similarly flawed.

>> why do you think this is the problem?
> 
> This is not a tough question, thanks to the reproducer.
> 
>> ->in_idle is always set when io_uring_cancel_files() sleeps on it,
>> and ->inflight_lock should guarantee ordering.
> 
> The syzbot report makes sense, right?
> 
>>>
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -6082,8 +6082,7 @@ static void io_req_drop_files(struct io_
>>>  
>>>  	spin_lock_irqsave(&ctx->inflight_lock, flags);
>>>  	list_del(&req->inflight_entry);
>>> -	if (atomic_read(&tctx->in_idle))
>>> -		wake_up(&tctx->wait);
>>> +	wake_up(&tctx->wait);
>>>  	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
>>>  	req->flags &= ~REQ_F_INFLIGHT;
>>>  	put_files_struct(req->work.identity->files);

-- 
Pavel Begunkov
