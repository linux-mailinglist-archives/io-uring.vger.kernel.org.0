Return-Path: <io-uring+bounces-5867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA02A11848
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 05:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05CF17A39EA
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 04:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB029155725;
	Wed, 15 Jan 2025 04:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZb3M3pK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2F62746D;
	Wed, 15 Jan 2025 04:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736914675; cv=none; b=E+v7Wj0f/+aJIbN2O4slOkh/7vs3wy9Ax/ovWG2pCqvIhLRyOEnKb6KuwxWmJDsBCwfwdb02VR8mxMnm54OYMj+3ETA1ieC8RlqaOLJw58To8gPpMIkUHnju5HCeweAcuGYlbkwNY+R8qUdFFpjSEs4CTz2kLPoJrspVdD8urSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736914675; c=relaxed/simple;
	bh=VsGwP/4rOYom0WXxctWyeqgUSyZah+lbhg84YI+77p0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0et45753SOCRxLFQPlLar/kPVTuOTP+ciBF7TBvwCmFSabS9B9v6wpuSoUAK7VBbQ9ShKp3wD3AMlno0DDQ/U9C12co4+1NTTH+7gaT4rUTSBHCKPxosGRG1QN8fTUEOxk39Ahz7EAjP7SF0dmBJ8ZI0Rn0nGFWk3NSdTrhZO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZb3M3pK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD822C4CEDF;
	Wed, 15 Jan 2025 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736914675;
	bh=VsGwP/4rOYom0WXxctWyeqgUSyZah+lbhg84YI+77p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZb3M3pKw5po6kcZ1vOVbN662UprBLe/VB38YXQkzop5+7zCSP8PzF5ClSKYSCI1C
	 ws/eZiZPaH5jHopPNgxGoRDM6YBs1wWmm9kOS/Tx4RsygQhf33nIMrqi9QWy8YEIVL
	 9KzxRVkEmAviwOgNpmog68MQku9mI192z0GWnlJdvmWjZMQuHLoxhLGZ9hyoDacaUF
	 rKN45KIHzYEMwVepGQNTlAOFyblcXHyoxIc9efnE/mXfhXWTN9q8yXt6+yuwb48p4k
	 CifQbTeeMff2GyTsOmYpU5dt5X+O4RiRyfuba3xVzUO6KmZZURN7NTfA/SvIGRJ27K
	 ThSUkVLUbsVSA==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	damon@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations from process_madvise()
Date: Tue, 14 Jan 2025 20:17:50 -0800
Message-Id: <20250115041750.58164-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <vwyuhra3bjcnwxsmenngsingp5gi2xqrazej5eescnuyz332q5@jc5u34qg4umc>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 14 Jan 2025 22:44:53 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * Shakeel Butt <shakeel.butt@linux.dev> [250114 13:14]:
> > Ccing relevant folks.
> 
> Thanks Shakeel.
> 
> > 
> > On Fri, Jan 10, 2025 at 04:46:18PM -0800, SeongJae Park wrote:
> > > process_madvise() calls do_madvise() for each address range.  Then, each
> > > do_madvise() invocation holds and releases same mmap_lock.  Optimize the
> > > redundant lock operations by doing the locking in process_madvise(), and
> > > inform do_madvise() that the lock is already held and therefore can be
> > > skipped.
> > > 
> > > Evaluation
> > > ==========
> > > 
> > > I measured the time to apply MADV_DONTNEED advice to 256 MiB memory
> > > using multiple madvise() calls, 4 KiB per each call.  I also do the same
> > > with process_madvise(), but with varying iovec size from 1 to 1024.
> > > The source code for the measurement is available at GitHub[1].
> > > 
> > > The measurement results are as below.  'sz_batches' column shows the
> > > iovec size of process_madvise() calls.  '0' is for madvise() calls case.
> > > 'before' and 'after' columns are the measured time to apply
> > > MADV_DONTNEED to the 256 MiB memory buffer in nanoseconds, on kernels
> > > that built without and with this patch, respectively.  So lower value
> > > means better efficiency.  'after/before' column is the ratio of 'after'
> > > to 'before'.
> > > 
> > >     sz_batches  before     after      after/before
> > >     0           124062365  96670188   0.779206393494111
> > >     1           136341258  113915688  0.835518827323714
> > >     2           105314942  78898211   0.749164453796119
> > >     4           82012858   59778998   0.728897875989153
> > >     8           82562651   51003069   0.617749895167489
> > >     16          71474930   47575960   0.665631431888076
> > >     32          71391211   42902076   0.600943385033768
> > >     64          68225932   41337835   0.605896230190011
> > >     128         71053578   42467240   0.597679120395598
> > >     256         85094126   41630463   0.489228398679364
> > >     512         68531628   44049763   0.6427654542221
> > >     1024        79338892   43370866   0.546653285755491
> > > 
> > > The measurement shows this patch reduces the process_madvise() latency,
> > > proportional to the batching size, from about 25% with the batch size 2
> > > to about 55% with the batch size 1,024.  The trend is somewhat we can
> > > expect.
> > > 
> > > Interestingly, this patch has also optimize madvise() and single batch
> > > size process_madvise(), though.  I ran this test multiple times, but the
> > > results are consistent.  I'm still investigating if there are something
> > > I'm missing.  But I believe the investigation may not necessarily be a
> > > blocker of this RFC, so just posting this.  I will add updates of the
> > > madvise() and single batch size process_madvise() investigation later.
> > > 
> > > [1] https://github.com/sjp38/eval_proc_madvise
> > > 
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> > > ---
> > >  include/linux/mm.h |  3 ++-
> > >  io_uring/advise.c  |  2 +-
> > >  mm/damon/vaddr.c   |  2 +-
> > >  mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
> > >  4 files changed, 45 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 612b513ebfbd..e3ca5967ebd4 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
> > >  		    unsigned long end, struct list_head *uf, bool unlock);
> > >  extern int do_munmap(struct mm_struct *, unsigned long, size_t,
> > >  		     struct list_head *uf);
> > > -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
> > > +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > > +		int behavior, bool lock_held);
> 
> We are dropping externs when it is not needed as things are changed.

Good point.  I will drop it if I result in changing something here in next
versions.

> 
> Also, please don't use a flags for this.  It will have a single user of
> true, probably ever.

Ok, that sounds fair.

> 
> It might be better to break do_madvise up into more parts:
> 1. is_madvise_valid(), which does the checking.
> 2. madivse_do_behavior()
> 
> The locking type is already extracted to madivse_need_mmap_write().
> 
> What do you think?

Sounds good to me :)

I will make the v2 of this patch following your suggestion after waiting for
any possible more comments a bit.


Thanks,
SJ

[...]

