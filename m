Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10BD401806
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbhIFI1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 04:27:42 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:38506 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241063AbhIFI1j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 04:27:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnOxwuy_1630916793;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnOxwuy_1630916793)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Sep 2021 16:26:33 +0800
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
 <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c991b4fa-e099-71c0-656f-e952a0758fe5@linux.alibaba.com>
Date:   Mon, 6 Sep 2021 16:26:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/6 上午3:44, Jens Axboe 写道:
> On 9/4/21 4:46 PM, Pavel Begunkov wrote:
>> On 9/4/21 7:40 PM, Jens Axboe wrote:
>>> On 9/4/21 9:34 AM, Hao Xu wrote:
>>>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>>>
>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>> ---
>>>>>>    fs/io_uring.c | 14 ++++++++++++--
>>>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>>> --- a/fs/io_uring.c
>>>>>> +++ b/fs/io_uring.c
>>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>    static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>    {
>>>>>>    	struct io_accept *accept = &req->accept;
>>>>>> +	bool is_multishot;
>>>>>>    
>>>>>>    	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>    		return -EINVAL;
>>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>    	accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>>    	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>>    
>>>>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>>> +		return -EINVAL;
>>>>>
>>>>> I like the idea itself as I think it makes a lot of sense to just have
>>>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>>>> which can currently be:
>>>>>
>>>>> SOCK_NONBLOCK
>>>>> SOCK_CLOEXEC
>>>>>
>>>>> While there's not any overlap here, that is mostly by chance I think. A
>>>>> cleaner separation is needed here, what happens if some other accept4(2)
>>>>> flag is enabled and it just happens to be the same as
>>>>> IORING_ACCEPT_MULTISHOT?
>>>> Make sense, how about a new IOSQE flag, I saw not many
>>>> entries left there.
>>>
>>> Not quite sure what the best approach would be... The mshot flag only
>>> makes sense for a few request types, so a bit of a shame to have to
>>> waste an IOSQE flag on it. Especially when the flags otherwise passed in
>>> are so sparse, there's plenty of bits there.
>>>
>>> Hence while it may not be the prettiest, perhaps using accept->flags is
>>> ok and we just need some careful code to ensure that we never have any
>>> overlap.
>>
>> Or we can alias with some of the almost-never-used fields like
>> ->ioprio or ->buf_index.
> 
> It's not a bad idea, as long as we can safely use flags from eg ioprio
> for cases where ioprio would never be used. In that sense it's probably
> safer than using buf_index.
> 
> The alternative is, as has been brougt up before, adding a flags2 and
> reserving the last flag in ->flags to say "there are flags in flags2".
May I ask when do we have to use a bit in ->flags to do this? My
understanding is just leverage a __u8 in pad2[2] in io_uring_sqe to
deliver ext_flags.
> Not exactly super pretty either, but we'll need to extend them at some
> point.
> 

