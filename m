Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D8F4BD4E0
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 05:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiBUExH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 23:53:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbiBUExH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 23:53:07 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE226AF4
        for <io-uring@vger.kernel.org>; Sun, 20 Feb 2022 20:52:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V5-mV0G_1645419160;
Received: from 30.225.24.181(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5-mV0G_1645419160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 12:52:41 +0800
Message-ID: <e6e3b1ac-a028-430b-7ab1-b183d2c021bd@linux.alibaba.com>
Date:   Mon, 21 Feb 2022 12:52:40 +0800
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
 <3dcb591407be5180d7b14c05eceff30a8f990b58.camel@trillion01.com>
 <2ec04f63-7d82-74db-1b59-9629b4d6ca9b@linux.alibaba.com>
 <637509b7a91737e8f965841d801583fd4bbb46d7.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <637509b7a91737e8f965841d801583fd4bbb46d7.camel@trillion01.com>
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

在 2022/2/19 下午3:14, Olivier Langlois 写道:
> On Fri, 2022-02-18 at 16:06 +0800, Hao Xu wrote:
>>
>>>
>>> Concerning the remaining problem about when to remove the napi_id,
>>> I
>>> would say that a good place to do it would be when a request is
>>> completed and discarded if there was a refcount added to your
>>> napi_entry struct.
>>>
>>> The only thing that I hate about this idea is that in my scenario,
>>> the
>>> sockets are going to be pretty much the same for the whole io_uring
>>> context existance. Therefore, the whole ref counting overhead is
>>> useless and unneeded.
>>
>> I remember that now all the completion is in the original task(
>>
>> should be confirmed again),
>>
>> so it should be ok to just use simple 'unsigned int count' to show
>>
>> the number of users of a napi entry. And doing deletion when count
>>
>> is 0. For your scenario, which is only one napi in a iouring context,
>>
>> This won't be big overhead as well.
>>
>> The only thing is we may need to optimize the napi lookup process,
>>
>> but I'm not sure if it is necessary.
>>
> Hi Hao,
> 
> You can forget about the ref count idea. What I hated about it was that
> it was incurring a cost to all the io_uring users including the vast
> majority of them that won't be using napi_busy_poll...

We can do the deletion at the end of each OP which we should, like
the recv, the poll_task_func/apoll_task_func. Won't affect the main path
I guess.
> 
> One thing that I know that Pavel hates is when hot paths are littered
> with a bunch of new code. I have been very careful doing that in my
> design.
> 
> I think that I have found a much better approach to tackle the problem
> of when to remove the napi_ids... I'll stop teasing about it... The
> code is ready, tested... All I need to do is prepare the patch and send
> it to the list for review.
> 
> net/core/dev.c is using a hash to store the napi structs. This could
> possible be easily replicated in io_uring but for now, imho, this is a
> polishing detail only that can be revisited later after the proof of
> concept will have been accepted.
Exactly, that is not a high priority thing right now.
> 
> So eager to share the patch... This is the next thing that I do before
> going to bed once I am done reading my emails...

