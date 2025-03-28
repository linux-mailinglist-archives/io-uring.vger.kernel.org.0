Return-Path: <io-uring+bounces-7284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFC3A75254
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EFEA7A2B0C
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 22:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974CA1EB9E2;
	Fri, 28 Mar 2025 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcxZOUzZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D93E1E835F;
	Fri, 28 Mar 2025 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743199827; cv=none; b=n541yiZY3WlvdtJlqMACnWLb3+6Wi/ineR/OrAoOrGvBDfd8gQpSFBSxwlvqwvOSV/6vuIa+E8p4nfdFx+/kxGPuRiViQGbtLK+pubDPC5g2De4nojbm4JXvVb9C/xb5nwhTyL3clKC6d4XpqIUoJdjjRm4Rc6M4SQT5ywFMTjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743199827; c=relaxed/simple;
	bh=45Mm4uN1o4oBDWf+JVu0pFiB9F96c7GoVtTr9ws9Z9s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eJ6l4ZroTlyz5y2DyzrGigdVP6KxMLUx4gLOkqYRjpX1WaO7KuLMopPncrnLHg+Va9QFOWLi3NnT+87J3rU5CC7Nb4vSkUCBW5NdWpHUgm3KNonmKzj5e+51qB7zrAi9wPvbLh0IS6fOBS74EHLwEvbCurgyvs/zPEoDYXcFuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcxZOUzZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F8C4CEE4;
	Fri, 28 Mar 2025 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743199827;
	bh=45Mm4uN1o4oBDWf+JVu0pFiB9F96c7GoVtTr9ws9Z9s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jcxZOUzZ+TN2salXtoRpXZ3w8rLP77LT1RfIv4kNQvp4v6Lq6E+kfMNWr7Xttuy8u
	 iaIkDyd+2ZUnX+iB4EjYvNlD3lULe+jAvdoqph298QoKMBQ0GcvvKPQpPqhtASoiML
	 QcRbbifP6ArafeLdU4HQtx69neS3FpkqlhDJSaqJTwXcS1JuWtZfpMIga+mL9AK/Pg
	 KxEPuDC+zVvlN/ZjqrR29sl23rdU7c7ZkI4zHYJIg/KMAZSL2E7G7/uEDtxrZE4ax+
	 10WAAytRt84xnVqZ6mQFNM+qr9BVqcvOp7waTBXOFEN9H5dFJ9YaPz8G1qZ5vbBaHg
	 p2MBbVTxpOtXw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EC61F3805D89;
	Fri, 28 Mar 2025 22:11:04 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring network zero-copy receive support
From: pr-tracker-bot@kernel.org
In-Reply-To: <12e0af8c-8417-41d5-9d47-408556b50322@kernel.dk>
References: <12e0af8c-8417-41d5-9d47-408556b50322@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <12e0af8c-8417-41d5-9d47-408556b50322@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git for-6.15/io_uring-rx-zc-20250325
X-PR-Tracked-Commit-Id: 89baa22d75278b69d3a30f86c3f47ac3a3a659e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78b6f6e9bf3960c5ee3368415a11babb754b9a19
Message-Id: <174319986335.2977572.1030888783879110453.pr-tracker-bot@kernel.org>
Date: Fri, 28 Mar 2025 22:11:03 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Mar 2025 05:46:21 -0600:

> git://git.kernel.dk/linux.git for-6.15/io_uring-rx-zc-20250325

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78b6f6e9bf3960c5ee3368415a11babb754b9a19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

