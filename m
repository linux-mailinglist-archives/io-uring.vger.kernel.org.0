Return-Path: <io-uring+bounces-11323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0366CE8789
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 02:15:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 808333008F81
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 01:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5C42E40E;
	Tue, 30 Dec 2025 01:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cj2UoJnJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0684A07
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767057355; cv=none; b=rYWZby99dKaqH3Wom2G5NzwFRrp8tSmDnxuyDb6ayWzTF1xuOCDJmJ53Ieo3DjM0lPzFjDDhKmWDplGLGRlTGe8tIusnKujX+ICgLj4pDoOKNeM8SmMFiDEyM6rH1ZFI21FXgozE6iJ6mGZcW2kqGqv96WUHlIrt1i+qoXMdoes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767057355; c=relaxed/simple;
	bh=Vzw8jfIg0fsnLhS5wngONOQ1kAaNK7F9dTzgwFkGWkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUEoEr/6Ob+79zmY2LPLAosVb6JVTEu70tWnyIMY/jkIsQgVNCdZddCPc8GcLdW+eMOgvQXG+1JQHqsfd29I2xh05gHVo4xbPF1v6o1nl9N8FjFcMa85DjZDdHp7FO4fJn0uD14PD1wqNqo4oJlw7TkT+OKyNeLIFeqhX5Y6Sp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cj2UoJnJ; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso105506581cf.1
        for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 17:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767057353; x=1767662153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQAOVvaZ/5Ofkknh4WYK6hRoniD41tWjmaMq0giQtvY=;
        b=cj2UoJnJmTW5dS7g65dxJ1KQfSX6qV/tLXiTnDkfYySNptjY6bNJ0QvTZtc2GF3I6Q
         crkN3lLZaoSwhJZPoo9gF3lZc+62KZT7li8x7meMczlLUh+dkxLGE0fHGKa1/3bDaIVa
         GCJ0NGdP7i1IKgEwo0vWMrBmXbLsf/B9HO6pnM6nJrFADWOU2QnaqMU1a5R9xH1A/VYl
         lw0vnyz6hFsRs9SjH3bsFmWMNPxrS6/2FoIH5hCJzuZJoDtCsVvPdOVxthQU6JC3ubPT
         2yT+co99ApD1/s8EkNLHK5kFfJufJ0EWPxxqaErr5K4AJbecCs07FYcuAnmuQIVvKvqU
         IXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767057353; x=1767662153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQAOVvaZ/5Ofkknh4WYK6hRoniD41tWjmaMq0giQtvY=;
        b=J5YXQvDTYnWZ6JOqNdPIWY6q9V9acIT2HlCTQFbv8+Rq08XFaVGeotXXYKvyLdIvAF
         uDPEfdYa6gV241tdBS2tcV3OU3UOkfsu05XJddYosjevWIbl7r1zm4qMz3G/qExGuwcH
         zp/BRMOkGfhxFARfssZd4FkXGsZCfekXTtKFONF5wiwxjZr6r7NaY+X1/2FZo8xdBgcT
         EH73qqF0u9y1lcyUVQdxi7ym0ZBSyUoQYjSlAn/sSaFdkNZWtvjvu8FhRE0nVNXGIpTs
         tovJLEweGgtLIkD1pJ6uazLXLk3VmigHHoRrU1fUeQFgmF5ZmGgLmrlo+I83Hfdy6BIx
         nv3A==
X-Forwarded-Encrypted: i=1; AJvYcCXFS30vIrxW8zXU5E83NOFCqMuyGhpIHhnqRcqw20Lo9LZyD3UGMGuUQnxmOAckBlCY31CmNYkezw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxeTGOlFQzUl+YuLd2cBgiUoRb2AOdbAAI8UEGJCMR1mgKiv+Z
	FxL+/Z3PRo7LA1N3fYj/7aCW7IiaHbuZ70Fb7yAZy086r/Jyc/XYtTmJt+277t76tdik3dBtPNh
	q16eoTdy/OgZzUYEI6ehRzQd0hNa9aWM8/wgb
X-Gm-Gg: AY/fxX4DKoPSjnVVWO6AKhNdkCFUGBibtjxtXwZ6KtH+UqmCA4cpJU/l2XzwGZEt9r1
	Qxbrpz0pu38xoCBbV24ZCGrVQrZqn/GbQq7tJqrbY3PUeZfrp5W+rtVBgU6+i9ounJqKtxjBFpI
	esbHBo6YbhT22aByd7OBH/CKMWy8ueEZtYcrNw0eZCkpQk7GPdm9B5LQ5q42uuzs1yhlpWdH1d1
	c4JiMji7zjbIlbphv/E5G5YlnSEbN+ha1iCQPLhbLRgH4vkNq+VIrLU19Ciot3pJqggag==
