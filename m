Return-Path: <io-uring+bounces-9207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0154FB304DD
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8725516F89C
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A09350834;
	Thu, 21 Aug 2025 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2kzACG/"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559536C090
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806898; cv=none; b=iAU0YUf3Qe44eSJZy1I4hg2x6Hc42HjYZwTmz8BHIm7tpMRFmTXTxuiLjAxf3jvEN30oCUI1rgbzj72KSsc2jtw7omhjyi+IpC/ac6oGPKJxmMHgkFmYlkth7tSEOUKr4MZOpSX2oNy2gK8ZEIpRhESpeT4pfU18ZlU1MS8m1o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806898; c=relaxed/simple;
	bh=kURokXQjB5Kuo7a6U8usTL1aQ1tfaOTG2Bf9aj2NBoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYu6drfqkP/aGHL4hen+5JKLEPYUdPwct/EE+AFq/vlG7ElQq0X9mjhYSBjEDsqsps0HHW7W4NLRliKXjIB0t8fUdwluywtXDT5UJKcFTf8bf3S+EDz1VgKwHXJoDD8Swam1VnOerkJjzNdfRa7dMZXBiMHv2ueIV7R1ordFxjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2kzACG/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKFS9/TuG2v9AIcAoooIJr3bGKW6zmP0XL+5izT5Y+4=;
	b=I2kzACG/XgO8fyV/UW5NJzt4znBSoXpxfY+JJceW7RcSLvJ3tiYmR4dJPG9N2Y4DV8PqSh
	ksGBQosUGSmvdlwn9XrdbSVHDuh4abHQqMb01qTcKD/uTU6XkGeOGy2L//fOn7YEZmSlgk
	527G2JfUjG4HmH+iMXma0t55Hezg/mA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-smErXcWNNCOJ-VlToDsmZw-1; Thu, 21 Aug 2025 16:08:13 -0400
X-MC-Unique: smErXcWNNCOJ-VlToDsmZw-1
X-Mimecast-MFC-AGG-ID: smErXcWNNCOJ-VlToDsmZw_1755806892
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b46bbso6502755e9.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806892; x=1756411692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKFS9/TuG2v9AIcAoooIJr3bGKW6zmP0XL+5izT5Y+4=;
        b=UB05quj4BNGIgjNhnxINrMYSGZLl4bmfy5vCSsj56+xafCSSy6kM/KfZz2Ig8XlKJL
         YJcuFsQrWhwVA0MmKv5UzGvHC4Gw1Dsm+TB1Wj68DzQ9/vdEbQXZLTf8cgfAEqPspN+k
         pk+Um1jnRx5/XyuRufCFVN+7kvkg6M5zLDtCCMojG9ij9xTt4WIpWfzRHD4T+jxR5lKU
         d0oi6oHSxJ0v8quC/rNkNRTG9pDsz0jQu6LXsmJMXfMuNxQC76GQm2kM3z10SS8RsOXa
         1SkT+CoqtQajNd1mxAmUsjpcOoJvUkdmYKvf3gka68/AYX21QHBB5IChQGl3/a71Psy2
         JRMg==
X-Forwarded-Encrypted: i=1; AJvYcCWagOXUkBIQ5gBrQNHVewWXKUhmK428UR7UHpbvDy7SeuOnVXDOkN2idOtSMVBUay/anl4RE4YuvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9zerI+DzLrtRPL8jt8EjpX5zcBYy5e0aSZHV7e71IWEy10l5b
	+Scu0MD6aNTMtOSvJgyUWF1iBkdMTge/V+fOWXjonhuDsBtv5elXeraFsSIr8QAZTsXfPTHS03q
	Qj+vA1dzeSKQr7qS23G9+AiAZUQsE5pjNfeNjUipRxn2EqODJJZZmkLm7DjBx
X-Gm-Gg: ASbGncv4rP7T0ctQPzyUzdLFpIuCqXbU4cHZ9wkYDkcWi159preXeJ/bd1fJy9Pue50
	wIvfshLFagyvmLWMqUdYYicuZr2SdAbyoVis9uSBFZLPppQY3K7WRMfm747cSBHjjh2+b9kzu8N
	rv7rYY8mLz5uImmB95R7T6eU4JY2sm2SKyVmlCcwSMnuLD3wFBP2+jghKfk8qiGDSWGoLGqBcfP
	FtZUy9KHy0o79eyvMfS8Gws+wMNuZOy5kuBOnHuevHaqRWR2hknDR7rdJo9iJ4G9jMbK9SQyi3E
	ZsAuSxIBTuoIMrITv9uBGi0g11x6DsZDXvGHXNetlKI24e+bg7dClNxLd536FYrSO4tV1WUE91Y
	LVa3USSoKUnlHarR+0lPOKw==
X-Received: by 2002:a05:600c:1f1a:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-45b517cbee2mr2552435e9.34.1755806891752;
        Thu, 21 Aug 2025 13:08:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/z26sBz7JGLAktk/cnLNnmvA2KmHoRy5M1TseKC0NpCNohvOWfWbiwnk6fyruz4Gv4BdEig==
X-Received: by 2002:a05:600c:1f1a:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-45b517cbee2mr2552235e9.34.1755806891155;
        Thu, 21 Aug 2025 13:08:11 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0748797acsm12277591f8f.10.2025.08.21.13.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:10 -0700 (PDT)
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
Subject: [PATCH RFC 23/35] scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Thu, 21 Aug 2025 22:06:49 +0200
Message-ID: <20250821200701.1329277-24-david@redhat.com>
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

The expectation is that there is currently no user that would pass in
non-contigous page ranges: no allocator, not even VMA, will hand these
out.

The only problematic part would be if someone would provide a range
obtained directly from memblock, or manually merge problematic ranges.
If we find such cases, we should fix them to create separate
SG entries.

Let's check in sg_set_page() that this is really the case. No need to
check in sg_set_folio(), as pages in a folio are guaranteed to be
contiguous.

We can now drop the nth_page() usage in sg_page_iter_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/scatterlist.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6f8a4965f9b98..8196949dfc82c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <asm/io.h>
 
 struct scatterlist {
@@ -158,6 +159,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
 	sg_assign_page(sg, page);
 	sg->offset = offset;
 	sg->length = len;
@@ -600,7 +602,7 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return sg_page(piter->sg) + piter->sg_pgoffset;
 }
 
 /**
-- 
2.50.1


