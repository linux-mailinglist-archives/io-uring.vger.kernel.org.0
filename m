Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9644BB375
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiBRHmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 02:42:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiBRHmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 02:42:01 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E07E26121
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 23:41:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4oPGuS_1645170101;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4oPGuS_1645170101)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 15:41:42 +0800
Message-ID: <44b5cc5e-5417-b766-5d28-15b7bcaaafed@linux.alibaba.com>
Date:   Fri, 18 Feb 2022 15:41:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
 <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
 <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
 <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
 <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
 <51b4d363a9bd926243a2f7928335cdd2ac3f1218.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <51b4d363a9bd926243a2f7928335cdd2ac3f1218.camel@trillion01.com>
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


On 2/18/22 13:05, Olivier Langlois wrote:
> On Wed, 2022-02-16 at 20:14 +0800, Hao Xu wrote:
>> @@ -5583,6 +5650,7 @@ static void io_poll_task_func(struct io_kiocb
>> *req, bool *locked)
>>           struct io_ring_ctx *ctx = req->ctx;
>>           int ret;
>>
>> +       io_add_napi(req->file, req->ctx);
>>           ret = io_poll_check_events(req);
>>           if (ret > 0)
>>                   return;
>> @@ -5608,6 +5676,7 @@ static void io_apoll_task_func(struct io_kiocb
>> *req, bool *locked)
>>           struct io_ring_ctx *ctx = req->ctx;
>>           int ret;
>>
>> +       io_add_napi(req->file, req->ctx);
>>           ret = io_poll_check_events(req);
>>           if (ret > 0)
>>                   return;
>>
> I have a doubt about these call sites for adding the napi_id into the
> list. AFAIK, these are the functions called when the desired events are
> ready therefore, it is too late for polling the device.
[1]
>
> OTOH, my choice of doing it from io_file_get_normal() was perhaps a
> poor choice too because it is premature.
>
> Possibly the best location might be __io_arm_poll_handler()...
Hi Oliver,

Have you tried just issue one recv/pollin request and observe the

napi_id? From my understanding of the network stack, the napi_id

of a socket won't be valid until it gets some packets. Because before

that moment, busy_poll doesn't know which hw queue to poll.

In other words, the idea of NAPI polling is: the packets of a socket

can be from any hw queue of a net adapter, but we just poll the

queue which just received some data. So to get this piece of info,

there must be some data coming to one queue, before doing the

busy_poll. Correct me if I'm wrong since I'm also a newbie of

network stuff...


I was considering to poll all the rx rings, but it seemed to be not

efficient from some tests by my colleague.

for question [1] you mentioned, I think it's ok, since:

  - not all the data has been ready at that moment

  - the polling is not just for that request, there may be more data comming

    from the rx ring since we usually use polling mode under high workload

    pressure.

See the implementation of epoll busy_poll, the same thing.


Regards,
Hao

