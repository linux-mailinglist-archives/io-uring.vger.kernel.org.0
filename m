Return-Path: <io-uring+bounces-7767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A85A9FE90
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C32C0189B2E3
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62C78F64;
	Tue, 29 Apr 2025 00:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QBqIKU9q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F31C6B4
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887614; cv=none; b=k3ur7SNBfmFuu5S0obgqW4b6n7qoN0APunoMfKmzUzX4qf3InFC9+tKmLawoRpjKi34KqlynK3/Vz+f8bI+dUJ1aPf0ge1+ZALgp2TpIofTTbFRRoUpGWL9DjwqFbg3PonVwHNigXVe058h9XchBkWJUQNzooomv+dc2uH81m7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887614; c=relaxed/simple;
	bh=BHA2GIv8byWhRxuYLEq7/vxb/WhxGKfdBrv3oUlyzqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ig/dxr2Pqo36+QcgYxN1eXmFNz7yzfeXiDgZdmCuxxX3yOKrdVZv4AkQBQd+M1aZHsIt3bGrcjzpbmkp6rSk8nTxv1StaYXnXbu+s+d7HFnuMTVhhTv5PC/WqWHawTEHwcwmLLdZGlgTAcfGPoKjimOOxkNt157f7OnHEp1MczI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QBqIKU9q; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-227e29b6c55so10301325ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745887612; x=1746492412; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/LZEG8VPkE+s9gfU09X0F9Gfwdyos92zSrtOsAgUPU=;
        b=QBqIKU9qrKSj+pCpifd+hFCAsHPnumXdUnCYTlN+GwsWPqRPmylcaErh33nYHH2/Bt
         1Ns4Kkp3A6JTAMqnxt7Lz15TEnjNOTfFdFljBs+CRCciYqrQ4RkCPmK9Pz1F2Xs9Ut9q
         Xr7mU8LRT455Zs490FhESkBnymf0WQEtB3t5xO+ljB6urSGQkbvZhmM7nZ2YqpE+a2t8
         Gz3s1QWcS6icOIQu9eLLmAKLipWgZWFxRN+BxX3DkTUATZEa/W7vmgZYL6YVMknbx2Sp
         4gxgvfZM9ElhmGua03R5K5VEtJtNVONF8gmsTpdLjXnDSquRE+LVOPU328N+Aa17ecau
         IQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745887612; x=1746492412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/LZEG8VPkE+s9gfU09X0F9Gfwdyos92zSrtOsAgUPU=;
        b=u5+3aLk0NmG2QSkFF+zqiqJDy+gjMTNZuAB9gnRAZY0ujuwG6Eo3o35esjFOPwL3sL
         q/MwGP746ZiEIWmmlUHRVx5tjMX7GuzFGFKgi3kQDU3whIyoExCQ2Ma6tCA0/u/idC1F
         udi7iXhwCkdNzd16UhTHQitsz1U9fIMKWvVDeqnX9yEQmgV/jG6022PedHGVXQyvJBS2
         Wxr32qCJ9/yLfm+smjfW97T+SDwAKgg3aRwhkFnBd+Y/I+C2YvXu5/85rTpq+TBM60fi
         BtDHMwlgy2GQ0JKSpBu7zKyi82j/5DWdmkgXiXHHN6XyxA9OCJW91l0ux3HiCXSjgtYg
         Ig4w==
X-Forwarded-Encrypted: i=1; AJvYcCWDwAqlqA4bW2478DnDTq4Nq1Lfk+pYk3nxUXm/b+ibYnposOjGu8/jjU4FQ6n3Jg/Soscdu35Ofw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFUh27Q8S6uhpIGAqQXkgHNkIQzEUFJUQ3u8qmiTTRPB8iIOhQ
	WST7LPwHouSyZ2ttyIaMRpc5OGfmZkM94TcwAtuZVrUiUqzMwqiR0VfUFJZxL1G1pbVZhsurdKw
	ZodNQZm0hjLoP1ZjTaevIIncZD5vzZ6dxYgC6dyIxEJz5H4oxJu4=
