Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2C26F1570
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 12:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345476AbjD1K3o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 06:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjD1K3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 06:29:43 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95C601FCA;
        Fri, 28 Apr 2023 03:29:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42338C14;
        Fri, 28 Apr 2023 03:30:26 -0700 (PDT)
Received: from [10.57.57.22] (unknown [10.57.57.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CDB23F64C;
        Fri, 28 Apr 2023 03:29:41 -0700 (PDT)
Message-ID: <002c3a2a-df57-1997-1739-9675a6c8dd46@arm.com>
Date:   Fri, 28 Apr 2023 11:29:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] io_uring/kbuf: Fix size for shared buffer ring
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, kevin.brodsky@arm.com,
        linux-kernel@vger.kernel.org
References: <20230427143142.3013020-1-tudor.cretu@arm.com>
 <03b13c8f-0f4c-0692-b2f0-e90d7877e327@kernel.dk>
Content-Language: en-US
From:   Tudor Cretu <tudor.cretu@arm.com>
In-Reply-To: <03b13c8f-0f4c-0692-b2f0-e90d7877e327@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 27-04-2023 19:42, Jens Axboe wrote:
> On 4/27/23 8:31 AM, Tudor Cretu wrote:
>> The size of the ring is the product of ring_entries and the size of
>> struct io_uring_buf. Using struct_size is equivalent to
>>    (ring_entries + 1) * sizeof(struct io_uring_buf)
>> and generates an off-by-one error. Fix it by using size_mul directly.
>>
>> Signed-off-by: Tudor Cretu <tudor.cretu@arm.com>
>> ---
>>   io_uring/kbuf.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 4a6401080c1f..9770757c89a0 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -505,7 +505,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>>   	}
>>   
>>   	pages = io_pin_pages(reg.ring_addr,
>> -			     struct_size(br, bufs, reg.ring_entries),
>> +			     size_mul(sizeof(struct io_uring_buf), reg.ring_entries),
>>   			     &nr_pages);
>>   	if (IS_ERR(pages)) {
>>   		kfree(free_bl);
> 
> Looking into this again, and some bells ringing in the back of my head,
> we do have:
> 
> commit 48ba08374e779421ca34bd14b4834aae19fc3e6a
> Author: Wojciech Lukowicz <wlukowicz01@gmail.com>
> Date:   Sat Feb 18 18:41:41 2023 +0000
> 
>      io_uring: fix size calculation when registering buf ring
> 
> which should have fixed that issue. What kernel version are you looking at?

Hi Jens,

Thank you for your message. Indeed I was looking at a slightly older 
version of the kernel. Apologies for the noise!

Kind regards,
Tudor

> 
