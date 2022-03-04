Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E964CD551
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 14:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiCDNk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Mar 2022 08:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiCDNk0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Mar 2022 08:40:26 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C111201B7
        for <io-uring@vger.kernel.org>; Fri,  4 Mar 2022 05:39:38 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V6CkuP3_1646401174;
Received: from 30.212.154.145(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V6CkuP3_1646401174)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Mar 2022 21:39:35 +0800
Message-ID: <3a59a3e1-4aa8-6970-23b6-fd331fb2c75c@linux.alibaba.com>
Date:   Fri, 4 Mar 2022 21:39:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
 <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
 <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 3/3/22 2:19 PM, Jens Axboe wrote:
>> On 3/3/22 1:41 PM, Jens Axboe wrote:
>>> On 3/3/22 10:18 AM, Jens Axboe wrote:
>>>> On 3/3/22 9:31 AM, Jens Axboe wrote:
>>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>>>> The only potential oddity here is that the fd passed back is not a
>>>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>>>> that could cause some confusion even if I don't think anyone actually
>>>>>>> does poll(2) on io_uring.
>>>>>> Side note - the only implication here is that we then likely can't make
>>>>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>>>>> flag which tells us that the application is aware of this limitation.
>>>>>> Though I guess close(2) might mess with that too... Hmm.
>>>>> Not sure I can find a good approach for that. Tried out your patch and
>>>>> made some fixes:
>>>>>
>>>>> - Missing free on final tctx free
>>>>> - Rename registered_files to registered_rings
>>>>> - Fix off-by-ones in checking max registration count
>>>>> - Use kcalloc
>>>>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>>>>> - Don't pass in tctx to io_uring_unreg_ringfd()
>>>>> - Get rid of forward declaration for adding tctx node
>>>>> - Get rid of extra file pointer in io_uring_enter()
>>>>> - Fix deadlock in io_ringfd_register()
>>>>> - Use io_uring_rsrc_update rather than add a new struct type
>>>> - Allow multiple register/unregister instead of enforcing just 1 at the
>>>>    time
>>>> - Check for it really being a ring fd when registering
>>>>
>>>> For different batch counts, nice improvements are seen. Roughly:
>>>>
>>>> Batch==1	15% faster
>>>> Batch==2	13% faster
>>>> Batch==4	11% faster
>>>>
>>>> This is just in microbenchmarks where the fdget/fdput play a bigger
>>>> factor, but it will certainly help with real world situations where
>>>> batching is more limited than in benchmarks.
>>> In trying this out in applications, I think the better registration API
>>> is to allow io_uring to pick the offset. The application doesn't care,
>>> it's just a magic integer there. And if we allow io_uring to pick it,
>>> then that makes things a lot easier to deal with.
>>>
>>> For registration, pass in an array of io_uring_rsrc_update structs, just
>>> filling in the ring_fd in the data field. Return value is number of ring
>>> fds registered, and up->offset now contains the chosen offset for each
>>> of them.
>>>
>>> Unregister is the same struct, but just with offset filled in.
>>>
>>> For applications using io_uring, which is all of them as far as I'm
>>> aware, we can also easily hide this. This means we can get the optimized
>>> behavior by default.
>> Only complication here is if the ring is shared across threads or
>> processes. The thread one can be common, one thread doing submit and one
>> doing completions. That one is a bit harder to handle. Without
>> inheriting registered ring fds, not sure how it can be handled by
>> default. Should probably just introduce a new queue init helper, but
>> then that requires application changes to adopt...
>>
>> Ideas welcome!
> Don't see a way to do it by default, so I think it'll have to be opt-in.
> We could make it the default if you never shared a ring, which most
> people don't do, but we can't easily do so if it's ever shared between
> tasks or processes.
Before sending this patch, I also have thought about whether we can make 
this
enter_ring_fd be shared between threads and be default feature, and 
found that
it's hard :)
   1) first we need to ensure this ring fd registration always can be 
unregistered,
so this cache is tied to io_uring_task, then when thread exits, we can 
ensure
fput called correspondingly.
   2) we may also implement a file cache shared between threads in a 
process,
but this may introduce extra overhead, at least need locks to protect 
modifications
to this cache. If this cache is per thread, it doesn't need any 
synchronizations.

So I suggest to make it be just simple and opt-in, and the registration 
interface
seems not complicated, a thread trying to submit sqes can adopt it easily.
>
> With liburing, if you share, you share the io_uring struct as well. So
> it's hard to maintain a new ->enter_ring_fd in there. It'd be doable if
> we could reserve real fd == . Which is of course possible
> using xarray or similar, but that'll add extra overhead.
For liburing, we may need to add fixed file version for helpers which 
submit sqes
or reap cqes, for example,  io_uring_submit_fixed(), which passes a 
enter_ring_fd.

>
> Anyway, current version below. Only real change here is allowing either
> specific offset or generated offset, depending on what the
> io_uring_rsrc_update->offset is set to. If set to -1U, then io_uring
> will find a free offset. If set to anything else, io_uring will use that
> index (as long as it's >=0 && < MAX).
Seems you forgot to attach the newest version, and also don't see a 
patch attachment.
Finally, thanks for your quick response and many code improvements, 
really appreciate it.

Regards,
Xiaoguang Wang
>

