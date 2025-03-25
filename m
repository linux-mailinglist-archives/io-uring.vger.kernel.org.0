Return-Path: <io-uring+bounces-7239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE45AA70402
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 15:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F47B3A8C1F
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681EC25A34E;
	Tue, 25 Mar 2025 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Xdasmq6k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1A253F0E
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742913559; cv=none; b=dNTCV60CDzoIWH4EYAk/KDXnSjcamuisQPl7BaidMffslqM+611CKPaJf0JK3dMeSHkd2M5vyp4uhHvpbPA73toW+mCmT8CswVpx0LMRKDrFErowCO59ByVEQ+aK3I2mOSEz6hM7utN1ZPRgz3/zT6Q7oDFoPCPXNmeCgvyLbWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742913559; c=relaxed/simple;
	bh=93eWenbFX4Qctz6lS+ZM7ptfCzMUV8wfEb7lTyzGPMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YV0PcrNN/SRa7VMRHmY0eouY6VG78OjFw0qslPKcIr+55v19uJoUDIO3GArsCUee99d4Tlm7iQuy9kxduvJF7TrE4oxylo50EAlAJHoO74hEhPUtgGTUe8+IhhaOiu10CQK11al0/IZBUYsFYDz1WFfsZDkqKMTQy1EKYbzhzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Xdasmq6k; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff73032ac0so1560595a91.3
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742913556; x=1743518356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5+emjeFfRDf3d8vzGiMI59WxZfGi88bAPj4rxcKWnI=;
        b=Xdasmq6kbva6eSwW0l1wHu71yw6sMqRKaj/k4RILNQo0sLM9Wjt9oU+PUiZVMv+QUE
         F5qVIBXjD04qnte1zLTx3OWp1ydUV0ZEHuJHs8VlvvEd2iWHYAV199g3AhymN7piHR5d
         K6rRQdZaCYD7IUqinp/6pOcAX6QIuTUUH0OmjuNChUvPr4OyhUIp8l4ZdVQ2lGhkoVRT
         hOfxWKsUBw7Jx2MYyMp5AI2z+xuUBFiaH7aBXZnV4GddMCIzELgmdiWKWAz1Qm7gmEB7
         5rEt8G/AZHEroh997xoCv6LbkBxaXhJjAIAsIUHCLjQt/7pHJUAbHB0vvHNOod45a9+0
         ox+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742913556; x=1743518356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5+emjeFfRDf3d8vzGiMI59WxZfGi88bAPj4rxcKWnI=;
        b=qsMkJlUauhN6eZ7iOrnIVOZAGfhfFIREtzKjXj/n4Wy2O/Z/srlJHgNuYI6RwD9/Ho
         qQYHf/uY8KZUUKXIztSvurzD90Njn828luGmjleqWovCfjHOr+3l6cJxeuc1Gi1ZRK/X
         FSG0xUoQTBXkg/3mGCwJ4BEIngaRR8nxfRiR6CgTduILqkiimKtPwadb2+yx9j2XDty9
         WiqmChjo3pAFcgCorGVLw2qZoYzoSTCjlNoSSdCTSgE23rms3UOfz29NEDBCTSO9PsUX
         01rWEIgmkLOwLGr6SOLtvm9t6vr60xEIiwCdC2ofvSu3B/6w3NrF7BAdPNrTi4xjbrJC
         mCmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD6KCxFIeCzg0vSr2/onCQSiikJlqIhnb203wQxeuB9CZjkBoR9sxz8fqdEKyANGOK+TzGyyK0MQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4y4vM/NLv27W65T95NEtcpXjaYBSLlE0E7kuIwIbWPedhBAn/
	JV6YniKFFXpD/+XN6tR5yujd95Ql6g/uBs77zSgVo+eY1NTfe7+1K53fXE/kI8wgMFTvHpfMu7P
	HUI/bcMetN2i3AhamZ2SInGJ462pJqMMQoxogfbQdCRNgb8fzNvw=
