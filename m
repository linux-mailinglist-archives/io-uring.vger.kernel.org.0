Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6C76191C
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 15:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjGYNAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjGYNAV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 09:00:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB764BC;
        Tue, 25 Jul 2023 06:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=53xlXtpDSjlczCoW5U6CiigD+NmPoPvWUZDjgYgo0rI=; b=IZCPIjLQeaj5KC/MZ1qOs+S0M9
        RVQFO1YxvUSfa79pCfcRTEUwU6+rG2DSxFnx86qhtr6hyGLJK2ZsHvXULwShKv0DmSb+wRYCQmYlK
        WPR1Mh61XXOxBZZW6hhLyBJjsHpr6Ji5oUErN6eTp8xdlkqLJmmZBoam9opohG4o9jb5eCK7HTmdK
        YhjKU7HfyH4sckY7cTo7WPEzIQRpP/WPTp/aiAUK92og6nU9xQ5ORNkEnK5YwoWO1PaFHwEix4Qhr
        2tlD+JKOvQPpkRq/U2oWOKJdtRiSxtPNdMj+cxL9aUxpTcBOh9O+XcfeUoxaeWIXFOSIBblWmqFeO
        rvs8kfLg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qOHeC-00497C-1v;
        Tue, 25 Jul 2023 13:00:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0DA3D30036B;
        Tue, 25 Jul 2023 15:00:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C41DA27D9B9A1; Tue, 25 Jul 2023 15:00:15 +0200 (CEST)
Date:   Tue, 25 Jul 2023 15:00:15 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Message-ID: <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
 <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
 <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
 <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 09:29:14AM -0600, Jens Axboe wrote:

> FWIW, here's the io_uring incremental after that rebase. Update the
> liburing futex branch as well, updating the prep helpers to take 64 bit
> values for mask/val and also add the flags argument that was missing as
> well. Only other addition was adding those 4 new patches instead of the
> old 3 ones, and adding single patch that just moves FUTEX2_MASK to
> futex.h.
> 
> All checks out fine, tests pass and it works.
> 
> 
> diff --git a/io_uring/futex.c b/io_uring/futex.c
> index 93df54dffaa0..4c9f2c841b98 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -18,11 +18,11 @@ struct io_futex {
>  		u32 __user			*uaddr;
>  		struct futex_waitv __user	*uwaitv;
>  	};
> +	unsigned long	futex_val;
> +	unsigned long	futex_mask;
>  	unsigned long	futexv_owned;
> +	u32		futex_flags;
> +	unsigned int	futex_nr;
>  };
>  
>  struct io_futex_data {
> @@ -171,15 +171,28 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
>  int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +	u32 flags;
>  
> +	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index))
>  		return -EINVAL;
>  
>  	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	iof->futex_val = READ_ONCE(sqe->addr2);
> +	iof->futex_mask = READ_ONCE(sqe->addr3);
> +	iof->futex_nr = READ_ONCE(sqe->len);
> +	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
> +		return -EINVAL;
> +

Hmm, would something like:

	if (req->opcode == IORING_OP_FUTEX_WAITV) {
		if (iof->futex_val && iof->futex_mask)
			return -EINVAL;

		/* sys_futex_waitv() doesn't take @flags as of yet */
		if (iof->futex_flags)
			return -EINVAL;

		if (!iof->futex_nr)
			return -EINVAL;

	} else {
		/* sys_futex_{wake,wait}() don't take @nr */
		if (iof->futex_nr)
			return -EINVAL;

		/* both take @flags and @mask */
		flags = READ_ONCE(sqe->futex_flags);
		if (flags & ~FUTEX2_MASK)
			return -EINVAL;

		iof->futex_flags = futex2_to_flags(flags);
		if (!futex_flags_valid(iof->futex_flags))
			return -EINVAL;

		if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
			return -EINVAL;

		/* sys_futex_wait() takes @val */
		if (req->iocode == IORING_OP_FUTEX_WAIT) {
			if (!futex_validate_input(iof->futex_flags, iof->futex_val))
				return -EINVAL;
		} else {
			if (iof->futex_val)
				return -EINVAL;
		}
	}

work? The waitv thing is significantly different from the other two.

