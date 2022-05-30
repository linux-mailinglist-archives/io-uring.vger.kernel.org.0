Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8847F537552
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 09:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiE3Gw5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 02:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiE3Gw4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 02:52:56 -0400
Received: from pv50p00im-ztdg10021101.me.com (pv50p00im-ztdg10021101.me.com [17.58.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2415579BD
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 23:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653893574;
        bh=mr2ReSVOZiPylSq4ZLP/xKZqceHCyk+44Q2kTyeh08o=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=AAsNlP3iBWIYQ9vTVAi8wag9zsfoVcyY3utbDgGHkmZ2qsVb+fJh6o0K2AvoHdMbn
         PgXCOUZNFZR4hsWyHbm4vtEwEEeDxPKYCGCmctcHFdL8sUOvRG0RYS9WFKfV3ihyQu
         VYyErVSe9Uh6vN83uVLg5WsnjuwTOJxpF+gYrhMqdPPAikTblEdB+V2Dv39NXCBTJ2
         MmyuT+Pt/Hm2mGvZvw6a2Vq3GBcFd9OJkGZX/KKcjRPxXyY2vj+js3fxeo6GQjr5CW
         fNUC6nW03rgP6lADqX9A6bsxxy768Rpzp1GrQj5g3pxaL1RLYYPBR/hjgUVbOiHxW/
         4N7jvsvrqjLfA==
Received: from [192.168.31.207] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021101.me.com (Postfix) with ESMTPSA id 376FDD002A2;
        Mon, 30 May 2022 06:52:51 +0000 (UTC)
Message-ID: <d530c3ab-4aec-730c-0f44-9752303e31ce@icloud.com>
Date:   Mon, 30 May 2022 14:52:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
 <d476c344-56ea-db57-052a-876605662362@gmail.com>
 <a939481d-98b5-2c40-4b76-74b89319ddba@kernel.dk>
 <97ebdccc-0c19-7019-fba7-4a1e5298c78f@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <97ebdccc-0c19-7019-fba7-4a1e5298c78f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_02:2022-05-27,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=908 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205300035
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 08:18, Pavel Begunkov wrote:
> On 5/30/22 00:34, Jens Axboe wrote:
>> On 5/29/22 4:50 PM, Pavel Begunkov wrote:
>>> On 5/29/22 19:40, Jens Axboe wrote:
>>>> On 5/29/22 12:07 PM, Hao Xu wrote:
>>>>> On 5/30/22 00:25, Jens Axboe wrote:
>>>>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>>
>>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>>
>>>>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>>>>> invocation and remove contension between different cancel_hash 
>>>>>>> entries
>>>>>>
>>>>>> Interesting, do you have any numbers on this?
>>>>>
>>>>> Just Theoretically for now, I'll do some tests tomorrow. This is
>>>>> actually RFC, forgot to change the subject.
>>>>>
>>>>>>
>>>>>> Also, I'd make a hash bucket struct:
>>>>>>
>>>>>> struct io_hash_bucket {
>>>>>>       spinlock_t lock;
>>>>>>       struct hlist_head list;
>>>>>> };
>>>>>>
>>>>>> rather than two separate structs, that'll have nicer memory 
>>>>>> locality too
>>>>>> and should further improve it. Could be done as a prep patch with the
>>>>>> old locking in place, making the end patch doing the per-bucket lock
>>>>>> simpler as well.
>>>>>
>>>>> Sure, if the test number make sense, I'll send v2. I'll test the
>>>>> hlist_bl list as well(the comment of it says it is much slower than
>>>>> normal spin_lock, but we may not care the efficiency of poll
>>>>> cancellation very much?).
>>>>
>>>> I don't think the bit spinlocks are going to be useful, we should
>>>> stick with a spinlock for this. They are indeed slower and generally 
>>>> not
>>>> used for that reason. For a use case where you need a ton of locks and
>>>> saving the 4 bytes for a spinlock would make sense (or maybe not
>>>> changing some struct?), maybe they have a purpose. But not for this.
>>>
>>> We can put the cancel hashes under uring_lock and completely kill
>>> the hash spinlocking (2 lock/unlock pairs per single-shot). The code
>>> below won't even compile and missing cancellation bits, I'll pick it
>>> up in a week.
>>>
>>> Even better would be to have two hash tables, and auto-magically apply
>>> the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
>>> and apoll (need uring_lock after anyway).
>>
>> My hope was that it'd take us closer to being able to use more granular
>> locking for hashing in general. I don't care too much about the
>> cancelation, but the normal hash locking would be useful to do.
>>
>> However, for cancelations, under uring_lock would indeed be preferable
>> to doing per-bucket locks there. Guess I'll wait and see what your final
>> patch looks like, not sure why it'd be a ctx conditional?
> 
> It replaces 2 spin lock/unlock with one io_tw_lock() in the completion
> path, which is done once per tw batch and grabbed anyway if
> there is no contention (see handle_tw_list()).
> 
> It could be unconditional, but I'd say for those 3 cases we have
> non-existing chance to regress perf/latency, but I can think of
> some cases where it might screw latencies, all share io_uring
> b/w threads.
> 
> Should benefit the cancellation path as well, but I don't care
> about it as well.
> 
>> What about io_poll_remove_all()?
> 
> As mentioned, it's not handled in the diff, but easily doable,
> it should just traverse both hash tables.
> 

Two hash tables looks good to me. If I don't get you wrong, one table
under uring_lock, the other one for normal handling(like per bucket
locking)?

