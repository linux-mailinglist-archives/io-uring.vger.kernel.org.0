Return-Path: <io-uring+bounces-6392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 336F1A332E3
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6C43A5B0C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CBB20AF66;
	Wed, 12 Feb 2025 22:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GFCZsfey"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDA1EF08E
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 22:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739400750; cv=none; b=AhKvs/CJQaB186J+Oucm1V93YA8OOtSs8VdtYkAigWRrOrCsGjEa4pVbmXjdhl16Z0SIaw2J3oyM/plQOh7UhiakgO3iMPNmymlf3D5Gqbql9GuQx+gepAVgzl9+Ph08nDbANIafJ93ThAo9PufvWJjcYOzCQVgf+7U1G6ctR2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739400750; c=relaxed/simple;
	bh=UtfN+GCGG125PSq00oIuJfcUPsgtgStzpiCDq0MDYUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aL3btHrDKxmZtjTNE2a+zZT9TKUn8YS+nYI3vJ3bIjpT7WpLIjUFsGWQoFFygSpTYoO72U4JlxHSK+Z7gs8WctptW8GoM68q67SuwrInygvhKH4+kYDnQTNbBmF+6yulPzTknD2k+tFUftXa0QBjqxdUliXImZVonEv8vlCzQTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GFCZsfey; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-220d47b035fso216855ad.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739400747; x=1740005547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfwY93M55tUY7tiuafz/+lMvgbNBwGKfC4CdSZeSjms=;
        b=GFCZsfey3LQIWyaxd/lzQ9LF9ptniBjwqPv3lIMv7nH0nOFD4cA+2DhjMtT/LGOWBf
         KMMJ58tjGApbIwZc/5n/3dbXTGsmoyjsrYYEecYqpF6aFKMts/sCdy1gyZxAkq9Q9b+T
         WcZ/qYWHa3Vc2l+c+NFcZQ6d2oeU+HviK1wIiDy8DoZdjdRIkOUeKv+YrTLEkX8Bwc9Y
         auTepwLRD3Ze0e0mGbDhzeVXTgG6wQXLsVS9sK3pwpTsIcd/l1ge9H+UOUEvmMBpoBrD
         N0vu6MWJ/FfkHSzGjavvXKjcm3j6E6879xhPntkv+pYooa9pahGk9SlhekT0lS7iaxWg
         B8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739400747; x=1740005547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfwY93M55tUY7tiuafz/+lMvgbNBwGKfC4CdSZeSjms=;
        b=C5yAzAq5Yfhggtwk8g+wyqtFq0UlnrYLFLKaKoBL3I1c6Kyau3s40R0S1nZRNnBMv4
         3hHV1UcZuAIb6iX38WDJoZhPmKeoRBnUMMX0bcxg2tSY4dpxJplOHO2OlG7JhNYxwqTH
         YmNjiS903iV+bLDJz39Q/BJT+S8W4rOb/RgezrfgUKZOHwmcxk5X6QFI2H49r60mRd2q
         mB/BhjFFod39eNklnz9cd54m5kj00xvf4ShLubujNc6wwMAphIuCqhfmLCrWO8a7tErC
         iaunnNjkPrYSL8Q0wlvRtJj9MvSM2JubU3s8IDON89v1YFMIBeX8xuq+oiNNMZ7bzR0Y
         5uTw==
X-Forwarded-Encrypted: i=1; AJvYcCUZbLH4Py0UKcGmpvXXoBina4uMmukw81Qncb+aWLuTgWUO+SG8IxEZGAaVCpv+DlL3JJuM0b8Bfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRKKi6bq1kYzX6DQTkfYhfBE9DkzE4vZhmK2W8iW3tHh4WCT2g
	TYUIsGrD2e0eTp2TD0WkDAnnwLh6w+5cjLIyyqwl6W8xocNsQFYj7CwMOijX9J/TTleCvVygzbg
	W+df3KyJTyjhwbCaxeykwCyn6oj1nSFx8P60vSg==
X-Gm-Gg: ASbGncvJbfUDi1yM1EaY1YIi4MITCEpCz2EzP+RDy74XoKII8obfOwPWbhwGippYqw4
	rWv2K8j18hPlQC1zfGkRux105vLFrd3EyfKqe/UEIa9FKsQf54Ezln99V4kqAzN4rxGkRFyE=
