Return-Path: <io-uring+bounces-9580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD1EB44C3C
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 05:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D00065868F1
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 03:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FB322172D;
	Fri,  5 Sep 2025 03:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8K8tsqE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8520C463;
	Fri,  5 Sep 2025 03:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757042736; cv=none; b=c0CwBwRifVyUYMFmYaJgCwlOEzY7zAzBAdOIHNB7xZhcD8Enhzn9CdADA0Fbzi3w7GMrIe6m32QT9UaF5xlD2GDR0nvigDUytZBM9iqya1EMv8E3J+wuXVeGauUnZzDyPLqx+S6qvJD2y3vsHOcOCcgsL7hsA6E+pE82uHQUZ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757042736; c=relaxed/simple;
	bh=YtZuuCz3KVJBwFv6l9cX99QAi+jK7Txov/fJu31Gjgo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=QHPtfyrbGOCLBZszSbB4akmrLS74WSIuHoo1yIfdAKJDzMuRDL7se4fYPLVoLvbsuKs58WXHlVwNUamV4N72Lu5sWrOI1FBAUdd+DwhDsobWvCzPUQ0BUz8pM1X1sBm17RxIpG+YIpAgf/WHYi4m8W++dzYAE1VQvQehZLp96A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8K8tsqE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCDCC4CEF1;
	Fri,  5 Sep 2025 03:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757042736;
	bh=YtZuuCz3KVJBwFv6l9cX99QAi+jK7Txov/fJu31Gjgo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q8K8tsqEZ9AFKuWCPYq/WXdRmiRWPaHOrzWJjVZ5DOe+YnwmjvZQKv6uQScJ5lsNI
	 x0bcgdKAD5GZ9N64NJAF+gNsfbDRDE9EHoxHEC+Uv3uLgiGsfxK1HPH5/iDo0/nIY4
	 ga8QNpEPEkYIH9O72D6X046mUk+sEOwNme2yJ1dc=
Date: Thu, 4 Sep 2025 20:25:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, David Hildenbrand <david@redhat.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in
 io_sqe_buffer_register
Message-Id: <20250904202535.fff5bea806408171d349a7f1@linux-foundation.org>
In-Reply-To: <54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
References: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
	<54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Sep 2025 17:20:41 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> > ==================================================================
> 
> This is from the mm-unstable changes in linux-next, adding David as I
> ran a quick bisect and it said:
> 
> da6b34293ff8dbb78f8b9278c9a492925bbf1f87 is the first bad commit
> commit da6b34293ff8dbb78f8b9278c9a492925bbf1f87
> Author: David Hildenbrand <david@redhat.com>
> Date:   Mon Sep 1 17:03:40 2025 +0200
> 
>     mm/gup: remove record_subpages()
>     
>     We can just cleanup the code by calculating the #refs earlier, so we can
>     just inline what remains of record_subpages().
>     
>     Calculate the number of references/pages ahead of times, and record them
>     only once all our tests passed.
>     
>     Link: https://lkml.kernel.org/r/20250901150359.867252-20-david@redhat.com
>     Signed-off-by: David Hildenbrand <david@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> I won't personally have time to look into this until after the weekend,
> but as it's linux-next specific, not a huge deal right now.
> 
> Note that there's also a similar report, which is the same thing:
> 
> https://lore.kernel.org/all/68b9d130.a00a0220.eb3d.0008.GAE@google.com/
> 
> which I marked as dupe of this one.

Thanks.  Seems i can remove that patch without causing merge or build
damage, so I'll do that.


