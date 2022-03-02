Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC714C9DC8
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 07:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiCBG2S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 01:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiCBG2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 01:28:16 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF8712AAB;
        Tue,  1 Mar 2022 22:27:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V61DD7-_1646202448;
Received: from 30.226.12.26(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V61DD7-_1646202448)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 14:27:29 +0800
Message-ID: <4af380e8-796b-2dd6-4ebc-e40e7fa51ce1@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 14:27:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646142288.git.olivier@trillion01.com>
 <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
 <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
 <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
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


On 3/2/22 04:06, Olivier Langlois wrote:
> On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
>>> +       ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
>>> +       if (!ne)
>>> +               goto out;
>> IMHO, we need to handle -ENOMEM here, I cut off the error handling
>> when
>>
>> I did the quick coding. Sorry for misleading.
> If you are correct, I would be shocked about this.
>
> I did return in my 'Linux Device Drivers' book and nowhere it is
> mentionned that the kmalloc() can return something else than a pointer
>
> No mention at all about the return value
>
> in man page:
> https://www.kernel.org/doc/htmldocs/kernel-api/API-kmalloc.html
> API doc:
>
> https://www.kernel.org/doc/html/latest/core-api/mm-api.html?highlight=kmalloc#c.kmalloc
>
> header file:
> https://elixir.bootlin.com/linux/latest/source/include/linux/slab.h#L522
>
> I did browse into the kmalloc code. There is a lot of paths to cover
> but from preliminary reading, it pretty much seems that kmalloc only
> returns a valid pointer or NULL...
>
> /**
>   * kmem_cache_alloc - Allocate an object
>   * @cachep: The cache to allocate from.
>   * @flags: See kmalloc().
>   *
>   * Allocate an object from this cache.  The flags are only relevant
>   * if the cache has no available objects.
>   *
>   * Return: pointer to the new object or %NULL in case of error
>   */
>   
>   /**
>   * __do_kmalloc - allocate memory
>   * @size: how many bytes of memory are required.
>   * @flags: the type of memory to allocate (see kmalloc).
>   * @caller: function caller for debug tracking of the caller
>   *
>   * Return: pointer to the allocated memory or %NULL in case of error
>   */
>
> I'll need someone else to confirm about possible kmalloc() return
> values with perhaps an example
>
> I am a bit skeptic that something special needs to be done here...
>
> Or perhaps you are suggesting that io_add_napi() returns an error code
> when allocation fails.
This is what I mean.
>
> as done here:
> https://elixir.bootlin.com/linux/latest/source/arch/alpha/kernel/core_marvel.c#L867
>
> If that is what you suggest, what would this info do for the caller?
>
> IMHO, it wouldn't help in any way...

Hmm, I'm not sure, you're probably right based on that ENOMEM here shouldn't

fail the arm poll, but we wanna do it, we can do something like what we 
do for

kmalloc() in io_arm_poll_handler()). I'll leave it to others.

>>> @@ -7519,7 +7633,11 @@ static int __io_sq_thread(struct io_ring_ctx
>>> *ctx, bool cap_entries)
>>>                      !(ctx->flags & IORING_SETUP_R_DISABLED))
>>>                          ret = io_submit_sqes(ctx, to_submit);
>>>                  mutex_unlock(&ctx->uring_lock);
>>> -
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +               if (!list_empty(&ctx->napi_list) &&
>>> +                   io_napi_busy_loop(&ctx->napi_list))
>> I'm afraid we may need lock for sqpoll too, since io_add_napi() could
>> be
>> in iowq context.
>>
>> I'll take a look at the lock stuff of this patch tomorrow, too late
>> now
>> in my timezone.
> Ok, please do. I'm not a big user of io workers. I may have omitted to
> consider this possibility.
>
> If that is the case, I think that this would be very easy to fix by
> locking the spinlock while __io_sq_thread() is using napi_list.
>> How about:
>>
>> if (list is singular) {
>>
>>       do something;
>>
>>       return;
>>
>> }
>>
>> while (!io_busy_loop_end() && io_napi_busy_loop())
>>
>>       ;
>>
> is there a concern with the current code?
> What would be the benefit of your suggestion over current code?

No, it's just coding style concern, since I see

do {

     if() {

         break;

     }

} while();

which means the if statement is actually not int the loop. Anyway, it's just

personal taste.

>
> To me, it seems that if io_blocking_napi_busy_loop() is called, a
> reasonable expectation would be that some busy looping is done or else
> you could return the function without doing anything which would, IMHO,
> be misleading.
>
> By definition, napi_busy_loop() is not blocking and if you desire the
> device to be in busy poll mode, you need to do it once in a while or
> else, after a certain time, the device will return back to its
> interrupt mode.
>
> IOW, io_blocking_napi_busy_loop() follows the same logic used by
> napi_busy_loop() that does not call loop_end() before having perform 1
> loop iteration.
I see, thanks for explanation. I'm ok with this.
>
>> Btw, start_time seems not used in singular branch.
> I know. This is why it is conditionally initialized.

like what I said, just personal taste.


+static void io_blocking_napi_busy_loop(struct list_head *napi_list,

+                                      struct io_wait_queue *iowq)
+{
+       if (list_is_singular(napi_list)) {
+               struct napi_entry *ne =
+                       list_first_entry(napi_list,
+                                        struct napi_entry, list);
+
+               napi_busy_loop(ne->napi_id, io_busy_loop_end, iowq,
+                              true, BUSY_POLL_BUDGET);
+               io_check_napi_entry_timeout(ne);
+               break;
+       }
+
+       while (io_napi_busy_loop(napi_list)) {
+               if(io_busy_loop_end(iowq, busy_loop_current_time()))
+                       break;
+       }
+}


>
> Greetings,
