Return-Path: <io-uring+bounces-9752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF9FB5378B
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 17:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FA4D188792A
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95AF334DCDE;
	Thu, 11 Sep 2025 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAcirdMh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F6A34DCC1
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603789; cv=none; b=FM0MpH8utrpvNLSydw0QZA4B6Bmw+y1Tq2BPgBC3seQGUY3q9nU2Wa0FLCdJ1R9CqMVrL8pxx/1pA6RxzgY4G6LZhexv2ix1iLd2LRooa0tnFFe0j8PXnXTdmXHdcx4axUhRTrCgLvEoIJ2NEWDEdFA8BVss5/fcudVPBfayg7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603789; c=relaxed/simple;
	bh=a4bwTTm8DDy1QIkTCmgQZy35/P1OSicCOauHAgByEfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCx8GXW3FhgROZ8SiYbqlKP0Ovpr/yDs5GnF26aJxOvYi76xR46MpUe9w6pucL+18N52PpggIpgOoxEz1E7pXJ+kNBcSmDOKMNL//ijSMw8DXuUCCHE/kJneV9o3F+zmI6c18C4MKpV+iyRteNt5WnPiKz7N8fZwRT6mnxnKGak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAcirdMh; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61d7b2ec241so1007903a12.0
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 08:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757603786; x=1758208586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wBo822YD+jvyd1+EsiFuVc9oA9ouix4aflKx2NsrPs=;
        b=AAcirdMh/paP8CvnwYN0WRwP/4NlghsmNdDHjiHYsSZrehyr7phxTUNvfxxxMzGgNh
         W/pumbX+m+DF3IUpX0y/CqFw8GzXNkN+mU45BXcxzFJAV1suGvKT9+Av2wIHMte4Fbqr
         fkyM++zQwG/21hMqVPKLgWVzQ1HdXnkxr/zRmqI+NbWV8s4QJiZjLS7OMY/kA9xkpYfh
         UoUFs26Jf4sZOmDuqhLPLzsjU9dwg2Bs3JhZP6pXEKSmsbzufxuIa7AlZCL/ROjutUu4
         YzhnAYHFzLSqSNDlFVAyYxvnjjses8MKw2zW5So/2vpnsSi+ogfx0J2Ukr5fUaQqA0MU
         xbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757603786; x=1758208586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wBo822YD+jvyd1+EsiFuVc9oA9ouix4aflKx2NsrPs=;
        b=bDPC+ujNaIT49o0qbRS9dviePPOE3anJaeUxVHfK7QVeTsGk/J+wRE4UWdLyUff6wR
         LaMEAONc+UwE/Un3vztWqavxXqpkcZEFP5dvcBcotLp3VwKQzkbd8f566gT2WhOOIejJ
         auNCG1M4MTKfPKahRNuX/12ubUQiUWRUefMhHXcSpkWwN7+1wQeAQKCsIaTgaBdWtU8J
         +pIE1yz7yV17mfp9/Cl3Kmpc5LHk+Guy5f2DZ74236uogQeD6tGMYzKYlR2sueLZokqn
         tK2v1wAvaR1CvwcZ7OeBLYMRm1rpFTkblHOr3gqHKtDERMNLrZp0p0hunHBzIMDLFLDD
         ONZw==
X-Forwarded-Encrypted: i=1; AJvYcCV2SjgMeHvLD5l62CFAFV4tjtGyGaTu0zXA91Q2tu9xR3xA37evMP52w5ExjFPQFQBP/INCBp5pkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcJbyY47BJ+N/siO9NqvDwWuT9ZP8DOYchdyZQP3Dp7AOX6wHV
	4OMKbl/hhuNcbTDxT+GTaKW0rjWyLIex3yEOxi6KffTbGgfA804B2D50n6iyITep8PStFgLybPw
	pJmnYHjMKfkHZFL0fefkFvsYFB+i6cWA=
X-Gm-Gg: ASbGncv1M8zypwWK+YEPs2ogVV8Dpv15kpciuGOOhn731cUTYTrDqc2CLe7EltBpU5g
	8md2N7IFYVpEjUwHtrwvy2qxHhec3OiWx+WytQ2ZJI5E+SxAvLUGi58drPA2oTOO6C5QI399EUc
	DBWY5NXs3ytDBWzHDU9WPtjHqBwT0d1ZSMB17lCNljGOPJdNwFOGLERyOMrcPaxSkWHNItfq7On
	kYN0cxnrnULD2wGvw==
X-Google-Smtp-Source: AGHT+IEWJHProfqe9MkMrApe0nu8Lni7uWBd5hMokDX8mM8AOlkDsbauNr0xucI3RgQ39BL1u0WyoFXJ+HknrvtHBLw=
X-Received: by 2002:a05:6402:2343:b0:61e:ca25:3502 with SMTP id
 4fb4d7f45d1cf-623771096b8mr18353367a12.17.1757603785655; Thu, 11 Sep 2025
 08:16:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-11-tahbertschinger@gmail.com> <aMLAkwL42TGw0-n6@infradead.org>
 <CAOQ4uxiKXq-YHfYy_LPt31KBVwWXc62+2CNqepBxhWrHcYxgnQ@mail.gmail.com> <DCQ2J75IZ9GN.29DY2W9SV3JPU@gmail.com>
In-Reply-To: <DCQ2J75IZ9GN.29DY2W9SV3JPU@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 17:16:14 +0200
X-Gm-Features: Ac12FXwWObOdteDLG_KWCcYb5SJCTz6npELP39lbmWonT28sMQmBU7w0_t-zMqY
Message-ID: <CAOQ4uxiQL9m2fBW6HhRkcsw=uBcU_YZT6Bs1KWw+Zppokar66Q@mail.gmail.com>
Subject: Re: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 5:10=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> On Thu Sep 11, 2025 at 6:39 AM MDT, Amir Goldstein wrote:
> > On Thu, Sep 11, 2025 at 2:29=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> >>
> >> On Wed, Sep 10, 2025 at 03:49:27PM -0600, Thomas Bertschinger wrote:
> >> > This is to support using open_by_handle_at(2) via io_uring. It is us=
eful
> >> > for io_uring to request that opening a file via handle be completed
> >> > using only cached data, or fail with -EAGAIN if that is not possible=
.
> >> >
> >> > The signature of xfs_nfs_get_inode() is extended with a new flags
> >> > argument that allows callers to specify XFS_IGET_INCORE.
> >> >
> >> > That flag is set when the VFS passes the FILEID_CACHED flag via the
> >> > fileid_type argument.
> >>
> >> Please post the entire series to all list.  No one has any idea what y=
our
> >> magic new flag does without seeing all the patches.
> >>
> >
> > Might as well re-post your entire v2 patches with v2 subjects and
> > cc xfs list.
> >
> > Thanks,
> > Amir.
>
>
> Thanks for the advice, sorry for messing up the procedure...
>
> Since there are a few quick fixups I can make, I may go straight to
> sending v3 with the correct subject and cc. Any reason for me to not do
> that -- is it preferable to resend v2 right away with no changes?

No worries. v3 is fine.
But maybe give it a day or two for other people to comment on v2
before posting v3. Some people may even be mid review of v2
and that can be a bit annoying to get v3 while in the middle of review of v=
2.

Thanks,
Amir.

