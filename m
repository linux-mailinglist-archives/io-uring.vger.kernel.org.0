Return-Path: <io-uring+bounces-10056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C32BED1FD
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 17:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4B6B4E5C29
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 15:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6781B4223;
	Sat, 18 Oct 2025 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6ME7jkG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F67450F2
	for <io-uring@vger.kernel.org>; Sat, 18 Oct 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760799967; cv=none; b=UP/Y+314LS8wUv0/s0mjbypxl2ulxxO3hqQFLIvUvhZ99pYotpBfwQTIXNsI+o/AMbfHEC5GHmLY8QWvQ5y2wMmxTOBPodoMOXfcsIEhVqT0pqA/PnyP6coltlZ3PmJ6vw4xyZ4zyaFx8dualVQJ3tsZNVMTMhX8B8pxjBcWjiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760799967; c=relaxed/simple;
	bh=ZyvjCPO/DXVQM8YwuZEJD0JqI8HSEb46tVTufAtomWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fy83+0itLubxdQrl3V7YB0J7d0TVV6VNdHrJtBBceNrsq6JV37pCQiBQA9asGc8rclE6beeZCxI7fcOWd6npNb0rOmvnkyfWbqnuwz7Mvo5y9kvc8aQiCCcYERKAnfFDsrWL0zvQvogjmgdjeX6e6uRB9SZFtbd3GDqAQDUZ5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6ME7jkG; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-58b027beea6so2528e87.1
        for <io-uring@vger.kernel.org>; Sat, 18 Oct 2025 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760799964; x=1761404764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSPOiZ7jNcagXuc9lWkglLdnTNQHlNGICFG0e3VfcRw=;
        b=Q6ME7jkGsm6mkgeROvptigGebUJofPQIBPkJZyGsxHgnTqfPuzCWoGOkOLpVWyhk+s
         qDpRrX0CsfdOznkp45d5JQBBBbeelXxm76/ZjBYTQ2kdiDFmRApJ9eOtYkYaBzfVJnwT
         qd2aoLatCZkf+GQO6/a5NZbTkXzgbZHE0pmWCGYoSABnl798V+xDMhLgxU8PnJFecFLj
         q2XCuq9TmANzKzwo+daHXKsxpZXZaHrlcxGLTDUt20szV53Yy7UqSWJ6BbjzQ5Fe7l7J
         fh4B2V8LA7EtMQ5g5L85MCzKmO9gruOZFa383QsMXfrwaAFgd42yAHhz51ue+LqbhvY9
         nyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760799964; x=1761404764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSPOiZ7jNcagXuc9lWkglLdnTNQHlNGICFG0e3VfcRw=;
        b=BajbLAle+xi8BhasbzKZBdEyGUY59ie030rITBi+Y64bempT9+RC9onCSHfutBN/oj
         J+wM8gYbryZcxy9Ue/HP0OaZOFOIEnlSQJ/W2lwWVBf8WBaT1rtXv1KTsC3U45hHJ9nH
         V3q2/BbG3O9uwl+oEJtR9K6MZsydksrYd0t0HQvdTnlND25ZyEvdMQazMbSzSL6MrT2M
         jZNZTj3lC0+pcKIxNGqHEQ3heGNKtowF7mjsxddaiz+1/a9bFDeKh3qlBYOYozifYovv
         C7vrlz6YxgnUBRv5Jpv31ZXxxQcxJCADUW8+DY9Xa/w953tQKtp5M+6KtI5Mz6fUYYXW
         tNQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXw3lc5YmQ2D/ClXqR8rp+jFGh5BD2RVKB03T9+J4mVPwB0zJ2YVnVGxSUuwwFGXpkgFwBYZ00Cqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyllK2o/62lGQxG9qsJiRs8qn89t/GdeFq4nvRStO/CcGpM6qHK
	sgFqu514Z67PDres0ikHpZuaBzrZf4vR8VzzPC/aN39gMU+Mql6aiRzGuFJgIoURn/He9o8GoNF
	FYwIlwbMLBJTnmemp7YMtJExSO3SAsSloVC8e9Uyd
X-Gm-Gg: ASbGncuhLmyvVnRbK9veUrWINZCJxzG5bNw5qsMEGNUMZtUppgUBqpklwRRpX+Y6Re2
	6IuAp84D8HLqfil2uKVyYS88vqIbky63ukbChOymlvQnJIVFcfuuX6ZqOrTyRy+lURd/FpvBaZG
	JoBFjEshobVAlSFywcnAn5dG87zi2zuaDZipys7hm/pWs9IICryYIj9e6IKI1vRDpThRHWP6HSf
	87bTB2Rsk/hWkzc/HALNdQjNpAnB0fVO40xfukMDpOJymLPeMm8KyKYgIYojQ==
