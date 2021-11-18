Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0840456259
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 19:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhKRSby (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 13:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhKRSby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 13:31:54 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B21DC061574;
        Thu, 18 Nov 2021 10:28:54 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id r130so6897218pfc.1;
        Thu, 18 Nov 2021 10:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K6sm93BWhmXPRdE+v8TSlW6tKH/ocsuUR/duzHuz5ms=;
        b=V713p+o2WSGjEgK25fVDoFnZBIOrFR+G/MAY2WDHIXXRKpOTyPxxmpxu4wqal6tMec
         46x49ZqVNlS713IP2YkARABVdx5lc1FPFw97t9YmUGtZKitQePBXlXqvakLR2W0nC8Mf
         OGFgxKqp0Uk253LA0IZwYWKCzoLi1cV9A31olSE635NGZC8W5LgiW/QZYFAk6sko+nNn
         KLoLSSOtdeu1dnvQFBNZb4C+EPDE3kudXCOELzvhq/KPW+xAF32ddHZp+VSuJ0OMhMLs
         DPKwNFWWE9Y5L5oIRySrN5qdCunIFdX9dZD3k4dJTXXQNOzr2ub3WAsDSmiqzPObhndh
         tSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K6sm93BWhmXPRdE+v8TSlW6tKH/ocsuUR/duzHuz5ms=;
        b=3E0IYA+nhVmQwrqwpwg6LczadMBLa7nPs3buaErhQB+T5XGbP2asl/BSFqaS9+xC2D
         Z7CB3LGDuphI8rPKQJnfYAALH/fIXsDtOLemt7DuieeVcRt+lxzpS/GvAh5zFZBGIhzq
         eBzit1e/tZIGNgVEDbN0GLfH7Q1ZhSOBNuB4Z+wpNAX+SqgP51B3+FCpa56VGcPaWubl
         UQRmn5XKmm44TV+Hq2Ie+hMUUpYoIQeD1ByUeupPEePEKQWdDncgyZg8ckdycA5Oypxc
         jc0qhnnn5F+ON5QqLt9dXYGZ51FfcSmvzoXaxnl62hrFOzeuCszwW+XVPCblaVcF2THp
         KayA==
X-Gm-Message-State: AOAM533bllsL9r6eY4ytGJKNGmLTpLrZRgL1cXtkRZ7JSm1RCVuulrbl
        jcDUpQwOoEzvC8W/znhC4BM=
X-Google-Smtp-Source: ABdhPJyqE7NdXqUKpQn88MRmASkg1XX6DwglOuz9y/N+WFLBkTj2qeDfSLevDNYLzs/sY+Rq1bevTg==
X-Received: by 2002:a62:6184:0:b0:4a2:a063:fe8e with SMTP id v126-20020a626184000000b004a2a063fe8emr15771910pfb.69.1637260129010;
        Thu, 18 Nov 2021 10:28:49 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id q13sm336096pfk.22.2021.11.18.10.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:28:48 -0800 (PST)
Date:   Thu, 18 Nov 2021 23:58:45 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211118182845.b4b7qaj7ip3lmkcj@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <8d95bd01-7f1a-9350-cede-c6abd56a7927@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d95bd01-7f1a-9350-cede-c6abd56a7927@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 18, 2021 at 10:51:59PM IST, Yonghong Song wrote:
>
>
> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> > This change adds eBPF iterator for buffers registered in io_uring ctx.
> > It gives access to the ctx, the index of the registered buffer, and a
> > pointer to the io_uring_ubuf itself. This allows the iterator to save
> > info related to buffers added to an io_uring instance, that isn't easy
> > to export using the fdinfo interface (like exact struct page composing
> > the registered buffer).
> >
> > The primary usecase this is enabling is checkpoint/restore support.
> >
> > Note that we need to use mutex_trylock when the file is read from, in
> > seq_start functions, as the order of lock taken is opposite of what it
> > would be when io_uring operation reads the same file.  We take
> > seq_file->lock, then ctx->uring_lock, while io_uring would first take
> > ctx->uring_lock and then seq_file->lock for the same ctx.
> >
> > This can lead to a deadlock scenario described below:
> >
> >        CPU 0				CPU 1
> >
> >        vfs_read
> >        mutex_lock(&seq_file->lock)	io_read
> > 					mutex_lock(&ctx->uring_lock)
> >        mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
> > 					mutex_lock(&seq_file->lock)
>
> It is not clear which mutex_lock switched to mutex_trylock.

The one in vfs_read.

> From below example, it looks like &ctx->uring_lock. But if this is
> the case, we could have deadlock, right?
>

Sorry, I will make the commit message clearer in the next version.

The sequence on CPU 0 is for normal read(2) on iterator.
For CPU 1, it is an io_uring instance trying to do same on iterator attached to
itself.

So CPU 0 does

sys_read
vfs_read
 bpf_seq_read
 mutex_lock(&seq_file->lock)    # A
  io_uring_buf_seq_start
  mutex_lock(&ctx->uring_lock)  # B

and CPU 1 does

io_uring_enter
mutex_lock(&ctx->uring_lock)    # B
 io_read
  bpf_seq_read
  mutex_lock(&seq_file->lock)   # A
  ...

Since the order of locks is opposite, it can deadlock. So I switched the
mutex_lock in io_uring_buf_seq_start to trylock, so it can return an error for
this case, then it will release seq_file->lock and CPU 1 will make progress.

The second problem without use of trylock is described below (for same case of
io_uring reading from iterator attached to itself).

Let me know if I missed something.

> >
> > The trylock also protects the case where io_uring tries to read from
> > iterator attached to itself (same ctx), where the order of locks would
> > be:
> >   io_uring_enter
> >    mutex_lock(&ctx->uring_lock) <-----------.
> >    io_read				    \
> >     seq_read				     \
> >      mutex_lock(&seq_file->lock)		     /
> >      mutex_lock(&ctx->uring_lock) # deadlock-`
> >
> > In both these cases (recursive read and contended uring_lock), -EDEADLK
> > is returned to userspace.
> >
> > In the future, this iterator will be extended to directly support
> > iteration of bvec Flexible Array Member, so that when there is no
> > corresponding VMA that maps to the registered buffer (e.g. if VMA is
> > destroyed after pinning pages), we are able to reconstruct the
> > registration on restore by dumping the page contents and then replaying
> > them into a temporary mapping used for registration later. All this is
> > out of scope for the current series however, but builds upon this
> > iterator.
> >
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: io-uring@vger.kernel.org
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   fs/io_uring.c                  | 179 +++++++++++++++++++++++++++++++++
> >   include/linux/bpf.h            |   2 +
> >   include/uapi/linux/bpf.h       |   3 +
> >   tools/include/uapi/linux/bpf.h |   3 +
> >   4 files changed, 187 insertions(+)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index b07196b4511c..46a110989155 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -81,6 +81,7 @@
> >   #include <linux/tracehook.h>
> >   #include <linux/audit.h>
> >   #include <linux/security.h>
> > +#include <linux/btf_ids.h>
> >   #define CREATE_TRACE_POINTS
> >   #include <trace/events/io_uring.h>
> > @@ -11125,3 +11126,181 @@ static int __init io_uring_init(void)
> >   	return 0;
> >   };
> >   __initcall(io_uring_init);
> > +
> > +#ifdef CONFIG_BPF_SYSCALL
> > +
> > +BTF_ID_LIST(btf_io_uring_ids)
> > +BTF_ID(struct, io_ring_ctx)
> > +BTF_ID(struct, io_mapped_ubuf)
> > +
> > +struct bpf_io_uring_seq_info {
> > +	struct io_ring_ctx *ctx;
> > +	unsigned long index;
> > +};
> > +
> > +static int bpf_io_uring_init_seq(void *priv_data, struct bpf_iter_aux_info *aux)
> > +{
> > +	struct bpf_io_uring_seq_info *info = priv_data;
> > +	struct io_ring_ctx *ctx = aux->ctx;
> > +
> > +	info->ctx = ctx;
> > +	return 0;
> > +}
> > +
> > +static int bpf_io_uring_iter_attach(struct bpf_prog *prog,
> > +				    union bpf_iter_link_info *linfo,
> > +				    struct bpf_iter_aux_info *aux)
> > +{
> > +	struct io_ring_ctx *ctx;
> > +	struct fd f;
> > +	int ret;
> > +
> > +	f = fdget(linfo->io_uring.io_uring_fd);
> > +	if (unlikely(!f.file))
> > +		return -EBADF;
> > +
> > +	ret = -EOPNOTSUPP;
> > +	if (unlikely(f.file->f_op != &io_uring_fops))
> > +		goto out_fput;
> > +
> > +	ret = -ENXIO;
> > +	ctx = f.file->private_data;
> > +	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
> > +		goto out_fput;
> > +
> > +	ret = 0;
> > +	aux->ctx = ctx;
> > +
> > +out_fput:
> > +	fdput(f);
> > +	return ret;
> > +}
> > +
> > +static void bpf_io_uring_iter_detach(struct bpf_iter_aux_info *aux)
> > +{
> > +	percpu_ref_put(&aux->ctx->refs);
> > +}
> > +
> > +/* io_uring iterator for registered buffers */
> > +
> > +struct bpf_iter__io_uring_buf {
> > +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +	__bpf_md_ptr(struct io_ring_ctx *, ctx);
> > +	__bpf_md_ptr(struct io_mapped_ubuf *, ubuf);
> > +	unsigned long index;
> > +};
>
> I would suggest to change "unsigned long index" to either u32 or u64.
> This structure is also the bpf program context and in bpf program context,
> "index" will be u64. Then on 32bit system, we potentially
> could have issues.
>

