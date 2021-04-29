Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FD536E3C5
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 05:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbhD2Dm1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 23:42:27 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55015 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237026AbhD2Dm1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 23:42:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX7MrO7_1619667698;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX7MrO7_1619667698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 11:41:39 +0800
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <3aa943b1-b53e-c3c5-7a45-278c2eebb861@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 11:41:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/28 下午10:16, Jens Axboe 写道:
> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index e1ae46683301..311532ff6ce3 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -98,6 +98,7 @@ enum {
>>>   #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>>>   #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>>   #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
>>> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>>>   
>>>   enum {
>>>   	IORING_OP_NOP,
>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>   	__u32 cq_entries;
>>>   	__u32 flags;
>>>   	__u32 sq_thread_cpu;
>>> -	__u32 sq_thread_idle;
>>> +	__u64 sq_thread_idle;
>>
>> breaks userspace API
> 
> And I don't think we need to. If you're using IDLE_NS, then the value
> should by definition be small enough that it'd fit in 32-bits. If you
I make it u64 since I thought users may want a full flexibility to set
idle in nanosecond granularity(eg. (1e6 + 10) ns cannot be set by
millisecond granularity). But I'm not sure if this deserve changing the
userspace API.
> need higher timeouts, don't set it and it's in usec instead.
> 
> So I'd just leave this one alone.
> 

