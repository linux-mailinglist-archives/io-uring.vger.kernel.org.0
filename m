Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589164BB31C
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 08:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiBRHWC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 02:22:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiBRHWA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 02:22:00 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698161CFF4
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 23:21:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4oPDUV_1645168900;
Received: from 192.168.31.208(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4oPDUV_1645168900)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 15:21:40 +0800
Message-ID: <499e8183-aa64-1dbd-ca6c-0ba413777589@linux.alibaba.com>
Date:   Fri, 18 Feb 2022 15:21:39 +0800
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
 <0a9c1bdcedac611518e4a90c1921d1f7657c2248.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <0a9c1bdcedac611518e4a90c1921d1f7657c2248.camel@trillion01.com>
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


On 2/18/22 07:18, Olivier Langlois wrote:
> On Wed, 2022-02-16 at 20:14 +0800, Hao Xu wrote:
>> Hi Olivier,
>> I've write something to express my idea, it would be great if you can
>> try it.
>> It's totally untested and only does polling in sqthread, won't be
>> hard
>> to expand it to cqring_wait. My original idea is to poll all the napi
>> device but seems that may be not efficient. so for a request, just
>> do napi polling for one napi.
>> There is still one problem: when to delete the polled NAPIs.
>>
> I think that I have found an elegant solution to the remaining problem!
>
> Are you ok if I send out a patch to Jens that contains your code if I
> put your name as a co-author?
No problem, go ahead.
>>
>> +       ne = kmalloc(sizeof(*ne), GFP_KERNEL);
>> +       if (!ne)
>> +               return;
>> +
>> +       list_add_tail(&ne->list, &ctx->napi_list);
>> +}
> ne->napi_id is not initialized before returning from the function!
Yes, feel free to enhance this code and fix bugs.
>
