Return-Path: <io-uring+bounces-2000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6428F8D4E6C
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86EC11C2145A
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 14:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24425143C40;
	Thu, 30 May 2024 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QI6zsrEC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D3186E38
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717080699; cv=none; b=dUfIkVQ8p7Sr9zuE2PIyIWvcIwlD07rEpUzlhuqasmw2UgqYeYX5mNfqufP6yg7JerpW5xAcnF69dLTRveDYL7bUqm3druUwVM8wNWe1dD3lalJUotetnQ38M9SWmZ2x7qOyMlg3R/fJ1NDNIlDY5xb5uRkASRZ6Q/6ETEoVuWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717080699; c=relaxed/simple;
	bh=nhAdl/mjm0foBJdzB17DgyIYjponnam78bYXksNa7pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OE8CV6epty4W77peaUI/PXCL6OF2UuT/tO57z2UAC/CF4IhGXKeBKzsYqO+JW2SFpFbyEeXxrBBN6M6SE8P26FOFYFS/4bs0+0S5fLpZUYZI/W0GhwEJpCP19qY/XXOsg1V1Ntv3SC02IsF30C43pkO3azgapsVNHvCWg0v3f7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QI6zsrEC; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5b3364995b4so154752eaf.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 07:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717080696; x=1717685496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WYp5fgircLVzy+Cvy20cshUUYPB+ifdVkSzY1yjHuXM=;
        b=QI6zsrECiCG+G1POkyvprJVv4lTOotBtKJl1284OYpKmDI+BSEr176UHDSKsnGSR2P
         HOqrXSoaie4gLbLfw2tudGFmgW7d24WnBzrWz1wa2vZ77kuWIt6d3rgjhygWD8UjLbp4
         VIrHFwKLHEmJ5qlSmZQJBa0NqoGIYsXVUCpQlgx8PdF7MP4n049Qe30gup7EqhZdJKJb
         PUvseJoBlkhyjwCVcMpTvz8HOGVnzeuOgpKj3Asx+/mz7I1o+CkS6bn+2s/faBnNShqS
         r+GT0ewQnf5A+JXoFreEWzajkO6NILNkszPz+5kszGQZb8cvQHD1C+1+Q5twrrIPObAq
         biuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717080696; x=1717685496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WYp5fgircLVzy+Cvy20cshUUYPB+ifdVkSzY1yjHuXM=;
        b=Ez8FEdXiKURjSEb0yh1g5ZZNfX+z2mOngHQNMbNUhGvHY4xxq5N64vG1asEp86cTj1
         y7CuLtKRYZbyYN6bWN2BwM+Po/LB9klKzVDRSS5oCDV6QLjwITfOQVF8w39V8f1/Y3CJ
         4y1xTixWLIoBYHSESLME97PcZSnq0YlKCnt8SFBadgNYNbvoIww7tcNlfCfytgBTlBrX
         28wVX4ZA5XMYdRlVT1NNUQpqVD2/gZ/S+wTQVz1rGDgwqNDpdg/d2r8iBiEYJGuXP/Ng
         OjNMZClWP4+XytSbrRsZDRce5kE0H70q1CjAtMHns6ePH78Pm8rNEy5Hz/RIn3gmLUg+
         HIzA==
X-Forwarded-Encrypted: i=1; AJvYcCWxQECs7//mCqo2AfuPRxvQyA4F7ex1wSMDQvS6W8EddfpWIJNwY48cciMMsO6e1Z9LlvQ55fqQeZGQswIGw89Is+5U00AHU3o=
X-Gm-Message-State: AOJu0Yzc3yPXcr140/AO09QltqGahoVyWnyZsmsJGnz30Me+9tppKKvz
	GPpNiBlLaEDNeOUP0wOE9RbiO6OCUXkuMttdCCw6RRuxvjPQCzQXmTGaWBZ/2Ko=
X-Google-Smtp-Source: AGHT+IEbf51a0Lez3VZgOhMIi0TTMUwx/lW+MYbzmBRzwh35ZsJrESThAlwZE9SUVfChhiwRpZMzfQ==
X-Received: by 2002:a05:6820:408c:b0:5b2:7e47:e914 with SMTP id 006d021491bc7-5b9ebadc61emr2859280eaf.0.1717080696358;
        Thu, 30 May 2024 07:51:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5b96c6dd119sm3158142eaf.42.2024.05.30.07.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 07:51:35 -0700 (PDT)
