Return-Path: <io-uring+bounces-9879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3CABA0FEB
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 20:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B1FE162A87
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 18:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C77F313D7F;
	Thu, 25 Sep 2025 18:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Zi/t0ed7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58697241663
	for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824495; cv=none; b=klF3fXKjyYdaHdeEGD5Vrm+ccOAuOAE3LJhRUtdfsnRFdDNUqQG572/2l8PePmp8QTnSiMfGb/XpwGPnnyC0Qc3q26q0cCQmA0oSftbEacOnn3LYxZA/jvFQlOI0uI34KwYS7EJUoZhehQ8ELnLuzGI25uW+dDzVz6l68/Xpt8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824495; c=relaxed/simple;
	bh=G3cBdCrcurNCh4sTQ3BhTrPy3NqDcFb+vxl3IVdDEFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2varRHIEirV3OFVFT75BNnFBSzxfPSqlTeQmObpjPtWpMMs/NqQX49wwA8ukyyrHbk+85AXfV2Gmm5takU8RCiGan9bq31byw/+cvY7zWr0LFixQWvaC6DoTgtH5opew1D34QSPTfHpulZdhHlSGle9hdsGJJDKUhGmUrX0AgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Zi/t0ed7; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33056307257so226787a91.3
        for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 11:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1758824493; x=1759429293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToHIABg5OcU57ynCYucgb3xpiBWcPw/LLqRXIbTXbqQ=;
        b=Zi/t0ed78XElNW8n7Ax8pjUfp+S1fILfyeV1HrpzArNK4a2F35I47wKekrfDdljFdr
         oiw0WmPFm0HnF/ukENult61CHv8Fqz808fnFMsQX5GZVwIq1ekYeTqDR75CCQNZ6k6HI
         oopHVP6qxZD9D7N0VEhlrFge32yoW7Lu0VdPybT0vCLlBKOLke4c9q6EKfgQwiWTS3uQ
         j7ezFiVFZPzhHpQwUKjIw4QRzm4wkDoUGqQr6MYKnf0eK2Irh8QE1EC+FDu4lTp8vgfv
         uaCeTOd+ZTKz8ZceYtpKneG7O7tqQqO6fvuXgJH1RcBk2ANE1EkAyhbTW7dB6OHyYvzC
         LncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758824493; x=1759429293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToHIABg5OcU57ynCYucgb3xpiBWcPw/LLqRXIbTXbqQ=;
        b=Cl2iY9yCOPZ8AlJ6DX6uTiHlWZnmUvrOHuD3woTR8qQHmMIw2e6SBxWYh0A4zPAzLy
         uAN1Rogj4eKSiRWzKh0M0+8D+lLMiD1RT9+rT9/M6cFbFc5X1L4HtUF9RdQp9kE7MoTu
         WiYNRZyz/KiV7MVVd0yoqcjDi9/pRQ7pN6RiBoeKOefL4Cc+bp47rCCgffshL+7xn+3/
         7GySjbOjHSF13NY4NR45aGXCBw4+4NLvkdk11cH1+05ki2RlCa0TtuK3m6CR2gswaVPc
         ucG1PtW7aKi76fbUxiE3dkNj+T/PlBzYgdPYg5GJZkJ9z9brDrSjO866wRmCZqURQsh1
         mw/g==
X-Forwarded-Encrypted: i=1; AJvYcCUa/GlVn65yXTwV3rWD0ve6UT/0BNtEWnXQKp/smlCnBbQfotdflY0TSn1Yh6cUDZaTVabubVJPog==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoK3VjBCx6D3ozMrjIbaMxXDu6YEXYuuT5QMBC2XruMW3igg1E
	3ECHEZsAEj03tcuN1ptxiwvtLNtwmIOU/H9J2iZxiD3mCPLKURSeLpI5KQ55lYz2DmmJgdbOvTR
	Q0U62t+VM+OG7nhnrHMTtj3A8nW2fGmprxenkkQYfqA==
