Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADB14C9DDD
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 07:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiCBGi4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 01:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCBGi4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 01:38:56 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F46013DDE;
        Tue,  1 Mar 2022 22:38:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V61CwrZ_1646203089;
Received: from 30.226.12.26(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V61CwrZ_1646203089)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 14:38:10 +0800
Message-ID: <81a915d3-cf5f-a884-4649-704a5cf26835@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 14:38:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646142288.git.olivier@trillion01.com>
 <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
 <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
 <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
 <4af380e8-796b-2dd6-4ebc-e40e7fa51ce1@linux.alibaba.com>
In-Reply-To: <4af380e8-796b-2dd6-4ebc-e40e7fa51ce1@linux.alibaba.com>
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


On 3/2/22 14:27, Hao Xu wrote:
>
> On 3/2/22 04:06, Olivier Langlois wrote:
>> On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
>>>> +       ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
>>>> +       if (!ne)
>>>> +               goto out;
>>> IMHO, we need to handle -ENOMEM here, I cut off the error handling
>>> when
>>>
>>> I did the quick coding. Sorry for misleading.
>> If you are correct, I would be shocked about this.
>>
>> I did return in my 'Linux Device Drivers' book and nowhere it is
>> mentionned that the kmalloc() can return something else than a pointer
>>
>> No mention at all about the return value
>>
>> in man page:
>> https://www.kernel.org/doc/htmldocs/kernel-api/API-kmalloc.html
>> API doc:
>>
>> https://www.kernel.org/doc/html/latest/core-api/mm-api.html?highlight=kmalloc#c.kmalloc 
>>
>>
>> header file:
>> https://elixir.bootlin.com/linux/latest/source/include/linux/slab.h#L522
>>
>> I did browse into the kmalloc code. There is a lot of paths to cover
>> but from preliminary reading, it pretty much seems that kmalloc only
>> returns a valid pointer or NULL...
>>
>> /**
>>   * kmem_cache_alloc - Allocate an object
>>   * @cachep: The cache to allocate from.
>>   * @flags: See kmalloc().
>>   *
>>   * Allocate an object from this cache.  The flags are only relevant
>>   * if the cache has no available objects.
>>   *
>>   * Return: pointer to the new object or %NULL in case of error
>>   */
>>     /**
>>   * __do_kmalloc - allocate memory
>>   * @size: how many bytes of memory are required.
>>   * @flags: the type of memory to allocate (see kmalloc).
>>   * @caller: function caller for debug tracking of the caller
>>   *
>>   * Return: pointer to the allocated memory or %NULL in case of error
>>   */
>>
>> I'll need someone else to confirm about possible kmalloc() return
>> values with perhaps an example
>>
>> I am a bit skeptic that something special needs to be done here...
>>
>> Or perhaps you are suggesting that io_add_napi() returns an error code
>> when allocation fails.
> This is what I mean.
>>
>> as done here:
>> https://elixir.bootlin.com/linux/latest/source/arch/alpha/kernel/core_marvel.c#L867 
>>
>>
>> If that is what you suggest, what would this info do for the caller?
>>
>> IMHO, it wouldn't help in any way...
>
> Hmm, I'm not sure, you're probably right based on that ENOMEM here 
> shouldn't
>
> fail the arm poll, but we wanna do it, we can do something like what 
> we do for
                             ^---but if we wanna do it
