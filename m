Return-Path: <io-uring+bounces-846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDE787408D
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 20:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1E041F2474C
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 19:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3948A13E7D3;
	Wed,  6 Mar 2024 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAwDIzzZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F79E13F00C
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709753825; cv=none; b=IQbkmw/fMAh1njNnQxRJ/pz1ZRqEYuPMbKpKCQxxDntJH8tSE0o9O6gddPUqVd7WOPMRdjvdMaMICuasfIieQUBguVjO8j5yNecFXV/eCz/YAEw0G82ZTy1GcVdmtB6TGmz6HNRs1Yv5XAZUt50e+59WJj+K18HqOujdCRNRqlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709753825; c=relaxed/simple;
	bh=gG1P7fparXWEEa4cCqhdPeN2Pt1tIWjdX0zMm0O19zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e62Fw87vPFzL6i4wTmxFfrfNVfxV16yu5p5fRP956NltEIAfYzHChmrLqldxhV0Kg/TVQ/PMFUwPg0rVIw+SdKb4YAYrTQzxoFFD8CorJG0n9BOiUZ9IyEb/FZd3tj/4x78nLJ0+4iqhzH1+WTpJJY3OVv9jDpyTfCXaMAPHDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAwDIzzZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709753822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cDSstYzM7wKyX3GKgWmp6cFKoHBrzmJ4Emjzjf1dHCA=;
	b=KAwDIzzZgpOd/QVX4Gay7Qk42xxNY1WDSl8e1LDxPLAMA5NsCNrair+pKAXTMDWTn4YjUv
	OrjCYuzaWr1N+GEOkOvetvQ2l7tgdS2Kv9PqXDyc6ygdR8ah2eSwdipi5bIxvIeb01xNzp
	zXjK111XkMj2/YN3oX/4lMMdl3UFo8k=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-Aa3QbluaOuOdmOAsOMCVfA-1; Wed, 06 Mar 2024 14:37:00 -0500
X-MC-Unique: Aa3QbluaOuOdmOAsOMCVfA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e58ec82581so80816b3a.2
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 11:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709753819; x=1710358619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDSstYzM7wKyX3GKgWmp6cFKoHBrzmJ4Emjzjf1dHCA=;
        b=qMEkbBgW/v4WCyIpFpbuCongpnsc9QiWoaeaN9eu5PA4mGq4su4RzI8Hy9SCS9Q1SN
         UhQd2uwhcyWzxyTG3sGxQNAhdk3Uq67b6dbLI6gp2s2N/i8ZeTohvzcS3vPPMRwOO+qY
         AOW3tIOyXS64uNYSYCHqbtawzNT4JsAN9RoCzpRpCgaEgmzUN0Uin1KxnVt58suYolv+
         ZLZ56GTr2t1MZ9vssfFdqSDmNQpsnIwotW5hsWVzdBZGyWKP5KnDCnDVLIJCRn3HG2h2
         vHj/m5k89AiYyCjTD+cBwWgHn1BDnRHyskMr5yUpZrHRvQflzVBclOj5aiKzLSKbacww
         8RVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6YHiAobsIiZRApsk/jMm9OEoymvI1vFYcGh+ZqIKc0RbyWIL4jcrpEhM5cKWVZ3c3P78Dj5SmEzVJ39qv7n7Akomws/YLCVA=
X-Gm-Message-State: AOJu0YzlyoVXFB0jsFZ+xgSQRropGLkNU+s/FYB+9HaOWZXvV2L3fYTg
	ogQJNYvkn0WozIXZ3eAraa0JxTNnzjJr2x2xu5yCtVOnzEBRhTl7AFc7oa/wsBv4wTHSihq8jgi
	eExn6zQS3g/MD2jfpyiXQ6bfQ2NQqfAm1ec5Th3GcuRNCvoBiVzlS80qf
X-Received: by 2002:a05:6a00:2354:b0:6e4:5b96:a63f with SMTP id j20-20020a056a00235400b006e45b96a63fmr17476308pfj.30.1709753818640;
        Wed, 06 Mar 2024 11:36:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyj7lnU+rOTIvzfM7rcDfB/QEFQHlKo3UAFqiw1SvMhsvojkpmpLGyravlRm6p5ZggWdLxfw==
X-Received: by 2002:a05:6a00:2354:b0:6e4:5b96:a63f with SMTP id j20-20020a056a00235400b006e45b96a63fmr17476277pfj.30.1709753818052;
        Wed, 06 Mar 2024 11:36:58 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t26-20020a62d15a000000b006e04c3b3b5asm12000394pfl.175.2024.03.06.11.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 11:36:57 -0800 (PST)
Date: Thu, 7 Mar 2024 03:36:54 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] fsstress: bypass io_uring testing if
 io_uring_queue_init returns EPERM
Message-ID: <20240306193654.n6tztubknjlsx2ub@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-3-zlang@kernel.org>
 <20240306155526.GB6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306155526.GB6188@frogsfrogsfrogs>

On Wed, Mar 06, 2024 at 07:55:26AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 06, 2024 at 05:19:34PM +0800, Zorro Lang wrote:
> > I found the io_uring testing still fails as:
> >   io_uring_queue_init failed
> > even if kernel supports io_uring feature.
> > 
> > That because of the /proc/sys/kernel/io_uring_disabled isn't 0.
> > 
> > Different value means:
> >   0 All processes can create io_uring instances as normal.
> >   1 io_uring creation is disabled (io_uring_setup() will fail with
> >     -EPERM) for unprivileged processes not in the io_uring_group
> >     group. Existing io_uring instances can still be used.  See the
> >     documentation for io_uring_group for more information.
> >   2 io_uring creation is disabled for all processes. io_uring_setup()
> >     always fails with -EPERM. Existing io_uring instances can still
> >     be used.
> > 
> > So besides the CONFIG_IO_URING kernel config, there's another switch
> > can on or off the io_uring supporting. And the "2" or "1" might be
> > the default on some systems.
> > 
> > On this situation the io_uring_queue_init returns -EPERM, so I change
> > the fsstress to ignore io_uring testing if io_uring_queue_init returns
> > -ENOSYS or -EPERM. And print different verbose message for debug.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  ltp/fsstress.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 482395c4..9c75f27b 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -762,12 +762,23 @@ int main(int argc, char **argv)
> >  #endif
> >  #ifdef URING
> >  			have_io_uring = true;
> > -			/* If ENOSYS, just ignore uring, other errors are fatal. */
> > +			/*
> > +			 * If ENOSYS, just ignore uring, due to kernel doesn't support it.
> > +			 * If EPERM, might due to sysctl kernel.io_uring_disabled isn't 0,
> 
> "might be due to..."

Hahaha, as native english speaker so :)

> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks, I'll change below if...else... to switch... as you suggested.

> 
> --D
> 
> > +			 *           or some selinux policies, etc.
> > +			 * Other errors are fatal.
> > +			 */
> >  			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
> >  				if (c == -ENOSYS) {
> >  					have_io_uring = false;
> > +					if (verbose)
> > +						printf("io_uring isn't supported by kernel\n");
> > +				} else if (c == -EPERM) {
> > +					have_io_uring = false;
> > +					if (verbose)
> > +						printf("io_uring isn't allowed, check io_uring_disabled sysctl or selinux policy\n");
> >  				} else {
> > -					fprintf(stderr, "io_uring_queue_init failed\n");
> > +					fprintf(stderr, "io_uring_queue_init failed, errno=%d\n", c);
> >  					exit(1);
> >  				}
> >  			}
> > -- 
> > 2.43.0
> > 
> > 
> 


