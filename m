Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AACF550419
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 13:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiFRLDG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 07:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiFRLDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 07:03:02 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF805E08C
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 04:03:00 -0700 (PDT)
Message-ID: <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655550178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WC26t7YWdMPz8pDnpnq2EX2lrreRJcin/VQpdjjp0vY=;
        b=ikkIDlDMM3jVnk4yT0fA59tVqFvRbRzib2fqyjNjdfE+TaaL2qaYAHR6IXijstS/ppisY+
        +OoLXiOVeSGbSWRDghlketsKBjv4uotbwR46if1cgJXWtzDRxc/45sWPJxWTLXYnT7CG7Q
        UdQVifEL4j/AUImR0KqxUGfRloYOm3c=
Date:   Sat, 18 Jun 2022 19:02:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] io_uring: add support for passing fixed file
 descriptors
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
 <20220617134504.368706-3-axboe@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20220617134504.368706-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 21:45, Jens Axboe wrote:
> With IORING_OP_MSG_RING, one ring can send a message to another ring.
> Extend that support to also allow sending a fixed file descriptor to
> that ring, enabling one ring to pass a registered descriptor to another
> one.
> 
> Arguments are extended to pass in:
> 
> sqe->addr3	fixed file slot in source ring
> sqe->file_index	fixed file slot in destination ring
> 
> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
> to the above arguments.
> 
> Undecided:
> 	- Should we post a cqe with the send, or require that the sender
> 	  just link a separate IORING_OP_MSG_RING? This makes error
> 	  handling easier, as we cannot easily retract the installed
> 	  file descriptor if the target CQ ring is full. Right now we do
> 	  fill a CQE. If the request completes with -EOVERFLOW, then the
> 	  sender must re-send a CQE if the target must get notified.

Hi Jens,
Since we are have open/accept direct feature, this may be useful. But I
just can't think of a real case that people use two rings and need to do
operations to same fd.
Assume there are real cases, then filling a cqe is necessary since users
need to first make sure the desired fd is registered before doing
something to it.

A downside is users have to take care to do fd delivery especially
when slot resource is in short supply in target_ctx.

                 ctx                            target_ctx
     msg1(fd1 to target slot x)

     msg2(fd2 to target slot x)

                                              get cqe of msg1
                                   do something to fd1 by access slot x


the msg2 is issued not at the right time. In short not only ctx needs to
fill a cqe to target_ctx to inform that the file has been registered
but also the target_ctx has to tell ctx that "my slot x is free now
for you to deliver fd". So I guess users are inclined to allocate a
big fixed table and deliver fds to target_ctx in different slots,
Which is ok but anyway a limitation.

> 
> 	- Add an IORING_MSG_MOVE_FD which moves the descriptor, removing
> 	  it from the source ring when installed in the target? Again
> 	  error handling is difficult.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/uapi/linux/io_uring.h |   8 +++
>   io_uring/msg_ring.c           | 122 ++++++++++++++++++++++++++++++++--
>   2 files changed, 123 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 8715f0942ec2..dbdaeef3ea89 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -264,6 +264,14 @@ enum io_uring_op {
>    */
>   #define IORING_ACCEPT_MULTISHOT	(1U << 0)
>   
> +/*
> + * IORING_OP_MSG_RING command types, stored in sqe->addr
> + */
> +enum {
> +	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
> +	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
> +};
> +
>   /*
>    * IO completion data structure (Completion Queue Entry)
>    */
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index b02be2349652..e9d6fb25d141 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -3,46 +3,154 @@
>   #include <linux/errno.h>
>   #include <linux/file.h>
>   #include <linux/slab.h>
> +#include <linux/nospec.h>
>   #include <linux/io_uring.h>
>   
>   #include <uapi/linux/io_uring.h>
>   
>   #include "io_uring.h"
> +#include "rsrc.h"
> +#include "filetable.h"
>   #include "msg_ring.h"
>   
>   struct io_msg {
>   	struct file			*file;
>   	u64 user_data;
>   	u32 len;
> +	u32 cmd;
> +	u32 src_fd;
> +	u32 dst_fd;
>   };
>   
> +static int io_msg_ring_data(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *target_ctx = req->file->private_data;
> +	struct io_msg *msg = io_kiocb_to_cmd(req);
> +
> +	if (msg->src_fd || msg->dst_fd)
> +		return -EINVAL;
> +
> +	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> +		return 0;
> +
> +	return -EOVERFLOW;
> +}
> +
> +static void io_double_unlock_ctx(struct io_ring_ctx *ctx,
> +				 struct io_ring_ctx *octx,
> +				 unsigned int issue_flags)
> +{
> +	if (issue_flags & IO_URING_F_UNLOCKED)
> +		mutex_unlock(&ctx->uring_lock);
> +	mutex_unlock(&octx->uring_lock);
> +}
> +
> +static int io_double_lock_ctx(struct io_ring_ctx *ctx,
> +			      struct io_ring_ctx *octx,
> +			      unsigned int issue_flags)
> +{
> +	/*
> +	 * To ensure proper ordering between the two ctxs, we can only
> +	 * attempt a trylock on the target. If that fails and we already have
> +	 * the source ctx lock, punt to io-wq.
> +	 */
> +	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
> +		if (!mutex_trylock(&octx->uring_lock))
> +			return -EAGAIN;
> +		return 0;
> +	}
> +
> +	/* Always grab smallest value ctx first. */
> +	if (ctx < octx) {
> +		mutex_lock(&ctx->uring_lock);
> +		mutex_lock(&octx->uring_lock);
> +	} else if (ctx > octx) {


Would a simple else work?
if (a < b) {
   lock(a); lock(b);
} else {
   lock(b);lock(a);
}

since a doesn't equal b



