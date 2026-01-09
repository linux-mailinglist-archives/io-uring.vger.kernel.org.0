Return-Path: <io-uring+bounces-11554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D76D06B04
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 02:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DDFF300EA19
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 01:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395B11632E7;
	Fri,  9 Jan 2026 01:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ELEjxyjG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8464F5E0
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920941; cv=pass; b=MDd1islBsDpyX7EpWmLn5IsKm2asAQznBKK+rWAmmjgM8FkrEquI06PyDSI3YsiKRy2gGQB8JMGz5swRtHXUSLSkGRF7xEfL88Y9USQNkHacMCr+LEsXvVioJ9ktiOMsnJ7rVo9M3jZWxRlHPybpov3icrIsVeGzlF4VhBG8zbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920941; c=relaxed/simple;
	bh=trJtWvUFlJSwUai5GFM2JDb9LgshLEc/5MHs272bSOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kRiTV3eRPLYx/2RwmOP0E2dDkWfSTrA+Ry7O3XEjRc3tpl+xnLoeqIXLO+gQI7an/p1BOmm2nNjgxjdP9lkCpxpWZ2qlI9lB4I+DrojwCMY9DT6EohO9SyMbQ5IpFwf91HjJ0pBC2dcfBpE+ItlD5+XtrqXtG7BC5Ps4bO41ggQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ELEjxyjG; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-11f450147cfso264463c88.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 17:08:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767920939; cv=none;
        d=google.com; s=arc-20240605;
        b=LKKLXhGXwcSFLKbKX8KPS6+jkMXBakQhmHssbQxPsM4ihyB7g/UUX/gtWlAdFfhThq
         FTS6tCEfOOzycXjLGxcrZW/TAiBGzcmoHg0lRmwsuwT8o1hYklWA764MCPzb2u7Qy2fz
         o3J3wBhUvlNzXYVHvrLavmVSuIe6UT8NH+2elVjvKqp5mCbZniOrDOz+o3fJkPFpZUIf
         k08U+OLhmJtCJ/OMdxc3ixnzoRWk6nDEGKAvxNsXD+/0QFfRgsQraNjc1FD4F9psTzKx
         aKR7D3g3c4cPNvr7Qt/y5eW4rVr+I8Llt9SVYDCQ85VU0s9JNRl3jKZDfryiQEa3DPTR
         inSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hH5ZRheui97dRDSGowqdmerpy2XNgKBNxKRO0GxS7IU=;
        fh=aZVtLpaZVrkpyh8AMiKU0SL+qXnO7mjp0hjT1MOqLUs=;
        b=CosKBgLH//S5nVNwOlMTOj3d2/1qLGSmcKRJuTocHs1b0mEByxGN9yICBl4eQQKZj0
         PbQXL4fBJO+1M+qJ2OHBtNAqm0sCuIoUszwOnPgh0wPBlH/N6iwT95NGA60RjcZj/R1+
         z6PEQFc0qFHmiwDG54M+Ax6TP+L5xdAF9Q+WSG8RYbIRmcXj3eCNd94rT6DkqzCi4ntA
         KvL1bbK1dujAEhfDXHxd/VEyhSOiGOJGGRxvpmjingYaXv0UKanehmMVWaNomxGZX1ij
         sA1Ns1YX2S+7BsKJVws29cOMLKVWmzhtBc0simJdkoxpPvsC1FiJ5VUyNQ1bjcZ6x4y1
         iJcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767920939; x=1768525739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hH5ZRheui97dRDSGowqdmerpy2XNgKBNxKRO0GxS7IU=;
        b=ELEjxyjG1z1wmAH9NJKIBru5eulmL/jeSk/GVyIoDgbn6boDgEb9iHUzXSq30AHYrv
         Xy0i4MWS5CIELREejdwP6X9mqOXaYKNm2ZEE7JL1R06T/6wUFEUBpl8/UPdeX3qJCqBB
         6fJP/7YcUmuM7wfDbrnaO9+ll6Gn4U/AKahTjvxT9YvgW8lEnXNKwTqH4Vnz8108XEuP
         SZh+Kngww0ZRR8sLZEO3eJfMuilEV1/JQTky34t0smwkRJQbygFBEVdy+c4wqb75ov5O
         vHWc3rLQSvgUOI2iPVBjaYqVYvRMiG3QRAd/nbOlES1UagNKpaOKbVFlA2brpSMpd10I
         rYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767920939; x=1768525739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hH5ZRheui97dRDSGowqdmerpy2XNgKBNxKRO0GxS7IU=;
        b=W23ocaE6wU487xGRHkS43vsVgcgKMxgQ0uqhIC5vIzYkSfTkzLUcV6ALHTuWL+eHDN
         3teq3Ks6F2IeHJ/6UFYjlIWJ89jym8p+yBOQDifskljP04W5YWVtYUdc2MUIj1Ki5pAC
         MbOaSc/TruaYTz4BTkasx+S3CrFYRx6NJYiwFnEHYEnhkRCstuyrH3iz/amfZ7KaflB7
         7BAGBkjtIIieDnSR1sWcuzJcSnSBwZuMz4dTVooSI4wVLFINi/HzkFCx7IwQnZdF/jsz
         WBBBiFJ+yeIVkMXSZPgrAwWBZknlLGSsDd0hEBfHNNRE5MQhgJLEqtiMnpIen7+iBtg/
         tQlw==
