Return-Path: <io-uring+bounces-9191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68082B3041F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD18916309D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2412F3605;
	Thu, 21 Aug 2025 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSsGRqUw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA32D7DDA
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806852; cv=none; b=RN5DqlflcqwVMdSytUvN5+SV3WG4Wxjq2SkIZPicZbc1+F3XTBAvDI5G3AxvdAzv+kCaFXmk2NYGrkFJUSZbmDoPaaI4IYhDnOUjaH9XRjuL2W+hqPhH6Ttbq8+aUCgqm4NvZT5T5W8OjRzJW0yNiZt1W0AeKWABe1uNOPgAFYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806852; c=relaxed/simple;
	bh=s79Oeg502W4xdw3NRVnr9AKhHVyvkgzn8FY1ksnzdKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3T/UcEWysTvbBzR4o8VClU7V/QL/Cjubm6KmCEevIdEBdgc9o+qEsvLuHvpjt5hUa2YJ5wwIXxuZak4aU6hTwmbtgo7iU1XO/LCvquEGg9nvFp40CWv19hqJTFrHquIktMlRDG8yAj1Xznu5WHXzVMcHSbJBGHaibCu+xlymnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSsGRqUw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
	b=jSsGRqUw79W7bpmZwB47eydkIHMJKZ+rKdt+XZha96SplDiDAaYrxwbZOXato5gieOI/KE
	3In/plysguHc10KPt2VUYFWKScDQ41ty5hiRqi4Dqu180eyY/LlJFRwHRLNq2TR2kbFwHt
	3TfdkpBygJs5WrS8m6E2dGORxeFMIlA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-x4nMimTmMrGAhRkVVTzfKw-1; Thu, 21 Aug 2025 16:07:28 -0400
X-MC-Unique: x4nMimTmMrGAhRkVVTzfKw-1
X-Mimecast-MFC-AGG-ID: x4nMimTmMrGAhRkVVTzfKw_1755806847
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso10735195e9.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806847; x=1756411647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
        b=mxjojztHn9jnyHuoX8pZVUveTfwGPiKXPOvqF4rMIZolKlSEye8ps7+5wEXUj/wI/N
         xZ+CKVzK3Z3nU6Zu6v+stZe73Lw9wgkhIuGiIFp7e0tS+pmpR3bGFtru47yrQE6xHytn
         0W69IcAYUM3u48hbwTFoH5btAhsu/iD55IK4BM67NpX4M7YbXYxPcrYgpeLiZp3kuOaE
         FXQuZbxbODkLvzb+5LcHxkn8JHpScjFTNmkruR9Zm67qJRyaFFrVYYP/ILBLxNHkxL/2
         hvAGZRUiWiX+5dDvwxkJTCi5HqpSV1VweYzTusG7BviUJIH3BS4/gp5EWHNs0yQ1vtAM
         uSGw==
X-Forwarded-Encrypted: i=1; AJvYcCXfuULvhqMm8N0rzpmyqiMwWizMDBogxo7qdlpoBu1X9g7IT7zFpVGOBaMOhvoNW80TXjd4xbugtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxV0zz6EK+dXeqHCEx9jDAsejp/oOKm14M9wF3fHRvBmSF4Ppdv
	xmzDor+terSzTyJETqmgrhC/zOWqSW2WeLZcQjfsMf4JlH0BpmmKlLQmKj9hrsIrAMineILne5G
	lPvs0qes8SC2U/9l20eudZEyTeXkM3I4E56s1jXOGUTBY1DhJq36RHikQKnZj
X-Gm-Gg: ASbGncsxuWZ9BB4dCGDH3YT6nFgo9dAE0vQANs8mx+ndrZozohsZfla36zTuvV6kWAv
	Rf0Wfg+wr5qULNu2sfD22phhIMX8wKSETCJ5Np69v1pkWa27ZUp/mC5cGm1AWINcqNf6H5EtUFR
	y/zGEG1U5ZA4G3w/i+nrO1pYKK0ifmS3YHX5ZvQa61/AhHlyYlf0RSKWEVFj+reyt1JbE2IW2U4
	efAxaFp2AUgH9/fAFqzV8jPl6ci/usnUSnyWKiR1q0zGNx4/ipOIeKDLEuVtKfma7Mr6ZyvfzTQ
	31D8sQLHROyLpzW0lBeL39XUOxMetbFX+2vT1XDGLUYRdm2o0cUPNK2k+F86LwPfd8NavSl5SDD
	5yDIHo6fO5jh2dOa6fJfWUg==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921935e9.26.1755806847195;
        Thu, 21 Aug 2025 13:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUeapMM5JkcwJNJXC+LM6ICHu4lGUEF2ir46AAuHXhYXAFzTcPIdec/q/lplZD/isU7mGEgg==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921795e9.26.1755806846742;
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50d62991sm9535385e9.0.2025.08.21.13.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
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
Subject: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Thu, 21 Aug 2025 22:06:33 +0200
Message-ID: <20250821200701.1329277-8-david@redhat.com>
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

Let's reject unreasonable folio sizes early, where we can still fail.
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible? It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a
WARN and just report a proper error message that indicates where
something went wrong such that we messed up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..a2d4bb88f64b6 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
-- 
2.50.1


