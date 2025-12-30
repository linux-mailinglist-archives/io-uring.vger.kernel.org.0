Return-Path: <io-uring+bounces-11330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C14CEA783
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 19:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC7BE30049EB
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 18:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724382DC350;
	Tue, 30 Dec 2025 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JRLcchYa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC3124BBFD
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767119312; cv=none; b=lggQjeVD47/mG8q5tgT5KEsO/xFQP5PS/ZeGBihq1xiqe6TVL3oJkVws177vDK7fZOVOOdH6mm26wXuPZfblftLvIarflTBN+6lVFEvVC3ACa3b+dUlzJ5wZE2gE89DRJL9UuZjnlwJTer3ztoABjNAdu2h5ZgKi+VKNloteYDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767119312; c=relaxed/simple;
	bh=Z8uyNwrMAmdXUBfSck5135ChToRCeFmBe1299odNiiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJwmeE336vT5+/jK7DVbOM0CjhhMdSrqsKwr02W/GXSsl2tEcLW+NANanPO04pG3cwpIOzwhj51uQZ/JYSJ1NQVVCBxezrIX1snrllh52jYY1cgc0GKnf7X08eMlI8jqmz6w/Wg/DdtpYed67kDN5BF4drPt+SzDQs/s4pifBWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JRLcchYa; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a07fb1527cso25718955ad.3
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 10:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767119310; x=1767724110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8uyNwrMAmdXUBfSck5135ChToRCeFmBe1299odNiiw=;
        b=JRLcchYaPKmGZuLjXd0/WgmOt2JEZft8lX1LxFfpi80cFE/nQ/JcYDb+KKj/sATpW3
         NlrsXILe33ECxTvDcdgp+F/k5pCWDh1EE1sf2LaAyK5ggtAfalkOBzEIuRD35RtRmCLJ
         oAV9QRLrTj/ust5cldabo5GWujAFBOQVTqgrJkNtpICkwLb4m4QNEiKd7C/0TAk5/vOb
         KTHaJMycqM77efYwdlxmqv3+m2z0UM58GZ5O0C7JdoyxR8/0k7fpAxywM/R33F6ffDSb
         7rJf8TAaCvbDUgWqxyBXWDmPe0SsqSk/B0m6odr+6E6EuN2v7xOpx/JnwqCnJEdC7vSp
         wVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767119310; x=1767724110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z8uyNwrMAmdXUBfSck5135ChToRCeFmBe1299odNiiw=;
        b=VteCNJVRqlykMFbIi8orUOW6TJq6njcye/LcZazfK6iKdqBQibN1N6fepLziEUWDoJ
         Hnwm1IHg8tPFdkLiY5JSfH6zSaFZr4a7nGGJQrOwka3LHYS+olTuaJTkxgoBU3wudNAz
         tq5cjkz6q9qUf0IfvXpCBoTmQBAEv4VlAV6q1N6jO6ARtDUqamSl19G+f3PvBGljeju0
         q0yaBcwATmdC8KGVfNtGwE65cBIpbk8GAQ7ZipD8BuDdCBHdleWTT0FHR1Y2EbXueEkD
         UyLhIgfgLHG4vI9pAUglGlYAa8IiQvVvbdWBlp0mz42SgJaqkc2UgQQTQCBjTSvO3g69
         jHng==
X-Forwarded-Encrypted: i=1; AJvYcCU8PfVWHEWb6B7uWeRTs3HEDYRf6UfOwPfTzmhM1/CKK1z7O+C6mt17qHyxOXVN7e8HNDIoNGvbSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YylvrL9hHZ3jFspG8yHbGQ4SN5m3Fo2dLW/lmWCBHIcnV7gvjBm
	cXS0VHz9ez1tGD8BIm2ZD0Sa3aCjuUfFRu/Th0O+TiMK+Qt2trBhLx+sEK9KU+VryOXtP5o2OZL
	vQqH6leFLUK6GNMUykVmBlAVwjq0vQ4+i7Z+vO+xKNQ==
X-Gm-Gg: AY/fxX66MAh2QvysEgPIsAiEuRgCUW54lU+4DC1Q0XR+hyZ5TYi5MRkCgZYp7vl6sPp
	yCqKkIa8sP9lTrMczVll5lwmKaIrY4+RbLAf5wrHLi1FSEcbMcHYoEb2CmLV+2NbFTZ3gVza+EB
	NQGm2jimHKWRHdkc3Qh+jucIZ76F95TYANr5L+H92PUdaH+dazKgRRTxFK5LbsPnCWXFD0Y44Xp
	K5TPx/VkM+Elc2KNCimuPPDQGpCv25PNuUrwrdDyDU6Ye7OaKCIQwY6idcAY+6dGaMDtLIr
