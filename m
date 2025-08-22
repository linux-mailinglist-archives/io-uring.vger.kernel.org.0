Return-Path: <io-uring+bounces-9247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F05ABB31664
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1E6B173668
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 11:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71052F49FF;
	Fri, 22 Aug 2025 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMubruNE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B721277CA4;
	Fri, 22 Aug 2025 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755862291; cv=none; b=gLY1LEsmW1TYKzlM0YvENdxJGhcOrnVj+s2qNaWh/FCLvrjPu+VveQEcF2NLlfk3uVwv6gRCSXX6sxZ2XActE2GNCHH2jqcgTerNc+BBf2gs/j4Yyiirs65rZ36Hk9fGczQUMOlgyl3aw9vduSMQZbdFsSNwjz4rWGEAARYtLNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755862291; c=relaxed/simple;
	bh=QxTICeIhRMERCgTBkORqT0sL9XBucsgusTgs9XuOzso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8WprZGxOwvTmSdbeAYopeC0ONHtMtWGLfrQJCAxEqmUF7cgoPFe+r4uhmTFJhSHnJbZr4uaO4hNReN8lYrLLfr7eORWonNE7j7K9F0ms8lHr9RpiSLrxl4GEOmZphL8dm2wFyQPMQUBkf84J30l96rIlQ9KtHDImiPlHTK2WZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMubruNE; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso9434335e9.2;
        Fri, 22 Aug 2025 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755862288; x=1756467088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SfbHPH5Jjp8Rpz5+ZFUkvP8crb1ywqdy8VPh1hjPgaM=;
        b=BMubruNEvhKpWVN7Y44DEKAVsnZ6QcGxFN32j8+1YyBZDKGgIEajcJoqSegm0jir7s
         BoocTHTYG8OSXLl5yTpmXaIAAMS4x/tjg4PxFwqOZG3D8jV3IJhTisL4qZZxne69/S/K
         HQBEhFVO6naJDIq1kiqZFnXWxOf7I0j4W06fLDTg17sbdVg0AqSazzwEI3YnrLCQt4BT
         uwuytRREG9HscRMkzB4pPuv2F/ESXeLK/xGCKoCaonvTZsQ++9mygIkH+JyKtQgWxoIs
         lCJVY3Cf8zTvIfTceApUmY2leA2DuJ13dhYKN/e2SceRxgFNhCc6CAZUbyYLL2eHNRXa
         VNqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755862288; x=1756467088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfbHPH5Jjp8Rpz5+ZFUkvP8crb1ywqdy8VPh1hjPgaM=;
        b=HpvL9lcua144BXaJ+h5AvLL6zqalA2ofOG8a5txDJkvpahwgZRVcv8V4X6bfYsSon0
         C3Y7bupoavMFdURadqkN1trXD4uhIpad2RPE/j5PTqrpHy89PV0SR85hkbT7OiZGWP65
         8rppjs4Blh2FFLoAM2HEVs8FVXaYnoR02CsY8pi+X8wMWpnccqzFGbaJbNOTfwnkS3WH
         usp5xTyLL+tytiqUqGI/eYv9RGOj9i2GpIiXQ2Gt4T4wcOG34H0PU2hkIRUeHdMbMFuW
         ikmwvO9AzriCvadIAxee+1qOhIDBw00nOomrZ65jZeGr3HpD5Tkj13ilad8I9DZqZuL0
         hvNg==
