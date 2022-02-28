Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB64F4C7815
	for <lists+io-uring@lfdr.de>; Mon, 28 Feb 2022 19:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiB1SlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 13:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240651AbiB1Skz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 13:40:55 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A065B45511;
        Mon, 28 Feb 2022 10:34:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5oMHbb_1646073255;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5oMHbb_1646073255)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 02:34:16 +0800
Message-ID: <9954b806-c4a0-2448-1eac-c8fc5cf2ca2c@linux.alibaba.com>
Date:   Tue, 1 Mar 2022 02:34:15 +0800
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
 <2cedc9f21a1c89aa9fe1fa4dffc2ebeabeb761f5.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <2cedc9f21a1c89aa9fe1fa4dffc2ebeabeb761f5.camel@trillion01.com>
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


On 2/25/22 23:32, Olivier Langlois wrote:
> On Fri, 2022-02-25 at 00:32 -0500, Olivier Langlois wrote:
>>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>>> +static void io_adjust_busy_loop_timeout(struct timespec64 *ts,
>>>> +                                       struct io_wait_queue
>>>> *iowq)
>>>> +{
>>>> +       unsigned busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
>>>> +       struct timespec64 pollto = ns_to_timespec64(1000 *
>>>> (s64)busy_poll_to);
>>>> +
>>>> +       if (timespec64_compare(ts, &pollto) > 0) {
>>>> +               *ts = timespec64_sub(*ts, pollto);
>>>> +               iowq->busy_poll_to = busy_poll_to;
>>>> +       } else {
>>>> +               iowq->busy_poll_to = timespec64_to_ns(ts) / 1000;
>>> How about timespec64_tons(ts) >> 10, since we don't need accurate
>>> number.
>> Fantastic suggestion! The kernel test robot did also detect an issue
>> with that statement. I did discover do_div() in the meantime but what
>> you suggest is better, IMHO...
> After having seen Jens patch (io_uring: don't convert to jiffies for
> waiting on timeouts), I think that I'll stick with do_div().
>
> I have a hard time considering removing timing accuracy when effort is
> made to make the same function more accurate...


I think they are different things. Jens' patch is to resolve the problem

that jiffies possibly can not stand for time < 1ms (when HZ is 1000).

For example, a user assigns 10us, turn out to be 1ms, it's big difference.

But divided by 1000 or 1024 is not that quite different in this case.

>>
>>>> +                !io_busy_loop_end(iowq, start_time));
>>>> +}
>>>> +#endif /* CONFIG_NET_RX_BUSY_POLL */
>>>> +
>>>>    /*
>>>>     * Wait until events become available, if we don't already have
>>>> some. The
>>>>     * application must reap them itself, as they reside on the
>>>> shared cq ring.
>>>> @@ -7729,12 +7906,20 @@ static int io_cqring_wait(struct
>>>> io_ring_ctx *ctx, int min_events,
>>>>                  if (!io_run_task_work())
>>>>                          break;
>>>>          } while (1);
>>>> -
>>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>>> +       iowq.busy_poll_to = 0;
>>>> +#endif
>>>>          if (uts) {
>>>>                  struct timespec64 ts;
>>>>    
>>>>                  if (get_timespec64(&ts, uts))
>>>>                          return -EFAULT;
>>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>>> +               if (!(ctx->flags & IORING_SETUP_SQPOLL) &&
>>>> +                   !list_empty(&ctx->napi_list)) {
>>>> +                       io_adjust_busy_loop_timeout(&ts, &iowq);
>>>> +               }
>>>> +#endif
>>>>                  timeout = timespec64_to_jiffies(&ts);
>>>>          }
>>>>    
>>>> @@ -7759,6 +7944,10 @@ static int io_cqring_wait(struct
>>>> io_ring_ctx
>>>> *ctx, int min_events,
>>>>          iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) +
>>>> min_events;
>>>>    
>>>>          trace_io_uring_cqring_wait(ctx, min_events);
>>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>>> +       if (iowq.busy_poll_to)
>>>> +               io_blocking_napi_busy_loop(ctx, &iowq);
>>> We may not need locks for the napi_list, the reason is we don't
>>> need
>>> to
>>> poll an accurate list, the busy polling/NAPI itself is kind of
>>> speculation. So the deletion is not an emergency.
>>> To say the least, we can probably delay the deletion to some safe
>>> place
>>> like the original task's task work though this may cause other
>>> problems...
>> There are 2 concerns here.
>>
>> 1. Iterating a list while another thread modify it is not thread-safe
>> unless you use a lock.
>>
>> If we offer napi_busy_poll() without sqpoll with the modification in
>> io_cqring_wait(), this is a real possibility. A thread could call
>> io_uring_enter(IORING_ENTER_GETEVENTS) while another thread calls
>> io_uring_enter() to submit new sqes that could trigger a call to
>> io_add_napi().
>>
>> If napi_busy_poll() is only offered through sqpoll thread, this
>> becomes
>> a non-issue since the only thread accessing/modifying the napi_list
>> field is the sqpoll thread.
>>
>> Providing the patch benchmark result with v2 could help deciding what
>> to do with this choice.
>>
>> 2. You are correct when you say that deletion is not an emergency.
>>
>> However, the design guideline that I did follow when writing the
>> patch
>> is that napi_busy_poll support should not impact users not using this
>> feature. Doing the deletion where that patch is doing it fullfill
>> this
>> goal.
>>
>> Comparing a timeout value with the jiffies variable is very cheap and
>> will only be performed when napi_busy_poll is used.
>>
>> The other option would be to add a refcount to each napi_entry and
>> decrement it if needed everytime a request is discarded. Doing that
>> that check for every requests that io_uring discards on completion, I
>> am very confident that this would negatively impact various
>> performance
>> benchmarks that Jens routinely perform...
>>
> Another fact to consider, it is that I expect the content of napi_list
> to be extremely stable. Regular entry deletion should not be a thing.
>
> postponing the deletion using task work is not an option too. How would
> io_busy_loop_end() discern between a pending list entry deletion and
> any other task work making the busy looping stop?
