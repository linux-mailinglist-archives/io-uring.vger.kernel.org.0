Return-Path: <io-uring+bounces-9218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CDABB30569
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1061B163E7D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2599C352FF6;
	Thu, 21 Aug 2025 20:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfRnDWql"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869937FBFA
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806928; cv=none; b=T1BqkbbDr6eBCm2nw1oEiwATeo8a7rm4lTdOC/cDXe0B7CE79k+ZZ2idj2YYKTElqeok0Z+7j3rAd0y0VvxYofbZS191rq3L0cToQIS/TPj33wg1PHsRJfmJLd32FfNeqMz/mpR6VSim1lLmp3JgdjdLp/3Tz05TICLLQdzwU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806928; c=relaxed/simple;
	bh=izYuZWtM9expuJ4aw1W3JEFW5k9djBINp3Pti4HydYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQEDw5O4ma4QLkU6aDAp/ByHsmRdb5F5VdqTI3cnC9IpE+dP4NNwPm0XpWuCOL6ePK6YMkBN/IRNGpomTm720l7tTB5CNG1IAlBa5taUXiGpxd7NbxapbNN4TwImLNV41S5LO2JqtlHA5PDXXZ3o/SY57UZpudWP9D1qmTJOTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfRnDWql; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=gfRnDWqleQo/tZ4QAtrPQMKR/aUg3yes98cmHPGjoTSRneXIVL//IQrG0SWTbax/+5Iz/9
	ozw1hgbIbhMaJIcm3hzSqiWVfzGZ7WLufLzSMczJFDkBKFPEMw5zlWpb1ZFHB2I2YPlnlr
	vg9CY6UzsMjU9WGLhao23urW1yfcuAI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-LkTZAGLXOpGT56u3ncfeBA-1; Thu, 21 Aug 2025 16:08:44 -0400
X-MC-Unique: LkTZAGLXOpGT56u3ncfeBA-1
X-Mimecast-MFC-AGG-ID: LkTZAGLXOpGT56u3ncfeBA_1755806923
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so519655f8f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806923; x=1756411723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
        b=X98PjfmNminEb0wZlTomq2wYU89/emoN0Q02lDCvoWCJRvIITBVvwv301rt6vaqNST
         I7UgxXb4nw+mdMJ3Mfq+uCrQiLNyEK5xOKq06Vyn+TLfHRdwaPLyJjwGmeDLbArq1xH3
         0gy6BAakIsfvbxGsx53XPsPHguBgDqpp7pOuS7nbJFn5g97XuzyRuRbS+W3m5iaUBfNT
         fKadWW98MG3XHAd9nOLJat7uwO2tIj/wGjOYyO8RHi0QdkWp3fo1KZU2AsNz9xHbxX7/
         X4xYDvFlZOqn36AKC9ktktoaOvy+XJo4Ua/B7bDnBY8+ZM521cn5avi9yF3hf0bS/RtH
         AnFA==
X-Forwarded-Encrypted: i=1; AJvYcCUDNuoy6SXsOOXa7xBn+qQN3eblajr6PIqrd+E0SQEOvBEirQcB4UHsprLzLm59+LkzBydiLLQI1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDH3n/Mxbo1oyeLUKoBzsEHgSkPR7v2l294bEkxEDrGJf1r6pW
	j2KJQxBZZG6PP2A3ZXhXJlgloFxw5XZMjKy/+J70C73NdqxqiKJnSJIxiqQ7Kay5Df8XCwIslNd
	4VtNYvf8lkwtQLj1uKeNh13XGFHoj/l7UV9hBA98bxb8F73fRqq5V16SeR9dp
X-Gm-Gg: ASbGnctCOE72pB4N7okGfjccRIjnLw574hBnHdaql/BuTbyBSo8o6dxfqqSN6Kpfy2m
	iGjOTOkZo4VsJjvTAPEqzcnyETnZcbFtdxvQcGIpG2CWt/WsHRHdu6/vk3uaCzose/at87xaf3m
	Nz2DGC/Dk4yQuE2mIXr0gzxIMsmXtYY2DKvw9ji1fUdUfh3+xAph98xVS0OtU185rzzIFSWKQNN
	AWCUvI53rSMCEe5TE3rKk+PaKsp0ra/QLdEjmLjUf4womgcgn/fMFoE0ITcFyvdlI01oQpQ4W2o
	iXE3YWoVJJBQyz2vLM85iYFyZZ6qiXC2GEw3VwljKpciedhIp73b6Dl8TvonsF8b7DeWcMzjZQ1
	liS1J7f4mlIhPazy6yqs0EA==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204700f8f.33.1755806922967;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnHzRKC08dohUKQD/XdldMc6IWYVddiLtTh8Yidep5vx+5++gzVG23SiimMwYZ+HldR36Zkg==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204645f8f.33.1755806922505;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm10028205e9.18.2025.08.21.13.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
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
Subject: [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 21 Aug 2025 22:07:00 +0200
Message-ID: <20250821200701.1329277-35-david@redhat.com>
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

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1


