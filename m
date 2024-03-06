Return-Path: <io-uring+bounces-848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130058740CE
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 20:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 449E41C20B41
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 19:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DD413E7F4;
	Wed,  6 Mar 2024 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPqY3WjD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2823140E22
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 19:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709754682; cv=none; b=RY/f9QzhDsDCFUFoZ1LzzO6Ei/ElqV0Xix8yILlnPhVLIYfHGSun2qo9feE5GldaGE0gfRzRJSCrt4zXPb3DMcArwE5zlJsx/8EJqh3Zs/5xMAgrFP246F0X5NQxP3NaRTQb7pnVsIHMzKedQHe8OemtUA5dYF3Pp7+8bBh60UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709754682; c=relaxed/simple;
	bh=CMb8pibMz4WgMwM2ztZiQSNz3Q3pYgajWZ3VtHGYqjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgZNhRjdFl9wCDp5jhBiBphdKgNUxnTg0MBfo+bh/0PFHcq22nb5XtXr9jWXpJJ9uriTobOX7viW4nVYaJgTpzpCUuReULM6OCjCCg5WcfkJwSme4ywoxPDTgySQBIkBHalvsAVnbGZW+Mwv2gF7T+ak8hzluqNBd+xW0hlrxKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPqY3WjD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709754679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cekf8mGcnJHeSFwkCfUPviVisxyaY7cCM5d4VnlIz1c=;
	b=MPqY3WjDlqJ1B3QObwi2e+CmeZ74XOMQ8O0E2HIWbcdX3AvUBu0vHyt82ThAINi5Qgcoli
	cxVRSEg/uAy7Ep/Lkf769NcfukKJgwt2GM2F18RM493NaJ6M3EUZTnsqK8iJeUNVHBZjP1
	j0GZqsCjXGa4wINptJBcwhOa52zzngU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-Ox5ELScoOSuo5prLe9n0mw-1; Wed, 06 Mar 2024 14:51:17 -0500
X-MC-Unique: Ox5ELScoOSuo5prLe9n0mw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-29976f92420so133664a91.0
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 11:51:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709754676; x=1710359476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cekf8mGcnJHeSFwkCfUPviVisxyaY7cCM5d4VnlIz1c=;
        b=M+CjDKMRHBjix4D85kydNkb+WBOmD5GyROo698Nwiclez8ZE3WAuI0bk41KTG9UXKj
         ZQehLN4zTmvyclXR6c5/8/vTHZoOXgjdwzyJynm4apjTnQMThfOScKTLnuA7F3VotioK
         cLQQsVTrMw1sysgM60nsZxvHx8+35x3gBSlS1oHcRelOA/R5wcWuEc7g2sKycKkVIb2b
         BOXOCRx2MFT0GWpJZOrspoLO/xlMebh7tcoKzi/Ja/0snWyxN8s3PZ+mhS1eW9GVJdYI
         OuCmvxAxCdlhN32UAb9MKGsEjC2j8aLJWDUHupxBPlDOkOfmEmXvm/r7Sd0UqgtR2NTN
         kIUg==
X-Forwarded-Encrypted: i=1; AJvYcCUeprRuNyA3wHfqRstSKUh1bkShz5eqRjHNEXjzU0HbVhQ8cyKVR18PLTn1bLLZncR7269MIq2fXkv4yJEWA4S5S92BIpM9eH8=
X-Gm-Message-State: AOJu0YwpmOY9SgvOcLo2r+MSoifGj4C3H2uldu8a892CEnDhXnMyn5C/
	9N5ZG2L2zJeP08aPefjMyMY7LuIqPoDIHvtmjKIXNFBrcwoC+Vi3pIreVRpZyLi+52socA+9euG
	5YBxoRc3kP46c+TapKeB1Q+kP9CP3kThLOsk3lINkY3icyjVslp97md7p
X-Received: by 2002:a17:90a:17a4:b0:29b:9e1:2fb0 with SMTP id q33-20020a17090a17a400b0029b09e12fb0mr1499075pja.0.1709754676182;
        Wed, 06 Mar 2024 11:51:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPzxPG8iJdGpBY8ws0lzaPSpJy2MSBFhZJCZv4sxH3m+tn1s1ADtCP5Cv0G8mHpjF6SgpzbQ==
X-Received: by 2002:a17:90a:17a4:b0:29b:9e1:2fb0 with SMTP id q33-20020a17090a17a400b0029b09e12fb0mr1499048pja.0.1709754675596;
        Wed, 06 Mar 2024 11:51:15 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a348900b0029658c7bd53sm127365pjb.5.2024.03.06.11.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 11:51:15 -0800 (PST)
Date: Thu, 7 Mar 2024 03:51:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] common/rc: force enable io_uring in _require_io_uring
Message-ID: <20240306195111.irajj7gojh5auahk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-4-zlang@kernel.org>
 <20240306154324.GZ6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306154324.GZ6188@frogsfrogsfrogs>

On Wed, Mar 06, 2024 at 07:43:24AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 06, 2024 at 05:19:35PM +0800, Zorro Lang wrote:
> > If kernel supports io_uring, userspace still can/might disable that
> > supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's set
> > it to 0, to always enable io_uring (ignore error if there's not
> > that file).
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  common/rc | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 50dde313..966c92e3 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2317,6 +2317,9 @@ _require_aiodio()
> >  # this test requires that the kernel supports IO_URING
> >  _require_io_uring()
> >  {
> > +	# Force enable io_uring if kernel supports it
> > +	sysctl -w kernel.io_uring_disabled=0 &> /dev/null
> 
> _require_XXX functions are supposed to be predicates that _notrun the
> test if XXX isn't configured or available.  Shouldn't this be:

Yeah, that makes sense, I tried to find a place to force enable io_uring,
forgot it's not proper for _require_XXX function.

> 
> 	local io_uring_knob="$(sysctl --values kernel.io_uring_disabled)"
> 	test "$io_uring_knob" -ne 0 && _notrun "io_uring disabled by admin"

And I think I need to change the src/feature.c:check_uring_support() too,
check -EPERM as I did in fsstress.c.

> 
> Alternately -- if it _is_ ok to turn this knob, then there should be a
> cleanup method to put it back after the test.

Yeah, I'm still wondering if we should let fstests touch/set the io_uring_disabled
sysctl. Or we leave this job to the fstests user/wrapper script, fstests just
_notrun if io_uring is off.

Thanks,
Zorro

> 
> --D
> 
> > +
> >  	$here/src/feature -R
> >  	case $? in
> >  	0)
> > -- 
> > 2.43.0
> > 
> > 
> 


