Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E5E2EC78C
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 01:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhAGAxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 19:53:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbhAGAxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 19:53:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1070ZSkM042360;
        Thu, 7 Jan 2021 00:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=Qucdc9VxSExF4+tGkfR9D/Cn3nkDekAmsNwbgQxjJBs=;
 b=M7pFs+72l+wFZFzMMC7sdYP3Ha6c7hml9sjO31Ivupv2YH4tw9e0RHPe1zboQbn5FxFx
 rvriCDR9YB60OeUPiIcrrjw2cj/uu23woiWUd4TeoMOMSwsYEPQUHXZ6PAj1YL4AjFWj
 rD6kgHoItZDqlb3iQ6joaTLZ0Z3OoGp742iFa9D7mQaxDhj4CiOuUdH3ikXCU1aO6l7c
 jLbKzsM9jpGStfuQ33XcnqGbt5gbVt6BTKP/ORx660bdoMLT85q0THk7yV24s4novCwT
 GpoTn4qc7YUxBpHJYFCzdk87tCoy3yxYeUZnTO8UMxc+/xfI6tnqT2N14wdQUcJHhe7U mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35wftxa1hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 00:52:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1070ZRl8101288;
        Thu, 7 Jan 2021 00:50:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35w3g1spsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 00:50:52 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1070opja014376;
        Thu, 7 Jan 2021 00:50:51 GMT
Received: from [10.154.148.218] (/10.154.148.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 16:50:51 -0800
Subject: Re: [PATCH v2 13/13] io_uring: support buffer registration sharing
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
 <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
 <2070b1b5-2931-7782-305f-c578b3b24567@oracle.com>
Message-ID: <074644d5-f299-3b70-9d86-bf4ed59d9674@oracle.com>
Date:   Wed, 6 Jan 2021 16:50:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2070b1b5-2931-7782-305f-c578b3b24567@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2020 10:06 AM, Bijan Mottahedeh wrote:
> 
>>> @@ -8415,6 +8421,12 @@ static int io_sqe_buffers_unregister(struct 
>>> io_ring_ctx *ctx)
>>>       if (!data)
>>>           return -ENXIO;
>>> +    if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
>>> +        io_detach_buf_data(ctx);
>>> +        ctx->nr_user_bufs = 0;
>>
>> nr_user_bufs is a part of invariant and should stay together with
>> stuff in io_detach_buf_data().
> 
> Moved to io_detach_buf_data.
> 
> 
>>> @@ -8724,9 +8740,17 @@ static int io_sqe_buffers_register(struct 
>>> io_ring_ctx *ctx, void __user *arg,
>>>       struct fixed_rsrc_ref_node *ref_node;
>>>       struct fixed_rsrc_data *buf_data;
>>> +    if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
>>> +        if (!ctx->buf_data)
>>> +            return -EFAULT;
>>> +        ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;
>>
>> Why? Once a table is initialised it shouldn't change its size, would
>> be racy otherwise.
> 
> ctx->buf_data is set at ring setup time but the sharing process 
> (SETUP_SHARE) may do the actual buffer registration at an arbitrary time 
> later, so the attaching process must ensure to get the updated value of 
> nr_user_bufs if available.
> 
>>>       buf_data = io_buffers_map_alloc(ctx, nr_args);
>>>       if (IS_ERR(buf_data))
>>>           return PTR_ERR(buf_data);
>>> +    ctx->buf_data = buf_data;
>>
>> Wanted to write that there is missing
>> `if (ctx->user_bufs) return -EBUSY`
>>
>> but apparently it was moved into io_buffers_map_alloc().
>> I'd really prefer to have it here.
> 
> Moved it back.
> 
>>> +static int io_attach_buf_data(struct io_ring_ctx *ctx,
>>> +                  struct io_uring_params *p)
>>> +{
>>> +    struct io_ring_ctx *ctx_attach;
>>> +    struct fd f;
>>> +
>>> +    f = fdget(p->wq_fd);
>>> +    if (!f.file)
>>> +        return -EBADF;
>>> +    if (f.file->f_op != &io_uring_fops) {
>>> +        fdput(f);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    ctx_attach = f.file->private_data;
>>> +    if (!ctx_attach->buf_data) {
>>
>> It looks racy. What prevents it from being deleted while we're
>> working on it, e.g. by io_sqe_buffers_unregister?
> 
> I think the premise here is that buffer sharing happens between trusted 
> and coordinated processes.  If I understand your concern correctly, then 
> if the sharing process unregisters its buffers after having shared them, 
> than that process is acting improperly.  The race could lead to a failed 
> attach but that would be expected and reasonable I would think?  What do 
> you think should happen in this case?
> 
>>
>>> +        fdput(f);
>>> +        return -EINVAL;
>>> +    }
>>> +    ctx->buf_data = ctx_attach->buf_data;
>>
>> Before updates, etc. (e.g. __io_sqe_buffers_update()) were synchronised
>> by uring_lock, now it's modified concurrently, that looks to be really
>> racy.
> 
> Racy from the attaching process perspective you mean?
> 
>>
>>> +
>>> +    percpu_ref_get(&ctx->buf_data->refs);
>>
>> Ok, now the original io_uring instance will wait until the attached
>> once get rid of their references. That's a versatile ground to have
>> in kernel deadlocks.
>>
>> task1: uring1 = create()
>> task2: uring2 = create()
>> task1: uring3 = create(share=uring2);
>> task2: uring4 = create(share=uring1);
>>
>> task1: io_sqe_buffers_unregister(uring1)
>> task2: io_sqe_buffers_unregister(uring2)
>>
>> If I skimmed through the code right, that should hang unkillably.
> 
> So we need a way to enforce that a process can only have one role, 
> sharing or attaching? But I'm not what the best way to do that.  Is this 
> an issue for other resource sharing, work queues or polling thread?
> 

The intended use case for buffer registration is:

- a group of processes attach a shmem segment
- one process registers the buffers in the shmem segment and shares it
- other processes attach that registration

For this case, it seems that there is really no need to wait for the 
attached processes to get rid of the their references since the shmem 
segment (and thus the registered buffers) will persist anyway until the 
last attached process goes away.  So the last unregister could quiesce 
all references and get rid of the shared buf_data.

I'm not sure how useful the non-shmem use case would be anyway.

Would it makes sense to restrict the scope of this feature?


