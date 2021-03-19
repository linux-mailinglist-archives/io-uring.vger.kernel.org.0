Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5444C341A39
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 11:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCSKkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 06:40:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40446 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCSKjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 06:39:55 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lNCXq-0001CN-99; Fri, 19 Mar 2021 10:39:54 +0000
Subject: Re: [PATCH] io_uring: fix provide_buffers sign extension
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
 <a0a52343-0bf9-79c0-d1c3-0d049487c5cc@canonical.com>
 <763d7d4f-5264-2db0-ee17-1b10699c095b@gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <280d0b86-1d49-2641-edc7-02de8bb01b92@canonical.com>
Date:   Fri, 19 Mar 2021 10:39:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <763d7d4f-5264-2db0-ee17-1b10699c095b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/03/2021 10:34, Pavel Begunkov wrote:
> On 19/03/2021 10:31, Colin Ian King wrote:
>> On 19/03/2021 10:21, Pavel Begunkov wrote:
>>> io_provide_buffers_prep()'s "p->len * p->nbufs" to sign extension
>>> problems. Not a huge problem as it's only used for access_ok() and
>>> increases the checked length, but better to keep typing right.
>>>
>>> Reported-by: Colin Ian King <colin.king@canonical.com>
>>> Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index c2489b463eb9..4f1c98502a09 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -3978,6 +3978,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
>>>  static int io_provide_buffers_prep(struct io_kiocb *req,
>>>  				   const struct io_uring_sqe *sqe)
>>>  {
>>> +	unsigned long size;
>>>  	struct io_provide_buf *p = &req->pbuf;
>>>  	u64 tmp;
>>>  
>>> @@ -3991,7 +3992,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
>>>  	p->addr = READ_ONCE(sqe->addr);
>>>  	p->len = READ_ONCE(sqe->len);
>>>  
>>> -	if (!access_ok(u64_to_user_ptr(p->addr), (p->len * p->nbufs)))
>>> +	size = (unsigned long)p->len * p->nbufs;
>>> +	if (!access_ok(u64_to_user_ptr(p->addr), size))
>>>  		return -EFAULT;
>>>  
>>>  	p->bgid = READ_ONCE(sqe->buf_group);
>>>
>>
>> Does it make sense to make size a u64 and cast to a u64 rather than
>> unsigned long?
> 
> static inline int __access_ok(unsigned long addr, unsigned long size)
> {
> 	return 1;
> }
> 
> Not sure. I was thinking about size_t, but ended up sticking
> to access_ok types.
> 
Ah, yep. OK.

Reviewed-by: Colin Ian King <colin.king@canonical.com>