X-Google-Smtp-Source: AGHT+IFtPx5mTyb/IuiGEIVxkvQ2pczO0DwFJngfOpyn2fty5YXDGA+Xdc9rjdurFCXleGpKfOEjBIeAqEBMrnf2lcQ=
X-Received: by 2002:a17:903:2f8a:b0:215:9a73:6c4f with SMTP id
 d9443c01a7336-220bbacbfcamr29770925ad.6.1739400746708; Wed, 12 Feb 2025
 14:52:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk> <50caa50c-5126-4072-8cfc-33b83b524489@kernel.dk>
 <CADUfDZroLajE4sF6=oYopg=gNtv3Zko78ZcJv4eQ5SBxMxDOiw@mail.gmail.com> <e315e4f5-a3f0-48be-8400-05bfaf8714f8@kernel.dk>
In-Reply-To: <e315e4f5-a3f0-48be-8400-05bfaf8714f8@kernel.dk>
From: Caleb Sander <csander@purestorage.com>
Date: Wed, 12 Feb 2025 14:52:14 -0800
X-Gm-Features: AWEUYZn_dOyE6MdpmE0S0s6r4x5ROWMgWV_7dG45zZiiWa6VI79ZFLHKZuOeHGg
Message-ID: <CADUfDZp5w_LuXn9suUnqNr5ePdvrUP1-f5UN3B_iVTtUn2kFbg@mail.gmail.com>
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Riley Thomasson <riley@purestorage.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 2:34=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/12/25 2:58 PM, Caleb Sander wrote:
> > On Wed, Feb 12, 2025 at 1:02?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/12/25 1:55 PM, Jens Axboe wrote:
> >>> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
> >>>> In our application issuing NVMe passthru commands, we have observed
> >>>> nvme_uring_cmd fields being corrupted between when userspace initial=
izes
> >>>> the io_uring SQE and when nvme_uring_cmd_io() processes it.
> >>>>
> >>>> We hypothesized that the uring_cmd's were executing asynchronously a=
fter
> >>>> the io_uring_enter() syscall returned, yet were still reading the SQ=
E in
> >>>> the userspace-mapped SQ. Since io_uring_enter() had already incremen=
ted
> >>>> the SQ head index, userspace reused the SQ slot for a new SQE once t=
he
> >>>> SQ wrapped around to it.
> >>>>
> >>>> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ he=
ad
> >>>> index in userspace upon return from io_uring_enter(). By overwriting=
 the