X-Google-Smtp-Source: AGHT+IHkVfbAj9boUODYdOpegecr25iA0S2cVTrxiSw805WRp4743seY0K7vD2D1SPE0UAgQ+SOv9nWzconuDGV9Vz4=
X-Received: by 2002:a05:7022:6199:b0:119:e56b:c3f1 with SMTP id
 a92af1059eb24-121721ad61fmr20511024c88.1.1767119309675; Tue, 30 Dec 2025
 10:28:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217123156.1100620-1-ming.lei@redhat.com> <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora> <aUNmrSVkZEMk7xmF@fedora> <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
 <aUn-sSrlD2gwkFTO@fedora> <CADUfDZpXNcBuA0Z6+btpw1M+iiyQV2KK0xx6FvHAqoUEMxwO1g@mail.gmail.com>
 <aUsbmGlQI9vC70IW@fedora>
In-Reply-To: <aUsbmGlQI9vC70IW@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Dec 2025 13:28:18 -0500
X-Gm-Features: AQt7F2oLYDRaOtUu7F_Nr5YBYCknyGYPU3QcLhMF3A1uFn_zHr4m0d3Bc6QDxAM
Message-ID: <CADUfDZqDRpYEn2JGdYtWwikdymayXop96hsWXBGzKfW=cxyN-w@mail.gmail.com>
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
To: Ming Lei <ming.lei@redhat.com>
Cc: huang-jl <huang-jl@deepseek.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	nj.shetty@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 2:45=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Dec 23, 2025 at 02:56:45PM -0500, Caleb Sander Mateos wrote:
> > On Mon, Dec 22, 2025 at 9:30=E2=80=AFPM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > On Mon, Dec 22, 2025 at 02:56:02PM -0500, Caleb Sander Mateos wrote:
> > > > On Wed, Dec 17, 2025 at 9:28=E2=80=AFPM Ming Lei <ming.lei@redhat.c=
om> wrote:
> > > > >
> > > > > On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> > > > > > On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > > > > > > The code looks correct to me.
> > > > > > >
> > > > > > > > This simplifies the logic
> > > > > > >
> > > > > > > I'm not an expert in Linux development, but from my perspecti=
ve, the
> > > > > > > original version seems simpler and more readable. The semanti=
cs of
> > > > > > > iov_iter_advance() are clear and well-understood.
> > > > > > >
> > > > > > > That said, I understand the appeal of merging them into a sin=
gle loop.
> > > > > > >
> > > > > > > > and avoids the overhead of iov_iter_advance()
> > > > > > >
> > > > > > > Could you clarify what overhead you mean? If it's the functio=
n call
> > > > > > > overhead, I think the compiler would inline it anyway. The ac=
tual
> > > > > > > iteration work seems equivalent between both approaches.
> > > > > >
> > > > > > iov_iter_advance() is global function, and it can't be inline.
> > > > > >
> > > > > > Also single loop is more readable, cause ->iov_offset can be ig=
nored easily.
> > > > > >
> > > > > > In theory, re-calculating nr_segs isn't necessary, it is just f=
or avoiding
> > > > > > potential split, however not get idea how it is triggered. Nite=
sh didn't
> > > > > > mention the exact reason:
> > > > > >
> > > > > > https://lkml.org/lkml/2025/4/16/351
> > > > > >
> > > > > > I will look at the reason and see if it can be avoided.
> > > > >
> > > > > The reason is in both bio_iov_bvec_set() and bio_may_need_split()=
.
> > > >
> > > > nr_segs is not just a performance optimization, it's part of the
> > > > struct iov_iter API and used by iov_iter_extract_bvec_pages(), as
> > > > huang-jl pointed out. I don't think it's a good idea to assume that
> > > > nr_segs isn't going to be used and doesn't need to be calculated
> > > > correctly.
> > >
> > > It doesn't have to be exact if the bytes covered by `count` won't cro=
ss
> > > `nr_segs`.
> > >
> > > The `nr_segs` re-calculation is added only for fixing performance reg=
ression
> > > in the following link:
> > >
> > > https://lkml.org/lkml/2025/4/16/351
> > >
> > > because bio_iov_bvec_set() takes iter->nr_segs for setting bio->bi_vc=
nt.
> >
> > But iov_iter_extract_bvec_pages() appears to only use iter->nr_segs
> > and not iter->count. I don't understand how it can get away with an
> > overestimated iter->nr_segs.
>
> iov_iter_extract_bvec_pages() does pass `max_size` for using iter->counte=
r,
> please see the only caller of iov_iter_extract_pages().
>
> iov_iter has to respect both two, otherwise it is a iov_iter bug.

I see what you mean, thanks for explaining.

Best,
Caleb

