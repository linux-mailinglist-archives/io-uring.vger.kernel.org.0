Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE92D37EE
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 01:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgLIApJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 19:45:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLIApI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 19:45:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B90KlJX151684;
        Wed, 9 Dec 2020 00:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CtmwuI/hLExbUSYhHzzedLFSP/ZE/i7+6iFitsaBQlU=;
 b=mKyEspJSy337Z4zXdNvcIMkq0XfhDHUBUg6jyiQs7387ZDZECiTOvvPk08xIBtZBgp+X
 GVY54jj7DDCPOWhIoOMtPemmZr6xiWACZJy41QffrkeSPgaJ1ObgIs6Y5jO9O96NMoEY
 snA2C0wdU4f74MXrafemEzh/6ygwJjGGjAzP6GfAlQL1LalXzULTizSXkAN9A15Vy5g8
 +7coYyCATMp/s7X5UYVK5pGzgO3GV8siTxtT1maRu0d/S2Of2aCGfhiZvIM1A3Yyzw+b
 A6aUOjfqz1duAxQTKxpCltiRdo+h6bBPJLd2HYeWXP5U7Xsvae5yBitMbfPHdKMM6M7B mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825m5r4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 00:44:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B90Knpm047974;
        Wed, 9 Dec 2020 00:42:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358kspb901-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 00:42:21 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B90gL5x011344;
        Wed, 9 Dec 2020 00:42:21 GMT
