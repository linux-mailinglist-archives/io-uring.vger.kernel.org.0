Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D112FBA6A
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389698AbhASOyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:44 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42398 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404321AbhASNW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:22:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMEzLvV_1611061941;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UMEzLvV_1611061941)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Jan 2021 21:12:21 +0800
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <jiangqi903@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
 <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
 <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
 <17125fd3-1d0e-1c71-374a-9a7a7382c8fc@gmail.com>
 <3572b340-ce74-765f-c6bd-0179b3756a1b@gmail.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <f202d3da-0b84-9d35-5da6-d0b7f31d740d@linux.alibaba.com>
Date:   Tue, 19 Jan 2021 21:12:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3572b340-ce74-765f-c6bd-0179b3756a1b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/19/21 7:45 PM, Pavel Begunkov wrote:
> On 19/01/2021 08:00, Joseph Qi wrote:
>>
>>
>> On 1/19/21 10:38 AM, Pavel Begunkov wrote:
>>> On 19/01/2021 01:58, Joseph Qi wrote:
>>>>> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
>>>>> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
>>>>> it to grab a struct file, that is wrong.
>>>>> Probably worked out because it just grabbed fd=0/stdin.
>>>>>
>>>>
>>>> I think IO_WQ_WORK_FILES can work since it will acquire
>>>> files when initialize async cancel request.
>>>
>>> That the one controlling files in the first place, need_file
>>> just happened to grab them submission.
>>>
>>>> Don't quite understand why we should have IO_WQ_WORK_BLKCG.
>>>
>>> Because it's set for IORING_OP_CLOSE, and similar situation
>>> may happen but with async_cancel from io-wq.
>>>
>> So how about do switch and restore in io_run_cancel(), seems it can
>> take care of direct request, sqthread and io-wq cases.
> 
> It will get ugly pretty quickly, + this nesting of io-wq handlers
> async_handler() -> io_close() is not great...
> 
> I'm more inclined to skip them in io_wqe_cancel_pending_work()
> to not execute inline. That may need to do some waiting on the
> async_cancel side though to not change the semantics. Can you
> try out this direction?
> 
Sure, I'll try this way and send v2.

Thanks,
Joseph
