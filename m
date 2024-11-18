Return-Path: <io-uring+bounces-4783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB60A9D1BBB
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93E7E1F21E12
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226FC1E7C3B;
	Mon, 18 Nov 2024 23:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWZgYdp0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06AC1E767D
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 23:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971646; cv=none; b=Dj/VzFcWMcoiEo/JPGiMtEBnQSsFGaN3FEtJcQqYeUQOOvjws+CsJdEXxWYRpFiOkMXfDQNc8Mozfn3C3Y6jg17Itsuvj5k7frhOCKUgG2iKRQyDNUX6TqcHGILwyfWjcU7tN7+49lZv5Tu6+ufX56BXZFN+cO9dv8ycyU58Se0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971646; c=relaxed/simple;
	bh=6bYubbpF16uZAHfJA4POwg11kPW/PNd3hELQMRWvl1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSZy+tQXEoerUBfSKqtA2Kc0eIwTTVkketfwKE6iseyfFLU5rZslV8e+KR4KRhITWTXB8Ce3fnS4PFmLyFxtojh2y+OQ1aBzAKHbn0TOtvgD+FcRpCosgGvbVAMXMXNSn3Bc33BwY1XoXEhalRFCdIYvUIV/sliXg4aOXejwS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWZgYdp0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A64C4CECC;
	Mon, 18 Nov 2024 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971645;
	bh=6bYubbpF16uZAHfJA4POwg11kPW/PNd3hELQMRWvl1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWZgYdp01Coei4JSy59F/VXdCpNGh4l2JOE/5wI2fqKG8al9n4OVEu5poWRXIyOTm
	 WvS8JdBZ3Und/BvGUFSJhVGrw28lLPpMp1MiistDPRTv2PZtfi0LzGwSge4J12JIRk
	 VE3ZglwyfXaFTuyNp8tweLTCMuUVHav7g43mR5Gnfd9GmfiGvGryynw94AX6gWilKx
	 c0rbrAlkzOx3ssJqwfQ12w4M4lUhdUjg1Dzuq21dvUQpxo602NOsQacb8nIMkTpwEi
	 +Pvwe6rchHtZeZqEeXg5wzrt1O0Clt2O1H7bPeCVhVHLs0OUffsoLpua/+E7XG6QNf
	 FpgPkfbTDDbWQ==
Date: Mon, 18 Nov 2024 17:06:46 -0500
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	io-uring <io-uring@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [GIT PULL] io_uring changes for 6.13-rc1
Message-ID: <Zzu6dkYTFX2AA26c@sashalap>
References: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>

Hi Jens, Thomas,

On Mon, Nov 18, 2024 at 07:22:59AM -0700, Jens Axboe wrote:
>hexue (1):
>      io_uring: add support for hybrid IOPOLL

After merging of this pull request into linus-next, I've started seeing
build errors:

/builds/linux/io_uring/rw.c: In function 'io_hybrid_iopoll_delay':
/builds/linux/io_uring/rw.c:1179:2: error: implicit declaration of function 'hrtimer_init_sleeper_on_stack'; did you mean 'hrtimer_setup_sleeper_on_stack'? [-Werror=implicit-function-declaration]
   hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   hrtimer_setup_sleeper_on_stack

This is because 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
adds a call to hrtimer_init_sleeper_on_stack() which was removed earlier
today in Thomas's PR[1], specifically in commit f3bef7aaa6c8
("hrtimers: Delete hrtimer_init_sleeper_on_stack()").


[1] https://lore.kernel.org/all/173195758632.1896928.11371209657780930206.tglx@xen13/

-- 
Thanks,
Sasha

