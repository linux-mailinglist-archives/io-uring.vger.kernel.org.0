Return-Path: <io-uring+bounces-1435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E410189B202
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 15:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9838D281D4E
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 13:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11AF13664C;
	Sun,  7 Apr 2024 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1kuqwhZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20091353E3;
	Sun,  7 Apr 2024 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712495639; cv=none; b=MNujIyF7GCsuykBmDWxDLlkcFDkOXydpSY9YcRK6yD2JGDz/4R9XqvQ6k/05fnqDuP57KIUJkYEnHwdBqL9S/xBJN1Adt0cGHhM5AkiG8KfpASmHi1jT2E+0SBUIDKgn7D/NXXPdjRAsxgNY+218/jaycAAbV9RrJvTWXIMgpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712495639; c=relaxed/simple;
	bh=yzaslZjG9r8gxOy7pz+qgUzY/Om3cUHp6ppl1M1nP94=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFc3HwM9W2YI2mbX/aTK4hg4BtWhx7P5MGVIZavouH2o1a5WmzsJ9qF5lDOuks3H1s706s4fL5hr4sVsDeWdjqSL94VOdBcQJeo9JE31zL7JGQzVrEIvmARCw73fjHZES/FpPN6K4Po/sZMctlapXCi39TzRI8foPoI5OfVZ2TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1kuqwhZ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4164c9debf6so3409805e9.1;
        Sun, 07 Apr 2024 06:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712495636; x=1713100436; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=7zi9maRkKEe1wJTBLEw6CNhNtu7l7A3MQCK2xzWXoig=;
        b=I1kuqwhZpJ2nn4dCZRaCerfj3NkH87kfUpMjNHvC9qNnga0jogrzg4j9H+pGlfom+6
         86AstJjHM77z7v844rwAuwA7VTc47MGC3gRAKvt2T6EeBJ9KneE3ZxPEHDKxD/pU2ytk
         dq1sVlTDUL6kSAUrCmb2oQPsuN1JMeLwTvSM3gd11h5VlGAWldgo26aXrpew6/LrrD4T
         KyYLWPjZP4yO2BmxyGFhSaCkuuNuhk0C0PxCWjaRI1RxtjQLuhLErWp1qO+dkuLJeJFr
         p54lqsEoy9y5udlIm30STl6CA6Bf6hpwVUih7dpD43PCbKcJnOXX87OK2dabnsl41RPM
         s5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712495636; x=1713100436;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zi9maRkKEe1wJTBLEw6CNhNtu7l7A3MQCK2xzWXoig=;
        b=tf689o5PgrVoAETLZr9LvZhXVz6wgCxPg/F1wxgpHYzfLm/zbHcUKheROx4vgSi9ph
         h1bHbb635+uujCONxYgmXCuXT20/0g36EcYgzlNuaRpOhlLnbyXQEvULe1cukJgk3m2Y
         wq3A5Xn6MYQYxNBJ2cQ8lrPkBjCvCx7ksvHFnUb9dadpzyBNVVQb70uuo3gpjlHkjxUz
         1vrYGA33oQ0udXPiGkonakkqX41Z7sVvN8m4fB5XI7N38ls1Dgr26Gi3gIHuS2kQpLbw
         DGJ/GXaThUJXggjt9rU8Fa4hhP5b3nuhwdqe0RRS8OJwJpb2xit2clN9fJ5SVU2BGJNv
         LCYg==
X-Forwarded-Encrypted: i=1; AJvYcCVF+gzreK5LCv7A/cyLu+HZ3AWN3Ou47JZ6eUGbwD/O5fJ+YlpBViq123ywcZ53ZqbttkCbI1swaP/eHq1zRyLSW/WH/onI9YUPvw5q
X-Gm-Message-State: AOJu0YyVQp3+U15zM8NpysZFS7opYoEB+2CjjIOkzRr64hkbUkRA0gbb
	vAzGXMBcWpmrKW+0/mo/hJQFkQSyGxIG+cPCYjNDaDNvK+fl9/7floxY6dnnl51L792vq2W1/o+
	E1GTa+0mrL8hYUeIpSrBtpKZzBeE=
X-Google-Smtp-Source: AGHT+IFMQd5Z4mba0t8DcKyItcYtNm+DHIZknZxgWv30j3wm1Ztc+J3cCnVxY4y1XMGUMvivR3rrYW8ZPFfLWyOulmM=
X-Received: by 2002:a5d:5708:0:b0:343:3538:4ee4 with SMTP id
 a8-20020a5d5708000000b0034335384ee4mr3582507wrv.45.1712495635860; Sun, 07 Apr
 2024 06:13:55 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 7 Apr 2024 06:13:55 -0700
