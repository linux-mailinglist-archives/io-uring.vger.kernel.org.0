Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6F693838
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBLPu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 10:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjBLPu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 10:50:26 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F317EB7B;
        Sun, 12 Feb 2023 07:50:25 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id f23-20020a05600c491700b003dff4480a17so7223071wmp.1;
        Sun, 12 Feb 2023 07:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G7TDx0ayV1s6yF8W14tJtZ/gbKxJ6Z8Rxoz1+MRRB7A=;
        b=RKS4W5PTCEt8h9dxpM/VmdNqA+20A8T8yAYMfmPc0dhn6E8Kv9T2xsGcjbUQuohKWI
         XvPX+mApehJ+YTXwwRMQcnQ833JK5y3nUtP0hMLPJu20MXof8CZ82lmXgnzSCmcFy7wq
         S9lxWuRM0TPpLaRsYrGcUhGt2bxK80xvVyWLZ8vj2NZ4xAY47YueLcBwNbYnMV28lHo7
         O0mhCJf6uovSA05Ecq1hwcMo0+ZlbCca3JkYncMQ8mLXmt92WAAe5iBDs9FWNEA4NhVd
         sS5zR9mBtKyKnRKSIJ3Y2l9gzpX4Lw8ILxYyc9n4uTYJkDAOpJ/VrrFsAWhH2tOx+2Ao
         uY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7TDx0ayV1s6yF8W14tJtZ/gbKxJ6Z8Rxoz1+MRRB7A=;
        b=Gn4+QlXVMgnCoDMCskVD80LyE7Y1aHUPSTz+hazSe1CGxCgcGvv+88B3Qeed+nz1zJ
         OyWzn2ri2zExHyO7fxaudvH7YFuX/Naup2prc2yCYtuYkQ2fW2qpGLCnqlTcB3CFCcEG
         wFeNDp05C8++9aQQCPdEObFcrMXgDCRbi7rMsGCpAxePUqy/CQx3TfnaEQFkvtTh6hTr
         YbyypRLN7MqpW1j7jVEhsrg5eayez9XnGFmgT2oVBDsiZ4gfSKk94b8G+FnfY87jN5SH
         4OJVEIQOmIXffRKirbDGPf47ou4ncScRMyvE2wvzP82TLaXtvfuhm+f0McUdf8Z48Lmn
         stFQ==
X-Gm-Message-State: AO0yUKV564uww9LW0FPF2ch2/T9Tayf0VYcCXvJt4xtnHEqEAT2IEKFL
        riDLHZhd/E13y3QusRAAq4U=
X-Google-Smtp-Source: AK7set9vCBDynh/m6z0bywm/EzFdeZoj+1p47ggyzl7F4nwnQ/AjuV3M9XuLjkeEpY/nnWMbixJcmA==
X-Received: by 2002:a05:600c:4383:b0:3df:f7f1:4fbe with SMTP id e3-20020a05600c438300b003dff7f14fbemr17209336wmn.1.1676217023726;
        Sun, 12 Feb 2023 07:50:23 -0800 (PST)
Received: from [192.168.8.100] (94.197.108.135.threembb.co.uk. [94.197.108.135])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c308900b003dc3f195abesm11095560wmn.39.2023.02.12.07.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 07:50:23 -0800 (PST)
Message-ID: <9552a45f-6a26-e7fa-aa63-3c74a7d17261@gmail.com>
Date:   Sun, 12 Feb 2023 15:47:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [syzbot] BUG: bad usercopy in io_openat2_prep
Content-Language: en-US
To:     Kees Cook <kees@kernel.org>,
        syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org
References: <00000000000088b3d905f46ed421@google.com>
 <B83C9F6F-569B-4DCB-9FFE-45D9B1E32B21@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <B83C9F6F-569B-4DCB-9FFE-45D9B1E32B21@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 16:36, Kees Cook wrote:
> On February 11, 2023 8:08:52 AM PST, syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ca72d58361ee Merge branch 'for-next/core' into for-kernelci
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14a882f3480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f3e78232c1ed2b43
>> dashboard link: https://syzkaller.appspot.com/bug?extid=cdd9922704fc75e03ffc
>> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>> userspace arch: arm64
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1203777b480000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c1ea3480000

I couldn't reproduce it, let's try latest io_uring first

#syz test: https://git.kernel.dk/linux.git for-6.3/io_uring


>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/e2c91688b4cd/disk-ca72d583.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/af105438bee6/vmlinux-ca72d583.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/4a28ec4f8f7e/Image-ca72d583.gz.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com
>>
>> usercopy: Kernel memory overwrite attempt detected to SLUB object 'pid' (offset 24, size 24)!
> 
> This looks like some serious memory corruption. The pid slab is 24 bytes in size, but struct io_open is larger... Possible UAF after the memory being reallocated to a new slab??
> 
> -Kees
> 
>> [...]
>> Call trace:
>> usercopy_abort+0x90/0x94
>> __check_heap_object+0xa8/0x100
>> __check_object_size+0x208/0x6b8
>> io_openat2_prep+0xcc/0x2b8
>> io_submit_sqes+0x338/0xbb8
>> __arm64_sys_io_uring_enter+0x168/0x1308
>> invoke_syscall+0x64/0x178
>> el0_svc_common+0xbc/0x180
>> do_el0_svc+0x48/0x110
>> el0_svc+0x58/0x14c
>> el0t_64_sync_handler+0x84/0xf0
>> el0t_64_sync+0x190/0x194
> 
> 
> 

-- 
Pavel Begunkov
