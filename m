Return-Path: <io-uring+bounces-837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E66873AFA
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78FBA1F2A422
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85481135408;
	Wed,  6 Mar 2024 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVjnjyCr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5788E135401;
	Wed,  6 Mar 2024 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739805; cv=none; b=dbq4yM4ej1Dli0y3wW5PMbH+spO1GSuDpF+d3SD17wrimXdjzQ6fidPKB0+1ni4cPsLZ7bxTuu9mRChFvNrZIawL1qpT2jFDVQ+0JC8o/vToYJ3TlLYusamUPnzs8GvfbPsHql1dL2fOSDhrXbI9SqkJEw2FpUNWVoqI5H5nVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739805; c=relaxed/simple;
	bh=q6EQjcrOpchyk4HvO4K/jIkLXXFSQrZQ69QuM7nJKsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuL8WSPtA8CnVKsk/rIPk3kgL/9peJGNu6dd/GYuzl0hFBx5Z1HWJcNHal1M5Ffx1CL/PZXgZfGuWPok/LKML0ZD1wzvCyMrBjjzklarjIue9oZxjy6rzp62c4PdgIJYwlZPDLVR9pkM9tDqc1rpGKXdOhaDNlPwxUpJPiLzLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVjnjyCr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AAFC433F1;
	Wed,  6 Mar 2024 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709739805;
	bh=q6EQjcrOpchyk4HvO4K/jIkLXXFSQrZQ69QuM7nJKsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sVjnjyCr5BePinLGrWy5Kxy2fl8CTvTZY17yV0xOqEqQYzwQAxpetGsZo5GOI9xXS
	 9cexSG7JkCFlkLdBWyiG4w707Mwv/GNfgtjBJIXSqh7WStsbpgfa1d545Nk5l7cvPn
	 yguVswp0qSY/PQaL8cIVi9ay+C86NZbCoF8g1byeVchRiolBrlyFhrOKfqpH6Zgj6j
	 ok/rV7HjXECZKbwoZVl0WRQHl0KRtx6lQLUIyH0WT9RwnU/8QgTgmfZ0u3VWK0nUep
	 i29yTimjeeVceB3vy4HNp2miHZbt1etIYW+iiOOiKkZbo37BTpdsgW0xbz27b4gME2
	 +S8IR9PUrMiyA==
Date: Wed, 6 Mar 2024 07:43:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] common/rc: force enable io_uring in _require_io_uring
Message-ID: <20240306154324.GZ6188@frogsfrogsfrogs>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-4-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306091935.4090399-4-zlang@kernel.org>

On Wed, Mar 06, 2024 at 05:19:35PM +0800, Zorro Lang wrote:
> If kernel supports io_uring, userspace still can/might disable that
> supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's set
> it to 0, to always enable io_uring (ignore error if there's not
> that file).
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 50dde313..966c92e3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2317,6 +2317,9 @@ _require_aiodio()
>  # this test requires that the kernel supports IO_URING
>  _require_io_uring()
>  {
> +	# Force enable io_uring if kernel supports it
> +	sysctl -w kernel.io_uring_disabled=0 &> /dev/null

_require_XXX functions are supposed to be predicates that _notrun the
test if XXX isn't configured or available.  Shouldn't this be:

	local io_uring_knob="$(sysctl --values kernel.io_uring_disabled)"
	test "$io_uring_knob" -ne 0 && _notrun "io_uring disabled by admin"

Alternately -- if it _is_ ok to turn this knob, then there should be a
cleanup method to put it back after the test.

--D

> +
>  	$here/src/feature -R
>  	case $? in
>  	0)
> -- 
> 2.43.0
> 
> 