X-Google-Smtp-Source: AGHT+IFhCAHdHZXsPB7S7tBXgr5RSUaEA7VwelPG/FCdhk/f3Sp+zUghrTahRZzQos1lPo86zhxX/UkhHLOp4Sm5U38=
X-Received: by 2002:ac8:5a15:0:b0:4ee:1f09:4c35 with SMTP id
 d75a77b69052e-4f4abd79a40mr480102731cf.52.1767057352990; Mon, 29 Dec 2025
 17:15:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-8-joannelkoong@gmail.com> <87tsx9ymm9.fsf@mailhost.krisman.be>
 <87ms31ylor.fsf@mailhost.krisman.be>
In-Reply-To: <87ms31ylor.fsf@mailhost.krisman.be>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 29 Dec 2025 17:15:42 -0800
X-Gm-Features: AQt7F2pGXelCVN94koHfYOSiWSDC-1CiV98YCqEEgBjioHCIRoplY0tFJSOOUmg
Message-ID: <CAJnrk1YRZYdEBL=6K0-7oAq6s-TfL7AnuHwZsN2miPYy1vGCOg@mail.gmail.com>
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, csander@purestorage.com, 
	xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 2:20=E2=80=AFPM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Gabriel Krisman Bertazi <krisman@suse.de> writes:
>
> > Joanne Koong <joannelkoong@gmail.com> writes:
> >
> >> Add an interface for buffers to be recycled back into a kernel-managed
> >> buffer ring.
> >>
> >> This is a preparatory patch for fuse over io-uring.
> >>
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >> ---
> >>  include/linux/io_uring/cmd.h | 13 +++++++++++
> >>  io_uring/kbuf.c              | 42 +++++++++++++++++++++++++++++++++++=
+
> >>  io_uring/kbuf.h              |  3 +++
> >>  io_uring/uring_cmd.c         | 11 ++++++++++
> >>  4 files changed, 69 insertions(+)
> >>
> >> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd=
.h
> >> index 424f071f42e5..7169a2a9a744 100644
> >> --- a/include/linux/io_uring/cmd.h
> >> +++ b/include/linux/io_uring/cmd.h
> >> @@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *=
ioucmd, unsigned buf_group,
> >>                            unsigned issue_flags, struct io_buffer_list=
 **bl);
> >>  int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned=
 buf_group,
> >>                              unsigned issue_flags);
> >> +
> >> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
> >> +                              unsigned int buf_group, u64 addr,
> >> +                              unsigned int len, unsigned int bid,
> >> +                              unsigned int issue_flags);
> >>  #else
> >>  static inline int
> >>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> >> @@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(str=
uct io_uring_cmd *ioucmd,
> >>  {
> >>      return -EOPNOTSUPP;
> >>  }
> >> +static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *=
cmd,
> >> +                                            unsigned int buf_group,
> >> +                                            u64 addr, unsigned int le=
n,
> >> +                                            unsigned int bid,
> >> +                                            unsigned int issue_flags)
> >> +{
> >> +    return -EOPNOTSUPP;
> >> +}
> >>  #endif
> >>
> >>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_=
req tw_req)
> >> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> >> index 03e05bab023a..f12d000b71c5 100644
> >> --- a/io_uring/kbuf.c
> >> +++ b/io_uring/kbuf.c
> >> @@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
> >>      req->kbuf =3D NULL;
> >>  }
> >>
> >> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 add=
r,
> >> +                 unsigned int len, unsigned int bid,
> >> +                 unsigned int issue_flags)
> >> +{
> >> +    struct io_ring_ctx *ctx =3D req->ctx;
> >> +    struct io_uring_buf_ring *br;
> >> +    struct io_uring_buf *buf;
> >> +    struct io_buffer_list *bl;
> >> +    int ret =3D -EINVAL;
> >> +
> >> +    if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> >> +            return ret;
> >> +
> >> +    io_ring_submit_lock(ctx, issue_flags);
> >> +
> >> +    bl =3D io_buffer_get_list(ctx, bgid);
> >> +
> >> +    if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> >> +        WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> >> +            goto done;
> >
> > Hi Joanne,
> >
> > WARN_ONs are not supposed to be reached by the user, but I think that i=
s
> > possible here, i.e. by passing the bgid of legacy provided buffers.
>
> But now I see this is never exposed to userspace as an io_uring_cmd
> command itself, it is only used internally by other fuse operations.
> Nevertheless, it's implemented as an io_uring_cmd by
> io_uring_cmd_kmbuffer_recycle.
>
> Is it eventually going to be exposed as operations to userspace? If not,
> I'd suggest to stay out of the io_uring_cmd namespace (perhaps call
> io_kmbuf_recycle directly from fs/fuse).  Do we need to have this
> io_uring_cmd abstraction for some reason I'm missing?

Hi Gabriel,

Thanks for taking a look at the patchset.

This is not going to be exposed as an operation to userspace. Only the
kernel will be able to recycle kmbufs.

I was under the impression the io_uring_cmd_* abstraction was
preferred as the API for interfacing with io_uring from another
subsystem. In that case then, I'll get rid of the io_uring_cmd layers
for the calls then, that will make things simpler.

Thanks,
Joanne

>
> Thanks,
>
> --
> Gabriel Krisman Bertazi

