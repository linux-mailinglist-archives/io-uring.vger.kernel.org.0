Return-Path: <io-uring+bounces-838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCC0873B3D
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AE86281452
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69B9135403;
	Wed,  6 Mar 2024 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLiY5yMO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00CA1EF1C;
	Wed,  6 Mar 2024 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740438; cv=none; b=qI2vWMbGAoSpVwOQ44Ac34wkBBCMiCXfkBAT6tA8ifEjoEL5l+DioS0BpwIbBgknHPRRKkGTnTGaLvIC9nqyDteUHza9Ob/I/hj/YhhhwWRP2ZMl7DgPOrul8mmQyJlP4vuU8Luv25SqyY5BAhqPt9XwGAYh/pqRR/Qr7aK2ErY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740438; c=relaxed/simple;
	bh=RjR3pVvrT9vRkeAP4vRfjCIaiDzYSOUI2pZPlFz/6V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5DXq23TsIBx0rYm7QN1RCPXqL9/RwyZAEXcJJjWoFVKLBMsMkEGylM34W1wG816kDPaOsSJXzhRm/O0n8UAxKIfIJyN24JIyZtbDmJ8RMATtb7WS5lVeTVL/GsxzUUcWitHv4ZymI4iKiieTU5oFLlwsM68cu5ssokJxr++FjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLiY5yMO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F76C433C7;
	Wed,  6 Mar 2024 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709740438;
	bh=RjR3pVvrT9vRkeAP4vRfjCIaiDzYSOUI2pZPlFz/6V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLiY5yMOi8gP1GMZvDshi8VbTCUoMPdh8PD2I7TXvBfPlnjoeWffeUJ480PTy3ux9
	 PYtj0bGPmRhMcEaYUwQEQJxs6fJu04CZmHdpfEp6W3QM7nfw1zYryOUpo9kAQ6qHmN
	 XWdDjctBB0CjH2diRMwNs+L9OLf6we3zQP+zZpg38erm3Lb41dvcoK6zg2b8xzXnUM
	 eF5ij29bFBPHbLk1/9e1yiWdxueteMXuZp1v7fmpGJlXarBD6Wuw7NSjjkxotdTaVY
	 uY+Hag8WlOrH3THzB6p9OX0RxyJqK8MMPWf6T6aJqy8XlUT9+t96V1TwAQOD6EE85a
	 Qm0tjSFTImXig==
Date: Wed, 6 Mar 2024 07:53:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] fsstress: check io_uring_queue_init errno properly
Message-ID: <20240306155357.GA6188@frogsfrogsfrogs>
References: <20240306091935.4090399-1-zlang@kernel.org>
 <20240306091935.4090399-2-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306091935.4090399-2-zlang@kernel.org>

On Wed, Mar 06, 2024 at 05:19:33PM +0800, Zorro Lang wrote:
> As the manual of io_uring_queue_init says "io_uring_queue_init(3)
> returns 0 on success and -errno on failure". We should check if the
> return value is -ENOSYS, not the errno.

/me checks liburing source code and sees that the library returns a
negative error code without touching errno (the semi global error code
variable) at all.  That's an unfortunate quirk of the manpage, but this
code here is correct...

> Fixes: d15b1721f284 ("ltp/fsstress: don't fail on io_uring ENOSYS")
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  ltp/fsstress.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 63c75767..482395c4 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -763,8 +763,8 @@ int main(int argc, char **argv)
>  #ifdef URING
>  			have_io_uring = true;
>  			/* If ENOSYS, just ignore uring, other errors are fatal. */
> -			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
> -				if (errno == ENOSYS) {
> +			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
> +				if (c == -ENOSYS) {
>  					have_io_uring = false;
>  				} else {
>  					fprintf(stderr, "io_uring_queue_init failed\n");

But why not:

			c = io_uring_queue_init(...);
			switch (c) {
			case 0:
				have_io_uring = true;
				break;
			case -ENOSYS:
				have_io_uring = false;
				break;
			default:
				fprintf(stderr, "io_uring_queue_init failed\n");
				break;
			}

Especially since you add another case in the next patch?

I'll leave the style nits up to you though:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


--D

> -- 
> 2.43.0
> 
> 

