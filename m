Return-Path: <io-uring+bounces-9209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C699FB3050D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34FB9AE3F48
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DF2350830;
	Thu, 21 Aug 2025 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N9QEUCIo"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E5B371E99
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806903; cv=none; b=ZS6jeoqlsJ2/bZskBgglgmYcE8RPK3axfolEUh6VIgJARTjeLtKj/bG43BGC0u47IacFGddA2nXPuQsX9COMMMdUEl67yn8u3eW4uNid4Rv4ZRGtGiXMnHz9JcXxEcJoKD1+r540kMq6vklhmN0uoWQa1vWmcnxXEeT8Xt0iqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806903; c=relaxed/simple;
	bh=r9aVOOwiYkYkJ2XxN3c4oDiixJCUuv2T31t2h3Fc0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK2ZqzQQ6QZbEpM+0KlnxEcnvr25oFxmRwgGW8E6A68k9neWY7OiKAAXtN0V0nXF8uWo9LNJevz4PzdhQeSDHSM65aQ1va+6k/YKG0bfaasoGNxRYrP+5Cnl3jsvIZahS8eY1l0QvwuTXTvRwYWVhAD4kPXY0YB/VEy1hNVtsdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N9QEUCIo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=N9QEUCIogiC101Gz+YwJ7Z7m5vi+HHY9IpUIgjXUtBM7syDWqUJa+AJfAQ5H2r2M43Eqmy
	7X1YutAKrYObOYmfElxD2g4NzUtgx8+zzkvc1/UqT6BaZVtJ8gutIyh8VpIRMsMB4esQTN
	UV0e/P2IDG3ZWLOKyQ10zRNdeldVxNo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-hkNpk0jLNtygrQBPC9lT7A-1; Thu, 21 Aug 2025 16:08:18 -0400
X-MC-Unique: hkNpk0jLNtygrQBPC9lT7A-1
X-Mimecast-MFC-AGG-ID: hkNpk0jLNtygrQBPC9lT7A_1755806897
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a256a20fcso8254305e9.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806897; x=1756411697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
        b=fI1DSc81zCF0SDgnoCyFdAd1BRWQld78QgEkssZs8Jumh8VDG0ZHqKa+rUXvJz3+mq
         sgxWezpDOsGP1I4BZsWdPpGQk+S5HnWM9v7xUHV2ecZ1e+/FrOwqCxqdKfNBcnyRw7+S
         Yfvl7DjwXZLifO2tPTESCDf/Zd4CtbUBM4rpEttDecBZgn9aIs8Ap+n18gN55PaD+RBQ
         /eshJKWIwGjqhckePEt6s9AW+75IuYWPwWyGNeoz5IIugd7PXXxPLyG4xbyW81bCrv+j
         Nz9cjr49bcFSrEdmt3ZyYuIRNujh6KifQTHKW+icgQbwEP9TaHE8JIHTj405LHKkXNIj
         qDZA==
X-Forwarded-Encrypted: i=1; AJvYcCU4WRKt7Fou+N4fjZ1CDcXOg/A0KgHpn6KgRb3SOtP5HhjgQ5IHLVtrMTv1ZmXlNawfF1gWeNeP0w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2RX8r2b6ngQkhuCbm1shp8AV6FbmiJL1BOSb7XrmOyUPwHTv
	XRYxyFUiCk1qlC458p7CRkcVY0p8hism1+pvxh0HrT5gsy6OHTn+O2yIEzEtctau4Y9fbEumqhC
	gwzIhvgX6Eib29oePlfWwLAxlhtOCm7GuIAMsMf77IG3yBZxEuUXe7xJZMBqX
X-Gm-Gg: ASbGncsFTwmFiOFO2K68XWaN8yJN3RAefrbXM9nI/22WlXy225K/3D9AuxuJTTOXFd7
	wHmAc0YIRW50Y6K2QgIzkuwEk5fofEdfOgxHd6f7YR2+axOoiR/yUINvCnqZdWKptNHYhCyTyfj
	6sB0CGQw/+BKmy6XwLEavkH3FUKC8hBHpuhR/lE93qF1PQ+HspuKHyHCw0/Cl9vwfC5FJuk0IAC
	peLBRMJ8f3qZQqAnuicXWDxhBuX+8dmqEsMudhi5wUoaTygD/UJNGzntG0l4G0EYju1/azb9D1B
	gUowQW47WAWGT40IfA4O7AOTVmKt2qoDujBUlkRWAAnZ2sEIpgfV8092kR2IyQZRyimk89B8Zu1
	Nj2XuOyYJJCci5GRoKBxIjg==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505915e9.29.1755806897447;
        Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPdYXvWWhsiYzUao4v8GSpApokx2tOJxTxGWaryOs6bj53AmOc+7o5w7P2pIRGnKU6jzi+ow==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505625e9.29.1755806896948;
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a551sm8831035e9.19.2025.08.21.13.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:51 +0200
Message-ID: <20250821200701.1329277-26-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1


