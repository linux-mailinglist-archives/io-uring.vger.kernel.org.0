Return-Path: <io-uring+bounces-9208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEFCB30502
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90551AE2B3C
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369FD350D4E;
	Thu, 21 Aug 2025 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aX9ONMgY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5941B36CC6A
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806900; cv=none; b=QmbFMp9wc7txImk8UUZBRhEQsp9FwmdS3YtX9bhwcD6GsBS3Sb68N7RfBKoiYnvus28p1GrxADt9jUSJcamCBQ9VVEsvwZqtfNqKSPVMzx1Cp+oJABgDzS62YV0qX5dVdLVKBSR9JMggjX4YF12bV6ZM8bWuT4HZpqA3SdpMyhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806900; c=relaxed/simple;
	bh=o0B/aIsMAhafmNCelOfWp+ALdEBw0Dyti3dxNNba1Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA9HUj/3qBh0KPmHZxf/Ri999IyLc9myLCSuAqsZFnExMOY1yBEpxauj1wvv2AifoP7EqegX0/DCZeDEo7nK5Fy9E2/ErKx0GXqggeeGKMrUFw+rWwMZUJHx1n00I7cK6AlZRXbJ2ge/OFD5UVPKhH53we/QyXtKNprG29rIp5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aX9ONMgY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
	b=aX9ONMgY8Vm9SFNoIXmwHxRPfk3NmbO6UISkA8vvEeo3SF/fDCQYUXNYDiwfvmFWOJ4lon
	HFolaJl5h1GSXNjWj9ptyUPBDd1BvVxQZAz5qhoYO/51ReECmFywElPz2/HhSnOjSlC21F
	bRBlMVJGNLiPkBF9TXx1pxNZ7YGpT4o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-uSItHErAMbS2m-pyGZMLKQ-1; Thu, 21 Aug 2025 16:08:16 -0400
X-MC-Unique: uSItHErAMbS2m-pyGZMLKQ-1
X-Mimecast-MFC-AGG-ID: uSItHErAMbS2m-pyGZMLKQ_1755806895
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9dc56225aso832772f8f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806894; x=1756411694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
        b=lpSRtI+uYuD+3dU39fyTSHLW5J8NpRH3JCiYFCb6bzGABgfRKfn5UI8Zu/la7vZpfy
         YrxSgmOlx9M0ReDBNwHJESJaD6CNHj+jrUFGi63cmpHA7WI0XjpnxZ0QPOjmHQHf377n
         YVk0kRi9eFPEGX7pg6QwDnq5HJwqib/de6fFDiNh2MPMFa86/YMiJk31DQ4gY4F9cOjY
         wexQL9VKhix5bHRlUL00QUd5jliZQUOb31khttaExiVk2aQ+cM5OiTg7MIkKk48DZIp8
         9N2dgSHNOGGY+kac8qSCxn2D401dI9SzhEtheqy+D/khRMsKE5uOYAm2x8oKgbpjEG2r
         +9kw==
X-Forwarded-Encrypted: i=1; AJvYcCXf2TNCGjO0PkapPpREekWxRyf2WfakmtOl2p0a3yW4hTQs0m/1fdDeLUMSfqtPeVzGXHlDfDzKUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzYJnwW0bVHhZa1A+g9eVHxo1kvb/Jwu4g5Jni2Nj0ctYP6Rzi
	RzLAUbCeBP78F3AZe+Ant3L42a4k6WAZVoXVs+LVRfYGOFi0VVpUKWd+2YVQFvojua86+7dF8U7
	EDzB0E6pm894gWiW5ghDxZ9VojG+C0wZ+eX1wZPWkOA+wSMomucCLB5isDT0X
X-Gm-Gg: ASbGncuLLigzLxru54wrnyEPz1fk5UQp6F1p18VmnHq55KMJlrYy6RS6D7H4jvyC+N2
	L1+RpJK2ufYsyudcw0KVIykOiqdkOIeh/2E4AGGlWSeBvwFtTHyr2i0zJVmyYeWWdp3sJSmBTd1
	Id1XxKHTgqEGLjfzc1/MkxMsZp8zR4LkrCVtOn8aOZ6KRQDSXyqfjgJbMbrxwSa+9FKRaasZhUN
	itVB16J9c2/yIejDAiIEceKuP0NlHDiIQSIapEN2cAYbO3qI49dc+HCB+YG1dXzToZZ39NHJ7S5
	GumUE1jV+uRKIy4WoRaTiiujNcGeR0J9CdIRvnQpNFaCR4t3PmRAKPMqz3cZ9ex/p8f7yHS5+ql
	dyC15IiXP4wbHRDP/UVr4rw==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215860f8f.44.1755806894506;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYrE9N2OTZOZSEOVxEUY9xhX4UsF8UOhI+5wOqBRpd/3VSIxUjVMLdiea20BiXkc+w3FSZ8A==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215789f8f.44.1755806894010;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12982954f8f.27.2025.08.21.13.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:13 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
Subject: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:50 +0200
Message-ID: <20250821200701.1329277-25-david@redhat.com>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/ata/libata-sff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7fc407255eb46..9f5d0f9f6d686 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SIZE;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-- 
2.50.1


