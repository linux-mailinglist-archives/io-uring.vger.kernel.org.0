Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA695FA445
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 21:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJJTkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJJTks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 15:40:48 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Oct 2022 12:40:46 PDT
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9215FF48
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 12:40:45 -0700 (PDT)
Received: (qmail 7681 invoked by uid 89); 10 Oct 2022 19:34:05 -0000
Received: from unknown (HELO ?IPV6:2620:10d:c085:2103:475:ef07:bb37:8b7b?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 10 Oct 2022 19:34:05 -0000
Message-ID: <ff17c609-7a6d-a144-c835-a72d5a965d28@flugsvamp.com>
Date:   Mon, 10 Oct 2022 12:34:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [RFC v1 0/9] zero-copy RX for io_uring
Content-Language: en-US
To:     dust.li@linux.alibaba.com,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        io-uring@vger.kernel.org
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
 <20221010073712.GE108825@linux.alibaba.com>
From:   Jonathan Lemon <jlemon@flugsvamp.com>
In-Reply-To: <20221010073712.GE108825@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/22 12:37 AM, dust.li wrote:
> On Fri, Oct 07, 2022 at 02:17:04PM -0700, Jonathan Lemon wrote:
>> This series is a RFC for io_uring/zctap.  This is an evolution of
>> the earlier zctap work, re-targeted to use io_uring as the userspace
>> API.  The current code is intended to provide a zero-copy RX path for
>> upper-level networking protocols (aka TCP and UDP).  The current draft
>> focuses on host-provided memory (not GPU memory).
>>
>> This RFC contains the upper-level core code required for operation,
>> with the intent of soliciting feedback on the general API.  This does
>> not contain the network driver side changes required for complete
>> operation.  Also please note that as an RFC, there are some things
>> which are incomplete or in need of rework.
>>
>> The intent is to use a network driver which provides header/data
>> splitting, so the frame header (which is processed by the networking
>> stack) does not reside in user memory.
>>
>> The code is roughly working (in that it has successfully received
>> a TCP stream from a remote sender), but as an RFC, the intent is
>> to solicit feedback on the API and overall design.  The current code
>> will also work with system pages, copying the data out to the
>> application - this is intended as a fallback/testing path.
>>
>> High level description:
>>
>> The application allocates a frame backing store, and provides this
>> to the kernel for use.  An interface queue is requested from the
>> networking device, and incoming frames are deposited into the provided
>> memory region.
>>
>> Responsibility for correctly steering incoming frames to the queue
>> is outside the scope of this work - it is assumed that the user
>> has set steering rules up separately.
>>
>> Incoming frames are sent up the stack as skb's and eventually
>> land in the application's socket receive queue.  This differs
>>from AF_XDP, which receives raw frames directly to userspace,
>> without protocol processing.
>>
>> The RECV_ZC opcode then returns an iov[] style vector which points
>> to the data in userspace memory.  When the application has completed
>> processing of the data, the buffer is returned back to the kernel
>> through a fill ring for reuse.
> 
> Interesting work ! Any userspace demo and performance data ?

Coming soon!  I'm hoping to get feedback on the overall API though, did 
you have any thoughts here?
-- 
Jonathan

