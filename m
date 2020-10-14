Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6663C28E7E8
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgJNUcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 16:32:05 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33068 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729022AbgJNUcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 16:32:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UC1ta.6_1602707517;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UC1ta.6_1602707517)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Oct 2020 04:31:57 +0800
Subject: Re: Loophole in async page I/O
To:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
 <0a2918fc-b2e4-bea0-c7e1-265a3da65fc9@kernel.dk>
 <22881662-a503-1706-77e2-8f71bf41fe49@kernel.dk>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Message-ID: <22435d46-bf78-ee8d-4470-bb3bcbc20cf2@linux.alibaba.com>
Date:   Thu, 15 Oct 2020 04:31:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <22881662-a503-1706-77e2-8f71bf41fe49@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2020/10/13 上午6:42, Jens Axboe 写道:
> On 10/12/20 4:22 PM, Jens Axboe wrote:
>> On 10/12/20 4:08 PM, Jens Axboe wrote:
>>> On 10/12/20 3:13 PM, Matthew Wilcox wrote:
>>>> This one's pretty unlikely, but there's a case in buffered reads where
>>>> an IOCB_WAITQ read can end up sleeping.
>>>>
>>>> generic_file_buffered_read():
>>>>                  page = find_get_page(mapping, index);
>>>> ...
>>>>                  if (!PageUptodate(page)) {
>>>> ...
>>>>                          if (iocb->ki_flags & IOCB_WAITQ) {
>>>> ...
>>>>                                  error = wait_on_page_locked_async(page,
>>>>                                                                  iocb->ki_waitq);
>>>> wait_on_page_locked_async():
>>>>          if (!PageLocked(page))
>>>>                  return 0;
>>>> (back to generic_file_buffered_read):
>>>>                          if (!mapping->a_ops->is_partially_uptodate(page,
>>>>                                                          offset, iter->count))
>>>>                                  goto page_not_up_to_date_locked;
>>>>
>>>> page_not_up_to_date_locked:
>>>>                  if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>>>                          unlock_page(page);
>>>>                          put_page(page);
>>>>                          goto would_block;
>>>>                  }
>>>> ...
>>>>                  error = mapping->a_ops->readpage(filp, page);
>>>> (will unlock page on I/O completion)
>>>>                  if (!PageUptodate(page)) {
>>>>                          error = lock_page_killable(page);
>>>>
>>>> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
>>>> and wait for the I/O to complete.  I can't quite figure out if this is
>>>> intentional -- I think not; if I understand the semantics right, we
>>>> should be returning -EIOCBQUEUED and punting to an I/O thread to
>>>> kick off the I/O and wait.
>>>>
>>>> I think the right fix is to return -EIOCBQUEUED from
>>>> wait_on_page_locked_async() if the page isn't locked.  ie this:
>>>>
>>>> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>>>>                                       struct wait_page_queue *wait)
>>>>   {
>>>>          if (!PageLocked(page))
>>>> -               return 0;
>>>> +               return -EIOCBQUEUED;
>>>>          return __wait_on_page_locked_async(compound_head(page), wait, false);
>>>>   }
>>>>   
>>>> But as I said, I'm not sure what the semantics are supposed to be.
>>>
>>> If NOWAIT isn't set, then the issue attempt is from the helper thread
>>> already, and IOCB_WAITQ shouldn't be set either (the latter doesn't
>>> matter for this discussion). So it's totally fine and expected to block
>>> at that point.
>>>
>>> Hmm actually, I believe that:
>>>
>>> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
>>> Author: Hao Xu <haoxu@linux.alibaba.com>
>>> Date:   Tue Sep 29 20:00:45 2020 +0800
>>>
>>>      io_uring: fix async buffered reads when readahead is disabled
>>>
>>> maybe messed up that case, so we could block off the retry-path. I'll
>>> take a closer look, looks like that can be the case if read-ahead is
>>> disabled.
>>>
>>> In general, we can only return -EIOCBQUEUED if the IO has been started
>>> or is in progress already. That means we can safely rely on being told
>>> when it's unlocked/done. If we need to block, we should be returning
>>> -EAGAIN, which would punt to a worker thread.
>>
>> Something like the below might be a better solution - just always use
>> the read-ahead to generate the IO, for the requested range. That won't
>> issue any IO beyond what we asked for. And ensure we don't clear NOWAIT
>> on the io_uring side for retry.
>>
>> Totally untested... Just trying to get the idea across. We might need
>> some low cap on req_count in case the range is large. Hao Xu, can you
>> try with this? Thinking of your read-ahead disabled slowdown as well,
>> this could very well be the reason why.
> 
> Here's one that caps us at 1 page, if read-ahead is disabled or we're
> congested. Should still be fine in terms of being async, and it allows
> us to use the same path for this instead of special casing it.
> 
> I ran some quick testing on this, and it seems to Work For Me. I'll do
> some more targeted testing.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index aae0ef2ec34d..9a2dfe132665 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3107,7 +3107,6 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>   	wait->wait.flags = 0;
>   	INIT_LIST_HEAD(&wait->wait.entry);
>   	kiocb->ki_flags |= IOCB_WAITQ;
> -	kiocb->ki_flags &= ~IOCB_NOWAIT;
>   	kiocb->ki_waitq = wait;
>   
>   	io_get_req_task(req);
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 3c9a8dd7c56c..d0f556612fd6 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -568,15 +568,20 @@ void page_cache_sync_readahead(struct address_space *mapping,
>   			       struct file_ra_state *ra, struct file *filp,
>   			       pgoff_t index, unsigned long req_count)
>   {
> -	/* no read-ahead */
> -	if (!ra->ra_pages)
> -		return;
> +	bool do_forced_ra = filp && (filp->f_mode & FMODE_RANDOM);
>   
> -	if (blk_cgroup_congested())
> -		return;
> +	/*
> +	 * Even if read-ahead is disabled, issue this request as read-ahead
> +	 * as we'll need it to satisfy the requested range. The forced
> +	 * read-ahead will do the right thing and limit the read to just the
> +	 * requested range, which we'll set to 1 page for this case.
> +	 */
> +	if (!ra->ra_pages || blk_cgroup_congested()) {
> +		req_count = 1;
> +		do_forced_ra = true;
> +	}
>   
> -	/* be dumb */
> -	if (filp && (filp->f_mode & FMODE_RANDOM)) {
> +	if (do_forced_ra) {
>   		force_page_cache_readahead(mapping, filp, index, req_count);
>   		return;
>   	}
> 

Hi Jens,
I've done some tests for the new fix code with readahead disabled from 
userspace. Here comes some results.
For the perf reports, since I'm new to kernel stuff, still investigating 
on it.
I'll keep addressing the issue which causes the difference among the 
four perf reports(in which the  copy_user_enhanced_fast_string() catches 
my eyes)

my environment is:
     server: physical server
     kernel: mainline 5.9.0-rc8+ latest commit 6f2f486d57c4d562cdf4
     fs: ext4
     device: nvme ssd
     fio: 3.20

I did the tests by setting and commenting the code:
     filp->f_mode |= FMODE_BUF_RASYNC;
in fs/ext4/file.c ext4_file_open()

the IOPS with readahead disabled from userspace is below:

with new fix code(force readahead)
QD/Test        FMODE_BUF_RASYNC set    FMODE_BUF_RASYNC not set
1                    10.8k                  10.3k
2                    21.2k                  20.1k
4                    41.1k                  39.1k
8                    76.1k                  72.2k
16                   133k                   126k
32                   169k                   147k
64                   176k                   160k
128                  (1)187k                (2)156k

now async buffered reads feature looks better in terms of IOPS,
but it still looks similar with the async buffered reads feature in the 
mainline code.

with mainline code(the fix code in commit c8d317aa1887 ("io_uring: fix 
async buffered reads when readahead is disabled"))
QD/Test        FMODE_BUF_RASYNC set    FMODE_BUF_RASYNC not set
1                       10.9k            10.2k
2                       21.6k            20.2k
4                       41.0k            39.9k
8                       79.7k            75.9k
16                      141k             138k
32                      169k             237k
64                      190k             316k
128                     (3)195k          (4)315k

Considering the number in place (1)(2)(3)(4), the new fix doesn't seem 
to fix the slow down
but make the number (4) become number (2)

the perf reports of (1)(2)(3)(4) situations are:
(1)
   9 # Overhead  Command  Shared Object       Symbol
  10 # ........  .......  .................. 
..............................................
  11 #
  12     10.19%  fio      [kernel.vmlinux]    [k] 
copy_user_enhanced_fast_string
  13      8.53%  fio      fio                 [.] clock_thread_fn
  14      4.67%  fio      [kernel.vmlinux]    [k] xas_load
  15      2.18%  fio      [kernel.vmlinux]    [k] clear_page_erms
  16      2.02%  fio      libc-2.24.so        [.] __memset_avx2_erms
  17      1.55%  fio      [kernel.vmlinux]    [k] mutex_unlock
  18      1.51%  fio      [kernel.vmlinux]    [k] shmem_getpage_gfp
  19      1.48%  fio      [kernel.vmlinux]    [k] native_irq_return_iret
  20      1.48%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
  21      1.46%  fio      [kernel.vmlinux]    [k] generic_file_buffered_read
  22      1.45%  fio      [nvme]              [k] nvme_irq
  23      1.25%  fio      [kernel.vmlinux]    [k] __list_del_entry_valid
  24      1.22%  fio      [kernel.vmlinux]    [k] free_pcppages_bulk
  25      1.15%  fio      [kernel.vmlinux]    [k] _raw_spin_lock
  26      1.12%  fio      fio                 [.] get_io_u
  27      0.81%  fio      [ext4]              [k] ext4_mpage_readpages
  28      0.78%  fio      fio                 [.] fio_gettime
  29      0.76%  fio      [kernel.vmlinux]    [k] find_get_entries
  30      0.75%  fio      [vdso]              [.] __vdso_clock_gettime
  31      0.73%  fio      [kernel.vmlinux]    [k] release_pages
  32      0.68%  fio      [kernel.vmlinux]    [k] find_get_entry
  33      0.68%  fio      fio                 [.] io_u_queued_complete
  34      0.67%  fio      [kernel.vmlinux]    [k] io_async_buf_func
  35      0.65%  fio      [kernel.vmlinux]    [k] io_submit_sqes
  ...

(2)
   9 # Overhead  Command  Shared Object       Symbol
  10 # ........  .......  .................. 
..............................................
  11 #
  12      7.94%  fio      fio                 [.] clock_thread_fn
  13      3.83%  fio      [kernel.vmlinux]    [k] xas_load
  14      2.57%  fio      [kernel.vmlinux]    [k] io_prep_async_work
  15      2.24%  fio      [kernel.vmlinux]    [k] clear_page_erms
  16      1.99%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irqsave
  17      1.94%  fio      libc-2.24.so        [.] __memset_avx2_erms
  18      1.83%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
  19      1.78%  fio      [kernel.vmlinux]    [k] __fget_files
  20      1.67%  fio      [kernel.vmlinux]    [k] __list_del_entry_valid
  21      1.50%  fio      fio                 [.] get_io_u
  22      1.41%  fio      [kernel.vmlinux]    [k] shmem_getpage_gfp
  23      1.40%  fio      [kernel.vmlinux]    [k] io_prep_rw
  24      1.39%  fio      [kernel.vmlinux]    [k] mutex_unlock
  25      1.28%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irq
  26      1.21%  fio      [kernel.vmlinux]    [k] free_pcppages_bulk
  27      1.17%  fio      [kernel.vmlinux]    [k] generic_file_buffered_read
  28      1.11%  fio      [ext4]              [k] ext4_mpage_readpages
  29      1.11%  fio      fio                 [.] fio_gettime
  30      1.09%  fio      [kernel.vmlinux]    [k] __pagevec_lru_add_fn
  31      1.04%  fio      [kernel.vmlinux]    [k] kmem_cache_alloc_bulk
  32      0.99%  fio      [kernel.vmlinux]    [k] io_submit_sqes
  33      0.95%  fio      fio                 [.] io_u_queued_complete
  34      0.90%  fio      [kernel.vmlinux]    [k] io_wqe_wake_worker
  35      0.78%  fio      [vdso]              [.] __vdso_clock_gettime
  ...

(3)
   9 # Overhead  Command  Shared Object       Symbol
  10 # ........  .......  .................. 
..............................................
  11 #
  12      9.06%  fio      fio                 [.] clock_thread_fn
  13      6.05%  fio      [kernel.vmlinux]    [k] 
copy_user_enhanced_fast_string
  14      4.27%  fio      [kernel.vmlinux]    [k] xas_load
  15      2.31%  fio      [kernel.vmlinux]    [k] clear_page_erms
  16      2.09%  fio      libc-2.24.so        [.] __memset_avx2_erms
  17      1.70%  fio      fio                 [.] get_io_u
  18      1.67%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
  19      1.67%  fio      [kernel.vmlinux]    [k] shmem_getpage_gfp
  20      1.61%  fio      [kernel.vmlinux]    [k] native_irq_return_iret
  21      1.56%  fio      [kernel.vmlinux]    [k] generic_file_buffered_read
  22      1.34%  fio      [kernel.vmlinux]    [k] __list_del_entry_valid
  23      1.29%  fio      [kernel.vmlinux]    [k] mutex_unlock
  24      1.24%  fio      [kernel.vmlinux]    [k] free_pcppages_bulk
  25      1.11%  fio      fio                 [.] fio_gettime
  26      1.01%  fio      [kernel.vmlinux]    [k] _raw_spin_lock
  27      0.90%  fio      [ext4]              [k] ext4_mpage_readpages
  28      0.89%  fio      [vdso]              [.] __vdso_clock_gettime
  29      0.82%  fio      [kernel.vmlinux]    [k] 
audit_filter_syscall.constprop.20
  30      0.74%  fio      [kernel.vmlinux]    [k] xas_store
  31      0.73%  fio      [kernel.vmlinux]    [k] find_get_entries
  32      0.72%  fio      [kernel.vmlinux]    [k] find_get_entry
  33      0.70%  fio      fio                 [.] io_u_queued_complete
  34      0.66%  fio      [kernel.vmlinux]    [k] release_pages
  35      0.66%  fio      [kernel.vmlinux]    [k] io_submit_sqes
  ...

(4)
   9 # Overhead  Command  Shared Object       Symbol
  10 # ........  .......  .................. 
..............................................
  11 #
  12     12.30%  fio      fio                 [.] clock_thread_fn
  13      4.69%  fio      [kernel.vmlinux]    [k] xas_load
  14      3.12%  fio      [kernel.vmlinux]    [k] clear_page_erms
  15      2.87%  fio      libc-2.24.so        [.] __memset_avx2_erms
  16      2.80%  fio      [kernel.vmlinux]    [k] io_prep_async_work
  17      2.43%  fio      [kernel.vmlinux]    [k] io_prep_rw
  18      2.32%  fio      [kernel.vmlinux]    [k] shmem_getpage_gfp
  19      2.24%  fio      [kernel.vmlinux]    [k] __fget_files
  20      2.18%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
  21      2.15%  fio      [kernel.vmlinux]    [k] __list_del_entry_valid
  22      2.10%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irqsave
  23      1.81%  fio      [kernel.vmlinux]    [k] 
native_queued_spin_lock_slowpath
  24      1.77%  fio      [kernel.vmlinux]    [k] lru_cache_add
  25      1.69%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irq
  26      1.65%  fio      [kernel.vmlinux]    [k] free_pcppages_bulk
  27      1.36%  fio      [kernel.vmlinux]    [k] __pagevec_lru_add_fn
  28      1.27%  fio      fio                 [.] get_io_u
  29      1.26%  fio      [kernel.vmlinux]    [k] generic_file_buffered_read
  30      1.21%  fio      [kernel.vmlinux]    [k] io_submit_sqes
  31      1.19%  fio      fio                 [.] account_io_completion
  32      1.16%  fio      [vdso]              [.] __vdso_clock_gettime
  33      1.14%  fio      fio                 [.] fio_gettime
  34      1.12%  fio      [kernel.vmlinux]    [k] allocate_slab
  35      0.97%  fio      [kernel.vmlinux]    [k] __x64_sys_io_uring_enter
  ...

the arguments of fio I use are:
fio_test.sh:
fio -filename=/mnt/nvme0n1/haul.xh/fio_read_test.txt \
     -buffered=1 \
     -iodepth $1 \
     -rw=randread \
     -ioengine=io_uring \
     -direct=0 \
     -bs=4k \
     -size=4G \
     -name=rand_read_4k \
     -numjobs=1

Thanks && Regards,
Hao
