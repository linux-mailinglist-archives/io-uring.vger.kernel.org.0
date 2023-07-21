Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4068375C5E0
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjGULai (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 07:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjGULah (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 07:30:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D232130;
        Fri, 21 Jul 2023 04:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oA1lxdsbmT9V9XvedsigbR9WiAzyb4kIzMarXuWjEc8=; b=FwmhjFFfOemzZVZmnCXr5qCVmg
        8jzApzjNE80tpxQmXVsbXhAEmiEScBaQiDRNAHeiuyJmDXAdf+URnxip8XoAz3rvRur67PKeykDGb
        A1wK8JMCHOnSPmMtXEZzJ0VKAKXqaSi9oEN6r5FBN9RnxWtU5DeR+suOlbLvhODYBIGFDjcLNML1p
        2bs8695ayW/rYwjvU7dv4bbxIjo+0zTIA1fwESx9jqF8c6aZWVEwePNz5U5tryYZqsW36Ob3g9SDQ
        y4zqJfSGkY2Es2dY8rvmmNE6GQ0xTOvRc7z73VBi1uDBgQnJnxCq3gB5jmF1jV9PswoQoOb9Odt6J
        MZTUCD7g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMoLA-0013wq-5k; Fri, 21 Jul 2023 11:30:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AB1F2300095;
        Fri, 21 Jul 2023 13:30:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 78B3426455813; Fri, 21 Jul 2023 13:30:31 +0200 (CEST)
Date:   Fri, 21 Jul 2023 13:30:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Message-ID: <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720221858.135240-7-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 04:18:54PM -0600, Jens Axboe wrote:


> +struct io_futex {
> +	struct file	*file;
> +	u32 __user	*uaddr;
> +	unsigned int	futex_val;
> +	unsigned int	futex_flags;
> +	unsigned int	futex_mask;
> +};

So in the futex patches I just posted I went with 'unsigned long'
(syscall) or 'u64' (data structures) for the futex, such that, on 64bit
platforms, we might support 64bit futexes in the future (I still need to
audit the whole futex internals and convert u32 to unsigned long in
order to enable that).

So would something like:

struct io_futex {
	struct file	*file;
	void __user	*uaddr;
	u64		futex_val;
	u64		futex_mask;
	u32		futex_flags;
};

work to match the futex2 syscalls?



> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +
> +	if (unlikely(sqe->fd || sqe->addr2 || sqe->buf_index || sqe->addr3))
> +		return -EINVAL;
> +
> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	iof->futex_val = READ_ONCE(sqe->len);
> +	iof->futex_mask = READ_ONCE(sqe->file_index);
> +	iof->futex_flags = READ_ONCE(sqe->futex_flags);

sqe->addr,		u64
sqe->len,		u32
sqe->file_index,	u32
sqe->futex_flags,	u32

> +	if (iof->futex_flags & FUTEX_CMD_MASK)

		FUTEX2_MASK

(which would need lifting from syscall.c to kernel/futex/futex.h I
suppose)

> +		return -EINVAL;
> +
> +	return 0;
> +}

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 36f9c73082de..3bd2d765f593 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -65,6 +65,7 @@ struct io_uring_sqe {
>  		__u32		xattr_flags;
>  		__u32		msg_ring_flags;
>  		__u32		uring_cmd_flags;
> +		__u32		futex_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */

Perhaps extend it like so?


diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 08720c7bd92f..c1d28bf64d11 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -35,6 +35,7 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u64	futex_val;
 		struct {
 			__u32	cmd_op;
 			__u32	__pad1;
@@ -65,6 +66,7 @@ struct io_uring_sqe {
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
+		__u32		futex_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -87,6 +89,7 @@ struct io_uring_sqe {
 	union {
 		struct {
 			__u64	addr3;
+			__u64	futex_mask;
 			__u64	__pad2[1];
 		};
 		/*


So that we can write something roughtly like:

	iof->uaddr = sqe->addr;
	iof->val   = sqe->futex_val;
	iof->mask  = sqe->futex_mask;
	iof->flags = sqe->futex_flags;

	if (iof->flags & ~FUTEX2_MASK)
		return -EINVAL;


