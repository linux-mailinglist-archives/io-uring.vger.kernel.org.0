Return-Path: <io-uring+bounces-1415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E1489A558
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 22:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC56E1C20BD9
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 20:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A514173328;
	Fri,  5 Apr 2024 20:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6sendFp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9052C172BD2;
	Fri,  5 Apr 2024 20:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712347476; cv=none; b=H6bcfzKy1K3/yNv0nQhdet7lMXDeCMlXUVtu1UTK0PtT6KzA5QWkXIB3Dg4eXWAgbtKB3vEmdXVe7d+oKwlqrjhCh3QIdU3p988+cxKxwJe/rCquoM8PJDvAnXnBSSJfhXMlW/YHxYKL/M7IbTlmVCFNJn5XptOqiZgyYNeUwDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712347476; c=relaxed/simple;
	bh=tbbi4WoC47A+bt3krfOjf71ActzV3spu8nYayJm63oA=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxvw+N4SEVAUmSvd7M4RPnzRSeiysRLqi6MJ1Z6I2v5ii8sQ96f81BJAIBlVpk848Ab9aV9tZCUb4oqEN4CnjBPgtTI3L9D3/Tq1XX+atXSW26CeYZAUDRTbImVJ9O+Tbm+F+oMzc33Fxk53hQzVaH9Ejx2UbDgYZ/q8pgrRrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6sendFp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4156c4fe401so16936345e9.1;
        Fri, 05 Apr 2024 13:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712347473; x=1712952273; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=oNObfeJuKkZ5zVbv0of2yxi9979Q5AyU5TKw6nz/51s=;
        b=f6sendFpi41pjEK0IF25gFpWPmgekLSEkAEQhKc+mCpYd6oiGfyD1JOuqCm+qFcIZ/
         24H5o4N4WEPja4wA6hjg4Uzq+GHedK3PQGeOOIF2xoqokEAXO0pQd50VoKc2qGxyguQs
         JSuk1LTCq7RPrAGyCliyyDk39kJ6dFDwcNGUC7Taj0wqZIHOpUljvHzXUZKe5+Yv7QXJ
         ht1fmdXn4gSy3AeTlwO2d8cY0nGKJzJx34/HbyQOJQ7qWP8fFWBQfLIAUSun9iQ+CuaQ
         tugGHUDnPU+3FKEBDFMXUhcByxRP+4PgRJTAQDPuhwvasK6bb2DOMUrFm7IMa3MabgVr
         Dc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712347473; x=1712952273;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNObfeJuKkZ5zVbv0of2yxi9979Q5AyU5TKw6nz/51s=;
        b=Y3VvMLiL27uj3m4bH0iayBgLNUaIiEcNX3x/DtwWjW8H0xNuvirEKye4oDbW55VnrR
         moOhxDSHlu7Q8RohpMikj81cBxB+j2uUT8itKu7qufZFaEoVDToFf/Lj7vSo4bj/1NUj
         obkcvdo89is2HIp3wVZr4DoLMJpqt42L6izrDnjRELPVkjlmTPkM4var8JJkvysbUN1M
         ypvuY6bHLoRyyc9KxB/RtLXh8hqS5RfaGg4gixQ2IZ72sLYGe8iG8F3pBab5AYh4/zM9
         zIDQ6h+37vZYAp5C9sPUTI865jDtLkVL7p8tGuraidNQkK7qMNzoB5Yj6iHqGkJmDLd1
         NNNg==
X-Forwarded-Encrypted: i=1; AJvYcCWgBIYuFznEh2AqrghvbFgF/hSD2qskxDWfcv2tIhYgTrudlVVhIZrAQrcCsrtzAVCVxK3XXO3OWSjhvOaFUF/kISmPDv91x7RJ6ozUkxw+1XQl9wECcIOUfTAXdjVnYpm5QmsWJT8ohjrlQewvJdbpVPkst27BxUF5a3DGERobb8ClUPH5
X-Gm-Message-State: AOJu0YxSkIv3nMDrhNiTnKscjiZuMDMS+G73xloy5AqBRzaN0tAq7dlN
	xvL0ItTeL4J5ecUTJUSK4M0S2ojE/OcG5aSnJatZILJJ5eKN6lfSdYKuNyolekYH9zm55EriUc7
	P0R7vWY44HFB0FGxQxE6BBeJETcQ=