X-Forwarded-Encrypted: i=1; AJvYcCW/AZs2m3PW2058c+XOb7RNZw/VTecLXK/QvCjK1FPMY+/114Eb42OseGBR4zfwJCnZkooFF9KSWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7R03gqMUJGcbrSXiE5TTR96ZfvYgPvO8f1firuHhso3x7vLqs
	ecXQ6m7YwLmV+Qz/437MpH1jI7FLrJnFC6hxF5zb7LWagSNqKVwuzr/79/FK/ZXpXV0NW3uVHIM
	SbXW08iRdvlM+5HL5ZfK7YxKs8onz5jZ/cIF/Fzw9RQ==
X-Gm-Gg: AY/fxX5hwd59dCosyOphLIzqpufoU+KW+WjdeTth+CzCr3U7RUiqkG8cAHfZlGVjZjH
	6XcaEDexcXoSN5IoSodof+DTLcHJ/l9ZS76Mx3/ZWJ5pii8V4cJv3aQ1vYiEhv7nWVPMyC9JWdQ
	TRkY2Sm3XhPzhFfB613fpyA8DRMWZIL9VUrklr8VPKPXcdpESwisQl4Dat3tV7D7ugo7iZRLrwl
	RAddA0KNCCbg1cIYKdiSP188SUwsol/U1MvC45vdvCAdC75WSmun6g/7VPgvrCH5cI1CApc
X-Google-Smtp-Source: AGHT+IFRUL+6fCFYxL8Iu3T4r8ynoQYe8o9aPpiLkPjX0Ww+rmyqxdIrxsYIe0IrnGvEzIODyFP89unT4EfOUUERtPg=
X-Received: by 2002:a05:7022:b9e:b0:122:8d:39d8 with SMTP id
 a92af1059eb24-122008d3f76mr1769244c88.6.1767920938506; Thu, 08 Jan 2026
 17:08:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-9-joannelkoong@gmail.com> <CADUfDZpdNNYdNnrPWviGYPViQ6O_S4S0hB7Hg56+wnQDgnXwAQ@mail.gmail.com>
 <CADUfDZpo06_FNCvYy+s0hi+vtUbWozeASv6ojxERqv=LMtQK2w@mail.gmail.com> <CAJnrk1aC6x=NppNZX+3iit5weO-oPULfFEq2D=9vDAA-TBuFtw@mail.gmail.com>
In-Reply-To: <CAJnrk1aC6x=NppNZX+3iit5weO-oPULfFEq2D=9vDAA-TBuFtw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 17:08:47 -0800
X-Gm-Features: AQt7F2oRXvWMBxD9bp-zZ31q1IgXFi40eLMiK9N7tUr_JogbOuoaLsHEZNx0Aoo
Message-ID: <CADUfDZqm_nwWG=oSfL69hioag+KF0t3nUKTQFRfXMHgmHtQRjg@mail.gmail.com>
Subject: Re: [PATCH v3 08/25] io_uring: add io_uring_cmd_fixed_index_get() and io_uring_cmd_fixed_index_put()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 4:55=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Thu, Jan 8, 2026 at 12:44=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Thu, Jan 8, 2026 at 11:02=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > Add two new helpers, io_uring_cmd_fixed_index_get() and
> > > > io_uring_cmd_fixed_index_put(). io_uring_cmd_fixed_index_get()
> > > > constructs an iter for a fixed buffer at a given index and acquires=
 a
