Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F6D15F603
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389142AbgBNSpU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 13:45:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37570 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbgBNSpU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 13:45:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so5300139pfn.4;
        Fri, 14 Feb 2020 10:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P72Mc2Tbo5N+z/hNONsT1busT/cguqnoD07kdOiSU4Y=;
        b=OKmpY2Z4L2rjfJdeyoY2mLDp66uND3A4BZdQbIvFyyVt/IqvyVBgQiPwbiop0UWcaJ
         ogFDTLgp0Hi/HF0OdHe1EsKZceuwXIbj+tn+O8AWYihZa2YQc5IrmVlVV4WTjJX+ceik
         ltgWjOOSM+ofHOP7VF1gPpazumckPW4G4YZ5OMQcEfvyrwJsj04zNV4Powi2qVVwYLAC
         z2vQtpYzR7irLCnfq4b7m1L9FwDAkIR9PzBlAOnIVDrv0tCXJkctx+MNcw4BgrtGVA+K
         N8guGA8lEQCagAEd/0zJHU3XhX9SVn7xDjacC5M84HaA1Yacid94ieduOcsaqiw/VEpD
         +wkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=P72Mc2Tbo5N+z/hNONsT1busT/cguqnoD07kdOiSU4Y=;
        b=HAlENXA6lJkV8FmtzJJIQ4ORmch2UNBW/gPMfHBoi0p8ZWmcdXLxxOqN0/JdlkH90l
         4HVXsFUEexx0c3qgdnZUDVg7s8AyMegDXXKaLJBgBkWUZdgd6+trV5VT+RR47NrGNEmn
         QeUSNEV7ENnr/EjrZQvrsfwAEWZZnEQjP6ioXr8WqgOXLLwjcQeFn+uK/s1X15Hesbnz
         lrlEqBvN6G8yho/MpAcYaJ2arS0AhwJoSePcZTVEaY6LTb0VWiEo/aAPmpfCEOKi1wXV
         i7xrShw+XzMlnTMofPAges6RaiGkA1Zy5FNzQ/WVqi83+7tXK0WynRBNriiDzYGGlfCp
         XZwA==
X-Gm-Message-State: APjAAAWRI1RJX1Zm1pV2Om+lyW58Nyn3+V/0VgacQUudl4t2BVcb5F/d
        pzLq/raMPYbNCTyDPBh5H2M=
X-Google-Smtp-Source: APXvYqyJETVPOYfUg1bqp/0tBYMnZsG4t8DHPWa+u3/wHsATdeZN64V0ywPAmpBENtgfDpv4c/CTPw==
X-Received: by 2002:a63:8743:: with SMTP id i64mr4793928pge.243.1581705917567;
        Fri, 14 Feb 2020 10:45:17 -0800 (PST)
Received: from google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id r14sm7569203pfh.10.2020.02.14.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 10:45:16 -0800 (PST)
Date:   Fri, 14 Feb 2020 10:45:14 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, sj38.park@gmail.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v5 1/7] mm: pass task and mm to do_madvise
Message-ID: <20200214184514.GA165785@google.com>
References: <20200214170520.160271-1-minchan@kernel.org>
 <20200214170520.160271-2-minchan@kernel.org>
 <CAG48ez3S5+EasZ1ZWcMQYZQQ5zJOBtY-_C7oz6DMfG4Gcyig1g@mail.gmail.com>
 <68044a15-6a31-e432-3105-f2f1af9f4b74@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68044a15-6a31-e432-3105-f2f1af9f4b74@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 14, 2020 at 11:22:08AM -0700, Jens Axboe wrote:
