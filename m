Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4804F0FE2
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 09:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiDDHS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 03:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiDDHS4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 03:18:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB8E33EA8
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 00:17:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B569868AFE; Mon,  4 Apr 2022 09:16:56 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:16:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 3/5] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <20220404071656.GC444@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com> <20220401110310.611869-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401110310.611869-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cann we plese spell out instastructure here?  Or did you mean
infraread anyway :)

> -enum io_uring_cmd_flags {
> -	IO_URING_F_COMPLETE_DEFER	= 1,
> -	IO_URING_F_UNLOCKED		= 2,
> -	/* int's last bit, sign checks are usually faster than a bit test */
> -	IO_URING_F_NONBLOCK		= INT_MIN,
> -};

This doesn't actually get used anywhere outside of io_uring.c, so why
move it?

> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> +{
> +	req->uring_cmd.driver_cb(&req->uring_cmd);
> +}
> +
> +void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> +			void (*driver_cb)(struct io_uring_cmd *))
> +{
> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> +
> +	req->uring_cmd.driver_cb = driver_cb;
> +	req->io_task_work.func = io_uring_cmd_work;
> +	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);

I'm still not a fund of the double indirect call here.  I don't really
have a good idea yet, but I plan to look into it.

>  static void io_req_task_queue_fail(struct io_kiocb *req, int ret)

Also it would be great to not add it between io_req_task_queue_fail and
the callback set by it.

> +void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
> +{
> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> +
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_complete(req, ret);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_done);

It seems like all callers of io_req_complete actually call req_set_fail
on failure.  So maybe it would be nice pre-cleanup to handle the
req_set_fail call from ĩo_req_complete?

> +	/* queued async, consumer will call io_uring_cmd_done() when complete */
> +	if (ret == -EIOCBQUEUED)
> +		return 0;
> +	io_uring_cmd_done(ioucmd, ret);

Why not:
	if (ret != -EIOCBQUEUED)
		io_uring_cmd_done(ioucmd, ret);
	return 0;

That being said I wonder why not just remove the retun value from
->async_cmd entirely and just require the implementation to always call
io_uring_cmd_done?  That removes the confusion on who needs to call it
entirely, similarly to what we do in the block layer for ->submit_bio.

> +struct io_uring_cmd {
> +	struct file     *file;
> +	void            *cmd;
> +	/* for irq-completion - if driver requires doing stuff in task-context*/
> +	void (*driver_cb)(struct io_uring_cmd *cmd);
> +	u32             flags;
> +	u32             cmd_op;
> +	u16		cmd_len;

The cmd_len field does not seem to actually be used anywhere.

> +++ b/include/uapi/linux/io_uring.h
> @@ -22,10 +22,12 @@ struct io_uring_sqe {
>  	union {
>  		__u64	off;	/* offset into file */
>  		__u64	addr2;
> +		__u32	cmd_op;
>  	};
>  	union {
>  		__u64	addr;	/* pointer to buffer or iovecs */
>  		__u64	splice_off_in;
> +		__u16	cmd_len;
>  	};
>  	__u32	len;		/* buffer size or number of iovecs */
>  	union {
> @@ -60,7 +62,10 @@ struct io_uring_sqe {
>  		__s32	splice_fd_in;
>  		__u32	file_index;
>  	};
> -	__u64	__pad2[2];
> +	union {
> +		__u64	__pad2[2];
> +		__u64	cmd;
> +	};

Can someone explain these changes to me a little more?
