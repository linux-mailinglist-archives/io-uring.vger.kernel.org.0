Return-Path: <io-uring+bounces-9377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45865B39595
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEF337C28B5
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7D92E03F2;
	Thu, 28 Aug 2025 07:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxmgKBFb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEF72DEA7B;
	Thu, 28 Aug 2025 07:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756366680; cv=none; b=gvjZHxSC/eIodf4bXPWCDL3HR/rjHRl9VQMg/YWulSEWsRxDh2NPvzV/jktAVWDBsqgyB4Yi6IYfBT13v+fOPiiDeyk9x602vvr6XYoTi0H1WUHtgMfblCTMv0Vx70o9Xm9KGmcndA6O1qvnx57BRhbjTa15M5vhQZuC/OTolDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756366680; c=relaxed/simple;
	bh=Evx+qHc0PZj/WJzWjKhVcHVcvE7nkS3TygD2JsAVLCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnKX7GTeApjwqNIyVHJnSYf8q9NWNqmX/h+aMZyS0PBlXOpplg43Z4frUnKcKdUJ9yvNq3vAQn+h1tKWjZGy43gH9/CQ8JvcS2GPCDNhy8mxNra+wwgf94r2J5ftI48NpNir/iDGAYG+et05bms89nDp39e7Co6FyjPlSepoopU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TxmgKBFb; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61cb9f6dbe7so1131548a12.0;
        Thu, 28 Aug 2025 00:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366677; x=1756971477; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVrt2ctwbXgHbo+Hn2TZ0gCxiv/sLljbJFjbqAY/TQU=;
        b=TxmgKBFb3qxDi71Fwfir8qC2NoATnSBLuhH8SWGnYPOeg7duHU2JwIkArwAFRoI3bP
         1UabzhGWlZwCf/RsTaKhzAsm4ZFba4pNr9Z8NpDm0GkPzztUadkKblvlAgudTeqWiJ41
         TDtInE1meUgFCh7DHbDYz9NmYRD7IFZoQLRAnNV3AQBSAf0XTEdFtX+KOY6wOo8PcmT8
         Sjs+i8zwl++amwg5cwK+gJhH23X+AzADqygs33KEDHtQgOnJ/IWfCM9RUuBYMp2iGgru
         +7QRt2cOgQn35J6JJOfFQiCEWWaEZBU83leSm7E3HB20ChRtWa6Zs4RMywzLDmv1MrUY
         2p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366677; x=1756971477;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TVrt2ctwbXgHbo+Hn2TZ0gCxiv/sLljbJFjbqAY/TQU=;
        b=It98vGtiP9GToZHqC9/yImB+mjxQpKuYUIKW99JYChP3nTpFKHhM36ctVYBOuszzKc
         pV9BV26qXcokV8XUWh+roMeObhLjDA+Swv/7/UCF4rDwAnfLQJZ2ds/kRL3UiZJTkJ6x
         mps2rXVtatIsawknLYS5iwSIkw0YITv17MmYpVY0gMwmR8YDgR+L3AFy0MU7AiaBv6Ud
         IKYdVNtG0FTUQesusNZNduI4luUqRuBP2Pg0oMLvrzgdTNEtXQVvleoOTIcUjh6K+KLq
         QSry3OaIJiyHKIle6exZrw57i68+gTzC0bzjVmMbysROqwEFKyVNpbbtSeN+kFDW/4Do
         vxRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyvRsRjrcz2hzzNGL16dbxDF/oT2ERo6841HlLJYpiAYrazdmYZ9shyMjSsJJa9DFHBUhMDV0EaFj1ow==@vger.kernel.org, AJvYcCVD21Z5jK6QIxbxn7E4J8HcvcaT08u6vAmSN1kn8s2WxlWaFE8lLvOkyR1epAmVjRpKrn9Wh30bz4tJ@vger.kernel.org, AJvYcCVWd4POk1Nhd4qH9aO2VW9gjbiBlVubAygkSaoIs164i+Yz3tycLANwIBONwHVHoDPLDQMGoHDt@vger.kernel.org, AJvYcCVuzN2Ik14gnPBXS5F7HVBoXTDSqhra5WyGlGY9KDJX+d+lyJTL3ny1yp2I2oPzfiAXiIhAbVEbXw==@vger.kernel.org, AJvYcCW6Z/dRm+AhpT2AyGkKtnj+F84m4ksGDZia8xoI+l2caaWQ5LqXbxUp9nkYRp8WoBxfUG+NYTsoeWPotw==@vger.kernel.org, AJvYcCWg2znyOtVyxEyKGdc5CY1SQESXxeorFPDLaCJZyuNVAiz9epnP7bUPjnGQ0A8p4Xr+2YjzQcbqhKwBeQ==@vger.kernel.org, AJvYcCWlsJXmrC83UjiWPdw8oFGhs8eVXDkYmfIRhKmn1WEPTdv9gTqKWuuln8t3JlrfiIPuKWeR5Uk+EAGQacvr@vger.kernel.org, AJvYcCX5XVxqz0RnE8IHUNPnjOTwYZ+miOSvXFQW5MpO/b1DMe8q5f90ZuDVQKudRt8RSEbNETXTWVg4zTUT@vger.kernel.org, AJvYcCXKlgXpl6grbzlDYMbg1JmEqMofGRkyrP7ABPAh1qxAKK4ETL75YBj0Q4V5tklaYTifeAuL5ydes7kw9VPSOa/v@vger.kernel.org, AJvYcCXM7bO9uRd+eOZil5A1s1YzqLeE
 zcv5wuoME2IQAD5Nkrx/Fw8eX7mGfPFbZ39Mdn7+h6DJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwGxUCCkO6POPsL8jIYWDGHpwmVERE0uID6TCgomq8xGfP5GGS8
	mv6GnzHSu5iFSgtqP77oFv66pq/nA4WYc+Nf811mmDqKW+ZUnEwdpfp/