> On 2/14/20 10:25 AM, Jann Horn wrote:
> > +Jens and io-uring list
> > 
> > On Fri, Feb 14, 2020 at 6:06 PM Minchan Kim <minchan@kernel.org> wrote:
> >> In upcoming patches, do_madvise will be called from external process
> >> context so we shouldn't asssume "current" is always hinted process's
> >> task_struct.
> > [...]
> >> [1] http://lore.kernel.org/r/CAG48ez27=pwm5m_N_988xT1huO7g7h6arTQL44zev6TD-h-7Tg@mail.gmail.com
> > [...]
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> > [...]
> >> @@ -2736,7 +2736,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
> >>         if (force_nonblock)
> >>                 return -EAGAIN;
> >>
> >> -       ret = do_madvise(ma->addr, ma->len, ma->advice);
> >> +       ret = do_madvise(current, current->mm, ma->addr, ma->len, ma->advice);
> >>         if (ret < 0)
> >>                 req_set_fail_links(req);
> >>         io_cqring_add_event(req, ret);
> > 
> > Jens, can you have a look at this change and the following patch
> > <https://lore.kernel.org/linux-mm/20200214170520.160271-4-minchan@kernel.org/>
> > ("[PATCH v5 3/7] mm: check fatal signal pending of target process")?
> > Basically Minchan's patch tries to plumb through the identity of the
> > target task so that if that task gets killed in the middle of the
> > operation, the (potentially long-running and costly) madvise operation
> > can be cancelled. Just passing in "current" instead (which in this
> > case is the uring worker thread AFAIK) doesn't really break anything,
> > other than making the optimization not work, but I wonder whether this
> > couldn't be done more cleanly - maybe by passing in NULL to mean "we
> > don't know who the target task is", since I think we don't know that
> > here?
> 
> Thanks for bringing this to my attention, patches that touch io_uring
> (or anything else) really should be CC'ed to the maintainer(s) of those
> areas...

Hi Jens, it was my mistake. Sorry for that.

> 
> Yeah, the change above won't do the right thing for io_uring, in fact
> it'll always be the wrong task. So I'd second Jann's question, and ask
> if we really need the actual task, or if NULL could be used? For
> cancelation purposes, I'm guessing you want the task that's actually
> doing the operation, even if it's on behalf of someone else. That makes
> the interface a bit weird, as you'd assume the task/mm passed in would
> be related to the madvise itself, not just for cancelation.
> 
> Would be nice with some clarification, so we can figure out an approach
> that would actually work.

MADV_(COLD|PAGEOUT) checks both caller and callee and the part aims for
callee(ie, target task). Thus, we could pass NULL for io_madvise if
it couldn't know who is target and let's have NULL check before the
fatal_signal_pending. I will put following checks in [3/7].

	if (private->target_Task &&
			fatal_signal_pending(private->target_task))
		return -EINTR;

From d008a5a1049b03b3e0eeef7121faead2b6555f49 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 14 Feb 2020 07:29:58 -0800
Subject: [PATCH] mm: pass task and mm to do_madvise

In upcoming patches, do_madvise will be called from external process
context so we shouldn't asssume "current" is always hinted process's
task_struct. Furthermore, we couldn't access mm_struct via task->mm
once it's verified by access_mm which will be introduced in next
patch[1]. And let's pass *current* and current->mm as arguments of
do_madvise so it shouldn't change existing behavior but prepare
next patch to make review easy.

Note: io_madvise pass NULL as target_tas argument of do_madvise
because it couldn't know who is target.

[1] http://lore.kernel.org/r/CAG48ez27=pwm5m_N_988xT1huO7g7h6arTQL44zev6TD-h-7Tg@mail.gmail.com

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/io_uring.c      |  2 +-
 include/linux/mm.h |  3 ++-
 mm/madvise.c       | 34 +++++++++++++++++++---------------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63beda9bafc5..1c7e9cd6c8ce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2736,7 +2736,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (force_nonblock)
 		return -EAGAIN;
 
-	ret = do_madvise(ma->addr, ma->len, ma->advice);
+	ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 52269e56c514..beb9259f9ed1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2323,7 +2323,8 @@ extern int __do_munmap(struct mm_struct *, unsigned long, size_t,
 		       struct list_head *uf, bool downgrade);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
 		     struct list_head *uf);
