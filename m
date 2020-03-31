Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA1A199800
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 15:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbgCaN7x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 31 Mar 2020 09:59:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48259 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730442AbgCaN7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 09:59:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-214-KBxWLHdjNfW7-10389SxYw-1; Tue, 31 Mar 2020 14:59:47 +0100
X-MC-Unique: KBxWLHdjNfW7-10389SxYw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 31 Mar 2020 14:59:47 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 31 Mar 2020 14:59:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: FW: [RFC PATCH 08/12] fs/io_uring: Use iovec_import() not
 import_iovec().
Thread-Topic: [RFC PATCH 08/12] fs/io_uring: Use iovec_import() not
 import_iovec().
Thread-Index: AdYHYizbfIRJ197UQ5GBjlxsSM9cggAAmlwg
Date:   Tue, 31 Mar 2020 13:59:47 +0000
Message-ID: <081d0ffde944432194ed0caf9f1df77c@AcuMS.aculab.com>
References: <518953cd20d84fc5b6fc4ab459bf3459@AcuMS.aculab.com>
In-Reply-To: <518953cd20d84fc5b6fc4ab459bf3459@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixed cc address

> -----Original Message-----
> From: David Laight
> Sent: 31 March 2020 14:52
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: 'io_uring@vger.kernel.org' <io_uring@vger.kernel.org>; 'axboe@kernel.de' <axboe@kernel.de>
> Subject: [RFC PATCH 08/12] fs/io_uring: Use iovec_import() not import_iovec().
> 
> 
> This is a mechanical change to this horrid code.
> I think it is correct.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  fs/io_uring.c | 165 +++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 87 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d8dc2e2..27d66cf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -77,6 +77,10 @@
>  #include <linux/eventpoll.h>
>  #include <linux/fs_struct.h>
> 
> +/* Temporary for commit bisection */
> +#define sendmsg_copy_msghdr(a, b, c, d) sendmsg_copy_msghdr(a, b, c, (void *)d)
> +#define recvmsg_copy_msghdr(a, b, c, d, e) recvmsg_copy_msghdr(a, b, c, d, (void *)e)
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> 
> @@ -435,7 +439,7 @@ struct io_async_connect {
>  };
> 
>  struct io_async_msghdr {
> -	struct iovec			fast_iov[UIO_FASTIOV];
> +	struct iovec_cache		fast_iov;
>  	struct iovec			*iov;
>  	struct sockaddr __user		*uaddr;
>  	struct msghdr			msg;
> @@ -443,7 +447,7 @@ struct io_async_msghdr {
>  };
> 
>  struct io_async_rw {
> -	struct iovec			fast_iov[UIO_FASTIOV];
> +	struct iovec_cache		fast_iov;
>  	struct iovec			*iov;
>  	ssize_t				nr_segs;
>  	ssize_t				size;
> @@ -2052,47 +2056,39 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>  	return len;
>  }
> 
> -static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
> -			       struct iovec **iovec, struct iov_iter *iter)
> +static struct iovec *io_import_iovec(int rw, struct io_kiocb *req,
> +			       struct iovec_cache *cache, struct iov_iter *iter)
>  {
>  	void __user *buf = u64_to_user_ptr(req->rw.addr);
>  	size_t sqe_len = req->rw.len;
>  	u8 opcode;
> 
>  	opcode = req->opcode;
> -	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
> -		*iovec = NULL;
> -		return io_import_fixed(req, rw, iter);
> -	}
> +	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED)
> +		return ERR_PTR(io_import_fixed(req, rw, iter));
> 
>  	/* buffer index only valid with fixed read/write */
>  	if (req->rw.kiocb.private)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
> 
> -	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
> -		ssize_t ret;
> -		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
> -		*iovec = NULL;
> -		return ret < 0 ? ret : sqe_len;
> -	}
> +	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE)
> +		return ERR_PTR(import_single_range(rw, buf, sqe_len, cache->iov, iter));
> 
>  	if (req->io) {
>  		struct io_async_rw *iorw = &req->io->rw;
> 
> -		*iovec = iorw->iov;
> -		iov_iter_init(iter, rw, *iovec, iorw->nr_segs, iorw->size);
> -		if (iorw->iov == iorw->fast_iov)
> -			*iovec = NULL;
> -		return iorw->size;
> +		iov_iter_init(iter, rw, iorw->iov, iorw->nr_segs, iorw->size);
> +		if (iorw->iov != iorw->fast_iov.iov)
> +			return iorw->iov;
> +		return NULL;
>  	}
> 
>  #ifdef CONFIG_COMPAT
>  	if (req->ctx->compat)
> -		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
> -						iovec, iter);
> +		return compat_iovec_import(rw, buf, sqe_len, cache, iter);
>  #endif
> 
> -	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
> +	return iovec_import(rw, buf, sqe_len, cache, iter);
>  }
> 
>  /*
> @@ -2154,13 +2150,13 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
>  }
> 
>  static void io_req_map_rw(struct io_kiocb *req, struct iovec *iovec,
> -			  struct iovec *fast_iov, struct iov_iter *iter)
> +			  struct iovec_cache *fast_iov, struct iov_iter *iter)
>  {
>  	req->io->rw.nr_segs = iter->nr_segs;
>  	req->io->rw.size = iter->count;
>  	req->io->rw.iov = iovec;
>  	if (!req->io->rw.iov) {
> -		req->io->rw.iov = req->io->rw.fast_iov;
> +		req->io->rw.iov = req->io->rw.fast_iov.iov;
>  		memcpy(req->io->rw.iov, fast_iov,
>  			sizeof(struct iovec) * iter->nr_segs);
>  	} else {
> @@ -2177,7 +2173,7 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
>  }
> 
>  static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
> -			     struct iovec *fast_iov, struct iov_iter *iter)
> +			     struct iovec_cache *fast_iov, struct iov_iter *iter)
>  {
>  	if (!io_op_defs[req->opcode].async_ctx)
>  		return 0;
> @@ -2195,6 +2191,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  {
>  	struct io_async_ctx *io;
>  	struct iov_iter iter;
> +	struct iovec *iov;
>  	ssize_t ret;
> 
>  	ret = io_prep_rw(req, sqe, force_nonblock);
> @@ -2209,29 +2206,30 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		return 0;
> 
>  	io = req->io;
> -	io->rw.iov = io->rw.fast_iov;
>  	req->io = NULL;
> -	ret = io_import_iovec(READ, req, &io->rw.iov, &iter);
> +	iov = io_import_iovec(READ, req, &io->rw.fast_iov, &iter);
>  	req->io = io;
> -	if (ret < 0)
> -		return ret;
> +	if (IS_ERR(iov))
> +		return PTR_ERR(iov);
> +	io->rw.iov = iov;
> 
> -	io_req_map_rw(req, io->rw.iov, io->rw.fast_iov, &iter);
> +	io_req_map_rw(req, io->rw.iov, &io->rw.fast_iov, &iter);
>  	return 0;
>  }
> 
>  static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
>  		   bool force_nonblock)
>  {
> -	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> +	struct iovec_cache cache;
> +	struct iovec *iovec;
>  	struct kiocb *kiocb = &req->rw.kiocb;
>  	struct iov_iter iter;
>  	size_t iov_count;
>  	ssize_t ret;
> 
> -	ret = io_import_iovec(READ, req, &iovec, &iter);
> -	if (ret < 0)
> -		return ret;
> +	iovec = io_import_iovec(READ, req, &cache, &iter);
> +	if (IS_ERR(iovec))
> +		return PTR_ERR(iovec);
> 
>  	/* Ensure we clear previously set non-block flag */
>  	if (!force_nonblock)
> @@ -2265,7 +2263,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kiocb_done(kiocb, ret2, nxt, req->in_async);
>  		} else {
>  copy_iov:
> -			ret = io_setup_async_rw(req, iovec, inline_vecs, &iter);
> +			ret = io_setup_async_rw(req, iovec, &cache, &iter);
>  			if (ret)
>  				goto out_free;
>  			return -EAGAIN;
> @@ -2282,6 +2280,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  {
>  	struct io_async_ctx *io;
>  	struct iov_iter iter;
> +	struct iovec *iov;
>  	ssize_t ret;
> 
>  	ret = io_prep_rw(req, sqe, force_nonblock);
> @@ -2296,29 +2295,30 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		return 0;
> 
>  	io = req->io;
> -	io->rw.iov = io->rw.fast_iov;
>  	req->io = NULL;
> -	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter);
> +	iov = io_import_iovec(WRITE, req, &io->rw.fast_iov, &iter);
>  	req->io = io;
> -	if (ret < 0)
> -		return ret;
> +	if (IS_ERR(iov))
> +		return PTR_ERR(iov);
> +	io->rw.iov = iov;
> 
> -	io_req_map_rw(req, io->rw.iov, io->rw.fast_iov, &iter);
> +	io_req_map_rw(req, io->rw.iov, &io->rw.fast_iov, &iter);
>  	return 0;
>  }
> 
>  static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
>  		    bool force_nonblock)
>  {
> -	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> +	struct iovec_cache cache;
> +	struct iovec *iovec;
>  	struct kiocb *kiocb = &req->rw.kiocb;
>  	struct iov_iter iter;
>  	size_t iov_count;
>  	ssize_t ret;
> 
> -	ret = io_import_iovec(WRITE, req, &iovec, &iter);
> -	if (ret < 0)
> -		return ret;
> +	iovec = io_import_iovec(WRITE, req, &cache, &iter);
> +	if (IS_ERR(iovec))
> +		return PTR_ERR(iovec);
> 
>  	/* Ensure we clear previously set non-block flag */
>  	if (!force_nonblock)
> @@ -2376,7 +2376,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kiocb_done(kiocb, ret2, nxt, req->in_async);
>  		} else {
>  copy_iov:
> -			ret = io_setup_async_rw(req, iovec, inline_vecs, &iter);
> +			ret = io_setup_async_rw(req, iovec, &cache, &iter);
>  			if (ret)
>  				goto out_free;
>  			return -EAGAIN;
> @@ -2994,7 +2994,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  #if defined(CONFIG_NET)
>  	struct io_sr_msg *sr = &req->sr_msg;
>  	struct io_async_ctx *io = req->io;
> -	int ret;
> +	struct iovec *iov;
> 
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags);
>  	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
> @@ -3011,12 +3011,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe
> *sqe)
>  	if (req->flags & REQ_F_NEED_CLEANUP)
>  		return 0;
> 
> -	io->msg.iov = io->msg.fast_iov;
> -	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> -					&io->msg.iov);
> -	if (!ret)
> -		req->flags |= REQ_F_NEED_CLEANUP;
> -	return ret;
> +	iov = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> +					&io->msg.fast_iov);
> +	if (IS_ERR(iov))
> +		return PTR_ERR(iov);
> +
> +	io->msg.iov = iov;
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
>  #else
>  	return -EOPNOTSUPP;
>  #endif
> @@ -3043,19 +3045,21 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kmsg->msg.msg_name = &req->io->msg.addr;
>  			/* if iov is set, it's allocated already */
>  			if (!kmsg->iov)
> -				kmsg->iov = kmsg->fast_iov;
> +				kmsg->iov = kmsg->fast_iov.iov;
>  			kmsg->msg.msg_iter.iov = kmsg->iov;
>  		} else {
>  			struct io_sr_msg *sr = &req->sr_msg;
> +			struct iovec *iov;
> 
>  			kmsg = &io.msg;
>  			kmsg->msg.msg_name = &io.msg.addr;
> 
> -			io.msg.iov = io.msg.fast_iov;
> -			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
> -					sr->msg_flags, &io.msg.iov);
> -			if (ret)
> -				return ret;
> +			iov = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
> +					sr->msg_flags, &io.msg.fast_iov);
> +			if (IS_ERR(iov))
> +				return PTR_ERR(iov);
> +
> +			io.msg.iov = iov;
>  		}
> 
>  		flags = req->sr_msg.msg_flags;
> @@ -3069,7 +3073,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			if (req->io)
>  				return -EAGAIN;
>  			if (io_alloc_async_ctx(req)) {
> -				if (kmsg->iov != kmsg->fast_iov)
> +				if (kmsg->iov != kmsg->fast_iov.iov)
>  					kfree(kmsg->iov);
>  				return -ENOMEM;
>  			}
> @@ -3081,7 +3085,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			ret = -EINTR;
>  	}
> 
> -	if (kmsg && kmsg->iov != kmsg->fast_iov)
> +	if (kmsg && kmsg->iov != kmsg->fast_iov.iov)
>  		kfree(kmsg->iov);
>  	req->flags &= ~REQ_F_NEED_CLEANUP;
>  	io_cqring_add_event(req, ret);
> @@ -3151,7 +3155,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
>  #if defined(CONFIG_NET)
>  	struct io_sr_msg *sr = &req->sr_msg;
>  	struct io_async_ctx *io = req->io;
> -	int ret;
> +	struct iovec *iov;
> 
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags);
>  	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
> @@ -3168,12 +3172,14 @@ static int io_recvmsg_prep(struct io_kiocb *req,
>  	if (req->flags & REQ_F_NEED_CLEANUP)
>  		return 0;
> 
> -	io->msg.iov = io->msg.fast_iov;
> -	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> -					&io->msg.uaddr, &io->msg.iov);
> -	if (!ret)
> -		req->flags |= REQ_F_NEED_CLEANUP;
> -	return ret;
> +	iov = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> +					&io->msg.uaddr, &io->msg.fast_iov);
> +	if (IS_ERR(iov))
> +		return PTR_ERR(iov);
> +
> +	io->msg.iov = iov;
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
>  #else
>  	return -EOPNOTSUPP;
>  #endif
> @@ -3200,20 +3206,23 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kmsg->msg.msg_name = &req->io->msg.addr;
>  			/* if iov is set, it's allocated already */
>  			if (!kmsg->iov)
> -				kmsg->iov = kmsg->fast_iov;
> +				kmsg->iov = kmsg->fast_iov.iov;
>  			kmsg->msg.msg_iter.iov = kmsg->iov;
>  		} else {
>  			struct io_sr_msg *sr = &req->sr_msg;
> +			struct iovec *iov;
> 
>  			kmsg = &io.msg;
>  			kmsg->msg.msg_name = &io.msg.addr;
> 
> -			io.msg.iov = io.msg.fast_iov;
> -			ret = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,
> +			io.msg.iov = io.msg.fast_iov.iov;
> +			iov = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,
>  					sr->msg_flags, &io.msg.uaddr,
> -					&io.msg.iov);
> -			if (ret)
> -				return ret;
> +					&io.msg.fast_iov);
> +			if (IS_ERR(iov))
> +				return PTR_ERR(iov);
> +
> +			io.msg.iov = iov;
>  		}
> 
>  		flags = req->sr_msg.msg_flags;
> @@ -3228,7 +3237,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			if (req->io)
>  				return -EAGAIN;
>  			if (io_alloc_async_ctx(req)) {
> -				if (kmsg->iov != kmsg->fast_iov)
> +				if (kmsg->iov != kmsg->fast_iov.iov)
>  					kfree(kmsg->iov);
>  				return -ENOMEM;
>  			}
> @@ -3240,7 +3249,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
>  			ret = -EINTR;
>  	}
> 
> -	if (kmsg && kmsg->iov != kmsg->fast_iov)
> +	if (kmsg && kmsg->iov != kmsg->fast_iov.iov)
>  		kfree(kmsg->iov);
>  	req->flags &= ~REQ_F_NEED_CLEANUP;
>  	io_cqring_add_event(req, ret);
> @@ -4269,12 +4278,12 @@ static void io_cleanup_req(struct io_kiocb *req)
>  	case IORING_OP_WRITEV:
>  	case IORING_OP_WRITE_FIXED:
>  	case IORING_OP_WRITE:
> -		if (io->rw.iov != io->rw.fast_iov)
> +		if (io->rw.iov != io->rw.fast_iov.iov)
>  			kfree(io->rw.iov);
>  		break;
>  	case IORING_OP_SENDMSG:
>  	case IORING_OP_RECVMSG:
> -		if (io->msg.iov != io->msg.fast_iov)
> +		if (io->msg.iov != io->msg.fast_iov.iov)
>  			kfree(io->msg.iov);
>  		break;
>  	case IORING_OP_OPENAT:
> --
> 1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