X-Forwarded-Encrypted: i=1; AJvYcCU9O1m6sDlWiZM1rcd4+bGf/GTjy3x4KgPimSUxjVAGPIyQIwjR0bLvaA6no2YjcxI5XcE7@vger.kernel.org, AJvYcCUJzr4ePRF5zzT3zwrS+sJAYTvyBWAl8shrwFrqmv/7quAIC4dTro6vYRKS/hnZSwYPWRKmWSNABL2+@vger.kernel.org, AJvYcCUsemyXlQqkDZhweTRp5YglVteJJQo84fh3nYYCLvOFBGc7j2niYdXAQYGsxLIVBwAgXApRMfs5DZqruw==@vger.kernel.org, AJvYcCW1Ed8sYNrIjYPW6Uo/9JNGGpg1Fo4mFSXD7vMQCkIjFwKToHrfBakYVKxKgWXLGc0YnWm7+N9y61RxzrAZ@vger.kernel.org, AJvYcCW1gLKT2NAkC3ErtP0vKWKjIGa5e1amqlL7xOcH0jELHEKPScpvRld/bnouWfjYWdWGs3CK5BIN@vger.kernel.org, AJvYcCW2yumLrMOlf9a9M+WAPUdMYB/5b1v/bG7zxF2EnAgNKkmH2A0/azlEcwEjX6xISKeyvrYUroj6j16udEEfjsif@vger.kernel.org, AJvYcCW8aKPpZkVFKieTBxlgVh/8dxod2Bp3LifliRxOG4CfrdqPoijMmoa+kJa/ivqB25B63a16LEniSOtDnw==@vger.kernel.org, AJvYcCWybWwXjio1RgnXN5astOxUGU4Ulz7wkGhs4IGuYkoT6iA7uLt7ZmfRi7HKdIOXVb7KYwUAGQJ1RT+jGtEi@vger.kernel.org, AJvYcCX9WTz1pWJ6mFdJB8EGogWIEVnDT2f5WbDmUexRA7yZ5zCuhFDBCaU8IGxQ6creRuczo9bvw7o6zQ==@vger.kernel.org, AJvYcCXknjyyeZRKQs/Jt8djUtMo8MUJeF/EMCwO
 BVu/6/pQOEEPpF/If3UX17PIXJQvYAJOFoTqPAUcWEx22w==@vger.kernel.org, AJvYcCXsA7rsM9SBx6MDkGUaCTPI/l40Rbi/44TETLbPmWnIKG6no+/TRsWDctqXKFMs4H7po2+WnsncgtRu@vger.kernel.org
X-Gm-Message-State: AOJu0YwkddID+wDK+lZ8JxumPMJFGT1TlX2r1hmYFldGe86nlcxatXOT
	i+phVVtR3+uvutfZliIigfjTWHzyv7YYs9mWmXLrZsj7xdKV1ukG/ETH
X-Gm-Gg: ASbGncurVePDMmMfveBJhj0k54mDiUmdw9Qd8trFyyFn8wGdElcvxibzoskuNfj+KK0
	GaJNq+fzqLNYLbWkY0Mfy0PVEa8xXOkUtiAUFj3SI/DduJcPHvb3loO46MLXiNwxJN1Its/r4vW
	xUiPZdXmQPZOqQWiw9+pV9Ywd1apEoXYJsgxlOwHsgTB4xcnMgrgkmbEE/Zzz89lPOHw7boI+Yc
	GyGC+gBg2fHsxWEGQQn5Fh7oPNn6uJPmPOPJ1PE5ZkuZM+5Bq7wwXUi0MKZ4ahfrJrM2FxClugH
	tM7sNqWJinDNZBICOcKX11sgF5ZoqTvp5mFk8QkcVpI1619C6ZXfOd8Cn2BpbSMynb7fiaK+bQn
	+6qVcCgfFjb9LqLM3MYpufceP+NdV7Iwgt38/vTs5BcGi6u5jod20mCU=
X-Google-Smtp-Source: AGHT+IGRxFKrTZ5eDvBkmi1zEgN6s0gJ3t3AoyWptSyZJnQ5Bb32czELomyx9FMDxkr1p0nFemiRbQ==
X-Received: by 2002:a05:600c:4747:b0:459:e094:92cb with SMTP id 5b1f17b1804b1-45b517ad81bmr24844685e9.12.1755862287996;
        Fri, 22 Aug 2025 04:31:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1b93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50e4241dsm35921185e9.24.2025.08.22.04.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 04:31:27 -0700 (PDT)
Message-ID: <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
Date: Fri, 22 Aug 2025 12:32:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache"
 and one nth_page() usage
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-19-david@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250821200701.1329277-19-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 21:06, David Hildenbrand wrote:
> We always provide a single dst page, it's unclear why the io_copy_cache
> complexity is required.

Because it'll need to be pulled outside the loop to reuse the page for
multiple copies, i.e. packing multiple fragments of the same skb into
it. Not finished, and currently it's wasting memory.

Why not do as below? Pages there never cross boundaries of their folios.

Do you want it to be taken into the io_uring tree?

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..18c12f4b56b6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
  
  		if (folio_test_partial_kmap(page_folio(dst_page)) ||
  		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
  			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
  			src_offset = offset_in_page(src_offset);
  			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
  			n = min(n, len);

-- 
Pavel Begunkov


