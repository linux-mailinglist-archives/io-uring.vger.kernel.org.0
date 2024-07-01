Return-Path: <io-uring+bounces-2400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B61C991E1E5
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 16:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E57821C22F0F
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 14:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72D41607A1;
	Mon,  1 Jul 2024 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E52+c2QV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAE43144;
	Mon,  1 Jul 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719842997; cv=none; b=loBR0oxIaMSoPzLfz03AMImg0tbFdQb+ZO80kfm212QBXl247YMVedtklGVfgD1qWrGGgp4MMOJH/STs52G6N9C6xQcYj0TguPskDzHMToXSa/+Qc968kjA+z2dZ8UA+bWMFIpvtmHBdbE04PKUpDjSZ3AP7K03DE5USGa1SIlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719842997; c=relaxed/simple;
	bh=Mu557jmbD+ExV7JJyBBnKegVQdOMCnuxP9X7vG5s8WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i43LtQFBi/zJXTkYO22G97WHAi4EAngOLt5Ufmk6oXyHFXODxZJxxH3o6mgMuh/QlruK9IunRdXp9EhgDDQwRkN/XyS1y8RCsQUJWBW0kD7Bo1lnxhRV6SomcIqCKVMN8sF2LoY3LYUNwpsxylVLB9vhnihTrgUJEm4rc3ITKTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E52+c2QV; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5c444e7d18fso615050eaf.3;
        Mon, 01 Jul 2024 07:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719842995; x=1720447795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQHiKheUZkHn50AxjZouoKLxa6g4cpujt17k/BC4nOw=;
        b=E52+c2QVHTaHYP9bfC1Rc0CewUEE4YIidAG7qZHmMARs1ZgX5CCSfb1a7TFWzzTVEO
         4EX3Dc4GYp8FR1WioFO/qudUCRE4/AUAnViwmTd/XNgZhICAI+WUWCd4LA7GW9uccYUF
         bhwaLNEyLu8i8eAP9O8ejQAHJuESFf/Fv71AADhHYyhqLgyNYdVaUchKBnZJhWBajdoy
         X3rpBsLE86TKYqYSWly0p9NSKY0uJICVycekC0JA7YpAlKytZnG4lRHmSMr+IM61t/Xn
         K5HvskV8eRoRGSvp15VooOZxVg5Gevuko/gtU46tQvcfvDcBC+kag86p4Xg2MPtXOgp8
         Qu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719842995; x=1720447795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQHiKheUZkHn50AxjZouoKLxa6g4cpujt17k/BC4nOw=;
        b=RGD0zt+967Pin2Mj0qfTIioBXwU5zvA2/5jNnEGiZdFSV0NIfFlNwveCjvvjtceUwi
         hM/1xEm+R0V/4txZZ2PNlrANyOrFyzaAW/exOj4wldXw3wZv7g9wLigpcLieFYvvLYhq
         ANdUyD4hSMRDQF1yEhPVKtX/zbxw3fiNYx1ykATNMez2TsjNN/rPqhYI07eK72WfUApI
         LSHi0dpPU5KvmNIHPqVDgLS373Rw5i5rKS3flddNzYoHVsp9K+/QNrsFLFN0qkCVCbwU
         7yib/btv+ZKiDOE1f2yL64ve/6PFuo4fGrNQ+VzLqI8pyQ6aATIjvODZcj09wZ3m1ZU+
         jbBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxmiQsfc2ENCgtIX+zjqDjMcfM1FDeC58HQWezP6GomJXL8Wwlgg3AtShL1JZN/vlNjjFDXt4IAoCNeS/I4mB+SGs2O2HVsivkG6cUayt7o6UqHRnwO82Eg2S0vCVzBWlF7J2/mw==
X-Gm-Message-State: AOJu0YzmksxyhxNKlhAmsO4jJXhdo02nyxXc6A8r4S7gG5qvGdCCc2wr
	Yh6L/PWOqg6v0U+8VXtngJHXIWYTCZBb+9s+FvtO3Hj6Eyp2jaUa4C+qR9od57ka3O+l3XJ2N4o
	ZG2WkywF64+CezY02xJ4wnNhpMz0J8kk=
X-Google-Smtp-Source: AGHT+IE8TG4svOSi6+jhYYnyW+u67ovSQnNVXF3NuZm79i2x0GD967K06PjxyjiYGXymjIv5LSLiODSMfh0keRpyC1E=
X-Received: by 2002:a05:6358:2910:b0:1a6:a960:4787 with SMTP id
 e5c5f4694b2df-1a6acf43eb3mr630619755d.20.1719842994996; Mon, 01 Jul 2024
 07:09:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521@epcas5p4.samsung.com>
 <20240626100700.3629-9-anuj20.g@samsung.com> <87y16rmxnb.fsf@mailhost.krisman.be>
In-Reply-To: <87y16rmxnb.fsf@mailhost.krisman.be>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 1 Jul 2024 19:39:17 +0530
Message-ID: <CACzX3AtdWHCp7hCCMKyb-qkxFLZKFPn3qiib5W-=0-qtKSgbxw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] io_uring/rw: add support to send meta along with read/write
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, asml.silence@gmail.com, mpatocka@redhat.com, 
	axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com, 
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 10:47=E2=80=AFPM Gabriel Krisman Bertazi
<krisman@suse.de> wrote:
>
> Anuj Gupta <anuj20.g@samsung.com> writes:
>
> >  static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe =
*sqe,
> >                     int ddir, bool do_import)
> >  {
> > @@ -269,11 +307,16 @@ static int io_prep_rw(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe,
> >               rw->kiocb.ki_ioprio =3D get_current_ioprio();
> >       }
> >       rw->kiocb.dio_complete =3D NULL;
> > +     rw->kiocb.ki_flags =3D 0;
> >
> >       rw->addr =3D READ_ONCE(sqe->addr);
> >       rw->len =3D READ_ONCE(sqe->len);
> >       rw->flags =3D READ_ONCE(sqe->rw_flags);
> > -     return io_prep_rw_setup(req, ddir, do_import);
> > +     ret =3D io_prep_rw_setup(req, ddir, do_import);
> > +
> > +     if (unlikely(req->ctx->flags & IORING_SETUP_SQE128 && !ret))
> > +             ret =3D io_prep_rw_meta(req, sqe, rw, ddir);
> > +     return ret;
>
> Would it be useful to have a flag to differentiate a malformed SQE from
> a SQE with io_uring_meta, instead of assuming sqe->cmd has it? We don't
> check for addr3 at the moment and differently from uring_cmd, userspace
> will be mixing writes commands with and without metadata to different
> files, so it would be useful to catch that.
>
Yes, but I couldn't find a good place to keep that flag. sqe->rw_flags are =
RWF
flags and are meant for generic read/write. sqe->flags are generic io_uring
flags and are not opcode specific. Do you see a place where this flag
could fit in?

> --
> Gabriel Krisman Bertazi
>
--
Anuj Gupta

