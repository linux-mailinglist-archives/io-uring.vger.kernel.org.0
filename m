Return-Path: <io-uring+bounces-9212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2225FB30538
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4603BF3DF
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB3237D5CD;
	Thu, 21 Aug 2025 20:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BS9nNoxB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCC35085A
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806915; cv=none; b=COatSq0Aa+iAEjHoIo4tcEFTi/ISlEcY93qoYpzeBBcPQkci8HvFKBd//k4uchpPB9vP9kyclbjxDkqm9sb8bjW+g30K5QihaHVmoSNpEXSr+CnExl1+zhXk5fqYYTuEMPJofxSZV/wOVJeR0WNwyAujypTcKuCsj6TPSH4lKOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806915; c=relaxed/simple;
	bh=nQnlX0DDaNxbga/DhB7JLie8Amiy5HfSv4XT65Hn/xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlix/SbGT5vhjZr2FhlzWS9TqfSgiDsWOv44qj8nt3HiHl4gkBIP7pHcWNX8qFqWWP/qMejNng87XmEaVw00yEUlTsBz/TqTEoImNyhJcPvDRSaxDediVl4FDWAXzFcH58EvRFzdWDywLnp118f1SA51zEanNjaIjFUNgk4c0/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BS9nNoxB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kuJ+10C4pYxyWPcGDJkWqMBAcRGmXje5KFYns7NWu0=;
	b=BS9nNoxB9LNSSPFEYuIj6zIvn4r+TeaO6EcutLDAI2N+TZRjgxtYH5/wZLG1XTFMzzLgb6
	EVdjKc95wOia8wCAcAI3BDFaX9voriZlZB0yk8WLb0quE56mnpxcq+hajTKfdNVPbVOL/B
	ZejxY1PnDdaiW1QnL91ujH/ddUtzGnw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-5wt6_RygMiqmS2_2-z5TLA-1; Thu, 21 Aug 2025 16:08:30 -0400
X-MC-Unique: 5wt6_RygMiqmS2_2-z5TLA-1
X-Mimecast-MFC-AGG-ID: 5wt6_RygMiqmS2_2-z5TLA_1755806909
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e41475edso915759f8f.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806909; x=1756411709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kuJ+10C4pYxyWPcGDJkWqMBAcRGmXje5KFYns7NWu0=;
        b=tWQ5sSU2y3y63UcioIwR7NDwXX0EdVVrNzKHMLTDUKeiiMWAXF0W9wmNvdcV0U39k3
         GbRcKk+h3kxpUbpK1ncPBM+sYGFJI6ANQZ0wA1ptrhUFUk2zERyKjZUBB1CbttbHJL1R
         7LnT6KnbypkUOMth81xV1S+vyWCqTY0cRdqRIL+Fogp4kKcGpwgL4Ov5FWnvQTLY+DZn
         mdvLiVFUBVszH+c1sYmAe4E5uobwxb2K+ioP9OrJtXlGFOQUttjO41cnt/MDG3nTnCRg
         7CHzjaokbkZakNnIoQJPlHwzMayv/HIwjjIYGYIRct62GEEMBxp3sqiEEgiJXuaImToB
         BtIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFNfSKFmYAEmw9Gw0RJoA0kZz4/QF24dMFRN8E+eJ12biQDGK667tUjd2Tiuir5BTXyEumvjkvhQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxH0+MdohGpAdeLIkGn1Yc7gtv+g6gcIkka8V6W5JtEZSoZk33f
	WhjEJLbJIUrzUj3hsVYKZRa5NO/B0RIHKi7Qm4B2uiyEAHjE82uofFOYn/qlKlxF25CqxJTMgyh
	9jeWexYkWM+S172u6clKS2FkMGuEo78cgou/Fe3bKS812EX7Mixxyoe4NSFBz
X-Gm-Gg: ASbGnctLoB4qFYNh9sptqsfs46TzFOybAMJUKA1Gho7NSpwHZk47Q511gtu11y3TScX
	Yljoa4KfKmZcQPg8/3pyW7uHIdjYzKzeS4K/k28snFXDF1KzX9TlUqvLl6sSEuY28E2Pp+XC0Xv
	5GIXiD0FTWzbdlhHT6XoKUahZ7/MV3IYMQPIW5nHIoldFl2Rv7Vbeuw6vgbfJa3Es3m+0pBipbK
	nZ/i3AOiql2zcP1gyNOM4musmkeYVT2dVnZ0N+MBTBw7Up9lqwaBLiTkOYNmiLIz33JV6zl7ILU
	bEyLBkqmHT2wMUWMuJJRFdA5d4rhDXXdYtiSCNvI++Zn2ppG7e3Att1X0N4ydqzV6nrnwy5mS/0
	7Tx07PLA2HiUxxZW9EP8WLg==
X-Received: by 2002:a05:6000:18a6:b0:3b9:48f:4967 with SMTP id ffacd0b85a97d-3c5dd6bbb33mr155511f8f.56.1755806909406;
        Thu, 21 Aug 2025 13:08:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRykwWh31JVJGBkobbD9YNZEskJV981iF0h0FASAg1XfgxaqZA4MQnDyPntA4/emfIOpWurA==
X-Received: by 2002:a05:6000:18a6:b0:3b9:48f:4967 with SMTP id ffacd0b85a97d-3c5dd6bbb33mr155476f8f.56.1755806908930;
        Thu, 21 Aug 2025 13:08:28 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c5317abe83sm2432791f8f.40.2025.08.21.13.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:28 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
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
Subject: [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:55 +0200
Message-ID: <20250821200701.1329277-30-david@redhat.com>
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

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 drivers/scsi/sg.c       | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd6..f523f85828b89 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3148,8 +3148,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	/* Offset starting from the beginning of first page in this sg-entry */
 	*offset = *offset - len_complete + sg->offset;
 
-	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
+	page = sg_page(sg) + *offset / PAGE_SIZE;
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c02a5f7b5f39..2c653f2b21133 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + offset / PAGE_SIZE;
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
-- 
2.50.1