Ack, will do.

> > +
> > +static void *__bpf_io_uring_buf_seq_get_next(struct bpf_io_uring_seq_info *info)
> > +{
> > +	if (info->index < info->ctx->nr_user_bufs)
> > +		return info->ctx->user_bufs[info->index++];
> > +	return NULL;
> > +}
> > +
> > +static void *bpf_io_uring_buf_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +	struct bpf_io_uring_seq_info *info = seq->private;
> > +	struct io_mapped_ubuf *ubuf;
> > +
> > +	/* Indicate to userspace that the uring lock is contended */
> > +	if (!mutex_trylock(&info->ctx->uring_lock))
> > +		return ERR_PTR(-EDEADLK);
> > +
> > +	ubuf = __bpf_io_uring_buf_seq_get_next(info);
> > +	if (!ubuf)
> > +		return NULL;
> > +
> > +	if (*pos == 0)
> > +		++*pos;
> > +	return ubuf;
> > +}
> > +
> > +static void *bpf_io_uring_buf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +	struct bpf_io_uring_seq_info *info = seq->private;
> > +
> > +	++*pos;
> > +	return __bpf_io_uring_buf_seq_get_next(info);
> > +}
> > +
> > +DEFINE_BPF_ITER_FUNC(io_uring_buf, struct bpf_iter_meta *meta,
> > +		     struct io_ring_ctx *ctx, struct io_mapped_ubuf *ubuf,
> > +		     unsigned long index)
>
> Again, change "unsigned long" to "u32" or "u64".
>