X-Gm-Gg: ASbGnctxPTzwYGQi1I8zKI5rlOXv1wo+/su3colPPC+Hk0xRk5M18UX5AfgYvFP97kX
	aGoER+3ppGcp0TVoWUeM+U0qULuUP3ERNzloWueD9ZYo8qNBxD2jtWMUumxgGRk8SBuMK+wIyCW
	JgoM6sUizVu06K/TByFAhOHMQFAvPvQGxtkyQzPzvQkAnG8AN/2WfDL0DwbCLRtFZ5sEKYx5fou
	ENJQ+NPS2NhAO54avbwqFIxXlR59PYqEzjFpr0=
X-Google-Smtp-Source: AGHT+IFEayEXvNAknVO5MmEBxPKJGzLhRN2Zo4XUttLW/6xHLr3Kk+9sdnNIteOQZ/a2eI08J+LfpYef8dXdiHyGuuQ=
X-Received: by 2002:a17:90b:1b0c:b0:32e:64ca:e851 with SMTP id
 98e67ed59e1d1-3342a14957dmr2481219a91.0.1758824492602; Thu, 25 Sep 2025
 11:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924151210.619099-1-kbusch@meta.com> <20250924151210.619099-3-kbusch@meta.com>
 <f5493b8a-634c-4fba-8fa4-a83c98f501d3@kernel.dk>
In-Reply-To: <f5493b8a-634c-4fba-8fa4-a83c98f501d3@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 25 Sep 2025 11:21:21 -0700
X-Gm-Features: AS18NWCmsm-qKqmYeH3ZxdISwgceb7SAO6R-TxBIpRmef39fOUoOu5E-QmmTgYI
Message-ID: <CADUfDZpL2r2nhVDGZF07pDwNw-agxogo3hz2VDvJNvZK+h_Uug@mail.gmail.com>
Subject: Re: [PATCHv3 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org, ming.lei@redhat.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 8:03=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/24/25 9:12 AM, Keith Busch wrote:
> > contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
> > case, a single NOP SQE should be posted with the SKIP_SUCCESS flag set.
> > The kernel should simply ignore those.
>
> I think this mirrors the CQE side too much - the kernel doesn't ignore
> then, they get processed just like any other NOP that has SKIP_SUCCESS
> set. They don't post a CQE, but that's not because they are ignored,
> that's just the nature of a successful NOP w/SKIP_SUCCESS set.
>
> > @@ -2179,6 +2179,14 @@ static int io_init_req(struct io_ring_ctx *ctx, =
struct io_kiocb *req,
> >       opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
> >
> >       def =3D &io_issue_defs[opcode];
> > +     if (def->is_128) {
> > +             if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 |=
|
> > +                 (ctx->cached_sq_head & (ctx->sq_entries - 1)) =3D=3D =
0)
> > +                     return io_init_fail_req(req, -EINVAL);
> > +             ctx->cached_sq_head++;
> > +             (*left)--;
> > +     }
>
> This could do with a comment!
>
> > @@ -582,9 +583,10 @@ static inline void io_req_queue_tw_complete(struct=
 io_kiocb *req, s32 res)
> >   * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for=
 each
> >   * slot.
> >   */
> > -static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
> > +static inline size_t uring_sqe_size(struct io_kiocb *req)
> >  {
> > -     if (ctx->flags & IORING_SETUP_SQE128)
> > +     if (req->ctx->flags & IORING_SETUP_SQE128 ||
> > +         req->opcode =3D=3D IORING_OP_URING_CMD128)
> >               return 2 * sizeof(struct io_uring_sqe);
> >       return sizeof(struct io_uring_sqe);
>
> This one really confused me, but then I grep'ed, and it's uring_cmd
> specific. Should probably move this one to uring_cmd.c rather than have
> it elsewhere.
>
> > +int io_uring_cmd128_prep(struct io_kiocb *req, const struct io_uring_s=
qe *sqe)
> > +{
> > +     if (!(req->ctx->flags & IORING_SETUP_SQE_MIXED))
> > +             return -EINVAL;
> > +     return io_uring_cmd_prep(req, sqe);
> > +}
>
> Why isn't this just allowed for SQE128 as well? There should be no
> reason to disallow explicitly 128b sqe commands in SQE128 mode, they
> should work for any mode that supports 128b SQEs which is either
> SQE_MIXED or SQE128?

Not to mention, the check in io_init_req() should already have
rejected a 128-byte operation on a non-IORING_SETUP_SQE_MIXED
io_ring_ctx.

Best,
Caleb

