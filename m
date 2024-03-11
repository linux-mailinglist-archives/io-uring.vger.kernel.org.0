Return-Path: <io-uring+bounces-889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EAA87857C
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 17:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0CDC1C223F5
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 16:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6446241C7A;
	Mon, 11 Mar 2024 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d69weerw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B45144C8C;
	Mon, 11 Mar 2024 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174576; cv=none; b=t7dy7qlS7UPNTRXH/D0X1hGFd2t+Fi5AZHKt8CFhhnx1Z/JvnOC5A1zPT7PZQx6VFGvV8Xtmrx2xMsKmS0gqbyNgJbyNIMK9gYzQb2Ok2X6UlAfScp/foxqW4zJZzyAt3+3zrp7Mff2D+lyJGDRFLY/fAl8O274y01zWi0X5KtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174576; c=relaxed/simple;
	bh=THsWYx+8+lkJyNg9KmPY39yeXHrCWb8jvwKQufUnO7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2zZpM4xGkoIcYpH7MQ/D4xqzIQAIYZ6J9cQWcM+7a1DF7uuFKRi6HJXIza0Lu4WtzHciIXZ2VM0UERvHLYxdouj/Rm00RXqMT7VMa1ge/x595f3FOeNrVuOOc2YJdNdyoTcp4HdZAXDZYsrIL2xvC8NJCb69EBFviNodtaBkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d69weerw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1DFC433C7;
	Mon, 11 Mar 2024 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710174576;
	bh=THsWYx+8+lkJyNg9KmPY39yeXHrCWb8jvwKQufUnO7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d69weerw0L9P5KGTwH45n+EAYG04hNLuJqUmybB+7xCKS9FRgYmcn9UsOeR2T5t6i
	 bd5OFKeRHy+6D7ZB0I3vuKbAAWU3JUjGvw8VqP9Dv45BpJitc9co3hMl2D8mwU3XXo
	 /LNdwjtevgaWVp7pcaQr16KK3XLOe03JpgZwDcrA6i1j95rQSyhgLRHPzCyC1EmW8M
	 0CwaiEb8JjrwGLu5ik8rSR9phYO1T1l3A9+/z5war3lYByxqkQ3CmO/0pPEki3E5nC
	 eiLEK6Hh9Tgow1dp6TcBgYE4emWHRBHmZTwusPP+lGP65Mvq8aLclfjAz4tnf0pn8z
	 3a8OOMzLtJaUQ==
Date: Mon, 11 Mar 2024 09:29:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 3/3] common/rc: notrun if io_uring is disabled by
 sysctl
Message-ID: <20240311162935.GD6188@frogsfrogsfrogs>
References: <20240311162029.1102849-1-zlang@kernel.org>
 <20240311162029.1102849-4-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311162029.1102849-4-zlang@kernel.org>

On Tue, Mar 12, 2024 at 12:20:29AM +0800, Zorro Lang wrote:
> If kernel supports io_uring, userspace still can/might disable that
> supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's notrun
> if io_uring is disabled by that way.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  README        |  6 ++++++
>  common/rc     | 10 ++++++++++
>  src/feature.c | 19 ++++++++++++-------
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/README b/README
> index c46690c4..477136de 100644
> --- a/README
> +++ b/README
> @@ -142,6 +142,12 @@ Setup Environment
>     https://www.lscdweb.com/registered/udf_verifier.html, then copy the udf_test
>     binary to xfstests/src/.
>  
> +8. (optional) To do io_uring related testing, please make sure below 3 things:
> +     1) kernel is built with CONFIG_IO_URING=y
> +     2) sysctl -w kernel.io_uring_disabled=0 (or set it to 2 to disable io_uring
> +        testing dynamically if kernel supports)
> +     3) install liburing development package contains liburing.h before building
> +        fstests
>  
>  For example, to run the tests with loopback partitions:
>  
> diff --git a/common/rc b/common/rc
> index 50dde313..1406d8d9 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2317,6 +2317,8 @@ _require_aiodio()
>  # this test requires that the kernel supports IO_URING
>  _require_io_uring()
>  {
> +	local n
> +
>  	$here/src/feature -R
>  	case $? in
>  	0)
> @@ -2324,6 +2326,14 @@ _require_io_uring()
>  	1)
>  		_notrun "kernel does not support IO_URING"
>  		;;
> +	2)
> +		n=$(sysctl -n kernel.io_uring_disabled 2>/dev/null)
> +		if [ "$n" != "0" ];then
> +			_notrun "io_uring isn't enabled totally by admin"
> +		else
> +			_fail "unexpected EPERM error, please check selinux or something else"
> +		fi
> +		;;
>  	*)
>  		_fail "unexpected error testing for IO_URING support"
>  		;;
> diff --git a/src/feature.c b/src/feature.c
> index 941f96fb..7e474ce5 100644
> --- a/src/feature.c
> +++ b/src/feature.c
> @@ -232,15 +232,20 @@ check_uring_support(void)
>  	int err;
>  
>  	err = io_uring_queue_init(1, &ring, 0);
> -	if (err == 0)
> +	switch (err) {
> +	case 0:
>  		return 0;
> -
> -	if (err == -ENOSYS) /* CONFIG_IO_URING=n */
> +	case -ENOSYS:
> +		/* CONFIG_IO_URING=n */
>  		return 1;
> -
> -	fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
> -		strerror(-err));
> -	return 2;
> +	case -EPERM:
> +		/* Might be due to sysctl io_uring_disabled isn't 0 */
> +		return 2;
> +	default:
> +		fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
> +			strerror(-err));
> +		return 100;
> +	}
>  #else
>  	/* liburing is unavailable, assume IO_URING is unsupported */
>  	return 1;
> -- 
> 2.43.0
> 
> 

