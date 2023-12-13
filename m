Return-Path: <io-uring+bounces-282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B59A811110
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 13:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75B17B20BDE
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 12:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B8128E1E;
	Wed, 13 Dec 2023 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZSRSRM0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815910E
	for <io-uring@vger.kernel.org>; Wed, 13 Dec 2023 04:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702470190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z+hST6RitM5nrhpGYy2e5Bj07bhUpOm/Wq2GufO4ACo=;
	b=HZSRSRM0rqOajkzl5pTv4YjzgVDO6W+MmynPvM05FXMp5opfobu76UvbVyzESYztlLh940
	kf1lbNoiFYei6y6uNBm2KwwdN1sj3dAafDULHMtwyzgrijUJMQ62m5lmWg16Z+UPr+ow9x
	v//VBcgDHUb8PGjZKHbNqfYhK9qzh1w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-j1epgEsYMC2hqyAXpUwCSQ-1; Wed, 13 Dec 2023 07:23:08 -0500
X-MC-Unique: j1epgEsYMC2hqyAXpUwCSQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40c38ae9764so33433355e9.1
        for <io-uring@vger.kernel.org>; Wed, 13 Dec 2023 04:23:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470187; x=1703074987;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+hST6RitM5nrhpGYy2e5Bj07bhUpOm/Wq2GufO4ACo=;
        b=BjF7DgwhDJfXGgI8EsqfjvKeYSLGfByEaOz6Tvt8ws0pgDEqHrXxXT1Jcply/x89dy
         MpkqZhP4ui86QNgY1xwKy8ss4UPwwLHNB6nI0OcVICynone2AzTf6DHkXRUt3yzjZjYE
         7T7HAgERNc2Wc/A6GMwQw+rhs5lIHbazqzzsD+i8HA0457kk/Vc8gwoQ9lRzKyQpkXb2
         YEnS8HUncwBCkuwqYIiwEv1LGti0gpiKLp+nWdltX+3nyULLXBNaJBaneRuLDUd8T6Sm
         KAYsgAwAXidxTlMm72PE2ZL9xT5N65MIUQrwrmJ9s3+exUEgTYTD5ssCxc0muZw2Rm5X
         9WRA==
X-Gm-Message-State: AOJu0YzgQAok61OhbI/86anq1sh47x2GIft5a2pwBDw5S8C+yXs5Y28M
	d0Dx/t1n0mSjIk2kdKLZX6jJG9uMkeEEPbUL6dcdY1TTT84dY8cSK/RfLWQ9FxytsgqdQR3c7LW
	lKvukkSZ5+dcpij4inis=
X-Received: by 2002:a05:600c:20d:b0:40c:3915:be5a with SMTP id 13-20020a05600c020d00b0040c3915be5amr4436156wmi.118.1702470187504;
        Wed, 13 Dec 2023 04:23:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5EOIT2DF0vT51dDPq2wM5llOjnwQAWikspq/TPGRtg450wX7z3HWsvoH5ubptvRsqPwioHA==
X-Received: by 2002:a05:600c:20d:b0:40c:3915:be5a with SMTP id 13-20020a05600c020d00b0040c3915be5amr4436149wmi.118.1702470187050;
        Wed, 13 Dec 2023 04:23:07 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:6e00:7e5:5f4d:f300:5d52? (p200300cbc7096e0007e55f4df3005d52.dip0.t-ipconnect.de. [2003:cb:c709:6e00:7e5:5f4d:f300:5d52])
        by smtp.gmail.com with ESMTPSA id r20-20020a05600c35d400b0040b538047b4sm22658359wmq.3.2023.12.13.04.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 04:23:06 -0800 (PST)
Message-ID: <35e313e9-b299-4e39-b94f-fd1fe4ea6bed@redhat.com>
Date: Wed, 13 Dec 2023 13:23:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Mike Kravetz <mike.kravetz@oracle.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-mm@kvack.org
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
 <8fa1c95c-4749-33dd-42ba-243e492ab109@suse.cz>
 <ZXNhGsX32y19a2Xv@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZXNhGsX32y19a2Xv@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.12.23 19:31, Matthew Wilcox wrote:
