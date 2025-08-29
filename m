Return-Path: <io-uring+bounces-9466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E2CB3BE08
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC8C24601E5
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EE42E7F08;
	Fri, 29 Aug 2025 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efSQPemr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A181EBA1E
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478256; cv=none; b=RbLosnUnOwRUMlMYgG8k0UJ+4sHe3gzcC8n1jrx6v3BKmw9tApjSm7RLWW28m4ZJcLDsKnzpwWzO/NTPTwf+8ae+IFtYII8W3F4IgiQY3p4aXL/ftM9SXl4UhlR2lydm5tqiUceK7uGm2skbhlRlbDW7klwyK/Q/Ct0eh8D7N/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478256; c=relaxed/simple;
	bh=ofm4InBTF9w6dgdMn/0Y8taX24CqTrMf+lLgsHms8II=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LpdTIWilUWbjWPyGoTtweBzYFjrt8evJu9t/1smqjiZtoEExc76MgevKI5OEZzy/IWlY5lpST4NGSLG8wqIssB+3J8ZHPVs3GF7W+S+R/5cy3mWYhmvGzf0YBWrLUxv8q/CnvKtH7v4xxmJDfM3R+ZzgGmmLr8fH6uKzq20lUD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efSQPemr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FneLljPHDM9XgGJyT12mwKiq6vPBg0z8/AklpfNT7Sc=;
	b=efSQPemrp/EfZsndqVcPvEjCqu8w0hRfa6pwnWs+KmWye8oDIlg1vgksqlv1hcx6ushcFR
	8wQinQ0937WyV+JmIW0uqR5oK7NZVg2wBaGtw5ryzqvE5BCdo6gP5+YHIjVxsCJI2gRLoJ
	/sCD4nd9T27uCze00pYeV4gq9JU8nGM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-wWJPCS5jPv6gEO6z9t6ALw-1; Fri, 29 Aug 2025 10:37:31 -0400
X-MC-Unique: wWJPCS5jPv6gEO6z9t6ALw-1
X-Mimecast-MFC-AGG-ID: wWJPCS5jPv6gEO6z9t6ALw_1756478250
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3d1114879a4so302484f8f.0
        for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 07:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478250; x=1757083050;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FneLljPHDM9XgGJyT12mwKiq6vPBg0z8/AklpfNT7Sc=;
        b=n0bEaKR3t1nuxaEOtxMrAtRh3zGUKzUhKOG41jqauknO+EIslp5kF4hcz6fe83qhku
         P7Kh8tAt0cSXfy4xQaH+zTC5Wo8SGi0Uv+9uyoefpmUhledIGyMtfJt9vPdFIENNNd8F
         Px/fmwX+fiwK/yicnQ4jSriuTcNicW8rVuQnSKpXmwJqYzyr2ZG4O0Q+UBt3ToSSMmza
         Dd00WYqimANtMl1rMMoihPP6TGvusqD1aqvrux+H3HCxRRIWtFmOdxjgN9q6MkAyVnRs
         TKZB6B42daDveK8+i2Ajl9w8o7YYOKpgvjtY/7vUgHQ6zd3x/YMeSGWa7RmA+4h9xUMi
         DtZA==
X-Forwarded-Encrypted: i=1; AJvYcCUTHPxiaYRpCeOapPC6whQ8Uq3s7tgxxyrpeXbHWUKbJUCy4LervMfB9ZFa7Vpw2kNqNsa7egwVdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhmPS+FeinXU2B9GTWPI4uvJp9xdQYwtkj3LudGl3pwI8Fy/F8
	JbAW6jXqzTSae5aFYt9JvirIbXitCHay1Oc447Nx1oo+xiAa2suIfSfW6qJX+6NoAnMvf12kISz
	5HETQOb8rjaqZkjTaQXzudG5oR8dqa+kXgcl2lWkQ/jzH0VMaqiSdz06LiiXS
X-Gm-Gg: ASbGncs1FyJBwFSMBd4zzGdUJnr1FO2Yx+RqJXub2N2sqA7e2fpoMZLdqWcnk4Uh4s8
	82TtAvc/cHxuRlYpA274Q89lj31tNlZbx1aviEFNht4KgH9oND6JE2ISJyOpYo+MH8NO8yOPoSi
	FExw6w5Qg/yOMGCQL40QPvcRLwc1ZPZ0tuRBUnGcs3VPbDmrjDEbcsdItEV9EPaPv+lQj8NtbuY
	R0e71bZbJExcksEfD7Ykj7ztlYCCLz5SyChvFWU0jENFd/8FDAL4AFRfYmSXNuz3lVW/XQWbAYv
	Nx+LLeslX368cNNayfTnFeww9H78euf6fKPkBx4pF9K1XFZur1BfE91n910RRobid+wcrMlsga0
	D+BouS+M3taWw4eFj9/Plwccdk8XCZfa4+lbdmuFGuvTa47xQo8WBlBGeWwva4FR1
X-Received: by 2002:a05:6000:4181:b0:3c6:cb4:e07a with SMTP id ffacd0b85a97d-3c60cb4e5f4mr14776363f8f.30.1756478249720;
        Fri, 29 Aug 2025 07:37:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHovUImNhvkO1lXs5k4xADHmBMPjxYhr00MTNQwak1+GGWTtZ4Tk7PPjO6gfl53i+oo7PyhA==
X-Received: by 2002:a05:6000:4181:b0:3c6:cb4:e07a with SMTP id ffacd0b85a97d-3c60cb4e5f4mr14776347f8f.30.1756478249246;
        Fri, 29 Aug 2025 07:37:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276cc915sm3557153f8f.21.2025.08.29.07.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:37:28 -0700 (PDT)
Message-ID: <07b11bc1-ea31-4d9d-b0be-0dd94a7b1c9c@redhat.com>
Date: Fri, 29 Aug 2025 16:37:26 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG
 entry
To: Damien Le Moal <dlemoal@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-25-david@redhat.com>
 <7612fdc2-97ff-4b89-a532-90c5de56acdc@lucifer.local>
 <423566a0-5967-488d-a62a-4f825ae6f227@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <423566a0-5967-488d-a62a-4f825ae6f227@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.08.25 02:22, Damien Le Moal wrote:
> On 8/29/25 2:53 AM, Lorenzo Stoakes wrote:
>> On Thu, Aug 28, 2025 at 12:01:28AM +0200, David Hildenbrand wrote:
>>> It's no longer required to use nth_page() when iterating pages within a
>>> single SG entry, so let's drop the nth_page() usage.
>>>
>>> Cc: Damien Le Moal <dlemoal@kernel.org>
>>> Cc: Niklas Cassel <cassel@kernel.org>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> LGTM, so:
>>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Just noticed this:
> 
> s/libata-eh/libata-sff
> 
> in the commit title please.
> 

Sure, I think some quick git-log search mislead me.

Thanks!

-- 
Cheers

David / dhildenb