Ack.

> > [...]
> > +static struct bpf_iter_reg io_uring_buf_reg_info = {
> > +	.target            = "io_uring_buf",
> > +	.feature	   = BPF_ITER_RESCHED,
> > +	.attach_target     = bpf_io_uring_iter_attach,
> > +	.detach_target     = bpf_io_uring_iter_detach,
>
> Since you have this extra `io_uring_fd` for the iterator, you may want
> to implement show_fdinfo and fill_link_info callback functions here.
>

Ack, but some questions:

What should it have? e.g. it easy to go from map_id to map fd if one wants
access to the map attached to the iterator, but not sure how one can obtain more
information about target fd from io_uring or epoll iterators.

Should I delegate to their show_fdinfo and dump using that?

The type/target is already available in link_info, not sure what other useful
information can be added there, which allows obtaining the io_uring/epoll fd.

> > +	.ctx_arg_info_size = 2,
> > +	.ctx_arg_info = {
> > +		{ offsetof(struct bpf_iter__io_uring_buf, ctx),
> > +		  PTR_TO_BTF_ID },
> > +		{ offsetof(struct bpf_iter__io_uring_buf, ubuf),
> > +		  PTR_TO_BTF_ID_OR_NULL },
> > +	},
> > +	.seq_info	   = &bpf_io_uring_buf_seq_info,
> > +};
> > +
> > +static int __init io_uring_iter_init(void)
> > +{
> > +	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
> > +	io_uring_buf_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[1];
> > +	return bpf_iter_reg_target(&io_uring_buf_reg_info);
> > +}
> > +late_initcall(io_uring_iter_init);
> > +
> > +#endif
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 56098c866704..ddb9d4520a3f 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1509,8 +1509,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> >   	extern int bpf_iter_ ## target(args);			\
> >   	int __init bpf_iter_ ## target(args) { return 0; }
> > +struct io_ring_ctx;
> >   struct bpf_iter_aux_info {
> >   	struct bpf_map *map;
> > +	struct io_ring_ctx *ctx;
> >   };
>
> Can we use union here? Note that below bpf_iter_link_info in
> uapi/linux/bpf.h, map_fd and io_uring_fd is also an union.
>

So the reason I didn't use a union was the link->aux.map check in
bpf_iter.c::__get_seq_info. Even if we switch to union bpf_iter_aux_info, it
needs some way to determine whether link is for map type, so maybe a string
comparison there? Leaving it out of union felt cleaner, also I move both
io_ring_ctx and eventpoll file into a union in later patch.

> >   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 6297eafdc40f..3323defa99a1 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -91,6 +91,9 @@ union bpf_iter_link_info {
> >   	struct {
> >   		__u32	map_fd;
> >   	} map;
> > +	struct {
> > +		__u32   io_uring_fd;
> > +	} io_uring;
> >   };
> >   /* BPF syscall commands, see bpf(2) man-page for more details. */
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 6297eafdc40f..3323defa99a1 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -91,6 +91,9 @@ union bpf_iter_link_info {
> >   	struct {
> >   		__u32	map_fd;
> >   	} map;
> > +	struct {
> > +		__u32   io_uring_fd;
> > +	} io_uring;
> >   };
> >   /* BPF syscall commands, see bpf(2) man-page for more details. */
> >

--
Kartikeya
