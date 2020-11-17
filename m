Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122392B71ED
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 00:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKQXAB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 18:00:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbgKQXAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 18:00:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHMsSFO013757;
        Tue, 17 Nov 2020 22:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0yPIDotgO/tufiYlPJpXSy2QBzJ+p1Ut62esGc+Aohc=;
 b=Vye0X4iZ+ak8bYOL4ZQLgF2Oi67NCBEoUL7yvwW4xZCb+psyHOM0XUHTigk5rE0uHnzS
 6sCRTUabj7vqxwlkaQKsKvrGGkoarjLx4TDlM4+B4IVu2rbJVHh8AvKXfUzXGwDoKpog
 zcq5MW5sokwN9PiUEFfmNWt89EdPp6OEHiiALMOCAm94EMBanTQFUo3HOlCkfQE09RG0
 qfyAbqW7xgK42LmUm+WNaTd9DLk/BhdZCn1x0/a0AV3494wLIAJw95xS54t9XiPjvh1u
 N8JSDS98jIKgVB/a+ZviLSEwcKvxlJEal9G4fTk60lCKzBKNX/5r3pIUv5LwFdml/5Bx qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rawe7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 22:59:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHMuXDL158545;
        Tue, 17 Nov 2020 22:59:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34ts5wr2r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 22:59:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AHMxtBb011971;
        Tue, 17 Nov 2020 22:59:55 GMT
Received: from [10.154.123.147] (/10.154.123.147)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 14:59:55 -0800
Subject: Re: [PATCH 7/8] io_uring: support readv/writev with fixed buffers
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
 <d8c1c348-7806-ce54-c683-0c08e44d4590@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <0bf865dc-14d3-9521-26d9-c91873535146@oracle.com>
Date:   Tue, 17 Nov 2020 14:59:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <d8c1c348-7806-ce54-c683-0c08e44d4590@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170170
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> Support readv/writev with fixed buffers, and introduce IOSQE_FIXED_BUFFER,
>> consistent with fixed files.
> 
> I don't like it at all, see issues below. The actual implementation would
> be much uglier.
> 
> I propose you to split the series and push separately. Your first 6 patches
> first, I don't have conceptual objections to them. Then registration sharing
> (I still need to look it up). And then we can return to this, if you're not
> yet convinced.

Ok.  The sharing patch is actually the highest priority for us so it'd 
be great to know if you think it's in the right direction.

Should I submit them as they are or address your fixed_file_ref comments 
in Patch 4/8 as well?  Would I need your prep patch beforehand?

>> +static ssize_t io_import_iovec_fixed(int rw, struct io_kiocb *req, void *buf,
>> +				     unsigned segs, unsigned fast_segs,
>> +				     struct iovec **iovec,
>> +				     struct iov_iter *iter)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_mapped_ubuf *imu;
>> +	struct iovec *iov;
>> +	u16 index, buf_index;
>> +	ssize_t ret;
>> +	unsigned long seg;
>> +
>> +	if (unlikely(!ctx->buf_data))
>> +		return -EFAULT;
>> +
>> +	ret = import_iovec(rw, buf, segs, fast_segs, iovec, iter);
> 
> Did you test it? import_iovec() does access_ok() against each iov_base,
> which in your case are an index.

I used liburing:test/file-{register,update} as models for the equivalent 
buffer tests and they seem to work.  I can send out the tests and the 
liburing changes if you want.

The fixed io test registers an empty iov table first:

	ret = io_uring_register_buffers(ring, iovs, UIO_MAXIOV);

It next updates the table with two actual buffers at offset 768:

         ret = io_uring_register_buffers_update(ring, 768, ups, 2);

It later uses the buffer at index 768 for writev similar to the 
file-register test (IOSQE_FIXED_BUFFER instead of IOSQE_FIXED_FILE):

         iovs[768].iov_base = (void *)768;
         iovs[768].iov_len = pagesize;


         io_uring_prep_writev(sqe, fd, iovs, 1, 0);
         sqe->flags |= IOSQE_FIXED_BUFFER;

         ret = io_uring_submit(ring);

Below is the iovec returned from

io_import_iovec_fixed()
-> io_import_vec()

{iov_base = 0x300 <dm_early_create+412>, iov_len = 4096}

>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	iov = (struct iovec *)iter->iov;
>> +
>> +	for (seg = 0; seg < iter->nr_segs; seg++) {
>> +		buf_index = *(u16 *)(&iov[seg].iov_base);
> 
> That's ugly, and also not consistent with rw_fixed, because iov_base is
> used to calculate offset.

Would offset be applicable when using readv/writev?

My thinkig was that for those cases, each iovec should be used exactly 
as registered.

> 
>> +		if (unlikely(buf_index < 0 || buf_index >= ctx->nr_user_bufs))
>> +			return -EFAULT;
>> +
>> +		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
>> +		imu = io_buf_from_index(ctx, index);
>> +		if (!imu->ubuf || !imu->len)
>> +			return -EFAULT;
>> +		if (iov[seg].iov_len > imu->len)
>> +			return -EFAULT;
>> +
>> +		iov[seg].iov_base = (void *)imu->ubuf;
> 
> Nope, that's not different from non registered version.
> What import_fixed actually do is setting up the iter argument to point
> to a bvec (a vector of struct page *).

So in fact, the buffers end up being pinned again because they are not 
being as bvecs?

> 
> So it either would need to keep a vector of bvecs, that's a vector of vectors,
> that's not supported by iter, etc., so you'll also need to iterate over them
> in io_read/write and so on. Or flat 2D structure into 1D, but that's still ugly.

So you're saying there's no clean way to create a readv/writev + fixed 
buffers API?  It would've been nice to have a consistent API between 
files and buffers.


>> @@ -5692,7 +5743,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
>>   {
>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>   		return -EINVAL;
>> -	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>> +	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
> 
> Why it's here?
> 
> #define REQ_F_FIXED_RSRC	(REQ_F_FIXED_FILE | REQ_F_FIXED_BUFFER)
> So, why do you | with REQ_F_BUFFER_SELECT again here?

I thought to group fixed files/buffers but distinguish them from 
selected buffers.

>> @@ -87,6 +88,8 @@ enum {
>>   #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>>   /* select buffer from sqe->buf_group */
>>   #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
>> +/* use fixed buffer set */
>> +#define IOSQE_FIXED_BUFFER	(1U << IOSQE_FIXED_BUFFER_BIT)
> 
> Unfortenatuly, we're almost out of flags bits -- it's a 1 byte
> field and 6 bits are already taken. Let's not use it.
