Return-Path: <io-uring+bounces-9484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05723B3C96B
	for <lists+io-uring@lfdr.de>; Sat, 30 Aug 2025 10:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0C1516E439
	for <lists+io-uring@lfdr.de>; Sat, 30 Aug 2025 08:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28405248881;
	Sat, 30 Aug 2025 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GuMcrSCS"
X-Original-To: io-uring@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39415BAF0;
	Sat, 30 Aug 2025 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543922; cv=none; b=HM6Orj4ke3D60a+EbFudE0smErQr7lrxuB/yRJH0l7Ia6eduuHoqvB3TAqyDYWqj+MzL9iYxw1eqcCEcjyHZCaT3aMsl5H6cm5vc2ZZUN7VjjVxAoSJ2DE9YIAYw8NIsKhxzjToxJOKkAJaQtYi4o1MeT+GsDy4G7HP6/O7spRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543922; c=relaxed/simple;
	bh=LdU1RMECgRUSivnWM7MCoW1DKEMHMJgOPQkH0K6OPpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PROcAue8buIucJ+NZsUK6REyOHTWyQB6IyjFc2s9pr0LrNaDA9cTuTzeZUMdaxmF5gM+p56l5szK3cfKfliIKlOqJK5YS1VayVBSvu2ULgBnO81TTAibF95FYpmQ6qvjcrQm6PFXanlnzqbsWwNTTKY8dwZqfcUosaJInEHfEnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GuMcrSCS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XvJAs0oWctTv+IZjXYqOb/DT/digU3gWo9ZFZvSPVF4=; b=GuMcrSCSc2h6K85gbh7d/Dq9GZ
	qdyNHDeRuMDOrQKt7Bo9CsxZu4fhi8uxonjr50DYybHV+WdJ7DHOoy71QzTrH5fU3B4gS3MrLLeJZ
	1yb0tB9r6ZBYeK/9cTotchZKYSs9UNaevFwWoiFaYrA1kDvZB73V07IEjWM7icXmel06ejOyu5tRM
	WEVmUV2x3M+JWaNqJjuInd5prsC/KbA4Dm0FGrf3ZmC4vszTKkk+/5RVJ8rZbwzjF/v6sclO9TSJ8
	zA89ssT/UNPKwDgfBFykggaqbG5N2LfCnIeOoYXu2AZxIIqU3jrjVfeakPWp8OpxRJWoq6dq/+xUB
	J8hgQp0Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH32-0017AV-0k;
	Sat, 30 Aug 2025 16:50:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:50:52 +0800
Date: Sat, 30 Aug 2025 16:50:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v1 32/36] crypto: remove nth_page() usage within SG entry
Message-ID: <aLK7bP285OO83efR@gondor.apana.org.au>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-33-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-33-david@redhat.com>

On Thu, Aug 28, 2025 at 12:01:36AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  crypto/ahash.c               | 4 ++--
>  crypto/scompress.c           | 8 ++++----
>  include/crypto/scatterwalk.h | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

