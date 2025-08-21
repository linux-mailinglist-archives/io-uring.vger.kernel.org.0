Return-Path: <io-uring+bounces-9188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD83AB303F3
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFB075E667F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B3634DCE3;
	Thu, 21 Aug 2025 20:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fe9vujWw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50A533EAE2
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806845; cv=none; b=dCiNhq1DK82IEI0elxH3aPnMdiwUu6A5wmOzx5HDP0xuJWex9Yxw5jdUUW3eDhvrnLuLRfYttD/k3/zWtUDsFoDsUrWos1uXhAYGTolOcctGLqGK6Z2YcyTiB0oWG46Wb4v3OCEGBMJZVO08CD70zJotbGFLVAwI3lA+rWpKsc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806845; c=relaxed/simple;
	bh=Cw7Tggvlta2Xmlg9ZVygUv1C92bk8NKTD0n9SH6aeIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+P5m5vG3OBYEH5m/nwD7dK6vGty2UOEq1EVH1Vy32CYFLfaZCa9fqjU/qYhZqCftZ6IKNFvdmq08E4vXtlGxnleHXuky9i+EJKFhREsuyIg6ipxIR8jJYCS+jrVQWwPZRAa0Rxz/NamReHZmROZT0tzfIVHXcjRR2gSgUEWcEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fe9vujWw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
	b=Fe9vujWwy2AfvbJRTsgeNRVuYMvEISkETVC6cviDoOEq7YPG7dE3dYnJEP3EiZOcgMEae9
	JHsmvrMbC7WuM3A7uabd2gOCugG0lPCM8nXLDq8AWeb5Cg6lwZLZk1Wc/80Dk6udFc8+Jh
	eJupA8hXx1ZKwcrq4MvllfBvbiyW8ms=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-xYak_S8pPL6nZsDK6WYxBQ-1; Thu, 21 Aug 2025 16:07:20 -0400
X-MC-Unique: xYak_S8pPL6nZsDK6WYxBQ-1
X-Mimecast-MFC-AGG-ID: xYak_S8pPL6nZsDK6WYxBQ_1755806839
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b4d6f3ab0so8375855e9.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806839; x=1756411639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
        b=ZN9SAFZjIuNoDJNJ4TvvhQqVOl4iq+M/KO2sTsmk7pNxYI96oVH+1mCEJJzbJjpsg7
         n8LVLcsbap8Uai9+F2GXnZrLpq+c5qNbOi9EGEgf2FGyakic/6/xsBR9elnSuIM2baKC
         5GinCcdk0df21kxElqtm/j/qZWgSZKEDOd7eRwSh5WdYZQOApy5lXW5502HOTSBV06/b
         x/xz0VlUn2nqXqHM01InFDmYEvzMHAQbwxRAluBlQZseKCQ6Bro8tGukP2jnDJFOUkYc
         FavZe2slQIu0RCPBAiTUZOR3n8z/4boCb2tXBcYS4On0R3E3SNLvue1ObDQNrvemRmJo
         COWA==
X-Forwarded-Encrypted: i=1; AJvYcCWzCfHqWtQEOwxZbLjVecIfRLqCB3If61Kcku3jNJRJvMEWQRq1eriMPCeztWsGNy3XnC/M+pcDnw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq9Hyxm+H4Z4wDsUXcG4jtF72QC7btlW48Jx9tVp/zftJlOvNW
	Fx6v+ugCcJKncG+aZr1qXXMCrsGodMbTnhMQ9UY1YZ1RlGokLceSOasfmVmNGAHCJEk3Ltq9XU5
	v16qNubE+WYeCJwbBNn8mEJH8WehBbUmTdtAemxM8QxoSbnfQvs79HsOJJnNE
X-Gm-Gg: ASbGncs1vdJlcJzg8H3E6i+b923O1jfP/rZMmhfReUmJ5HfIS2si1qvvEjqT9uWXWdd
	XviuBR87Ww2gFa3jmRV7lKeLUJJ0vFYEaY82BDqwE/gFP8a3CM98OQyqBjc8qdGZftAyjS4di7p
	7+0sWSDZUAOT6M+6ShdDHkY2lFQR530jUFSDmWQ/TDjj6tkpMgR7kRA68iq/yMmc0BvxZQk7/jo
	inaygLaE2FpGlu4nEfGvmKUAmpSFJBri5Uxgn/fpWr04YHehu6LYqBWfc4tBBzR5k1Ph7LyViM7
	KavNPc22mWKH3Q4u23tfo7S10TZ1TqOgNP6U6soMwu8v76uvm2VwzaqwRbdlYCweI7PAVF1MKhI
	0ywiD4nDmFj7bmHeZYK1APw==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845665e9.7.1755806838967;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMhnqxttMNkrL8PAxIX9Mfq64uKkvY2MjzJ39LtAH2Yg7PxwVl8kOZ6CXLaaMF5rYTxrWwyA==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845125e9.7.1755806838506;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dea2b9sm8988005e9.15.2025.08.21.13.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:30 +0200
Message-ID: <20250821200701.1329277-5-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100e..e431d1c06fecd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-	select SPARSEMEM_VMEMMAP if X86_64
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool X86_64 || (NUMA && X86_32)
-- 
2.50.1


