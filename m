Return-Path: <io-uring+bounces-839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DBAD873B46
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65D8D1C21911
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69CD1350EF;
	Wed,  6 Mar 2024 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hwd6SaXm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF68134CE3;
	Wed,  6 Mar 2024 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740526; cv=none; b=Y9YYwDSBDlwrXvrAWi0CM+Od4lOxvPBuT9EfGClQJq+XB6hdux62KZfqHPI6KafZWA6mLgvaBEi96q8WQ838PCx+pleFI4FnpMpo7luo3ApWg1+xdsMTGjc5n68+KlynkxndnMm9AjHE7I7YJJ2yrVX3CKXV0jMCQEnC8IkS0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740526; c=relaxed/simple;
	bh=UwSMAzXEoD/C5Qne8jLQlUoCSOaG9RZW14QDHEd5pbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbuH4zONJrQMbjEgoLRsrz23/y0Dwv1BPC91iXAQ5CCMkrAG6ssTdXRwh1PE8GCHnYnI28HgRkQRokw1UDlEu7kDvrRCJuHz1FzG9CGzUVxyiL2ZVHXMldUHu20OLqIoaM4jtJskrDqxM4YPOGU97V7P9lwcdihHmwytJnD+Egw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hwd6SaXm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E30C433F1;
	Wed,  6 Mar 2024 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709740526;
	bh=UwSMAzXEoD/C5Qne8jLQlUoCSOaG9RZW14QDHEd5pbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hwd6SaXmxoEIRv19BRph/XvJH/f/VlSNrPZLQps9xnByqy6ANXmuam9WtsBPst8Oe
	 sSnh21eqt7bLBv/gGg7UIel0EM+3mY2kbZhTNBcCUHsylViH3Mc2kxUuSdRUkDYp3h
	 cXqPE+s3CbYekJ5VfrgMmIzkGLBERT7PtG53b1AUN8aJZ0rrwlA6cTqNVlNbpmtdqP
	 tFO0y1XE56CO//+ZvjMz8/38JT4sPFUx8xBLasboF3xP0QEPi/5g4OxzhMJRqaszJw
	 djDIxxZ1m9colelFIDdb9sx37yHqM3MeSQI4uiucDLlFKTWt5kNZUkzLMWfwKU9JYE
	 Z6Vj/07235e+g==
Date: Wed, 6 Mar 2024 07:55:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] fsstress: bypass io_uring testing if
 io_uring_queue_init returns EPERM
Message-ID: <20240306155526.GB6188@frogsfrogsfrogs>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-3-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306091935.4090399-3-zlang@kernel.org>

On Wed, Mar 06, 2024 at 05:19:34PM +0800, Zorro Lang wrote:
> I found the io_uring testing still fails as:
>   io_uring_queue_init failed
> even if kernel supports io_uring feature.
> 
> That because of the /proc/sys/kernel/io_uring_disabled isn't 0.
> 
> Different value means:
>   0 All processes can create io_uring instances as normal.
>   1 io_uring creation is disabled (io_uring_setup() will fail with
>     -EPERM) for unprivileged processes not in the io_uring_group
>     group. Existing io_uring instances can still be used.  See the
>     documentation for io_uring_group for more information.
>   2 io_uring creation is disabled for all processes. io_uring_setup()
>     always fails with -EPERM. Existing io_uring instances can still
>     be used.
> 
> So besides the CONFIG_IO_URING kernel config, there's another switch
> can on or off the io_uring supporting. And the "2" or "1" might be
> the default on some systems.
> 
> On this situation the io_uring_queue_init returns -EPERM, so I change
> the fsstress to ignore io_uring testing if io_uring_queue_init returns
> -ENOSYS or -EPERM. And print different verbose message for debug.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  ltp/fsstress.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 482395c4..9c75f27b 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -762,12 +762,23 @@ int main(int argc, char **argv)
>  #endif
>  #ifdef URING
>  			have_io_uring = true;
> -			/* If ENOSYS, just ignore uring, other errors are fatal. */
> +			/*
> +			 * If ENOSYS, just ignore uring, due to kernel doesn't support it.
> +			 * If EPERM, might due to sysctl kernel.io_uring_disabled isn't 0,

"might be due to..."

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +			 *           or some selinux policies, etc.
> +			 * Other errors are fatal.
> +			 */
>  			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
>  				if (c == -ENOSYS) {
>  					have_io_uring = false;
> +					if (verbose)
> +						printf("io_uring isn't supported by kernel\n");
> +				} else if (c == -EPERM) {
> +					have_io_uring = false;
> +					if (verbose)
> +						printf("io_uring isn't allowed, check io_uring_disabled sysctl or selinux policy\n");
>  				} else {
> -					fprintf(stderr, "io_uring_queue_init failed\n");
> +					fprintf(stderr, "io_uring_queue_init failed, errno=%d\n", c);
>  					exit(1);
>  				}
>  			}
> -- 
> 2.43.0
> 
> 

