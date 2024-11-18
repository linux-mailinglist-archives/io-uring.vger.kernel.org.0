Return-Path: <io-uring+bounces-4787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B095A9D1BD5
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EB151F224C8
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2AE1885BF;
	Mon, 18 Nov 2024 23:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZs3cTCq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE43D2E3EB
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 23:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731972700; cv=none; b=CsTd641K09IoX2VFtYjVkDNwCrFw5dd1T/wP3+xwpgjvcGp4xdFgk+Jz7l6L16nMUGLLyTH8D/GYHsX84faUC32vfVHJGzkaSIY4x3Fp3K3wbQKNB5S2IZHqm66vWCagvfJRhW+ljgSSfZhat8V/oikCZRInbHoNNm56k+3ME2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731972700; c=relaxed/simple;
	bh=RSjFiAdJC1674a14jNvmlIMN52hCke/iMrfnmXV6SQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXI7F0t9Bux2qm51CpEdjzQPi/ROy/pXQAPaqRd3xIkJ+XM2A7UhIrqbIBkgmRuzYEBnBrsZwJklzCPjtha+i9cyhUMKGcln8R1K/rwbe1upfSS8MYD+64ChQw/SJu1RNe/Ta3y5lZ+tbmD+D/LKkqBXqIFWD43mizZ/VQVM6Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZs3cTCq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6ADC4CECC;
	Mon, 18 Nov 2024 23:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731972699;
	bh=RSjFiAdJC1674a14jNvmlIMN52hCke/iMrfnmXV6SQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JZs3cTCqF5B5lxXA9+bWuuP44LKd4CWIOBR2A6NmVG56O8SdHxZbEajmR8ShXc4xg
	 Yjk5PG0q7PQsE5iv35XSK2UAyHAyVBbn0D+RDJ5zQlTBTGmSDNigfOMNmkL1mnve+L
	 e+j5rVd5GT8VWw0LF9odfSwBJ5svSDMz6xJetrhLv1dsuwwaMr2DjrsOeoPfjedT+B
	 vl6LuQhxWkw6NRj6VuZTjKgSOfOdkev9YWI6E53VV9edud4q44SoOZiDB/j6UzTyY7
	 CBsep6D1RlOrsV1QzptMJHctDeQe0e4UqAkHDbwj5q4WXzDcaQ2hFt/pI/A/njIUnC
	 43HpIstHuU3cQ==
Date: Mon, 18 Nov 2024 17:24:19 -0500
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	io-uring <io-uring@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [GIT PULL] io_uring changes for 6.13-rc1
Message-ID: <Zzu-k1nW7LegRJEB@sashalap>
References: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
 <Zzu6dkYTFX2AA26c@sashalap>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Zzu6dkYTFX2AA26c@sashalap>

On Mon, Nov 18, 2024 at 05:06:46PM -0500, Sasha Levin wrote:
>Hi Jens, Thomas,
>
>On Mon, Nov 18, 2024 at 07:22:59AM -0700, Jens Axboe wrote:
>>hexue (1):
>>     io_uring: add support for hybrid IOPOLL
>
>After merging of this pull request into linus-next, I've started seeing
>build errors:
>
>/builds/linux/io_uring/rw.c: In function 'io_hybrid_iopoll_delay':
>/builds/linux/io_uring/rw.c:1179:2: error: implicit declaration of function 'hrtimer_init_sleeper_on_stack'; did you mean 'hrtimer_setup_sleeper_on_stack'? [-Werror=implicit-function-declaration]
>  hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
>  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  hrtimer_setup_sleeper_on_stack
>
>This is because 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
>adds a call to hrtimer_init_sleeper_on_stack() which was removed earlier
>today in Thomas's PR[1], specifically in commit f3bef7aaa6c8
>("hrtimers: Delete hrtimer_init_sleeper_on_stack()").

Linus,

Looks like this is a simple
s/hrtimer_init_sleeper_on_stack/hrtimer_setup_sleeper_on_stack , so this
issue could be addressed by replacing the new call with
hrtimer_setup_sleeper_on_stack() either in the io_uring or the
timers/core merge, whichever you pull last.

-- 
Thanks,
Sasha

