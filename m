Return-Path: <io-uring+bounces-9323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15424B38C56
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79FF11B2529C
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 22:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF3731280B;
	Wed, 27 Aug 2025 22:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuaKfYIm"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F12D0601
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 22:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756332238; cv=none; b=Y/PjcHzLVWSl9dskLTrXUlsh81BWNj7zvUg0juTvXgbzf2vEbZyDBgvfWaDbMWL+ViZiKMg+Ryj8WioQhqJBXsgNeCvTInQkDi0W91DbpHSSaDFojikm1JyAilBx03k5Cq93wmJrg0J3ENDc60NwwNFHupIMivNhKfGxoY4j2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756332238; c=relaxed/simple;
	bh=R5lxx77cdoP4NbkMBLOncLKRL1v7VrMSDCbLG2aQaxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSrVB/J/N5q4nSOU/un5F3R2iUXgFlNLHiIp3yfMH/Svz6ntOs41rZD/kjFQO1BYCmsaHYRsDQSqVFs5x2qgMtTy1y0zytiRQFiKYpTsOgPLDy3gNhtKmDc56+M/K43Cx95Gz9Sz9keHV/BCeQkhvbGScvVW/MUUBEBwycNSV/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GuaKfYIm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0slYk4bfz75S649wa7kW6E6tBTFrSx9AC44N5jnD3cE=;
	b=GuaKfYImW/yUOIY+WipTte+R9N2S8Q/pQE3hrePVGn6Q3DBiMU+JykpN7YFlbOJP07nn32
	Zfqpd0iVEYstBQpYRJiLMGX9gv8p8wNhPF4cQGQAG0mtOMp6hQcDGbJ6EF99uEfH3PIQuP
	zNuWCRUvY1H10y7TUFpiR6SqTg+fKj8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-Gig6YInBOwuPYECmvWEljg-1; Wed,
 27 Aug 2025 18:03:53 -0400
X-MC-Unique: Gig6YInBOwuPYECmvWEljg-1
X-Mimecast-MFC-AGG-ID: Gig6YInBOwuPYECmvWEljg_1756332228
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A462195608A;
	Wed, 27 Aug 2025 22:03:47 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47BA430001A1;
	Wed, 27 Aug 2025 22:03:31 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
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
Subject: [PATCH v1 05/36] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Thu, 28 Aug 2025 00:01:09 +0200
Message-ID: <20250827220141.262669-6-david@redhat.com>
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

It's no longer user-selectable (and the default was already "y"), so
let's just drop it.

It was never really relevant to the wireguard selftests either way.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 0a5381717e9f4..1149289f4b30f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
-- 
2.50.1


