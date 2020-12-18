Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571DC2DE8BF
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgLRSHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:07:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39850 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgLRSHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:07:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3nvL110792;
        Fri, 18 Dec 2020 18:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GSIJurSzoqgP8Fow7wrya31zWmf8HM6KMr9J5580lPw=;
 b=RgyBhbI58il15+Ph6hFmOLkQk82bMOlnRh7ph5drIETfl3zJlTjqlUCKxyf3gcvZsJv2
 0MIYrF6If7KlnXxbk+e8IwHz8N1fMaIzaxRl8dSOn3sFWg+1hFDh8u1SN4cB2IaZmGNj
 lEY0oNfHz76obip/xYhH/wmAGqxj5CshZ0ygdGGMP+J1ZSu0BmR85rxKlXGNvVh98C07
 1Ykng0ciYgq70iGipHoSLT7vBhgvDfjcTJz4ziLmKM+QKkt351W8OVCqbHb0ewELKyql
 /41qw31FDdSb2XpG/RykO52G6WHFySTzDsYGgJF0RRdkab1T4cbn3JpbB4D41xApqLVk 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:06:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5R4u095832;
        Fri, 18 Dec 2020 18:06:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35e6ev0wm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:06:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII6Qd8015957;
        Fri, 18 Dec 2020 18:06:26 GMT
Received: from [10.154.184.112] (/10.154.184.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:06:26 -0800
Subject: Re: [PATCH v2 13/13] io_uring: support buffer registration sharing
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
 <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <2070b1b5-2931-7782-305f-c578b3b24567@oracle.com>
Date:   Fri, 18 Dec 2020 10:06:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201217-2, 12/17/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>> @@ -8415,6 +8421,12 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>>   	if (!data)
>>   		return -ENXIO;
>>   
>> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
>> +		io_detach_buf_data(ctx);
>> +		ctx->nr_user_bufs = 0;
> 
> nr_user_bufs is a part of invariant and should stay together with
> stuff in io_detach_buf_data().

Moved to io_detach_buf_data.


>> @@ -8724,9 +8740,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>>   	struct fixed_rsrc_ref_node *ref_node;
>>   	struct fixed_rsrc_data *buf_data;
>>   
>> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
>> +		if (!ctx->buf_data)
>> +			return -EFAULT;
>> +		ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;
> 
> Why? Once a table is initialised it shouldn't change its size, would
> be racy otherwise.

ctx->buf_data is set at ring setup time but the sharing process 
(SETUP_SHARE) may do the actual buffer registration at an arbitrary time 
later, so the attaching process must ensure to get the updated value of 
nr_user_bufs if available.

>>   	buf_data = io_buffers_map_alloc(ctx, nr_args);
>>   	if (IS_ERR(buf_data))
>>   		return PTR_ERR(buf_data);
>> +	ctx->buf_data = buf_data;
> 
> Wanted to write that there is missing
> `if (ctx->user_bufs) return -EBUSY`
> 
> but apparently it was moved into io_buffers_map_alloc().
> I'd really prefer to have it here.

Moved it back.

>> +static int io_attach_buf_data(struct io_ring_ctx *ctx,
>> +			      struct io_uring_params *p)
>> +{
>> +	struct io_ring_ctx *ctx_attach;
>> +	struct fd f;
>> +
>> +	f = fdget(p->wq_fd);
>> +	if (!f.file)
>> +		return -EBADF;
>> +	if (f.file->f_op != &io_uring_fops) {
>> +		fdput(f);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ctx_attach = f.file->private_data;
>> +	if (!ctx_attach->buf_data) {
> 
> It looks racy. What prevents it from being deleted while we're
> working on it, e.g. by io_sqe_buffers_unregister?

I think the premise here is that buffer sharing happens between trusted 
and coordinated processes.  If I understand your concern correctly, then 
if the sharing process unregisters its buffers after having shared them, 
than that process is acting improperly.  The race could lead to a failed 
attach but that would be expected and reasonable I would think?  What do 
you think should happen in this case?

> 
>> +		fdput(f);
>> +		return -EINVAL;
>> +	}
>> +	ctx->buf_data = ctx_attach->buf_data;
> 
> Before updates, etc. (e.g. __io_sqe_buffers_update()) were synchronised
> by uring_lock, now it's modified concurrently, that looks to be really
> racy.

Racy from the attaching process perspective you mean?

> 
>> +
>> +	percpu_ref_get(&ctx->buf_data->refs);
> 
> Ok, now the original io_uring instance will wait until the attached
> once get rid of their references. That's a versatile ground to have
> in kernel deadlocks.
> 
> task1: uring1 = create()
> task2: uring2 = create()
> task1: uring3 = create(share=uring2);
> task2: uring4 = create(share=uring1);
> 
> task1: io_sqe_buffers_unregister(uring1)
> task2: io_sqe_buffers_unregister(uring2)
> 
> If I skimmed through the code right, that should hang unkillably.

So we need a way to enforce that a process can only have one role, 
sharing or attaching? But I'm not what the best way to do that.  Is this 
an issue for other resource sharing, work queues or polling thread?

