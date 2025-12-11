Return-Path: <io-uring+bounces-11007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3AF7CB4950
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 03:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7903F301896F
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 02:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A692429BDB0;
	Thu, 11 Dec 2025 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="F1MMEZ9d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF29293C4E
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 02:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765421884; cv=none; b=Dr9xYQ8uRtDaHxDdOrPR+twcarqu1T3P6DGdLqNAwdjaIay8DbfWptMpTKtGbH8kNu6OQi/En1zefnpRb7FFBLQeNSTGcMkVQskKKU709c8k1caatImcxWFJ0g38o5bbAO/krnqbSZw8wr71WBSjLpq93rZpENNFP0TlRVKC4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765421884; c=relaxed/simple;
	bh=Q2Tz54xcXfKNhOl1jEEl+EPX++hlD7Wr0xdYX70vtz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AUmPZRf2/JWaaTFs22StdSbqG0lty8s+jZxTtsQh7Yp1xyb96/0HBatXtWCpNZRrqRZLnNlPZAAcLunst1NcP9f9xs6Q17PNC7mviKj5xKWaXVL50dqlqcqH7SU0YCNolHmb6GNG8409ISc6n8kgLUPANyDLtISmYxeR1nLdkew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=F1MMEZ9d; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7bb2fa942daso87203b3a.1
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 18:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765421882; x=1766026682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jS6Ier0wKLBde7ZWAUZx+lTRrTdrR6E+/ZstXOFBoOg=;
        b=F1MMEZ9ds1exVBscUDzAqi8EXIS69XHe49MjfFeiqXtqROxFGJM5xcvPTldEswfAOd
         4O6GlI9wiJAUrk+X8Tw4sXphDUkymtwSIb2Xsui2nvSlNaVxonyPyz1OpczB3l3TXhJ6
         GnkoCmVTfbcDOBw0owQo+cjx6vkv+rZlppxjMUxqfPubuC2CnV4q3T0wyGhJLq5PmYpK
         ti/k34ohIh/FYA6zUrNmz3m5g1Ob9uTZmuNiAKlWx4CmQKcUco1CUOGkkCi2HqxlebQo
         0zqhUY2PKYPJymHcn06oR+6L4KVcqk738vsTClCdihhdZiTFkAL98retYMPPh/CmFndc
         wGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765421882; x=1766026682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jS6Ier0wKLBde7ZWAUZx+lTRrTdrR6E+/ZstXOFBoOg=;
        b=vGFAu6SJB+beyOfDIlfTZYD5UhDfiBMCRggmrjbz7VZ64xUKFCMxuufC091Gj3YLo6
         zUH+leIT8908E4Z6v1Op9maGnjm8GuXFsMAKOzatc8ssFR+/QhJez+jIW4+5eyE9W7yh
         w5wFx0Mmm5kqiLd9HxO4XAZR/ftkIJre4KsVGZi45OHDeJEpecJQey6PzuGTSBdpuBs/
         BqL81c/2W7n6c8chrLjFIJi5QTBuMin0140UdGtrT2ilGHwycNqWFgqGTF42Ij/sm6du
         URRV6hkCN1Ub2eRiFkMNlMtufqgaLWKu8Yi6geqjbBW12gniDI8OMGLQ6V0BbudC90qx
         Etww==
X-Forwarded-Encrypted: i=1; AJvYcCWQxNSU4ZL4LMmpbDGO/EMrdEDBvxlDQxOkkSYu6KFYE64kaMG+goPSqTUmhbTvki1cCgXqktMODg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd40dGrqRn9fL37LVBvbQtT2Gp2icQngsPXqpT1FgIXriz7Lyw
	lRGYIRvL1sW0juwyjWiWTiiqBa+3vBEou755GTDjrJtFvl2t9ovqwEeN94J63iMH9CYuaZrLaaB
	rKAI/Tb/UxwLy90uBKF3INfWnYEx/ge9ygknPyvH95g==
X-Gm-Gg: ASbGncsYrl5EineT8lV1FyddSEg26iYTxF8aeyQn0IMkrOaXqca+5GNmfpprfv1Ovi+
	0YeD22Eba0TGkkwTO2mF5DBJ425CFGD4tU8YdaOP/B6t/RQyTyDqsfheQFnIUyjv/bSJuPO4JkD
	95YezpfEzY8exZXRjuj5X3MckDQ1Js/BIZstYwUsewnl6devYdw1134yPPQdkzZjxujjuKZ/wuJ
	FY7mSQltFr7WD8yZDkbbInqacXxKHBTxyJNfQpGO9CdAkgdjLPT+gMKhUAjfLz2KpDwuxCz
