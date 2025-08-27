Return-Path: <io-uring+bounces-9332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B89B38D0A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9C2E189F716
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 22:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE12C3148D1;
	Wed, 27 Aug 2025 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YxfB55tj"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF931A56E
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 22:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756332386; cv=none; b=ASv0YdK4qgv1W7woXaaXHcFe7Zj2VuZ1QvdDAfFZKoyCWvALKk2/PUK0pU7VyO5EkvKYi59puv307W3s8VeyuF88peQWsax0jYmRpThzli9nq7dG0RMP2eI4k04EKiAKZ8c5BDUtc6SDAsXUNXu44CIxvDBojS15+bsCRZfR6uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756332386; c=relaxed/simple;
	bh=g5Pqhen6+TGsZaJhVjcxjHrty8uEIOPaJGSbz6Iayeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMrwz+a4KkEmpuPoOwsJCyKCYzc+/nvBS0g5CLWi6Z+PJCIrtIxy8WmuvFVkHjl4n31W0in+1HyuF1LTg7PwI95+rPdZkUCKFtwLU1vlkTP73w2a4dz7h1b8HFNJzvvPGdkMGPfofXxpwEM1wrVDJjJWQfLNWh1/yxdVyuh5jms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YxfB55tj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=YxfB55tj4tPH3P9wjRSWPlk4vvJ5YD+c+swNFzzzuoid74K4aipFAELZ28wkGJabgLLXlu
	E1JjD04aSDdq/3IFwoQ46E4ez2+vh+KTfRImhG+0gCpWygcQKPgkJ7x7A0VLqmSpmMvI0u
	nCudp8pcT65XmEe9aWwnxl+p89VhrZ0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-990HNXa9P7CWji11STEtIQ-1; Wed,
 27 Aug 2025 18:06:21 -0400
X-MC-Unique: 990HNXa9P7CWji11STEtIQ-1
X-Mimecast-MFC-AGG-ID: 990HNXa9P7CWji11STEtIQ_1756332373
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36F19180028E;
	Wed, 27 Aug 2025 22:06:13 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B193D30001A1;
	Wed, 27 Aug 2025 22:05:57 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v1 14/36] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 28 Aug 2025 00:01:18 +0200
Message-ID: <20250827220141.262669-15-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1


