Return-Path: <io-uring+bounces-11613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDD3D1ABD4
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 18:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBB2F300E477
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 17:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBAC2F3608;
	Tue, 13 Jan 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9sssFk0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5C921C16E;
	Tue, 13 Jan 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326699; cv=none; b=NK674HYV9DwZzDakJBKhLo5v4fe5nrzgRKd4QkfrskduCnQUYHQipS/Fr0ma7rXf4HgCy5Eqka88D1yAZ+onqR/rKnEyD4VuHUgDHZFsred3PWmYc+/FG9LCQWEt5L+cmh9eYK+ds5Hk1bXbRVZpvyJm1N5+iUFAoQxgF+9ntSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326699; c=relaxed/simple;
	bh=u5yB2Af5ZEp4v9jSy7Lyba9Srv6l7smSuqGnUS5JO50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYyF82X3lokkZWNvLXlhGTyOaXnrkIowmfwcCOyiKAVxnfHLF+jO0B48ajAGDbbHrHC5y06iZXk143ao/KAbwX9WYSZt3LSDNt1ieHe0CoRtG/JGzJDt3chUqo51/dx8RsWDZCP9W0YBSJZFT3aiPdYuAu7QFj74wWVZfhJbVl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9sssFk0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34F3C116C6;
	Tue, 13 Jan 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768326699;
	bh=u5yB2Af5ZEp4v9jSy7Lyba9Srv6l7smSuqGnUS5JO50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9sssFk0DYfXoi5J+Z953WUH9om7NMddeT+PUnLqct2AsJ2O4dkUEY1SsUHmn2+OK
	 dG+2yDWL4pRtqrdTBQ5TnEOocN6w26yny6yaYHltYgPbMz+7z+Un/k8I8quvKUQ2uh
	 wG20rwrYv+XEIJ/9ztNFZSIaz93jC5nth/7nXcP8+T6qCkAJFgpFU6Yh7HdtpnFf5J
	 95+JzIeOA571TQfF4lov+oIhNYYAl4s0Ogtvi5nuxTLEOAkqRN+YRh+2aSRrToLsyv
	 xEOWz5ck0XLIJG0Rj4EgesM0yntEOGzSvZ+ZGB14eA77Cx6fDxJgAHZsQJhdYG7y4K
	 X81yZ1U68jo0Q==
Date: Tue, 13 Jan 2026 17:51:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/59] struct filename: saner handling of long names
Message-ID: <64f6bd19-7906-4138-ae1b-a5a443ed140d@sirena.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
 <20260108073803.425343-16-viro@zeniv.linux.org.uk>
 <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
 <20260113153953.GN3634291@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Of4QYEo5dqgFFZip"
Content-Disposition: inline
In-Reply-To: <20260113153953.GN3634291@ZenIV>
X-Cookie: All models over 18 years of age.


--Of4QYEo5dqgFFZip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2026 at 03:39:53PM +0000, Al Viro wrote:
> On Tue, Jan 13, 2026 at 03:31:14PM +0000, Mark Brown wrote:

> > I'm seeing a regression in -next in the execveat kselftest which bisects
> > to 2a0db5f7653b ("struct filename: saner handling of long names").  The
> > test triggers two new failures with very long filenames for tests that
> > previously succeeded:

> Could you check if replacing (in include/linux/fs.h)

> #define EMBEDDED_NAME_MAX       192 - sizeof(struct __filename_head)

> with

> #define EMBEDDED_NAME_MAX       (192 - sizeof(struct __filename_head))

> is sufficient for fixing that reproducer?

Yes, that fixes both testcases - thanks!

--Of4QYEo5dqgFFZip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlmhiUACgkQJNaLcl1U
h9D+Fgf+Kes/aSCAueu1qfrerl0JcUVsduMxtytvZhZRtYOZUzYgu6kid1P4zS5u
cB5UgmPBUyPl5R/MxwWR4cNczlzXNFEaxsK98vJkDb8JLEE//EPjvqX4U3k1oKxz
1E8gkC1QxX1a50iY6DlKm9fuyjoe1ipQf79X5WeLqJZH/LRuvq8APEPjMGtdtWwb
uzTemUH1GvgZ79y2wzHogJtzt10qfdX6O8aUIhLcS1Sb3w5xTpV4vYHQ8w3bGFEy
TKtKrT3nO7GmZVlV1rLAhKkpZ5YJvhyfkkpixNDY0ewFBmO3pv96cCAhRtwUOliu
6xpuTk37TiRbf30DeGcEOrNhbnmYQA==
=7zUr
-----END PGP SIGNATURE-----

--Of4QYEo5dqgFFZip--

