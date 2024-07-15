Return-Path: <io-uring+bounces-2514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C505F931CA9
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 23:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F024280CE0
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 21:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403F513F42A;
	Mon, 15 Jul 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKbpLyVx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6913D51B
	for <io-uring@vger.kernel.org>; Mon, 15 Jul 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721079348; cv=none; b=HIf34Jek4xZ8OYLocDf+NbWQGYJQJ6Ah+CuVG2AtZI9GHgxyuB/TOp10epbZ0XDHps1bwsWjLH17uBppCnl1hSsBCkZmOwnHXA/a9HtIZBPEQGRm4VpVbmK0BjCh926lT/J9XPbLF3lsvUAeYRSyFj8NMhCR5XGlkqZVxzkpKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721079348; c=relaxed/simple;
	bh=fbUzHbBE3uzu/g27svsgDbiMXZ7RxgO1jpu/Pqf97pI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sdYaDgQrMQ+uFybuPOAOVlEHxjXAJliK7U+q4aFUV0++eR68ryqxmu4LiGaf4Xdp/SV+W4z7EoTOhjBT4p0x9P5omXBvafk31HZ2KzJv27tKYoIwdhUUwaFcglQpvbcWNQUaH0n05ZFxUOR0BIxvBfcCrjWKQVhw4ITMebNhTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKbpLyVx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3113C4AF0B;
	Mon, 15 Jul 2024 21:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721079348;
	bh=fbUzHbBE3uzu/g27svsgDbiMXZ7RxgO1jpu/Pqf97pI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HKbpLyVx1+HNzYSsY6e7uFl4K5bB8j3ihOgU9lDCwihs8rlIaWX38yOa1bomYEQyU
	 pVVuJ6h0bag+S+qr8zP1yDGBDKRgf6bQOlVGw87JhO1wQJUdP5lLqcIXLEPfJeQFya
	 y1ICo/L2TFZg8sqUfgGvfrPKCsVKTavRmIHdXHXxDA0mmBbnWeN29uaFpxdGNGRm0x
	 hCU+37zNufeYdWNrxvN7lz7IDGeXk7ORzmfRlSbslIF4vqb3zhdb2wJ+2GlXdkXjsU
	 FnRVRTHIEuMOgpQ/+r33O2a9y1VvQxRdUGoZpcoza8SO8acbOgUhR9w2sggbF5z8ly
	 yuRhdHQSmn39A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7FD4C43443;
	Mon, 15 Jul 2024 21:35:47 +0000 (UTC)
Subject: Re: Re: [GIT PULL] io_uring updates for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <5808867d-c2dc-4c34-a14c-ece564b28cc2@kernel.dk>
References: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk> <5808867d-c2dc-4c34-a14c-ece564b28cc2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5808867d-c2dc-4c34-a14c-ece564b28cc2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240714
X-PR-Tracked-Commit-Id: ad00e629145b2b9f0d78aa46e204a9df7d628978
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a56e241732975c2c1247047ddbfc0ac6f6a4905
Message-Id: <172107934794.10457.11694609829485001649.pr-tracker-bot@kernel.org>
Date: Mon, 15 Jul 2024 21:35:47 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 14 Jul 2024 01:50:16 -0600:

> git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240714

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a56e241732975c2c1247047ddbfc0ac6f6a4905

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

