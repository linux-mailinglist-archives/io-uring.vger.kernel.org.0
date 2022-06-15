Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D594954C1C4
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 08:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiFOGYt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 02:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352299AbiFOGYs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 02:24:48 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2613027FEE
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 23:24:47 -0700 (PDT)
Message-ID: <bc2e2829-0910-28a8-29d2-3d970b65337c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655274285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+4xajxiGyRTG5jjeQ7wlRjD/ePGS/BrnVDG18kMGkk=;
        b=bpvTQGa230T2Xryhv8k9eEQA31TkUMH4unR9OwxDGydXyCydQbJMm/8o7aMYjj3PM/kv+5
        u40evJiOvRSNYMYoyn+2HQXGHOErj4eMQluO4t7hjhx8j+kUCejtPUKhx99aXC/7U/XY2M
        jxIPQ0ZnhWyfQ6Gf3GpTxs96lfnn5XA=
Date:   Wed, 15 Jun 2022 14:24:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1655219150.git.asml.silence@gmail.com>
 <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
 <da4c0717-be10-c298-9074-b237ea613ba5@gmail.com>
 <bd18039b-2a06-62c8-77e2-6b86ba3c2d73@kernel.dk>
 <9f85b4b2bddf00b3e2962679a4b3e07f5b6b0e7b.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <9f85b4b2bddf00b3e2962679a4b3e07f5b6b0e7b.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 02:23, Dylan Yudaken wrote:
> On Tue, 2022-06-14 at 09:51 -0600, Jens Axboe wrote:
>> On 6/14/22 9:48 AM, Pavel Begunkov wrote:
>>> On 6/14/22 16:30, Jens Axboe wrote:
>>>> On 6/14/22 9:27 AM, Pavel Begunkov wrote:
>>>>> Add some tests to check the kernel enforcing single-issuer
>>>>> right, and
>>>>> add a simple poll benchmark, might be useful if we do poll
>>>>> changes.
>>>>
>>>> Should we add a benchmark/ or something directory rather than use
>>>> examples/ ?
>>>>
>>>> I know Dylan was looking at that at one point. I don't feel too
>>>> strongly, as long as it doesn't go into test/.
>>>
>>> I don't care much myself, I can respin it once (if) the kernel
>>> side is queued.
>>
>> I'm leaning towards just using examples/ - but maybe Dylan had some
>> reasoning for the new directory. CC'ed.
>>
> 
> I wanted to have some common framework for benchmarks to make it easy
> to write new ones and get some nice numbers. In that case it would make
> sense for them to be in one place.

This sounds great, it's really nice to have a series of standard
performance tests rather than temporary tests created along with new
kernel patches. A framework is something nicer. Actually there are
people doing this though just a simple one, FWIW:

https://gitee.com/anolis/perf-test-for-io_uring

> 
> But I haven't finished it yet, so probably for now examples/ is best
> and if/when I finish it I can port these over.
> 

