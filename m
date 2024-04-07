Return-Path: <io-uring+bounces-1437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA4889B3C6
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 21:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD0581C20BBA
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 19:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038991E889;
	Sun,  7 Apr 2024 19:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlYBdHDC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0206A3E46D;
	Sun,  7 Apr 2024 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517300; cv=none; b=iHe8ZhuNzS3n3CiqNSOyVGzrTEAmaPdlT6P7jgaU6B5OmNgWSA61u4GefAFzztb3lM0pKjb7mNSfqEUPEGvOwMOtqpjma7DGxW56gQPjDtBuakX7Z8mIotHBFg46ln2Wv+cRAxD1cuJilM2cr67T9gMVEUFITuFEs7oaWhWt+Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517300; c=relaxed/simple;
	bh=9RWWgQeSaVZMIAeu/qiCqa6+4hSN9vLPiol43n48sp0=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i76l5pUCLdbfHUicz07/LBpvd6SbkEzAxRltpT5JaFbLgmxjUmFfggylbgKDOcciVwKg17yeaaL45I3TppmFH6idSa0+a1iFQLEq/91D1KNYHkhV/w1MB6CctEz3JC2rBVmGtxoS4aPb4Aruc8osFIuon3CSFZy6loZPW/Hu3Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlYBdHDC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-343b7c015a8so2359836f8f.1;
        Sun, 07 Apr 2024 12:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712517297; x=1713122097; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+gdPiUUIiUQITPAoo0ks+ZsORrAf0MHk7pXFtNSkrc=;
        b=QlYBdHDC3f2/lHlHnrsx30UW4wzPPdg0nZmx4xrlMXfGWttIpzE5hbq/8Y08nPLS3+
         8lFGezKUm6nwWCUUszrRgcdxItvUdDjLXZYq6qkF1o8zQWHWEAgP6dFbZLH4PN0bdvAn
         zGWgYz6NQeg8X5b1da7jyilnmfXFifGKJbyqOLhGr0ywnuhi0XT6f0cQ7Z8b05/piB7E
         le52Z6zOKaxQbwWe2k0a3S7N+udffhPeXTtJqHevJjRo0LGdisSd0rbRtwze1DsUX8z+
         iiwiXAlYM7SxFPuGjsbhEqRBV7/HacFr4YWlLjr8xHWluHVcyrDElcjPyKKthqgSkwHO
         CEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517297; x=1713122097;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+gdPiUUIiUQITPAoo0ks+ZsORrAf0MHk7pXFtNSkrc=;
        b=uYsfQqLuh9hCsnmp12vayuiPoFa67EatvOrJ1HEm6MJuZN9RZfra4L53wAtqPTGdGb
         q7GP0AceOsWzrtDrXxf05OYH9yIg6FymioeEx/kL4tq7Sfa1jDSTlbRpJ85cg/f3NLZu
         3QnEI72tKQzgmWpHPKBX4nZKm5hp0xCpJ5UDlqxdkvNTE04TkxaAThLTz3GzoCV3nnWg
         0hRjpF8nkSGE4r7ey83cxfgCbTqjfwT28xjpMgsCoYRFqbYwInzLu88hgakubJLnXNPD
         fluIEE0/p4s/S+m8gRplljr7ns2kKuBMbddvUqeAtwIp1zeTS0r735EHwpbn6j6e0aut
         ZgNg==
X-Forwarded-Encrypted: i=1; AJvYcCVFsecmjV8YL5cvjdd11CaMt/vSKKvAbGsqHISMnE9cOtn3JTYVa354EN1J4oK5Nxy7cr4EvaiNssQ+CC64yz3AoVm4fl8ukUwhxVjG
X-Gm-Message-State: AOJu0Yy02+AtUcNOPZvgkgB+3p/Zm2xAYPJQ58v1r2/qLWa4fIP3ey94
	ku1OzeV/c2hrHyQ3+4Ck6HdBXe7sH4GRtZnvJoiyPHL8K7yGYxiiBsWvO2q7zUYMREu0QvIPncT
	Lag1a3+7WIh8npMFw0V+sJ6nMT6M=
