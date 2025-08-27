Return-Path: <io-uring+bounces-9300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D3FB37F0D
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 11:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64849460EC7
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 09:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2DF345747;
	Wed, 27 Aug 2025 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eq493+Om"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC913451D1;
	Wed, 27 Aug 2025 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287762; cv=none; b=nEwjm6CQGT+ALnULD2o6mBDuHpY9yOei6EKhRNECi7QqIpvr0v30qMHJNeJZoil1gow1eMFJ8+dE9zqNm5X/XIBwzCt7p57RY0DJX+j4+BODGt2bkL3a+BEYJo8mIR+M79Tq6+hm3fhjaqVMX866fCEXI0beXWqHtBf6RGi0JKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287762; c=relaxed/simple;
	bh=A0KNxlVGHuvT2hmaoiFbUd67u8sxODxt85QG+mrnbSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j79R7A3GCROk2ruAAuKDSgSrH794YN9YWD2icaxlv/z6gnGiNISfH9hEcl56DsFtszrir5+CdE+J0hNWdTKNLW9DrizVbSY95a7+4Yo3x7feeZlt8Htq+OsgkU5tfKAI01lwHpLbiOwe5iZmvKetqMUmmIMXVLQMIyLDX2feDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eq493+Om; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3c84925055aso2676474f8f.2;
        Wed, 27 Aug 2025 02:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756287759; x=1756892559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s4gNirUawo/2N73RGh/VZFmiZovBEw6Zvsz5pkyBSog=;
        b=eq493+OmhqNBlrHmEpRZnEz1udJxBnU8wy/od2pb0QmbYFaKRSHxFcsAqHxsJ2TEzG
         QBqejTxuUzbOVndo32LSzbSSp0rCDlR1WdSjwC3FA3DDY4NQeEbvmkxL+op4Ry1Dw9zQ
         OORjwVyiKB660OR+sRd3CJ+vaL+LinNcNuq0rl15XuqSNQnmRP4qzaVekokcOd2D+dy3
         dUFa5PMQezCzhuB179mlCs/5zfgfrc1lKHcDCjIiR915l+JZftBJvMbPLaFLMIvO03tx
         TYzdoy6btAPmODdrW7nnnPzJthrK5xVn9J6LJC22uVNGCCzA1VZDXL/GZqGef9v9szJ3
         Li7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287759; x=1756892559;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s4gNirUawo/2N73RGh/VZFmiZovBEw6Zvsz5pkyBSog=;
        b=XJtmg7UHoVD30CoT+FKblYoZtABzlu4N3DZ6dhhPiXEfpoV9kU+NAB9KR09ra3D8dk
         NoYjfcZlSyXnyhkrkSNqUTXFdeh490Syntu19fnH93P7KzOt3T59CcNzH1ks4e+/lboE
         trtBxQ2orJLgABNv4jpYJ8XmGp8faHXf1VU9YiAtURgcCqwW5EIWaBoIdEdT3zYXf6j6
         NPArsqk+0psPvBmEhyWitc9Md87LJVbBRar+9rp72JlvQPq1XC4tztmcat2hTuy3iJO4
         huGbKp4QFhw6E5eaEVJOzL7f8F9juzjhkAWq7IWbYwi3KBNLcNeHwA5OYhRc8sE3T7On
         Kw2A==
X-Forwarded-Encrypted: i=1; AJvYcCUSCD9fILJ+28uBSDuNZsU5f7Pv/8U1R315+LkMl037ggSCsORSMSvIIsT8BI1aAx5UD7jzqk9fKgAt@vger.kernel.org, AJvYcCUevdMQ2U6BknqNgrRAup+8086qnra1hkhgnS8kGZwYBR8aHMwvZ2s+9Z+/7FR0Rg7zY+RZ0Iz3@vger.kernel.org, AJvYcCUwjwj2psJ3u1NTKFkvIuSk7XPiUFns5EOn/VS/D1k4GTM648TpyZF0gG4qowylcaP4+o+OyxsHSxh7b3lx@vger.kernel.org, AJvYcCVSuYnGxLEuak2LpXneBP47Ev8FwkhXNK4DhZPDbzn9+gI4U22dlBn6NSOMVxI0Y0agjI18swxby6NK+g==@vger.kernel.org, AJvYcCWHItbwDNtWiQSBUrmigpBGdHJmeHDQ0zMuMT4ythMTaaoWqMrV65v2O0zj9OS5r9kvc4rH2aHBRp92CGS8@vger.kernel.org, AJvYcCWPkyZ4ts8gDVwGjo+LVW3NWm3mKfxk/0RP7WQiR5U9Purif6HzR4nw+5MJutgu3rxI72A1baGBwviE9A==@vger.kernel.org, AJvYcCWVxViLACC6YPP+7vcfD03FZmgBbpqoP5faJU93MPVgOC+qnfp3h8nuDLn2YMvpZkIWCMbD1osNAw==@vger.kernel.org, AJvYcCWtpBu505T4zFzQadPKj4FGpkvdL3mU7z3XzmGucBfhTRR7DuFuaQJG23q8n0xbTQMdKcBcGG8miYUS@vger.kernel.org, AJvYcCX2R2aDmNtVcBcxZWgIWrEiBWjFndVBvXbAzZSXgbZn4VJ5T93jH7HlViJj6gWByHrxRqlVPP704Yim/fS+gFQW@vger.kernel.org, AJvYcCXFCJRx/mLbMBsp6wVmhJjhZVhz
 FvPeRvdqDo3M3lMOAEMTk7+m55WqSEA8xQzvuXszF1rD@vger.kernel.org, AJvYcCXej6CLaLomb7S9q6UVEExPEuszQhiKxOb0t4ZOUjJGyQq/Oeh/JFpg2PJ5msw8r2CU0aBLZ6vyc3bPZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3uH3XZwv1aBKWmz5rKen1jHgk3kkc+6ikF+oKvmYvv/hHoraV
	YZto5Bc54QVEQI5XbHTi6VZ5QWjg0Eyxi1xBd7F8GPRBxGs39WuwJnyaqLgB95lE
