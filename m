Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E844C7804
	for <lists+io-uring@lfdr.de>; Mon, 28 Feb 2022 19:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiB1SjV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 13:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiB1Sig (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 13:38:36 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763204F45F;
        Mon, 28 Feb 2022 10:26:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5oRhK-_1646072786;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5oRhK-_1646072786)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 02:26:27 +0800
Message-ID: <c8083ad8-076b-2f2d-4c80-fc9f75d9fcd8@linux.alibaba.com>
Date:   Tue, 1 Mar 2022 02:26:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
 <aee0e905-7af4-332c-57bc-ece0bca63ce2@linux.alibaba.com>
 <f84f59e3edd9b4973ea2013b2893d4394a7bdb61.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <f84f59e3edd9b4973ea2013b2893d4394a7bdb61.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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


On 2/25/22 13:32, Olivier Langlois wrote:
> On Mon, 2022-02-21 at 13:23 +0800, Hao Xu wrote:
>>> @@ -5776,6 +5887,7 @@ static int __io_arm_poll_handler(struct
>>> io_kiocb *req,
>>>                  __io_poll_execute(req, mask);
>>>                  return 0;
>>>          }
>>> +       io_add_napi(req->file, req->ctx);
>> I think this may not be the right place to do it. the process will
>> be:
>> arm_poll sockfdA--> get invalid napi_id from sk->napi_id --> event
>> triggered --> arm_poll for sockfdA again --> get valid napi_id
>> then why not do io_add_napi() in event
>> handler(apoll_task_func/poll_task_func).
> You have a valid concern that the first time a socket is passed to
> io_uring that napi_id might not be assigned yet.
>
> OTOH, getting it after data is available for reading does not help
> neither since busy polling must be done before data is received.
>
> for both places, the extracted napi_id will only be leveraged at the
> next polling.

Hi Olivier,

I think we have some gap here. AFAIK, it's not 'might not', it is

'definitely not', the sk->napi_id won't be valid until the poll callback.

Some driver's code FYR: (drivers/net/ethernet/intel/e1000/e1000_main.c)

e1000_receive_skb-->napi_gro_receive-->napi_skb_finish-->gro_normal_one

and in gro_normal_one(), it does:

           if (napi->rx_count >= gro_normal_batch)
                   gro_normal_list(napi);


The gro_normal_list() delivers the info up to the specifical network 
protocol like tcp.

And then sk->napi_id is set, meanwhile the poll callback is triggered.

So that's why I call the napi polling technology a 'speculation'. It's 
totally for the

future data. Correct me if I'm wrong especially for the poll callback 
triggering part.