X-Google-Smtp-Source: AGHT+IFcaG2diqMxOqusH9IIiQ6tzpbrJgmvAJveAGN983bDcWLIVWyiyO0L7LLJDKrl11UqMQ6S9cxZtA1TVs4J73o=
X-Received: by 2002:a05:6512:38ab:b0:591:d413:57fd with SMTP id
 2adb3069b0e04-591d4135be6mr718612e87.4.1760799963225; Sat, 18 Oct 2025
 08:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016063657.81064-1-byungchul@sk.com> <20251016072132.GA19434@system.software.com>
 <8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com> <CAHS8izMdwiijk_15NgecSOi_VD3M7cx5M0XLAWxQqWnZgJksjg@mail.gmail.com>
 <20251018044653.GA66683@system.software.com>
In-Reply-To: <20251018044653.GA66683@system.software.com>
From: Mina Almasry <almasrymina@google.com>
Date: Sat, 18 Oct 2025 10:05:51 -0500
X-Gm-Features: AS18NWCdRnTpaOE-ua3r-9Us5t5kUAoflf6Cc1Wzwirr87rmZDAh12Y2B710qzk
Message-ID: <CAHS8izPeFvTNPTAqmfkAxR9aKd00HW-G45r77Ex16QQSjfQibg@mail.gmail.com>
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
To: Byungchul Park <byungchul@sk.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk, kuba@kernel.org, 
	pabeni@redhat.com, davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	hawk@kernel.org, ilias.apalodimas@linaro.org, sdf@fomichev.me, dw@davidwei.uk, 
	ap420073@gmail.com, dtatulea@nvidia.com, toke@redhat.com, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kernel_team@skhynix.com, max.byungchul.park@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 11:47=E2=80=AFPM Byungchul Park <byungchul@sk.com> =
wrote:
>
> On Fri, Oct 17, 2025 at 08:13:14AM -0700, Mina Almasry wrote:
> > On Fri, Oct 17, 2025 at 5:32=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> > >
> > > On 10/16/25 08:21, Byungchul Park wrote:
> > > > On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
> > > >> ->pp_magic field in struct page is current used to identify if a p=
age
> > > >> belongs to a page pool.  However, ->pp_magic will be removed and p=
age
> > > >> type bit in struct page e.g. PGTY_netpp should be used for that pu=
rpose.
> > > >>
> > > >> As a preparation, the check for net_iov, that is not page-backed, =
should
> > > >> avoid using ->pp_magic since net_iov doens't have to do with page =
type.
> > > >> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs=
 to a
> > > >> page pool, by making sure nmdesc->pp is NULL otherwise.
> > > >>
> > > >> For page-backed netmem, just leave unchanged as is, while for net_=
iov,
> > > >> make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for=
 the
> > > >> check.
> > > >
> > > > IIRC,
> > > >
> > > > Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> > >
> > > Pointing out a problem in a patch with a fix doesn't qualify to
> > > me as "suggested-by", you don't need to worry about that.
> > >
> > > Did you get the PGTY bits merged? There is some uneasiness about
> > > this patch as it does nothing good by itself, it'd be much better
> > > to have it in a series finalising the page_pool conversion. And
> > > I don't think it simplify merging anyhow, hmm?
> > >
> >
> > +1 honestly.
> >
> > If you want to 'extract the networking bits' into its own patch,  let
> > it be a patch series where this is a patch doing pre-work, and the
> > next patches in the series are adding the page_flag.
>
> Okay.  Then is it possible that one for mm tree and the other for
> net-next in the same patch series?  I've never tried patches that way.
>
> > I don't want added netmem_is_net_iov checks unnecessarily tbh. These
> > checks are bad and only used when absolutely necessary, so let the
> > patch series that adds them also do something useful (i.e. add the
> > page flag), if possible. But I honestly think this patch was almost
> > good as-is:
>
> Hm.. but the following patch includes both networking changes and mm
> changes.  Jakub thinks it should go to mm and I don't know how Andrew
> thinks it should be.  It's not clear even to me.
>
> That's why I splitted it into two, and this is the networking part, and
> I will post the mm part to mm folks later.  Any suggestions?
>

I think 1 series with all the mm and networking changes targeting mm
and Cc: netdev@ would work (and lets see if Andrew prefers something
different). The networking changes are very small.

--=20
Thanks,
Mina

