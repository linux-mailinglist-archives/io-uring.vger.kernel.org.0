Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68CB5372D9
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 00:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiE2WvN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 18:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiE2WvN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 18:51:13 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF066AC4
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 15:51:11 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v4-20020a1cac04000000b00397001398c0so7455274wme.5
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 15:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ohaSIe3ZLoiouAOpEowRJFCdgxYXMabjjCo0Hrs/oHI=;
        b=l7JOPp59SPBM7U79hU+1GPdkRGwfuW2fKk/67/4IcT/4H/qBb5pITiSmB51MZbTesP
         0/NoM59tgKw7rgV58wangiFQh0joQ0RmOovhaJdXV/o8yD9KdMx/qj16gDmzf6SP2WZb
         VhHHAO78go1clBPndAWPbrGco79h6jF8MBs6uEkjTfh7HeBUl+CCguQkmKsPd0LBDGNh
         sJiY+c4g1Ys2PLNQzZx60KdJBZUiUNMCJccguPyfs/qyeOSh7rldVYT+toeWlOPs7DDe
         oVq1IOU8M6cLi2ZLw38KGukGJ1D5C/SS73fDRapFxo+gJo6dWlrjz9IYxr9nibnj/cWk
         E2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ohaSIe3ZLoiouAOpEowRJFCdgxYXMabjjCo0Hrs/oHI=;
        b=Dv7Mgwx2g7wYQERzCTFV8Ynww8TF9aZY4zQ1qrODsBnRDZe6nn2JsDon0iXZ7zQk8d
         6eGXCiAHQZ3ic6srJQRVvkvAICpH+suaP9Mjmz4tZGTPhunYwIrgXpvXE86EAu07DOkS
         wMaZG+s2d9giYNuDTIBNan+dE/AsXI7f+/jgl0ut7tZUixIrgHj61uchYhox7u0ORW1f
         8ILVlAbLs3s9N2PEqaL29NxF+h7dQwFI/8g+kGSOFxcvLVQt4r63jwxHwpIfobZxoY/m
         HF/QJfr5B1vYBK49L8tH2mG3IlIEZlIznS0WMyQEMTwzwoLLntRlByBpduNcXLH9GDL5
         LXVQ==
X-Gm-Message-State: AOAM5312Y/QVjqob/LtcPDNbwlzWSzbbw+2N26+ojmttACNUn3v6IJt5
        KVCeSfATv8cHbyRaxr3BDW4=
X-Google-Smtp-Source: ABdhPJzxV4tvvOhaE/tAH9GDQdkHD7RJDWoJ9UFuQoWci7tAyt8WyzRKQVvIG8EaQUEpGMCkSqIEfA==
X-Received: by 2002:a05:600c:257:b0:397:4106:5150 with SMTP id 23-20020a05600c025700b0039741065150mr16364277wmj.163.1653864670177;
        Sun, 29 May 2022 15:51:10 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id bi12-20020a05600c3d8c00b003974b95d897sm8259261wmb.37.2022.05.29.15.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 15:51:09 -0700 (PDT)
Message-ID: <d476c344-56ea-db57-052a-876605662362@gmail.com>
Date:   Sun, 29 May 2022 23:50:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu.linux@icloud.com>,
        io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/22 19:40, Jens Axboe wrote:
> On 5/29/22 12:07 PM, Hao Xu wrote:
>> On 5/30/22 00:25, Jens Axboe wrote:
>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>> invocation and remove contension between different cancel_hash entries
>>>
>>> Interesting, do you have any numbers on this?
>>
>> Just Theoretically for now, I'll do some tests tomorrow. This is
>> actually RFC, forgot to change the subject.
>>
>>>
>>> Also, I'd make a hash bucket struct:
>>>
>>> struct io_hash_bucket {
>>>      spinlock_t lock;
>>>      struct hlist_head list;
>>> };
>>>
>>> rather than two separate structs, that'll have nicer memory locality too
>>> and should further improve it. Could be done as a prep patch with the
>>> old locking in place, making the end patch doing the per-bucket lock
>>> simpler as well.
>>
>> Sure, if the test number make sense, I'll send v2. I'll test the
>> hlist_bl list as well(the comment of it says it is much slower than
>> normal spin_lock, but we may not care the efficiency of poll
>> cancellation very much?).
> 
> I don't think the bit spinlocks are going to be useful, we should
> stick with a spinlock for this. They are indeed slower and generally not
> used for that reason. For a use case where you need a ton of locks and
> saving the 4 bytes for a spinlock would make sense (or maybe not
> changing some struct?), maybe they have a purpose. But not for this.

We can put the cancel hashes under uring_lock and completely kill
the hash spinlocking (2 lock/unlock pairs per single-shot). The code
below won't even compile and missing cancellation bits, I'll pick it
up in a week.

Even better would be to have two hash tables, and auto-magically apply
the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
and apoll (need uring_lock after anyway).


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6be21967959d..191fa7f31610 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7120,12 +7120,20 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
  	}
  
  	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	__io_req_complete_post(req, req->cqe.res, 0);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+
+	if (ctx->flags & IORING_MUTEX_HASH) {
+		io_tw_lock(ctx, locked);
+		hash_del(&req->hash_node);
+		io_req_complete_state(req, req->cqe.res, 0);
+		io_req_add_compl_list(req);
+	} else {
+		spin_lock(&ctx->completion_lock);
+		hash_del(&req->hash_node);
+		__io_req_complete_post(req, req->cqe.res, 0);
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
+	}
  }
  
  static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
@@ -7138,9 +7146,14 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
  		return;
  
  	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
+	if (ctx->flags & IORING_MUTEX_HASH) {
+		io_tw_lock(ctx, locked);
+		hash_del(&req->hash_node);
+	} else {
+		spin_lock(&ctx->completion_lock);
+		hash_del(&req->hash_node);
+		spin_unlock(&ctx->completion_lock);
+	}
  
  	if (!ret)
  		io_req_task_submit(req, locked);
@@ -7332,9 +7345,13 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
  		return 0;
  	}
  
-	spin_lock(&ctx->completion_lock);
-	io_poll_req_insert(req);
-	spin_unlock(&ctx->completion_lock);
+	if (ctx->flags & IORING_MUTEX_HASH) {
+		io_poll_req_insert(req);
+	} else {
+		spin_lock(&ctx->completion_lock);
+		io_poll_req_insert(req);
+		spin_unlock(&ctx->completion_lock);
+	}
  
  	if (mask) {
  		/* can't multishot if failed, just queue the event we've got */
