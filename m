Return-Path: <io-uring+bounces-9374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DFDB3952D
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 202BE3B6629
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065462798E1;
	Thu, 28 Aug 2025 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IojEBrIY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C025634;
	Thu, 28 Aug 2025 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756366314; cv=none; b=qWC2Vwoig8aYS76njKQO8470ytesOUdkGNtnL1pHSJVI1Q92x/qpIW8FJ1TY0Ci2lhJWxRMQVWxjlsSFDAxswBRZQkX+KBI1X/FmtapgVuEFdt9m8FQHILztQHIQFd+gkweJG/7cTSLqB1BBpgSLREI18qIUmUWVGIn/olVA6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756366314; c=relaxed/simple;
	bh=TpwyzypEujQZAeEzgHHlRrVk+R8i3A3xvfnvM9KGUhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDUlxMJ/d8KYNdc8PS876M1qMcHSRnis70mi47IzlpAmQkqPmYBASzapRiOXI5kTrx5dIbyqKdpHHERiyPhUp7dNVlnNvkq6FCnEzij36HRnCZOIo6YaSa86mWbMx6mTgkOFlI6bu8U/4KYj+KbV8Go2qPPcmg1vjFnzNgPO+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IojEBrIY; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c8fe6bd038so285007f8f.1;
        Thu, 28 Aug 2025 00:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366311; x=1756971111; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuV0vIwmYzbGp0NvCAEdvEWsqc4i4ounAUIZgXtsn78=;
        b=IojEBrIY02OFMAEdD5l+cqfpLbuHMSMObCvLSgZ/V1mbItoAXTh9551Wu4SyO7QXkY
         2Nr+ip1MvzrpXHDnQo8ajDHGFsFJB+toxNaLP6BQKpnx3d33nkRuZMOMRHiZAt401dF2
         rYsWc49/U/dVQteBheVb0o4feobzxdSO4WusUO7z4MjpLB6h0V2r7XuEW6d7Yb+vi+Zj
         bk1UzU0UTPK/PFQr3+s/CHBROUr6P71g4cmE7jpDicVjLr/wA9boRd5D+q7Pb1Jg9sf+
         0cefcN4B6H0oUpaLO+f8dqy6tjGXPSuo6aFIJpuX/JAy5QiAucXYGU7OXR8HRYK/KECI
         2Djg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366311; x=1756971111;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EuV0vIwmYzbGp0NvCAEdvEWsqc4i4ounAUIZgXtsn78=;
        b=bmm/W+gJ9uxO60EVpPqFuttZFyuV2L0ZRIKfVV+hVoIMR4fPSKQYUSktuS77SmeY3U
         Duf7N/xcboGFyzspamgOAUDmIuZDvVLG6OuVFXBnbW6jSM4vlgoyUIE7/4Q+Or+pQUU9
         hH3vXRLzEO75BoDzEGkyyiyC/IrzEui6jZP7NneDGelua+W0TLMfvsLPHLJ42UpLHYQp
         udy/3z6fsaARGiJ5z8/EzdTsptjphzg/NQ9O77u4EiCgZLhlHaxNzqGyCfYJbL/njZwX
         b06+zescZgMPZVSuDQSTo0vq053CBT/xcwO7c6mwogjgKisEmGBEh7E+UO/kF95+bQPt
         wdVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJWZax6PY9+wL8MwidAATTyjN+rBsy4H1eYrqWcvBxls6crMNu61eT260ohV9YpqWCK7RcRkHbXoU9Mg==@vger.kernel.org, AJvYcCVXladc80+VeA3Umt4krY0kN/BYGymfbwJuhcPGzE5X+sU5YGuA4wcDB5U6L1TOrZn9F/FUaC938xHWLw==@vger.kernel.org, AJvYcCW9hSxxp2Hy1mEca5O6PI7XybXZP/A6slh02+kzkZoFpnHBzG9e329J9k+brfIBvPdzoP5/KzLjSg==@vger.kernel.org, AJvYcCWGyx3dZzEWUJXzxGbUXyhTGc/3RwTIRlPaM2jZaJ5wg+XO4sIyGYomhUnMwvnXqnR8mdY0+dioI9jS@vger.kernel.org, AJvYcCWI3a4W0oBj6R3K6WJbPN6gAZf78pxywJaQWnUuRCzbTFDbt1wFRdW/+0EKHiBgKQt5Xdgkl4tYsmJWpjet@vger.kernel.org, AJvYcCWX+MgQipGMBNLsY+omSs0BWUrQ2we0z87R1UX3mmTydTAU5Mo7pKBwp2H7zABwKq/PhZXaOIV9@vger.kernel.org, AJvYcCWZ49csSkToLG0pACa7fsGcBMoZAbjOLCyT5ZTKlDbkLumJJ5xjQ4RN58D2iMQVTGnOYIHq35kh7lNU@vger.kernel.org, AJvYcCWao2HbfGF60qbVTCsN5chWuueF6uj9bBTIsrfTgwFJhUOUg1dZugQujbhOgZXAQIEuovN+3qXtkACZ9s5h4Zz2@vger.kernel.org, AJvYcCWvYvE1TM5VDOg/DODi1+LtuQYyy/CUeoqiClTOlbhovmx1vQZlS84C6SJF9M7PQROVvWXF@vger.kernel.org, AJvYcCXlJBm9LiSAtuzE36j4TRAwXGUdWj63xxUWvEFQ
 6oSHYaMTYf6vFmVLfBR85Q9bmDL3yFYwhZ7XTLcpXw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg6PJ3+DmyeKPNZdPeIKUNdCQtPZSyCIc7a3/RWwszQ9EC7kXs
	3uUXTm8FM2jv7nBZ2Duzr51F36Cs8fVIjildXJ9C54X3TfNtdXngKogD
X-Gm-Gg: ASbGnctNtER5g1VktjqrpE/4/C2dw1j3VNSIor4GJY2pI6qC3O/Y+m53Gn9ge1u0x8q
	sr/B+QgYpsIY+zxCvk1zD8GdnxRsGLm3eHNOrVIGTN31///9YvPT0MMuEhnLHtc+aFzskHmNXM+
	7Qp05BYDHsmMCJKtahkE8bgK+T3vGKqUCNY4BH3IKtA91dWBFngDLuef01gIM4YoOWViyNxtCRc
	MrqjU4TGpc+pElJQFBLcDoH5f7q5LTTUJW3TTi+supZnxAmrMk3BPF9LPFfJdr6jtpAIICQEseU
	OUlM45bu2voBRfUE1/OH6LhCeSyy3KA0CMylA5q8QTZ510AGC9STWFbEry6XGSSemigmw/4gSKN
	US/Lp40FSoAUzXsi7uRph7PS2DiOzSlZzBl3e
X-Google-Smtp-Source: AGHT+IGYsCTFAB2u+mO+a+/7YQm7WCRYBnf/bqNrDbgJHuGpC+AeSLNYygCiHCIag3yJJPklKDadWQ==
X-Received: by 2002:a05:6000:2891:b0:3cd:96bb:b948 with SMTP id ffacd0b85a97d-3cd96bbc28fmr1837267f8f.47.1756366311260;
        Thu, 28 Aug 2025 00:31:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c9c9324dc9sm14883755f8f.3.2025.08.28.00.31.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:31:50 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:31:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
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
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Message-ID: <20250828073150.jyafkufvkjfqwp3f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-7-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
>Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>them properly.
>
>To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>and calculate MAX_FOLIO_NR_PAGES based on that.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: SeongJae Park <sj@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

