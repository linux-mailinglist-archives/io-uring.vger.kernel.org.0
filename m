Return-Path: <io-uring+bounces-9269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B25BB3213E
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 19:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DE14B21122
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF0D313536;
	Fri, 22 Aug 2025 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmWBU4Vz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1184285C91;
	Fri, 22 Aug 2025 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755882594; cv=none; b=bsanKgWmNcKU+nLuyLpnQSLETDHjtxuZRyKIldH0b1QGd9Rt7obZHytBU7Isfh+BOr/jn/lhAjKrRp2QIz2vR9lRiluwMY3UJ7BLb2DjJMg77RPblTvKhAP9ay4ewDZNE+g2To+ewQZefJ/0HwzwdhneF8QorC4q6vYmSV5CgUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755882594; c=relaxed/simple;
	bh=NEyazjWgDDK3Y8sTMLiPKtOTS94IEzEQJlr1MXdW648=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=blb+KATW03u+cDSLyCvIVamBMaBM3BO9IYu6uEPnelZvBc5e6XXqITWaxySX8U+Sg/H4UtVUGY9FtKz1tW+zveJXW2KZxEDSP/3VmtBEMDCxbyB7vv1X4NQCOqNluDz7DXDQQdzDbtweKzPx9cvxomvBQKtfN9sR8zBuA5HNZVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmWBU4Vz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506C3C4CEED;
	Fri, 22 Aug 2025 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882593;
	bh=NEyazjWgDDK3Y8sTMLiPKtOTS94IEzEQJlr1MXdW648=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmWBU4VzSCcAnl6Zdrhjx6ksjldQdRyRt8SGGJHoy1Xwe7M0wFFiAnOgc7AY/DT0q
	 lyqL/1TbY9lw6Mk6ofMnsxQa0R5tG+ekC6WUSLcyfnxUCURU/dBA0VxXY7c6IJ9LBi
	 dspILvQPKUlPvqhEvwNtu+fRhuKR7/IUmABwpf10OfXceruEb+htOjuVlClrNaqJfU
	 QZNtMHJYtlsQdWeTBL2WlQglN7zceCD+RoTlZDKPvwA5Fz0NZs4QmCTFXTFDq7ZuUg
	 eXWdY/p99/aQ44iT5rRcus/JttgHgvk0uE55mO5Gfzz0M9Zot8coHQnhPz2Tn/edlI
	 y9z5UNwm6HZrw==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Fri, 22 Aug 2025 10:09:51 -0700
Message-Id: <20250822170951.53418-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821200701.1329277-8-david@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 21 Aug 2025 22:06:33 +0200 David Hildenbrand <david@redhat.com> wrote:

> Let's reject unreasonable folio sizes early, where we can still fail.
> We'll add sanity checks to prepare_compound_head/prepare_compound_page
> next.
> 
> Is there a way to configure a system such that unreasonable folio sizes
> would be possible? It would already be rather questionable.
> 
> If so, we'd probably want to bail out earlier, where we can avoid a
> WARN and just report a proper error message that indicates where
> something went wrong such that we messed up.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