Received: from [10.154.174.46] (/10.154.174.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 16:42:21 -0800
Subject: Re: [PATCH 6/8] io_uring: support buffer registration updates
To:     axboe@kernel.dk, Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-7-git-send-email-bijan.mottahedeh@oracle.com>
 <7d9e5065-0cad-2ef1-be6b-0067116c67bf@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <593730fa-6a11-c86c-216b-0a7e8b511f9b@oracle.com>
Date:   Tue, 8 Dec 2020 16:42:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <7d9e5065-0cad-2ef1-be6b-0067116c67bf@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/2020 12:17 PM, Pavel Begunkov wrote:
> On 12/11/2020 23:00, Bijan Mottahedeh wrote:
>> Introduce IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE,
>> consistent with file registration update.
> 
> I'd prefer to not add a new opcode for each new resource. Can we have
> only IORING_OP_RESOURCE_UPDATE and multiplex inside? Even better if you
> could fit all into IORING_OP_FILES_UPDATE and then
> 
> #define IORING_OP_RESOURCE_UPDATE IORING_OP_FILES_UPDATE
> 
> Jens, what do you think?

Hi Jens,

What do you think the right approach is here?

Thanks.

--bijan

> 
>>
>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>> ---
>>   fs/io_uring.c                 | 139 +++++++++++++++++++++++++++++++++++++++++-
>>   include/uapi/linux/io_uring.h |   8 +--
>>   2 files changed, 140 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 71f6d5c..6020fd2 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1006,6 +1006,9 @@ struct io_op_def {
>>   		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
>>   						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
>>   	},
>> +	[IORING_OP_BUFFERS_UPDATE] = {
>> +		.work_flags		= IO_WQ_WORK_MM,
>> +	},
>>   };
>>   
>>   enum io_mem_account {
>> @@ -1025,6 +1028,9 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
>>   static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>   				 struct io_uring_rsrc_update *ip,
>>   				 unsigned nr_args);
>> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>> +				   struct io_uring_rsrc_update *up,
>> +				   unsigned nr_args);
>>   static void __io_clean_op(struct io_kiocb *req);
>>   static struct file *io_file_get(struct io_submit_state *state,
>>   				struct io_kiocb *req, int fd, bool fixed);
>> @@ -5939,6 +5945,19 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
>>   	percpu_ref_exit(&ref_node->refs);
>>   	kfree(ref_node);
>>   }
>> +
>> +static int io_buffers_update_prep(struct io_kiocb *req,
>> +				  const struct io_uring_sqe *sqe)
>> +{
>> +	return io_rsrc_update_prep(req, sqe);
>> +}
>> +
>> +static int io_buffers_update(struct io_kiocb *req, bool force_nonblock,
>> +			     struct io_comp_state *cs)
>> +{
>> +	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_buffers_update);
>> +}
>> +
>>   static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>   	switch (req->opcode) {
>> @@ -6010,11 +6029,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   		return io_renameat_prep(req, sqe);
>>   	case IORING_OP_UNLINKAT:
>>   		return io_unlinkat_prep(req, sqe);
>> +	case IORING_OP_BUFFERS_UPDATE:
>> +		return io_buffers_update_prep(req, sqe);
>>   	}
>>   
>>   	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
>>   			req->opcode);
>> -	return-EINVAL;
>> +	return -EINVAL;
>>   }
>>   
>>   static int io_req_defer_prep(struct io_kiocb *req,
>> @@ -6268,6 +6289,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
>>   	case IORING_OP_UNLINKAT:
>>   		ret = io_unlinkat(req, force_nonblock);
>>   		break;
>> +	case IORING_OP_BUFFERS_UPDATE:
>> +		ret = io_buffers_update(req, force_nonblock, cs);
>> +		break;
>>   	default:
>>   		ret = -EINVAL;
>>   		break;
>> @@ -8224,6 +8248,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
>>   	if (imu->acct_pages)
>>   		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
>>   	kvfree(imu->bvec);
>> +	imu->bvec = NULL;
>>   	imu->nr_bvecs = 0;
>>   }
>>   
>> @@ -8441,6 +8466,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>>   		if (pret > 0)
>>   			unpin_user_pages(pages, pret);
>>   		kvfree(imu->bvec);
>> +		imu->bvec = NULL;
>>   		goto done;
>>   	}
>>   
>> @@ -8602,6 +8628,8 @@ static void io_buf_data_ref_zero(struct percpu_ref *ref)
>>   static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
>>   {
>>   	io_buffer_unmap(ctx, prsrc->buf);
>> +	kvfree(prsrc->buf);
>> +	prsrc->buf = NULL;
>>   }
>>   
>>   static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
>> @@ -8684,6 +8712,111 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>>   	return 0;
>>   }
>>   
>> +static inline int io_queue_buffer_removal(struct fixed_rsrc_data *data,
>> +					  struct io_mapped_ubuf *imu)
>> +{
>> +	return io_queue_rsrc_removal(data, (void *)imu);
>> +}
>> +
>> +static void destroy_fixed_buf_ref_node(struct fixed_rsrc_ref_node *ref_node)
>> +{
>> +	destroy_fixed_rsrc_ref_node(ref_node);
>> +}
>> +
>> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>> +				   struct io_uring_rsrc_update *up,
>> +				   unsigned nr_args)
>> +{
>> +	struct fixed_rsrc_data *data = ctx->buf_data;
>> +	struct fixed_rsrc_ref_node *ref_node;
>> +	struct io_mapped_ubuf *imu;
>> +	struct iovec iov;
>> +	struct iovec __user *iovs;
>> +	struct page *last_hpage = NULL;
>> +	__u32 done;
>> +	int i, err;
>> +	bool needs_switch = false;
>> +
>> +	if (check_add_overflow(up->offset, nr_args, &done))
>> +		return -EOVERFLOW;
>> +	if (done > ctx->nr_user_bufs)
>> +		return -EINVAL;
>> +
>> +	ref_node = alloc_fixed_buf_ref_node(ctx);
>> +	if (IS_ERR(ref_node))
>> +		return PTR_ERR(ref_node);
>> +
>> +	done = 0;
>> +	iovs = u64_to_user_ptr(up->iovs);
>> +	while (nr_args) {
>> +		struct fixed_rsrc_table *table;
>> +		unsigned index;
>> +
>> +		err = 0;
>> +		if (copy_from_user(&iov, &iovs[done], sizeof(iov))) {
>> +			err = -EFAULT;
>> +			break;
>> +		}
>> +		i = array_index_nospec(up->offset, ctx->nr_user_bufs);
>> +		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
>> +		index = i & IORING_BUF_TABLE_MASK;
>> +		imu = &table->bufs[index];
>> +		if (table->bufs[index].ubuf) {
>> +			struct io_mapped_ubuf *dup;
>> +			dup = kmemdup(imu, sizeof(*imu), GFP_KERNEL);
>> +			if (!dup) {
>> +				err = -ENOMEM;
>> +				break;
>> +			}
>> +			err = io_queue_buffer_removal(data, dup);
>> +			if (err)
>> +				break;
>> +			memset(imu, 0, sizeof(*imu));
>> +			needs_switch = true;
>> +		}
>> +		if (!io_buffer_validate(&iov)) {
>> +			err = io_sqe_buffer_register(ctx, &iov, imu,
>> +						     &last_hpage);
>> +			if (err) {
>> +				memset(imu, 0, sizeof(*imu));
>> +				break;
>> +			}
>> +		}
>> +		nr_args--;
>> +		done++;
>> +		up->offset++;
>> +	}
>> +
>> +	if (needs_switch) {
>> +		percpu_ref_kill(&data->node->refs);
>> +		spin_lock(&data->lock);
>> +		list_add(&ref_node->node, &data->ref_list);
>> +		data->node = ref_node;
>> +		spin_unlock(&data->lock);
>> +		percpu_ref_get(&ctx->buf_data->refs);
>> +	} else
>> +		destroy_fixed_buf_ref_node(ref_node);
>> +
>> +	return done ? done : err;
>> +}
>> +
>> +static int io_sqe_buffers_update(struct io_ring_ctx *ctx, void __user *arg,
>> +				 unsigned nr_args)
>> +{
>> +	struct io_uring_rsrc_update up;
>> +
>> +	if (!ctx->buf_data)
>> +		return -ENXIO;
>> +	if (!nr_args)
>> +		return -EINVAL;
>> +	if (copy_from_user(&up, arg, sizeof(up)))
>> +		return -EFAULT;
>> +	if (up.resv)
>> +		return -EINVAL;
>> +
>> +	return __io_sqe_buffers_update(ctx, &up, nr_args);
>> +}
>> +
>>   static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>>   {
>>   	__s32 __user *fds = arg;
>> @@ -9961,6 +10094,7 @@ static bool io_register_op_must_quiesce(int op)
>>   	switch (op) {
>>   	case IORING_UNREGISTER_FILES:
>>   	case IORING_REGISTER_FILES_UPDATE:
>> +	case IORING_REGISTER_BUFFERS_UPDATE:
>>   	case IORING_REGISTER_PROBE:
>>   	case IORING_REGISTER_PERSONALITY:
>>   	case IORING_UNREGISTER_PERSONALITY:
>> @@ -10036,6 +10170,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>   			break;
>>   		ret = io_sqe_buffers_unregister(ctx);
>>   		break;
>> +	case IORING_REGISTER_BUFFERS_UPDATE:
>> +		ret = io_sqe_buffers_update(ctx, arg, nr_args);
>> +		break;
>>   	case IORING_REGISTER_FILES:
>>   		ret = io_sqe_files_register(ctx, arg, nr_args);
>>   		break;
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 87f0f56..17682b5 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -137,6 +137,7 @@ enum {
>>   	IORING_OP_SHUTDOWN,
>>   	IORING_OP_RENAMEAT,
>>   	IORING_OP_UNLINKAT,
>> +	IORING_OP_BUFFERS_UPDATE,
>>   
>>   	/* this goes last, obviously */
>>   	IORING_OP_LAST,
>> @@ -279,17 +280,12 @@ enum {
>>   	IORING_UNREGISTER_PERSONALITY		= 10,
>>   	IORING_REGISTER_RESTRICTIONS		= 11,
>>   	IORING_REGISTER_ENABLE_RINGS		= 12,
>> +	IORING_REGISTER_BUFFERS_UPDATE		= 13,
>>   
>>   	/* this goes last */
>>   	IORING_REGISTER_LAST
>>   };
>>   
>> -struct io_uring_files_update {
>> -	__u32 offset;
>> -	__u32 resv;
>> -	__aligned_u64 /* __s32 * */ fds;
>> -};
>> -
>>   struct io_uring_rsrc_update {
>>   	__u32 offset;
>>   	__u32 resv;
>>
> 

