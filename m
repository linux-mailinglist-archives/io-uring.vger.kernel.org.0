Return-Path: <io-uring+bounces-6388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DF2A331D0
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2CF37A2287
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D966A202F61;
	Wed, 12 Feb 2025 21:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="glTpOYId"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7881FF1DF
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 21:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739397534; cv=none; b=ITUCpZlHtpm+dYf9KdQG9lUjKi52kABn6cMYd9XlbU2yd8P1SLVpz5LGUuT6O1kEhHRzDD2AOLrshRKyqQhHb2p77yUiHwWqzJOqUD/tJsMMjL131VcUz3702D2Vva2fUHtiT6p5LSst7JB/RDlFWohaF2T6gXVi8tiqJQeFgmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739397534; c=relaxed/simple;
	bh=ZeJV606HhNOYcrFNa/6JlfrCAbfQCMj5yvznSZgG+FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nNrsPnd3kHYIf65XB/yuAOo6wGKfP9X/Uf1Lh6Dia38Bo8AN8xzZdJwE4ViYlZmNCG8yM6pLsv2+3AT5LB6lirGB2El+qMKreAlQkY+7wWexnA8mRW5jt63YisyQWSPlVwABr8xNyGhfyAOY4RjYiNcOvrjYQ1nN+6h1Tyk8Svc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=glTpOYId; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21f6fb68502so377275ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 13:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739397532; x=1740002332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vkMubqrMNCA+P8txMR+PCY+IaB0s5pHKten9Sx9268=;
        b=glTpOYIdb+kLz1ZRA1Vnu9O39TWSqAIQbKMXCHSA5K5/yEOA34LVq8knQGuWLcaLW8
         muAB65UZp60B2GpGIyJVd3IH5y2OC3i/3+Xa3czqbi1bSY53icUXS04KPBEqNsx2JPJx
         HKRBTGjMCuakuyPhgAX92/Buf+CeIRbpv4nphr+n3v6u3dCHM7ld7T5gwuTxh+kaSXOE
         euk6Gkv4tW8FC5WqMR6G2ez8kYMSJkAU0j1+6K8wgrfRKU2t2DvyN4IXNYrMCN/LvKw/
         rYavhUU+x7l/74NMxWNwzqgrTqmG3zUOz9dQv8/thtMBWghLndsA8yBkWNvLR5GWp5yJ
         oBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739397532; x=1740002332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7vkMubqrMNCA+P8txMR+PCY+IaB0s5pHKten9Sx9268=;
        b=Y6XHIWlpPfDzLeVx6sVMuv1ydyWekBlC46QU12WC0Xp0pQeXED3VpdSlDJ5Cnt8luR
         9Rm6Q3cSEMJDCcaJc5QioLe8mWcB5SZvNrJuJqTRoa1Gz8aiq2YgeJxYHTWwWISLxNBH
         cT+V2awUpBL8s/v+a8EKLiu+1R2vVP2CCpIw4QSJa1uFvZF5hiWbSpEAaJT2TTcEXE77
         ZgmpDVrVYvYipyHnXDn+xNL6UrvPpWRSzSeii0pJIe3RSijOZ6Fqp//B85hv3CQEvlVo
         misGaFcqTGML+V0qYpE6zvH451lyImSshpliuj0kkQu7XfLlk/rAolqEmTc5CIb43/z7
         aBZw==
X-Forwarded-Encrypted: i=1; AJvYcCWdSuoOlb9Yhaw3F1IakF80PTeNAF3nP7wTM7t3oSPDjDF5NJHkbr7bn7OsJZ64hCbLY43ZdH2VkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YylWwD/AXB84pGKXy8SuuELxO410AN5KHPWUNZ92ze3+m3D8ZCV
	o6Hk2y95RvCiWRqyF33Q+xPoiDSlCEBZhTADhTfsPqZm7UGoPRY/cfBuSrZfAIf1ekuns3q1zv+
	jXjZ2eQjdj/u+J5p385E7HddT7wGabJnBMmveYg==
X-Gm-Gg: ASbGnct3wAn2DkI4MixOl5kjpfhwhal2mQ0dD6y0oHaUKS11WsaYzozJw6K26/XbI23
	JT5Lpi8P/1JHrGJlaNj5abHvHPk+l+weHA2TtvlYEiTdzf+rFHiAn/KTzjO49bubG6gHHZac=
X-Google-Smtp-Source: AGHT+IGv1A+woJLlJgl63xhuiKMFHTiUoQ/G0lh4kY82QXapUXwlp/DT66Lo83612m9rkYmfcT+rnuzNCLEgGSvUxoE=
X-Received: by 2002:a17:902:ea01:b0:20c:5da8:47b8 with SMTP id
 d9443c01a7336-220bbf3284amr30377295ad.5.1739397532283; Wed, 12 Feb 2025
 13:58:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk> <50caa50c-5126-4072-8cfc-33b83b524489@kernel.dk>
