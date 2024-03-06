Return-Path: <io-uring+bounces-847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1109C874095
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 20:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C7B6B210A7
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 19:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6AC140360;
	Wed,  6 Mar 2024 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Okevkc+H"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FBF13E7D3
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 19:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709753941; cv=none; b=lb+H7PZj3V1X4Bn5Y09IG9FdrqiHpku8hd7EWPEoMcqxuDhJ0FeGy104aUsL96TJW5aSvIitk6NnTsFvV8YAPm4A7N1EhpJgm47up6eY5r+KtGiI7tOGK45RpPPmMD3nwpQQa0udKVvCyOMFoXDaVE1M9dBm9B0GYaRm8cotCgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709753941; c=relaxed/simple;
	bh=rOkXvC/2O3BJs8QT2acVqFPP10yE4TuK9fL6MCvN44o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5OR+wwXrpIvxivcLXN0tDox3EJTZKGWVWBwHNlVvlpLcCslfLM9W4bDPtZ0B3XfmzKG+axdDGHpAjqGDUyooYSc6fkK2dQYQAHXLHaEbphB4j001lhk16XMC/CKpF1tXyXFpNRSiw28XlRJ4I4fnf4n18i+6U/G2PEAWFFw0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Okevkc+H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709753938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P89CM40iIZfCeQn9OYPtlN2D3LAieBdJkB2PwXlwjMg=;
	b=Okevkc+Hv2HbY5b04TJ4pGXi6G06Z8YGf3EKdA6u9iPd96hcjwMnW+8qI8OJpf9b26vPC6
	Mh89z5kjg4U7MeK81MuOgmAxBdI26PP278u7Zlmqc01PT7QMQO+CDtE1lpRQLzvu0RLEWw
	A22SkNvLpPQt57s3Guv0Qz7cMZXc3DQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-35IuRhy0MT6JeEk2vIMKzA-1; Wed, 06 Mar 2024 14:38:57 -0500
X-MC-Unique: 35IuRhy0MT6JeEk2vIMKzA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5dca5c631ffso45057a12.2
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 11:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709753936; x=1710358736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P89CM40iIZfCeQn9OYPtlN2D3LAieBdJkB2PwXlwjMg=;
        b=ecdd03jvOx4xmTHdt8Pkvg8YzinZOe0gc4Wzem/644htvlHAFk+0VsH1zM4Q0K4YOf
         nTzhdfDbmEmh9cGedSh8C2J5ds+rSumWCmIfYPjFTTpsE3+Nla7N0kJvDlcGmMJLV5i6
         DJo1Kkid9uupyjuQJaXp0P4d4YWijwyqQxCxJ7K+vouEIPIWsQ9Vo67lVv8Tt0osAd3U
         H++MGxqehTZGoMn7/xoztmZVzOhXn3bcBwBVPO1rCSZNioBYUP5F3vPRjrD3+e18O1oQ
         rhCu46NCFrOoBN48HCPeqIghk/W3WW+d8GpNyIfm9i2kZMxPNNIhNRcxfNe+kGPa+rKT
         te4w==
X-Forwarded-Encrypted: i=1; AJvYcCX5/Wc3gmJmT5taCbOEPgvrpNBtLojg/SOrdIuXwNOysFdnq9oTKb7tdk+jtNAvpLQ396tsWvpqGrNx9qjtWeSrYT246cZLpeo=
X-Gm-Message-State: AOJu0YxqRe5G6J0eu2SaVS9Y0fKoLqXx3c1z/y8TPHeUwntT2TK9PGRL
	9Lnvaw1baEuwinIL9l5E2rVX7VS6HHi8cpr/+IIW092jwRkkssRgNxXZdzQQWVGQIH+GZ254e64
	zvIN88lDvnCBhkwzMS/RqTkf4ICP9ekC1JT6jOesz7489bLxeF2Rs8TrJsYo7WK9e/Ms=
X-Received: by 2002:a05:6a20:6a28:b0:1a1:6da9:e16 with SMTP id p40-20020a056a206a2800b001a16da90e16mr689266pzk.21.1709753935835;
        Wed, 06 Mar 2024 11:38:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGF6+aoeUmtfWjxS+sbqWLLon4bIjM5h1urB7K74LQeTsenxFzGbCFCIms+0ejpNoDh/pN7AA==
X-Received: by 2002:a05:6a20:6a28:b0:1a1:6da9:e16 with SMTP id p40-20020a056a206a2800b001a16da90e16mr689242pzk.21.1709753935313;
        Wed, 06 Mar 2024 11:38:55 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u20-20020a62d454000000b006e468cd0a5asm12020204pfl.178.2024.03.06.11.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 11:38:54 -0800 (PST)
Date: Thu, 7 Mar 2024 03:38:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] fsstress: bypass io_uring testing if
 io_uring_queue_init returns EPERM
Message-ID: <20240306193851.tpcaq2vklbjekgde@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-3-zlang@kernel.org>
 <x49a5nbuze3.fsf@segfault.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49a5nbuze3.fsf@segfault.usersys.redhat.com>

On Wed, Mar 06, 2024 at 10:57:08AM -0500, Jeff Moyer wrote:
> Zorro Lang <zlang@kernel.org> writes:
> 
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
> 
> I think you want to use -c here, right?

Sure, will change that, thanks!

> 
> Other than that:
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> 
> 


