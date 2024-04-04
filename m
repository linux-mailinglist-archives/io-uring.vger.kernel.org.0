Return-Path: <io-uring+bounces-1392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C8D898649
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 13:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E689B2619F
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 11:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CB684FAE;
	Thu,  4 Apr 2024 11:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eG+YnMHp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAECC84D2A;
	Thu,  4 Apr 2024 11:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712231017; cv=none; b=ldBvJqvMEu9LaMHfT0ZrW6yIzOZzjoxcSEh1905MXzZhD9wcUpAWC53VDtwVRUpGEioRPeUOmfGgf8ePdrqc485FEM03Zp5NTgLgou7WDmlPQfebKCYVjQtQxfdq3HdndTBzmuOp7k314n8/Oa105hSsNDEUSazs9TnEDoCRoOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712231017; c=relaxed/simple;
	bh=wF/yykeOWyFOu8oMSERSOECSAfhZ2iAq2kEuwhbHsh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awPxZwUuQtEZ3jDvICpQkg+M8TZFQkNUJPeaQAkiGhLbO43Xy8+Kn3OHq4jaVBi30agdo5IEplNeYY+DluczVRcYgcHg/VPplsJiIxcJqIHpGfQZNZvch2LDJ/Ot+M9mwrSshXUb/ZdL4rok+a5641WqOSqOlUZpbxT05CK9Yi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eG+YnMHp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0F3C433C7;
	Thu,  4 Apr 2024 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712231017;
	bh=wF/yykeOWyFOu8oMSERSOECSAfhZ2iAq2kEuwhbHsh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eG+YnMHp+aUKBCa9dCDa/r+QNBiWDcpmkSN36DAAVsfsUFhukK0aj94vFNwi0gYRx
	 6kCFV1XGB/ypBDZZ8nztHkh15thxr0rw8Lh4wu5r+D1qaItRJn+EEC1AmDjxWBRMmb
	 m7fKEEJ1cg3PLtVTQVsmd1S0ORovWX+Znf5bfMVXezVUTepu+A5TeWfYHnMxyXcqWn
	 40Rn6dUA+MNUMS/wa1aYsMVYCqa7pd5qBy6vakLdemb79WZYQLG2UGDM9DHhD1CC2z
	 4mYrm8uJlerXdt1v4lwHGWm2zf5oyooLQT+3e/iF7eOxtSonIB/B04vgos8U9yfiIX
	 ALsAN4tbbb2Rg==
Date: Thu, 4 Apr 2024 12:43:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <6fb750e5-650e-42dd-8786-3bf0b2199178@sirena.org.uk>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
 <20240404091215.kpphfowf5ktmouu7@quack3>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OGvdFptkhg15Bi2k"
Content-Disposition: inline
In-Reply-To: <20240404091215.kpphfowf5ktmouu7@quack3>
X-Cookie: Buckle up!


--OGvdFptkhg15Bi2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 11:12:15AM +0200, Jan Kara wrote:
> On Wed 03-04-24 22:12:45, Mark Brown wrote:

> > For the past couple of days several LTP tests (open_by_handle_at0[12]
> > and name_to_handle_at01) have been failing on all the arm64 platforms
> > we're running these tests on.  I ran a bisect which came back to this

> Do you have some LTP logs / kernel logs available for the failing runs?

Actually it looks like the issue went away with today's -next, but FWIW
the logging for the open_by_handle_at0[12] failures was:

tst_test.c:1690: TINFO: LTP version: 20230929
tst_test.c:1574: TINFO: Timeout per run is 0h 01m 30s
tst_buffers.c:56: TINFO: Test is using guarded buffers
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (0): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (1): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (2): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (3): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (4): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (5): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (6): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (7): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (8): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (9): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (10): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (11): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (12): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (13): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (14): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (15): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (16): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (17): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (18): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (19): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (20): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (21): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (22): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (23): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (24): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (25): EFAULT (14)
name_to_handle_at01.c:94: TFAIL: open_by_handle_at() failed (26): EFAULT (14)

Summary:
passed   0
failed   27
broken   0
skipped  0
warnings 0

tst_test.c:1690: TINFO: LTP version: 20230929
tst_test.c:1574: TINFO: Timeout per run is 0h 01m 30s
tst_buffers.c:56: TINFO: Test is using guarded buffers
open_by_handle_at02.c:92: TFAIL: invalid-dfd: open_by_handle_at() should fail with EBADF: EFAULT (14)
open_by_handle_at02.c:92: TFAIL: stale-dfd: open_by_handle_at() should fail with ESTALE: EFAULT (14)
open_by_handle_at02.c:98: TPASS: invalid-file-handle: open_by_handle_at() failed as expected: EFAULT (14)
open_by_handle_at02.c:98: TPASS: high-file-handle-size: open_by_handle_at() failed as expected: EINVAL (22)
open_by_handle_at02.c:98: TPASS: zero-file-handle-size: open_by_handle_at() failed as expected: EINVAL (22)
tst_capability.c:29: TINFO: Dropping CAP_DAC_READ_SEARCH(2)
tst_capability.c:41: TINFO: Permitting CAP_DAC_READ_SEARCH(2)
open_by_handle_at02.c:98: TPASS: no-capability: open_by_handle_at() failed as expected: EPERM (1)
open_by_handle_at02.c:92: TFAIL: symlink: open_by_handle_at() should fail with ELOOP: EFAULT (14)

Summary:
passed   4
failed   3
broken   0
skipped  0
warnings 0

--OGvdFptkhg15Bi2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYOkmIACgkQJNaLcl1U
h9Ck8gf/Tpcf2gwZagUS50/G6C/LCQUHoQk3d5rODJ0j182e9irT1W1nhpn50Pfc
owqChNh7ffoepuAka5fyhdR1MZqpdmUpOuP/9MPHo6lAE+A9ZuqsoqJVKz3fF4kZ
1v2q0bKL6x/icHiqxVC0Pu2wJN47/Wh0PsP+AidwNQ2fy5lujnkXhjDhIZAr6TX5
n9EAsc2BprNoa1FiJfZcWFDOZR2eLOtpBB3afQPKbg/aVXMRaHExJtEVO65KinUv
cmrUsZnGkAFNvNjqe81OC7K8VHSCW5s5moS1f6189f6LRukT7k5eDIRe0olyXnmc
Nq9KIcYuVSdbbsWQglbeUCCAEjYnNQ==
=gA/c
-----END PGP SIGNATURE-----

--OGvdFptkhg15Bi2k--

