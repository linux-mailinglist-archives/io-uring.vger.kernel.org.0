Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130BC4C81C5
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 04:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiCADyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 22:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiCADyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 22:54:23 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1499333E84;
        Mon, 28 Feb 2022 19:53:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5ryTkb_1646106819;
Received: from 30.225.24.181(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5ryTkb_1646106819)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 11:53:40 +0800
Message-ID: <dc861c95-3150-03c7-4ecb-d86c53f7d8b3@linux.alibaba.com>
Date:   Tue, 1 Mar 2022 11:53:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
 <aee0e905-7af4-332c-57bc-ece0bca63ce2@linux.alibaba.com>
 <f84f59e3edd9b4973ea2013b2893d4394a7bdb61.camel@trillion01.com>
 <2cedc9f21a1c89aa9fe1fa4dffc2ebeabeb761f5.camel@trillion01.com>
 <9954b806-c4a0-2448-1eac-c8fc5cf2ca2c@linux.alibaba.com>
 <1b6439ba29a3725ed041bfb8040c6b667cc4898a.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <1b6439ba29a3725ed041bfb8040c6b667cc4898a.camel@trillion01.com>
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

在 2022/3/1 上午5:20, Olivier Langlois 写道:
> On Tue, 2022-03-01 at 02:34 +0800, Hao Xu wrote:
>>
>> On 2/25/22 23:32, Olivier Langlois wrote:
>>> On Fri, 2022-02-25 at 00:32 -0500, Olivier Langlois wrote:
>>>>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>>>>> +static void io_adjust_busy_loop_timeout(struct timespec64
>>>>>> *ts,
>>>>>> +                                       struct io_wait_queue
>>>>>> *iowq)
>>>>>> +{
>>>>>> +       unsigned busy_poll_to =
>>>>>> READ_ONCE(sysctl_net_busy_poll);
>>>>>> +       struct timespec64 pollto = ns_to_timespec64(1000 *
>>>>>> (s64)busy_poll_to);
>>>>>> +
>>>>>> +       if (timespec64_compare(ts, &pollto) > 0) {
>>>>>> +               *ts = timespec64_sub(*ts, pollto);
>>>>>> +               iowq->busy_poll_to = busy_poll_to;
>>>>>> +       } else {
>>>>>> +               iowq->busy_poll_to = timespec64_to_ns(ts) /
>>>>>> 1000;
>>>>> How about timespec64_tons(ts) >> 10, since we don't need
>>>>> accurate
>>>>> number.
>>>> Fantastic suggestion! The kernel test robot did also detect an
>>>> issue
>>>> with that statement. I did discover do_div() in the meantime but
>>>> what
>>>> you suggest is better, IMHO...
>>> After having seen Jens patch (io_uring: don't convert to jiffies
>>> for
>>> waiting on timeouts), I think that I'll stick with do_div().
>>>
>>> I have a hard time considering removing timing accuracy when effort
>>> is
>>> made to make the same function more accurate...
>>
>>
>> I think they are different things. Jens' patch is to resolve the
>> problem
>>
>> that jiffies possibly can not stand for time < 1ms (when HZ is 1000).
>>
>> For example, a user assigns 10us, turn out to be 1ms, it's big
>> difference.
>>
>> But divided by 1000 or 1024 is not that quite different in this case.
>>
>>>
> idk... For every 100uSec slice, dividing by 1024 will introduce a
> ~2.4uSec error. I didn't dig enough the question to figure out if the
> error was smaller than the used clock accuracy.
> 
> but even if the error is small, why letting it slip in when 100%
> accurate value is possible?
> 
> Beside, making the painfully picky do_div() macro for some platforms
> happy, I fail to understand the problem with doing a division to get an
> accurate value.
> 
> let me reverse the question. Even if the bit shifting is a bit faster
> than doing the division, would the code be called often enough to make
> a significant difference?
It's just my personal preference: when a faster way is acceptable, I 
just choose that one. For this one, do_div() should be ok since that
code is not hot in most case. But all depends to your test results.

Regards,
Hao

