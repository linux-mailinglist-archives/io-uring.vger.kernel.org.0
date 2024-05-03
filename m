Return-Path: <io-uring+bounces-1711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DD68BB306
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 20:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD12B1F22055
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 18:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0672A158864;
	Fri,  3 May 2024 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M9aS+qkc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4C015821F
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760795; cv=none; b=WFUAcpwyLmcjI4wH2+43duL5GmjN7My4aBe577lw8CTwQCmhKZSVWubEqsnhZar2lo7aYVCFpGukGb5yXB6vkRdI5IjL1U6tKxJS0ARBtJL32rzkE94I5hx9T3l8QunwpEgMuY/tzpqZxYIgTiU3gWiYZKs2QL+Nwdh4Kr5ID7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760795; c=relaxed/simple;
	bh=Wuw0XjND+rfJBPzq21zocszfotHkDyVdJzVpWm3AfNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8TNv+04J0ZHoj2vkzl2RHGazEa7qgN5dsXTOhT/dLXsXasHFGfGbGAMtc5uvWmbQ8cyiBtLcBN6UFZ2vgPLj0+/Rlk9TsCugx5crzeDjLPU9UExPGyuSO+Dq382+so3K9Yrg5flZBiFuCHbKunmvenmm5Gt3A71p7yY/y2mfvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=M9aS+qkc; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f4521ad6c0so27021b3a.0
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 11:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714760793; x=1715365593; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jqBoL43PMGyCqFXn3ehXdH+uWie7AbSm2FUzxDYORqI=;
        b=M9aS+qkcreF0Yq+Via4wsh9ECoELo5LsqMdjIkxYRdFFs3834dJmEBcqVBDy3YC9dA
         9Cl0NMBRX/qO+kAXJw4gI8IGiM20H3aVk7DKvhzAnRHjyEBGDpz5RqbhVzuTUJ3emQAM
         sTrp36RbAklquQmS/09Glw8lYjzH2a7p3P/Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714760793; x=1715365593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqBoL43PMGyCqFXn3ehXdH+uWie7AbSm2FUzxDYORqI=;
        b=uD8kyVCYvcbz76sL3wZbJtRmU8waa267CF6s67la94zC3r7urdT4ZJS83B8T4RE4i3
         ujJRRADr6cOmhJOX9tP68dfW21M1qFWmz1aMBLZf/mvsJY+2nb/H9SLMmAXYvmSQ6LSq
         nAXB3B9gAUhz5hEMkQPNVOMAbzsuInHkELFxCGAL0Jyi2ymBVpwMVmeC3bkPP2Uzqyp7
         YZZtdeaEVbkSLPl4p9W/SmNO2V2jQTc1atgmopB7xDmP2p2UHIKLXzZKJk9wgzCOy8AI
         NHi7iOH0qZhbmTN54r+CAS5ybDCQmdLWcSAmRR3d7q6+/P8fmcYsKyMQgNhKcXv3PyAx
         6rTA==
X-Forwarded-Encrypted: i=1; AJvYcCVhDGK2zW/dXnrrlRVTnZ4K5hRhXI4W/RIeeWHrswaVIbDX+kqacW1VwYrkPQhLasUSW8VJPBxS/ckC+ABxB3iLcpEJzAlcBf8=
X-Gm-Message-State: AOJu0YxNPKeCmVaAARb50opfJRaEGJriI+q2giaQpkkrPJzk7hmjtXHA
	hLJ+5krPdITb2iUhpRuUrg1BY0nZYba/SY8Wk9uk2kVnjCNGQeea2PFEvzUU1w==
X-Google-Smtp-Source: AGHT+IGWOc/11Q1zIvnXaqaqAVGNo4zxAI/bv3cFFxYSIO/ngCUn47liMIMHwFEFiX6Gt/zTa/ffcw==
X-Received: by 2002:a05:6a00:3d06:b0:6e7:20a7:9fc0 with SMTP id lo6-20020a056a003d0600b006e720a79fc0mr3768000pfb.34.1714760793183;
        Fri, 03 May 2024 11:26:33 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id gp9-20020a056a003b8900b006ea8cc9250bsm3361952pfb.44.2024.05.03.11.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 11:26:32 -0700 (PDT)