X-Gm-Gg: ASbGncuCqU/nkBGRdXGnNo5MfckG7WjY/gNy6DbXOB3ZtQMktbl4lVGzxKFghaaecwj
	N+T1LpBR/Rbu9ivSVaYEzPRmFVNyMR6aJL2XisOuAWoejJ9pR+1ptbRyBzmIRG7OkT4goxvI8b8
	NqB9NnMpkozMWPKjbvjK1RMpDz
X-Google-Smtp-Source: AGHT+IELDUGTHhhfY6IuAt3IGxep+aF++UUFDx9mIkxkIg5Rky6VYHfF/K2vYvRLeDpg3qkuJHKzbYSL5b1iC44oGPc=
X-Received: by 2002:a17:90b:1b52:b0:2fe:a747:935a with SMTP id
 98e67ed59e1d1-3030fef1da3mr10236262a91.4.1742913555742; Tue, 25 Mar 2025
 07:39:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250324151123.726124-1-csander@purestorage.com> <8b22d0df-f0ea-4667-b161-0ca42f03a232@gmail.com>
In-Reply-To: <8b22d0df-f0ea-4667-b161-0ca42f03a232@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 25 Mar 2025 07:39:04 -0700
X-Gm-Features: AQ5f1JrNvLHl-Bc07IZmeCK7EzYr-z2R9_YgkneyPMAWniWHWnNox-4XX-GkLxQ
Message-ID: <CADUfDZocNe0jm1n3WxO+hHqVcQcgj5PtA4h+S3EsiB0D=-m+dA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 6:30=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/24/25 15:11, Caleb Sander Mateos wrote:
> > Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
> > track whether io_send_zc() has already imported the buffer. This flag
> > already serves a similar purpose for sendmsg_zc and {read,write}v_fixed=
.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >   include/linux/io_uring_types.h | 5 ++++-
> >   io_uring/net.c                 | 8 +++-----
> >   2 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_ty=
pes.h
> > index c17d2eedf478..699e2c0895ae 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -583,11 +583,14 @@ enum {
> >       REQ_F_BUFFERS_COMMIT    =3D IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT)=
,
> >       /* buf node is valid */
> >       REQ_F_BUF_NODE          =3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
> >       /* request has read/write metadata assigned */
> >       REQ_F_HAS_METADATA      =3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
> > -     /* resolve padded iovec to registered buffers */
> > +     /*
> > +      * For vectored fixed buffers, resolve iovec to registered buffer=
s.
> > +      * For SEND_ZC, whether to import buffers (i.e. the first issue).
> > +      */
> >       REQ_F_IMPORT_BUFFER     =3D IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
> >   };
> >
> >   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t =
tw);
> >
> > diff --git a/io_uring/net.c b/io_uring/net.c
> > index c87af980b98e..b221abe2600e 100644
> > --- a/io_uring/net.c
> > +++ b/io_uring/net.c
> > @@ -75,11 +75,10 @@ struct io_sr_msg {
> >       unsigned                        nr_multishot_loops;
> >       u16                             flags;
> >       /* initialised and used only by !msg send variants */
> >       u16                             buf_group;
> >       bool                            retry;
> > -     bool                            imported; /* only for io_send_zc =
*/
> >       void __user                     *msg_control;
> >       /* used only for send zerocopy */
> >       struct io_kiocb                 *notif;
> >   };
> >
> > @@ -1305,12 +1304,11 @@ int io_send_zc_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
> >       struct io_ring_ctx *ctx =3D req->ctx;
> >       struct io_kiocb *notif;
> >
> >       zc->done_io =3D 0;
> >       zc->retry =3D false;
> > -     zc->imported =3D false;
> > -     req->flags |=3D REQ_F_POLL_NO_LAZY;
> > +     req->flags |=3D REQ_F_POLL_NO_LAZY | REQ_F_IMPORT_BUFFER;
>
> This function is shared with sendmsg_zc, so if we set it here,
> it'll trigger io_import_reg_vec() in io_sendmsg_zc() even for
> non register buffer request.

Good catch. I keep forgetting which prep and issue functions are
shared between which opcodes.

Thanks,
Caleb

