Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4781F54C592
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbiFOKMf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243110AbiFOKMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:12:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5ACE17
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:12:27 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kq6so22192671ejb.11
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=NZtp0PDdpP3vrPOrbSVPbusd+tgyDNm9wgeH6U6kKUs=;
        b=2dqTS46km6NCYEBdzKSnZmT8s4w/nE4xDdMDvIQWLzfSNR6q56ReT1BqS9Otty02Oi
         jFVm2G9bbweP7eXouFO//1mhZxapZjc9lf/4t+K1/WPOu9ndGluooTOmMyGBdl6WvSYS
         d3NvNTacjrFlFGStSbYD7D6vmouDm8VWrmqVrFyz2+GFRFDAfGexfEgbS9dK+IZIw11T
         XLD3v88DcjwXKLvZpEYZn1JqLzA2tpuxmL53wL6pQQ6Jog2oEt/6h3pgH5lASqXTaOc5
         9D4+aoF7IeICkkSIakRkz4JrpDK7GVwv4pfakAodFNrIfPXbZowxVKj3B6JWcb4BFdP+
         BDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=NZtp0PDdpP3vrPOrbSVPbusd+tgyDNm9wgeH6U6kKUs=;
        b=gK2Q/RbnUQqL0rCU3jxGFkgZxzP8M0gK7DTSRnuqVDIx2ra6wROZa2P61xecsIBpt5
         q4Th0sY2vsnSbXrGF/hnRSLFUysl+oIXqcAtQIHoQGqrxZcrZY2MOqJFoH51gfEKB8sn
         AgKfSbJVWYI2HjWvIXr084lDlleeZS8vYiB53qdH7OP5251pfuHjGpsr+NqY0J/aXMOQ
         EJzfWVLTDu+MFPSgueXX/YySo4u0pf37fkhQ4Z3QZ1O0inkw0Sl1y4MRxTlND0vDVOwj
         sHqpBp9l1XWwtWLJ67AltuPhi+hWPQg2A3v9cf19vscsnJy+eca8+OwxHk4Hx/ORlCAv
         40Jg==
X-Gm-Message-State: AOAM533OiEoB462Yv/mOfVAZgiu51wdP34mf7mpyPIyf87EJR4Wpljog
        hG73nNGYN18kwpKHedDZ3IHlgU4AP9qgXE2u
X-Google-Smtp-Source: ABdhPJw60DoQj0vUbPj2pzoeCMb4mgLLcoQ3DnK7Mw58iUcttgUqx9wu+KxjJShe6boEbOJ19KC+aQ==
X-Received: by 2002:a17:906:7486:b0:6fe:ffd9:b14f with SMTP id e6-20020a170906748600b006feffd9b14fmr7975715ejl.573.1655287945746;
        Wed, 15 Jun 2022 03:12:25 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id rv16-20020a17090710d000b006fec8e8eff6sm6154028ejb.176.2022.06.15.03.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:12:25 -0700 (PDT)
Message-ID: <1d79b0e6-ee65-6eab-df64-3987a7f7f4e7@scylladb.com>
Date:   Wed, 15 Jun 2022 13:12:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 19/04/2022 20.14, Jens Axboe wrote:
> On 4/19/22 9:21 AM, Jens Axboe wrote:
>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>
>>>>>>>>
>>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>>> inline completion vs workqueue completion:
>>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>>> completions.
>>>>>> I measured this:
>>>>>>
>>>>>>
>>>>>>
>>>>>>    Performance counter stats for 'system wide':
>>>>>>
>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>
>>>>>>         12.288597765 seconds time elapsed
>>>>>>
>>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>>> counter.
>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>> expected.
>> Might actually be implicated. Not because it's a async worker, but
>> because I think we might be losing some affinity in this case. Looking
>> at traces, we're definitely bouncing between the poll completion side
>> and then execution the completion.
>>
>> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
>> me know what base you prefer, I can do a version against that. I see
>> about a 3% win with io_uring with this, and was slower before against
>> linux-aio as you saw as well.
> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
> believe may be the underlying cause of it.
>

Resurrecting an old thread. I have a question about timeliness of 
completions. Let's assume a request has completed. From the patch, it 
appears that io_uring will only guarantee that a completion appears on 
the completion ring if the thread has entered kernel mode since the 
completion happened. So user-space polling of the completion ring can 
cause unbounded delays.


If this is correct (it's not unreasonable, but should be documented), 
then there should also be a simple way to force a kernel entry. But how 
to do this using liburing? IIUC if I the following apply:


  1. I have no pending sqes

  2. There are pending completions

  3. There is a completed event for which a completion has not been 
appended to the completion queue ring


Then io_uring_wait_cqe() will elide io_uring_enter() and the 
completed-but-not-reported event will be delayed.


> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 32aeb2c581c5..59987dd212d8 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -871,7 +871,7 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
>   
>   static bool io_wq_worker_wake(struct io_worker *worker, void *data)
>   {
> -	set_notify_signal(worker->task);
> +	set_notify_signal(worker->task, true);
>   	wake_up_process(worker->task);
>   	return false;
>   }
> @@ -991,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
>   {
>   	if (work && match->fn(work, match->data)) {
>   		work->flags |= IO_WQ_WORK_CANCEL;
> -		set_notify_signal(worker->task);
> +		set_notify_signal(worker->task, true);
>   		return true;
>   	}
>   
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 3c8b34876744..ac1f14973e09 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -359,10 +359,10 @@ static inline void clear_notify_signal(void)
>    * Called to break out of interruptible wait loops, and enter the
>    * exit_to_user_mode_loop().
>    */
> -static inline void set_notify_signal(struct task_struct *task)
> +static inline void set_notify_signal(struct task_struct *task, bool need_ipi)
>   {
>   	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
> -	    !wake_up_state(task, TASK_INTERRUPTIBLE))
> +	    !wake_up_state(task, TASK_INTERRUPTIBLE) && need_ipi)
>   		kick_process(task);
>   }
>   
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5d03a2ad1066..bff53f539933 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -367,7 +367,7 @@ static void klp_send_signals(void)
>   			 * Send fake signal to all non-kthread tasks which are
>   			 * still not migrated.
>   			 */
> -			set_notify_signal(task);
> +			set_notify_signal(task, true);
>   		}
>   	}
>   	read_unlock(&tasklist_lock);
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index c59e1a49bc40..47d7024dc499 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -51,7 +51,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>   		set_notify_resume(task);
>   		break;
>   	case TWA_SIGNAL:
> -		set_notify_signal(task);
> +		set_notify_signal(task, false);
>   		break;
>   	default:
>   		WARN_ON_ONCE(1);
>
