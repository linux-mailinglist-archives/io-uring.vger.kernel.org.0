Return-Path: <io-uring+bounces-9222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FF1B306A0
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFFA57B004F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E3437428E;
	Thu, 21 Aug 2025 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rn087/J5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77240372889
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807889; cv=none; b=kHUnjEXSahnEAgr3Jwk9az0m3e57af9ifHUd4VoBuGo7LIK4bnlvrhM0Kh1YKdBXhwVS3+maJlJIvSBvV2brG5hGS/67vdFhALEfbd88FmJEWHRK1AVDc7uydGSkSzZ8BoFc2okrdEvqiLcQqDAxWTXGX1h5y/Naitb1t/t1+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807889; c=relaxed/simple;
	bh=oA3XFTq+X9InxrtY53OI1FqTpqPTKR+1uoMqvtlA0+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABpzs2iQydAl+kT909YdeZ/0zgcCwwlr/K1pfM8yCsBldULqApFD1xC8Hdicq3Jo1gf3ZAxh+ieHn5XaywtwLMwAPm0gYjcLAPs41lu/qGBOc7CnLBS1nF6f2tQu007vczbBH9xKMVUiZMqqZ3R9YAvaDlKFNI3bS3ddraWLNh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rn087/J5; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-519d3c38bc9so445555137.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755807886; x=1756412686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=Rn087/J5j5FyNm4Qob+9GCqTtp8pQbHjYbCRu64LYME9nCB/R8OdClXzzaa7a+/uxY
         ujfPt2eRSJw/WeMN0EQF8as3k6xLpR5eUf3rYsO8DckcIhSxFOL7+S65CbXwcqa1jcr4
         iB1ovtPyDAUUI5rkLx/QO2uZ3EMX/16guNRXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807886; x=1756412686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=jpUXfcB25G4Mx8CYVOSzGoemmGEfx+6Dskwkt0rZENA4/p8u54+eM9ydfeyVpmHrL8
         /VYFfikMf/zcCAmvAHK8S7ebX2mLkfb/Q7WT+q1ulKWvgLJA8dS5yLXX/bk3hAgWA9TJ
         q1rfmYrloCkiQESX9xRSSS7EkrdGwh91ZYrz4z+hSmFmJhmAK7j7xXP7LLsw9Kyy/b+i
         4zx2OdV64HTnTWLgkK77KSae+S18TOt1p7zgXwEhUtAOCDjPMBVgB5UF6qNo00mm4hst
         crr/Q85rIAQRPDwKEsUZSvHKB+lbsfu+7fnV+yuhqyqPSZh8oNNGxIDAuTfW7lAafgfr
         z+kw==
X-Forwarded-Encrypted: i=1; AJvYcCU8by4uTt77OVabF0ympXOOZZnf5WjfU3vomnetwUoIgDclS3/7zuIzRr4m7ieZQ75a2Srcm5Nsxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQN9Rb1vfH4ly1l4X5yHFArLwWdWdk7UDdu0Jhg/u11m3anfVP
	SU2/iRgpsN9Chh9XvlgMcYvCPINad7dociAgePO21CpFcoMApXbAyuhGLRPZKSqFyqQfmCLbp4O
	tTI2xMws=
X-Gm-Gg: ASbGncsP5gGP4MQsiwdkHY/BpYXIhwowsUDN9f6CUAWr8kxGd15PuyqsH+rIN6nRAAs
	TLZVIRYRW7vAIws2zodwQTZMqyrhhhmHaUy89C5KXxJBb+mDZ6FDm6W56+y+Jn8HNFR2gshTxbK
	BISBTWSEvrFnjWSCX4f8IZNljc2HSIPYJofYnzIOBVHQz6gXqFoYFWkdGZxONCU2fMRT0GNArFZ
	qOGhc4/ptlPkpwuZ0em5W/ganjB2Bjwt0jHnfXUBgTnYWLL7HQpISucDn+9mQkmpjSwQXQlkYx0
	Uuke4XNhj4oQ4xgKvpMFKHU6noRY/OcR7nrLxGH/4qsMXyR2Cc1TQkN9E2UNcJPwK7HAcYJnjh+
	qN6R2bUDnOdoefwX8JfuT9w5KG9AV/MWgax7CytMRvGQT2A3bCGcxiahJhbDf5pA9TWZQyNlQMB
	WZMqhiuB9qCsQ=
X-Google-Smtp-Source: AGHT+IFczKZxnnsPLC55UhEoet3v0cE01NpS0kZKF+jyp2syOoqlS+FMmQdZQXBJ8Oj373PcoTXMXw==
X-Received: by 2002:a05:6102:3306:b0:4e7:bf04:413f with SMTP id ada2fe7eead31-51d0edcc4cfmr174578137.18.1755807886073;
        Thu, 21 Aug 2025 13:24:46 -0700 (PDT)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-53b2bed8eb8sm3964310e0c.21.2025.08.21.13.24.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-53b1718837dso603896e0c.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUXYDRWnDtmYILFJGZpsQQPV4yGLVHOmlQNKap9YEFX/zUPbff/5DRCayNiBMLWLtP2eOB6V3P2/w==@vger.kernel.org
X-Received: by 2002:a05:6122:1ad2:b0:53c:896e:2870 with SMTP id
 71dfb90a1353d-53c8a40b923mr212315e0c.12.1755807884664; Thu, 21 Aug 2025
 13:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
In-Reply-To: <20250821200701.1329277-32-david@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:24:23 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
X-Gm-Features: Ac12FXxaZhwn04a0gbwY6rjh9UGLxnRlGOG0Jy0WjRbVAG0UxLDqNy0Wydj0GQk
Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 Aug 2025 at 16:08, David Hildenbrand <david@redhat.com> wrote:
>
> -       page = nth_page(page, offset >> PAGE_SHIFT);
> +       page += offset / PAGE_SIZE;

Please keep the " >> PAGE_SHIFT" form.

Is "offset" unsigned? Yes it is, But I had to look at the source code
to make sure, because it wasn't locally obvious from the patch. And
I'd rather we keep a pattern that is "safe", in that it doesn't
generate strange code if the value might be a 's64' (eg loff_t) on
32-bit architectures.

Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
64-bit signed division by a simple constant is something like ten
strange instructions even if the end result is only 32-bit.

And again - not the case *here*, but just a general "let's keep to one
pattern", and the shift pattern is simply the better choice.

             Linus

