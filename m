Return-Path: <io-uring+bounces-9197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB58B30462
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CCFF1CC58FF
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928EC352079;
	Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jIRSUtF7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B88834A31C
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806872; cv=none; b=J1aXzs0lZhS84yzmlQfbmOuz98yxBAk3IGytQqgsS3t4pi/CCt9KkKHoiTycMQYl5c78h1IQ5/veNqDafish1OP+fp19TvqDUSuwt/7/sNg8OnbBia8UPwT1/fBzrtbPyrYw4+zNz3/aSMEbCelDmfFTlXTvuL8UijA+lu1JmdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806872; c=relaxed/simple;
	bh=g5Pqhen6+TGsZaJhVjcxjHrty8uEIOPaJGSbz6Iayeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkwHvtbT+yJA08QqqysSOpmtpaGJgGnp4ryfVKVBC5sOsCNDYyeZlYmpcmPYjFX4QDmPYUpda7VmjRmG9IwsL+iMNZiWD9qnBJd/T9JFYREuS3qqHiOS6y3sKKFIqun8ESSAVsr8zmaP2HmamZwO5WBLRJQJW/jKfFOzklRNoao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jIRSUtF7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=jIRSUtF7Qsx0FT7WrG0s6ptvTaWbRuyOa0zj3WIy++xstX+EEKPU/aaEoPK7eplS3fmYF3
	pdniKt+n9l1WIdXbIwXKD+vnOqjE2bydKBQmH/jfjPhj0ucj04ezfkrl5NdHgKlds0kthC
	sX6p/Vv8knDVTkt3t2upH/Uf+X/Tn1I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-Z_1yFUAWPeiWh-zWBW0BKA-1; Thu, 21 Aug 2025 16:07:47 -0400
X-MC-Unique: Z_1yFUAWPeiWh-zWBW0BKA-1
X-Mimecast-MFC-AGG-ID: Z_1yFUAWPeiWh-zWBW0BKA_1755806866
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso7260885e9.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806866; x=1756411666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
        b=qvky4Dgyc03SwOwhp6bpKxl5i3HdnlmTkAe7BrQ0W+elfp5WLUWJKUHn8Itv0YSRFd
         +4KSt1Imj9GE48cIFE5HF2cmuWbQHJpDAGBhGDisObfF4OxWLxsfJWxGp4h/j3es1qy2
         i0CZeZADM2eWE1rz4ph4x3uL1Slf3ZG1b4pRydJ7eRu1ydPb5cN4unrfb9J8pKOWhHUW
         p1YugeNfk2Tn9s2p5zfl3Y2virFhoQNF63hfcagWo6pMJi8skQLDFxbcXSufFl/JO8j7
         KR1Q4zK3uWrZ26sDfo2+YS1cJlgOCBvU3c6+2esMnyd5E9H2uQo9SojcpF/xGYbfT+lt
         I5cw==
X-Forwarded-Encrypted: i=1; AJvYcCULeQXgtqc/Whrjx0ihWyrwOA24LTUyWDZa/rOAhXIL+3cgOuThVacle0cPHKywGJavSW9gEj6Glg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzboBU90yl7b6PhwQq/d/ZfguzHCcAL8yYYdEVgDgA09WhPFRZ
	VY093rHrc0FVBRMncsKHsPQKjrtCj1UkMM9Tt7k+TvWK+ZNQlueYma26M/2SshioXOux4iwlpws
	ppQo+cEDULki36h+G2QWO8ZOqv6O1sqyNMi5tEngT6bqT3Qr5fdO3VGhhzCXK
X-Gm-Gg: ASbGncuLVVoCddy8wYP7uqqKbcOpCHMePobLxnn69J4ZHDcX8PvrLpoTKOVgbjlmqrc
	GSWCQKf1FPWAHAdDYMSFKjybZWmXgJlGU/9U9wai+rRVydyEEeCK2A7cGGSEdo5ZFUHuguJtp1D
	QDSYz6/Z3EjI2oX1WazKY9XIo7DoHQUGUWbO7ZXKbKkMnRYRJbmNzzdFY4aElgAlx9vCVKJu+hq
	6Bce21sPHIvhFx7cAoHeiUh7P7Uqxdr/NgV5V02s3ZGaRxQeUqM7ZDQMQc8eJAxKydCa0KsZ5A8
	KViqKfBMNc0TzeQBgsNpNvKpVHoVsiBJMV3WCOpnSAIyFx1GJzfX6Paf+sAT1WVHPhCIj6q9rKi
	9+Dj4MdciVfNP+iA6xLmQKg==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819605e9.26.1755806866198;
        Thu, 21 Aug 2025 13:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUtzGc4rPv18tjnV22wd1xjfGI25AJiVbHUBF3o7jj7YvZLrrv8XzLc39l/Z4dCqHj4yY2QA==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819075e9.26.1755806865726;
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dd0380sm8632985e9.10.2025.08.21.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
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
Subject: [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 21 Aug 2025 22:06:40 +0200
Message-ID: <20250821200701.1329277-15-david@redhat.com>
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


