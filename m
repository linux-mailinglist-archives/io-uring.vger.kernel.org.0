Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520A3507652
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244124AbiDSRRN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 13:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiDSRRM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 13:17:12 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08473B578
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 10:14:28 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i196so12956306ioa.1
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=P0VhzWTtiWglpqEsLIIkys7l4c14UtMWJugXjxiKB90=;
        b=TxFWEw7V8eUHQxXus9LdWXXxPSHtKlSd0raikrK5cVq+LGYH+SwrLwhvh48Qjp/MCH
         Fn7mnAtuDcfmL5dVkOYBaCkBYAKwr+mDa0rqppdGQuB6UL9YcZahkauVVxKOoxDbfmjA
         FPX0E3b2/kIEXkqmWbcBRD2esWAnO+cnApxusiH8Yzl+8D2FtYN9PJ/zm3Mlj4086a9g
         vx8D2Sgg1eftWT2uVxJLcg6CSu+d0Zz6nvRW3wldKtZn2yT8/4LOLajxjTNsGelQINqL
         zhnP6Jb4BpKg870UeQt8EoJGqp/AffGymPLi2KVdAQWaaCYeIlhu57DDnA/2w4WTBX1S
         QUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=P0VhzWTtiWglpqEsLIIkys7l4c14UtMWJugXjxiKB90=;
        b=tmuXeZi7gNJYEecpwWRBb+EUOg6u6sYcrn230LMesxt1MtrfKETT/cTRfpfqGmGS3m
         UgKsmL1od6YCF0bVhrPxzpQ+R/s7BjkbSUMjyk2Z7q7XlZ04llkS129esgQt9RIoml6I
         tJoMThEIRZ5nDqKRCUBpesC5GRyozyMtenE4Fn4XdGKNYhlAZ+Hs4G+Skp6a0vxFHTP6
         /vKCuK2R/IGVSA/RKDMUgF9SKAPcyMxDnjEYjal4BruAnfqWombM+GXqkLJGqUfPw32D
         KhetnGTfboOgpeaNmfxIamUa8vDgV5KWzI0kfD0JVMBXP3GC0QFn0kmi73DgBemHWF9L
         3upA==
X-Gm-Message-State: AOAM530MbdcIj7v4emODUHjqCI4Wu4sx0UtuB7IJrb08MmAJlpUQZRtq
        V1i54g9uROJqs9ibH9ZfMETL/FxdLfeh8Q==
X-Google-Smtp-Source: ABdhPJx5+pQ0VDemhoKiltTuWlC7VsZHOTWjCnwPZKI9Az7+/9E5AjuF+WsIICDXKiIvpUTjcF3a6A==
X-Received: by 2002:a6b:ed06:0:b0:649:d35f:852c with SMTP id n6-20020a6bed06000000b00649d35f852cmr7292045iog.186.1650388468196;
        Tue, 19 Apr 2022 10:14:28 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r14-20020a92d98e000000b002cbe036560bsm8960901iln.12.2022.04.19.10.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 10:14:27 -0700 (PDT)
Message-ID: <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
Date:   Tue, 19 Apr 2022 11:14:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
In-Reply-To: <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 9:21 AM, Jens Axboe wrote:
> On 4/19/22 6:31 AM, Jens Axboe wrote:
>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>
>>>>>>>
>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>> inline completion vs workqueue completion:
>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>> completions.
>>>>>
>>>>> I measured this:
>>>>>
>>>>>
>>>>>
>>>>>   Performance counter stats for 'system wide':
>>>>>
>>>>>           1,273,756 io_uring:io_uring_task_add
>>>>>
>>>>>        12.288597765 seconds time elapsed
>>>>>
>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>> counter.
>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>> expected.
> 
> Might actually be implicated. Not because it's a async worker, but
> because I think we might be losing some affinity in this case. Looking
> at traces, we're definitely bouncing between the poll completion side
> and then execution the completion.
> 
> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
> me know what base you prefer, I can do a version against that. I see
> about a 3% win with io_uring with this, and was slower before against
> linux-aio as you saw as well.

Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
believe may be the underlying cause of it.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 32aeb2c581c5..59987dd212d8 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -871,7 +871,7 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
-	set_notify_signal(worker->task);
+	set_notify_signal(worker->task, true);
 	wake_up_process(worker->task);
 	return false;
 }
@@ -991,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 {
 	if (work && match->fn(work, match->data)) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		set_notify_signal(worker->task);
+		set_notify_signal(worker->task, true);
 		return true;
 	}
 
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3c8b34876744..ac1f14973e09 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -359,10 +359,10 @@ static inline void clear_notify_signal(void)
  * Called to break out of interruptible wait loops, and enter the
  * exit_to_user_mode_loop().
  */
-static inline void set_notify_signal(struct task_struct *task)
+static inline void set_notify_signal(struct task_struct *task, bool need_ipi)
 {
 	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
-	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+	    !wake_up_state(task, TASK_INTERRUPTIBLE) && need_ipi)
 		kick_process(task);
 }
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5d03a2ad1066..bff53f539933 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -367,7 +367,7 @@ static void klp_send_signals(void)
 			 * Send fake signal to all non-kthread tasks which are
 			 * still not migrated.
 			 */
-			set_notify_signal(task);
+			set_notify_signal(task, true);
 		}
 	}
 	read_unlock(&tasklist_lock);
diff --git a/kernel/task_work.c b/kernel/task_work.c
index c59e1a49bc40..47d7024dc499 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -51,7 +51,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		set_notify_signal(task);
+		set_notify_signal(task, false);
 		break;
 	default:
 		WARN_ON_ONCE(1);

-- 
Jens Axboe

