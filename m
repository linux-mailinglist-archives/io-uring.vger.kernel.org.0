Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D75529C4
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 05:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbiFUDi2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 23:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbiFUDi1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 23:38:27 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BC76259
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 20:38:23 -0700 (PDT)
Message-ID: <126cd000-dc9f-76a6-bc88-5c3e3c65891c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655782700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLaZpJtfsnIdO3UGkcOJD5+Dy1J32SrYPTDGoIMkhhk=;
        b=wF0fXZnU51LXz87dLSiIoRD3Pm3ls/pxpv6WHv7w7ekMppX6HXFns54IjbaGf+5cSyXrkG
        BgWVzs1pPtO/DrmNZL2xW7W8pPqmDdqdgwk6r2Tb3pp3g3rLDhMg8mFZ4XTurj88m9NT15
        yuY0zdkPCrH8Gvslxvn3NTrwI1SVo2Y=
Date:   Tue, 21 Jun 2022 11:38:06 +0800
MIME-Version: 1.0
Subject: Re: [RFC] a new way to achieve asynchronous IO
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, dvernet@fb.com
References: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
 <b297ac50-c336-dabe-b6ee-c067b7f418c7@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <b297ac50-c336-dabe-b6ee-c067b7f418c7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/22 21:41, Jens Axboe wrote:
> On 6/20/22 6:01 AM, Hao Xu wrote:
>> Hi,
>> I've some thought on the way of doing async IO. The current model is:
>> (given we are using SQPOLL mode)
>>
>> the sqthread does:
>> (a) Issue a request with nowait/nonblock flag.
>> (b) If it would block, reutrn -EAGAIN
>> (c) The io_uring layer captures this -EAGAIN and wake up/create
>> a io-worker to execute the request synchronously.
>> (d) Try to issue other requests in the above steps again.
>>
>> This implementation has two downsides:
>> (1) we have to find all the block point in the IO stack manually and
>> change them into "nowait/nonblock friendly".
>> (2) when we raise another io-worker to do the request, we submit the
>> request from the very beginning. This isn't a little bit inefficient.
>>
>>
>> While I think we can actually do it in a reverse way:
>> (given we are using SQPOLL mode)
>>
>> the sqthread1 does:
>> (a) Issue a request in the synchronous way
>> (b) If it is blocked/scheduled soon, raise another sqthread2
>> (c) sqthread2 tries to issue other requests in the same way.
>>
>> This solves problem (1), and may solve (2).
>> For (1), we just do the sqthread waken-up at the beginning of schedule()
>> just like what the io-worker and system-worker do. No need to find all
>> the block point.
>> For (2), we continue the blocked request from where it is blocked when
>> resource is satisfied.
>>
>> What we need to take care is making sure there is only one task
>> submitting the requests.
>>
>> To achieve this, we can maintain a pool of sqthread just like the iowq.
>>
>> I've done a very simple/ugly POC to demonstrate this:
>>
>> https://github.com/HowHsu/linux/commit/183be142493b5a816b58bd95ae4f0926227b587b
>>
>> I also wrote a simple test to test it, which submits two sqes, one
>> read(pipe), one nop request. The first one will be block since no data
>> in the pipe. Then a new sqthread was created/waken up to submit the
>> second one and then some data is written to the pipe(by a unrelated
>> user thread), soon the first sqthread is waken up and continues the
>> request.
>>
>> If the idea sounds no fatal issue I'll change the POC to real patches.
>> Any comments are welcome!
> 
> One thing I've always wanted to try out is kind of similar to this, but
> a superset of it. Basically io-wq isn't an explicit offload mechanism,
> it just happens automatically if the issue blocks. This applies to both
> SQPOLL and non-SQPOLL.
> 
> This takes a page out of the old syslet/threadlet that Ingo Molnar did
> way back in the day [1], but it never really went anywhere. But the
> pass-on-block primitive would apply very nice to io_uring.
> 
> That way it'd work is that any issue, SQPOLL or not, would just assume
> that it won't block. If it doesn't block, great, we can complete it
> inline. If it does block, an io-wq thread is grabbed and the context
> moved there. The io-wq takes over the blocking, and the original issue
> returns in some fashion that allows us to know it went implicitly async.

This sounds pretty good, I once thought about this but couldn't figure
it out clearly how to return to the desire place in the original
context.

> 
> This may be a bit more involved than what you suggest here, which in
> nature is similar in how we just hope for the best, and deal with the
> outcome if we did end up blocking.
> 
> Do you have any numbers from your approach?

Currently no, the POC is only to prove the idea works. Shouldn't be hard
to modify it to get some numbers.

> 
> [1] https://lore.kernel.org/all/20070301145742.GC12684@2ka.mipt.ru/T/
> 

I'll take a look and see what I can do.

