Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0E57A06F0
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239719AbjINOKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbjINOKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 10:10:19 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA281A2;
        Thu, 14 Sep 2023 07:10:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-500913779f5so1709628e87.2;
        Thu, 14 Sep 2023 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694700613; x=1695305413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ff2smVWjK7Bcd33u1xwQxm/zbvIof/RmQVV4BlHgZCI=;
        b=bwZmstpIm1wvrebX9ZGky0Wlv+6ljEDiRpboTco/2iKaHcJQV6a9MMdju047XCD3Ni
         I+kN1MVarFzY5CKGVl4Y+M2R9yLwGGoRC9cDLbFKIfio/NXI8WU4jHfsTUbS2ABYh3y3
         kyKQriZIC5lJVCOsvltDzSHP1CxOizCZM3RPSa0FMec8lM+Vw+1QSwwAZxfjuUONOajr
         sCUPAePQrlA+XW4aJ6BJCFD6vX3KeU5oQUiDp4buRGGPmqV4E+0hronJIBDU//GouvK0
         8Cikl9T2OFudgYMYXZ8n3+WqbARa+XAxZC5EK4+Qq/LSHUsM7ZSE2WdcU2mukQ3lB82o
         ZFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694700613; x=1695305413;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ff2smVWjK7Bcd33u1xwQxm/zbvIof/RmQVV4BlHgZCI=;
        b=k9iR5cBTJaXj23K8841g1nWLKo84Mpi8PXVf9oMqwW/4e9beAIUiRIbZ+cVqf71Gj7
         O7pthhufRYZPazq68cJS4h8gtE5C2nPV/tIiBPSY2v3yLyaMi73OwnbqfAsLjDfaxxmu
         7JtMLh0exh5wFqfS0Oc9W2mSYErXUeRCCWCihP3SAjBZBIMZxruCyniY9ilkdDUlDcnS
         Dc39oLFeNkrSsNiXSW9bLGKKq9+t3r0KFUNrwjB8R2zZ+S/ZmtIITGNdc91YcGXTbtsK
         rWkvWNzozWUHaF6gXTyQ8ork0YLOke1mKTuYzXg+VqZE7T8D2ZBHYPDoSfAOcH0K8dXW
         ie8Q==
X-Gm-Message-State: AOJu0YzAR+RkQQoF8PzGo+K30WARaiITJXRRHzaZBRlw3ocFe45RBT+m
        PXjutfTHpB7OkAIR6iYKLwM=
X-Google-Smtp-Source: AGHT+IFt2SsAcVqIZdtIn5+HS/JXbfUNWZaTcxCBpsfU+ve85sLDRrU8FVC1JxI6PJHYSqJPTC5HhQ==
X-Received: by 2002:a05:6512:108f:b0:502:9fce:b6da with SMTP id j15-20020a056512108f00b005029fceb6damr6187058lfg.21.1694700612508;
        Thu, 14 Sep 2023 07:10:12 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id z7-20020aa7cf87000000b0052718577668sm961495edx.11.2023.09.14.07.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 07:10:12 -0700 (PDT)
Message-ID: <d27afdc7-7251-61b0-2311-ba2e27e73682@gmail.com>
Date:   Thu, 14 Sep 2023 15:08:09 +0100
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

Couldn't repro myself, I think this is the fix

#syz test: https://github.com/isilence/linux.git netmsg-init

-- 
Pavel Begunkov
