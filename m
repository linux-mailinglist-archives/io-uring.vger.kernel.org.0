Return-Path: <io-uring+bounces-5869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33228A11989
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 07:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C22218861AF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 06:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0881022F175;
	Wed, 15 Jan 2025 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxHHGFKn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA4F1F9F5C;
	Wed, 15 Jan 2025 06:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736921953; cv=none; b=cdbOtkg3rnAGXc0zdkOjc3fbPLKYWPNwRLO0LATzA83xPwYlhwXl8YcdnJA9XC3g3oUWBF+QZM/m3YwtukZm+SHsAJvDSCr/6SGZHLHQuxtiYktYkzFLPb/1axL9ZiPxTpSzO9nnDCMQ2SfhoUxMQ9AG2x4ZMdRAV/hzGh2B1v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736921953; c=relaxed/simple;
	bh=xPfKkMWgx5qIRi97DeQ/SvkD1AWZgJlDQc7lklyto6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k6iBR+2KzxvRAgvq5wmooCocJE+Kd+4pEo5RlVz0WBc7azyDfVQ1IofrpmKAv80RqfXZMs4Zwv+8AIo41QISdcnoLZxdahmon7q5bBlBLyyTUzNNwDZQ2hZ2rvSFBC5iipW/BS9Dhan8mSxvbBfLmTqkErjS11Te20eVJvpJcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxHHGFKn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2472CC4CEE1;
	Wed, 15 Jan 2025 06:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736921953;
	bh=xPfKkMWgx5qIRi97DeQ/SvkD1AWZgJlDQc7lklyto6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxHHGFKnvjMQiiLrPU8h7trzS1ZSStbmsBPHnLXveVg0hGsj2Nus6RhFsIdofw2Y1
	 DCaB7M+gA5gWz7tYi0adr9fLRugGCd18LjhBHrWpQuSt+MwOkg4iJZvR8tJyJdiCAW
	 knlbCo7Q3muot6CL6Ka18Ch6KlxGgk4td6SfY9AsNK5gMZlHNe1ybf2d5R8uY3VwwE
	 1JpC7BC19Xn6zdzBy3lFlrVpKnuPbKGVOihycCRPbMMf7VCy6C7LE+uzw9JDY00iDF
	 t7ba3yPUIEiQtoXAqMoYwoghy/FivpU/vcdcQw7RUu6HsGt18T254ml3wO8fj8SS1O
	 jSfMx/9nQvdRA==
From: SeongJae Park <sj@kernel.org>
To: Honggyu Kim <honggyu.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>,
	kernel_team@skhynix.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	damon@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations from process_madvise()
Date: Tue, 14 Jan 2025 22:19:10 -0800
Message-Id: <20250115061910.58938-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <00242654-5e98-4489-ae6d-f4dd01bfdaa7@sk.com>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Honggyu,

On Wed, 15 Jan 2025 13:35:48 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:

> Hi SeongJae,
> 
> I have a simple comment on this.
> 
> On 1/11/2025 9:46 AM, SeongJae Park wrote:
> > process_madvise() calls do_madvise() for each address range.  Then, each
> > do_madvise() invocation holds and releases same mmap_lock.  Optimize the
> > redundant lock operations by doing the locking in process_madvise(), and
> > inform do_madvise() that the lock is already held and therefore can be
> > skipped.
[...]
> > ---
> >   include/linux/mm.h |  3 ++-
> >   io_uring/advise.c  |  2 +-
> >   mm/damon/vaddr.c   |  2 +-
> >   mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
> >   4 files changed, 45 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 612b513ebfbd..e3ca5967ebd4 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >   		    unsigned long end, struct list_head *uf, bool unlock);
> >   extern int do_munmap(struct mm_struct *, unsigned long, size_t,
> >   		     struct list_head *uf);
> > -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
> > +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > +		int behavior, bool lock_held);
> >   
> >   #ifdef CONFIG_MMU
> >   extern int __mm_populate(unsigned long addr, unsigned long len,
> > diff --git a/io_uring/advise.c b/io_uring/advise.c
> > index cb7b881665e5..010b55d5a26e 100644
> > --- a/io_uring/advise.c
> > +++ b/io_uring/advise.c
> > @@ -56,7 +56,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
> >   
> >   	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> >   
> > -	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
> > +	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice, false);
> 
> I feel like this doesn't look good in terms of readability. Can we 
> introduce an enum for this?

I agree that's not good to read.  Liam alos pointed out a similar issue but
suggested splitting functions with clear names[1].  I think that also fairly
improves readability, and I slightly prefer that way, since it wouldn't
introduce a new type for only a single use case.  Would that also work for your
concern, or do you have a different opinion?

[1] https://lore.kernel.org/20250115041750.58164-1-sj@kernel.org


Thanks,
SJ

[...]

