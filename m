Return-Path: <io-uring+bounces-5870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30508A11ABF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 08:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32BE3A6272
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 07:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89661DB12A;
	Wed, 15 Jan 2025 07:15:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D688B1DB123;
	Wed, 15 Jan 2025 07:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736925341; cv=none; b=qWosq0WvN6lakidZb9LZo4UFXNmDi7YUy5H+YSQlAQz80sQ6JJuU0t0fUH8KpQkc4+uunOfTOPZkV6qE6dlsVsrmku0S1ak1WSZ5UIJiuf71o7cYTe2m8nLpRrJ6mDXeFdNLcfZYI7oV4o6w9wlU6JJAqbMc8n9kKULS+UJhSVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736925341; c=relaxed/simple;
	bh=XTfYeOYdNjhi9x2oJK4o0/XfD+i/tlZy1DRxSaja6sY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WE1q+OrA32cFdavVPSWgJNNF9FlMNv3yFVSEXuZ9ZPb3hNuhiMkPHl1CjEgak0srgTae0mY/Na6YzMKMu/ouJmVmn4fVHDxRDv4eZrygXRRsgHmaT7Q33QShDJj393wAEcO5UyaNtUS8wI17Gi13cA5zkJksXNvsz66XI7AKk28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-3e1ff7000001d7ae-93-67876096efa2
Message-ID: <c210f152-5eb7-456a-8cd3-ec75e1a5b266@sk.com>
Date: Wed, 15 Jan 2025 16:15:34 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, Andrew Morton <akpm@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 damon@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations
 from process_madvise()
Content-Language: ko
To: SeongJae Park <sj@kernel.org>
References: <20250115061910.58938-1-sj@kernel.org>
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250115061910.58938-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LhesuzSHdaQnu6wY7HChZz1q9hs5izahuj
	xeq7/WwWT/7/ZrV413qOxWJ7wwN2i8u75rBZ3Fvzn9Xi5KyVLBaHv75hcuDy2DnrLrvH5bOl
	HptWdbJ5bPo0id3jxIzfLB4vNs9k9Pj49BaLx+dNcgEcUVw2Kak5mWWpRfp2CVwZM9ZeYC94
	K1bRf/8MUwPjRqEuRg4OCQETiZkzE7oYOcHMm3f3MoKEeQUsJabN5wUxWQRUJZ4fDAWp4BUQ
	lDg58wkLiC0qIC9x/9YM9i5GLg5mgbVMEjOmTmEGSQgLJEtMv3OQDcRmFhCRmN3ZBhYXEVCU
	OPf4IiuILSRgJHHy9xqwQWwCahJXXk5iAtnFKWAs8f1fPUSrmUTX1i5GCFteYvvbOcwguyQE
	XrNJrH47jRHiZEmJgytusExgFJyF5L5ZSFbPQjJrFpJZCxhZVjEKZeaV5SZm5pjoZVTmZVbo
	JefnbmIExtCy2j/ROxg/XQg+xCjAwajEw3shvi1diDWxrLgy9xCjBAezkgjvErbWdCHelMTK
	qtSi/Pii0pzU4kOM0hwsSuK8Rt/KU4QE0hNLUrNTUwtSi2CyTBycUg2Moi+Pe/88486y0fZK
	XhxTcPzM1eXXvcqULuzOPrPNWMRx9d8codmtV0JEVhf0iDes3vYkMtq9nPukxbMjSWyTT1xQ
	mr92D4P9f5mr9581HgzRbTr+6QJTn5XyDHH29YbFH+VLftuar7kY8kNE6/TWwFL5v/GXRTgS
	l5m4F1nNnKx7bM37Xb/MlViKMxINtZiLihMBHWf0NZ0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsXCNUNLT3daQnu6wappYhZz1q9hs5izahuj
	xeq7/WwWT/7/ZrV413qOxeLw3JOsFtsbHrBbXN41h83i3pr/rBYnZ60ESnx9w+TA7bFz1l12
	j8tnSz02repk89j0aRK7x4kZv1k8Xmyeyejx8ektFo/FLz4weXzeJBfAGcVlk5Kak1mWWqRv
	l8CVMWPtBfaCt2IV/ffPMDUwbhTqYuTkkBAwkbh5dy9jFyMHB6+ApcS0+bwgJouAqsTzg6Eg
	FbwCghInZz5hAbFFBeQl7t+awd7FyMXBLLCWSWLG1CnMIAlhgWSJ6XcOsoHYzAIiErM728Di
	IgKKEuceX2QFsYUEjCRO/l4DNohNQE3iystJTCC7OAWMJb7/q4doNZPo2trFCGHLS2x/O4d5
	AiPfLCRnzEKyYRaSlllIWhYwsqxiFMnMK8tNzMwx1SvOzqjMy6zQS87P3cQIjIlltX8m7mD8
	ctn9EKMAB6MSD++JiLZ0IdbEsuLK3EOMEhzMSiK8S9ha04V4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzeoWnJggJpCeWpGanphakFsFkmTg4pRoYtzzpXvyi377+pZWLhxzLb9/LR3ZsW/RYtiz0
	Z0au3oR9HWLP+VunPDlo/YM79kznW7dkk6kf2Hcm3V3JV/HJv5lPgktJzPRFUNiG35s3r5Pb
	0M66YlOxT/J1YeuImdFay6o6Q7Ru2BtLtkRskHrsnqeWLBxU2yP0rP3KnUy2vfViOayXxLYo
	sRRnJBpqMRcVJwIA58YCEoUCAAA=