Date: Fri, 3 May 2024 11:26:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Bui Quang Minh <minhquangbui99@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	axboe@kernel.dk, brauner@kernel.org, io-uring@vger.kernel.org,
	jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Subject: get_file() unsafe under epoll (was Re: [syzbot] [fs?] [io-uring?]
 general protection fault in __ep_remove)
Message-ID: <202405031110.6F47982593@keescook>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>

On Fri, May 03, 2024 at 06:54:22PM +0700, Bui Quang Minh wrote:
> [...]
> Root cause:
> AFAIK, eventpoll (epoll) does not increase the registered file's reference.
> To ensure the safety, when the registered file is deallocated in __fput,
> eventpoll_release is called to unregister the file from epoll. When calling
> poll on epoll, epoll will loop through registered files and call vfs_poll on
> these files. In the file's poll, file is guaranteed to be alive, however, as
> epoll does not increase the registered file's reference, the file may be
> dying
> and it's not safe the get the file for later use. And dma_buf_poll violates
> this. In the dma_buf_poll, it tries to get_file to use in the callback. This
> leads to a race where the dmabuf->file can be fput twice.
> 
> Here is the race occurs in the above proof-of-concept
> 
> close(dmabuf->file)
> __fput_sync (f_count == 1, last ref)
> f_count-- (f_count == 0 now)
> __fput
>                                     epoll_wait
>                                     vfs_poll(dmabuf->file)
>                                     get_file(dmabuf->file)(f_count == 1)
> eventpoll_release
> dmabuf->file deallocation
>                                     fput(dmabuf->file) (f_count == 1)
>                                     f_count--
>                                     dmabuf->file deallocation
> 
> I am not familiar with the dma_buf so I don't know the proper fix for the
> issue. About the rule that don't get the file for later use in poll callback
> of
> file, I wonder if it is there when only select/poll exist or just after
> epoll
> appears.
> 
> I hope the analysis helps us to fix the issue.

Thanks for doing this analysis! I suspect at least a start of a fix
would be this:

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 8fe5aa67b167..15e8f74ee0f2 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -267,9 +267,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 
 		if (events & EPOLLOUT) {
 			/* Paired with fput in dma_buf_poll_cb */
-			get_file(dmabuf->file);
-
-			if (!dma_buf_poll_add_cb(resv, true, dcb))
+			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
+			    !dma_buf_poll_add_cb(resv, true, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
 			else
@@ -290,9 +289,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 
 		if (events & EPOLLIN) {
 			/* Paired with fput in dma_buf_poll_cb */
-			get_file(dmabuf->file);
-
-			if (!dma_buf_poll_add_cb(resv, false, dcb))
+			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
+			    !dma_buf_poll_add_cb(resv, false, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
 			else


But this ends up leaving "active" non-zero, and at close time it runs
into:

        BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);

But the bottom line is that get_file() is unsafe to use in some places,
one of which appears to be in the poll handler. There are maybe some
other fragile places too, like in drivers/gpu/drm/vmwgfx/ttm_object.c:

static bool __must_check get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
{
	return atomic_long_inc_not_zero(&dmabuf->file->f_count) != 0L;
}

Which I also note involves a dmabuf...

Due to this issue I've proposed fixing get_file() to detect pathological states:
https://lore.kernel.org/lkml/20240502222252.work.690-kees@kernel.org/

But that has run into some push-back. I'm hoping that seeing this epoll
example will help illustrate what needs fixing a little better.

I think the best current proposal is to just WARN sooner instead of a
full refcount_t implementation:


diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8dfd53b52744..e09107d0a3d6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1040,7 +1040,8 @@ struct file_handle {
 
 static inline struct file *get_file(struct file *f)
 {
-	atomic_long_inc(&f->f_count);
+	long prior = atomic_long_fetch_inc_relaxed(&f->f_count);
+	WARN_ONCE(!prior, "struct file::f_count incremented from zero; use-after-free condition present!\n");
 	return f;
 }
 


What's the right way to deal with the dmabuf situation? (And I suspect
it applies to get_dma_buf_unless_doomed() as well...)

-Kees

-- 
Kees Cook

