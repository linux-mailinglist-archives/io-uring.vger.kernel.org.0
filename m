Return-Path: <io-uring+bounces-11350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C837BCEC4F1
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 18:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E10A5304DE1B
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 17:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D6729AB1A;
	Wed, 31 Dec 2025 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="b8VIPKwA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1920529BDB0
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767200553; cv=pass; b=NleK0E7TNEaDrStpIRUwQW8uk6buATrswE+0hAuxu0FerraqMkqrMQ2h+xgafpt20YyIZJUahXuRbEDRBAlYpfRaZ8CRzu/FpnO2Oo2dtUp8mHIzTYorcw01e6f6MHjZJeHbHDA2uHudubs4Hh4qlt/1nq9CBGS373J1CVgUPNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767200553; c=relaxed/simple;
	bh=Sejc3sL2dVpoduNYUNAAxP+Mp7XyEBPgHXURjOZGF7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PaDvjxUx+KRupseeS67VuU9NJ5EklEwqD0TV8P3UROlTR+O6P/CwqaWPCGlhL8Bh02QHzf2XUfw1B4c8IFJoJ0ZmmJTIBbPQ3RCPBALAsVoEoQkk5xpiWoRnNVJfYtPJ2RB2slpN4yTUWlaGwyvYg+BFE84tnp+y3flxEuuGzvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=b8VIPKwA; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29f3018dfc3so33272865ad.0
        for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 09:02:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767200551; cv=none;
        d=google.com; s=arc-20240605;
        b=QMsTvkPlSWMsjVGyuJHKdh9gdpCXIYwRYl8b1fSAvhR+LWGOQWunTl8SftGY+gSfic
         2bb5fVHyD6ZYfQ82n7XmQckHkM7bq/jVbvbo8jjg/kvJ/vDuy6csOF2gVgnzk5sjPGia
         GXC4v/tmmgj+o26Rc4Onwb8bwSJJxCIuOAy7pOSX1cXtnVTGP6JxHNvciOfhclrvwNIp
         HABhhWkcXgEdvlk2comPj9pQnXlvdSslTXAn+tX4btxzQn+NigUJY+2TKM/hudOYJIAK
         W/4akAB6LqcvTsO+/QUxuLGNUxFb8o+BaVK9GPCoIbduhbFCdNQ4JHAqH1lNowAA+P2l
         3c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d0jpK130eOKxAU3spov1WU3b2naE9Ddz/5bAcQ0MTv8=;
        fh=CnGQmHHcqwJARuAmJ3BuP7P3rDPssO7V9T6T2Krjdms=;
        b=h2yLpwPqc5Zj+tIRxS03G0xSIR0FTi0SxTnKzFwAbVQ/FvhLeQ3TwHZlTDK5uSdkMv
         1uwNLK4SgmaI0/OQIl0W8KpyFlT2JuuwHhpF4LVHLHQQEqEa62Im4+sj8dH8xkmJ/Ha5
         Mr0cQMhwDV8CW4wNHN9fvZdwuSN+KXEItjGQR+CrLh11jOywmNbkaMtiknn4P4SkrJir
         zayTx+ZZjTNcO1rU7f2B9/+iNTenORH0trp/QwuyuJqg0D7cP6pElEx4W5oMZmKGUctU
         3sRcFcRIJXkEZOyVNrNq+hJsEraFiT2Y2Oz4bEurit4unPxXNbiJ2LFhQdduhr4n8N6W
         04nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767200551; x=1767805351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0jpK130eOKxAU3spov1WU3b2naE9Ddz/5bAcQ0MTv8=;
        b=b8VIPKwAqW3Fi6RYvgCR3254jOtRBqLCBB3zX8kATt4+iOEkwtZ0psizBou5yOosUx
         RFtXg8FQq8fj3JWoWratSJZ6NrQU0vlq5qgH27JSeyrWUhcoI5kDpPt8OJ6kCr3QmYyQ
         Q+2pvTtwXXbHnlVyeDUG9USReZw18Oqgle8yJcH406BiOnJ2zVFQzQnTQEkBNm9R8toI
         1ZGaTWAwLch+Z7VW1L5HsamLmuAy8MfL7yyIHXhpN7wj6cpH6ECqEhBI4zADThva2hr3
         RJlW7CtEH+zDWk2EeVa+ONr+ILrbentNxk0x/SdnPnpuj/7Gpjgcxuqca7eDpYdVa+OS
         VLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767200551; x=1767805351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d0jpK130eOKxAU3spov1WU3b2naE9Ddz/5bAcQ0MTv8=;
        b=eJf28gLyKuGQSEc6LIfoyfVIScBsV+wDjdSxKuPZkFCaWQ/57kXvVwjr+wFN/wkE4n
         RsLejLCnsPDjXE5HOyCi1aGYgsXH+//s1G33JcLVdthS+8l9O3wuIk2ZeRZa2MnlIKs6
         /Pg1Vol3QC8tcG6gS/7suYkEH0Jx2ULLBHUh5oViwCNJMiiglzQR25165bjMM2PTc5M1
         l5P3S89iVY+DyhI/yPbKGsvPf0q9HUMGEtts3nd64zAN8hmOnD99fFYbWVJpKCApetF4
         nsjncYPbY82cKxMAajWHkbDH1omjZ6uskwGYmFMl/t2oeedYDm3mnrjvWnZMCno7cHlB
         58Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWVOqP5j9K58mDeTMeKsZK7y5KMrs4CNZQC9zOl4spQWLQ1DexDiep5RoDaB2PY0S4xU9AxEfYasA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg316G9PhPlMZ3oULeZ3EqmWUXExeD8dQTie4Appxdpc5Vy1QA
	YLSfEcxoWn8dtD521ox0oMJzNP2emGWq9EbMHOvFXqnhUVuJ2PvzITmCb+61ktZIsGmi9nLggBE
	foz3Cad/XMMrJd5BYgvrlcudQ6ZeiR7GOw2DBMNeh+g==
