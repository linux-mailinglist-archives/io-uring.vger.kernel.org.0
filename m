Return-Path: <io-uring+bounces-1265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA3A88F01C
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 21:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86D23B25CAD
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572803A28B;
	Wed, 27 Mar 2024 20:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cOV6P5cZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73BB3DAC11
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571363; cv=none; b=hdTRXuqgH526cvDjRAg7BtOUQNX9hV4CV67pxTifZFpGDoZ4nSaHPiXnbuBCV6v82njEZ1jZah8TZRQrx4ZMCRPfxYFQ/50vSbcaYer4iUq/kQ94lUpv4qCmk7M/LfQ8phJrLCcBFKqkzIFDT0OlVDpx8bpHPEpbJoraLf7Ue8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571363; c=relaxed/simple;
	bh=ZLIsHWiO3sD6KloFXR7nOPVRxk5xlrMJ4Uc9OLIQq5Q=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=f57ds4+Jf2QDDJoNA1ETxH7H8KbYQMOtR4xLw/KgU42rJBpVLvbI/h4lcYlBTKwDL/HjaKL6z30NwWuDTy8bv+IDhamn3lOZCK33Lb4/c6kmubofLp8wXWLEFiXyOF9VFG1FlOxsBj3sqizU8IIHt7eVfdjYPTzUzQVFG75IYgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cOV6P5cZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711571358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jH5gStFyEK8jhWrJxWE0U1OyzabG4QTJ9PlypXOr5cY=;
	b=cOV6P5cZVzz7zRZ1tNAVFp7VqxdgbDnn1nIvc77LRcNNPRx3JAypUO7A2EiXMEbovjNHNz
	R6W4aVDJ0qmzdmGiq+NLvNnlFoylNHIdDz9A4gVzDZGFa2Nrr1wbyciB2cU5QvscVfb3R4
	ydRqzZL5EAg5noefOCmOkTgzi8pH4Rs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-o3BBSCPrPVi1BOY02ivTRA-1; Wed, 27 Mar 2024 16:29:17 -0400
X-MC-Unique: o3BBSCPrPVi1BOY02ivTRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB3228007A1;
	Wed, 27 Mar 2024 20:29:16 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.9.228])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FEB41C060D0;
	Wed, 27 Mar 2024 20:29:16 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 03/10] io_uring: use vmap() for ring mapping
References: <20240327191933.607220-1-axboe@kernel.dk>
	<20240327191933.607220-4-axboe@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 27 Mar 2024 16:29:15 -0400
In-Reply-To: <20240327191933.607220-4-axboe@kernel.dk> (Jens Axboe's message
	of "Wed, 27 Mar 2024 13:13:38 -0600")
Message-ID: <x49v8574dwk.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Jens Axboe <axboe@kernel.dk> writes:

> This is the last holdout which does odd page checking, convert it to
> vmap just like what is done for the non-mmap path.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 40 +++++++++-------------------------------
>  1 file changed, 9 insertions(+), 31 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 29d0c1764aab..67c93b290ed9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -63,7 +63,6 @@
>  #include <linux/sched/mm.h>
>  #include <linux/uaccess.h>
>  #include <linux/nospec.h>
> -#include <linux/highmem.h>
>  #include <linux/fsnotify.h>
>  #include <linux/fadvise.h>
>  #include <linux/task_work.h>
> @@ -2650,7 +2649,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>  	struct page **page_array;
>  	unsigned int nr_pages;
>  	void *page_addr;
> -	int ret, i, pinned;
> +	int ret, pinned;
>  
>  	*npages = 0;
>  
> @@ -2659,8 +2658,6 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>  
>  	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	if (nr_pages > USHRT_MAX)
> -		return ERR_PTR(-EINVAL);
> -	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
>  	if (!page_array)
>  		return ERR_PTR(-ENOMEM);

That's not right.  ;-)  It gets fixed up (removed) in the next patch.

-Jeff


