Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063144BD4ED
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 06:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiBUFEP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 00:04:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiBUFEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 00:04:15 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22A86354
        for <io-uring@vger.kernel.org>; Sun, 20 Feb 2022 21:03:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V5-pAz1_1645419828;
Received: from 30.225.24.181(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5-pAz1_1645419828)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 13:03:49 +0800
Message-ID: <b4440070-e255-9107-4214-1b00ee84ac47@linux.alibaba.com>
Date:   Mon, 21 Feb 2022 13:03:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: napi_busy_poll
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
 <44b5cc5e-5417-b766-5d28-15b7bcaaafed@linux.alibaba.com>
 <085cb98e6136fc4874b6311ac2e4b78f5a6ef86d.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <085cb98e6136fc4874b6311ac2e4b78f5a6ef86d.camel@trillion01.com>
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

在 2022/2/19 下午3:02, Olivier Langlois 写道:
> On Fri, 2022-02-18 at 15:41 +0800, Hao Xu wrote:
>>
>> Hi Oliver,
>>
>> Have you tried just issue one recv/pollin request and observe the
>>
>> napi_id?
> 
> Hi Hao, not precisely but you are 100% right about where the
> association is done. It is when a packet is received that the
> association is made. This happens in few places but the most likely
> place where it can happen with my NIC (Intel igb) is inside
> napi_gro_receive().

Yes, when a packet is received-->set skb->napi_id, when receiving a
batch of them-->deliver the skbs to the protocol layer and set
sk->napi_id
> 
> I do verify the socket napi_id once a WebSocket session is established.
> At that point a lot of packets going back and forth have been
> exchanged:
> 
> TCP handshake
> TLS handshake
> HTTP request requesting a WS upgrade
> 
> At that point, the napi_id has been assigned.
> 
> My problem was only that my socket packets were routed on the loopback
> interface which has no napi devices associated to it.
> 
> I did remove the local SOCKS proxy out of my setup and NAPI ids started
> to appear as expected.
> 
>>   From my understanding of the network stack, the napi_id
>>
>> of a socket won't be valid until it gets some packets. Because before
>>
>> that moment, busy_poll doesn't know which hw queue to poll.
>>
>> In other words, the idea of NAPI polling is: the packets of a socket
>>
>> can be from any hw queue of a net adapter, but we just poll the
>>
>> queue which just received some data. So to get this piece of info,
>>
>> there must be some data coming to one queue, before doing the
>>
>> busy_poll. Correct me if I'm wrong since I'm also a newbie of
>>
>> network stuff...
> 
> I am now getting what you mean here. So there are 2 possible
> approaches. You either:
> 
> 1. add the napi id when you are sure that it is available after its
> setting in the sock layer but you are not sure if it will be needed
> again with future requests as it is too late to be of any use for the
> current request (unless it is a MULTISHOT poll) (the add is performed
> in io_poll_task_func() and io_apoll_task_func()
> 
> 2. add the napi id when the request poll is armed where this knowledge
> could be leveraged to handle the current req knowing that we might fail
> getting the id if it is the initial recv request. (the add would be
> performed in __io_arm_poll_handler)
I explains this in the patch.
> 
> TBH, I am not sure if there are arguments in favor of one approach over
> the other... Maybe option #1 is the only one to make napi busy poll
> work correctly with MULTISHOT requests...
> 
> I'll let you think about this point... Your first choice might be the
> right one...
> 
> the other thing to consider when choosing the call site is locking...
> when done from __io_arm_poll_handler(), uring_lock is acquired...
> 
> I am not sure that this is always the case with
> io_poll_task_func/io_apoll_task_func...
> 
> I'll post v1 of the patch. My testing is showing that it works fine.
> race condition is not an issue when busy poll is performed by sqpoll
> thread because the list modification is exclusivy performed by that
> thread too.
> 
> but I think that there is a possible race condition where the napi_list
> could be used from io_cqring_wait() while another thread modify the
> list. This is NOT done in my testing scenario but definitely something
> that could happen somewhere in the real world...

Will there be any issue if we do the access with
list_for_each_entry_safe? I think it is safe enough.

> 
>>
>>
>> I was considering to poll all the rx rings, but it seemed to be not
>>
>> efficient from some tests by my colleague.
> 
> This is definitely the simplest implementation but I did not go as far
> as testing it. There is too much unknown variables to be viable IMHO. I
> am not too sure how many napi devices there can be in a typical server.
> I know that in my test machine, it has 2 NICs and one of them is just
> unconnected. If we were to loop through all the devices, we would be
> polling wastefully at least half of all the devices on the system. That
> does not sound like a very good approach.
> 

