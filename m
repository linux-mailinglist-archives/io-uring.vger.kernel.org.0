Return-Path: <io-uring+bounces-6607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA33A3FBC9
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:45:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28282882E82
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8B7211A29;
	Fri, 21 Feb 2025 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Acbied0Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542D92116EF;
	Fri, 21 Feb 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155749; cv=none; b=RXI3pu16NCfey++gDjuKLX8PJTh7f/9w6N/QgXAnvpttszhYx2cxl6SNHJetBJ54f6Fmbnlw17RY3G7H0mJBnrSXwPI7i8VNYp8fuM5ekTLCYh+ftZzazOq7XeNDb2JfL06OKYZdXX7LQEqvJ6D5+GqBQPgKaFczYvSBvwe+Mho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155749; c=relaxed/simple;
	bh=ltIRd0VTIRj9WLYmMWG+AvzBQYumeFVY5WbuCW8+sO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dmvJa+uiLngqB33bYv/VvAD/mODCAbzkX8BXk6hvyVD0ErCAUZQk1R5ICa1CQhU05nWS15/KAZY89x1KlWxfu3cCAvu4LD0RiIhaJXuKvCmmRGQw8ij9WjuXplMdKPN+ej1V0iYmLUFI4DX/AnxG8ev9b7517fFVBPFnKHTxwUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Acbied0Z; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abbae92be71so268102666b.2;
        Fri, 21 Feb 2025 08:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740155745; x=1740760545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PknoJIwmSHlHD6E/suhtCc6yDi3zaT7cW8DeFouonpg=;
        b=Acbied0Zfzq5wqeT1VzZj8ms2gOcaqIBGnTM1K1A3LPD3MIgJ0ZTRqzWrvwGig2tPJ
         xwoJZniNNJ6Jp8TIz0Pgxgj2iKRMF2i/RcPdSJotaIhmY8vSCvqDDjx81pRHrsq8r7Qa
         CvndRht3B51kdewOXGMoWPc+gc5zy0bHn4oyFuRQAxriMgq41XvEn4AzN0al4FETu3Ub
         o2/A82u44aCa+gbYRf7v/kiv4VJoXIyNk24FXyV3nKV6q9i9TTCiTK6YWzztJsTId5op
         0GRyKA6L29G0qUySn6ohHHFhS6P7tkmd4XkiX0B/s54OC4oWtux/zmx3uPUMNYokpxi8
         idHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740155745; x=1740760545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PknoJIwmSHlHD6E/suhtCc6yDi3zaT7cW8DeFouonpg=;
        b=IIl+oKGZIPpt8ORrgomCJmfqMYwf8j8mWSYvHHgYlz9trvfqdpQXmuivHyW7iB9o8m
         QWR/BYdl4rgt5aIQDyP5T8xCb4mmaGZj+2/YqSmeB1dL3jTLqFo92Xd1+U23xBu5jvGh
         fQWuUBbKCmqhrJz8XuKj01RxX6eumRkMm/KUZ6XXTlUVTbIJu70dzhsz/TX/tkMqM9dj
         K3agCWLSvs8QPkpMcOb1h1PWcCLrn7v6KM1bAwJEEh/XBBYkqlVlGL9Kxr0N9T3Omhqt
         GdmguanBPyUslqdZ8W7yYPVG6Bo4M13wKM8TwtDNxeI66z+oa1JMoiOb24HCMFVFBqPs
         ibMg==
X-Forwarded-Encrypted: i=1; AJvYcCV2f8CQP9oYVUFXUIHewYphFFqN+MPLyJ9bGYtx8GdWjhhs+jDU/3riZNBWMz68JoMZVo5ALnC7WA9+gOmErg==@vger.kernel.org, AJvYcCWRYmhe6llBHTy+0p8iDDElVZdnwxh/uwB059sZjy3cdLg1HP0+XzGZdKRQkVUUhUbFZpXSRmltkuqPAeQS@vger.kernel.org, AJvYcCXSjGgZA1xZxlarzUbTmo/bm/XpvNmzMKUeN1HEdKd3JTtWjH2sOTvBrxlCE6TZh6L5dyQ2mrMXfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUOnVqibsBF+G2Y0KYZBvWnTyb9RSC+iuOaV5OHx4P8QhshRP4
	FKtAGtbame5rWFJDIJrPh59hAcK3/AqJoAS8AuQUKgZwmySe2damQ1b61HZRYUJFwtiLXswPqHd
	Fs2r4dN22LLpVvqWFv0nWbxe9y6sGVbsyd64=