-extern int do_madvise(unsigned long start, size_t len_in, int behavior);
+extern int do_madvise(struct task_struct *task, struct mm_struct *mm,
+		unsigned long start, size_t len_in, int behavior);
 
 static inline unsigned long
 do_mmap_pgoff(struct file *file, unsigned long addr,
diff --git a/mm/madvise.c b/mm/madvise.c
index 43b47d3fae02..f75c86b6c463 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -254,6 +254,7 @@ static long madvise_willneed(struct vm_area_struct *vma,
 			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	loff_t offset;
 
@@ -288,12 +289,12 @@ static long madvise_willneed(struct vm_area_struct *vma,
 	 */
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 	get_file(file);
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
 	fput(file);
-	down_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	return 0;
 }
 
@@ -676,7 +677,6 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	if (nr_swap) {
 		if (current->mm == mm)
 			sync_mm_rss(mm);
-
 		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
 	}
 	arch_leave_lazy_mmu_mode();
@@ -756,6 +756,8 @@ static long madvise_dontneed_free(struct vm_area_struct *vma,
 				  unsigned long start, unsigned long end,
 				  int behavior)
 {
+	struct mm_struct *mm = vma->vm_mm;
+
 	*prev = vma;
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
@@ -763,8 +765,8 @@ static long madvise_dontneed_free(struct vm_area_struct *vma,
 	if (!userfaultfd_remove(vma, start, end)) {
 		*prev = NULL; /* mmap_sem has been dropped, prev is stale */
 
-		down_read(&current->mm->mmap_sem);
-		vma = find_vma(current->mm, start);
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, start);
 		if (!vma)
 			return -ENOMEM;
 		if (start < vma->vm_start) {
@@ -818,6 +820,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 	loff_t offset;
 	int error;
 	struct file *f;
+	struct mm_struct *mm = vma->vm_mm;
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
@@ -845,13 +848,13 @@ static long madvise_remove(struct vm_area_struct *vma,
 	get_file(f);
 	if (userfaultfd_remove(vma, start, end)) {
 		/* mmap_sem was not released by userfaultfd_remove() */
-		up_read(&current->mm->mmap_sem);
+		up_read(&mm->mmap_sem);
 	}
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				offset, end - start);
 	fput(f);
-	down_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	return error;
 }
 
@@ -1044,7 +1047,8 @@ madvise_behavior_valid(int behavior)
  *  -EBADF  - map exists, but area maps something that isn't a file.
  *  -EAGAIN - a kernel resource was temporarily unavailable.
  */
-int do_madvise(unsigned long start, size_t len_in, int behavior)
+int do_madvise(struct task_struct *target_task, struct mm_struct *mm,
+		unsigned long start, size_t len_in, int behavior)
 {
 	unsigned long end, tmp;
 	struct vm_area_struct *vma, *prev;
@@ -1082,10 +1086,10 @@ int do_madvise(unsigned long start, size_t len_in, int behavior)
 
 	write = madvise_need_mmap_write(behavior);
 	if (write) {
-		if (down_write_killable(&current->mm->mmap_sem))
+		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
 	} else {
-		down_read(&current->mm->mmap_sem);
+		down_read(&mm->mmap_sem);
 	}
 
 	/*
@@ -1093,7 +1097,7 @@ int do_madvise(unsigned long start, size_t len_in, int behavior)
 	 * ranges, just ignore them, but return -ENOMEM at the end.
 	 * - different from the way of handling in mlock etc.
 	 */
-	vma = find_vma_prev(current->mm, start, &prev);
+	vma = find_vma_prev(mm, start, &prev);
 	if (vma && start > vma->vm_start)
 		prev = vma;
 
@@ -1130,19 +1134,19 @@ int do_madvise(unsigned long start, size_t len_in, int behavior)
 		if (prev)
 			vma = prev->vm_next;
 		else	/* madvise_remove dropped mmap_sem */
-			vma = find_vma(current->mm, start);
+			vma = find_vma(mm, start);
 	}
 out:
 	blk_finish_plug(&plug);
 	if (write)
-		up_write(&current->mm->mmap_sem);
+		up_write(&mm->mmap_sem);
 	else
-		up_read(&current->mm->mmap_sem);
+		up_read(&mm->mmap_sem);
 
 	return error;
 }
 
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
-	return do_madvise(start, len_in, behavior);
+	return do_madvise(current, current->mm, start, len_in, behavior);
 }
-- 
2.25.0.265.gbab2e86ba0-goog
