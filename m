Return-Path: <io-uring+bounces-11324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB0CCE87B1
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 02:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA3A5300E3DC
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 01:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E658F2367A2;
	Tue, 30 Dec 2025 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfpwMWOa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515F11EEA31
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 01:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767058052; cv=none; b=ikND3YkLMokbhSalq5CY1rPG0k5TxqbB9HUiyhGKIeAFEb/El8OgVMsP+4x5oCeYUNEL1wFNQkDV9LmfYvUtO+gmGznWVtbfSBc4oU6gpH4ollNDaJCwc9SsOHXdsRIefsuErHK9hqqk3nVjRrFQfQMJ7567KsLunOLNQW86od4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767058052; c=relaxed/simple;
	bh=03Ig/4f7NlIENVyrUs/YNTqAQxlnByDRom572un8Sk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nt6AnuBzHLyGV99NyDH8HZq9i878ubG1WG+gfMpQxRxVpDC3BFIphxa2bOMq9+DFzY4Xvrrq/krrKipBf9SzQ+610HFqiK1vTTfMlu0dD9FSZ+ma3cTTnOxClGWCZj97IW2JLyjDOFHBn9ISWKNItS3nrTvSIxBu7hUTC9ciI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfpwMWOa; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee1fca7a16so81606411cf.3
        for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 17:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767058050; x=1767662850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k91pgBWmPa8akUfZJ7BSG2CpbE5hOjf4BCq5FsPTwOg=;
        b=XfpwMWOaYqNuP6WpvQ2MnAJm2IYSU9mkpvIAuRnNH0L4Qwh1w3jQlSnWSmQ0C1hYuu
         KCrHXGlWN9lnsaq/KkOhwjdEz/pBcoE2YWz6b3jJRDcvJo/zeyqlts1zrJ68ZKxiT7Mk
         aRY+MempDtvkd4PZJHXKNY6Aef2vQxE8DZoVB1acCZP4xXsUe1NBmiwP4CmnPsaOYhmG
         JWXz6R8sE6Jc+G+onHJ1R9BAkIoYGiOmSAdxsSLcuF6bo6zQkQvtRTFmYbufi7xQGcvo
         pCsh7CMIXm1imgjWpG52HsuKx2JccAhBrGt349DK2EHfM18T7+atFR0G+CzJEDV23HJ0
         SgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767058050; x=1767662850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k91pgBWmPa8akUfZJ7BSG2CpbE5hOjf4BCq5FsPTwOg=;
        b=Aw2nVkhwrgtYJwhwj2C1QQ3Jy3Z96pGhx5k9MoBNqOmjxmUg5F6ByGnGxsU8sN7AKn
         Oo19H+ZkBeIBEic3+tQDrxyQNBZFjJxgywthGZo28+nsTgHmFxUyvaZGZURqqK0NltAA
         pbHIMaQa6jTqwxby0ExHVh5zI/zMwuanmU/Z8ILYvFh9NpPS7n1bV0M3i9r1fyElf058
         j2h62F6ts/dEB4VLpoAfCZzpuIsSBXsQMZ4oUkhC5v2n26fNUNlnD3/7E+DxqeGAJBMu
         Vu41tGyRMJB0/kO4PS+ZKxi7mY5Qil711VNjnnFvUtdA82E3D67AK1VZCgDxp1FkIXH7
         GNkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxqeMl8omcirjsbyzMYqnvXqyAD2D8zHQAsMU/0xo8TZ+KIYG3P9/79dc2nY3ZqrP2IseSYZjhBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAdHqmJhenItiaP7EqZo+YkKAbtxfKNLVLedl9V/8iLZaxtOLt
	6FM7WPiIBBk43FYi57y/xBUcpjViUI87cTiNcJzijZoS1G/CB3WOs6d+lKdX5KQC0yDTibb4OIH
	fJWyUU6zPrlgHIKp5yx/nHlLWILIIo7uz4jsk
