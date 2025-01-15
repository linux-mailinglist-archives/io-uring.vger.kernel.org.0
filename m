Return-Path: <io-uring+bounces-5868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1069EA11897
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 05:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9FE13A10AB
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 04:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC02022DFAD;
	Wed, 15 Jan 2025 04:51:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E839214A4F0;
	Wed, 15 Jan 2025 04:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736916663; cv=none; b=DsPvt0oBt1B/kAkfeF7evWo9BwTyfT40PaRXgwWWT1CM+kD9uAzw7Y1HLu4RlOIDYrUX9CwDFOQIgkSurA+TU2FTQ2cW8ISr43w+yFialYOgpNRE3GC/AX7f42a324QIJnk1nsp/5ufhTVjmx39AnqZQEvVf1mCqMK9Q2mEMEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736916663; c=relaxed/simple;
	bh=nKE4bDk9uffl83Ll+KoIAz7VLIQRd1mQmG9IeQeao/g=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mq0kybdFwjsjGcO8N+v2OsUfZQ+Gsu8HvBF7ARSgaTaXSNb6qLS4rRVos76tjXj0nboJC3zJX6SYJBRM6MjSupedqSgCqpBGBTFle+R8DN68ydlMFHZf8XRyc0Pr4FGm6hpLK6hIrQzSor0rRfVtBA9N0bchZ9A277ujMWXhh4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-3c9ff7000001d7ae-ca-67873b240812
Message-ID: <00242654-5e98-4489-ae6d-f4dd01bfdaa7@sk.com>
Date: Wed, 15 Jan 2025 13:35:48 +0900
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
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations
 from process_madvise()
Content-Language: ko
To: SeongJae Park <sj@kernel.org>
References: <20250111004618.1566-1-sj@kernel.org>
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250111004618.1566-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LhesuzSFfFuj3dYFabhcWc9WvYLOas2sZo
	sfpuP5vFk/+/WS3etZ5jsbi8aw6bxb01/1ktTs5ayWJx+OsbJgdOj52z7rJ7XD5b6rFpVSeb
	x6ZPk9g9Tsz4zeLxYvNMRo+PT2+xeHzeJBfAEcVlk5Kak1mWWqRvl8CVsX5fK1PBXbuKrr9v
	WBoYVxl0MXJySAiYSCzpWMcGY18+1c4KYvMKWEpMODEBzGYRUJU4seELO0RcUOLkzCcsILao
	gLzE/VszgOJcHMwCk5gkXm2YCVYkLJAsMf3OQbChzAIiErM725hBbBEBRYlzjy+CDRUSMJRY
	eXw3WA2bgJrElZeTmEBsTgEjiVtnWxkhes0kurZ2QdnyEtvfzmEGWSYhcJ9NYtm8T+wQV0tK
	HFxxg2UCo+AsJAfOQrJ7FpJZs5DMWsDIsopRKDOvLDcxM8dEL6MyL7NCLzk/dxMjMIKW1f6J
	3sH46ULwIUYBDkYlHt4L8W3pQqyJZcWVuYcYJTiYlUR4l7C1pgvxpiRWVqUW5ccXleakFh9i
	lOZgURLnNfpWniIkkJ5YkpqdmlqQWgSTZeLglGpgXKFxXq7B+FqO7W+mOYlhxjcvWod/V+uR
	/ORb8nJjbcf7rBPeVi/4I80lvpRmTPzcdM6J6d6OvzqhZlNZrO+7vvuYlLSpRO9TYsbfc/d9
	BRWUoxsl/J5efsNxqSr/S+KbG/1vbUI00y5tyvz4/Pz0Hfxvl1RweC3ep+8p8EZzTbmIRu/W
	SUzaSizFGYmGWsxFxYkAoQqHyJwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsXCNUNLT1fFuj3d4NFvLYs569ewWcxZtY3R
	YvXdfjaLJ/9/s1q8az3HYnF47klWi8u75rBZ3Fvzn9Xi5KyVQLGvb5gcuDx2zrrL7nH5bKnH
	plWdbB6bPk1i9zgx4zeLx4vNMxk9Pj69xeKx+MUHJo/Pm+QCOKO4bFJSczLLUov07RK4Mtbv
	a2UquGtX0fX3DUsD4yqDLkZODgkBE4nLp9pZQWxeAUuJCScmgNksAqoSJzZ8YYeIC0qcnPmE
	BcQWFZCXuH9rBlCci4NZYBKTxKsNM8GKhAWSJabfOcgGYjMLiEjM7mxjBrFFBBQlzj2+CDZU
	SMBQYuXx3WA1bAJqEldeTmICsTkFjCRunW1lhOg1k+ja2gVly0tsfzuHeQIj3ywkd8xCsmIW
	kpZZSFoWMLKsYhTJzCvLTczMMdUrzs6ozMus0EvOz93ECIyHZbV/Ju5g/HLZ/RCjAAejEg/v
	iYi2dCHWxLLiytxDjBIczEoivEvYWtOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83qFpyYICaQn
	lqRmp6YWpBbBZJk4OKUaGM+Umb48XRommrZ/7267wyFGTTwKr/KPORXGW2XOzWxLDV9UZZOv
	ItTVOVfK6+TT881bGOoqjXoiV80zYVjxJclETWDHkS7b8MN6E9wFt5663PrErmfnzunzghq2
	LL/75mbJftZTxt+23hVimOH36v9Bmx8pMX+un358L8TqF8OZLyUFclsnPFRiKc5INNRiLipO
	BACBhKntgwIAAA==