X-Gm-Gg: ASbGncux/p/IiTYT3fmUWgdFSu7VtvaeWMCBAcjB6Kdi5nqKmW7qlNYoWmYaihgfJRa
	KrH7dgFPBmGdi0WMemHtFgyXlPvXydVsnmhjduvmD0zkRxm6ZU3Y2Ah53Hnt7ZEQgU270wSGFMd
	mdoeOsI4ZRL3ttNGA0d+PLGkO0amO22cOqwv8Rmg1XdfWpi7cUGvfNd6OJFyAOqmTKvU1fnLd4E
	Th9WaZbUAhhlQpJRm3w9UK/Ueps4M8gEo/m+fan+l3NYcIlMcsEtPsX5q7iIfoaSiMuXVC5C93R
	m+7/zdVKbc8avq5UFxnSZmJW7a13AVpMoUrHcpBk/KD6Mv6sehhvrsTVie4QKVQ9c+I3RdVrnro
	KYBnYQaeDHgtAVLM4ooYW0ZattqFcH+27TLMH8dXnqE/temY5qZKyGbEbJwEdf0Elmg==
X-Google-Smtp-Source: AGHT+IFkjO5GHbU1+2MUuKQvNL0fwH2etmLb7S57NgBpdq01aCYpWSgROxwdQQpXxfO8aoPZevSNpQ==
X-Received: by 2002:a05:6000:3105:b0:3b8:d672:3cf8 with SMTP id ffacd0b85a97d-3c5dcb10b6amr14770182f8f.43.1756287759105;
        Wed, 27 Aug 2025 02:42:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4a1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc4b102889sm3363615f8f.51.2025.08.27.02.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:42:38 -0700 (PDT)
Message-ID: <46d09557-1873-4d97-b073-ce0c7296b954@gmail.com>
Date: Wed, 27 Aug 2025 10:43:59 +0100
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
 <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
 <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/22/25 14:59, David Hildenbrand wrote:
> On 22.08.25 13:32, Pavel Begunkov wrote:
>> On 8/21/25 21:06, David Hildenbrand wrote:
>>> We always provide a single dst page, it's unclear why the io_copy_cache
>>> complexity is required.
>>
>> Because it'll need to be pulled outside the loop to reuse the page for
>> multiple copies, i.e. packing multiple fragments of the same skb into
>> it. Not finished, and currently it's wasting memory.
> 
> Okay, so what you're saying is that there will be follow-up work that will actually make this structure useful.

Exactly

>> Why not do as below? Pages there never cross boundaries of their folios. > Do you want it to be taken into the io_uring tree?
> 
> This should better all go through the MM tree where we actually guarantee contiguous pages within a folio. (see the cover letter)

Makes sense. No objection, hopefully it won't cause too many conflicts.

>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index e5ff49f3425e..18c12f4b56b6 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
>>            if (folio_test_partial_kmap(page_folio(dst_page)) ||
>>                folio_test_partial_kmap(page_folio(src_page))) {
>> -            dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
>> +            dst_page += dst_offset / PAGE_SIZE;
>>                dst_offset = offset_in_page(dst_offset);
>> -            src_page = nth_page(src_page, src_offset / PAGE_SIZE);
>> +            src_page += src_offset / PAGE_SIZE;
> 
> Yeah, I can do that in the next version given that you have plans on extending that code soon.

If we go with this version:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


