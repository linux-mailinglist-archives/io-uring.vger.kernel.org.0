Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35BC571ED7
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiGLPUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 11:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiGLPTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 11:19:39 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A60F60DF;
        Tue, 12 Jul 2022 08:16:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJ8npQf_1657638965;
Received: from 30.227.94.73(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VJ8npQf_1657638965)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 23:16:06 +0800
Message-ID: <afed0772-3626-44e6-a33c-7134a7d623f0@linux.alibaba.com>
Date:   Tue, 12 Jul 2022 23:16:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <c8e593e6-105f-7a69-857f-5b91ecd3b801@linux.alibaba.com>
 <YswtwnJuWG+55NM1@T590>
 <0697cae5-f366-6f69-be39-96f060d8c586@linux.alibaba.com>
 <Ys1bTrVd+L5zYODg@T590>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <Ys1bTrVd+L5zYODg@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

>>>
>>> If we adopt to pass one io_uring fd per queue when starting device,
>>> blk-mq's queue_rq() will get corresponding io_uring file for this queue and
>>> use it to generate cqes directly to notify new io commands inserted,
>>> then UBLK_CMD_START_DEV doesn't need to wait, and can be in the
>>> same thread with ublksrv_queue_init or ublksrv_process_io.
>>> Seems that for demo_null.c, they are still in different threads.
>>>
>>> For current io_uring implementation, one sqe may generate one or more
>>> cqes, but indeed, we can generate cqes without submitting sqes, just
>>> fill one event to io_uring ctx.
>>> Just suggestions :)
> I don't have any interest in so unusual usage of io_uring, especially it
> needs fundamental change in io_uring.
Got it, I see your point now and will respect that.

>
> Compared with kernel side change, removing waiting until queue setup in
> userspace side simplifies nothing.
>
> You still need io_kiocb/io_uring_cmd and both are allocated in
> submission code path, since 'io_ring_ctx' is private for
> io_uring.
>
> And ublk server still needs one command to send io result to ublk driver,
> that said this way saves nothing for us cause ublk driver uses single
> command for both fetching io request and committing io result.
>
> Easy to say than done, you may try to write a patch to verify your
> ideas, especially no one uses io_ring in this way.
I have done a hack change in io_uring:
iff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ff2cdb425bc..e6696319148e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11958,6 +11958,21 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
        return 0;
 }

+static u64 tst_count;
+
+static void io_gen_cqe_direct(struct file *file)
+{
+       struct io_ring_ctx *ctx;
+       ctx = file->private_data;
+
+       printk(KERN_ERR "tst_count %llu\n", tst_count);
+       spin_lock(&ctx->completion_lock);
+       io_fill_cqe_aux(ctx, tst_count++, 0, 0);
+       io_commit_cqring(ctx);
+       spin_unlock(&ctx->completion_lock);
+       io_cqring_ev_posted(ctx);
+}
+
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
                u32, min_complete, u32, flags, const void __user *, argp,
                size_t, argsz)
@@ -12005,6 +12020,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
        if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
                goto out;

+       io_gen_cqe_direct(f.file);
        /*
         * For SQ polling, the thread will do all submissions and completions.
         * Just return the requested submit count, and wake the thread if

And in user-space:
ret = io_uring_queue_init(QD, &ring, 0);

for (i = 0; i < 100; i++) {
    io_uring_submit_and_wait(&ring, 0);
    io_uring_wait_cqe(&ring, &cqe);
    printf("lege user_data %llu\n", cqe->user_data);
    io_uring_cqe_seen(&ring, cqe);
}

Now user-space app will get cqes continually, by it does not submit any sqes.
Indeed, io_fill_cqe_aux() has been used somewhere in kernel io_uring, for example,
sent one cqe from one io_uring instance to another instance.

I had planned to use io_gen_cqe_direct() in ublk's queue_rq to notify io requests
inserted. But now I'm fine that dropping this idea.
>
>> As I said before, there maybe such benefits:
>> 1. may decouple io command descriptor acquire and io command handling well.
>> At least helper like tcmulib_get_next_command maybe added easily. I'm not sure, some
>> applications based on tcmu previously may need this helper.
> Why do we need similar helper of tcmulib_get_next_command()? for what
> purpose? In current design of ublk server, it should be enough for target
> code to focus on ->handle_io_async(), ->target_io_done() in case of handling
> target io via ubq io_uring, ->handle_event() in case of handling target io in
> other contexts.
I'll have a deep think about it. Initially I tried to make libublk offer
similar programming interface to libtcmu, so apps can switch to ublk
easily, but indeed they maybe totally different things.

Sorry for noises again.
>
> ublk server is one io_uring application, and interfaces provided
> are based on io_uring design/interfaces. I guess TCMU isn't based on
> io_uring, so it may have original style interface. You may ask
> TCMU guys if it is possible to reuse current interface for supporting
> io_uring with expected performance.
>
>> 2. UBLK_CMD_START_DEV won't need to wait another thread context to submit
>> number of queue depth of sqes firstly, but I admit that it's not a big issue.
> Yeah, it simplifies nothing, compared with fundamental io_uring change
> and ublk driver side change.
>
>>
>> I admit batch will be good, and syscalls userspace and kernel context switch
>> introduce overhead. But for big io requests, batch in one context is not good. In
>> the example of read requests, if io request is big, say 1MB, io_uring will do
>> commit req sequentially, which indeed mainly do memcpy work. But if users
>> can choose to issue multiple ioctls which do commit req concurrently, I think
>> user may get higher io throughput.
> If BS is big, single job could saturate devices bw easily, multiple jobs won't
> make a difference, will it? Not mention sync cost among multiple jobs.n
No, I don't consider device scenes, at least for us, our target will visit distributed
file systems, which can offer very high io throughput, far greater than normal device.
>
> Not mention current ublk server does support multiple io jobs.
Yeah, I see that. But for read request, commit req commands will still be done
in ubq->ubq_daemon task context, and commit req commands mainly do memcpy work.

Regards,
Xiaoguang Wang

>
>> And in this case, user may not care userspace and kernel context switch overhead at all.
>>
>> Or to put it another way, should libublk offer synchronous programming interface ?
> It depends what the sync interface is.
>
> You can call sync read()/write() for target io directly in ->handdle_io_async(),
> or call them in other pthread(s) just by telling ubq after these sync ios are done
> with the eventfd API.
>
> demo_null.c is actually one such example.
>
>>> With ublk, usually we handle dozens or even more than hundred of IOs in
>>> single io_uring_enter() syscall.
>>>
>>>> io workers can run concurrently. Since GET_DATA(write request)
>>>> or COMMIT_REQ(read request) mainly do memcpy work, one
>>>> io_uring instance will just do these jobs sequentially, which may
>>>> not take advantage of multi-cpu.
>>> IMO you can implement target code to handle io in other pthreads against
>>> current libublksrv design, see demo_event.c. Or if you think it is still
>>> enough, please just share with us what the problem is. Without
>>> understanding the problem, I won't try to figure out any solution or
>>> change.
>> I need to read your ublk userspace codes carefully, if I made
> One small suggestion, you may start with the two builtin examples, both
> are simple & clean, and the big one is only 300+ LOC, really complicated?
>
>
> Thanks.
> Ming