X-CFilter-Loop: Reflected

Hi SeongJae,

I'm resending this because my new mail client mistakenly set the mail
format to HTML. Sorry for the noise.

On 1/15/2025 3:19 PM, SeongJae Park wrote:
> Hi Honggyu,
> 
> On Wed, 15 Jan 2025 13:35:48 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
> 
>> Hi SeongJae,
>>
>> I have a simple comment on this.
>>
>> On 1/11/2025 9:46 AM, SeongJae Park wrote:
>>> process_madvise() calls do_madvise() for each address range.  Then, each
>>> do_madvise() invocation holds and releases same mmap_lock.  Optimize the
>>> redundant lock operations by doing the locking in process_madvise(), and
>>> inform do_madvise() that the lock is already held and therefore can be
>>> skipped.
> [...]
>>> ---
>>>    include/linux/mm.h |  3 ++-
>>>    io_uring/advise.c  |  2 +-
>>>    mm/damon/vaddr.c   |  2 +-
>>>    mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
>>>    4 files changed, 45 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 612b513ebfbd..e3ca5967ebd4 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
>>>    		    unsigned long end, struct list_head *uf, bool unlock);
>>>    extern int do_munmap(struct mm_struct *, unsigned long, size_t,
>>>    		     struct list_head *uf);
>>> -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
>>> +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
>>> +		int behavior, bool lock_held);
>>>    
>>>    #ifdef CONFIG_MMU
>>>    extern int __mm_populate(unsigned long addr, unsigned long len,
>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>> index cb7b881665e5..010b55d5a26e 100644
>>> --- a/io_uring/advise.c
>>> +++ b/io_uring/advise.c
>>> @@ -56,7 +56,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
>>>    
>>>    	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
>>>    
>>> -	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
>>> +	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice, false);
>>
>> I feel like this doesn't look good in terms of readability. Can we
>> introduce an enum for this?
> 
> I agree that's not good to read.  Liam alos pointed out a similar issue but

Right. I didn't carefully read his comment. Thanks for the info.

> suggested splitting functions with clear names[1].  I think that also fairly
> improves readability, and I slightly prefer that way, since it wouldn't
> introduce a new type for only a single use case.  Would that also work for your
> concern, or do you have a different opinion?
> 
> [1] https://lore.kernel.org/20250115041750.58164-1-sj@kernel.org

I don't have any other concern.

Thanks,
Honggyu

> Thanks,
> SJ
> 
> [...]


