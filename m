Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA685400BEC
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhIDPgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 11:36:00 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40143 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhIDPgA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 11:36:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnDBaYc_1630769696;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnDBaYc_1630769696)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 04 Sep 2021 23:34:56 +0800
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
Date:   Sat, 4 Sep 2021 23:34:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/4 上午12:29, Jens Axboe 写道:
> On 9/3/21 5:00 AM, Hao Xu wrote:
>> Update io_accept_prep() to enable multishot mode for accept operation.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index eb81d37dce78..34612646ae3c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>   	struct io_accept *accept = &req->accept;
>> +	bool is_multishot;
>>   
>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>   		return -EINVAL;
>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>>   
>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>> +		return -EINVAL;
> 
> I like the idea itself as I think it makes a lot of sense to just have
> an accept sitting there and generating multiple CQEs, but I'm a bit
> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
> which can currently be:
> 
> SOCK_NONBLOCK
> SOCK_CLOEXEC
> 
> While there's not any overlap here, that is mostly by chance I think. A
> cleaner separation is needed here, what happens if some other accept4(2)
> flag is enabled and it just happens to be the same as
> IORING_ACCEPT_MULTISHOT?
Make sense, how about a new IOSQE flag, I saw not many
entries left there.
> 

