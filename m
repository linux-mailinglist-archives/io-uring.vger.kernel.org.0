Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADAB55E762
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347624AbiF1PRl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiF1PRk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:17:40 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1901F32053
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:17:39 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s17so13179193iob.7
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jRkMzSQzgOMgPIEkkuhPs2nAj1hHj9sd4Ri+U/HJKsQ=;
        b=3CnJqKTXL8Azv13zI2BEkSJuzpXac2RqDDiOAhEjehAxPPpCfR/JKGJcUIxgjN4nJX
         UzoOj2eOSG+/3jGxVWbefGBrAfLd6DdDZNxaYc/2ry9rwJ6tX0gc5Nt9dj41IHBrTzVx
         xeYO183OIKOjnaDOivHFWm7PZUjw3Rbwc6O004zLSTWlHUwXjuTfEOqnLyFcD97k+xRi
         MRk1fxHzMntbEFlbzRX6a5Jwqxm/wUTVbVsOL6hG3Tn2Ii/VDlq+3k96M5bDHDi4+mra
         TJHuLFOF2TaCSDsGiV7RumT/xbm0t4MET9rgcmD2vKYHJvr1p3FWH+6xK94eaGHE9Tme
         4peg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jRkMzSQzgOMgPIEkkuhPs2nAj1hHj9sd4Ri+U/HJKsQ=;
        b=pQs4EaGetbX0Gk+uMByHrCUlyiq8UyufyQ/hFD8QTcmRHwYD4JdkTk1tgbtQCiM4Mu
         iaHqbhhjtMOBhoMVtvxD5NJbeeBUoiJs56rlzAVBylCwAEX37p6xqMxtYwC2K+/nRVyl
         VRekfDk8VmmYeoDj+hQVoBsjnrj+QKs4+ujY0KarIrW4cbNTfe6Nj7UZTNFS4qXOrNCg
         0zYX9GzcrcQEruHHSNwC6XII44qVNTRT78SJPbThaKO26SvtlJAQ1oqs4FbFZqakzWx2
         VNV/8v43AcrQtUoMPHgTgHDQDNMVuyYGfqDnhh+ls732SPTNX8PQcJYtAHKDTogu48zH
         nZrQ==
X-Gm-Message-State: AJIora/qpPmY/fMjuunRPdqeH0gvWA8uTYeki4kLE0mmgXFLxZZl8zBf
        c1dExf2y0ovA9DXH9rqfjTcBLg==
X-Google-Smtp-Source: AGRyM1si+3E1+d8q6BXGRJWygzB54R9wQkcd0jeCC63qrY1a+b74XrvjSgqWaAxnjYXhhFCyLW6CCA==
X-Received: by 2002:a5d:9d9b:0:b0:669:cd74:7e0d with SMTP id ay27-20020a5d9d9b000000b00669cd747e0dmr10131641iob.7.1656429458412;
        Tue, 28 Jun 2022 08:17:38 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k15-20020a02a70f000000b00331b9a3c5adsm6092281jam.170.2022.06.28.08.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:17:37 -0700 (PDT)
Message-ID: <8af6250c-9f83-3a33-fa73-e6df0982ff63@kernel.dk>
Date:   Tue, 28 Jun 2022 09:17:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 8/8] io_uring: multishot recv
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com, linux-kernel@vger.kernel.org
References: <20220628150228.1379645-1-dylany@fb.com>
 <20220628150228.1379645-9-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220628150228.1379645-9-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 9:02 AM, Dylan Yudaken wrote:
> @@ -399,13 +401,22 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	sr->len = READ_ONCE(sqe->len);
>  	sr->flags = READ_ONCE(sqe->addr2);
> -	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
> +	if (sr->flags & ~(RECVMSG_FLAGS))
>  		return -EINVAL;
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>  	if (sr->msg_flags & MSG_DONTWAIT)
>  		req->flags |= REQ_F_NOWAIT;
>  	if (sr->msg_flags & MSG_ERRQUEUE)
>  		req->flags |= REQ_F_CLEAR_POLLIN;
> +	if (sr->flags & IORING_RECV_MULTISHOT) {
> +		if (!(req->flags & REQ_F_BUFFER_SELECT))
> +			return -EINVAL;
> +		if (sr->msg_flags & MSG_WAITALL)
> +			return -EINVAL;
> +		if (req->opcode == IORING_OP_RECV && sr->len)
> +			return -EINVAL;
> +		req->flags |= REQ_F_APOLL_MULTISHOT;
> +	}

Do we want to forbid not using provided buffers? If you have a ping-pong
type setup, eg you know you'll have to send something before you receive
anything again, seems like it'd be feasible to use this with a normal
buffer?

I strongly suspect that most use cases will use provided buffers for
this, just wondering if there are any particular reasons for forbidding
it explicitly.