X-Google-Smtp-Source: AGHT+IFrPM5oGw+4ASKhyJhC7y9kDQROUrxQf55/hzv5FGD1A9xVpzd3S/wT/Xk0jtl6dLdcU8Kuyn1pjkJowAhoKUk=
X-Received: by 2002:a05:7022:aaa:b0:119:e56b:46b6 with SMTP id
 a92af1059eb24-11f2e6abc15mr531934c88.0.1765421881924; Wed, 10 Dec 2025
 18:58:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-10-joannelkoong@gmail.com> <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
 <CAJnrk1a9oifzg+7gtzxux+A0smUE-Hi3sfWU-VpnXZgvKg1ymQ@mail.gmail.com>
 <CADUfDZoMNiJMoHJpKzF2E_xZ7U-2jitSfQJd=SZD57AxqN6O_Q@mail.gmail.com> <CAJnrk1Z2dTPbWeTxZT2Nh0XZSBHnPopK9qcKVFnyzkcMckhVuw@mail.gmail.com>
In-Reply-To: <CAJnrk1Z2dTPbWeTxZT2Nh0XZSBHnPopK9qcKVFnyzkcMckhVuw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 10 Dec 2025 18:57:50 -0800
X-Gm-Features: AQt7F2qoyJItnFWk8VYnalJqtP6lWmqWUhELRdmN5LRNLZCD4x91EDK1yGjlXbg
Message-ID: <CADUfDZraQqEMZ=UAwbvSfPXZTF5hx7i7DLZ=UzQNA+YZOTxD7Q@mail.gmail.com>
Subject: Re: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 3:28=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Fri, Dec 5, 2025 at 8:56=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Thu, Dec 4, 2025 at 10:56=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > On Wed, Dec 3, 2025 at 1:44=E2=80=AFPM Caleb Sander Mateos
> > > <csander@purestorage.com> wrote:
> > > >
> > > > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@g=
mail.com> wrote:
> > > > >
> > > > > Add a new helper, io_uring_cmd_import_fixed_index(). This takes i=
n a
> > > > > buffer index. This requires the buffer table to have been pinned
> > > > > beforehand. The caller is responsible for ensuring it does not us=
e the
> > > > > returned iter after the buffer table has been unpinned.
> > > > >
> > > > > This is a preparatory patch needed for fuse-over-io-uring support=
, as
> > > > > the metadata for fuse requests will be stored at the last index, =
which
> > > > > will be different from the sqe's buffer index.
> > > > >
> > > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > > ---
> > > > >  include/linux/io_uring/cmd.h | 10 ++++++++++
> > > > >  io_uring/rsrc.c              | 31 ++++++++++++++++++++++++++++++=
+
> > > > >  io_uring/rsrc.h              |  2 ++
> > > > >  io_uring/uring_cmd.c         | 11 +++++++++++
> > > > >  4 files changed, 54 insertions(+)
> > > > >
> > > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > > index 67331cae0a5a..b6dd62118311 100644
> > > > > --- a/io_uring/rsrc.c
> > > > > +++ b/io_uring/rsrc.c
> > > > > @@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req=
, struct iov_iter *iter,
> > > > >         return io_import_fixed(ddir, iter, node->buf, buf_addr, l=
en);
> > > > >  }
> > > > >
> > > > > +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_ite=
r *iter,
> > > > > +                           u16 buf_index, int ddir, unsigned iss=
ue_flags)
> > > > > +{
> > > > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > > > +       struct io_rsrc_node *node;
> > > > > +       struct io_mapped_ubuf *imu;
> > > > > +
> > > > > +       io_ring_submit_lock(ctx, issue_flags);
> > > > > +
> > > > > +       if (buf_index >=3D req->ctx->buf_table.nr ||
> > > >
> > > > This condition is already checked in io_rsrc_node_lookup() below.
> > >
> > > I think we still need this check here to differentiate between -EINVA=
L
> > > if buf_index is out of bounds and -EFAULT if the buf index was not ou=
t
> > > of bounds but the lookup returned NULL.
> >
> > Is there a reason you prefer EINVAL over EFAULT? EFAULT seems
> > consistent with the errors returned from registered buffer lookups in
> > other cases.
>
> To me -EINVAL makes sense because the error stems from the user
> passing in an invalid argument (eg a buffer index that exceeds the
> number of buffers registered to the table). The comment in
> errno-base.h for EINVAL is "Invalid argument". The EFAULT use for the
> other cases (eg io_import_reg_buf) makes sense because it might be the
> case that for whatever reason the req->buf_index isn't found in the
> table but isn't attributable to having passed in an invalid index.

req->buf_index generally comes from the buf_index field of the
io_uring SQE, so you could make the same argument about EINVAL making
sense for other failed buffer lookups. I don't feel strongly either
way, but it seems a bit more consistent (and less code) to just
propagate EFAULT from io_rsrc_node_lookup().

Best,
Caleb

