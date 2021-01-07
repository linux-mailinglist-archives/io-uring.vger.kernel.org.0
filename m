Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB562EE797
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 22:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbhAGVWN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 16:22:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbhAGVWN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 16:22:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107L90UF169042;
        Thu, 7 Jan 2021 21:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PvgWtOzCv5dAq/zTJS/Hvw1uqK+FvCmB1Ttrsamdirg=;
 b=PGJCRlb9LSBbL9Po7lvLuo7ZJ7ZyuVUUH0BXh5tc111A0I5gnA/rLY8YWU4uQFNtkI9O
 2zHUKzfrjj7C18q86FrxzDCfNxoEMAFdagAmcCBZrM5wgoEVlsAaLkTTgXdV4gKxzki/
 7b7vm5roMvb2Fojy7PkLTcQYYcdk9CvAdjDDnrScizPLVl0/C2G0bnm7KjnKADGtk+pI
 seAzahYL7ebtBazWfmbECrhIbPTphrTR6vtTXewlja2sJ6AwD8ve+OAElPFrjCB/7hSA
 QxJt5fU9nlcqa3vwtd1bzpAmy3sYxrm6/yysWQjYoCdu2itg6eDbk1X6M177/qCPXNt5 JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmed7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 21:21:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107LAtnk017691;
        Thu, 7 Jan 2021 21:21:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35v1fbqtyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 21:21:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107LLRvm006069;
        Thu, 7 Jan 2021 21:21:27 GMT
Received: from [10.154.113.215] (/10.154.113.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 13:21:27 -0800
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
 <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <20b6a902-4193-22fe-2cd7-569024648a26@oracle.com>
Date:   Thu, 7 Jan 2021 13:21:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070123
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>> Because it's do quiesce, fixed read/write access buffers from asynchronous
>>> contexts without synchronisation. That won't work anymore, so
>>>
>>> 1. either we save it in advance, that would require extra req_async
>>> allocation for linked fixed rw
>>>
>>> 2. or synchronise whenever async. But that would mean that a request
>>> may get and do IO on two different buffers, that's rotten.
>>>
>>> 3. do mixed -- lazy, but if do IO then alloc.
>>>
>>> 3.5 also "synchronise" there would mean uring_lock, that's not welcome,
>>> but we can probably do rcu.
>>
>> Are you referring to a case where a fixed buffer request can be submitted from async context while those buffers are being unregistered, or something like that?
>>
>>> Let me think of a patch...
> 
> The most convenient API would be [1], it selects a buffer during
> submission, but allocates if needs to go async or for all linked
> requests.
> 
> [2] should be correct from the kernel perspective (no races), it
> also solves doing IO on 2 different buffers, that's nasty (BTW,
> [1] solves this problem naturally). However, a buffer might be
> selected async, but the following can happen, and user should
> wait for request completion before removing a buffer.
> 
> 1. register buf id=0
> 2. syscall io_uring_enter(submit=RW_FIXED,buf_id=0,IOSQE_ASYNC)
> 3. unregister buffers
> 4. the request may not find the buffer and fail.
> 
> Not very convenient + can actually add overhead on the userspace
> side, can be even some heavy synchronisation.
> 
> uring_lock in [2] is not nice, but I think I can replace it
> with rcu, probably can even help with sharing, but I need to
> try to implement to be sure.
> 
> So that's an open question what API to have.
> Neither of diffs is tested.
> 
> [1]
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7e35283fc0b1..2171836a9ce3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -826,6 +826,7 @@ static const struct io_op_def io_op_defs[] = {
>   		.needs_file		= 1,
>   		.unbound_nonreg_file	= 1,
>   		.pollin			= 1,
> +		.needs_async_data	= 1,
>   		.plug			= 1,
>   		.async_size		= sizeof(struct io_async_rw),
>   		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
> @@ -835,6 +836,7 @@ static const struct io_op_def io_op_defs[] = {
>   		.hash_reg_file		= 1,
>   		.unbound_nonreg_file	= 1,
>   		.pollout		= 1,
> +		.needs_async_data	= 1,
>   		.plug			= 1,
>   		.async_size		= sizeof(struct io_async_rw),
>   		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE |
> 
> 
> 
> [2]
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7e35283fc0b1..31560b879fb3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3148,7 +3148,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>   	opcode = req->opcode;
>   	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
>   		*iovec = NULL;
> -		return io_import_fixed(req, rw, iter);
> +
> +		io_ring_submit_lock(req->ctx, needs_lock);
> +		lockdep_assert_held(&req->ctx->uring_lock);
> +		ret = io_import_fixed(req, rw, iter);
> +		io_ring_submit_unlock(req->ctx, needs_lock);
> +		return ret;
>   	}
>   
>   	/* buffer index only valid with fixed read/write, or buffer select  */
> @@ -3638,7 +3643,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>   copy_iov:
>   		/* some cases will consume bytes even on error returns */
>   		iov_iter_revert(iter, io_size - iov_iter_count(iter));
> -		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
> +		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
>   		if (!ret)
>   			return -EAGAIN;
>   	}
> 
> 

For my understanding, is [1] essentially about stashing the iovec for 
the fixed IO in an io_async_rw struct and referencing it in async 
context?  I don't understand how this prevents unregistering the buffer 
(described by the iovec) while the IO takes place.

Taking a step back, what is the cost of keeping the quiesce for buffer 
registration operations?  It should not be a frequent operation even a 
heavy handed quiesce should not be a big issue?
