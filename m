Return-Path: <io-uring+bounces-9185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4613FB303EE
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BAB8680495
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA7B34F480;
	Thu, 21 Aug 2025 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMHEgVhK"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F62034DCD4
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806837; cv=none; b=f8cEDC3yLdoD+WJ08r3aRaEg4toqfgjpH0IL/B65F/TkqXmZE6ss/sC/iFiZkSmE9UNWiNsRmktL7LFel2VXJe2H1qItVGgcZK/RmkUqV9BRj6eY32R5Xim8zhwaFUv7evt4jMg3fHBP2SbaaKL2sgAA/C2vpZ+8viiTWk66ttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806837; c=relaxed/simple;
	bh=6nSseGe+74q2JGOSoz3zO112Eo1zTQLz4H2FdYfsyUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN91dqAbu1L+Y0IQIIC0ekKbfJFxoBdj4+nTfp0hwpdUuzWIgmzkc4VN00LfsBOxcJj5dwvFnbGBY3RTp2387lfDlJWmzWk7FGUoj4jvewWPRkZFWBFZcwInsdCsXgOL03RlQTbtx/WlyF5J8xBSBc45+4hd8KVmFKZBEFHs/zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AMHEgVhK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
	b=AMHEgVhKsAOyLQUcGBbH1u7jlwCNbrL5HmIHPlJd8fv6ZbZdXuUAP3R+3pWWr6I8m3nV8r
	QTEq1nHDnb9yAAcW7fdZZBBAFlz8AL8h2zb8RooTf1K6VCTUlHLNkq/N8OJojEyf0nJ65C
	ExcKJGjs3WheDpImxlwUxEbc82aadW8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-kqin-dE3OzmlCQ2Bu-am7g-1; Thu, 21 Aug 2025 16:07:10 -0400
X-MC-Unique: kqin-dE3OzmlCQ2Bu-am7g-1
X-Mimecast-MFC-AGG-ID: kqin-dE3OzmlCQ2Bu-am7g_1755806829
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so8767065e9.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806829; x=1756411629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
        b=HvW/zfjARB5+RQK+wtIJguSnhxEIBIIurz+IqQaqpKfl8G7EAPcU4fX2l8RGw/0cQC
         i+9Ml1H490JQSIzZOjspf1a904Pgik6jAaPUQkqIzVPISLL5IoNHjaGFZY1Nb2PBOQ5e
         D0M0sRQVp3kvtf73MXwaMEYTqeHYbao9MaJHfGCOxeKM7mIJZCCDgM7uNRm8NUON4FVm
         vubZQOjDiAZNXSE2hHUSTNypQxM2F4su0k7S4e1KWocH2o8QSIfHTiXoPA+UWanS4lYo
         iFb+Kl7+WecN++8fhmR60+CswVKYuWA10na8oevwpoowzEQcRF+n3Lbszr4u1tGnpdjq
         vc5w==
X-Forwarded-Encrypted: i=1; AJvYcCUUSnSWhEeIduC1po5d0e8Eu83Sv1U9rdKK6Fjk79Kx0E1qMn/Sp0ukMu5/2ulVR6+7pdvGNqmdvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzIXb9h1X+PqnN34bm/C/T6ZomC84j4Yj7etbds4RMuBm2FxfM
	sQdzI18tJxTSbo9ugVAThueT7RnarB1U7uGWZFoQv6rYqJ7liURFKemvRMwb5evJy//4mkcGFXm
	y2NhkRbeUe2KBAuixVyByOPgAaRGgobAFMoKOBiLa7WvQvHhxdv6oOjAwmGTd
X-Gm-Gg: ASbGncuEfvalvOphbz7Ufza3OCHuuKhdXUMqDOsFJpPuEPnHyw71fIbHzUP5KvMuWkz
	n+RqgwpEODQmYk6JklWk9oFNa08wrlMuHE7yEdesjVxG9X42n8ZJM9fr2/QcHQut7U3++qTtyQd
	KAYQdhP3+cp9pDnt3Vogh2hoKbOwB8lX4k/GT7ZnBilw9QYKlZWMbkUNg2tzGPxdI2nhGHz9k98
	XwobDDkHvBfC/6AkLQEYUz2gf2SnQ3xL8WK2BsLwHAdl90bX0j1CC/p7dryxTgt9uMcX08SWLai
	3/r/RMOrzVuK0v0lH2iK7xm7EButxuko1dqKeKd62up3kINe5Tj09CwKBSO+aH0J7PfHbCYo89t
	ALRC10kFSUBgeAGvjreqtUQ==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673475e9.17.1755806829473;
        Thu, 21 Aug 2025 13:07:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvYkVaGxfZdplMxnR9eu9+L8mDJqjqWM2enq3Cze2cE8zEp05huuco+bDpuuERUQ/1xaOAqQ==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673145e9.17.1755806828996;
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e1852asm8722665e9.25.2025.08.21.13.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
Subject: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Thu, 21 Aug 2025 22:06:27 +0200
Message-ID: <20250821200701.1329277-2-david@redhat.com>
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

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with
SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
like we already do for arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be
gone for loongarch, powerpc, riscv and sparc. All architectures only
enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
be a big downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section
(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
want to limit possible impact as much as possible (e.g., gigantic hugetlb
page allocations suddenly fails).

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd967848..330d0e698ef96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
-- 
2.50.1


