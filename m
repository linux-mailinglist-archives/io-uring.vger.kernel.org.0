Return-Path: <io-uring+bounces-1406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C723899BAB
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 13:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A47431F23CF3
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 11:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D262716C44D;
	Fri,  5 Apr 2024 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlrZsS7r"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A775516C44A;
	Fri,  5 Apr 2024 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712315575; cv=none; b=oU0F4ZDNj4mpNJ6fJj83l4sOjT9FN5HnolHMC+l6fmvaO2UHwo48A29AmlnTfZWkgebpfHsPHXd/0GGU9oO/vv4nvCdqAavUDyMLSC2ocS+faEzBEMhgEadpLId4dN3ow8KNtVj2TnYG+udslhix3D8LL8AjhuIVb6BJ+2eIf94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712315575; c=relaxed/simple;
	bh=zVM+VZdH38/HNbDjhlmOgfFpjnsns0TKhI0rjRRPd9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4rYe1yrjziUq6RKu3xSDfonz+kyL9Pb82hfGLvJWQfrj1TbarmrA/GHv+MQf/ojRRZgayZSYYnncgggKt8tTOtslTX+piyQuqPVkPdZi55fD8BDHLcMLdIz9/8AePA0uiFhJ220ZpWiSlm9M4yi598x+gLy/ppw0nkBSj7Ygks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlrZsS7r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E9DC433C7;
	Fri,  5 Apr 2024 11:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712315575;
	bh=zVM+VZdH38/HNbDjhlmOgfFpjnsns0TKhI0rjRRPd9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlrZsS7ry3aV56Nz6QiHKTi/+7N2lN8pMBwJulVOD8o5R1slR8PyC8MBLfGmLFtCv
	 l58+7w+Rj+nKQclMAi9QuGjU3nEoqzRQbGT6012ZGx6opu4PyzggwJ3U6MvobP31Ns
	 XlpCcEjeavmalunaAmEflrf7Nl7ZZWeKzJ/naQxlqfwF55qzJahrAYlQ5GQ7XzWMm8
	 fCasq37rufckXvn3JxL/e5SmTr4iyjZc7VAFCa1KK3yL33Y40n+DcKjYilHupUs9HE
	 2lS3SncliunLG5xdmjECgeCsNs6DmXEiSSfvOOvk9DCJjmenSzbQWKfFmrdyXwz6y7
	 BDPq1+UYas3TA==
Date: Fri, 5 Apr 2024 12:12:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <ccf7feb2-8270-440a-8479-18ae1f29e239@sirena.org.uk>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
 <20240404091215.kpphfowf5ktmouu7@quack3>
 <6fb750e5-650e-42dd-8786-3bf0b2199178@sirena.org.uk>
 <20240405-vorhof-kolossal-c31693e3fdbe@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L5qsdgoLnzbc5ivh"
Content-Disposition: inline
In-Reply-To: <20240405-vorhof-kolossal-c31693e3fdbe@brauner>
X-Cookie: Honk if you love peace and quiet.


--L5qsdgoLnzbc5ivh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 05, 2024 at 12:27:41PM +0200, Christian Brauner wrote:
> On Thu, Apr 04, 2024 at 12:43:30PM +0100, Mark Brown wrote:

> > Actually it looks like the issue went away with today's -next, but FWIW
> > the logging for the open_by_handle_at0[12] failures was:

> The bug was with:

> fs: Annotate struct file_handle with __counted_by() and use struct_size()

> and was reported and fixed in the thread around:

> https://lore.kernel.org/r/20240403110316.qtmypq2rtpueloga@quack3

> so this is really unrelated.

Ah, good - I did actually get to that one on my original bisect but
reran the final section of the bisect since it looked like a false
positive and wanted to confirm.  Not sure why it glitched on the second
run.

--L5qsdgoLnzbc5ivh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYP3LEACgkQJNaLcl1U
h9D31wf+N6BidDQRvmEBARbca7Iekf39m/ue0lgbh3YIbuPRYtEV3jsS77tFIBBj
LD57PSZJQTY/goGYKZscps77X5P3qDWnZrpf2tzy7ULxPCeMaA5uNDxEoOe8VXtN
u6k6kBmsal5U3b+Hi2IeXQeg99QosHHA9c8j1fHYuLtS6LjXoQa2VjYj4+yDBIwN
3EAnE632NyhGDs7tT95tiZSykbD+gi5NfCAxjVibCg2L/BPrlHn4armvzS7iYZlO
0Dsn4PUW4AXCrQdQ4PBrGzQd0JiAW4w7aQ3CMdou0NpxfV0ta/h3NeGvmX3PLtxB
9A5cO9ozTrxJFVh0hSnHMta3X9vboA==
=v/0V
-----END PGP SIGNATURE-----

--L5qsdgoLnzbc5ivh--

