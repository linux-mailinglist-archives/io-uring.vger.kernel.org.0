Return-Path: <io-uring+bounces-2027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 526528D5403
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 22:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD252B23D85
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 20:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41A284D2A;
	Thu, 30 May 2024 20:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ezf8+Yt7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8CD18756A
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 20:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717102060; cv=none; b=Hydx2KNsLk2H5YlNHFkrgO2z0JOdCTSvqpPUvLEmj5C87xs0vQgH8sznMYjDEISMBim1jMqbpHaBwh2qJeHq2LvToZS5qisiFWBzwge+WkzODaPI83BwP0zMRmcAw44b/8lfXRz6wJsT2bBdQ8yq0OVZorkFfvT6FMgf73MZ1pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717102060; c=relaxed/simple;
	bh=6/UQ6VPfkMRwnmDBG6S+OaVpBStKl1/nQtfKY8q8Q9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9zN1n0BZckcItVFgxkESxRS2GrBccRA9iA2lCdROc8V1eCAu99R7tK05CGkStPDX5Py0XQuqzCOjT+c13gW1OTT22kQH951pNChFgYqpkgEAbrB803zGbavwA01VVLJQEuWKOzB8VN0L8nl2kejMHEGO9nSZ1MwXzJA8aDH0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ezf8+Yt7; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6ad74e5afeaso8675176d6.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 13:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1717102058; x=1717706858; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ga1Yixe/s4ryLMU9oA1rEgCpWnaYwXalqsXklj5AYA=;
        b=ezf8+Yt7+1CVv8vuHSuHkQ6VLIRaGh5l9Ba2UpQ40Ltz9CT2X/TCPbb4KOlUtBD9ob
         UWSZ35HNw4ecyGvxbZwuKP5L9gZ24my0lwmx+R+9pH0aW7ppHyRTzVBxIvb5peJ6sVaH
         7qW2kdPJhWPoUUgNSSU0dVxVO35UZAjkVIG30gQ+fbfLJJBazyj7Ag9cv9L3xRbSlZA2
         2O3BwK2KpaJFZ4Xk8+JkSS2rvZ/inGkv4him9xfx5/BLjMiQl+xCFCySk5Un7MpvfY96
         ijSsFmmweetqe9Hgs+MGkjDq528m7j810dQ009r7iX8aYc281UjSFq6CXP+9tmviZQNe
         H+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717102058; x=1717706858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ga1Yixe/s4ryLMU9oA1rEgCpWnaYwXalqsXklj5AYA=;
        b=BeYOwrLALtaAH3bj4ChgxeaiMVr8Gesx1ZHBBEE5pX7Itf3vPWPoYSE0HqcfZcLH/2
         C/UoQt7BTPYDeVhpOCnBesFHAyLKlnDU1CXBR5Q0dU73u9L0I/MrzgssKDCp6AeTU7/o
         iIK8HO8LM6+GIExpbtvJyBeM+/oxOF3E96HkcLm6mKf+fKdcnhoX8ASRjIDl60NslyOL
         N/LNAu6AmOFsIvWAqAIvE/PV7gfWvg9q2IWk1ytKzAzujtVY/EbPIAoU5h4uJjzzdRx1
         49E07i4V/l+aX24b5tpQ8ezC2l5loTlLcFzunEwIqbP6fQa6HRsRLSeDyC31kF0UFtnW
         yQcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyfvVfSIUS793sHE2sGxke8kWCupanGi8IE3UA/UaVWD/Lb9iy338sXOX9/j61e3UfjOvTW9KUMLuEXFj2WEYeN1alsDMNl24=
X-Gm-Message-State: AOJu0YwXhNFzbjUwFsBGw9vQ1jYrycvXfUiS6igfScd4vKcw6RDqkGSa
	hihygeaXHW8lfu+ISmCiGdCAaNoHwVQTMu8UpLFHbz2sDdRLxqTbdmXACWpFLLw=
X-Google-Smtp-Source: AGHT+IGLu7Utvn4d35cKADWO6xyI2iy9v6hacZFhv3Dr/b0t0erkbT0o+o7A9sG+I16KFAv8qHzmlw==
X-Received: by 2002:a05:6214:b61:b0:6ad:657d:9d47 with SMTP id 6a1803df08f44-6ae0e87f2bfmr56543066d6.14.1717102058329;
        Thu, 30 May 2024 13:47:38 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4a74770dsm1587556d6.30.2024.05.30.13.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 13:47:37 -0700 (PDT)
Date: Thu, 30 May 2024 16:47:36 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org, bernd.schubert@fastmail.fm,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <20240530204736.GH2210558@perftesting>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>

On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
> From: Bernd Schubert <bschubert@ddn.com>
> 
> This adds support for uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> appraoch was taken from ublk.  The patches are in RFC state,
> some major changes are still to be expected.
> 

First, thanks for tackling this, this is a pretty big project and pretty
important, you've put a lot of work into this and it's pretty great.

A few things that I've pointed out elsewhere, but bear repeating and keeping in
mind for the entire patch series.

1. Make sure you've got changelogs.  There's several patches that just don't
   have changelogs.  I get things where it's like "add a mmap interface", but it
   would be good to have an explanation as to why you're adding it and what we
   hope to get out of that change.

2. Again as I stated elsewhere, you add a bunch of structs and stuff that aren't
   related to the current patch, which makes it difficult for me to work out
   what's needed or how it's used, so I go back and forth between the code and
   the patch a lot, and I've probably missed a few things.

3. Drop the CPU scheduling changes for this first pass.  The performance
   optimizations are definitely worth pursuing, but I don't want to get hung up
   in waiting on the scheduler dependencies to land.  Additionally what looks
   like it works in your setup may not necessarily be good for everybody's
   setup.  Having the baseline stuff in and working well, and then providing
   patches to change the CPU stuff in a way that we can test in a variety of
   different environments to validate the wins would be better.  As someone who
   has to regularly go figure out what in the scheduler changed to make all of
   our metrics look bad again, I'm very wary of changes that make CPU selection
   policy decisions in a way that aren't changeable without changing the code.

Thanks,

Josef

