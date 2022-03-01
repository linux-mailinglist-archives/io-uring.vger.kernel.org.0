Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D2D4C8664
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 09:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiCAIXq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 03:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiCAIXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 03:23:46 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BBB5FF1D;
        Tue,  1 Mar 2022 00:23:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5v0N2A_1646122981;
Received: from 30.226.12.13(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5v0N2A_1646122981)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 16:23:02 +0800
Message-ID: <7695c3a2-6cb0-067a-5655-0e6180170bde@linux.alibaba.com>
Date:   Tue, 1 Mar 2022 16:23:00 +0800
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
 <c8083ad8-076b-2f2d-4c80-fc9f75d9fcd8@linux.alibaba.com>
 <f84e9ab7d61aef6bf58d602a466a806193f3abbc.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <f84e9ab7d61aef6bf58d602a466a806193f3abbc.camel@trillion01.com>
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


On 3/1/22 05:01, Olivier Langlois wrote:
> On Tue, 2022-03-01 at 02:26 +0800, Hao Xu wrote:
>> On 2/25/22 13:32, Olivier Langlois wrote:
>>> On Mon, 2022-02-21 at 13:23 +0800, Hao Xu wrote:
>>>>> @@ -5776,6 +5887,7 @@ static int __io_arm_poll_handler(struct
>>>>> io_kiocb *req,
>>>>>                   __io_poll_execute(req, mask);
>>>>>                   return 0;
>>>>>           }
>>>>> +       io_add_napi(req->file, req->ctx);
>>>> I think this may not be the right place to do it. the process
>>>> will
>>>> be:
>>>> arm_poll sockfdA--> get invalid napi_id from sk->napi_id -->
>>>> event
>>>> triggered --> arm_poll for sockfdA again --> get valid napi_id
>>>> then why not do io_add_napi() in event
>>>> handler(apoll_task_func/poll_task_func).
>>> You have a valid concern that the first time a socket is passed to
>>> io_uring that napi_id might not be assigned yet.
>>>
>>> OTOH, getting it after data is available for reading does not help
>>> neither since busy polling must be done before data is received.
>>>
>>> for both places, the extracted napi_id will only be leveraged at
>>> the
>>> next polling.
>> Hi Olivier,
>>
>> I think we have some gap here. AFAIK, it's not 'might not', it is
>>
>> 'definitely not', the sk->napi_id won't be valid until the poll
>> callback.
>>
>> Some driver's code FYR:
>> (drivers/net/ethernet/intel/e1000/e1000_main.c)
>>
>> e1000_receive_skb-->napi_gro_receive-->napi_skb_finish--
>>> gro_normal_one
>> and in gro_normal_one(), it does:
>>
>>             if (napi->rx_count >= gro_normal_batch)
>>                     gro_normal_list(napi);
>>
>>
>> The gro_normal_list() delivers the info up to the specifical network
>> protocol like tcp.
>>
>> And then sk->napi_id is set, meanwhile the poll callback is
>> triggered.
>>
>> So that's why I call the napi polling technology a 'speculation'.
>> It's
>> totally for the
>>
>> future data. Correct me if I'm wrong especially for the poll callback
>> triggering part.
>>
> When I said 'might not', I was meaning that from the io_uring point of
> view, it has no idea what is the previous socket usage. If it has been
> used outside io_uring, the napi_id could available on the first call.
>
> If it is really read virgin socket, neither my choosen call site or
> your proposed sites will make the napi busy poll possible for the first
> poll.
>
> I feel like there is not much to gain to argue on this point since I
> pretty much admitted that your solution was most likely the only call
> site making MULTIPOLL requests work correctly with napi busy poll as
> those requests could visit __io_arm_poll_handler only once (Correct me
> if my statement is wrong).
>
> The only issue was that I wasn't sure is how using your calling sites
> would make locking work.
>
> I suppose that adding a dedicated spinlock for protecting napi_list
> instead of relying on uring_lock could be a solution. Would that work?
spinlock should be fine.