X-Gm-Gg: ASbGncurm8o+M71u9hkm0FNIVG92SdhVC4gRveZm8LZv8tj5gtzCAlA0ioiqz0D4f5r
	rfFYTQHF2e+ICJXQc3r+HHcOGWZJpSBN/NV6WpAQL2yPdLcid9ltZ8pFlRnClyABrhNw5gmAPLN
	GSNs2+eQW8hGoLen8CSNHjpSkEXki6H4nhb2Ofdn3FqtRDegMukRdcd1GlaIMHnZQqb3U6pTM8w
	gjnI1owNQCLuUcK0QoXF8qiA/5hr0yZOB/ZE5oT+cYfO0Ys14Z+frSUMtCOrGw8ZooN5qmCVeIN
	HCQwF3y/EgcJVCJbjtlzJhw4JrTM3GmxAYN4O0ouY/7vhjdBJisRtqvfu7xlegFJHisdsyiJJlN
	U9DjvITKAvV8gpJkjQNxmsUABoGe7Q4L+xFqnPPmRdn0EXIQ=
X-Google-Smtp-Source: AGHT+IHzpXzU7IRYTRL9u8s1GDWZ3U5CYmUtBakw/pIBZX/rgdseIwaMMauanPlQhlJ9DDnzYy2q2w==
X-Received: by 2002:a05:6402:52c4:b0:607:28c9:c3c9 with SMTP id 4fb4d7f45d1cf-61c1b453182mr20154119a12.6.1756366676733;
        Thu, 28 Aug 2025 00:37:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cdb00baf9sm715248a12.33.2025.08.28.00.37.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:37:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:37:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <20250828073755.gyq5cyafrxb7lnw2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-12-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:15AM +0200, David Hildenbrand wrote:
>Let's limit the maximum folio size in problematic kernel config where
>the memmap is allocated per memory section (SPARSEMEM without
>SPARSEMEM_VMEMMAP) to a single memory section.
>
>Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>but not SPARSEMEM_VMEMMAP: sh.
>
>Fortunately, the biggest hugetlb size sh supports is 64 MiB
>(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>(SECTION_SIZE_BITS == 26), so their use case is not degraded.
>
>As folios and memory sections are naturally aligned to their order-2 size
>in memory, consequently a single folio can no longer span multiple memory
>sections on these problematic kernel configs.
>
>nth_page() is no longer required when operating within a single compound
>page / folio.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

