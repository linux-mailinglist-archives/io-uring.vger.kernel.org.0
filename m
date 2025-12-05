Return-Path: <io-uring+bounces-10981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4377CA8721
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 17:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C133A301AE34
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 16:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A57B3446AD;
	Fri,  5 Dec 2025 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cLMRFEzG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F546344029
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953806; cv=none; b=seG9a4sIRn5Yttf/pgDqGo23TqDdW075ST78CXaOweKTte9BgOZAYAgfxzQ/uYRr3BaZfPk3gBtsp5gn8Gs5FjLqWdK/G8RHX9zUTZg4ZJjuVvUwZbQi+hsuxyCau9bvNQUtECqRXO8gxJ24JDWR88WjyLja5amkK3oSkSRxLqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953806; c=relaxed/simple;
	bh=M4oPY7GS9GpxI9PUNxyEN7UBwwAUyqzFlomAPU8Akvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8B5p/UOe0jFMt45R+UqAjXjK8qUA2xOM9XHdFB285+PZ39Qo5FeEt40k+lOWLglsoonWNEy+9So6HX56A68oLv64nGpakFwpmOe3CCPzRFfrdZCDzvQDZLHKwHg6G4tCNLi10o+1AynIFmd+YlqQhr4a2ubTYRmY7fMSA3vng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cLMRFEzG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29806bd4776so4022455ad.0
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 08:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764953797; x=1765558597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLkse+kxK2cpAjStUn6oi58P19wP2uA7EZcpaXApxz8=;
        b=cLMRFEzGDgK+/EuAkgJ3UBtuIPCc0YHZk5Z/WWfGRQDemD0B28bXdB/1vhnXA1XeXP
         6yJYGCZ9B6uIeTe1bNhM49o6F3J+FZr67g+gtZV7tfu2wBujkwceJH5FFUNRxziMVWuZ
         eO8KCCK3pOkaHyqNMbaJCFnk68iz7wqCDh7LyB0yq7XiH3uDMphIqEX7eSZPZWV4azfd
         Kwcuot/5Yy9Cmo8I0hojEnqkpdRBkJW6h1LlCH1Io/j3L1YoVx7k3D3Jw0PpjIKAEy4g
         9uRNfVnCJ3A2rkZX630IqeKdF1Y5p+iAw6xoYjqRnt/8Ps00COMi2SKtuiEX5H4+x2K6
         +dAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953797; x=1765558597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xLkse+kxK2cpAjStUn6oi58P19wP2uA7EZcpaXApxz8=;
        b=thjVjASjkIHO8CDhJMhw4B726SkipAi/ZxtgO3jRh7YA7KkkKcXB0fJr0ebNDYg+72
         7kPhDFqaXUbJOFuEPIhO8aTzF5qf/SNPALd78S/KdLxkHnRTuC9LFR5H4JUdT4WY1wrq
         uCgrxTWXztsZ3pRywTOPQ8JO8tS1BHsawAp3peTzT2ZSFr9+AzFhLqpS0g11sT3xvrnz
         u8S1bsTYfEtOomCfwYFWnBVpSMp7aI3p3oGwwm5juyQcorca/U3FAWzXC5ZToiqlVoSn
         APYTYNasTpUo2QXJJWcr5fE6ljVHX1h1Q3q98sstSbxDV2u2PgkGbykLDhduYzG6T0GV
         2mOw==
X-Forwarded-Encrypted: i=1; AJvYcCUnRWspGBfPjA6Dp+TLnonxpI+ZCZXNDTBcpd1/uUyRh3yjeXZPmu7DbUsGYCJKDtBNIY5BIphELw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTDOTOdQ22HHQqRLF4ngCCWuLthWRll95e234rAZozbnprZbU3
	8ukIwo5+HztZosv+unJMOFybr5tT+h6M1B3OSsPt9sXrstOBG0VU2j434nXLzITfYl3yFIOpQi6
	pH8HiAZVAcIPIxeDQAVajxS5Ar7FJz2STVVpmW3hJgQ==
X-Gm-Gg: ASbGnctWSiWKdGsvMvnZqMidddVVpXPltEX8cbKiDHX+GyQ/RnwxTh/1GcGC/e+8Sb2
	I+4IIYQgdUSJZA8V6by5o5p/u9bKBU/DzZ0oxOvAlV2yvfzY13Jo6bihFsGxYX4+oT+X+L9ytF4
	whHBvugb/lj/c8N7XpCslzO9OMaaxcz9OZN1cRht0T81BDrmoq758jW63x83BnogadSjhLMcH51
	F3XoZpOsdHk9xX6brIRngHVzqNb8gltvDCMVSNeyx+JDLZojicxcIcTjndqC62Uvs8XaXBwncqX
	zuFic0E=
