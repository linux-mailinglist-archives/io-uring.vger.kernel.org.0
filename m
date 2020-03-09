Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC4317E599
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 18:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCIRVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 13:21:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58193 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgCIRVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 13:21:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E0FD3221AD;
        Mon,  9 Mar 2020 13:21:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 09 Mar 2020 13:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=aMxmGOHO1elFHlCaAiIMRgJIrRK
        Gl3xxYF1pkGvLB1s=; b=Q+i4pVcw9Pyq9n8iEx2et4dVGTdXAsRMr1BJ1z3nrjM
        kDF6HHVg8/SfftKE1796q0vuPFq8xus6NyDZPnynwTrpUfQlQseKduSJ/+8lpE9Z
        iNImE+pRGKNd45ts5sr58ILQw5Czw6kiMow6R2rkJRzM1a9uelCjqOeklBH5zrSb
        qlIldJeAeFcrYObYkUnmQY2bbCvkqBwUG5OaJKEHc7W2vgSArE5v2gP10itX+9vt
        2OFm+7KLIuPbOSG36UJtLrZ1zkVJCgOh/9tEdsG1tAo9ZOS8hMD7j6NAtncoxLGs
        taUN10setD30klpv9cPdCLblWmqbOk6Imqj4jGhjGYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aMxmGO
        HO1elFHlCaAiIMRgJIrRKGl3xxYF1pkGvLB1s=; b=20laBR2sWlTwKutqtelkmj
        Xt2UUz+IZNdRZCEWaTT/SJrfqFtFicuABBCaiz1GCELB7U28yk7PGC4D+u72O2QV
        RAXKG/Gyzk71X7LoOiJ/WCG15JlMO7/tk35CBj3+iRFZKJUQdHwIAarjBz/cIx/g
        JXPXfBYgiQ5YWfR4ULqveaf8pOCQVnszc34HT7fJktEdh6X9/KzZrJwO6aIK3CDC
        F+cDe1Q1PdBw/b14GLIvgv/fK+H4qmahBvNoF20pUXqW0JBaEDgs71oOO8hhXLTe
        XtJz0n5x5jP0mPBqY2+E0eJyffZSuZ6848x3IGLf8Foc+XiH3SOIiWdzwOx1qMdQ
        ==
X-ME-Sender: <xms:_3pmXvlRDxkEgvU6WIueqeao5afVffPNk0CEpZ8EGZU4Tf3ScGKMig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppe
    eijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:_3pmXtou8L0Y4ZAz7GWnaUW8MaIkjMlCTuCeGRLLdRiHzoaHYkOusA>
    <xmx:_3pmXj6be7iLCrEKuun5J8MDcfXMltnFN69FkpzIrfkyhq6chHDggg>
    <xmx:_3pmXnKFKoUst3J-hevdOYNE9oUE_ALYdvUHkqDgMnOQPtXSHYEn_g>
    <xmx:_3pmXqDg63r8jG3WU0-JR5JFCdptOISMjL1_QJ2Kp5O5GX8lkK5bQA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D0D230611FB;
        Mon,  9 Mar 2020 13:21:03 -0400 (EDT)
Date:   Mon, 9 Mar 2020 10:21:01 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 3/6] io_uring: support buffer selection
Message-ID: <20200309172101.lgswlmmt763jtuno@alap3.anarazel.de>
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228203053.25023-4-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-28 13:30:50 -0700, Jens Axboe wrote:
> If a server process has tons of pending socket connections, generally
> it uses epoll to wait for activity. When the socket is ready for reading
> (or writing), the task can select a buffer and issue a recv/send on the
> given fd.
> 
> Now that we have fast (non-async thread) support, a task can have tons
> of pending reads or writes pending. But that means they need buffers to
> back that data, and if the number of connections is high enough, having
> them preallocated for all possible connections is unfeasible.
> 
> With IORING_OP_PROVIDE_BUFFERS, an application can register buffers to
> use for any request. The request then sets IOSQE_BUFFER_SELECT in the
> sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
> a free buffer from the specified group is selected. If none are
> available, the request is terminated with -ENOBUFS. If successful, the
> CQE on completion will contain the buffer ID chosen in the cqe->flags
> member, encoded as:
> 
> 	(buffer_id << IORING_CQE_BUFFER_SHIFT) | IORING_CQE_F_BUFFER;
> 
> Once a buffer has been consumed by a request, it is no longer available
> and must be registered again with IORING_OP_PROVIDE_BUFFERS.
> 
> Requests need to support this feature. For now, IORING_OP_READ and
> IORING_OP_RECV support it. This is checked on SQE submission, a CQE with
> res == -EINVAL will be posted if attempted on unsupported requests.

Why not EOPNOTSUPP or such? Makes it more feasible for applications to
handle the case separately.


> +static int io_rw_common_cflags(struct io_kiocb *req)
> +{
> +	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
> +	int cflags;
> +
> +	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
> +	cflags |= IORING_CQE_F_BUFFER;
> +	req->rw.addr = 0;
> +	kfree(kbuf);
> +	return cflags;
> +}

