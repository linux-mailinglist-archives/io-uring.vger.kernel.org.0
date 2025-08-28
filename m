Return-Path: <io-uring+bounces-9383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12897B396BA
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 10:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D67361738
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 08:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384FE2EAD14;
	Thu, 28 Aug 2025 08:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIYY7CMM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF72E174C;
	Thu, 28 Aug 2025 08:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756369116; cv=none; b=ikaSymyU8ITa1sua1hs60RhAZoP5WxuqIdxnxWt4POC3qm49UrvmZNPI5rD6GEVAfyPC7JcX3ga1tXCS1XPvu20XrqDpgRfGiyzw7bQmduWkNHatp1tT3K4WZGiFPQKtH7+lu47QodOu0ab6yCtI1FXpZMirckwJmu1Wjl+o7Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756369116; c=relaxed/simple;
	bh=+dYxoMUqGPEc9iqIX9bUKHerO98X4htKPSSAx2YoAuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h20WEMLR6x+jL9BGlg6k4v9lr0sOS0Tih8s3RJExcxqpusJ3g2sgZF76JsfR0fVf+hjNqc4+YGAJ/bUvjzczv2YXDBcaY48kMk6q0bHQwuoahNSh0kj2ed+ZHyQFffRTHqQK8GgdL643WTjA9dQuVmRAPcYTPpxsk9ojpB3XIlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KIYY7CMM; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6188b6f501cso820513a12.2;
        Thu, 28 Aug 2025 01:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756369112; x=1756973912; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFlTc2o50xP7q9jUUn86Cat3HkUhlqoaXfvof6seHm8=;
        b=KIYY7CMMme7oMnlSm3BBdXvQFNdpO6zJDkMFT/20QCH1qtSUnxpBkHCBNaZ+q9T/El
         Zwgez+EBqxDZz5AMxeSOPrYRQd6pS3yKqLyExDIWJM4idGi7PKmNR0pRkOG4BRwJ6gcY
         M1CHB5BxhfALhjx/zK6O3atAlWeY26vOs67qf/bMI1njVV/jW1OBaTqV+lQa7yjSMBdA
         eRIbYQApsZKe8JfC1j87RWfiW7Sn5cxcLb2hRB8oZJ6MPHButtCI8TmhOR4iMPYf1S9z
         gICSLzdzyatlCcS9OfwhHIAZcckY6mPuGQw0FgFKlGAfD+YJrEuOBnwQ24wvuIRj9+dA
         6nIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756369112; x=1756973912;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CFlTc2o50xP7q9jUUn86Cat3HkUhlqoaXfvof6seHm8=;
        b=UkKSc8+ULWIYKUU4irGCH1dlbqbsNtXq4UmnoKVVRIBSj/6HOOl8PcQEw133bQ3Wwn
         eXaeUIpo6/7dDZ0cj6FpptT3XIHmFX8nFrlLBeCl1INMKFLZC6nuerEx5MQ+cfDSiOo3
         I+F0V1Z1y/yMrLq0fmlOSvUg7+970lavvOsd25ZGUHcQOwsBn6sI9joyzk2vb58RGV+d
         HYzoo+CeSYSa3sw8srcn7OpBel+/tuCx+RdID6bar72Ib5+eOc7OQJYjn7vSGdX9qPKS
         Gg97dAcrJeyf8zRkS31W2ayBMLJRWAd8B9ELx6rBFDr5w0VTc2cK+AoltnY90OmvNwY7
         7JhA==
