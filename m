Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A26693207
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBKPnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 10:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKPnp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 10:43:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19754211F3
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 07:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676130177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8U4buABgszycRdED4BVp3vwkQcDbX/tjVIxmfJwq8SM=;
        b=U4wCQAk3cC5k6D9wRQ6gADXrQ/g10DATr5v9+yBK2XDIzCrXkmAgpqLWE8zrRfHe+5aqO7
        CyBLM8qw5e8x4tU0j9irmGKf+qwUHCv5H7Oz+VPTwY2Lh6JG8EfHN/yjW0DWIDoptiSTwU
        ju3shQ3TqiXXUYnQXyOasyhtTEcDt70=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-SfFr5-p8NTC0BsBpvpIOpQ-1; Sat, 11 Feb 2023 10:42:53 -0500
X-MC-Unique: SfFr5-p8NTC0BsBpvpIOpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93CD9101A521;
        Sat, 11 Feb 2023 15:42:52 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8FB1121315;
        Sat, 11 Feb 2023 15:42:44 +0000 (UTC)
Date:   Sat, 11 Feb 2023 23:42:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
Message-ID: <Y+e3b+Myg/30hlYk@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210153212.733006-2-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 11:32:09PM +0800, Ming Lei wrote:
> Per-task direct pipe can transfer page between two files or one
> file and other kernel components, especially by splice_direct_to_actor
> and __splice_from_pipe().
> 
> This way is helpful for fuse/ublk to implement zero copy by transferring
> pages from device to file or socket. However, when device's ->splice_read()
> produces pages, the kernel consumer may read from or write to these pages,
> and from device viewpoint, there could be unexpected read or write on
> pages.
> 
> Enhance the limit by the following approach:
> 
> 1) add kernel splice flags of SPLICE_F_KERN_FOR_[READ|WRITE] which is
>    passed to device's ->read_splice(), then device can check if this
>    READ or WRITE is expected on pages filled to pipe together with
>    information from ppos & len
> 
> 2) add kernel splice flag of SPLICE_F_KERN_NEED_CONFIRM which is passed
>    to device's ->read_splice() for asking device to confirm if it
>    really supports this kind of usage of feeding pages by ->read_splice().
>    If device does support, pipe->ack_page_consuming is set. This way
>    can avoid misuse.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  fs/splice.c               | 15 +++++++++++++++
>  include/linux/pipe_fs_i.h | 10 ++++++++++
>  include/linux/splice.h    | 22 ++++++++++++++++++++++
>  3 files changed, 47 insertions(+)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 87d9b19349de..c4770e1644cc 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -792,6 +792,14 @@ static long do_splice_to(struct file *in, loff_t *ppos,
>  	return in->f_op->splice_read(in, ppos, pipe, len, flags);
>  }
>  
> +static inline bool slice_read_acked(const struct pipe_inode_info *pipe,
> +			       int flags)
> +{
> +	if (flags & SPLICE_F_KERN_NEED_CONFIRM)
> +		return pipe->ack_page_consuming;
> +	return true;
> +}
> +
>  /**
>   * splice_direct_to_actor - splices data directly between two non-pipes
>   * @in:		file to splice from
> @@ -861,10 +869,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  		size_t read_len;
>  		loff_t pos = sd->pos, prev_pos = pos;
>  
> +		pipe->ack_page_consuming = false;
>  		ret = do_splice_to(in, &pos, pipe, len, flags);
>  		if (unlikely(ret <= 0))
>  			goto out_release;
>  
> +		if (!slice_read_acked(pipe, flags)) {
> +			bytes = 0;
> +			ret = -EACCES;
> +			goto out_release;
> +		}
> +
>  		read_len = ret;
>  		sd->total_len = read_len;
>  
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index 6cb65df3e3ba..09ee1a9380ec 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -72,6 +72,7 @@ struct pipe_inode_info {
>  	unsigned int r_counter;
>  	unsigned int w_counter;
>  	bool poll_usage;
> +	bool ack_page_consuming;	/* only for direct pipe */
>  	struct page *tmp_page;
>  	struct fasync_struct *fasync_readers;
>  	struct fasync_struct *fasync_writers;
> @@ -218,6 +219,15 @@ static inline void pipe_discard_from(struct pipe_inode_info *pipe,
>  		pipe_buf_release(pipe, &pipe->bufs[--pipe->head & mask]);
>  }
>  
> +/*
> + * Called in ->splice_read() for confirming the READ/WRITE page is allowed
> + */
> +static inline void pipe_ack_page_consume(struct pipe_inode_info *pipe)
> +{
> +	if (!WARN_ON_ONCE(current->splice_pipe != pipe))
> +		pipe->ack_page_consuming = true;
> +}
> +
>  /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
>     memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
>  #define PIPE_SIZE		PAGE_SIZE
> diff --git a/include/linux/splice.h b/include/linux/splice.h
> index a55179fd60fc..98c471fd918d 100644
> --- a/include/linux/splice.h
> +++ b/include/linux/splice.h
> @@ -23,6 +23,28 @@
>  
>  #define SPLICE_F_ALL (SPLICE_F_MOVE|SPLICE_F_NONBLOCK|SPLICE_F_MORE|SPLICE_F_GIFT)
>  
> +/*
> + * Flags used for kernel internal page move from ->splice_read()
> + * by internal direct pipe, and user pipe can't touch these
> + * flags.
> + *
> + * Pages filled from ->splice_read() are usually moved/copied to
> + * ->splice_write(). Here address fuse/ublk zero copy by transferring
> + * page from device to file/socket for either READ or WRITE. So we
> + * need ->splice_read() to confirm if this READ/WRITE is allowed on
> + * pages filled in ->splice_read().
> + */
> +/* The page consumer is for READ from pages moved from direct pipe */
> +#define SPLICE_F_KERN_FOR_READ	(0x100)
> +/* The page consumer is for WRITE to pages moved from direct pipe */
> +#define SPLICE_F_KERN_FOR_WRITE	(0x200)
> +/*
> + * ->splice_read() has to confirm if consumer's READ/WRITE on pages
> + * is allow. If yes, ->splice_read() has to set pipe->ack_page_consuming,
> + * otherwise pipe->ack_page_consuming has to be cleared.
> + */
> +#define SPLICE_F_KERN_NEED_CONFIRM	(0x400)
> +