X-Gm-Gg: AY/fxX41jlLzKvuoR7NcY79lpD4+9Oass6qcPwoq1fbAFwHkXw7z4rWCHkAuV507DRB
	AXC/HMxWsB9S012M92DYmwox+uTm7WJBXSx0M1hiaN7cNf1megvgpVKe7iNDmET+HC12v8Z3oDk
	J3HGzRq6Sgh4jwcJw3B27tZHPR3zGsfL1cw3Ox1HPJCQ7CZIrLiyc7mdPRBzCg2lgW/BxkMPVIR
	SYnTYBaIMPLsaahGjztQLcSqZaaOGV1I/VItmiaQBNM+CxmcHbaoS4+ODDineQQQRszfA==
X-Google-Smtp-Source: AGHT+IHm+3ZnhvCYiAawzpugNI36XN0vlG84RIO//EpPhE6QiwUoxFqREBINmHF5z6uXZQtnfCLznOx0rc9abKcsOxw=
X-Received: by 2002:a05:622a:514a:b0:4ee:1c81:b1d1 with SMTP id
 d75a77b69052e-4f4abcf2b74mr473834161cf.22.1767058050170; Mon, 29 Dec 2025
 17:27:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-7-joannelkoong@gmail.com> <87y0mlyp31.fsf@mailhost.krisman.be>
In-Reply-To: <87y0mlyp31.fsf@mailhost.krisman.be>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 29 Dec 2025 17:27:19 -0800
X-Gm-Features: AQt7F2oXNyfS4Qq35qc2jw9Q3_knUBbEA949Xmd2hfXwLMUF6Sk2Bnmq-U9YFaQ
Message-ID: <CAJnrk1a_qDe22E5WYN+yxJ3SrPCLp=uFKYQ6NU2WPf-wCiZOtg@mail.gmail.com>
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, csander@purestorage.com, 
	xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 1:07=E2=80=AFPM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Joanne Koong <joannelkoong@gmail.com> writes:
>
> > +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> > +                  unsigned issue_flags, struct io_buffer_list **bl)
> > +{
> > +     struct io_buffer_list *buffer_list;
> > +     struct io_ring_ctx *ctx =3D req->ctx;
> > +     int ret =3D -EINVAL;
> > +
> > +     io_ring_submit_lock(ctx, issue_flags);
> > +
> > +     buffer_list =3D io_buffer_get_list(ctx, buf_group);
> > +     if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BUF_R=
ING)) {
>
> FWIW, the likely construct is unnecessary here. At least, it should
> encompass the entire expression:
>
>     if (likely(buffer_list && buffer_list->flags & IOBL_BUF_RING))
>
> But you can just drop it.

I see, thanks. Could you explain when likelys/unlikelys should be used
vs not? It's unclear to me when they need to be included vs can be
dropped. I see some other io-uring code use likely() for similar-ish
logic, but is the idea that it's unnecessary because the compiler
already infers it?

Thanks,
Joanne

>
> > +             if (unlikely(buffer_list->flags & IOBL_PINNED)) {
> > +                     ret =3D -EALREADY;
> > +             } else {
> > +                     buffer_list->flags |=3D IOBL_PINNED;
> > +                     ret =3D 0;
> > +                     *bl =3D buffer_list;
> > +             }
> > +     }
> > +
> > +     io_ring_submit_unlock(ctx, issue_flags);
> > +     return ret;
> > +}
> > +
> > +int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
> > +                    unsigned issue_flags)
> > +{
> > +     struct io_ring_ctx *ctx =3D req->ctx;
> > +     struct io_buffer_list *bl;
> > +     int ret =3D -EINVAL;
> > +
> > +     io_ring_submit_lock(ctx, issue_flags);
> > +
> > +     bl =3D io_buffer_get_list(ctx, buf_group);
> > +     if (likely(bl) && likely(bl->flags & IOBL_BUF_RING) &&
> > +         likely(bl->flags & IOBL_PINNED)) {
>
> likewise.
>