X-Gm-Gg: AY/fxX6oCE3VeuCd3dnEExE3uWD+CXBf6tMONNvXS0GTcHPpf/eTXN6eLYobDa/aElz
	yTcCfnl+OhmKb2lqNXBym7WyhVXOYW+yzgy3IMbZZK8NHSWbNrZn/ex/KAWtYMRVJqcBfSOaRxV
	cR+mJEcxEsHLaEZB/AzmL222qqc/LFRpArqgSetCEcR4MY0ZEBxz7jVVQoeeXhhhVF5s0xaiilD
	giUjBiW+OBzqtJKPfZNrgQYZxud8bnK5z01RTlS5xCyDtIXS+YKqvaUDwpeAJXGrXDO1PAD
X-Google-Smtp-Source: AGHT+IFZaDqEo6Js3iMTg2q9hIsyQ0GQfn7ECMMLQRJj257QjrmPTbXS6jkIV+AYoaw4amu7mckhM78NkqYgMCKlHvU=
X-Received: by 2002:a05:7022:6291:b0:11e:3e9:3e97 with SMTP id
 a92af1059eb24-121723111fcmr18154261c88.6.1767200551098; Wed, 31 Dec 2025
 09:02:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-5-ming.lei@redhat.com>
 <CADUfDZqUbJz_05m63-p4Q7XpsM1V6f4oGMCaKmPcE_wzNJvNqA@mail.gmail.com> <aVUCsQ2fuOP_hfPF@fedora>
In-Reply-To: <aVUCsQ2fuOP_hfPF@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 31 Dec 2025 12:02:19 -0500
X-Gm-Features: AQt7F2qrpAFzz8OSL-MVLsuybMgxBuqGcFK1BXK3WgxAO4M0xen24lUUw79ojrI
Message-ID: <CADUfDZqwZQAkgS-Co=qmbKxiK1A0hoEP8XW0uHX_Z5M6tCDGMw@mail.gmail.com>
Subject: Re: [PATCH 4/5] io_uring: bpf: add buffer support for IORING_OP_BPF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2025 at 3:02=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Dec 30, 2025 at 08:42:11PM -0500, Caleb Sander Mateos wrote:
> > On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> w=
rote:
> > >
> > > Add support for passing 0-2 buffers to BPF operations through
> > > IORING_OP_BPF. Buffer types are encoded in sqe->bpf_op_flags
> > > using dedicated 3-bit fields for each buffer.
> >
> > I agree the 2 buffer limit seems a bit restrictive, and it would make
> > more sense to expose kfuncs to import plain and fixed buffers. Then
> > the BPF program could decide what buffers to import based on the SQE,
> > BPF maps, etc. This would be analogous to how uring_cmd
> > implementations import buffers.
>
> Yes, this way is too restrictive.
>
> I think there are at least two approaches:
>
> - define public buffer descriptor, which can describe plain, fixed, vecto=
r,
> fixed vector buffer, ...
>
> - user can pass this buffer descriptor array from sqe->addr & sqe->len (b=
uf descriptor
>   need to be defined in UAPI)
>
> OR
>
> - user can pass this buffer array from arena map (buf descriptor is just
> API between bpf prog and userspace)
>
> The former could be better, because `buf descriptor` is part of UAPI, and
> user still can choose to use bpf map to pass buffer. But defining 'buf
> descriptor' may take a while...
>
> The latter way could be easier to start...

I think the latter approach (buffer interface specific to io_uring BPF
program) probably makes more sense. Different programs may have
different buffer needs (e.g. 1 buffer, 2 buffers, an arbitrary number
of buffers). Programs that need an arbitrary number of buffers will
probably have to specify the address and length of a struct iovec
array in the SQE, or communicate via some BPF map. But this additional
indirection would add unnecessary overhead for programs that only
accept 1 or 2 buffers. Leaving it up to the io_uring BPF program how
to interpret the SQE fields makes a lot of sense to me, as
->uring_cmd() implementations already have that responsibility.

>
> >
> > >
> > > Buffer 1 can be:
> > > - None (no buffer)
> > > - Plain user buffer (addr=3Dsqe->addr, len=3Dsqe->len)
> > > - Fixed/registered buffer (index=3Dsqe->buf_index, offset=3Dsqe->addr=
,
> >
> > Should this say "addr=3D" instead of "offset=3D"? It's passed as buf_ad=
dr
> > to io_bpf_import_buffer(), so it's an absolute userspace address. The
> > offset into the fixed buffer depends on the starting address of the
> > fixed buffer.
>
> For user fixed buffer, offset is the buff addr.
>
> For kernel fixed buffer, it is offset.

Yes, good point. I think fixed buffers are usually described in terms
of user registered buffers (probably since those were the only kind of
registered buffers until recently). It wouldn't hurt to be explicit
that addr vs. offset depends on the type of registered buffer. I think
it would also be fine to just say that this is an addr for both kinds
of buffers, as you can think of kernel registered buffers as
implicitly having a starting address of 0.

Best,
Caleb

