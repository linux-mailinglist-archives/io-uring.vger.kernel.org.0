Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3E307C92
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhA1RdC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhA1Rcn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:32:43 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7DBC061756;
        Thu, 28 Jan 2021 09:31:58 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id s24so5573364wmj.0;
        Thu, 28 Jan 2021 09:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Cwjm/2qlCWIRJFTs2hMQREg4FZ+PGacvMyXkhD9iAI=;
        b=aNDwA4+XL8J4sXT7eSn/ZZSMF03cX+ORj7VtUYQ40d5L3w/lOFAYwcfVKviHkT9Lvw
         jkB7/6nNArZXinngR7QHZ8yJ9omw8V/qCtaikewSHOY/sLRw5SG0sbCSX1fx5LfTtvaL
         P0TrTVE4JiBLUswV4wAeob/dzXBAsmvKzQ1MMHj1hpqx7v21XRqDAkdC8mrxDY/i33Pd
         +gndzvN5lcDDBJIzlP92bFdOs/lnkiYwWRsLaJMG6gHIzz00NL4vV0w39wKbGs46F3c3
         SbbAOCyXlaTYIUTV0rmSnmInIk4M1qrYw2Gu48Td8nfE628ILV3tMUDXO8hUfBM/4+7n
         d27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Cwjm/2qlCWIRJFTs2hMQREg4FZ+PGacvMyXkhD9iAI=;
        b=HH3NMNMrSDoNskNpxShT0IoUDhzBWUgFgETpra7iCF0pKoVrBlcP+TmttS7uTgZYVW
         jaGdSrfwXogfJl3w9XpqC/Uq9Q/k6gxkGBS9q3fYAlQ3yRURQSZAd9+NfGzhFGywUq8r
         b6EBO1cv33PEM7/PLzWnqC0Pc46rFUkV+0ZOIzUWRL6Na0WSMp0hiUskoEPOBWMltz94
         sVXIZHt3By40HIpS73lqkqFw7feuHiA7GaCN9lGi6aQ4tZPKulrkzodrLQbtj4hzeSII
         Nl8Jvq8lIVoWcHYN3Zjyyej5WQBadyl/mJfDsORkqR3PjDOc+wqDBx6gfAMb+9A/7S28
         ffmA==
X-Gm-Message-State: AOAM533W9ol5K3PSRLii40mU02Hpcv4gN65RaLNOJ3TBO0OgN8z/WXhs
        5ZGntnt0pnvOmJZiSaZEq6U=
X-Google-Smtp-Source: ABdhPJygx9Ph++VuBSrkb9n+oBg+H/Gv/LSmI9wHe2DQj62JJFtY0p9ycYWUIMvnJvnfNVFIGGr/9A==
X-Received: by 2002:a05:600c:2803:: with SMTP id m3mr349304wmb.86.1611855117568;
        Thu, 28 Jan 2021 09:31:57 -0800 (PST)
Received: from [192.168.8.160] ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id e12sm7516082wrs.67.2021.01.28.09.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:31:56 -0800 (PST)
Subject: Re: BUG: corrupted list in io_file_get
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+6879187cf57845801267@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000ab74fb05b9f8cb0a@google.com>
 <944c4b9b-9c83-3167-fd43-d5118fdc2e0e@gmail.com>
 <7dfb62b3-0821-5203-b34f-4400e0b1152d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <918e464c-b628-5bc5-e65c-7eaa465a1cf9@gmail.com>
Date:   Thu, 28 Jan 2021 17:28:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7dfb62b3-0821-5203-b34f-4400e0b1152d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/01/2021 17:25, Jens Axboe wrote:
> On 1/28/21 10:12 AM, Pavel Begunkov wrote:
>> On 28/01/2021 16:58, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    76c057c8 Merge branch 'parisc-5.11-2' of git://git.kernel...
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11959454d00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=96b123631a6700e9
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=6879187cf57845801267
>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a3872cd00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ab17a4d00000
>>>
>>> The issue was bisected to:
>>>
>>> commit 02a13674fa0e8dd326de8b9f4514b41b03d99003
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Sat Jan 23 22:49:31 2021 +0000
>>>
>>>     io_uring: account io_uring internal files as REQ_F_INFLIGHT
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d1bf44d00000
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16d1bf44d00000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12d1bf44d00000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
>>> Fixes: 02a13674fa0e ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")
>>>
>>> list_add double add: new=ffff888017eaa080, prev=ffff88801a9cb520, next=ffff888017eaa080.
>>> ------------[ cut here ]------------
>>> kernel BUG at lib/list_debug.c:29!
>>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>>> CPU: 0 PID: 8481 Comm: syz-executor556 Not tainted 5.11.0-rc5-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
>>> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
>>> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
>>> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
>>> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
>>> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
>>> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
>>> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
>>> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
>>> Call Trace:
>>>  __list_add include/linux/list.h:67 [inline]
>>>  list_add include/linux/list.h:86 [inline]
>>>  io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
>>>  __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
>>>  io_splice_prep fs/io_uring.c:3920 [inline]
>>>  io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
>>>  io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
>>>  io_submit_sqe fs/io_uring.c:6705 [inline]
>>>  io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
>>>  __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
>>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> RIP: 0033:0x440569
>>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>>> RSP: 002b:00007ffe38c5c5a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>>> RAX: ffffffffffffffda RBX: 0000000000401e00 RCX: 0000000000440569
>>> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000004
>>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000401d70
>>> R13: 0000000000401e00 R14: 0000000000000000 R15: 0000000000000000
>>> Modules linked in:
>>> ---[ end trace 3c68392a0f24e7a0 ]---
>>> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
>>> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
>>> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
>>> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
>>> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
>>> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
>>> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
>>> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
>>> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
>>
>> This one is simple
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ae388cc52843..39ae1f821cef 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6460,7 +6460,8 @@ static struct file *io_file_get(struct io_submit_state *state,
>>  		file = __io_file_get(state, fd);
>>  	}
>>  
>> -	if (file && file->f_op == &io_uring_fops) {
>> +	if (file && file->f_op == &io_uring_fops &&
>> +	    !(req->flags & REQ_F_INFLIGHT)) {
>>  		io_req_init_async(req);
>>  		req->flags |= REQ_F_INFLIGHT;
> 
> Curious, how is it marked in-flight already? Ah it's splice... Pavel,

Yeah, splice was handled automatically in the end...

> can you send the fix for this one?

sure, in an hour


-- 
Pavel Begunkov
