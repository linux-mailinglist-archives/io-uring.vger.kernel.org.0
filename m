Return-Path: <io-uring+bounces-11298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD57CDA6F1
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 20:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0808F300942D
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 19:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346812EB5A9;
	Tue, 23 Dec 2025 19:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZdHoOiz+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B8199EAD
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 19:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766519820; cv=none; b=gwkRlEUkTauyk9CCeNGADO+590cFw/VoprcX5kCQ4VGqYLJ+YkWPXPrQH5MXp7+h/MXWMw5xv/jzK050OEpsdooiZZVHLS0bgLoOyNbwH+k2otQ55z8D0G7hOdzNsORvKtGpGCnbJOfJfrVVgEXNPIzHPlZrc8fF1RkOSnl0Odk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766519820; c=relaxed/simple;
	bh=q7wfyKzbRMbDvk9WjRLwEIppG3WoOQQQ54ixBfO4ics=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gNwvaN5+/WPRsKoWo3SYivQJ2nEnasdlw/+61N01jK3JTBKY7Q6eP9AeXoNqt1Q755PLtrY4K8h27LtLLQ8ylXzBTGxAZ2ME7JNGAexTaKNEdxaCPI+vjHnhEJ02hLa1AKDytMklt/0NteDfZ19K6H3VHLsLRJM3jnIBi2iGijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZdHoOiz+; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ab689d3fa0so430881b3a.0
        for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 11:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766519818; x=1767124618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7wfyKzbRMbDvk9WjRLwEIppG3WoOQQQ54ixBfO4ics=;
        b=ZdHoOiz+xC3u90ITpTqqjh8abf/Sun5VQNqH2Owcqlol+d53Lns/4rFHkzXbIZc1//
         tnSktDOMjh0LrmS9ivTUSVCXJP6VxL0b9GR3kgEWqi0wNYysYrkSfVuQL5Usxw6M3w1k
         WWvkuNoTxF0cj9M4ow5YBMrDihMdGG5LteOjrEt0BNxJPAgIBH3uwkri+3890NF9V6Tv
         M4qLz3RvbnMmgntsrDSrufEn12aUtFMLJ2MgP4jtTA9Nzf/IK9pxhhiCgjigi8YWRBK9
         IsbXmQw7Ia8UvFNWx3nPklDIgGBQ1rGITvKKeeiDTD9kwKoiR1/lyncBSRvXFL9PONy1
         oepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766519818; x=1767124618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q7wfyKzbRMbDvk9WjRLwEIppG3WoOQQQ54ixBfO4ics=;
        b=SFXT32QNc22x3DLSywy0Mu3sGqZ7Wik10mv99h3CXK7TH0IgVP1t5rd6Y3OSOIa+aC
         R9pgqSqUZHCAOVS3EFjilmKeEkVuR06oXxOWNgAfJYxYkJTo3n2T9/hooNBqxkgfIvd/
         VkUKnkQAFniQzkPPpaiaQnMZxEAgjZPrCTxsQDuRtYQEJ6b33i8/RU1Rm/OViBkJaSOb
         TW5qtwqrJPvJ0KS0HHwN9/uNLk5UMgpfCd3O+grQYPAsbmmRUv1msSVDxI8NrLK+q4cU
         sBV4tKZuE92dy6iffe3EqrTu6NTXX4tolViGbmB83I6+CWZdtrQPhZh7m2HoLhOwCydU
         DqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx4hc4MG5LHcjon3uazD7vwSkX/Vj2h3exloFFG5DB0BkE8a5TvbHaGcchSspcQn/0gC1othjsgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvhuQieerA1GMKA4YHhA3ShQTjRvNlV6rRCkVj8SnSk5oYJhTK
	edcKxN1aMAGGYvFr68MvzZQuBKFoA2smh+MFfWPKyP42u57NsE5FJayCvmbCH1VjSuuB5//phKb
	1tm3Ns3h90VYHrzNTDJFFYGAJiWA1KWIdRcRyCwolMA==
X-Gm-Gg: AY/fxX7DIkWN8dOgiFPFgxHHnmEpl1hygsJIN148SL0249fm8F1axFXdrjFRJvAVD8I
	xkUGyvThJPMF1nvGlF2dGd26uLceUStldtNMm8b9Y1VeKlFFGH8A/TJ5UVEqGFTH5qPEFyrdm2j
	A3blUa6mYvhMHD97hu5btA0IiaqU41vI0xAsILiSK3ozKlFmRzlK7ZQ0SlJLidVmASidjHTBkPO
	ks7h8uru48mGki9m93fJQoy+vIW3IYOlLA8iBOFNvdrh3L2+RITurbBTfQBKTvnEfiFt0U=
