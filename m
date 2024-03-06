Return-Path: <io-uring+bounces-849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD27D8740ED
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 20:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92FB71F2217A
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 19:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698FE14036B;
	Wed,  6 Mar 2024 19:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gdp6nb+5"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B782713BAD1
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709755008; cv=none; b=afI9723WNxIj2KQkU5fg1Qh5NgR2R+JJmlUqeDYNL7ABExT7y8NH3cHmVvvNbz4rn9cF/MlPtUunz7JM0mYnJmKVlc9sSygZiyfzDqPl3e0UphY821rEokWLZktSThEtdsD8YijxkYX6RurnJPNrdSm6CtL0ntqJ7nadTJtYB0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709755008; c=relaxed/simple;
	bh=WwOZGOqufCnM+LmoEghJpWEI1xXGACezWh6JBXJEnow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kP7U3PACA+V9K+jAFit1Q5oNyt+FZ+mC6vS0lllbT/VuYVUKnzWSEmyv25uz7ijj9B/k94OkeOJaBwKThgAim5s0llslDiClsTLj5lBJ7YHE01u2TBLrNEH2AQ40yVZFEK7AHeiA0DSTspcP77Wb5K5hE9sKaw2WZBpmwnSKJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gdp6nb+5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709755005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qO3+X1vd5aHEnwQ+NjGahRyBGY8kyboJlNxdOazaIPA=;
	b=Gdp6nb+5w3AtnjMgtczgmM3Qy30dgzCju0FKuc3awxdSBoy6h6QQmzNe1wYd1iUZY7eo39
	QBxm91+04bgfJ2AdAPjksXGxjCkaEpSj2mv7iTruLkzzKBmL9C+4RxG8MRLJXMYPo9K6F6
	hfSbrRt6ht6b6ysKmDrJlxiLbQ25kK4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-W1OkGcrJO8eMLFhcu0eWtA-1; Wed, 06 Mar 2024 14:56:44 -0500
X-MC-Unique: W1OkGcrJO8eMLFhcu0eWtA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dc6f81c290so1127655ad.1
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 11:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709755003; x=1710359803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qO3+X1vd5aHEnwQ+NjGahRyBGY8kyboJlNxdOazaIPA=;
        b=d6mIjuEXbfJoXb8sc63wlmYXHglhVy/+8Z/AknKtHItQ4Yjc/DTkJ8d3X49PqKANnA
         giV00rHWjXsRQ3/tChIFWzrWH6JnM5g1PwauMR1oFzUl4TvIo0uq+ydG0uAyMlZV9+SA
         EyyakCN4xfq8hteua7amngFwvE8tmAzuzVRLBkIAUQoANifiA+82E0Q8jAJe49eLsl1d
         VPw8uP5EdMbySqK9qP8EnQiZCvhNZJ6//uNozqGOPdzRKMXkvmMIam7QYmtMODH+ZJTL
         Rr5SeWR+3mclRdru2AjR+/UBKNSlZ07ASOQoDnuDgAwuIw6S6D8nWEubZmJpu6SNPqHq
         HhDA==
X-Forwarded-Encrypted: i=1; AJvYcCWwdI1W4CEo80EqHG8gvSyElMezSVWx+gbJBH8Ym4/wtbJzwzvypWPPp8/LU1y5hwiU9JHU6JY+2jlAvEFWFRPzuRFAzzRYOzU=
X-Gm-Message-State: AOJu0YxTd+IK+aUAY6OGt0S8x6f/ECvcf5vWiZPVobHFIRxxlmSCQ11F
	VA2HoSSDAtgYAWgIb/tok7ToxZ5QrvKqeHytDXQBx4qZCQbQqQK1jPD+IM0+liWHKaeCQAUj3n3
	Gn81e/aie8599uZUuiOepcMh27OvecCCamZuAPyV6g8tvKgFDZ6z5BawhpSpg7Ef9j+M=
X-Received: by 2002:a17:903:2444:b0:1dc:d52e:a038 with SMTP id l4-20020a170903244400b001dcd52ea038mr6928128pls.60.1709755002907;
        Wed, 06 Mar 2024 11:56:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3pdt14LeJcO+vMvbgZMi+SWe62XrZ0xOE7dTcMXpGNHHQdUwxALtEVQ1SEC6ra+fJ1ZF6dg==
X-Received: by 2002:a17:903:2444:b0:1dc:d52e:a038 with SMTP id l4-20020a170903244400b001dcd52ea038mr6928109pls.60.1709755002381;
        Wed, 06 Mar 2024 11:56:42 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m18-20020a170902f21200b001da34166cd2sm13016388plc.180.2024.03.06.11.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 11:56:42 -0800 (PST)
Date: Thu, 7 Mar 2024 03:56:38 +0800
From: Zorro Lang <zlang@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] common/rc: force enable io_uring in _require_io_uring
Message-ID: <20240306195638.tdw7upqc7om7x65b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-4-zlang@kernel.org>
 <20240306154324.GZ6188@frogsfrogsfrogs>
 <x495xxzuzaa.fsf@segfault.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x495xxzuzaa.fsf@segfault.usersys.redhat.com>

On Wed, Mar 06, 2024 at 10:59:25AM -0500, Jeff Moyer wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Wed, Mar 06, 2024 at 05:19:35PM +0800, Zorro Lang wrote:
> >> If kernel supports io_uring, userspace still can/might disable that
> >> supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's set
> >> it to 0, to always enable io_uring (ignore error if there's not
> >> that file).
> >> 
> >> Signed-off-by: Zorro Lang <zlang@kernel.org>
> >> ---
> >>  common/rc | 3 +++
> >>  1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/common/rc b/common/rc
> >> index 50dde313..966c92e3 100644
> >> --- a/common/rc
> >> +++ b/common/rc
> >> @@ -2317,6 +2317,9 @@ _require_aiodio()
> >>  # this test requires that the kernel supports IO_URING
> >>  _require_io_uring()
> >>  {
> >> +	# Force enable io_uring if kernel supports it
> >> +	sysctl -w kernel.io_uring_disabled=0 &> /dev/null
> >
> > _require_XXX functions are supposed to be predicates that _notrun the
> > test if XXX isn't configured or available.  Shouldn't this be:
> >
> > 	local io_uring_knob="$(sysctl --values kernel.io_uring_disabled)"
> > 	test "$io_uring_knob" -ne 0 && _notrun "io_uring disabled by admin"
> 
> That sounds like a good option to me.
> 
> > Alternately -- if it _is_ ok to turn this knob, then there should be a
> > cleanup method to put it back after the test.
> 
> I think it would be better not to change the setting, especially if the
> admin had disabled it.

As a testing environment/system, even if fstests doesn't touch the io_uring_disabled
sysctl, the testers should care about that before doing his test. So the fstests
users might need to change the io_uring_disabled=0 manually, or do it in their CI
test scripts. Maybe we should leave this job to the users.

Thanks,
Zorro

> 
> Cheers,
> Jeff
> 
> >
> > --D
> >
> >> +
> >>  	$here/src/feature -R
> >>  	case $? in
> >>  	0)
> >> -- 
> >> 2.43.0
> >> 
> >> 
> 
> 