> On Fri, Dec 08, 2023 at 06:54:19PM +0100, Vlastimil Babka wrote:
>> On 8/16/23 17:11, Matthew Wilcox (Oracle) wrote:
>>> We can use a bit in page[1].flags to indicate that this folio belongs
>>> to hugetlb instead of using a value in page[1].dtors.  That lets
>>> folio_test_hugetlb() become an inline function like it should be.
>>> We can also get rid of NULL_COMPOUND_DTOR.
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>
>> I think this (as commit 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")) is
>> causing the bug reported by Luis here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=218227
> 
> Luis, please stop using bugzilla.  If you'd sent email like a normal
> kernel developer, I'd've seen this bug earlier.
> 
>>> page:000000009006bf10 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x3f8a0 pfn:0x1035c0
>>> flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
>>> page_type: 0xffffff7f(buddy)
>>> raw: 017fffc000000000 ffffe704c422f808 ffffe704c41ac008 0000000000000000
>>> raw: 000000000003f8a0 0000000000000005 00000000ffffff7f 0000000000000000
>>> page dumped because: VM_BUG_ON_PAGE(n > 0 && !((__builtin_constant_p(PG_head) && __builtin_constant_p((uintptr_t)(&page->flags) != (uintptr_t)((vo>
>>> ------------[ cut here ]------------
>>> kernel BUG at include/linux/page-flags.h:314!
>>> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>>> CPU: 6 PID: 2435641 Comm: md5sum Not tainted 6.6.0-rc5 #2
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>> RIP: 0010:folio_flags+0x65/0x70
>>> Code: a8 40 74 de 48 8b 47 48 a8 01 74 d6 48 83 e8 01 48 39 c7 75 bd eb cb 48 8b 07 a8 40 75 c8 48 c7 c6 d8 a7 c3 89 e8 3b c7 fa ff <0f> 0b 66 0f >
>>> RSP: 0018:ffffad51c0bfb7a8 EFLAGS: 00010246
>>> RAX: 000000000000015f RBX: ffffe704c40d7000 RCX: 0000000000000000
>>> RDX: 0000000000000000 RSI: ffffffff89be8040 RDI: 00000000ffffffff
>>> RBP: 0000000000103600 R08: 0000000000000000 R09: ffffad51c0bfb658
>>> R10: 0000000000000003 R11: ffffffff89eacb08 R12: 0000000000000035
>>> R13: ffffe704c40d7000 R14: 0000000000000000 R15: ffffad51c0bfb930
>>> FS:  00007f350c51b740(0000) GS:ffff9b62fbd80000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000555860919508 CR3: 00000001217fe002 CR4: 0000000000770ee0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> PKRU: 55555554
>>> Call Trace:
>>>   <TASK>
>>>   ? die+0x32/0x80
>>>   ? do_trap+0xd6/0x100
>>>   ? folio_flags+0x65/0x70
>>>   ? do_error_trap+0x6a/0x90
>>>   ? folio_flags+0x65/0x70
>>>   ? exc_invalid_op+0x4c/0x60
>>>   ? folio_flags+0x65/0x70
>>>   ? asm_exc_invalid_op+0x16/0x20
>>>   ? folio_flags+0x65/0x70
>>>   ? folio_flags+0x65/0x70
>>>   PageHuge+0x67/0x80
>>>   isolate_migratepages_block+0x1c5/0x13b0
>>>   compact_zone+0x746/0xfc0
>>>   compact_zone_order+0xbb/0x100
>>>   try_to_compact_pages+0xf0/0x2f0
>>>   __alloc_pages_direct_compact+0x78/0x210
>>>   __alloc_pages_slowpath.constprop.0+0xac1/0xdb0
>>>   __alloc_pages+0x218/0x240
>>>   folio_alloc+0x17/0x50
>>
>> It's because PageHuge() now does folio_test_hugetlb() which is documented to
>> assume caller holds a reference, but the test in
>> isolate_migratepages_block() doesn't. The code is there from 2021 by Oscar,
>> perhaps it could be changed to take a reference (and e.g. only test
>> PageHead() before), but it will be a bit involved as the
>> isolate_or_dissolve_huge_page() it calls has some logic based on the
>> refcount being zero/non-zero as well. Oscar, what do you think?
>> Also I wonder if any of the the other existing PageHuge() callers are also
>> affected because they might be doing so without a reference.
> 
> I don't think the warning is actually wrong!  We're living very
> dangerously here as PageHuge() could have returned a false positive
> before this change [1].  Then we assume that compound_nr() returns a
> consistent result (and compound_order() might, for example, return a
> value larger than 63, leading to UB).

All this code is racy (as spelled out in some of the code comments), and the
assumption is that races are tolerable. In the worst case, isolation fails on
races.

There is some code in there that sanitizes compound_order() return values :

		/*
		 * Regardless of being on LRU, compound pages such as THP and
		 * hugetlbfs are not to be compacted unless we are attempting
		 * an allocation much larger than the huge page size (eg CMA).
		 * We can potentially save a lot of iterations if we skip them
		 * at once. The check is racy, but we can consider only valid
		 * values and the only danger is skipping too much.
		 */
		if (PageCompound(page) && !cc->alloc_contig) {
			const unsigned int order = compound_order(page);

			if (likely(order <= MAX_ORDER)) {
				low_pfn += (1UL << order) - 1;
				nr_scanned += (1UL << order) - 1;
			}
			goto isolate_fail;
		}

At least isolate_or_dissolve_huge_page() looks like it wants to deal with
concurrent dissolving of hugetlb folios properly. See below, if it is
actually correct.

> 
> I think there's a place for a folio_test_hugetlb_unsafe(), but that
> would only remove the warning, and do nothing to fix all the unsafe
> usage.  The hugetlb handling code in isolate_migratepages_block()
> doesn't seem to have any understanding that it's working with pages
> that can change under it.  

Staring at the code (once again), I think we might miss to sanitize
the compound_nr() return value; but I'm not sure if that is really
problematic; We can get out-of-memory low_pfn either way when we're
operating at the end of memory, memory holes etc.

> I can have a go at fixing it up, but maybe
> Oscar would prefer to do it?
> 
> [1] terribly unlikely, but consider what happens if the page starts out
> as a non-hugetlb compound allocation.  Then it is freed and reallocated;
> the new owner of the second page could have put enough information
> into it that tricked PageHuge() into returning true.  Then we call

I think that got more likely by using a pageflag :)

> isolate_or_dissolve_huge_page() which takes a lock, but doesn't take
> a refcount.  Now it gets a bogus hstate and things go downhill from
> there ...)

hugetlb folios can have a refocunt of 0, in which case they are considered
"free". The recount handling at the end of isolate_or_dissolve_huge_page()
gives a hint that this is how hugetlb operates.

So grabbing references as you're used to from !hugetlb code doesn't work.

That function needs some care, to deal with what you described. Maybe
something like the following (assuming page_folio() is fine):


bool is_hugetlb_folio = false;


/*
  * Especially for free hugetlb folios, we cannot use the recount
  * to stabilize. While holding the hugetlb_lock, no hugetlb folios can
  * be dissolved.
  */
spin_lock_irq(&hugetlb_lock);
folio = page_folio(page);

if (folio_test_hugetlb_unsafe(folio)) {
	/*
          * We might have a false positive. Make sure the folio hasn't
          * changed in the meantime and still is a hugetlb folio.
	 */
	smp_rmb();
	if (folio == page_folio(page) &&
	    folio_test_hugetlb_unsafe(folio))
		is_hugetlb_folio = true;
}

if (is_hugetlb_folio)
	h = folio_hstate(folio);
spin_unlock_irq(&hugetlb_lock);
if (!is_hugetlb_folio)
	return 0;


But devil is in the detail (could someone trick us twice?).

isolate_hugetlb() performs similar lockless checks under
hugetlb_lock, and likely we should just unify them once we figure
out the right thing to do.

-- 
Cheers,

David / dhildenb


