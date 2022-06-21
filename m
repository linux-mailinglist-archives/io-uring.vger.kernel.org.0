Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB1552C26
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 09:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344834AbiFUHem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 03:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346725AbiFUHej (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 03:34:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8729B12E
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 00:34:38 -0700 (PDT)
Message-ID: <1c29ad13-cc42-8bc5-0f12-3413054a4faf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655796876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBvljbnrxAb1thDQiN6UX3AlI07Jus82oBjTBXDYweU=;
        b=k25zbP+WG2I6bCZaPqwDWpk/fyVo7NF63lPFsB5hlNq6fPZTvUT7zbZV0KTNQaN3Lz5+pg
        W5DJcQ49PT3kIyfKwHxu11TvTOlVrKcie7Ugy6C0KTa5htnWvwtrCkCPUWlQ52MiOlI3B1
        lY1Y/Pv+8D7ReJWsqDMSjrvrZB70puQ=
Date:   Tue, 21 Jun 2022 15:34:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
 <15e36a76-65d5-2acb-8cb7-3952d9d8f7d1@linux.dev>
 <f8c8e52996aaa8fb8c72ae46f0e87e733a9053aa.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <f8c8e52996aaa8fb8c72ae46f0e87e733a9053aa.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/22 15:03, Dylan Yudaken wrote:
> On Tue, 2022-06-21 at 13:10 +0800, Hao Xu wrote:
>> On 6/21/22 00:18, Dylan Yudaken wrote:
>>> Task work currently uses a spin lock to guard task_list and
>>> task_running. Some use cases such as networking can trigger
>>> task_work_add
>>> from multiple threads all at once, which suffers from contention
>>> here.
>>>
>>> This can be changed to use a lockless list which seems to have
>>> better
>>> performance. Running the micro benchmark in [1] I see 20%
>>> improvment in
>>> multithreaded task work add. It required removing the priority tw
>>> list
>>> optimisation, however it isn't clear how important that
>>> optimisation is.
>>> Additionally it has fairly easy to break semantics.
>>>
>>> Patch 1-2 remove the priority tw list optimisation
>>> Patch 3-5 add lockless lists for task work
>>> Patch 6 fixes a bug I noticed in io_uring event tracing
>>> Patch 7-8 adds tracing for task_work_run
>>>
>>
>> Compared to the spinlock overhead, the prio task list optimization is
>> definitely unimportant, so I agree with removing it here.
>> Replace the task list with llisy was something I considered but I
>> gave
>> it up since it changes the list to a stack which means we have to
>> handle
>> the tasks in a reverse order. This may affect the latency, do you
>> have
>> some numbers for it, like avg and 99% 95% lat?
>>
> 
> Do you have an idea for how to test that? I used a microbenchmark as
> well as a network benchmark [1] to verify that overall throughput is
> higher. TW latency sounds a lot more complicated to measure as it's
> difficult to trigger accurately.
> 
> My feeling is that with reasonable batching (say 8-16 items) the
> latency will be low as TW is generally very quick, but if you have an
> idea for benchmarking I can take a look
> 
> [1]: https://github.com/DylanZA/netbench

It can be normal IO requests I think. We can test the latency by fio
with small size IO to a fast block device(like nvme) in SQPOLL
mode(since for non-SQPOLL, it doesn't make difference). This way we can
see the influence of reverse order handling.

Regards,
Hao
