Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45F5673FFD
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjASRdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 12:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjASRdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 12:33:16 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE1E5593
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 09:33:14 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so1821088wms.2
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 09:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=99ojboZnNmPKgHgXG5Pa4m8j6QglL+OzQRGBJ/Nx/TU=;
        b=R/zpBd3pxGFNMpM+m35rLI7bYbcmlknNZz3lqxVFlmHCSRE6f6JJ+QJHayDaGtFibD
         pRkL9fZ5wUtAe2gCNsd1q+VqEcwMqpWs6oG0yLpc7O/6MqC7n+YJUBa6XuONuqmGCFIk
         fQAXJN8chEmXmDYNpgZGigHC3C7cjSWahhb3PBmaJ2oKExFMMK2/Mq4dFCfdU5FV6RUb
         2kEym8zz44euxrpqKRaa1Hz5rikINDjs4D1Rc+v/ar+j3Uvt2UhrIa6Ez/w1Hn2WwoJa
         NbJJtMRZjzq0Q2Q4DjHv+PJjhRsfYoSLQ1DB3wUsZdLs2yeFSdYE0xlZjLcwHE5/XsjS
         k7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99ojboZnNmPKgHgXG5Pa4m8j6QglL+OzQRGBJ/Nx/TU=;
        b=KKZtCkxhv/l3K9mp909FmuV8jEr1RLkCnWYR39wdBozluKNkd3O0C7GsYvEKsYGghD
         M82wdi5vx7P/YJ1ayNNWGRNXAopLE33SNZBgjyHxPiEdD+bVJ6miAkB8iYBBYymuusLr
         OJDBTMP5mjnKv+C2gHu7hvKHItH1jkpu2M3CxlFK6nUlZihHcytx/4Bpi0+q150zDOqF
         pqRGWhxZWpnXBhF1EvK4Aj4taEXwUVwaYtpO7Ykr1n9KXnRkDMUs/TidutJjzobiWMsk
         l3hNCcx3B/QF4igBhDS1yRRs2rxijncg8AgVDmY4OR8XuxeoBDTS9eZ2aVALb2oYX9iD
         ykOw==
X-Gm-Message-State: AFqh2kqzNQOzKt6HE0nOud1Jz5tl7PJ3iefjlh7IREP8xEYIg2KT4LhF
        Ld/GOt9aNRIJtzuPjlkFb5elYYKG7Z4=
X-Google-Smtp-Source: AMrXdXs2Wrx3J6lRVzdNoIzco/ycNXn5Yq3CcvQlH4YNRIstHodOMVJI+XmEHh0hlXu1UF4JkRVW7Q==
X-Received: by 2002:a05:600c:3ac8:b0:3da:270b:ba6b with SMTP id d8-20020a05600c3ac800b003da270bba6bmr11533356wms.41.1674149592992;
        Thu, 19 Jan 2023 09:33:12 -0800 (PST)