X-Forwarded-Encrypted: i=1; AJvYcCU2vJ2lWZQKEv5SzGt/MR1HnK72lNT8X1At5pUa3PGgg+jVSm84BlsiolXFYvmWJE9RhwjmvoI4a6GCx/NX@vger.kernel.org, AJvYcCUM/wv+pAz/fW9M6o0fUPYBQVZ3laJnIyzqgTJeUnTpRFu3lJBb2d2jQwGD8ui4VuJPQUvEy8OBQf5ODT+iJodi@vger.kernel.org, AJvYcCUqXVO+cIb5QosqZhlKfwi7sO1GmBPBQoFF51US0EdOTwJ54zK9M49MDnPc/iBSJdp9+cbyZG7qTThZxw==@vger.kernel.org, AJvYcCV7HgBT18YEkWNYZWAoPSRsJWzA/A6aXoTnDD6W/mtHBRhQw6F3aQDFWKpHIYRzhxv1fqWs29OZQnYn@vger.kernel.org, AJvYcCVe1QNI73NpRKqyMVkoEngVnzLdjWw8BrewGgdmZBR6hLhuFTqXvDgMqN8za+UDkEQ9rIh1JhHuQC97@vger.kernel.org, AJvYcCVeAgn2OMtnwWDkVtK9wkPUCrUXJiwrZTBCX4RLY/mwZf/OKeD+8QnS8SyDypR6ivROelYGcUzgsbzgsw==@vger.kernel.org, AJvYcCW4wJ7qAN95wW+KfmDjLVuIFXp1jSdv/WEbCCfSlQ9ji94CCAkQfSE0gjJ67LVyIYqtwBX8fV2HCg==@vger.kernel.org, AJvYcCW8CMuS2nhkGpx42Up9/6qEsCnXbwmAloYHcSNWs6zXEbEbJGnOS+08rqkJ264SlMq0cHsZ@vger.kernel.org, AJvYcCWKQD9f5zUuOd+HnUyWAxtCue3xTBFctl7roEjgk9sYzR96Fmyl9ku32m8aJuSgYc2skzgPeFmA@vger.kernel.org, AJvYcCWf4K0oLmmbWLD+3Lz7CluYh2re3/G+tw0CMmp2
 9FrxvfUncZ8Bk3SB81CzfSldqTPt8wz43NTWCCDkPhLt@vger.kernel.org, AJvYcCXQdMILrG0wc1zvDEeDprHtZAlSOHUvqUAvZ7DXxH7j4I6RTVW48jyx7xZh8qx/Es2punsoDhpu5tPq+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbG7pmGHpmc0ZMyDOw+1vVt2tSTkj87ms7q7kX+SqHgOmtt8qO
	ejMzXovAIDJtDF/qfmGRPrOAQA4bzbD3+cIhbI0V6wCjD48rIm8POw4n
X-Gm-Gg: ASbGncv6fTardVXmv4ct6Bjy+cMfbYSGiUJGS65tgW8pPTtW94/LmWp/NrxOnbKjL2d
	1Xg9ezbiPIVY4iha1swLmL3YTEE6RnQGfplC8TrtIK/kOjwuqtJwoibAX5tLzNPNAXmNmkC0uhe
	9PJ9smVnwtBfAFjiD9r0+C1Pqvt21klqYpNKns5hhRkyWepktMx2nLcJ1PD40YZt6OG7+mrC3Mn
	wsfttMGOPOMTCOGmERM+1wz+d8k8vH5pyPf5WCRmPbgV/WTRwJuuDaLtLo2kS+/4JpG01IVySG+
	Aj+U/1zrVio87BrH1zsPm7fqSZpVC1wGAl7WzeVh6r2n/UBk7GpnLFeCZ9R3l6DUmW283itG5g3
	U5wBRV2Qx5korEAej4tO2PZdrk/v8y8Zz3Rev
X-Google-Smtp-Source: AGHT+IFrqyfe7g2Zl+sLgEHASy1+ip6WVy4aEpiIRxktJ8PetprRYIIgoW+xQR/WhySTtvxcEvhJTw==
X-Received: by 2002:a17:907:1c27:b0:afe:b878:a164 with SMTP id a640c23a62f3a-afeb878abecmr620398166b.50.1756369112172;
        Thu, 28 Aug 2025 01:18:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe80daceb5sm811531866b.68.2025.08.28.01.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 01:18:31 -0700 (PDT)
Date: Thu, 28 Aug 2025 08:18:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>, Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <20250828081831.fv4bs77kihwbffdi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
 <20250828074356.3xiuqugokg36yuxw@master>
 <0e1c0fe1-4dd1-46dc-8ce8-a6bf6e4c3e80@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1c0fe1-4dd1-46dc-8ce8-a6bf6e4c3e80@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 09:46:25AM +0200, David Hildenbrand wrote:
>> 
>> Curious about why it is in page-flags.h. It seems not related to page-flags.
>
>Likely because we have the page_folio() in there as well.
>

Hmm... sorry for this silly question.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