>  
>  #ifdef CONFIG_COMPAT
>  	if (req->ctx->compat)
> @@ -415,6 +426,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	return 0;
>  }
>  
> +static inline void io_recv_prep_retry(struct io_kiocb *req)
> +{
> +	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
> +
> +	sr->done_io = 0;
> +	sr->len = 0; /* get from the provided buffer */
> +}
> +
>  int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
> @@ -424,6 +443,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	unsigned flags;
>  	int ret, min_ret = 0;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	size_t len = sr->len;
>  
>  	sock = sock_from_file(req->file);
>  	if (unlikely(!sock))
> @@ -442,16 +462,17 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
>  		return io_setup_async_msg(req, kmsg);
>  
> +retry_multishot:
>  	if (io_do_buffer_select(req)) {
>  		void __user *buf;
>  
> -		buf = io_buffer_select(req, &sr->len, issue_flags);
> +		buf = io_buffer_select(req, &len, issue_flags);
>  		if (!buf)
>  			return -ENOBUFS;
>  		kmsg->fast_iov[0].iov_base = buf;
> -		kmsg->fast_iov[0].iov_len = sr->len;
> +		kmsg->fast_iov[0].iov_len = len;
>  		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
> -				sr->len);
> +				len);
>  	}
>  
>  	flags = sr->msg_flags;
> @@ -463,8 +484,15 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	kmsg->msg.msg_get_inq = 1;
>  	ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, flags);
>  	if (ret < min_ret) {
> -		if (ret == -EAGAIN && force_nonblock)
> -			return io_setup_async_msg(req, kmsg);
> +		if (ret == -EAGAIN && force_nonblock) {
> +			ret = io_setup_async_msg(req, kmsg);
> +			if (ret == -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) ==
> +					       IO_APOLL_MULTI_POLLED) {
> +				io_kbuf_recycle(req, issue_flags);
> +				ret = IOU_ISSUE_SKIP_COMPLETE;
> +			}
> +			return ret;
> +		}
>  		if (ret == -ERESTARTSYS)
>  			ret = -EINTR;
>  		if (ret > 0 && io_net_retry(sock, flags)) {
> @@ -491,8 +519,24 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	cflags = io_put_kbuf(req, issue_flags);
>  	if (kmsg->msg.msg_inq)
>  		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
> +
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> +		io_req_set_res(req, ret, cflags);
> +		return IOU_OK;
> +	}
> +
> +	if (ret > 0) {
> +		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, ret,
> +				    cflags | IORING_CQE_F_MORE)) {
> +			io_recv_prep_retry(req);
> +			goto retry_multishot;
> +		} else {
> +			ret = -ECANCELED;
> +		}
> +	}
> +
>  	io_req_set_res(req, ret, cflags);
> -	return IOU_OK;
> +	return req->flags & REQ_F_POLLED ? IOU_STOP_MULTISHOT : ret;
>  }

Minor style, but I prefer avoiding ternaries if possible. This is much
easier to read for me:

	if (req->flags & REQ_F_POLLED)
		return IOU_STOP_MULTISHOT;
	return ret;

> @@ -505,6 +549,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	unsigned flags;
>  	int ret, min_ret = 0;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	size_t len = sr->len;
>  
>  	if (!(req->flags & REQ_F_POLLED) &&
>  	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
> @@ -514,16 +559,17 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	if (unlikely(!sock))
>  		return -ENOTSOCK;
>  
> +retry_multishot:
>  	if (io_do_buffer_select(req)) {
>  		void __user *buf;
>  
> -		buf = io_buffer_select(req, &sr->len, issue_flags);
> +		buf = io_buffer_select(req, &len, issue_flags);
>  		if (!buf)
>  			return -ENOBUFS;
>  		sr->buf = buf;
>  	}
>  
> -	ret = import_single_range(READ, sr->buf, sr->len, &iov, &msg.msg_iter);
> +	ret = import_single_range(READ, sr->buf, len, &iov, &msg.msg_iter);
>  	if (unlikely(ret))
>  		goto out_free;
>  
> @@ -543,8 +589,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	ret = sock_recvmsg(sock, &msg, flags);
>  	if (ret < min_ret) {
> -		if (ret == -EAGAIN && force_nonblock)
> -			return -EAGAIN;
> +		if (ret == -EAGAIN && force_nonblock) {
> +			if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
> +				io_kbuf_recycle(req, issue_flags);
> +				ret = IOU_ISSUE_SKIP_COMPLETE;
> +			}
> +
> +			return ret;
> +		}

Maybe:
		if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
			io_kbuf_recycle(req, issue_flags);
			return IOU_ISSUE_SKIP_COMPLETE;
		}

		return ret;

> @@ -570,8 +622,25 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	cflags = io_put_kbuf(req, issue_flags);
>  	if (msg.msg_inq)
>  		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
> +
> +
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> +		io_req_set_res(req, ret, cflags);
> +		return IOU_OK;
> +	}
> +
> +	if (ret > 0) {
> +		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, ret,
> +				    cflags | IORING_CQE_F_MORE)) {
> +			io_recv_prep_retry(req);
> +			goto retry_multishot;
> +		} else {
> +			ret = -ECANCELED;
> +		}
> +	}
> +
>  	io_req_set_res(req, ret, cflags);
> -	return IOU_OK;
> +	return req->flags & REQ_F_POLLED ? IOU_STOP_MULTISHOT : ret;
>  }

Same here, and maybe this needs to be a helper so you could just do

	return io_recv_finish(req, ret, cflags);

or something like that? It's non-trivial duplicated code.

-- 
Jens Axboe

