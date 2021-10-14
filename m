Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40542DAE1
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhJNNzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 09:55:36 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39921 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231464AbhJNNzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 09:55:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Urt-ryH_1634219609;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Urt-ryH_1634219609)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Oct 2021 21:53:29 +0800
Subject: Re: [PATCH for-5.16 0/2] async hybrid, a new way for pollable
 requests
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
 <c0602c8a-d08d-7a0d-0639-ac2ca8d836b1@linux.alibaba.com>
 <16da92ff-39a5-2126-0f12-225017d4d825@gmail.com>
 <9568b6b5-491b-977a-0351-36004a85bf4c@linux.alibaba.com>
Message-ID: <7f7fc777-b32c-23c4-ff44-a424499d34cd@linux.alibaba.com>
Date:   Thu, 14 Oct 2021 21:53:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9568b6b5-491b-977a-0351-36004a85bf4c@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/14 下午4:53, Hao Xu 写道:
> 在 2021/10/12 下午7:39, Pavel Begunkov 写道:
>> On 10/11/21 04:08, Hao Xu wrote:
>>> 在 2021/10/9 下午8:51, Pavel Begunkov 写道:
>>>> On 10/8/21 13:36, Hao Xu wrote:
>>>>> this is a new feature for pollable requests, see detail in commit
>>>>> message.
>>>>
>>>> It really sounds we should do it as a part of IOSQE_ASYNC, so
>>>> what are the cons and compromises?
>>> I wrote the pros and cons here:
>>> https://github.com/axboe/liburing/issues/426#issuecomment-939221300
>>
>> I see. The problem is as always, adding extra knobs, which users
>> should tune and it's not exactly clear where to use what. Not specific
>> to the new flag, there is enough confusion around IOSQE_ASYNC, but it
>> only makes it worse. It would be nice to have it applied
>> "automatically".
>>
>> Say, with IOSQE_ASYNC the copy is always (almost) done by io-wq but
>> there is that polling optimisation on top. Do we care enough about
>> copying specifically in task context to have a different flag?
>>
> I did more tests in a 64 cores machine.
> test command is: nice -n -15 taskset -c 10-20 ./io_uring_echo_server -p 
> 8084 -f -n con_nr -l 1024
> where -n means the number of connections, -l means size of load.
> the results of tps and cpu usage under different IO pressure is:
> (didn't find the way to make it look better, you may need a markdown
> renderer :) )
> tps
> 
> | feature | 1 | 2 | 1000 | 2000 | 3000 | 5800 |
> | -------- | -------- | -------- | -------- | -------- | -------- | 
> -------- |
> | ASYNC     |  123.000    |  295.203    |  67390.432   | 132686.361   | 
> 186084.114   | 319550.540    |
> | ASYNC_HYBRID     |   122.000   |  299.401    |  168321.092   | 
> 188870.283  | 226427.166   |  371580.062   |
> 
> 
> cpu
> 
> | feature | 1 | 2 | 1000 | 2000 | 3000 | 5800 |
> | -------- | -------- | -------- | -------- | -------- | -------- | 
> -------- |
> | ASYNC     |  0.3%    |   1.0%   |   62.5%  |  111.3%  |  198.3%  | 
> 420.9%   |
> | ASYNC_HYBRID     |    0.3%  |   1.0%   |  360%   |  435.5%  |  516.6% 
>   |   1100%  |
> 
> when con_nr is 1000 or more, we leveraged all the 10 cpus. hybrid is
> surely better than async. when con_nr is 1 or 2, in theory async should
> be better since it use more cpu resource, but it didn't, it is because
> the copying in tw is not a bottleneck. So I tried bigger workload, no
> difference. So I think it should be ok to just apply this feature on top
> of IOSQE_ASYNC, for all pollable requests in all condition.
> 
> Regards,
> Hao
>> a quick question, what is "tps" in "IOSQE_ASYNC: 76664.151 tps"?
Forgot this one.. tps = transaction per second, here a transaction means
the client send the workload to the server and receive it from the
server.
>>
>>>>> Hao Xu (2):
>>>>>    io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests
>>>>
>>>> btw, it doesn't make sense to split it into two patches
>>> Hmm, I thought we should make adding a new flag as a separate patch.
>>> Could you give me more hints about the considerration here?
>>
>> You can easily ignore it, just looked weird to me. Let's try to
>> phrase it:
>>
>> 1) 1/2 doesn't do anything useful w/o 2/2, iow it doesn't feel like
>> an atomic change. And it would be breaking the userspace, if it's
>> not just a hint flag.
>>
>> 2) it's harder to read, you search the git history, find the
>> implementation (and the flag is already there), you think what's
>> happening here, where the flag was used and so to find out that
>> it was added separately a commit ago.
>>
>> 3) sometimes it's done similarly because the API change is not
>> simple, but it's not the case here.
>> By similarly I mean the other way around, first implement it
>> internally, but not exposing any mean to use it, and adding
>> the userspace API in next commits.
>>
>>>>>    io_uring: implementation of IOSQE_ASYNC_HYBRID logic
>>>>>
>>>>>   fs/io_uring.c                 | 48 
>>>>> +++++++++++++++++++++++++++++++----
>>>>>   include/uapi/linux/io_uring.h |  4 ++-
>>>>>   2 files changed, 46 insertions(+), 6 deletions(-)
>>>>>
>>>>
>>>
>>

