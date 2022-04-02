Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16464EFDB2
	for <lists+io-uring@lfdr.de>; Sat,  2 Apr 2022 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbiDBBTD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 21:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiDBBTC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 21:19:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EB1066D9
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 18:17:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u12so1679810plg.10
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 18:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=UMtPvlYTR6AQE1N5bSrGUBnNrN2gVn2SJixXNFPGPrc=;
        b=U2u05iX7pkbtjDqECz56AzVASGzMvT1G6vm72dRB+dnEf1UYJn282lnWza5UyAI3Xm
         jNXz6iJju/94hZWQfAyFvpCIw/k+bht20woG2XqojLALYTQ8NUYRrNmn7rRTktUkQqJD
         NgdDTOYdv+yxeIRn7NtMg49EXeMpnV8mWBjXbLty8nT4Ykccnf6kpoicrlbW2rq8b32o
         svCs/UZxlto4Phj3qFO46tMslFo8BqFtNUyaEk/W/5MBem2b3BqfPiUI2NkBB0c7guDC
         7/yqt5FFRH6EK57cxq9UYWU1wNnXjiSMAJ+knSi3uJ6HHOQfzyGjyMNNfX/7JAyspzab
         pWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=UMtPvlYTR6AQE1N5bSrGUBnNrN2gVn2SJixXNFPGPrc=;
        b=26UTgWAu+pXWY7LSkVp9+dHonPpbC1mNXAMnn1IIKKpVzJKyyITyuXukVYVqvm+C/o
         +gmHe9eFkGFKiBYbRUtauQf9X0nHKLhwBZ8WRmx7N4FAe3PrbUO9R3hAdMI5JvRboSjQ
         bkZvisvhe3O63HXu9zuhihPqQ2eBs9JCRVnL28GI5bLsMiR891U+BFvZcqPI0lkP7W48
         ijfiEGoPa9+OPU2eF0NHXwTbb2ru2H1Pma+J0tmJZHTM8RHf54zvgYZNI6lgLZLULOY3
         3Ku5g3SEDPQoCnyP8x3toJLaevB+hadhufDgXJs+2Lk/AkYQ7L1docB5VudGmwIg/YEi
         AzkQ==
X-Gm-Message-State: AOAM533XGtPWOS1oXMW3N80M9FNwMLb3lfcWAvV9Sb6AK48j/IJqsIQH
        RqBYwhBKbZzwYQVxf+hyWnkM51FqEnVqMw==
X-Google-Smtp-Source: ABdhPJzWd6ZnWVYDt4vlVo5JVSTNEM/DGSGxC+L+OU5NJJfABpESvm1YoNwlnY9YNPRmtr7kLFrpoQ==
X-Received: by 2002:a17:902:e8d2:b0:156:32bf:b1b9 with SMTP id v18-20020a170902e8d200b0015632bfb1b9mr12886568plg.107.1648862231305;
        Fri, 01 Apr 2022 18:17:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b10-20020a056a00114a00b004f784ba5e6asm4541577pfm.17.2022.04.01.18.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 18:17:10 -0700 (PDT)
Message-ID: <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
Date:   Fri, 1 Apr 2022 19:17:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
 <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
 <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk>
 <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk>
In-Reply-To: <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/22 10:21 AM, Jens Axboe wrote:
> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> I take it you're continually reusing those slots?
>>
>> Yes.
>>
>>>  If you have a test
>>> case that'd be ideal. Agree that it sounds like we just need an
>>> appropriate breather to allow fput/task_work to run. Or it could be the
>>> deferral free of the fixed slot.
>>
>> Adding a breather could make the worst case latency be large.  I think
>> doing the fput synchronously would be better in general.
> 
> fput() isn't sync, it'll just offload to task_work. There are some
> dependencies there that would need to be checked. But we'll find a way
> to deal with it.
> 
>> I test this on an VM with 8G of memory and run the following:
>>
>> ./forkbomb 14 &
>> # wait till 16k processes are forked
>> for i in `seq 1 100`; do ./procreads u; done
>>
>> You can compare performance with plain reads (./procreads p), the
>> other tests don't work on public kernels.
> 
> OK, I'll check up on this, but probably won't have time to do so before
> early next week.

