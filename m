Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2436E44A
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 06:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhD2EoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 00:44:04 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37719 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhD2EoE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 00:44:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX82tUA_1619671396;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX82tUA_1619671396)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 12:43:16 +0800
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <48d57ee6-995e-147f-186d-6187499d3310@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 12:43:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/28 下午10:39, Jens Axboe 写道:
> On 4/28/21 8:34 AM, Pavel Begunkov wrote:
>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>> sqes are submitted by sqthread when it is leveraged, which means there
>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>> number of sqes in the original task context.
>>> Tests result below:
>>
>> Frankly, it can be a nest of corner cases if not now then in the future,
>> leading to a high maintenance burden. Hence, if we consider the change,
>> I'd rather want to limit the userspace exposure, so it can be removed
>> if needed.
>>
>> A noticeable change of behaviour here, as Hao recently asked, is that
>> the ring can be passed to a task from a completely another thread group,
>> and so the feature would execute from that context, not from the
>> original/sqpoll one.
>>
>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>> ignored if the previous point is addressed.
> 
> I mostly agree on that. The problem I see is that for most use cases,
> the "submit from task itself if we need to enter the kernel" is
> perfectly fine, and would probably be preferable. But there are also
> uses cases that absolutely do not want to spend any extra cycles doing
> submit, they are isolating the submission to sqpoll exclusively and that
> is part of the win there. Based on that, I don't think it can be an
> automatic kind of feature.
> 
> I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
> would likely be better, or maybe even more verbose as
> IORING_ENTER_SQ_SUBMIT_ON_IDLE.
Agree 😂
> 
> On top of that, I don't think an extra submit flag is a huge deal, I
> don't imagine we'll end up with a ton of them. In fact, two have been
> added related to sqpoll since the inception, out of the 3 total added
> flags.
> 
> This is all independent of implementation detail and needed fixes to the
> patch.
> 

