Return-Path: <io-uring+bounces-6110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 329E2A1AFDA
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 06:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 523CD16D624
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 05:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6C01D61A7;
	Fri, 24 Jan 2025 05:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkoQorUv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568CA1D5CF2;
	Fri, 24 Jan 2025 05:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737696301; cv=none; b=mCBWH21H4jGrQy3/r4NodK5CeAD34DrdPKegebHSRbGWy3tR0NTvY692NQ+sLV1i/k8JAdByyz3A2Zt9BpVTnJcRBHIsZizUb0LzGR6SRkQcZOVMEm+12J3so0OQLiuDxmDhvS+TRblc+IXPBiAc2ZgXEgPZogThkOiTkb7eX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737696301; c=relaxed/simple;
	bh=wUsnlwYFTdc+MvnuZ8vrb+p4T3M2yRpjztiGdhiJh7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGk6CtlhjnVsxwM4E4AFFIyGLMr3VrXWNnqJ+ALPGe/qsIR2dUuhtBcOqkVCFoLcovh3TheavQWYT3SMPzNG79lHaPIpi1Z7Ldx44aizNUk2wtqob8h8K8AzvD2BbRhXmL0xMR4FwKu9WYVWfq0dpMcqWayW2MCbfsDfHz3zHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkoQorUv; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so2785400a12.1;
        Thu, 23 Jan 2025 21:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737696297; x=1738301097; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fKweFn49YcSgRl7XNnglleppGHVhMNQ1QlteyLFd6Fg=;
        b=YkoQorUv/d9Yj3MoWiZVDmQzZFPmwO0dq1DYElVOWBhjqO8rqhZwCvdMeRyCmvWjao
         3iMO5A7aupT85d3ZhdAqxho0M4Z8M6h2M05nLXn64W61KGUfs2T+VYvjYl3GaSPmVfK/
         ywVxQJ5bFrAw9fRShlAp23i10sczo1cc1riGTW4e0RpaoI6Q/3FZHBXONWCDnmVCrzIj
         dsnNcokNPipYU40BQ+m4exsK/cle6/0M/VPdJxUbd5cFxYEEx+6zUVlF82baJEeUZ3NB
         Fx51o9xKtnz22eD2+omPgzIwxDbYvCYHvmiHqPLdyvFaQhmfuHue8x3JEr/ARUiIUfvH
         wASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737696297; x=1738301097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fKweFn49YcSgRl7XNnglleppGHVhMNQ1QlteyLFd6Fg=;
        b=IJt2g3SuV8j98JlBUjdujGvKNliYLGxJ36UZqchvZTR9mPPMHBrrP3JL1/Bg8WkL6S
         Hu8y+Yn3Bqg1IeopaTZdvQUJbIgztW0qB1NI4fEAYCLcFnBYu8Pa/aVxMY11deDkd+wh
         vfGYzexrYwJiuSJkmz/zuQbKt5ZFl3rToYq035NSkw83fr0ecRxt+N6WvogXiL5V1VnH
         jCNgUWc1sqKI2ppkL66TjskyVQkjFPxM5Rqd4zuxUurE5xdLLv69XkApj9u7cZyZaj/d
         S7eGGaTfW9QlWwxcdWWv8grVL23oMee/CCNE42fXkSjcfl1xvr9BG82Ib3xIo57qsrGL
         vQ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4yMSXkEF06V+ZHPxUPkQoBXVCa3T/1FP6gNh9LKMVAiud3dB3GIFM1Xc2zrNwMgWw2zjX6CuN2A==@vger.kernel.org, AJvYcCXwDeOWIGVK5+CrEHg9VcEG3Xk+dS6g2POIKQ4Ak43N818vnyz73DPx9KsqSTuUFRv5qPSHrazFj51UKIUG@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo0GSeYAd2kkfcl4sEGWe+iRSenRP5MHPN1pQX9YPIG+LqViqe
	WlHiW45sEoyKrNhIF/nArR/JafJ+qhJAurQ8sfm4jRDA32IYZQas