Received: from [192.168.8.100] (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id i16-20020a1c5410000000b003db01178b62sm5450573wmb.40.2023.01.19.09.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 09:33:12 -0800 (PST)
Message-ID: <e54c32f2-58ca-70ca-481e-ac7e9ffc05be@gmail.com>
Date:   Thu, 19 Jan 2023 17:31:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: WARNING in io_fill_cqe_aux
To:     Jens Axboe <axboe@kernel.dk>, Xingyuan Mo <hdthky0@gmail.com>
Cc:     syzkaller@googlegroups.com, io-uring@vger.kernel.org
References: <Y8krlYa52/0YGqkg@ip-172-31-85-199.ec2.internal>
 <6b21328e-d32c-3a54-0578-7a39412d4615@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6b21328e-d32c-3a54-0578-7a39412d4615@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/23 15:54, Jens Axboe wrote:
> On 1/19/23 4:37?AM, Xingyuan Mo wrote:
>> Hello,
>>
>> Recently, when using our tool to fuzz kernel, the following bug was
>> triggered.
>>
>> HEAD commit: 5dc4c995db9e Linux 6.2-rc4
>> git tree: mainline
>> compiler: gcc (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0
>> kernel config: https://drive.google.com/file/d/1anGeZxcTgSKNZX4oywvsSfLqw1tcZSTp/view?usp=share_link
>> C reproducer: https://drive.google.com/file/d/1DxYuWGnFSBhqve-jjXloYhwKpyUm8nDt/view?usp=share_link
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
>> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
>> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
>> Modules linked in:
>> CPU: 1 PID: 36200 Comm: syz-executor.0 Not tainted 6.2.0-rc4 #1
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>> RIP: 0010:io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
>> RIP: 0010:io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
>> RIP: 0010:io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
>> Code: fd 48 8d bb a8 00 00 00 be ff ff ff ff e8 dd 1b 02 06 31 ff 89 c5 89 c6 e8 c2 76 7e fd 85 ed 0f 85 44 fa ff ff e8 05 7a 7e fd <0f> 0b e9 38 fa ff ff e8 f9 79 7e fd 31 ff 89 ee e8 a0 76 7e fd 85
>> RSP: 0018:ffffc90015747b68 EFLAGS: 00010212
>> RAX: 000000000000016e RBX: ffff8881245b6000 RCX: ffffc90013881000
>> RDX: 0000000000040000 RSI: ffffffff8401f31b RDI: 0000000000000005
>> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
>> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881245b6018
>> FS:  00007fcf02ab4700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000001b2e024000 CR3: 00000001054e6000 CR4: 0000000000752ee0
>> PKRU: 55555554
>> Call Trace:
>>   <TASK>
>>   __io_post_aux_cqe root/linux-6.2-rc4/io_uring/io_uring.c:880 [inline]
>>   io_post_aux_cqe+0x3b/0x90 root/linux-6.2-rc4/io_uring/io_uring.c:890
>>   io_msg_ring_data root/linux-6.2-rc4/io_uring/msg_ring.c:74 [inline]
>>   io_msg_ring+0x5b9/0xb70 root/linux-6.2-rc4/io_uring/msg_ring.c:227
>>   io_issue_sqe+0x6c2/0x1210 root/linux-6.2-rc4/io_uring/io_uring.c:1856
>>   io_queue_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2028 [inline]
>>   io_submit_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2286 [inline]
>>   io_submit_sqes+0x96c/0x1e10 root/linux-6.2-rc4/io_uring/io_uring.c:2397
>>   __do_sys_io_uring_enter+0xc20/0x2540 root/linux-6.2-rc4/io_uring/io_uring.c:3345
>>   do_syscall_x64 root/linux-6.2-rc4/arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x39/0xb0 root/linux-6.2-rc4/arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fcf01c8f6cd
>> Code: c3 e8 17 32 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fcf02ab3bf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> RAX: ffffffffffffffda RBX: 00007fcf01dbbf80 RCX: 00007fcf01c8f6cd
>> RDX: 0000000000000000 RSI: 0000000000007b84 RDI: 0000000000000004
>> RBP: 00007fcf01cfcb05 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007fcf01edfb2f R14: 00007fcf01edfcd0 R15: 00007fcf02ab3d80
>>   </TASK>
> 
> I think this should fix it. Pavel?

Looking that you added uring_lock locking, was the target
ring IOPOLL? If so sounds right and a comment below


> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 2d3cd945a531..c98e9c74054b 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
[...]
> +
>   void io_msg_ring_cleanup(struct io_kiocb *req)
>   {
>   	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
> @@ -43,20 +65,25 @@ static void io_msg_tw_complete(struct callback_head *head)
>   	struct io_ring_ctx *target_ctx = req->file->private_data;
>   	int ret = 0;
>   
> -	if (current->flags & PF_EXITING)
> +	if (current->flags & PF_EXITING) {
>   		ret = -EOWNERDEAD;
> -	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> -		ret = -EOVERFLOW;
> +	} else {
> +		mutex_lock(&target_ctx->uring_lock);

It can be be conditional or could use a comment that it's only
necessary in case of IOPOLL ring.


> +		if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> +			ret = -EOVERFLOW;
> +		mutex_unlock(&target_ctx->uring_lock);
> +	}
>   
>   	if (ret < 0)
>   		req_set_fail(req);
>   	io_req_queue_tw_complete(req, ret);
>   }
>   

-- 
Pavel Begunkov
