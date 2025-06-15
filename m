Return-Path: <io-uring+bounces-8348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ECD3ADA2F3
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 20:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EC2B7A4A4D
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 18:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24671B043F;
	Sun, 15 Jun 2025 18:09:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from fx.arvanta.net (93-87-244-166.static.isp.telekom.rs [93.87.244.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F587266F1D
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.87.244.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750010978; cv=none; b=QyoBN2WUI7Fm4pr3+1JXV9Zd04GC6D1DtoxbJwCkKloEDEtzh71DrmTm1zYaKwhwUFBs8wfKZsTpyJw3USjttnKrWvBRLSbQ8k+Mdgd6nIUY1GGg3jz1aMLr+sd2y2FTrSxfRCYrTvHF/C8ggctlZ7fTmJ1M7Q9tHdA430VZ1Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750010978; c=relaxed/simple;
	bh=d+jTA+AoO9TJFqoWejxNxDkGX1ZnXqRoFlk8g2vlR74=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ak2rX5ovTeD8fvd13cmfUe6Al6YnkSktGTL2yTsG7UqzAGl2KaROzixZimS6+FJ/+wRjn3oWWeQG+C14xwd3SWASBvHO2aiO/WKWbl3YtOToUlMV6MiAwNJNsRsSvhM1KfS8nmJn5NsByevyAmOtWRvjwn29tqsH4W6UuDnWnVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net; spf=pass smtp.mailfrom=arvanta.net; arc=none smtp.client-ip=93.87.244.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvanta.net
Received: from m1pro.arvanta.net (m1pro.arvanta.net [10.5.1.11])
	by fx.arvanta.net (Postfix) with SMTP id 2733410A18
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 19:17:10 +0200 (CEST)
Date: Sun, 15 Jun 2025 19:16:38 +0200
From: Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To: io-uring@vger.kernel.org
Subject: Building liburing on musl libc gives error that errno.h not found
Message-ID: <20250615171638.GA11009@m1pro.arvanta.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Trying to build liburing 2.10 on Alpine Linux with musl libc got error
that errno.h is not found when building examples/zcrx.c

Temporary I disabled build zcrx.c, merge request with patch for Alpine
is here:
https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
I commented in merge request that error.h is glibc specific.

Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
should I post full log here.

-- 
Kind regards