Message-ID: <301ba50b-5015-46d0-a7a9-48692be7dfa0@kernel.dk>
Date: Thu, 30 May 2024 08:51:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2] test: add test cases for hugepage registered
 buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
 gost.dev@samsung.com
References: <CGME20240530031555epcas5p352110986064e3d9bcd31683fe59188ee@epcas5p3.samsung.com>
 <20240530031548.1401768-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240530031548.1401768-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 9:15 PM, Chenliang Li wrote:
> Add a test file for hugepage registered buffers, to make sure the
> fixed buffer coalescing feature works safe and soundly.
> 
> Testcases include read/write with single/multiple/unaligned/non-2MB
> hugepage fixed buffers, and also a should-not coalesce case where
> buffer is a mixture of different size'd pages.

Thanks for improving the test case. Note on the commit message - use
'---' as the separator, not a random number of '-' as it would otherwise
need hand editing after being applied.

This is against a really old base, can you resend it so it applies to
the current tree? Would not be hard to hand apply, but it's a bit
worrying if your tree is that old.

Outside of that, if you get ENOMEM on mmap'ing a huge page because the
system doesn't have huge pages allocated (quite common), the test case
should print an information message and return T_EXIT_SKIP to skip the
test case rather than hard failing.

A few other comments below.

> diff --git a/test/fixed-hugepage.c b/test/fixed-hugepage.c
> new file mode 100644
> index 0000000..a5a0947
> --- /dev/null
> +++ b/test/fixed-hugepage.c
> @@ -0,0 +1,391 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Test fixed buffers consisting of hugepages.
> + */
> +#include <stdio.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <sys/mman.h>
> +#include <linux/mman.h>
> +#include <sys/shm.h>
> +
> +#include "liburing.h"
> +#include "helpers.h"
> +
> +/*
> + * Before testing
> + * echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
> + * echo always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
> + *
> + * Not 100% guaranteed to get THP-backed memory, but in general it does.
> + */
> +#define MTHP_16KB	(16UL * 1024)
> +#define HUGEPAGE_SIZE	(2UL * 1024 * 1024)
> +#define NR_BUFS		1
> +#define IN_FD		"/dev/urandom"
> +#define OUT_FD		"/dev/zero"
> +
> +static int open_files(int *fd_in, int *fd_out)
> +{
> +	*fd_in = open(IN_FD, O_RDONLY, 0644);
> +	if (*fd_in < 0) {
> +		perror("open in");
> +		return -1;
> +	}
> +
> +	*fd_out = open(OUT_FD, O_RDWR, 0644);
> +	if (*fd_out < 0) {
> +		perror("open out");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void unmap(struct iovec *iov, int nr_bufs, size_t offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_bufs; i++)
> +		munmap(iov[i].iov_base - offset, iov[i].iov_len + offset);
> +
> +	return;
> +}

Don't need a return, just remove that.

> +static int mmap_hugebufs(struct iovec *iov, int nr_bufs, size_t buf_size, size_t offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_bufs; i++) {
> +		void *base = NULL;
> +
> +		base = mmap(NULL, buf_size, PROT_READ | PROT_WRITE,
> +				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> +		if (!base || base == MAP_FAILED) {
> +			fprintf(stderr, "Error in mmapping the %dth buffer: %s\n", i, strerror(errno));
> +			unmap(iov, i, offset);
> +			return -1;
> +		}

You just need to check MAP_FAILED here.

> +/* map a hugepage and smaller page to a contiguous memory */
> +static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
> +{
> +	int i;
> +	void *small_base = NULL, *huge_base = NULL, *start = NULL;
> +	size_t small_size = buf_size - HUGEPAGE_SIZE;
> +	size_t seg_size = ((buf_size / HUGEPAGE_SIZE) + 1) * HUGEPAGE_SIZE;
> +
> +	start = mmap(NULL, seg_size * nr_bufs, PROT_NONE, 

Trailing whitespace here after "PROT_NONE,".

> +static void free_bufs(struct iovec *iov, int nr_bufs, size_t offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_bufs; i++)
> +		free(iov[i].iov_base - offset);
> +
> +	return;
> +}

Redundant return again.

> +int main(int argc, char *argv[])
> +{
> +	struct io_uring ring;
> +	int ret, fd_in, fd_out;
> +
> +	if (argc > 1)
> +		return T_EXIT_SKIP;

Since it just takes a generic input file, you could have the test case
use argv[1] as the input file to read from rather than just skip if one
is provided.

-- 
Jens Axboe