X-Google-Smtp-Source: AGHT+IGbeCMLnueowPIoRrzPwuFgraW/b5AAoT5rWEdLqtgXZRw7M2hUo1Y4TmZqi7QNuKoRpruzJlYVuOmDSOOWv8Y=
X-Received: by 2002:a05:7022:529:b0:11a:2020:ac85 with SMTP id
 a92af1059eb24-11df259c23bmr6564324c88.4.1764953796295; Fri, 05 Dec 2025
 08:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-10-joannelkoong@gmail.com> <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
 <CAJnrk1a9oifzg+7gtzxux+A0smUE-Hi3sfWU-VpnXZgvKg1ymQ@mail.gmail.com>
In-Reply-To: <CAJnrk1a9oifzg+7gtzxux+A0smUE-Hi3sfWU-VpnXZgvKg1ymQ@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 5 Dec 2025 08:56:24 -0800
X-Gm-Features: AWmQ_bmHamkODTakaBnJQIc2zvf1nBWE4PbpBsybaPsg17oL8N-OXIplP9XG6pE
Message-ID: <CADUfDZoMNiJMoHJpKzF2E_xZ7U-2jitSfQJd=SZD57AxqN6O_Q@mail.gmail.com>
Subject: Re: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 10:56=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Dec 3, 2025 at 1:44=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > Add a new helper, io_uring_cmd_import_fixed_index(). This takes in a
> > > buffer index. This requires the buffer table to have been pinned
> > > beforehand. The caller is responsible for ensuring it does not use th=
e
> > > returned iter after the buffer table has been unpinned.
> > >
> > > This is a preparatory patch needed for fuse-over-io-uring support, as
> > > the metadata for fuse requests will be stored at the last index, whic=
h
> > > will be different from the sqe's buffer index.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/io_uring/cmd.h | 10 ++++++++++
> > >  io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
> > >  io_uring/rsrc.h              |  2 ++
> > >  io_uring/uring_cmd.c         | 11 +++++++++++
> > >  4 files changed, 54 insertions(+)
> > >
> > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > index 67331cae0a5a..b6dd62118311 100644
> > > --- a/io_uring/rsrc.c
> > > +++ b/io_uring/rsrc.c
> > > @@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req, st=
ruct iov_iter *iter,
> > >         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
> > >  }
> > >
> > > +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *i=
ter,
> > > +                           u16 buf_index, int ddir, unsigned issue_f=
lags)
> > > +{
> > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > +       struct io_rsrc_node *node;
> > > +       struct io_mapped_ubuf *imu;
> > > +
> > > +       io_ring_submit_lock(ctx, issue_flags);
> > > +
> > > +       if (buf_index >=3D req->ctx->buf_table.nr ||
> >
> > This condition is already checked in io_rsrc_node_lookup() below.
>
> I think we still need this check here to differentiate between -EINVAL
> if buf_index is out of bounds and -EFAULT if the buf index was not out
> of bounds but the lookup returned NULL.

Is there a reason you prefer EINVAL over EFAULT? EFAULT seems
consistent with the errors returned from registered buffer lookups in
other cases.

Best,
Caleb

>
> >
> > > +           !(ctx->buf_table.flags & IO_RSRC_DATA_PINNED)) {
> > > +               io_ring_submit_unlock(ctx, issue_flags);
> > > +               return -EINVAL;
> > > +       }
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index 197474911f04..e077eba00efe 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -314,6 +314,17 @@ int io_uring_cmd_import_fixed_vec(struct io_urin=
g_cmd *ioucmd,
> > >  }
> > >  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
> > >
> > > +int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16=
 buf_index,
> > > +                                   int ddir, struct iov_iter *iter,
> > > +                                   unsigned int issue_flags)
> > > +{
> > > +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> > > +
> > > +       return io_import_reg_buf_index(req, iter, buf_index, ddir,
> > > +                                      issue_flags);
> > > +}
> >
> > Probably would make sense to make this an inline function, since it
> > immediately defers to io_import_reg_buf_index().
>
> That makes sense to me, I'll make this change for v2.
>
> Thanks,
> Joanne
>
> >
> > Best,
> > Caleb