From: Oliver Crumrine <ozlinuxc@gmail.com>
In-Reply-To: <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com> <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com> <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Sun, 7 Apr 2024 06:13:55 -0700
Message-ID: <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
To: Pavel Begunkov <asml.silence@gmail.com>, Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pavel Begunkov wrote:
> On 4/5/24 21:04, Oliver Crumrine wrote:
> > Pavel Begunkov wrote:
> >> On 4/4/24 23:17, Oliver Crumrine wrote:
> >>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> >>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
> >>> understanding) the userspace program wouldn't receive the
> >>> IORING_CQE_F_MORE flag in the result value.
> >>
> >> No. IORING_CQE_F_MORE means there will be another CQE from this
> >> request, so a single CQE without IORING_CQE_F_MORE is trivially
> >> fine.
> >>
> >> The problem is the semantics, because by suppressing the first
> >> CQE you're loosing the result value. You might rely on WAITALL
> > That's already happening with io_send.
>
> Right, and it's still annoying and hard to use
Another solution might be something where there is a counter that stores
how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
userspace could call a function like: io_wait_completions(int completions)
which would wait until everything is done, and then userspace could peek
the completion ring.
>
> >> as other sends and "fail" (in terms of io_uring) the request
> >> in case of a partial send posting 2 CQEs, but that's not a great
> >> way and it's getting userspace complicated pretty easily.
> >>
> >> In short, it was left out for later because there is a
> >> better way to implement it, but it should be done carefully
> > Maybe we could put the return values in the notifs? That would be a
> > discrepancy between io_send and io_send_zc, though.
>
> Yes. And yes, having a custom flavour is not good. It'd only
> be well usable if apart from returning the actual result
> it also guarantees there will be one and only one CQE, then
> the userspace doesn't have to do the dancing with counting
> and checking F_MORE. In fact, I outlined before how a generic
> solution may looks like:
>
> https://github.com/axboe/liburing/issues/824
>
> The only interesting part, IMHO, is to be able to merge the
> main completion with its notification. Below is an old stash
> rebased onto for-6.10. The only thing missing is relinking,
> but maybe we don't even care about it. I need to cover it
> well with tests.
The patch looks pretty good. The only potential issue is that you store
the res of the normal CQE into the notif CQE. This overwrites the
IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
indicate to userspace that there will be another CQE, of which there
won't.
>
>
>
>
> commit ca5e4fb6d105b5dfdf3768d46ce01529b7bb88c5
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sat Apr 6 15:46:38 2024 +0100
>
>      io_uring/net: introduce single CQE send zc mode
>
>      IORING_OP_SEND[MSG]_ZC requests are posting two completions, one to
>      notify that the data was queued, and later a second, usually referred
>      as "notification", to let the user know that the buffer used can be
>      reused/freed. In some cases the user might not care about the main
>      completion and would be content getting only the notification, which
>      would allow to simplify the userspace.
>
>      One example is when after a send the user would be waiting for the other
>      end to get the message and reply back not pushing any more data in the
>      meantime. Another case is unreliable protocols like UDP, which do not
>      require a confirmation from the other end before dropping buffers, and
>      so the notifications are usually posted shortly after the send request
>      is queued.
>
>      Add a flag merging completions into a single CQE. cqe->res will store
>      the send's result as usual, and it will have IORING_CQE_F_NOTIF set if
>      the buffer was potentially used. Timewise, it would be posted at the
>      moment when the notification would have been originally completed.
>
>      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 7bd10201a02b..e2b528c341c9 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -356,6 +356,7 @@ enum io_uring_op {
>   #define IORING_RECV_MULTISHOT		(1U << 1)
>   #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
>   #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
> +#define IORING_SEND_ZC_COMBINE_CQE	(1U << 4)
>
>   /*
>    * cqe.res for IORING_CQE_F_NOTIF if
> diff --git a/io_uring/net.c b/io_uring/net.c
> index a74287692071..052f030ab8f8 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -992,7 +992,19 @@ void io_send_zc_cleanup(struct io_kiocb *req)
>   	}
>   }
>
> -#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
> +static inline void io_sendzc_adjust_res(struct io_kiocb *req)
> +{
> +	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> +
> +	if (sr->flags & IORING_SEND_ZC_COMBINE_CQE) {
> +		sr->notif->cqe.res = req->cqe.res;
> +		req->flags |= REQ_F_CQE_SKIP;
> +	}
> +}
> +
> +#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | \
> +			    IORING_RECVSEND_FIXED_BUF | \
> +			    IORING_SEND_ZC_COMBINE_CQE)
>   #define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
>
>   int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> @@ -1022,6 +1034,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		if (zc->flags & ~IO_ZC_FLAGS_VALID)
>   			return -EINVAL;
>   		if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
> +			if (zc->flags & IORING_SEND_ZC_COMBINE_CQE)
> +				return -EINVAL;
>   			io_notif_set_extended(notif);
>   			io_notif_to_data(notif)->zc_report = true;
>   		}
> @@ -1197,6 +1211,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
>   	else if (zc->done_io)
>   		ret = zc->done_io;
>
> +	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> +	io_sendzc_adjust_res(req);
> +
>   	/*
>   	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
>   	 * flushing notif to io_send_zc_cleanup()
> @@ -1205,7 +1222,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
>   		io_notif_flush(zc->notif);
>   		io_req_msg_cleanup(req, 0);
>   	}
> -	io_req_set_res(req, ret, IORING_CQE_F_MORE);
>   	return IOU_OK;
>   }
>

>   	else if (sr->done_io)
>   		ret = sr->done_io;
>
> +	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> +	io_sendzc_adjust_res(req);
> +
>   	/*
>   	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
>   	 * flushing notif to io_send_zc_cleanup()
> @@ -1266,7 +1285,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
>   		io_notif_flush(sr->notif);
>   		io_req_msg_cleanup(req, 0);
>   	}
> -	io_req_set_res(req, ret, IORING_CQE_F_MORE);
>   	return IOU_OK;
>   }
>
> @@ -1278,8 +1296,10 @@ void io_sendrecv_fail(struct io_kiocb *req)
>   		req->cqe.res = sr->done_io;
>
>   	if ((req->flags & REQ_F_NEED_CLEANUP) &&
> -	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
> +	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
>   		req->cqe.flags |= IORING_CQE_F_MORE;
> +		io_sendzc_adjust_res(req);
> +	}
>   }
>
>   int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>
>
> --
> Pavel Begunkov