In-Reply-To: <50caa50c-5126-4072-8cfc-33b83b524489@kernel.dk>
From: Caleb Sander <csander@purestorage.com>
Date: Wed, 12 Feb 2025 13:58:41 -0800
X-Gm-Features: AWEUYZmI7u_8qzPpg7HXGKAXEj_umodoVjsh9_-byPg-wdS94gn-N9p1Mvu9XyA
Message-ID: <CADUfDZroLajE4sF6=oYopg=gNtv3Zko78ZcJv4eQ5SBxMxDOiw@mail.gmail.com>
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Riley Thomasson <riley@purestorage.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 1:02=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/12/25 1:55 PM, Jens Axboe wrote:
> > On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
> >> In our application issuing NVMe passthru commands, we have observed
> >> nvme_uring_cmd fields being corrupted between when userspace initializ=
es
> >> the io_uring SQE and when nvme_uring_cmd_io() processes it.
> >>
> >> We hypothesized that the uring_cmd's were executing asynchronously aft=
er
> >> the io_uring_enter() syscall returned, yet were still reading the SQE =
in
> >> the userspace-mapped SQ. Since io_uring_enter() had already incremente=
d
> >> the SQ head index, userspace reused the SQ slot for a new SQE once the
> >> SQ wrapped around to it.
> >>
> >> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
> >> index in userspace upon return from io_uring_enter(). By overwriting t=
he
> >> nvme_uring_cmd nsid field with a known garbage value, we were able to
> >> trigger the err message in nvme_validate_passthru_nsid(), which logged
> >> the garbage nsid value.
> >>
> >> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
> >> SQE copying until it's needed"). With this commit reverted, the poison=
ed
> >> values in the SQEs are no longer seen by nvme_uring_cmd_io().
> >>
> >> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
> >> to async_data at prep time. The commit moved this memcpy() to 2 cases
> >> when the request goes async:
> >> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
> >> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
> >>
> >> This patch set fixes a bug in the EAGAIN case where the uring_cmd's sq=
e
> >> pointer is not updated to point to async_data after the memcpy(),
> >> as it correctly is in the REQ_F_FORCE_ASYNC case.
> >>
> >> However, uring_cmd's can be issued async in other cases not enumerated
> >> by 5eff57fa9f3a, also leading to SQE corruption. These include request=
s
> >> besides the first in a linked chain, which are only issued once prior
> >> requests complete. Requests waiting for a drain to complete would also
> >> be initially issued async.
> >>
> >> While it's probably possible for io_uring_cmd_prep_setup() to check fo=
r
> >> each of these cases and avoid deferring the SQE memcpy(), we feel it
> >> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
> >> As discussed recently in regard to the ublk zero-copy patches[1], new
> >> async paths added in the future could break these delicate assumptions=
.
> >
> > I don't think it's particularly delicate - did you manage to catch the
> > case queueing a request for async execution where the sqe wasn't alread=
y
> > copied? I did take a quick look after our out-of-band conversation, and
> > the only missing bit I immediately spotted is using SQPOLL. But I don't
> > think you're using that, right? And in any case, lifetime of SQEs with
> > SQPOLL is the duration of the request anyway, so should not pose any
> > risk of overwriting SQEs. But I do think the code should copy for that
> > case too, just to avoid it being a harder-to-use thing than it should
> > be.
> >
> > The two patches here look good, I'll go ahead with those. That'll give
> > us a bit of time to figure out where this missing copy is.
>
> Can you try this on top of your 2 and see if you still hit anything odd?
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index bcfca18395c4..15a8a67f556e 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -177,10 +177,13 @@ static void io_uring_cmd_cache_sqes(struct io_kiocb=
 *req)
>         ioucmd->sqe =3D cache->sqes;
>  }
>
> +#define SQE_COPY_FLAGS (REQ_F_FORCE_ASYNC|REQ_F_LINK|REQ_F_HARDLINK|REQ_=
F_IO_DRAIN)

I believe this still misses the last request in a linked chain, which
won't have REQ_F_LINK/REQ_F_HARDLINK set?
IOSQE_IO_DRAIN also causes subsequent operations to be issued async;
is REQ_F_IO_DRAIN set on those operations too?

Thanks,
Caleb

> +
>  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>                                    const struct io_uring_sqe *sqe)
>  {
>         struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       struct io_ring_ctx *ctx =3D req->ctx;
>         struct io_uring_cmd_data *cache;
>
>         cache =3D io_uring_alloc_async_data(&req->ctx->uring_cache, req);
> @@ -190,7 +193,7 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *r=
eq,
>
>         ioucmd->sqe =3D sqe;
>         /* defer memcpy until we need it */
> -       if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
> +       if (unlikely(ctx->flags & IORING_SETUP_SQPOLL || req->flags & SQE=
_COPY_FLAGS))
>                 io_uring_cmd_cache_sqes(req);
>         return 0;
>  }
>
> --
> Jens Axboe