> > > > refcount on the underlying node. io_uring_cmd_fixed_index_put()
> > > > decrements this refcount. The caller is responsible for ensuring
> > > > io_uring_cmd_fixed_index_put() is properly called for releasing the
> > > > refcount after it is done using the iter it obtained through
> > > > io_uring_cmd_fixed_index_get().
> > > >
> > > > This is a preparatory patch needed for fuse-over-io-uring support, =
as
> > > > the metadata for fuse requests will be stored at the last index, wh=
ich
> > > > will be different from the buf index set on the sqe.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  include/linux/io_uring/cmd.h | 20 +++++++++++
> > > >  io_uring/rsrc.c              | 65 ++++++++++++++++++++++++++++++++=
++++
> > > >  io_uring/rsrc.h              |  5 +++
> > > >  io_uring/uring_cmd.c         | 21 ++++++++++++
> > > >  4 files changed, 111 insertions(+)
> > > >
> > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > index a63474b331bf..a141aaeb099d 100644
> > > > --- a/io_uring/rsrc.c
> > > > +++ b/io_uring/rsrc.c
> > > > @@ -1151,6 +1151,71 @@ int io_import_reg_buf(struct io_kiocb *req, =
struct iov_iter *iter,
> > > >         return io_import_fixed(ddir, iter, node->buf, buf_addr, len=
);
> > > >  }
> > > >
> > > > +int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *it=
er,
> > > > +                        u16 buf_index, unsigned int off, size_t le=
n,
> > > > +                        int ddir, unsigned issue_flags)
> > > > +{
> > > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > > +       struct io_rsrc_node *node;
> > > > +       struct io_mapped_ubuf *imu;
> > > > +       u64 addr;
> > > > +       int err;
> > > > +
> > > > +       io_ring_submit_lock(ctx, issue_flags);
> > > > +
> > > > +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> > > > +       if (!node) {
> > > > +               io_ring_submit_unlock(ctx, issue_flags);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       node->refs++;
> > > > +
> > > > +       io_ring_submit_unlock(ctx, issue_flags);
> > > > +
> > > > +       imu =3D node->buf;
> > > > +       if (!imu) {
> > > > +               err =3D -EFAULT;
> > > > +               goto error;
> > > > +       }
> > > > +
> > > > +       if (check_add_overflow(imu->ubuf, off, &addr)) {
> > > > +               err =3D -EINVAL;
> > > > +               goto error;
> > > > +       }
> > > > +
> > > > +       err =3D io_import_fixed(ddir, iter, imu, addr, len);
> > > > +       if (err)
> > > > +               goto error;
> > > > +
> > > > +       return 0;
> > > > +
> > > > +error:
> > > > +       io_reg_buf_index_put(req, buf_index, issue_flags);
> > > > +       return err;
> > > > +}
> > > > +
> > > > +int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
> > > > +                        unsigned issue_flags)
> > > > +{
> > > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > > +       struct io_rsrc_node *node;
> > > > +
> > > > +       io_ring_submit_lock(ctx, issue_flags);
> > > > +
> > > > +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> > >
> > > Hmm, I don't think it's safe to assume this node looked up by
> > > buf_index matches the one obtained in io_reg_buf_index_get(). Since
> > > the uring_lock is released between io_reg_buf_index_get() and
> > > io_reg_buf_index_put(), an intervening IORING_REGISTER_BUFFERS_UPDATE
> > > operation may modify the node at buf_index in the buf_table. That
> > > could result in a reference decrement on the wrong node, resulting in
> > > the new node being freed while still in use.
> > > Can we return the struct io_rsrc_node * from io_reg_buf_index_get()
> > > and pass it to io_reg_buf_index_put() in place of buf_index?
> >
> > Alternatively, store the struct io_rsrc_node * in the struct io_kiocb,
> > as io_find_buf_node() does? Then you wouldn't even need to call
> > io_reg_buf_index_put(); io_uring would automatically release the
> > buffer node reference upon completion of the request. The only reason
> > I can see why that wouldn't work is if a single fuse io_uring_cmd
> > needs to import multiple registered buffers. But it doesn't look like
> > that's the case from my quick skim of the fuse code.
>
> Good catch, I think I'll need to store that rsrc node pointer inside
> the fuse code then. I think we could store it inside the struct
> io_kiocb for the fuse use case but I think at an api level that ends
> up getting ugly with introducing unobvious relationships between
> io_uring_cmd_fixed_index_get() and io_uring_cmd_import_fixed().

Perhaps renaming it to something more similar
("io_uring_cmd_import_fixed_index()" or something) would help hint
that these 2 functions are related? But I'm fine with storing the
struct io_rsrc_node * externally if you'd prefer that.

Best,
Caleb