X-Google-Smtp-Source: AGHT+IHp3+aT9sVgn0YHJAKW+CipKjGD4eScKnLVzGcMEhDgYJfX9DzNlOVo/L+XGWKt6FV9RpYkRR2UIhN2YwyxRZE=
X-Received: by 2002:a05:7022:e1c:b0:11b:acd7:4e48 with SMTP id
 a92af1059eb24-121721ab805mr10762422c88.2.1766519817497; Tue, 23 Dec 2025
 11:56:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217123156.1100620-1-ming.lei@redhat.com> <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora> <aUNmrSVkZEMk7xmF@fedora> <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
 <aUn-sSrlD2gwkFTO@fedora>
In-Reply-To: <aUn-sSrlD2gwkFTO@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 23 Dec 2025 14:56:45 -0500
X-Gm-Features: AQt7F2r5G_L-q1XPV3Yi1bv4GSHVWUR1-3IablcxYEg3Q3F3MVxOitrfocrZ8YU
Message-ID: <CADUfDZpXNcBuA0Z6+btpw1M+iiyQV2KK0xx6FvHAqoUEMxwO1g@mail.gmail.com>
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
To: Ming Lei <ming.lei@redhat.com>
Cc: huang-jl <huang-jl@deepseek.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	nj.shetty@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 9:30=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Mon, Dec 22, 2025 at 02:56:02PM -0500, Caleb Sander Mateos wrote:
> > On Wed, Dec 17, 2025 at 9:28=E2=80=AFPM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> > > > On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > > > > The code looks correct to me.
> > > > >
> > > > > > This simplifies the logic
> > > > >
> > > > > I'm not an expert in Linux development, but from my perspective, =
the
> > > > > original version seems simpler and more readable. The semantics o=
f
> > > > > iov_iter_advance() are clear and well-understood.
> > > > >
> > > > > That said, I understand the appeal of merging them into a single =
loop.
> > > > >
> > > > > > and avoids the overhead of iov_iter_advance()
> > > > >
> > > > > Could you clarify what overhead you mean? If it's the function ca=
ll
> > > > > overhead, I think the compiler would inline it anyway. The actual
> > > > > iteration work seems equivalent between both approaches.
> > > >
> > > > iov_iter_advance() is global function, and it can't be inline.
> > > >
> > > > Also single loop is more readable, cause ->iov_offset can be ignore=
d easily.
> > > >
> > > > In theory, re-calculating nr_segs isn't necessary, it is just for a=
voiding
> > > > potential split, however not get idea how it is triggered. Nitesh d=
idn't
> > > > mention the exact reason:
> > > >
> > > > https://lkml.org/lkml/2025/4/16/351
> > > >
> > > > I will look at the reason and see if it can be avoided.
> > >
> > > The reason is in both bio_iov_bvec_set() and bio_may_need_split().
> >
> > nr_segs is not just a performance optimization, it's part of the
> > struct iov_iter API and used by iov_iter_extract_bvec_pages(), as
> > huang-jl pointed out. I don't think it's a good idea to assume that
> > nr_segs isn't going to be used and doesn't need to be calculated
> > correctly.
>
> It doesn't have to be exact if the bytes covered by `count` won't cross
> `nr_segs`.
>
> The `nr_segs` re-calculation is added only for fixing performance regress=
ion
> in the following link:
>
> https://lkml.org/lkml/2025/4/16/351
>
> because bio_iov_bvec_set() takes iter->nr_segs for setting bio->bi_vcnt.

But iov_iter_extract_bvec_pages() appears to only use iter->nr_segs
and not iter->count. I don't understand how it can get away with an
overestimated iter->nr_segs.

Best,
Caleb

>
> >
> > I think this patch is a definite improvement as it reduces the number
> > of assumptions about the internal structure of a bvec iov_iter. The
> > remaining assignment to iter->iov_offset is unfortunate, but I don't
> > see a great way around it.
> >
>
> The re-calculation can be removed, please see the following patches:
>
> https://lore.kernel.org/linux-block/20251218093146.1218279-1-ming.lei@red=
hat.com/
>
> Nitesh has verified that it won't cause perf regression by replacing
> bio->bi_vcnt with __bvec_iter_bvec() in bio_may_need_split().
>
>
> Thanks,
> Ming
>

