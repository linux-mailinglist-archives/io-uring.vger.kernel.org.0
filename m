Return-Path: <io-uring+bounces-8975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01FE4B280CD
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CC403ACEEC
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 13:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330BE46BF;
	Fri, 15 Aug 2025 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfNzTD8J"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409C319855;
	Fri, 15 Aug 2025 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755265598; cv=none; b=PE8oYF2bvUopd9G36khmvEPzTrkOKAC9oeyGu1sBM0mTjaEDQiWKMvoExix7wtt3lORQxE43yxcHvSXd6CyMpGTiWTc/MYqBzwHgjH8OTHej8MXBAJeWA+UzPPJF0SgyDCM5x3QGBngMxoOw7RBwaJeJ4MJF2mG6JI0R7oGb+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755265598; c=relaxed/simple;
	bh=xzlMUjs0ZD7ozfSGCSYJK8OX3Wg/Kw1/MwrhO6ctMPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwIUShIXerCQy4Zj5QuzegX1iRr+OkIAsu0/fN50FmsYXBeFnJ903hNm576ObncAFkiGnRAGTaWvShgM7guK5bYCWE5drZ+y8hKN1Fxoa6363VGMeP+HpG99oZ8g2vP4QvvHGqW8kqcT/zoPzMRytMVyDyQ85E+KevjJsQDmzA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfNzTD8J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADCAC4CEEB;
	Fri, 15 Aug 2025 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755265597;
	bh=xzlMUjs0ZD7ozfSGCSYJK8OX3Wg/Kw1/MwrhO6ctMPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfNzTD8J50DNe/CI4J60Y69B6fI40IcczyuonyE77kZAa9nxITJfcXUNV6kZW8Nxs
	 2+JoQA1E0gPy673G+Zy2VHU7WVF0RnwSkJbmJ4feRVk2ZC+KKePab6pi0ESz+x9mBa
	 jlka2zvutnzP2xMPTpKHEiIxZ2SMAXEXPgAz+VBSk9JCNdanXzVNh3G9rqHvucLh1v
	 ws9wFYJ4Orbq6XxMYCm7D2u0+avzcsGWuUN2QeAsWzKTVr7c+/Kgy7hiClpD5N7WNK
	 SgDZUW4ODvauae4G31b8X3Yco7saCJVevCdSntO7BfcpN1EWSzDjoZgkqeSKGIYttQ
	 Q59EZg+msRt+Q==
Date: Fri, 15 Aug 2025 15:46:33 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, 
	io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 3/6] fhandle: do_handle_open() should get FD with user
 flags
Message-ID: <20250815-raupen-erdgeschichte-f16f3bf454ea@brauner>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <20250814235431.995876-4-tahbertschinger@gmail.com>
 <CAOQ4uxhhSRVyyfZuuPpbF7GpcTiPcxt3RAywbtNVVV_QDPkBRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhhSRVyyfZuuPpbF7GpcTiPcxt3RAywbtNVVV_QDPkBRQ@mail.gmail.com>

On Fri, Aug 15, 2025 at 11:17:26AM +0200, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 1:52 AM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
> >
> > In f07c7cc4684a, do_handle_open() was switched to use the automatic
> > cleanup method for getting a FD. In that change it was also switched
> > to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
> > of passing the user-specified flags.
> >
> > I don't see anything in that commit description that indicates this was
> > intentional, so I am assuming it was an oversight.
> >
> > With this fix, the FD will again be opened with, or without, O_CLOEXEC
> > according to what the user requested.
> >
> > Fixes: f07c7cc4684a ("fhandle: simplify error handling")
> > Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> 
> This patch does not seem to be conflicting with earlier patches in the series
> but it is still preferred to start the series with the backportable fix patch.
> 
> Fee free to add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

I'm kinda tempted to last let it slide because I think that's how it
should actually be... But ofc, we'll fix.

