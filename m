Return-Path: <io-uring+bounces-1477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF3889E1AE
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 19:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6901A281B91
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 17:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3644C85;
	Tue,  9 Apr 2024 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="hnCIRZWC"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51BF15666A
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.211.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712684267; cv=none; b=AQ+mc33VV1OCCQEuWdE8LTGlJTigHOOIGDIH5Z52raPybTCj6S3AZh8eGhY02JxCPyHMfPcP3CHZ1Z2kGXY9HymdztGwyyHkIxN/hkJGK5svLOQLILyfTVn/bci8uK4Cb0XrZe3BruD930GgeOAUDiw2PdCCc9aEYQrYk+7N6Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712684267; c=relaxed/simple;
	bh=DWDmnrILdy4EWgj8XgYVDArV/w8gj6vRftFyPeontfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvVEWk2VCBNlzXNWHEnUZPYtcfQEK4jv5jE9qZpQRGwMjcEmpNeDC0W/OpHAFoIVhER/z4uNdqfYVstrXYDFxUsICDYfNtvL7QNJGiRYMMqOzdbCQYbTASWTAYpq2Gs2BEPyk0PP6u9JbohEJtq2FM0T0Aj4mCBVulXvcjct31Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=hnCIRZWC; arc=none smtp.client-ip=51.81.211.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1712684259;
	bh=DWDmnrILdy4EWgj8XgYVDArV/w8gj6vRftFyPeontfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnCIRZWCfQZSG3RkNTTywRsPwAxNsoir7BLLRvCQ7MVqezADjOYvHgq8ERWtC7Ii9
	 xVSwieMGy5Zq9CoBHnkJjifEai6zAcqpMrrKliYgITvvqDHrCkDq6ynkcmMvMVUT66
	 H3h97tDJwt5GkkKIOuwadwDP6xSkekcVK6hvHoqreSR4+doF5w3SJ0ABhlcjU30fBc
	 k5sLFLDR9avLjuRyacU1BNeiP8gx0Bz8aS+Hj0tEgY0bE3KRqSC/8ts/KrFqUbDr/J
	 nvP/boyzoukWVapQ2np0XuzDre8eiZUqxubXSS5cnLBKp1AYoaLJqs5sPWnRuBh+5Q
	 viyQKl8LTW39g==
Received: from biznet-home.integral.gnuweeb.org (unknown [114.10.16.27])
	by gnuweeb.org (Postfix) with ESMTPSA id 0E02324ACB2;
	Wed, 10 Apr 2024 00:37:37 +0700 (WIB)
Date: Wed, 10 Apr 2024 00:37:33 +0700
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Arthur Williams <taaparthur@disroot.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCH] Fix portability issues in configure script
Message-ID: <ZhV83Ryv1oz6NyxU@biznet-home.integral.gnuweeb.org>
References: <20240409172735.1082-1-taaparthur@disroot.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409172735.1082-1-taaparthur@disroot.org>
X-Bpl: hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1

On Tue, Apr 09, 2024 at 10:27:35AM -0700, Arthur Williams wrote:
> The configure script failed on my setup because of the invalid printf
> directive "%" and for use of the unportable "echo -e". These have been
> replaced with more portable options.
> ---
>  configure | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

The patch is missing your Signed-off-by tag.

-- 
Ammar Faizi


