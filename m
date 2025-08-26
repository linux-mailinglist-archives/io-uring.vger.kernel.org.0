Return-Path: <io-uring+bounces-9293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC6EB361AD
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 15:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B51BF1BA5E9C
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 13:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A1428EA72;
	Tue, 26 Aug 2025 13:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3IIkNT6"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6861C29D280
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213699; cv=none; b=mp7aAAQlU9rH/rkEshxMPjbPCuf0RAJq9O7YxGKP8QLFOmKkScnWPNZ++WYBy0z+9IAn9SPQoprVhuaGQGxuQuvWnjj8aPfCZdXCJbi0GAV6p8bmdbrXc+eJfHsxj4O5Tf+jAemuk292hpjh50x4uijst9kqVMFEOmTzQbLohHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213699; c=relaxed/simple;
	bh=96oZjGpBhsGM6T5RqD1Jhcz8DPmt/ETyRKKVXbbqnx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqQx2bi6LV82KWRLVNeClrQqXQ1yjWSP/YEP1fWvX/f52JYiZ+SMbfQjecTVD4qOWAQhCnDKj0QM/iK+oZLx1/j5nyM3YHPA6XSBPwTD2N/O0KNbUkeX6vJgOJZTn3+5ig0UXrL/53sypJoASW5Fp2tevo+ZsdV2YTn+VNEoRdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3IIkNT6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756213696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+33Ue2Cu5Y5oxJByCwLn3TsnRWViKb51w/F+XvIasfg=;
	b=d3IIkNT6zYxE8y0Kz/jJYGpb2HfndRlBfARmXNqzMV72RsSpXNWGSvqZ0goAYhq1ivBCdl
	qd4ht9z0wqNWrLhCDbJ5S2q0mU8GvV4H9XtvvIUOZnUfPGXRuzxFSmDGf8db2uU+MyknPQ
	B0+ddRbBPCKX85Yr3ShHtmEWquF/M+s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-DlYhuzyuPRi0drrXs7l-Ew-1; Tue, 26 Aug 2025 09:08:14 -0400
X-MC-Unique: DlYhuzyuPRi0drrXs7l-Ew-1
X-Mimecast-MFC-AGG-ID: DlYhuzyuPRi0drrXs7l-Ew_1756213693
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso42465165e9.1
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 06:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756213693; x=1756818493;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+33Ue2Cu5Y5oxJByCwLn3TsnRWViKb51w/F+XvIasfg=;
        b=exXCfdEDEiGc9Pml9sioVdNTwEAXVRXOzP/wsPUvL6DGbJefhojctZMLWujWFudSdk
         pAsUyfsNLMJJ2zvA7bl+x2lb0GMwbxvQlzy5g19gv19DqNQE75yoaNhhNkfrfbq1/2Pi
         aT/jl7kpesEY+8bAbHeWrGdztDTRa62FLVWQNrNrAVoo6ukeAvPp0hXoB4iP/F8kGNsc
         +7uBCM0lnA92s5njA/DHw+b7JbDg8I/W6jFBwazw9mEUJzjUD6q4zzd8dPMrNo0cMLmJ
         H6peK6IwE2hu1uxIUcIR6afeJrDIpWG3qI8dbmU9qa96M3/GH9unmSbMm313gsCww1qF
         c6hw==
X-Forwarded-Encrypted: i=1; AJvYcCVcMb1EGxRwZerrS4bhZiKLq+OYZlv43Mcw/Z2qUR2QdZDi7t7CfcBF9fyl6FUgEzfLaYEk2gqBYw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yww1wkSKejSGWSYMSUzFUyy7gCYDsJ/5S0E9HMX3+CSh7gLZyKE
	iaHCMfkXOHk93WjdlBRhl2DRZhwHXeF72bbubci+47PdqyHz3BAHJBvtfBCLV2Dnb0JL3KQkzrh
	1qgz5Ut55bQ3veKHd6GI2DLI9rwUBGgVZAHUk0mKKS4S3imTY328VVHGGrKix
X-Gm-Gg: ASbGncsAGqkhkGwwojMQomyk158tE/VDTQnTol80PrORyQ03GBv9mRFozvSUdFm3mAD
	fh6ztow8lepCRsM50CYf2tjQiuGQIAXUxu4KygO5wallggpHv2oy23LmvtF3NkZvxgz+xdmHK6N
	21Fr/DzeV2vghOWYTcI7hI0A67pKN7QLeVaoXW822VJRW4e12LGQ23Pv6+tyWG1bFwKkC6dojXu
	QNdb77jg28lnbRClcrenIS6D3OTk30MhQyCQj62ZCkRKioasy53BGolPhAVK08mcI1M+INAwfLX
	1EtM1sRJQLJHvCQO8W3h1pqQv++xMYO1Wga8dO8l02Wv3Bb+XoOl5YvIXpSvAQ+LKeFug5d25Q=
	=
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr126239425e9.28.1756213692637;
        Tue, 26 Aug 2025 06:08:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0uVvd3bkBu8Q9HfrtdCgTiP652NIGyMgKGC7lB/H2NXiQPCgnz3LGDq701BEdJbsSh2Pm8g==
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr126238015e9.28.1756213691060;
        Tue, 26 Aug 2025 06:08:11 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57444963sm165603375e9.3.2025.08.26.06.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:08:10 -0700 (PDT)
Message-ID: <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>
Date: Tue, 26 Aug 2025 15:08:08 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page
 ranges
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
 <20250821200701.1329277-22-david@redhat.com> <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com> <aK2wlGYvCaFQXzBm@raptor>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aK2wlGYvCaFQXzBm@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.08.25 15:03, Alexandru Elisei wrote:
> Hi David,
> 
> On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
> ..
>>> Just so I can better understand the problem being fixed, I guess you can have
>>> two consecutive pfns with non-consecutive associated struct page if you have two
>>> adjacent memory sections spanning the same physical memory region, is that
>>> correct?
>>
>> Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
>> guaranteed that
>>
>> 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
>>
>> when we cross memory section boundaries.
>>
>> It can be the case for early boot memory if we allocated consecutive areas
>> from memblock when allocating the memmap (struct pages) per memory section,
>> but it's not guaranteed.
> 
> Thank you for the explanation, but I'm a bit confused by the last paragraph. I
> think what you're saying is that we can also have the reverse problem, where
> consecutive struct page * represent non-consecutive pfns, because memmap
> allocations happened to return consecutive virtual addresses, is that right?

Exactly, that's something we have to deal with elsewhere [1]. For this 
code, it's not a problem because we always allocate a contiguous PFN range.

> 
> If that's correct, I don't think that's the case for CMA, which deals out
> contiguous physical memory. Or were you just trying to explain the other side of
> the problem, and I'm just overthinking it?

The latter :)

[1] https://lkml.kernel.org/r/20250814064714.56485-2-lizhe.67@bytedance.com

-- 
Cheers

David / dhildenb