X-Gm-Gg: ASbGnct/6CHDZDXj0dQFfY8wB7CrqaCoUIPBwK1qn26xoppnPCT6OyeS6ohArBcm+1A
	o7XFyWk5EV6FZFaoNR2doaGaf8sxnP4XhgWweWpxYWruHcER+EKBkIH1p4eKFOqd8k8BjhEflKP
	7G4o01cRI=
X-Google-Smtp-Source: AGHT+IEOmKJPFlMpukMjx7CxdPEThD+RSxWCweGs8yUL0Bf2UosLonKK/bylgn7Hzu9w3F5kICLoHT5Zeb+5Jqw7/nM=
X-Received: by 2002:a05:6402:13c8:b0:5dc:caab:9447 with SMTP id
 4fb4d7f45d1cf-5e0b720acf4mr9522446a12.18.1740155745100; Fri, 21 Feb 2025
 08:35:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com> <216baa7e-2a97-4f12-b30a-4e21b4696ddd@bsbernd.com>
In-Reply-To: <216baa7e-2a97-4f12-b30a-4e21b4696ddd@bsbernd.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Feb 2025 17:35:34 +0100
X-Gm-Features: AWEUYZnUOZyDzWLGKmQRd1N45G0gotPf2Ganf8fFLj45JYHuBYwTB0m1xAVO6SE
Message-ID: <CAOQ4uxgNyKL9-PqDPjZsXum-1+YNwOcj=jhGCYmhrhr2JcCjNw@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Moinak Bhattacharyya <moinakb001@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 5:17=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 2/21/25 17:14, Bernd Schubert wrote:
> >
> >
> > On 2/21/25 16:36, Moinak Bhattacharyya wrote:
> >> Sorry about that. Correctly-formatted patch follows. Should I send out=
 a
> >> V2 instead?
> >>
> >> Add support for opening and closing backing files in the fuse_uring_cm=
d
> >> callback. Store backing_map (for open) and backing_id (for close) in t=
he
> >> uring_cmd data.
> >> ---
> >>  fs/fuse/dev_uring.c       | 50 ++++++++++++++++++++++++++++++++++++++=
+
> >>  include/uapi/linux/fuse.h |  6 +++++
> >>  2 files changed, 56 insertions(+)
> >>
> >> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >> index ebd2931b4f2a..df73d9d7e686 100644
> >> --- a/fs/fuse/dev_uring.c
> >> +++ b/fs/fuse/dev_uring.c
> >> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd =
*cmd,
> >>      return ent;
> >>  }
> >>
> >> +/*
> >> + * Register new backing file for passthrough, getting backing map fro=
m
> >> URING_CMD data
> >> + */
> >> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> >> +    unsigned int issue_flags, struct fuse_conn *fc)
> >> +{
> >> +    const struct fuse_backing_map *map =3D io_uring_sqe_cmd(cmd->sqe)=
;
> >> +    int ret =3D fuse_backing_open(fc, map);
> >
> > Do you have the libfuse part somewhere? I need to hurry up to split and
> > clean up my uring branch. Not promised, but maybe this weekend.
> > What we need to be careful here about is that in my current 'uring'
> > libfuse always expects to get a CQE - here you introduce a 2nd user
> > for CQEs - it needs credit management.
> >
> >
> >> +
> >> +    if (ret < 0) {
> >> +        return ret;
> >> +    }
> >> +
> >> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> >> +    return 0;
> >> +}
> >> +
> >> +/*
> >> + * Remove file from passthrough tracking, getting backing_id from
> >> URING_CMD data
> >> + */
> >> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> >> +    unsigned int issue_flags, struct fuse_conn *fc)
> >> +{
> >> +    const int *backing_id =3D io_uring_sqe_cmd(cmd->sqe);
> >> +    int ret =3D fuse_backing_close(fc, *backing_id);
> >> +
> >> +    if (ret < 0) {
> >> +        return ret;
> >> +    }
> >
> >
> > Both functions don't have the check for
> >
> >       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >               return -EOPNOTSUPP;
> >
> > but their ioctl counter parts have that.
> >
>
> In order to avoid code dup, maybe that check could be moved
> into fuse_backing_open() / fuse_backing_close() as preparation
> patch? Amir?

Without CONFIG_FUSE_PASSTHROUGH, fuse/passthrough.c
is compiled out, so the check cannot be moved into fuse_backing_*
we'd need inline helpers that return -EOPNOTSUPP when
CONFIG_FUSE_PASSTHROUGH is not defined.
I don't mind, but I am not sure this is justified (yet).

Thanks,
Amir.

