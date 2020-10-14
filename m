Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FD28E3FE
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgJNQGm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730579AbgJNQGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 12:06:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24937C061755;
        Wed, 14 Oct 2020 09:06:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b8so4578713wrn.0;
        Wed, 14 Oct 2020 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e+m5qsnEajbbEQHI4VfPxur6uIKBSMwPX12oNaFiBDs=;
        b=jZqr70ut+rRRq5MGT8YTcxZA6Ka07Ib+zp8eg4tdDwASQsk8knXCaaK5440TtNHHtR
         uWf7LY0rUt8TXtSgzmVuPywJOlOU/0rXzggXWwPVkfiN91cLmNFi9M7qqT1c49HPaW+q
         p2i9QgalW0iOOrfJBuVMMcS6lVnUZMzuQx4zWYbp24awpbVqUr7zM11ySdyczNYf84SE
         MvvKLcfx9Um3ex5jW2ELTy60y7IMlHnLzapyZD7AiCJJJs+gYmV/fHNtVN9h9fZzFEpU
         IFyghg1vLEu7S4jrBzAzcXo24DwMHFHdEyDiwYSnUqD+auloMGGaL2zrresZ7OGUWnLp
         jPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e+m5qsnEajbbEQHI4VfPxur6uIKBSMwPX12oNaFiBDs=;
        b=RZN6b0peNujpt6bhLnISFnHHHh5wtvNwKjy45y8xyT4k0qCGOssUXEOITvvNnfOKxP
         IoayXQmOjbCzkbN1u65xr+cOjl88eTMhGO3qBVB+d1nhUF0O2MVqKSKVBv+j3tYTUwSP
         sNRGML4X8WT3TfmbfLXOb+yA1efS4zAxmO3DMvc8APjCVEBteqqgnCQlg3pms31WWJ/o
         3hKn0CfVSERZOA1swD34GQsk9voQIIYLKZ6nIFtldzDX9uFZiZbH/K8NB+N2GmutdlgZ
         LhHbc8W71qp/3GEAPQ1lsSpmVfHxqsIc3rtV0qRdQ1EVoBVwgG5QO81nLX/ueyJHfz/y
         5+LA==
X-Gm-Message-State: AOAM531vFDh0ThvhRoop5L2MLm/YNEfnTpFx7H4mvDOmMk+nXJ8xG8oE
        DLgIfwulzylt4X2kSQBP6yTEPLmk1NLrLA==
X-Google-Smtp-Source: ABdhPJyNyV8QEK4HJQfrwODLW2R6Quk5UjF7jmPmudF/sqldIOdirnZPvAtXwzbTo97jyIF1poCnRg==
X-Received: by 2002:adf:f7d1:: with SMTP id a17mr6408322wrq.396.1602691600707;
        Wed, 14 Oct 2020 09:06:40 -0700 (PDT)
Received: from [192.168.1.27] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id o4sm5597034wrv.8.2020.10.14.09.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 09:06:40 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000005a849705b1a04ab8@google.com>
 <94fe990f-6382-039b-34b5-233b437af610@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: general protection fault in __do_sys_io_uring_register
Message-ID: <cc5d791f-78da-f73d-c6a3-c9dae3cf5a1b@gmail.com>
Date:   Wed, 14 Oct 2020 17:03:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <94fe990f-6382-039b-34b5-233b437af610@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/10/2020 14:35, Jens Axboe wrote:
> On 10/14/20 6:01 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    029f56db Merge tag 'x86_asm_for_v5.10' of git://git.kernel..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13b5c678500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4ce0764b8e2dd3f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=f4ebcc98223dafd8991e
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com
>>
>> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>> CPU: 1 PID: 8927 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
>> RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
>> RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
>> RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
>> Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
>> RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
>> RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
>> RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
>> R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
>> FS:  00007f4266f3c700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000000118c000 CR3: 000000008e57d000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45de59
>> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f4266f3bc78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> RAX: ffffffffffffffda RBX: 00000000000083c0 RCX: 000000000045de59
>> RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000005
>> RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
>> R10: 40000000000000a1 R11: 0000000000000246 R12: 000000000118bf2c
>> R13: 00007fff2fa4f12f R14: 00007f4266f3c9c0 R15: 000000000118bf2c
>> Modules linked in:
>> ---[ end trace 2a40a195e2d5e6e6 ]---
>> RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
>> RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
>> RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
>> RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
>> Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
>> RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
>> RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
>> RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
>> R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
>> FS:  00007f4266f3c700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000000074a918 CR3: 000000008e57d000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> I think this should fix it.

("io_uring: clean file_data access in files_register") is reported
already a second time, that's a really unfortunate commit...

The fix looks good. Though, in the future I'd prefer to remove the
ctx dependency there, e.g. __io_file_from_index(file_table).

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc6de6b4784e..528eced8ee1f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7311,6 +7311,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  
>  	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
>  		goto out_ref;
> +	ctx->file_data = file_data;
>  
>  	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
>  		struct fixed_file_table *table;
> @@ -7345,7 +7346,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  		table->files[index] = file;
>  	}
>  
> -	ctx->file_data = file_data;
>  	ret = io_sqe_files_scm(ctx);
>  	if (ret) {
>  		io_sqe_files_unregister(ctx);
> @@ -7378,6 +7378,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  out_free:
>  	kfree(file_data->table);
>  	kfree(file_data);
> +	ctx->file_data = NULL;
>  	return ret;
>  }
>  
> 

-- 
Pavel Begunkov
