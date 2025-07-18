Return-Path: <io-uring+bounces-8712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B67EFB0A8F1
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DC5D1AA133A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 16:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8AB2DCF5E;
	Fri, 18 Jul 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q+Rj+m+C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CB1C862C
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752857590; cv=none; b=k2hTxscOaLBSoEk3u4Cz+V35QI143eWK30AK/SNj89Bf2bZgPNk1Yx9BHj5jQJtDhX9JTpu9Bt23ODYerg8ELcOwHLFraYYonr8DVG7X8VVysHCdbpWXHk8hLFm/mpLAVM8onnt7CLYe6GUZJCoQUFhQIcWXuntfBB2PU5Kaddw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752857590; c=relaxed/simple;
	bh=r7vzXnivQc/h5uUcMjRgwB7bDa7aeB9BjXtl7XYKyII=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=KSFfPIkJBi+DHS25Jg24FWk4mVJCy8iMtNt47owSXmsFUX0SaOUsPu/ko/fpX4jnO7tFiKED2CZRrjzwCXuG4XMRmvOSPtP5jmVaDP7rj82275oGGIiB29P5CP6OXpO5JtiGcdy+WQap7xHjgmyfbxlQdA//e/vrSOvTNO+zs6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q+Rj+m+C; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-311e2cc157bso2084378a91.2
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 09:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752857585; x=1753462385; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVG6cLK9n8y4nJi36ugdAcSs8CPsckK94dtRLvWIjJA=;
        b=q+Rj+m+CI9L+MKBoz/caymC9GFuIBWgcSkQGWCMgebGrqso04nzge5NO95Z+2iJ7NQ
         gGmk2qDuGR9ycLaFEUcFEfE7wNFBdpeI+keYqGIr05Fb24NNPoU7OdNVF0Zdh0x47YMh
         /hiNm8cZ6ZvtlUat59FQzLotLpLRQchpDmygSELIn2tyCB9RsLAV1ogghwzpOcWU4abw
         MmD/lZ1Lm42AZUpjSy+K9rfafPjqOI78IwDB9PQNDXxwt8B/vGxmr4qfue+XNdwhm1ec
         E78LSP0dinSIc3QNqSKtbuFHHcRMDRzQBF/XuLW4xeGXxWvqTbtqAG+ThYzSHUyAR3WM
         2mWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752857585; x=1753462385;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PVG6cLK9n8y4nJi36ugdAcSs8CPsckK94dtRLvWIjJA=;
        b=SyiYmAoZ9iqu1iQU//Kac3Fah4pHniLkUHrBnIXaBklO+HpAvjZ4jNLwCgHL6WFA/o
         ixyzyPMROVXA1vmz2Im1J2h6XfhsO6CzP2tzfzujuQ5rA4hw+ch16AeBS3mKOq1fV2fd
         KPwFp5h2ckuoMEy5sdsgydkWtUUgx646yXf8LF1mwHVbaPgI62SBGAWe7qaz7ZejK7NS
         JQLRf3qnysZAmMezQmlFhjiyWDmUd40XyAVGmVi/lGK3IJPNy4UW9qQG0rq1NENnv/GJ
         Qi60NQzy3iVqNQsEbV5pOby9bRqbt4Z9ZrANErvisHXBKLJb9Nf8coXT4LyoVf6PEaH9
         YAhQ==
X-Gm-Message-State: AOJu0YyH9KZKxqCi91fLw5ueYcKGQjjalNUD4S+PCySRn15rsriz8M4k
	O0MUC/dhSR8P11BlvFJGwPZekd7ncwl3PF6wLh+QHFuYeDK+xO4F61Y1V6rps/E7J2CCyQyiclX
	WJYfc
X-Gm-Gg: ASbGnctT/GCpwnkep7ywreBLuhYJuYsUc0KuxFbROB+WtIwzK3VXeRWoXvMuuO322Pv
	nC19COw1rCxuNooD94RAN7NQ/sMwSx+8hcFEYRAhz76nXSe+Ikq20YNZZl4KP8whZEnF4Few4xn
	XCfmNgoNmq7nFWGrDaUdaQKnLqmkjeNdQHk6d9d+yRsnDlyMnR+eGMt6qTAudRmZfnpjI0eJAN2
	OatAKGrgam1aTJLXZ71kxbzj5BnL62GRlgSZjZJ2vE1NM/8ET4zAeFvZshR8x3ADUFjMGwHcmrJ
	43MM/FHVyiJOD1pqlBjW6cXT0y302YkPWjBJZnFwhyfgD+wnETsOWEWgzCK5T1UKf/feEmxySn9
	1arUGSTsu/jSlqNaqzkd4nx3f++4mKSk+IhzXGaSunMLL1MRnl01RvjxS
X-Google-Smtp-Source: AGHT+IFR8+Sd1wAHxi086ltSijI1rT9V75cTKjGTGtHSLbFV8muHF6Tw3/R6o27R9rxC+MngG3AY7g==
X-Received: by 2002:a17:90b:5281:b0:310:8d4a:a246 with SMTP id 98e67ed59e1d1-31c9e6e515cmr15445147a91.1.1752857585559;
        Fri, 18 Jul 2025 09:53:05 -0700 (PDT)
Received: from [172.20.8.9] (syn-071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31cc3f46b0csm1597043a91.42.2025.07.18.09.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 09:53:04 -0700 (PDT)
Message-ID: <7c756cba-904d-48bc-99c8-d21f47db1c69@kernel.dk>
Date: Fri, 18 Jul 2025 10:53:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.16-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes that should go into the 6.16 kernel release. This pull
request contains:

- dmabug offset fix for zcrx

- Fix for the POLLERR connect work around handling

Please pull!


The following changes since commit 9dff55ebaef7e94e5dedb6be28a1cafff65cc467:

  Revert "io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well" (2025-07-08 11:09:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250718

for you to fetch changes up to c7cafd5b81cc07fb402e3068d134c21e60ea688c:

  io_uring/poll: fix POLLERR handling (2025-07-16 10:28:28 -0600)

----------------------------------------------------------------
io_uring-6.16-20250718

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring/zcrx: disallow user selected dmabuf offset and size
      io_uring/poll: fix POLLERR handling

 io_uring/net.c  | 12 ++++++++----
 io_uring/poll.c |  2 --
 io_uring/zcrx.c |  4 +++-
 3 files changed, 11 insertions(+), 7 deletions(-)

-- 
Jens Axboe