Can you try with this patch? It's not complete yet, there's actually a
bunch of things we can do to improve the direct descriptor case. But
this one is easy enough to pull off, and I think it'll fix your OOM
case. Not a proposed patch, but it'll prove the theory.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e199040f151..d52cd9c98d6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,7 +231,7 @@ struct io_rsrc_put {
 	u64 tag;
 	union {
 		void *rsrc;
-		struct file *file;
+		unsigned long file_ptr;
 		struct io_mapped_ubuf *buf;
 	};
 };
@@ -1601,7 +1601,12 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 #define FFS_NOWAIT		0x1UL
 #define FFS_ISREG		0x2UL
-#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
+#if defined(CONFIG_64BIT)
+#define FFS_DIRECT		0x4UL
+#else
+#define FFS_DIRECT		0x0UL
+#endif
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG|FFS_DIRECT)
 
 static inline bool io_req_ffs_set(struct io_kiocb *req)
 {
@@ -7443,12 +7448,19 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return (struct file *) (slot->file_ptr & FFS_MASK);
 }
 
-static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file)
+static bool io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file,
+			      bool direct_descriptor)
 {
 	unsigned long file_ptr = (unsigned long) file;
+	bool ret = false;
 
 	file_ptr |= io_file_get_flags(file);
+	if (direct_descriptor) {
+		file_ptr |= FFS_DIRECT;
+		ret = true;
+	}
 	file_slot->file_ptr = file_ptr;
+	return ret;
 }
 
 static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
@@ -8917,7 +8929,7 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
-	struct file *file = prsrc->file;
+	struct file *file = (struct file *) (prsrc->file_ptr & FFS_MASK);
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -9083,7 +9095,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
+		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file,
+					false);
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -9166,6 +9179,20 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 	return 0;
 }
 
+static int io_queue_file_removal(struct io_rsrc_data *data, unsigned idx,
+				 struct io_rsrc_node *node,
+				 unsigned long file_ptr)
+{
+	struct file *file = (struct file *) (file_ptr & FFS_MASK);
+
+	if (file_ptr & FFS_DIRECT) {
+		fput(file);
+		return 0;
+	}
+
+	return io_queue_rsrc_removal(data, idx, node, file);
+}
+
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
 {
@@ -9189,15 +9216,13 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
 
 	if (file_slot->file_ptr) {
-		struct file *old_file;
-
 		ret = io_rsrc_node_switch_start(ctx);
 		if (ret)
 			goto err;
 
-		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
-					    ctx->rsrc_node, old_file);
+		ret = io_queue_file_removal(ctx->file_data, slot_index,
+					    ctx->rsrc_node,
+					    file_slot->file_ptr);
 		if (ret)
 			goto err;
 		file_slot->file_ptr = 0;
@@ -9205,13 +9230,13 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	}
 
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
-	io_fixed_file_set(file_slot, file);
-	ret = io_sqe_file_register(ctx, file, slot_index);
-	if (ret) {
-		file_slot->file_ptr = 0;
-		goto err;
+	if (!io_fixed_file_set(file_slot, file, true)) {
+		ret = io_sqe_file_register(ctx, file, slot_index);
+		if (ret) {
+			file_slot->file_ptr = 0;
+			goto err;
+		}
 	}
-
 	ret = 0;
 err:
 	if (needs_switch)
@@ -9228,7 +9253,6 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_fixed_file *file_slot;
-	struct file *file;
 	int ret, i;
 
 	io_ring_submit_lock(ctx, needs_lock);
@@ -9248,8 +9272,8 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (!file_slot->file_ptr)
 		goto out;
 
-	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	ret = io_queue_file_removal(ctx->file_data, offset,
+				    ctx->rsrc_node, file_slot->file_ptr);
 	if (ret)
 		goto out;
 
@@ -9298,9 +9322,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
 		if (file_slot->file_ptr) {
-			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_file_removal(data, up->offset + done,
+						    ctx->rsrc_node,
+						    file_slot->file_ptr);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -9326,7 +9350,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			*io_get_tag_slot(data, up->offset + done) = tag;
-			io_fixed_file_set(file_slot, file);
+			io_fixed_file_set(file_slot, file, false);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
 				file_slot->file_ptr = 0;

-- 
Jens Axboe