X-CFilter-Loop: Reflected

Hi SeongJae,

I have a simple comment on this.

On 1/11/2025 9:46 AM, SeongJae Park wrote:
> process_madvise() calls do_madvise() for each address range.  Then, each
> do_madvise() invocation holds and releases same mmap_lock.  Optimize the
> redundant lock operations by doing the locking in process_madvise(), and
> inform do_madvise() that the lock is already held and therefore can be
> skipped.
>
> Evaluation
> ==========
>
> I measured the time to apply MADV_DONTNEED advice to 256 MiB memory
> using multiple madvise() calls, 4 KiB per each call.  I also do the same
> with process_madvise(), but with varying iovec size from 1 to 1024.
> The source code for the measurement is available at GitHub[1].
>
> The measurement results are as below.  'sz_batches' column shows the
> iovec size of process_madvise() calls.  '0' is for madvise() calls case.
> 'before' and 'after' columns are the measured time to apply
> MADV_DONTNEED to the 256 MiB memory buffer in nanoseconds, on kernels
> that built without and with this patch, respectively.  So lower value
> means better efficiency.  'after/before' column is the ratio of 'after'
> to 'before'.
>
>      sz_batches  before     after      after/before
>      0           124062365  96670188   0.779206393494111
>      1           136341258  113915688  0.835518827323714
>      2           105314942  78898211   0.749164453796119
>      4           82012858   59778998   0.728897875989153
>      8           82562651   51003069   0.617749895167489
>      16          71474930   47575960   0.665631431888076
>      32          71391211   42902076   0.600943385033768
>      64          68225932   41337835   0.605896230190011
>      128         71053578   42467240   0.597679120395598
>      256         85094126   41630463   0.489228398679364
>      512         68531628   44049763   0.6427654542221
>      1024        79338892   43370866   0.546653285755491
>
> The measurement shows this patch reduces the process_madvise() latency,
> proportional to the batching size, from about 25% with the batch size 2
> to about 55% with the batch size 1,024.  The trend is somewhat we can
> expect.
>
> Interestingly, this patch has also optimize madvise() and single batch
> size process_madvise(), though.  I ran this test multiple times, but the
> results are consistent.  I'm still investigating if there are something
> I'm missing.  But I believe the investigation may not necessarily be a
> blocker of this RFC, so just posting this.  I will add updates of the
> madvise() and single batch size process_madvise() investigation later.
>
> [1] https://github.com/sjp38/eval_proc_madvise
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   include/linux/mm.h |  3 ++-
>   io_uring/advise.c  |  2 +-
>   mm/damon/vaddr.c   |  2 +-
>   mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
>   4 files changed, 45 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 612b513ebfbd..e3ca5967ebd4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
>   		    unsigned long end, struct list_head *uf, bool unlock);
>   extern int do_munmap(struct mm_struct *, unsigned long, size_t,
>   		     struct list_head *uf);
> -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
> +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> +		int behavior, bool lock_held);
>   
>   #ifdef CONFIG_MMU
>   extern int __mm_populate(unsigned long addr, unsigned long len,
> diff --git a/io_uring/advise.c b/io_uring/advise.c
> index cb7b881665e5..010b55d5a26e 100644
> --- a/io_uring/advise.c
> +++ b/io_uring/advise.c
> @@ -56,7 +56,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
>   
>   	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
>   
> -	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
> +	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice, false);

