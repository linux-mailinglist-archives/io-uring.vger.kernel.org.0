Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924A12F57A9
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 04:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbhANCER (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 21:04:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbhANCEO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 21:04:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10E1xoet073829;
        Thu, 14 Jan 2021 02:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=gG646mZm/fi2fgzQkJTOVrQptIo0kuteOpZY6ZUVtk0=;
 b=KtTb0nDRgeaCEZ6TSwWnOcEPQoFPdPxO9CymFSejIcjf3XWzHZJ85mGCuecGqtB39NHt
 pkhk64nVVebr0qgVPd9pWHM6oqhsMzCCtDG1MUiboUpYNhg8HAiGY5TItXXqSAu3YS1t
 BCZ1i4qEgxC/P0JcJyWoVG8ZC41MBqwBtZ/Pyfhdi7Fm1fuagWGRBDDTmqlHXQE7aI0z
 ZQJZLTfxzMwX4MXVnyXjkEwrTYYMPkE+mfIMaRN6sPegZYhTIMmS98qZZkAHtBQaPW/R
 vCYqfIB3n0ppTfuxl/WwxOY/asCpqb6WWlAAO/98Ig63kheIJZa1o+d82P/x/K4A94ZY vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 360kvk6ar8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 02:03:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10E1sp1T042626;
        Thu, 14 Jan 2021 02:01:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 360keme5e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 02:01:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10E21Pqp020833;
        Thu, 14 Jan 2021 02:01:25 GMT
Received: from [10.154.142.175] (/10.154.142.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Jan 2021 18:01:25 -0800
Subject: Re: [PATCH v5 13/13] io_uring: support buffer registration sharing
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1610487193-21374-14-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <f902d7fa-bce6-7cc6-6e99-4acd76aa45f7@oracle.com>
Date:   Wed, 13 Jan 2021 18:01:25 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1610487193-21374-14-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210113-0, 01/12/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140006
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/2021 1:33 PM, Bijan Mottahedeh wrote:
> Implement buffer sharing among multiple rings.
> 
> A ring shares its (future) buffer registrations at setup time with
> IORING_SETUP_SHARE_BUF. A ring attaches to another ring's buffer
> registration at setup time with IORING_SETUP_ATTACH_BUF, after
> authenticating with the buffer registration owner's fd. Any updates to
> the owner's buffer registrations become immediately available to the
> attached rings.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> 
> Conflicts:
> 	fs/io_uring.c
> ---
>   fs/io_uring.c                 | 85 +++++++++++++++++++++++++++++++++++++++++--
>   include/uapi/linux/io_uring.h |  2 +
>   2 files changed, 83 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 37639b9..856a570b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8439,6 +8439,13 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
>   	ctx->nr_user_bufs = 0;
>   }
>   
> +static void io_detach_buf_data(struct io_ring_ctx *ctx)
> +{
> +	percpu_ref_put(&ctx->buf_data->refs);
> +	ctx->buf_data = NULL;
> +	ctx->nr_user_bufs = 0;
> +}
> +
>   static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>   {
>   	struct fixed_rsrc_data *data = ctx->buf_data;
> @@ -8447,6 +8454,11 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>   	if (!data)
>   		return -ENXIO;
>   
> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
> +		io_detach_buf_data(ctx);
> +		return 0;
> +	}
> +
>   	ret = io_rsrc_ref_quiesce(data, ctx, alloc_fixed_buf_ref_node);
>   	if (ret)
>   		return ret;
> @@ -8690,9 +8702,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
>   	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
>   		return ERR_PTR(-EINVAL);
>   
> -	buf_data = alloc_fixed_rsrc_data(ctx);
> -	if (IS_ERR(buf_data))
> -		return buf_data;
> +	if (ctx->buf_data) {
> +		buf_data = ctx->buf_data;
> +	} else {
> +		buf_data = alloc_fixed_rsrc_data(ctx);
> +		if (IS_ERR(buf_data))
> +			return buf_data;
> +	}
>   
>   	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
>   	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
> @@ -8757,9 +8773,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>   	if (ctx->nr_user_bufs)
>   		return -EBUSY;
>   
> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
> +		if (!ctx->buf_data)
> +			return -EFAULT;
> +		ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;
> +		return 0;
> +	}
> +
>   	buf_data = io_buffers_map_alloc(ctx, nr_args);
>   	if (IS_ERR(buf_data))
>   		return PTR_ERR(buf_data);
> +	ctx->buf_data = buf_data;
>   
>   	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
>   		struct io_mapped_ubuf *imu;
> @@ -8783,7 +8807,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>   			break;
>   	}
>   
> -	ctx->buf_data = buf_data;
>   	if (ret) {
>   		io_sqe_buffers_unregister(ctx);
>   		return ret;
> @@ -9831,6 +9854,55 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
>   	return file;
>   }
>   
> +static int io_attach_buf_data(struct io_ring_ctx *ctx,
> +			      struct io_uring_params *p)
> +{
> +	struct io_ring_ctx *ctx_attach;
> +	struct fd f;
> +
> +	f = fdget(p->wq_fd);
> +	if (!f.file)
> +		return -EBADF;
> +	if (f.file->f_op != &io_uring_fops) {
> +		fdput(f);
> +		return -EINVAL;
> +	}
> +
> +	ctx_attach = f.file->private_data;
> +	if (!ctx_attach->buf_data) {
> +		fdput(f);
> +		return -EINVAL;
> +	}
> +	ctx->buf_data = ctx_attach->buf_data;
> +
> +	percpu_ref_get(&ctx->buf_data->refs);
> +	fdput(f);
> +	return 0;
> +}
> +
> +static int io_init_buf_data(struct io_ring_ctx *ctx, struct io_uring_params *p)
> +{
> +	if ((p->flags & (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF)) ==
> +	    (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF))
> +		return -EINVAL;
> +
> +	if (p->flags & IORING_SETUP_SHARE_BUF) {
> +		struct fixed_rsrc_data *buf_data;
> +
> +		buf_data = alloc_fixed_rsrc_data(ctx);
> +		if (IS_ERR(buf_data))
> +			return PTR_ERR(buf_data);
> +
> +		ctx->buf_data = buf_data;
> +		return 0;
> +	}
> +
> +	if (p->flags & IORING_SETUP_ATTACH_BUF)
> +		return io_attach_buf_data(ctx, p);
> +
> +	return 0;
> +}
> +
>   static int io_uring_create(unsigned entries, struct io_uring_params *p,
>   			   struct io_uring_params __user *params)
>   {
> @@ -9948,6 +10020,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>   	if (ret)
>   		goto err;
>   
> +	ret = io_init_buf_data(ctx, p);
> +	if (ret)
> +		goto err;
> +
>   	ret = io_sq_offload_create(ctx, p);
>   	if (ret)
>   		goto err;
> @@ -10028,6 +10104,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>   	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
>   			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
>   			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
> +			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
>   			IORING_SETUP_R_DISABLED))
>   		return -EINVAL;
>   
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b289ef8..3ad786a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,8 @@ enum {
>   #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>   #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>   #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
> +#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
> +#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
>   
>   enum {
>   	IORING_OP_NOP,
> 

I recreated the deadlock scenario you had raised:

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

with the following test:

+static int test_deadlock(void)
+{
+       int i, pid, ret;
+       struct io_uring rings[4];
+       struct io_uring_params p = {};
+
+       p.flags = IORING_SETUP_SHARE_BUF;
+
+       for (i = 0; i < 2; i++) {
+               ret = io_uring_queue_init_params(1, &rings[i], &p);
+               if (ret) {
+                       verror("queue_init share");
+                       return ret;
+               }
+       }
+
+       p.flags = IORING_SETUP_ATTACH_BUF;
+
+       pid = fork();
+       if (pid) {
+               p.wq_fd = rings[1].ring_fd;
+               ret = io_uring_queue_init_params(1, &rings[3], &p);
+       } else {
+               p.wq_fd = rings[0].ring_fd;
+               ret = io_uring_queue_init_params(1, &rings[4], &p);
+       }
+
+       if (ret) {
+               verror("queue_init attach");
+               return ret;
+       }
+
+
+       vinfo(V1, "unregister\n");
+
+       if (pid) {
+               close(rings[1].ring_fd);
+               ret = io_uring_unregister_buffers(&rings[0]);
+       } else {
+               close(rings[0].ring_fd);
+               ret = io_uring_unregister_buffers(&rings[1]);
+       }
+
+       vinfo(V1, "unregister done\n");
+
+       if (ret)
+               verror("unregister");
+
+       return ret;
+}


The two processe in the test hang but can be interrupted.

I checked that

ret = wait_for_completion_interruptible(&data->done);

in io_rsrc_ref_quiesce() returns -ERESTARTSYS (-512) after hitting ^C 
and that

ret = io_run_task_work_sig();

returns -EINTR (-4)

Finally in

io_ring_ctx_free()
-> io_sqe_buffers_unregister()
    -> io_rsrc_ref_quiesce()

ret = wait_for_completion_interruptible(&data->done);

returns 0.

So it looks like the unkillable hang is not there.

However, when I take out the io_uring_unregister_buffers() calls from 
the test, one of the processes gets a segfault with the following trace 
and I'm not sure what the cause is.

buffer-share[2791]: segfault at 7f2ca196b040 ip ]
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

#0  io_uring_release (inode=0xffff88810665a5a8, file=0xffff88811b5eb540)
     at fs/io_uring.c:9116
#1  0xffffffff812eb208 in __fput (file=0xffff88811b5eb540)
     at fs/file_table.c:280
#2  0xffffffff810aa857 in task_work_run () at kernel/task_work.c:140
#3  0xffffffff8108b37d in exit_task_work (task=0xffff8881321b8040)
     at ./include/linux/task_work.h:30
#4  do_exit (code=code@entry=139) at kernel/exit.c:825
#5  0xffffffff8108bbe7 in do_group_exit (exit_code=139) at kernel/exit.c:922
#6  0xffffffff81099697 in get_signal (ksig=ksig@entry=0xffffc900023d3ea8)
     at kernel/signal.c:2770
#7  0xffffffff81031819 in arch_do_signal_or_restart 
(regs=0xffffc900023d3f58,
     has_signal=<optimized out>) at ./arch/x86/include/asm/current.h:15
#8  0xffffffff8111dd72 in handle_signal_work (ti_work=<optimized out>,
     regs=0xffffc900023d3f58) at kernel/entry/common.c:147
#9  exit_to_user_mode_loop (ti_work=<optimized out>, regs=<optimized out>)
     at kernel/entry/common.c:171
#10 exit_to_user_mode_prepare (regs=0xffffc900023d3f58)
     at kernel/entry/common.c:201
#11 0xffffffff819c5645 in irqentry_exit_to_user_mode (regs=<optimized out>)
     at kernel/entry/common.c:315
#12 0xffffffff81a00ade in asm_exc_page_fault ()
     at ./arch/x86/include/asm/idtentry.h:580
#13 0x0000000000000000 in ?? ()