>  		if (refcount_dec_and_test(&req->refs) &&
> @@ -1819,13 +1860,16 @@ static inline void req_set_fail_links(struct io_kiocb *req)
>  static void io_complete_rw_common(struct kiocb *kiocb, long res)
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
> +	int cflags = 0;
>  
>  	if (kiocb->ki_flags & IOCB_WRITE)
>  		kiocb_end_write(req);
>  
>  	if (res != req->result)
>  		req_set_fail_links(req);
> -	io_cqring_add_event(req, res);
> +	if (req->flags & REQ_F_BUFFER_SELECTED)
> +		cflags = io_rw_common_cflags(req);
> +	__io_cqring_add_event(req, res, cflags);
>  }

Besides the naming already commented upon by Pavel, I'm also wondering
if it's the right thing to call this unconditionally from
io_complete_*rw*_common() - hard to see how this feature would ever be
used in the write path...


> +static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
> +					  struct io_buffer *kbuf,
> +					  bool needs_lock)
> +{
> +	struct list_head *list;
> +
> +	if (req->flags & REQ_F_BUFFER_SELECTED)
> +		return kbuf;
> +
> +	/*
> +	 * "Normal" inline submissions always hold the uring_lock, since we
> +	 * grab it from the system call. Same is true for the SQPOLL offload.
> +	 * The only exception is when we've detached the request and issue it
> +	 * from an async worker thread, grab the lock for that case.
> +	 */
> +	if (needs_lock)
> +		mutex_lock(&req->ctx->uring_lock);
> +
> +	lockdep_assert_held(&req->ctx->uring_lock);

This comment is in a few places, perhaps there's a way to unify by
placing the conditional acquisition into a helper?


> +	list = idr_find(&req->ctx->io_buffer_idr, gid);
> +	if (list && !list_empty(list)) {
> +		kbuf = list_first_entry(list, struct io_buffer, list);
> +		list_del(&kbuf->list);
> +	} else {
> +		kbuf = ERR_PTR(-ENOBUFS);
> +	}
> +
> +	if (needs_lock)
> +		mutex_unlock(&req->ctx->uring_lock);
> +
> +	return kbuf;
> +}
> +
>  static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
> -			       struct iovec **iovec, struct iov_iter *iter)
> +			       struct iovec **iovec, struct iov_iter *iter,
> +			       bool needs_lock)
>  {
>  	void __user *buf = u64_to_user_ptr(req->rw.addr);
>  	size_t sqe_len = req->rw.len;
> @@ -2140,12 +2219,30 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  		return io_import_fixed(req, rw, iter);
>  	}
>  
> -	/* buffer index only valid with fixed read/write */
> -	if (req->rw.kiocb.private)
> +	/* buffer index only valid with fixed read/write, or buffer select  */
> +	if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
>  		return -EINVAL;
>  
>  	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
>  		ssize_t ret;
> +
> +		if (req->flags & REQ_F_BUFFER_SELECT) {
> +			struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
> +			int gid;
> +
> +			gid = (int) (unsigned long) req->rw.kiocb.private;
> +			kbuf = io_buffer_select(req, gid, kbuf, needs_lock);
> +			if (IS_ERR(kbuf)) {
> +				*iovec = NULL;
> +				return PTR_ERR(kbuf);
> +			}
> +			req->rw.addr = (u64) kbuf;
> +			if (sqe_len > kbuf->len)
> +				sqe_len = kbuf->len;
> +			req->flags |= REQ_F_BUFFER_SELECTED;
> +			buf = u64_to_user_ptr(kbuf->addr);
> +		}

Feels a bit dangerous to have addr sometimes pointing to the user
specified data, and sometimes to kernel data. Even if indicated by
REQ_F_BUFFER_SELECTED.


> +static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
> +					       int *cflags, bool needs_lock)
> +{
> +	struct io_sr_msg *sr = &req->sr_msg;
> +	struct io_buffer *kbuf;
> +
> +	if (!(req->flags & REQ_F_BUFFER_SELECT))
> +		return NULL;
> +
> +	kbuf = io_buffer_select(req, sr->gid, sr->kbuf, needs_lock);
> +	if (IS_ERR(kbuf))
> +		return kbuf;
> +
> +	sr->kbuf = kbuf;
> +	if (sr->len > kbuf->len)
> +		sr->len = kbuf->len;
> +	req->flags |= REQ_F_BUFFER_SELECTED;
> +
> +	*cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
> +	*cflags |= IORING_CQE_F_BUFFER;
> +	return kbuf;
> +}

Could more of this be moved into io_buffer_select? Looks like every
REQ_F_BUFFER_SELECT supporting op is going to need most of it?


>  static int io_recvmsg_prep(struct io_kiocb *req,
>  			   const struct io_uring_sqe *sqe)
>  {

Looks like this would be unused if !defined(CONFIG_NET)?


Greetings,

Andres Freund