X-Google-Smtp-Source: AGHT+IFB8aEDQ/BbWb+hOhkcYe3VOfWJS6EMMeWrTqCpIDi+W6S2XSEZW4aH+5cffK/Mhx7nORN93E11StYoe/7EisE=
X-Received: by 2002:a05:600c:a04:b0:414:1325:e8a8 with SMTP id
 z4-20020a05600c0a0400b004141325e8a8mr2043843wmp.39.1712347472797; Fri, 05 Apr
 2024 13:04:32 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 5 Apr 2024 13:04:32 -0700
From: Oliver Crumrine <ozlinuxc@gmail.com>
In-Reply-To: <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com> <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Fri, 5 Apr 2024 13:04:32 -0700
Message-ID: <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
To: Pavel Begunkov <asml.silence@gmail.com>, Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	shuah@kernel.org, leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pavel Begunkov wrote:
> On 4/4/24 23:17, Oliver Crumrine wrote:
> > In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> > specifically disabled REQ_F_CQE_SKIP, as (at least from my
> > understanding) the userspace program wouldn't receive the
> > IORING_CQE_F_MORE flag in the result value.
>
> No. IORING_CQE_F_MORE means there will be another CQE from this
> request, so a single CQE without IORING_CQE_F_MORE is trivially
> fine.
>
> The problem is the semantics, because by suppressing the first
> CQE you're loosing the result value. You might rely on WAITALL
That's already happening with io_send.
> as other sends and "fail" (in terms of io_uring) the request
> in case of a partial send posting 2 CQEs, but that's not a great
> way and it's getting userspace complicated pretty easily.
>
> In short, it was left out for later because there is a
> better way to implement it, but it should be done carefully
Maybe we could put the return values in the notifs? That would be a
discrepancy between io_send and io_send_zc, though.
>
>
> > To fix this, instead of keeping track of how many CQEs have been
> > received, and subtracting notifs from that, programs can keep track of
>
> That's a benchmark way of doing it, more realistically
> it'd be more like
>
> event_loop() {
> 	cqe = wait_cqe();
> 	struct req *r = (struct req *)cqe->user_data;
> 	r->callback(r, cqe);
>
>
> send_zc_callback(req, cqe) {
> 	if (cqe->flags & F_MORE) {
> 		// don't free the req
> 		// we should wait for another CQE
> 		...
> 	}
> }
>
> > how many SQEs they have issued, and if a CQE is returned with an error,
> > they can simply subtract from how many notifs they expect to receive.
>
> The design specifically untangles those two notions, i.e. there can
> be a notification even when the main CQE fails (ret<0). It's safer
> this way, even though AFAIK relying on errors would be fine with
> current users (TCP/UDP).
>
>
> > Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
> > ---
> >   io_uring/net.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/io_uring/net.c b/io_uring/net.c
> > index 1e7665ff6ef7..822f49809b68 100644
> > --- a/io_uring/net.c
> > +++ b/io_uring/net.c
> > @@ -1044,9 +1044,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >
> >   	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
> >   		return -EINVAL;
> > -	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
> > -	if (req->flags & REQ_F_CQE_SKIP)
> > -		return -EINVAL;
> >
> >   	notif = zc->notif = io_alloc_notif(ctx);
> >   	if (!notif)
> > @@ -1342,7 +1339,8 @@ void io_sendrecv_fail(struct io_kiocb *req)
> >   		req->cqe.res = sr->done_io;
> >
> >   	if ((req->flags & REQ_F_NEED_CLEANUP) &&
> > -	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
> > +	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC) &&
> > +	    !(req->flags & REQ_F_CQE_SKIP))
> >   		req->cqe.flags |= IORING_CQE_F_MORE;
> >   }
> >
>
> --
> Pavel Begunkov