I feel like this doesn't look good in terms of readability. Can we 
introduce an enum for this?

>   	io_req_set_res(req, ret, 0);
>   	return IOU_OK;
>   #else
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index a6174f725bd7..30b5a251d73e 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -646,7 +646,7 @@ static unsigned long damos_madvise(struct damon_target *target,
>   	if (!mm)
>   		return 0;
>   
> -	applied = do_madvise(mm, start, len, behavior) ? 0 : len;
> +	applied = do_madvise(mm, start, len, behavior, false) ? 0 : len;
>   	mmput(mm);
>   
>   	return applied;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 49f3a75046f6..c107376db9d5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1637,7 +1637,8 @@ int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
>    *  -EAGAIN - a kernel resource was temporarily unavailable.
>    *  -EPERM  - memory is sealed.
>    */
> -int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
> +int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> +		int behavior, bool lock_held)
>   {
>   	unsigned long end;
>   	int error;
> @@ -1668,12 +1669,14 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
>   		return madvise_inject_error(behavior, start, start + len_in);
>   #endif
>   
> -	write = madvise_need_mmap_write(behavior);
> -	if (write) {
> -		if (mmap_write_lock_killable(mm))
> -			return -EINTR;
> -	} else {
> -		mmap_read_lock(mm);
> +	if (!lock_held) {
> +		write = madvise_need_mmap_write(behavior);
> +		if (write) {
> +			if (mmap_write_lock_killable(mm))
> +				return -EINTR;
> +		} else {
> +			mmap_read_lock(mm);
> +		}
>   	}
>   
>   	start = untagged_addr_remote(mm, start);
> @@ -1692,17 +1695,19 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
>   	}
>   	blk_finish_plug(&plug);
>   
> -	if (write)
> -		mmap_write_unlock(mm);
> -	else
> -		mmap_read_unlock(mm);
> +	if (!lock_held) {
> +		if (write)
> +			mmap_write_unlock(mm);
> +		else
> +			mmap_read_unlock(mm);
> +	}
>   
>   	return error;
>   }
>   
>   SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
>   {
> -	return do_madvise(current->mm, start, len_in, behavior);
> +	return do_madvise(current->mm, start, len_in, behavior, false);
>   }
>   
>   /* Perform an madvise operation over a vector of addresses and lengths. */
> @@ -1711,12 +1716,28 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>   {
>   	ssize_t ret = 0;
>   	size_t total_len;
> +	bool hold_lock = true;
> +	int write;
>   
>   	total_len = iov_iter_count(iter);
>   
> +#ifdef CONFIG_MEMORY_FAILURE
> +	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> +		hold_lock = false;
> +#endif
> +	if (hold_lock) {
> +		write = madvise_need_mmap_write(behavior);
> +		if (write) {
> +			if (mmap_write_lock_killable(mm))
> +				return -EINTR;
> +		} else {
> +			mmap_read_lock(mm);
> +		}
> +	}
> +
>   	while (iov_iter_count(iter)) {
>   		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
> -				 iter_iov_len(iter), behavior);
> +				 iter_iov_len(iter), behavior, hold_lock);
>   		/*
>   		 * An madvise operation is attempting to restart the syscall,
>   		 * but we cannot proceed as it would not be correct to repeat
> @@ -1739,6 +1760,13 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>   		iov_iter_advance(iter, iter_iov_len(iter));
>   	}
>   
> +	if (hold_lock) {
> +		if (write)
> +			mmap_write_unlock(mm);
> +		else
> +			mmap_read_unlock(mm);
> +	}
> +
>   	ret = (total_len - iov_iter_count(iter)) ? : ret;
>   
>   	return ret;

