Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F48319993D
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 17:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgCaPKT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 31 Mar 2020 11:10:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20361 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgCaPKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 11:10:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-100-Sh6i9EmcPFSOkPYOf_5IaA-1; Tue, 31 Mar 2020 16:10:15 +0100
X-MC-Unique: Sh6i9EmcPFSOkPYOf_5IaA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 31 Mar 2020 16:10:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 31 Mar 2020 16:10:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: FW: [RFC PATCH 02/12] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Topic: [RFC PATCH 02/12] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Index: AdYHYUSKSGJaZEFfSFajLxQsesYkOQADTLgQ
Date:   Tue, 31 Mar 2020 15:10:15 +0000
Message-ID: <1e7279e89d2a40079c2da188a10e32e5@AcuMS.aculab.com>
References: <87c31730ece341b0bdf29745b9411ab8@AcuMS.aculab.com>
In-Reply-To: <87c31730ece341b0bdf29745b9411ab8@AcuMS.aculab.com>
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



> -----Original Message-----
> From: David Laight
> Sent: 31 March 2020 14:52
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: [RFC PATCH 02/12] fs/io_uring Don't use the return value from import_iovec().
> 
> This is the only code that relies on import_iovec() returning
> iter.count on success.
> Not using the value actually saves passing it through to functions
> that are also passed the 'iter'.
> This allows a better interface to import_iovec().
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  fs/io_uring.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3affd96..d8dc2e2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2153,12 +2153,11 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
>  	return ret;
>  }
> 
> -static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
> -			  struct iovec *iovec, struct iovec *fast_iov,
> -			  struct iov_iter *iter)
> +static void io_req_map_rw(struct io_kiocb *req, struct iovec *iovec,
> +			  struct iovec *fast_iov, struct iov_iter *iter)
>  {
>  	req->io->rw.nr_segs = iter->nr_segs;
> -	req->io->rw.size = io_size;
> +	req->io->rw.size = iter->count;
>  	req->io->rw.iov = iovec;
>  	if (!req->io->rw.iov) {
>  		req->io->rw.iov = req->io->rw.fast_iov;
> @@ -2177,9 +2176,8 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
>  	return req->io == NULL;
>  }
> 
> -static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
> -			     struct iovec *iovec, struct iovec *fast_iov,
> -			     struct iov_iter *iter)
> +static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
> +			     struct iovec *fast_iov, struct iov_iter *iter)
>  {
>  	if (!io_op_defs[req->opcode].async_ctx)
>  		return 0;
> @@ -2187,7 +2185,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
>  		if (io_alloc_async_ctx(req))
>  			return -ENOMEM;
> 
> -		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
> +		io_req_map_rw(req, iovec, fast_iov, iter);
>  	}
>  	return 0;
>  }
> @@ -2218,7 +2216,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (ret < 0)
>  		return ret;
> 
> -	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
> +	io_req_map_rw(req, io->rw.iov, io->rw.fast_iov, &iter);
>  	return 0;
>  }
> 
> @@ -2229,7 +2227,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
>  	struct kiocb *kiocb = &req->rw.kiocb;
>  	struct iov_iter iter;
>  	size_t iov_count;
> -	ssize_t io_size, ret;
> +	ssize_t ret;
> 
>  	ret = io_import_iovec(READ, req, &iovec, &iter);
>  	if (ret < 0)
> @@ -2240,9 +2238,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
>  		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
> 
>  	req->result = 0;
> -	io_size = ret;
>  	if (req->flags & REQ_F_LINK)
> -		req->result = io_size;
> +		req->result = iter.count;
> 
>  	/*
>  	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
> @@ -2268,8 +2265,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kiocb_done(kiocb, ret2, nxt, req->in_async);
>  		} else {
>  copy_iov:
> -			ret = io_setup_async_rw(req, io_size, iovec,
> -						inline_vecs, &iter);
> +			ret = io_setup_async_rw(req, iovec, inline_vecs, &iter);
>  			if (ret)
>  				goto out_free;
>  			return -EAGAIN;
> @@ -2307,7 +2303,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (ret < 0)
>  		return ret;
> 
> -	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
> +	io_req_map_rw(req, io->rw.iov, io->rw.fast_iov, &iter);
>  	return 0;
>  }
> 
> @@ -2318,7 +2314,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
>  	struct kiocb *kiocb = &req->rw.kiocb;
>  	struct iov_iter iter;
>  	size_t iov_count;
> -	ssize_t ret, io_size;
> +	ssize_t ret;
> 
>  	ret = io_import_iovec(WRITE, req, &iovec, &iter);
>  	if (ret < 0)
> @@ -2329,9 +2325,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
>  		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
> 
>  	req->result = 0;
> -	io_size = ret;
>  	if (req->flags & REQ_F_LINK)
> -		req->result = io_size;
> +		req->result = iter.count;
> 
>  	/*
>  	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
> @@ -2381,8 +2376,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
>  			kiocb_done(kiocb, ret2, nxt, req->in_async);
>  		} else {
>  copy_iov:
> -			ret = io_setup_async_rw(req, io_size, iovec,
> -						inline_vecs, &iter);
> +			ret = io_setup_async_rw(req, iovec, inline_vecs, &iter);
>  			if (ret)
>  				goto out_free;
>  			return -EAGAIN;
> --
> 1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

