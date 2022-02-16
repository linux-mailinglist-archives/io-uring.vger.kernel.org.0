Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8087E4B7E50
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 04:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbiBPDMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 22:12:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiBPDMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 22:12:31 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE508939D3
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 19:12:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4bHGHq_1644981136;
Received: from 30.225.24.82(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4bHGHq_1644981136)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 11:12:17 +0800
Message-ID: <4d889559-9268-7948-eb6b-1cb60d90016f@linux.alibaba.com>
Date:   Wed, 16 Feb 2022 11:12:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
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
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/2/16 上午2:05, Olivier Langlois 写道:
> On Tue, 2022-02-15 at 03:37 -0500, Olivier Langlois wrote:
>>
>> That being said, I have not been able to make it work yet. For some
>> unknown reasons, no valid napi_id is extracted from the sockets added
>> to the context so the net_busy_poll function is never called.
>>
>> I find that very strange since prior to use io_uring, my code was
>> using
>> epoll and the busy polling was working fine with my application
>> sockets. Something is escaping my comprehension. I must tired and
>> this
>> will become obvious...
>>
> The napi_id values associated with my sockets appear to be in the range
> 0 < napi_id < MIN_NAPI_ID
> 
> from busy_loop.h:
> /*		0 - Reserved to indicate value not set
>   *     1..NR_CPUS - Reserved for sender_cpu
>   *  NR_CPUS+1..~0 - Region available for NAPI IDs
>   */
> #define MIN_NAPI_ID ((unsigned int)(NR_CPUS + 1))
> 
> I have found this:
> https://lwn.net/Articles/619862/
> 
> hinting that busy_poll may be incompatible with RPS
> (Documentation/networking/scaling.rst) that I may have discovered
> *AFTER* my epoll -> io_uring transition (I don't recall exactly the
> sequence of my learning process).
> 
I read your code, I guess the thing is the sk->napi_id is set from
skb->napi_id and the latter is set when the net device received some
packets.
> With my current knowledge, it makes little sense why busy polling would
> not be possible with RPS. Also, what exactly is a NAPI device is quite
> nebulous to me... Looking into the Intel igb driver code, it seems like
> 1 NAPI device is created for each interrupt vector/Rx buffer of the
> device.
AFAIK, yes, each Rx ring has its own NAPI.
> 
> Bottomline, it seems like I have fallen into a new rabbit hole. It may
> take me a day or 2 to figure it all... you are welcome to enlight me if
> you know a thing or 2 about those topics... I am kinda lost right
> now...
> 