As Linus commented in another thread, this patch is really ugly.

I'd suggest to change to the following one, any comment is welcome!


From fb9340ce72a1c58c9428d2af7cb00b55fa4ba799 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 10 Feb 2023 09:16:46 +0000
Subject: [PATCH 2/4] fs/splice: add private flags for cross-check in two ends

Pages are transferred via pipe/splice between different subsystems.

The source subsystem may know if spliced pages are readable or
writable. The sink subsystem may know if spliced pages need to
write to or read from.

Add two pair of private flags, so that the source subsystem and
sink subsystem can run cross-check about page use correctness,
and they are supposed to be used in case of communicating over
direct pipe only. Generic splice and pipe code is supposed to
not touch the two pair of private flags.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/pipe_fs_i.h | 8 ++++++++
 include/linux/splice.h    | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 6cb65df3e3ba..959c8b9287f4 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -14,6 +14,14 @@
 #define PIPE_BUF_FLAG_LOSS	0x40	/* Message loss happened after this buffer */
 #endif
 
+/*
+ * Used by source/sink end only, don't touch them in generic
+ * splice/pipe code. Set in source side, and check in sink
+ * side
+ */
+#define PIPE_BUF_PRIV_FLAG_MAY_READ	0x1000 /* sink can read from page */
+#define PIPE_BUF_PRIV_FLAG_MAY_WRITE	0x2000 /* sink can write to page */
+
 /**
  *	struct pipe_buffer - a linux kernel pipe buffer
  *	@page: the page containing the data for the pipe buffer
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..90d1d2b5327d 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -23,6 +23,15 @@
 
 #define SPLICE_F_ALL (SPLICE_F_MOVE|SPLICE_F_NONBLOCK|SPLICE_F_MORE|SPLICE_F_GIFT)
 
+/*
+ * Use for source/sink side only, don't touch them in generic splice/pipe
+ * code. Pass from sink side, and check in source side.
+ *
+ * So far, it is only for communicating over direct pipe.
+ */
+#define SPLICE_F_PRIV_FOR_READ	(0x100)	/* sink side will read from page */
+#define SPLICE_F_PRIV_FOR_WRITE	(0x200) /* sink side will write page */
+
 /*
  * Passed to the actors
  */
-- 
2.38.1



Thanks,
Ming