> >>>> nvme_uring_cmd nsid field with a known garbage value, we were able t=
o
> >>>> trigger the err message in nvme_validate_passthru_nsid(), which logg=
ed
> >>>> the garbage nsid value.
> >>>>
> >>>> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: def=
er
> >>>> SQE copying until it's needed"). With this commit reverted, the pois=
oned
> >>>> values in the SQEs are no longer seen by nvme_uring_cmd_io().
> >>>>
> >>>> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()=
ed
> >>>> to async_data at prep time. The commit moved this memcpy() to 2 case=
s
> >>>> when the request goes async:
> >>>> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
> >>>> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
> >>>>
> >>>> This patch set fixes a bug in the EAGAIN case where the uring_cmd's =
sqe
> >>>> pointer is not updated to point to async_data after the memcpy(),
> >>>> as it correctly is in the REQ_F_FORCE_ASYNC case.
> >>>>
> >>>> However, uring_cmd's can be issued async in other cases not enumerat=
ed
> >>>> by 5eff57fa9f3a, also leading to SQE corruption. These include reque=
sts
> >>>> besides the first in a linked chain, which are only issued once prio=
r
> >>>> requests complete. Requests waiting for a drain to complete would al=
so
> >>>> be initially issued async.
> >>>>
> >>>> While it's probably possible for io_uring_cmd_prep_setup() to check =
for
> >>>> each of these cases and avoid deferring the SQE memcpy(), we feel it
> >>>> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
> >>>> As discussed recently in regard to the ublk zero-copy patches[1], ne=
w
> >>>> async paths added in the future could break these delicate assumptio=
ns.
> >>>
> >>> I don't think it's particularly delicate - did you manage to catch th=
e
> >>> case queueing a request for async execution where the sqe wasn't alre=
ady
> >>> copied? I did take a quick look after our out-of-band conversation, a=
nd
> >>> the only missing bit I immediately spotted is using SQPOLL. But I don=
't
> >>> think you're using that, right? And in any case, lifetime of SQEs wit=
h
> >>> SQPOLL is the duration of the request anyway, so should not pose any
> >>> risk of overwriting SQEs. But I do think the code should copy for tha=
t
> >>> case too, just to avoid it being a harder-to-use thing than it should
> >>> be.
> >>>
> >>> The two patches here look good, I'll go ahead with those. That'll giv=
e
> >>> us a bit of time to figure out where this missing copy is.
> >>
> >> Can you try this on top of your 2 and see if you still hit anything od=
d?
> >>
> >> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >> index bcfca18395c4..15a8a67f556e 100644
> >> --- a/io_uring/uring_cmd.c
> >> +++ b/io_uring/uring_cmd.c
> >> @@ -177,10 +177,13 @@ static void io_uring_cmd_cache_sqes(struct io_ki=
ocb *req)
> >>         ioucmd->sqe =3D cache->sqes;
> >>  }
> >>
> >> +#define SQE_COPY_FLAGS (REQ_F_FORCE_ASYNC|REQ_F_LINK|REQ_F_HARDLINK|R=
EQ_F_IO_DRAIN)
> >
> > I believe this still misses the last request in a linked chain, which
> > won't have REQ_F_LINK/REQ_F_HARDLINK set?
>
> Yeah good point, I think we should just be looking at link->head instead
> to see if the request is a link, or part of a linked submission. That
> may overshoot a bit, but that should be fine - it'll be a false
> positive. Alternatively, we can still check link flags and compare with
> link->last instead...

Yeah, checking link.head sounds good to me. I don't think it should
catch any extra requests. link.head will still be NULL when ->prep()
is called on the first request of the chain, since it is set in
io_submit_sqe() after io_init_req() (which calls ->prep()).

>
> But the whole thing still feels a bit iffy. The whole uring_cmd setup
> with an SQE that's sometimes the actual SQE, and sometimes a copy when
> needed, does not fill me with joy.
>
> > IOSQE_IO_DRAIN also causes subsequent operations to be issued async;
> > is REQ_F_IO_DRAIN set on those operations too?
>
> The first 8 flags are directly set in the io_kiocb at init time. So if
> IOSQE_IO_DRAIN is set, then REQ_F_IO_DRAIN will be set as they are one
> and the same.

Sorry, I meant that a request marked IOSQE_IO_DRAIN/REQ_F_IO_DRAIN
potentially causes both that request and any following requests to be
submitted async. The first request waits for any outstanding requests
to complete, and the following requests wait for the request marked
IOSQE_IO_DRAIN to complete. I know REQ_F_IO_DRAIN =3D IOSQE_IO_DRAIN is
already set on the first request, but will it also be set on any
following requests that have to wait on that one?

>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index bcfca18395c4..9e60b5bb5a60 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -177,10 +177,14 @@ static void io_uring_cmd_cache_sqes(struct io_kiocb=
 *req)
>         ioucmd->sqe =3D cache->sqes;
>  }
>
> +#define SQE_COPY_FLAGS (REQ_F_FORCE_ASYNC|REQ_F_IO_DRAIN)
> +
>  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>                                    const struct io_uring_sqe *sqe)
>  {
>         struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_submit_link *link =3D &ctx->submit_state.link;
>         struct io_uring_cmd_data *cache;
>
>         cache =3D io_uring_alloc_async_data(&req->ctx->uring_cache, req);
> @@ -190,7 +194,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *r=
eq,
>
>         ioucmd->sqe =3D sqe;
>         /* defer memcpy until we need it */
> -       if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
> +       if (unlikely(ctx->flags & IORING_SETUP_SQPOLL ||
> +                    req->flags & SQE_COPY_FLAGS || link->head))
>                 io_uring_cmd_cache_sqes(req);
>         return 0;
>  }
>
> --
> Jens Axboe