X-Google-Smtp-Source: AGHT+IFpFV4CXXbf/0k5lILYcg76tGfFvrf4I2cakorGM8W7mFWzxGK5+sHDHDKzohgyHkXBFNn/T9z93yhsz2rHuic=
X-Received: by 2002:a5d:6a09:0:b0:343:79e8:a4d6 with SMTP id
 m9-20020a5d6a09000000b0034379e8a4d6mr3932188wru.25.1712517296930; Sun, 07 Apr
 2024 12:14:56 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 7 Apr 2024 12:14:56 -0700
From: Oliver Crumrine <ozlinuxc@gmail.com>
In-Reply-To: <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com> <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com> <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com> <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Sun, 7 Apr 2024 12:14:56 -0700
Message-ID: <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
To: Pavel Begunkov <asml.silence@gmail.com>, Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Oliver Crumrine wrote:
> Pavel Begunkov wrote:
> > On 4/5/24 21:04, Oliver Crumrine wrote:
> > > Pavel Begunkov wrote:
> > >> On 4/4/24 23:17, Oliver Crumrine wrote:
> > >>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> > >>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
> > >>> understanding) the userspace program wouldn't receive the
> > >>> IORING_CQE_F_MORE flag in the result value.
> > >>
> > >> No. IORING_CQE_F_MORE means there will be another CQE from this
> > >> request, so a single CQE without IORING_CQE_F_MORE is trivially
> > >> fine.
> > >>
> > >> The problem is the semantics, because by suppressing the first
> > >> CQE you're loosing the result value. You might rely on WAITALL
> > > That's already happening with io_send.
> >
> > Right, and it's still annoying and hard to use
> Another solution might be something where there is a counter that stores
> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
> userspace could call a function like: io_wait_completions(int completions)
> which would wait until everything is done, and then userspace could peek
> the completion ring.
> >
> > >> as other sends and "fail" (in terms of io_uring) the request
> > >> in case of a partial send posting 2 CQEs, but that's not a great
> > >> way and it's getting userspace complicated pretty easily.
> > >>
> > >> In short, it was left out for later because there is a
> > >> better way to implement it, but it should be done carefully
> > > Maybe we could put the return values in the notifs? That would be a
> > > discrepancy between io_send and io_send_zc, though.
> >
> > Yes. And yes, having a custom flavour is not good. It'd only
> > be well usable if apart from returning the actual result
> > it also guarantees there will be one and only one CQE, then
> > the userspace doesn't have to do the dancing with counting
> > and checking F_MORE. In fact, I outlined before how a generic
> > solution may looks like:
> >
> > https://github.com/axboe/liburing/issues/824
> >
> > The only interesting part, IMHO, is to be able to merge the
> > main completion with its notification. Below is an old stash
> > rebased onto for-6.10. The only thing missing is relinking,
> > but maybe we don't even care about it. I need to cover it
> > well with tests.
> The patch looks pretty good. The only potential issue is that you store
> the res of the normal CQE into the notif CQE. This overwrites the
> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
> indicate to userspace that there will be another CQE, of which there
> won't.
I was wrong here; Mixed up flags and result value.
> >
> >
> >
> >
> > commit ca5e4fb6d105b5dfdf3768d46ce01529b7bb88c5
> > Author: Pavel Begunkov <asml.silence@gmail.com>
> > Date:   Sat Apr 6 15:46:38 2024 +0100
> >
> >      io_uring/net: introduce single CQE send zc mode
> >
> >      IORING_OP_SEND[MSG]_ZC requests are posting two completions, one to
> >      notify that the data was queued, and later a second, usually referred
> >      as "notification", to let the user know that the buffer used can be
> >      reused/freed. In some cases the user might not care about the main
> >      completion and would be content getting only the notification, which
> >      would allow to simplify the userspace.
> >
> >      One example is when after a send the user would be waiting for the other
> >      end to get the message and reply back not pushing any more data in the
> >      meantime. Another case is unreliable protocols like UDP, which do not
> >      require a confirmation from the other end before dropping buffers, and
> >      so the notifications are usually posted shortly after the send request
> >      is queued.
> >
> >      Add a flag merging completions into a single CQE. cqe->res will store
> >      the send's result as usual, and it will have IORING_CQE_F_NOTIF set if
> >      the buffer was potentially used. Timewise, it would be posted at the
> >      moment when the notification would have been originally completed.
> >
> >      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 7bd10201a02b..e2b528c341c9 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -356,6 +356,7 @@ enum io_uring_op {
> >   #define IORING_RECV_MULTISHOT		(1U << 1)
> >   #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
> >   #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
> > +#define IORING_SEND_ZC_COMBINE_CQE	(1U << 4)
> >
> >   /*
> >    * cqe.res for IORING_CQE_F_NOTIF if
> > diff --git a/io_uring/net.c b/io_uring/net.c
> > index a74287692071..052f030ab8f8 100644
> > --- a/io_uring/net.c
> > +++ b/io_uring/net.c
> > @@ -992,7 +992,19 @@ void io_send_zc_cleanup(struct io_kiocb *req)
> >   	}
> >   }
> >
> > -#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
> > +static inline void io_sendzc_adjust_res(struct io_kiocb *req)
> > +{
> > +	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> > +
> > +	if (sr->flags & IORING_SEND_ZC_COMBINE_CQE) {
> > +		sr->notif->cqe.res = req->cqe.res;
> > +		req->flags |= REQ_F_CQE_SKIP;
> > +	}
> > +}
> > +
> > +#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | \
> > +			    IORING_RECVSEND_FIXED_BUF | \
> > +			    IORING_SEND_ZC_COMBINE_CQE)
> >   #define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
> >
> >   int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > @@ -1022,6 +1034,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >   		if (zc->flags & ~IO_ZC_FLAGS_VALID)
> >   			return -EINVAL;
> >   		if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
> > +			if (zc->flags & IORING_SEND_ZC_COMBINE_CQE)
> > +				return -EINVAL;
> >   			io_notif_set_extended(notif);
> >   			io_notif_to_data(notif)->zc_report = true;
> >   		}
> > @@ -1197,6 +1211,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
> >   	else if (zc->done_io)
> >   		ret = zc->done_io;
> >
> > +	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> > +	io_sendzc_adjust_res(req);
> > +
> >   	/*
> >   	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
> >   	 * flushing notif to io_send_zc_cleanup()
> > @@ -1205,7 +1222,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
> >   		io_notif_flush(zc->notif);
> >   		io_req_msg_cleanup(req, 0);
> >   	}
> > -	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> >   	return IOU_OK;
> >   }
> >
>
> >   	else if (sr->done_io)
> >   		ret = sr->done_io;
> >
> > +	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> > +	io_sendzc_adjust_res(req);
> > +
> >   	/*
> >   	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
> >   	 * flushing notif to io_send_zc_cleanup()
> > @@ -1266,7 +1285,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
> >   		io_notif_flush(sr->notif);
> >   		io_req_msg_cleanup(req, 0);
> >   	}
> > -	io_req_set_res(req, ret, IORING_CQE_F_MORE);
> >   	return IOU_OK;
> >   }
> >
> > @@ -1278,8 +1296,10 @@ void io_sendrecv_fail(struct io_kiocb *req)
> >   		req->cqe.res = sr->done_io;
> >
> >   	if ((req->flags & REQ_F_NEED_CLEANUP) &&
> > -	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
> > +	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
> >   		req->cqe.flags |= IORING_CQE_F_MORE;
> > +		io_sendzc_adjust_res(req);
> > +	}
> >   }
> >
> >   int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >
> >
> > --
> > Pavel Begunkov
>
>

