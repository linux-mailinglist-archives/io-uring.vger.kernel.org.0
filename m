Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FEF30753D
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhA1Lw6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 06:52:58 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54176 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhA1Lwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 06:52:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UN8Gkqz_1611834725;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UN8Gkqz_1611834725)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Jan 2021 19:52:05 +0800
Subject: Re: [PATCH v2 3/6] block: add iopoll method to support bio-based IO
 polling
To:     Christoph Hellwig <hch@infradead.org>
Cc:     snitzer@redhat.com, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-4-jefflexu@linux.alibaba.com>
 <20210128084016.GA1951639@infradead.org>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <7d5402f2-c4d7-9d9a-e637-54a2dd349b3f@linux.alibaba.com>
Date:   Thu, 28 Jan 2021 19:52:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128084016.GA1951639@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/28/21 4:40 PM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 08:13:37PM +0800, Jeffle Xu wrote:
>> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> 
> Can you split the guts of this function into two separate helpers
> for the mq vs non-mq case?  As is is is a little hard to read and
> introduced extra branches in the fast path.
> 

I know your consideration, actually I had ever tried.

I can extract some helper functions, but I'm doubted if the extra
function call is acceptable.

Besides, the iteration logic is generic and I'm afraid the branch or
function call is unavoidable. Or if we maintain two separate function
for mq and dm, the code duplication may be unavoidable.

Anyway I'll give a try.

-- 
Thanks,
Jeffle