X-Gm-Gg: ASbGncuDPo+L21IVsW1DAlO/VxDTPyLBfZ7h8zj4UtBy/2L30JtbS3Qsfa+X9JxE4UW
	pxzDzKgHN+dx5+tWrh0Q5FjNOGieIY+lBIehkOt3ec6p5KFbRDqscECP4Fc3Ubr2vkiNFay51BL
	HOLLhAHxAFaoHjRdjaKsCx
X-Google-Smtp-Source: AGHT+IEdIlC46fHH0uBZ4ZC4b6A/mHEoygMskLDJghXQ+KOu2C3SO+R9VlQzMAg90lg9KAFzStdmR5W/xX7hWQl87cw=
X-Received: by 2002:a17:902:f608:b0:224:13a2:ab9a with SMTP id
 d9443c01a7336-22de6ea71f0mr6248295ad.7.1745887611738; Mon, 28 Apr 2025
 17:46:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-4-ming.lei@redhat.com>
 <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
In-Reply-To: <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:46:40 -0700
X-Gm-Features: ATxdqUHr72PcXYKOrWKmkES5_wiw-qKrX9vb52IL7rmmEXKIvIgrtAihuMk2aos
Message-ID: <CADUfDZoukKYc2M--UysLkGq1TnX_brJiNYPM-sGq3iG-nys_6w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 3:27=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 4/28/25 10:44, Ming Lei wrote:
> > Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> > supporting to register/unregister bvec buffer to specified io_uring,
> > which FD is usually passed from userspace.
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring/cmd.h |  4 ++
> >   io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++--------=
-
> >   2 files changed, 67 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 78fa336a284b..7516fe5cd606 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
> ...
> >       io_ring_submit_lock(ctx, issue_flags);
> > -     ret =3D __io_buffer_unregister_bvec(ctx, buf);
> > +     if (reg)
> > +             ret =3D __io_buffer_register_bvec(ctx, buf);
> > +     else
> > +             ret =3D __io_buffer_unregister_bvec(ctx, buf);
> >       io_ring_submit_unlock(ctx, issue_flags);
> >
> >       return ret;
> >   }
> > +
> > +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> > +                                 struct io_buf_data *buf,
> > +                                 unsigned int issue_flags,
> > +                                 bool reg)
> > +{
> > +     struct io_ring_ctx *remote_ctx =3D ctx;
> > +     struct file *file =3D NULL;
> > +     int ret;
> > +
> > +     if (buf->has_fd) {
> > +             file =3D io_uring_register_get_file(buf->ring_fd, buf->re=
gistered_fd);
>
> io_uring_register_get_file() accesses task private data and the request
> doesn't control from which task it's executed. IOW, you can't use the
> helper here. It can be iowq or sqpoll, but either way nothing is
> promised.

The later patches only call it from task_work on the task that
submitted the ublk fetch request, so it should work. But I agree it's
a very subtle requirement that may be difficult to ensure for other
callers added in the future.

Best,
Caleb

>
> > +             if (IS_ERR(file))
> > +                     return PTR_ERR(file);
> > +             remote_ctx =3D file->private_data;
> > +             if (!remote_ctx)
> > +                     return -EINVAL;
>
> nit: this check is not needed.
>
> > +     }
> > +
> > +     if (remote_ctx =3D=3D ctx) {
> > +             do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> > +     } else {
> > +             if (!(issue_flags & IO_URING_F_UNLOCKED))
> > +                     mutex_unlock(&ctx->uring_lock);
>
> We shouldn't be dropping the lock in random helpers, for example
> it'd be pretty nasty suspending a submission loop with a submission
> from another task.
>
> You can try lock first, if fails it'll need a fresh context via
> iowq to be task-work'ed into the ring. see msg_ring.c for how
> it's done for files.
>
> > +
> > +             do_reg_unreg_bvec(remote_ctx, buf, IO_URING_F_UNLOCKED, r=
eg);
> > +
> > +             if (!(issue_flags & IO_URING_F_UNLOCKED))
> > +                     mutex_lock(&ctx->uring_lock);
> > +     }
> > +
> > +     if (file)
> > +             fput(file);
> > +
> > +     return ret;
> > +}
> --
> Pavel Begunkov
>

