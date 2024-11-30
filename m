Return-Path: <io-uring+bounces-5162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D8B9DF3D9
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 00:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0322B2104F
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 23:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7663156646;
	Sat, 30 Nov 2024 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCHiNU8x"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FD0154429
	for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733010815; cv=none; b=jksVpSKWy52uzu6ov8gpegcpRd2LAJecW9nuGTZhboqbHOB0Ul8aDhz2UZ8VFP3T+sQUmnkNXL0jiz8MILJJ6cf0N+ABdHPItjJDrHi+ODqWmcQ+WhkLavd/+MWnr5DB1AeWH4CfgCEXscbnkaAZf5tfjclYAZFJMGFD0dsFcPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733010815; c=relaxed/simple;
	bh=/aq/OitHwaR1XFXES2K2BP/Gq2aC2B8m41WHNC49oAg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JWTqW8Exwv+Xld16NY69V+vHRVwpZJIyaPOvEe6du8RE5Jsknk9Bhx4xpqBzSqFFAvMjGGAx/ebcyHkQxaXdXLeSnKjPqOqyLhsuPzLB6ApU1qri8EX6evjOGbYXRsepKbJcmJNl2Jsn7DKNxoNBPmgg5YqhQs3IPO0R85Rsp4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCHiNU8x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1615C4CECC;
	Sat, 30 Nov 2024 23:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733010815;
	bh=/aq/OitHwaR1XFXES2K2BP/Gq2aC2B8m41WHNC49oAg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VCHiNU8xpF48uTO5XGuEaXAw83fmqKw3eSXzzWedvrpPbdI04DNjn9Q0uv9wx3MI6
	 V9w0nYsQEL3Dk/2K5qcJeRErOERLvBRcjyhmSbFNX5jESImHSvDZO52DbCp7d35Bm2
	 m9llumLEKQUv9Rn1JLa2oICUKNDloFYKmP8b54wrKsIc73nI22ozt0Z6UDjHPJ9JrG
	 aahYOKAsVsslG+od42fI1VdNIxEABi/Qy69fu0IoM/GhMD0OzPn4p8BS1goNTy0Tsa
	 hBNb4Ml2fEzf1cqIHYoXsMRM8/uSM02XSHpqkak0mZqDzn+UD+LFAFNjTxkNuVsP6f
	 qzPlwQThTDa0Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB208380A944;
	Sat, 30 Nov 2024 23:53:49 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring changes for 6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <4fa8aaa8-78e5-4e75-98ce-5d79c2b98dd2@kernel.dk>
References: <4fa8aaa8-78e5-4e75-98ce-5d79c2b98dd2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4fa8aaa8-78e5-4e75-98ce-5d79c2b98dd2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20242901
X-PR-Tracked-Commit-Id: 7eb75ce7527129d7f1fee6951566af409a37a1c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dd54fcced81d479d77acbeb4eea74b9ab9276bff
Message-Id: <173301082865.2511415.14466983648087181292.pr-tracker-bot@kernel.org>
Date: Sat, 30 Nov 2024 23:53:48 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 Nov 2024 09:27:36 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20242901

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dd54fcced81d479d77acbeb4eea74b9ab9276bff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