>
> Your suggestion is superior because it might be the only working way
> for MULTIPOLL requests.
>
> However, I choose __io_arm_poll_handler() because if napi_busy_poll()
> is desired without a sqpoll thread, the context must be locked when
> calling io_add_napi(). This is the case when __io_arm_poll_handler() is
> called AFAIK.
>
> and I don't think that the context is locked when
> (apoll_task_func/poll_task_func) are called.
>
> I acknowledge that this is an issue that needs to be fixed but right
> now I am not sure how to address this so let me share v2 of the patch
> and plan a v3 for at least this pending issue.
>
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +static void io_adjust_busy_loop_timeout(struct timespec64 *ts,
>>> +                                       struct io_wait_queue *iowq)
>>> +{
>>> +       unsigned busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
>>> +       struct timespec64 pollto = ns_to_timespec64(1000 *
>>> (s64)busy_poll_to);
>>> +
>>> +       if (timespec64_compare(ts, &pollto) > 0) {
>>> +               *ts = timespec64_sub(*ts, pollto);
>>> +               iowq->busy_poll_to = busy_poll_to;
>>> +       } else {
>>> +               iowq->busy_poll_to = timespec64_to_ns(ts) / 1000;
>> How about timespec64_tons(ts) >> 10, since we don't need accurate
>> number.
> Fantastic suggestion! The kernel test robot did also detect an issue
> with that statement. I did discover do_div() in the meantime but what
> you suggest is better, IMHO...
>
>>> +static void io_blocking_napi_busy_loop(struct io_ring_ctx *ctx,
>>> +                                      struct io_wait_queue *iowq)
>>> +{
>>> +       unsigned long start_time =
>>> +               list_is_singular(&ctx->napi_list) ? 0 :
>>> +               busy_loop_current_time();
>>> +
>>> +       do {
>>> +               if (list_is_singular(&ctx->napi_list)) {
>>> +                       struct napi_entry *ne =
>>> +                               list_first_entry(&ctx->napi_list,
>>> +                                                struct napi_entry,
>>> list);
>>> +
>>> +                       napi_busy_loop(ne->napi_id,
>>> io_busy_loop_end, iowq,
>>> +                                      true, BUSY_POLL_BUDGET);
>>> +                       io_check_napi_entry_timeout(ne);
>>> +                       break;
>>> +               }
>>> +       } while (io_napi_busy_loop(ctx) &&
>> Why don't we setup busy_loop_end callback for normal(non-singular)
>> case,
>> we can record the number of napi_entry, and divide the time frame to
>> each entry.
> This is from intuition that iterating through all the napi devices in a
> 'sprinkler' pattern is the correct way to proceed when handling several
> devices.
>
> If you busy poll the first devices for a certain amount of time and a
> packet is received in the last device, you won't know until you reach
> it which will be much later than with the proposed 'sprinkler' way.
>
> singular case is treated differently because entering/exiting
> napi_busy_loop() incur setup overhead that you don't need for that
> special case.
>
>>> +                !io_busy_loop_end(iowq, start_time));
>>> +}
>>> +#endif /* CONFIG_NET_RX_BUSY_POLL */
>>> +
>>>    /*
>>>     * Wait until events become available, if we don't already have
>>> some. The
>>>     * application must reap them itself, as they reside on the
>>> shared cq ring.
>>> @@ -7729,12 +7906,20 @@ static int io_cqring_wait(struct
>>> io_ring_ctx *ctx, int min_events,
>>>                  if (!io_run_task_work())
>>>                          break;
>>>          } while (1);
>>> -
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +       iowq.busy_poll_to = 0;
>>> +#endif
>>>          if (uts) {
>>>                  struct timespec64 ts;
>>>    
>>>                  if (get_timespec64(&ts, uts))
>>>                          return -EFAULT;
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +               if (!(ctx->flags & IORING_SETUP_SQPOLL) &&
>>> +                   !list_empty(&ctx->napi_list)) {
>>> +                       io_adjust_busy_loop_timeout(&ts, &iowq);
>>> +               }
>>> +#endif
>>>                  timeout = timespec64_to_jiffies(&ts);
>>>          }
>>>    
>>> @@ -7759,6 +7944,10 @@ static int io_cqring_wait(struct io_ring_ctx
>>> *ctx, int min_events,
>>>          iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>>>    
>>>          trace_io_uring_cqring_wait(ctx, min_events);
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +       if (iowq.busy_poll_to)
>>> +               io_blocking_napi_busy_loop(ctx, &iowq);
>> We may not need locks for the napi_list, the reason is we don't need
>> to
>> poll an accurate list, the busy polling/NAPI itself is kind of
>> speculation. So the deletion is not an emergency.
>> To say the least, we can probably delay the deletion to some safe
>> place
>> like the original task's task work though this may cause other
>> problems...
> There are 2 concerns here.
>
> 1. Iterating a list while another thread modify it is not thread-safe
> unless you use a lock.
>
> If we offer napi_busy_poll() without sqpoll with the modification in
> io_cqring_wait(), this is a real possibility. A thread could call
> io_uring_enter(IORING_ENTER_GETEVENTS) while another thread calls
> io_uring_enter() to submit new sqes that could trigger a call to
> io_add_napi().

Thanks, I forgot the io_add_napi() part. Yes, we have to ensure

the entry to be added will be really added...so lock is necessary.

I knew there may be multiple threads accesses the napi_list like

you described above, but if there were only deletion, then lock might

be avoided since we just want it not to crash.

>
> If napi_busy_poll() is only offered through sqpoll thread, this becomes
> a non-issue since the only thread accessing/modifying the napi_list
> field is the sqpoll thread.
>
> Providing the patch benchmark result with v2 could help deciding what
> to do with this choice.
>
> 2. You are correct when you say that deletion is not an emergency.
>
> However, the design guideline that I did follow when writing the patch
> is that napi_busy_poll support should not impact users not using this
> feature. Doing the deletion where that patch is doing it fullfill this
> goal.
>
> Comparing a timeout value with the jiffies variable is very cheap and
> will only be performed when napi_busy_poll is used.
>
> The other option would be to add a refcount to each napi_entry and
> decrement it if needed everytime a request is discarded. Doing that
> that check for every requests that io_uring discards on completion, I
> am very confident that this would negatively impact various performance
> benchmarks that Jens routinely perform...
