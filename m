Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC74D4389
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 10:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiCJJ2x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 04:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiCJJ2w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 04:28:52 -0500
X-Greylist: delayed 721 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 01:27:51 PST
Received: from mail.j284.net (mail.j284.net [151.236.222.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6296B32ECC
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 01:27:50 -0800 (PST)
Received: by mail.j284.net  with ESMTPSA id 22A9FjAH449685; Thu, 10 Mar 2022 09:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=movency.com; s=mail;
        t=1646903746; bh=h9/j23gj+/NJ46U9iAPJ21oYHlG2puGZjw//kmGAcyI=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=TdobgQA3y2K27L3mHfZHS1lyneLY7Utv2TG+9T1dtlqaF8neZolIHGmEV8n9pEkvx
         ruBDJ79kt5UftFKr3PUJ4rqvjURDOOmVDXViRjOOKEy2RQL8Puazvxz2YKQ++6M3w8
         R30HcK6OgXCr0NvgP91P6KhL/ylnQotameEu+j7nmYXgWdBEgPmGeW4ULQjXqRDs5X
         GBzdXxAYkfx967h7p972lnhDLXdSVEWoCeXb/lWejtZHVuNWDViGI+696FSGusN8tc
         2yZZUU09TsBxD0zNlaAez78J+mrBfiFcB5wz4l4wDEczD4mJoS7Fpd2r34QViTMoFA
         y2U41vUqNXQDg==
Message-ID: <aeead0ae-9a38-7920-69fd-9da37aa40d31@movency.com>
Date:   Thu, 10 Mar 2022 09:15:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Artyom Pavlov <newpavlov@gmail.com>,
        io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <f4db0d4c-0ea3-3efa-7e28-bc727b7bc05a@kernel.dk>
 <1f58dbfa-9b1f-5627-89aa-2dda3e2844ab@kernel.dk>
From:   Chris Panayis <chris@movency.com>
In-Reply-To: <1f58dbfa-9b1f-5627-89aa-2dda3e2844ab@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_SBL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ooo.. I like this simple interface, even if there ends up being a more 
'infra-ring-esque' api... We currently implement thread/ring 
callbacks/wakeups using eventfd - this IORING_OP_WAKEUP_RING interface 
would be much better..

Thanks

Chris


On 10/03/2022 02:33, Jens Axboe wrote:
> On 3/9/22 6:55 PM, Jens Axboe wrote:
>> On 3/9/22 6:36 PM, Jens Axboe wrote:
>>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>>>> Greetings!
>>>>
>>>> A common approach for multi-threaded servers is to have a number of
>>>> threads equal to a number of cores and launch a separate ring in each
>>>> one. AFAIK currently if we want to send an event to a different ring,
>>>> we have to write-lock this ring, create SQE, and update the index
>>>> ring. Alternatively, we could use some kind of user-space message
>>>> passing.
>>>>
>>>> Such approaches are somewhat inefficient and I think it can be solved
>>>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>>>> ring to which CQE must be sent by kernel. It can be done by
>>>> introducing an IOSQE_ flag and using one of currently unused padding
>>>> u64s.
>>>>
>>>> Such feature could be useful for load balancing and message passing
>>>> between threads which would ride on top of io-uring, i.e. you could
>>>> send NOP with user_data pointing to a message payload.
>>> So what you want is a NOP with 'fd' set to the fd of another ring, and
>>> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
>>> flags for that, we just need a NOP that supports that. I see a few ways
>>> of going about that:
>>>
>>> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>>>     io_uring instance. It can then grab the completion lock on that ring
>>>     and post an empty CQE.
>>>
>>> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>>>     'fd' is another ring. Posting CQE same as above.
>>>
>>> 3) We add a specific opcode for this. Basically the same as #2, but
>>>     maybe with a more descriptive name than NOP.
>>>
>>> Might make sense to pair that with a CQE flag or something like that, as
>>> there's no specific user_data that could be used as it doesn't match an
>>> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
>>> Would be applicable to all the above cases.
>>>
>>> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
>>> that sqe->fd point to a ring (could even be the ring itself, doesn't
>>> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
>> Something like the below, totally untested. The request will complete on
>> the original ring with either 0, for success, or -EOVERFLOW if the
>> target ring was already in an overflow state. If the fd specified isn't
>> an io_uring context, then the request will complete with -EBADFD.
>>
>> If you have any way of testing this, please do. I'll write a basic
>> functionality test for it as well, but not until tomorrow.
>>
>> Maybe we want to include in cqe->res who the waker was? We can stuff the
>> pid/tid in there, for example.
> Made the pid change, and also wrote a test case for it. Only change
> otherwise is adding a completion trace event as well. Patch below
> against for-5.18/io_uring, and attached the test case for liburing.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2e04f718319d..b21f85a48224 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1105,6 +1105,9 @@ static const struct io_op_def io_op_defs[] = {
>   	[IORING_OP_MKDIRAT] = {},
>   	[IORING_OP_SYMLINKAT] = {},
>   	[IORING_OP_LINKAT] = {},
> +	[IORING_OP_WAKEUP_RING] = {
> +		.needs_file		= 1,
> +	},
>   };
>   
>   /* requests with any of those set should undergo io_disarm_next() */
> @@ -4235,6 +4238,44 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
>   	return 0;
>   }
>   
> +static int io_wakeup_ring_prep(struct io_kiocb *req,
> +			       const struct io_uring_sqe *sqe)
> +{
> +	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index || sqe->off ||
> +		     sqe->len || sqe->rw_flags || sqe->splice_fd_in ||
> +		     sqe->buf_index || sqe->personality))
> +		return -EINVAL;
> +
> +	if (req->file->f_op != &io_uring_fops)
> +		return -EBADFD;
> +
> +	return 0;
> +}
> +
> +static int io_wakeup_ring(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_ring_ctx *ctx;
> +	int ret = 0;
> +
> +	ctx = req->file->private_data;
> +	spin_lock(&ctx->completion_lock);
> +	cqe = io_get_cqe(ctx);
> +	if (cqe) {
> +		WRITE_ONCE(cqe->user_data, 0);
> +		WRITE_ONCE(cqe->res, 0);
> +		WRITE_ONCE(cqe->flags, IORING_CQE_F_WAKEUP);
> +	} else {
> +		ret = -EOVERFLOW;
> +	}
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +
> +	__io_req_complete(req, issue_flags, ret, 0);
> +	return 0;
> +}
> +
>   static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -6568,6 +6609,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		return io_symlinkat_prep(req, sqe);
>   	case IORING_OP_LINKAT:
>   		return io_linkat_prep(req, sqe);
> +	case IORING_OP_WAKEUP_RING:
> +		return io_wakeup_ring_prep(req, sqe);
>   	}
>   
>   	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6851,6 +6894,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>   	case IORING_OP_LINKAT:
>   		ret = io_linkat(req, issue_flags);
>   		break;
> +	case IORING_OP_WAKEUP_RING:
> +		ret = io_wakeup_ring(req, issue_flags);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 787f491f0d2a..088232133594 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -143,6 +143,7 @@ enum {
>   	IORING_OP_MKDIRAT,
>   	IORING_OP_SYMLINKAT,
>   	IORING_OP_LINKAT,
> +	IORING_OP_WAKEUP_RING,
>   
>   	/* this goes last, obviously */
>   	IORING_OP_LAST,
> @@ -199,9 +200,11 @@ struct io_uring_cqe {
>    *
>    * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
>    * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
> + * IORING_CQE_F_WAKEUP	Wakeup request CQE, no link to an SQE
>    */
>   #define IORING_CQE_F_BUFFER		(1U << 0)
>   #define IORING_CQE_F_MORE		(1U << 1)
> +#define IORING_CQE_F_WAKEUP		(1U << 2)
>   
>   enum {
>   	IORING_CQE_BUFFER_SHIFT		= 16,
>
