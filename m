Return-Path: <io-uring+bounces-8648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFFAB02363
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 20:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B65654A0128
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 18:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DF52F1FEC;
	Fri, 11 Jul 2025 18:12:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from gw.shic.co.uk (gw.shic.co.uk [94.23.159.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395DD2EF656
	for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.23.159.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752257577; cv=none; b=qi/ZrX3aoqDnKsMnBvXNpYWAITK8lfWvSuqugjtSUkJKZWPXO7Gvt5HgkAJmeDQjbw6SuNlxEbjXCnQcv879kEFDJG7+4ZXGHMH/944FGB3+R/lyqucfKS8uVPjSCQqLY10crhOcMQnl6oHiSetY6vDND7ZDoKUhN7ddJHvYnCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752257577; c=relaxed/simple;
	bh=/ImE8cm7Bz2eXTHVDEt+THBs3B+giqwF+GbXqCnMccw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=YbSaBWcdQP6gMr0IWHwUC32X0qA7jfYOHTGPy39wSPvRBE22OhOstR95Xj3zwyGG1d6gV3X/M0p11v1a5ewV4ula8RkdDJRh8kgPkxFU2FF4rfg6uyFDznrIZu7Sv3CQo/YJoIyR/Z0HsdW6CaPZ932lSs/sFBJHrwH02KE+A4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shic.co.uk; spf=pass smtp.mailfrom=shic.co.uk; arc=none smtp.client-ip=94.23.159.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shic.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shic.co.uk
Received: from localhost (localhost [127.0.0.1])
	by gw.shic.co.uk (Postfix) with ESMTP id C8FCD16C0159
	for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 19:12:52 +0100 (BST)
X-Virus-Scanned: Debian amavisd-new at shic.co.uk
Received: from gw.shic.co.uk ([192.168.42.2])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ItVdG4f3gotW for <io-uring@vger.kernel.org>;
	Fri, 11 Jul 2025 19:12:48 +0100 (BST)
Received: from [192.168.64.2] (han-router.han-router.shic.co.uk [192.168.33.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by gw.shic.co.uk (Postfix) with ESMTPSA id 1B88216C011D
	for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 19:12:48 +0100 (BST)
Message-ID: <a11e741c-458f-4343-8f68-28ecc151cb34@shic.co.uk>
Date: Fri, 11 Jul 2025 19:12:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Steve <steve_iouring_list@shic.co.uk>
Subject: Relationship between io-uring asynchronous idioms and mmap/LRU
 paging.
Content-Language: en-GB
To: io-uring@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I hope my post is appropriate for this list. Relative to other recent 
posts on this list, my interests are high-level.

I want to develop efficient, scalable, low-latency, asynchronous 
services in user-space. I've dabbled with liburing in the context of an 
experimental service involving network request/responses.  For the 
purpose of this post, assume calculating responses, to requests, 
requires looking-up pages in a huge read-only file.  In order to reap 
all the performance benefits of io-uring, I know I should avoid blocking 
calls in my event loop.

If I were to use a multithreaded (c.f. asynchronous) paradigm... my 
strategy, to look-up pages, would have been to mmap 
<https://man7.org/linux/man-pages/man2/mmap.2.html> the huge file and 
rely upon the kernel LRU cache. Cache misses, relative to the memory 
mapped file will result in a page fault and a blocked thread. This could 
be OK, if cache-misses are rare events... but, while cache hits are 
expected to be frequent, I can't assume cache misses will be rare.

Options I have considered:

   1. Introduce a thread-pool, with task-request and task-response 
queues... using tasks to de-couple reading requests from writing 
responses... the strategy would be to avoid the io-uring event loop 
thread interacting with the memory mapped file. Intuitively, this seems 
cumbersome - compared with using a 'more asynchronous' idiom to avoid 
having to depend upon multithreaded concurrency and thread synchronisation.

   2. Implement an explicit application-layer page cache. Pages could be 
retrieved, into explicitly allocated memory, asynchronously... using 
io-uring read requests. I could suspend request/response processing on 
any cache miss... then resume processing when the io-uring completion 
queue informs that each page has been loaded.  A C++20 coroutine, for 
example, could allow this asynchronous suspension and resumption of 
calculation of responses to requests. This approach seems to undermine 
resource-use cooperation between processes. A single page on disk could 
end-up cached separately by each process instance (inefficient) and 
there would be difficulties efficiently managing appropriate sizes for 
application layer caches.

In an ideal world, I would like to fuse the benefits of mmap's 
kernel-managed cache, with the advantages of an io-uring asynchronous 
idiom.  I find myself wishing there were kernel-level APIs to:

   * Determine if a page, at a virtual address, is already cached in 
RAM. [ Perhaps mincore() 
<https://man7.org/linux/man-pages/man2/mincore.2.html> could be adequate? ]
   * Submit an asynchronous io-uring request with comparable (but 
non-blocking) effect to a page-fault for the virtual address whose page 
was not in core.
   * Receive notification, on the io-uring completion queue, that an 
requested page has now been cached.

If such facilities were to exist, I can imagine a process, using 
io-uring asynchronous idioms, that retains the memory management 
advantages associated with mmap... without introducing dependence upon 
threads.  I've not found any documentation to suggest that my imagined 
io-uring features exist.  Am I overlooking something? Are there plans to 
implement asynchronous features involving the kernel page-cache and 
io-uring scheduling?  Would io-uring experts consider option 1 a 
sensible, pragmatic, choice... in a circumstance where kernel-level 
caching of the mapped file seems desirable... or would a different 
approach be more appropriate?

Thanks in advance for any comments.

Steve



