Return-Path: <io-uring+bounces-9649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8A8B49346
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 17:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5BAD189A9F3
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 15:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19D630DD32;
	Mon,  8 Sep 2025 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsNHM3XM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5219D1C3BFC;
	Mon,  8 Sep 2025 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345320; cv=none; b=F9pRQWTJbOQIZLQj7TecVrUNYsIGKvkgMlnKeWQZ+02DXiTw6BJ+cEoUMEOqTrMLNp9fGj+WHqD3NjN1C3nnemMdMJt7OiIuGQCsDxWe2UQTNph3/NpCiO5uzJufEwk0ECni5ORiKrdWxDj4uOJdFAZLsIy6/r1Yz/hbUfnvnLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345320; c=relaxed/simple;
	bh=Do6afPicQEb4NL8JqQTOF9ldvaOz/50hXlHx8t3d/Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGzLNGERbTrHqbtoaAGb4TQXF+tEIIiNimSM/AXqX+OsGkIqDygdFxI8mS+JceIDO5vj/+yVn11gApDtU+Sn5tLnMFB2ihSn9IfvElrfAblBxPYST6mqnaCU9y9i5iSRmjLkMe8bK+ZPxiDhYnBPoPZZ/lhHUAMMaWuTTRSFgTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsNHM3XM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A6FC4CEF1;
	Mon,  8 Sep 2025 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757345319;
	bh=Do6afPicQEb4NL8JqQTOF9ldvaOz/50hXlHx8t3d/Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsNHM3XMtszyc0MR1l+7nz70Pbv2C2OaoFSsE5TqVi1L0TWseb3dm8FxU4bOhGA4x
	 K4Pbr34ZZu4GjLSy0wcBOLtbTfSDZ2sZXwcW4q/GMOmsbSZpLzPh3VE05cQHN1bvx6
	 51Gz7lPPEfDUpWjzsa4c4LUlGmtD5Yh+xRUZwAvoz2gdSvkS4s3poGD4jvdFCM3JbR
	 k937DQwE3qDKhikqJJbGzJuWzvxXLe1oyvTjXmvEVG3yc5Fy+l/qJEMutidM5xegfs
	 8U0ArRBNo11ISeeVjRQuNSccclJrtzFk1VDZN9ty2Mo1sIkDvMoHTI/K2PNGM65fEw
	 HzowuB88dAXMA==
Date: Mon, 8 Sep 2025 16:28:28 +0100
From: Mark Brown <broonie@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <e8428944-e2ef-4785-b0c2-d4896b291cb1@sirena.org.uk>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <f5032553-9ec0-494c-8689-0e3a6a73853c@sirena.org.uk>
 <83d3ef61-abc7-458d-b6ea-20094eeff6cd@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DHpSdvAG938A2yDi"
Content-Disposition: inline
In-Reply-To: <83d3ef61-abc7-458d-b6ea-20094eeff6cd@redhat.com>
X-Cookie: Air is water with holes in it.


--DHpSdvAG938A2yDi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2025 at 05:22:24PM +0200, David Hildenbrand wrote:
> On 08.09.25 17:16, Mark Brown wrote:

> > I'm seeing failures in kselftest-mm in -next on at least Raspberry Pi 4
> > and Orion O6 which bisect to this patch.  I'm seeing a NULL pointer

> On which -next label are you on? next-20250908 should no longer have that
> commit.

Ah, sorry - it was Friday's -next but I only saw the report this
morning.  Sorry for the noise.

--DHpSdvAG938A2yDi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi+9hwACgkQJNaLcl1U
h9Dbtgf+Lll52kCjsemPK6UaH7DQkWfZmHDqtHqLwe5SzgAfSeqnhQgasjG5jMSv
Nx5981jPRrpwjz/cI58x/+7VGV4mHF331CfuGkvW9jVYKznATgc/3x877cxjQPYg
I0fxXcE59j2a4VQrjcWqpuF0unCRYckVgvCsxK0iBkltPEMKR6iqf1xBECY8ofae
HYKT9ows31m6zoR1t0ed+9WHQqIH9nlo9gPcNJm6Vw2vMSwDBa5BuQv3MIIyOFq3
9MutZOCRam8c+vwt91HNCNUP85vbnHqG+eZCecu4Y2rVwHaENgW7ayTBrmb1OQ4G
cd9uBVEvCzE0tE1Rm7r+1srw8xc6vg==
=z4uX
-----END PGP SIGNATURE-----

--DHpSdvAG938A2yDi--