X-Gm-Gg: ASbGncuxbVeCJWbgZ4aT9uARVZwmCGrroH5DQXH8DsFC0F2VVyN6KlawIwD1JD+lQcF
	l3T9Eh4pYzKtCMff0QRm/edVnvfmixXhP2QKNTmn+RM5R7HQRKeOB1NCjU6ufZiEfplMLDxlhX5
	FEhKQI36q6Ob4Or+NVM4oN34pS3O3bPBvIDqjup+20LIxglA1zzUotAgvSK5HfIoP83CgaLIbqr
	WbpREx1hZdq/pB6wjsr0kvPBNQ1fLUd9nWTrrGJvox7VFKfssyaVDJiqdEyTaS4z8MZjEuN7+cW
	y71PDQAbAIXJF3VLzrJIl0VSc/Xau4HWovgp6Q==
X-Google-Smtp-Source: AGHT+IE9HFq7mNLOm/QvCIMuTTT0B1SRwpLbjCALcY22IM2Vh1Rb9eDeebeyEpJBRTvY320BIsVPVw==
X-Received: by 2002:a17:907:9408:b0:aab:daf9:972 with SMTP id a640c23a62f3a-ab38b29cf07mr2500248266b.28.1737696297229;
        Thu, 23 Jan 2025 21:24:57 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760b76acsm65810666b.113.2025.01.23.21.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 21:24:56 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 435E1BE2EE7; Fri, 24 Jan 2025 06:24:55 +0100 (CET)
Date: Fri, 24 Jan 2025 06:24:55 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
	Jens Axboe <axboe@kernel.dk>, Bernhard Schmidt <berni@debian.org>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
Message-ID: <Z5MkJ5sV-PK1m6_H@eldamar.lan>
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>

HI Pavel, hi Jens,

On Thu, Jan 23, 2025 at 11:20:40PM +0000, Pavel Begunkov wrote:
> On 1/23/25 20:49, Salvatore Bonaccorso wrote:
> > Hi Xan,
> > 
> > On Thu, Jan 23, 2025 at 02:31:34PM -0600, Xan Charbonnet wrote:
> > > I rented a Linode and have been trying to load it down with sysbench
> > > activity while doing a mariabackup and a mysqldump, also while spinning up
> > > the CPU with zstd benchmarks.  So far I've had no luck triggering the fault.
> > > 
> > > I've also been doing some kernel compilation.  I followed this guide:
> > > https://www.dwarmstrong.org/kernel/
> > > (except that I used make -j24 to build in parallel and used make
> > > localmodconfig to compile only the modules I need)
> > > 
> > > I've built the following kernels:
> > > 6.1.123 (equivalent to linux-image-6.1.0-29-amd64)
> > > 6.1.122
> > > 6.1.121
> > > 6.1.120
> > > 
> > > So far they have all exhibited the behavior.  Next up is 6.1.119 which is
> > > equivalent to linux-image-6.1.0-28-amd64.  My expectation is that the fault
> > > will not appear for this kernel.
> > > 
> > > It looks like the issue is here somewhere:
> > > https://www.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.1.120
> > > 
> > > I have to work on some other things, and it'll take a while to prove the
> > > negative (that is, to know that the failure isn't happening).  I'll post
> > > back with the 6.1.119 results when I have them.
> > 
> > Additionally please try with 6.1.120 and revert this commit
> > 
> > 3ab9326f93ec ("io_uring: wake up optimisations")
> > 
> > (which landed in 6.1.120).
> > 
> > If that solves the problem maybe we miss some prequisites in the 6.1.y
> > series here?
> 
> I'm not sure why the commit was backported (need to look it up),
> but from a quick look it does seem to miss a barrier present in
> the original patch.

Ack, this was here for reference:
https://lore.kernel.org/stable/57b048be-31d4-4380-8296-56afc886299a@kernel.dk/

Xan Charbonnet was able to confirm in https://bugs.debian.org/1093243#99 that
indeed reverting the commit fixes the mariadb related hangs.

Regards,
Salvatore

