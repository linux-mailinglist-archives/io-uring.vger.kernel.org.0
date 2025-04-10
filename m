Return-Path: <io-uring+bounces-7451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BF5A845DF
	for <lists+io-uring@lfdr.de>; Thu, 10 Apr 2025 16:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 288301BA6294
	for <lists+io-uring@lfdr.de>; Thu, 10 Apr 2025 14:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150F428A41A;
	Thu, 10 Apr 2025 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZgNmq7Z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5240276021
	for <io-uring@vger.kernel.org>; Thu, 10 Apr 2025 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744294158; cv=none; b=WcOzjooxEoJyzDcYFrmV7/KWC6Pr6Cz9qJqmqnRS8AsqaK+GNW3CVVdDI7DJljPtj8YVZ71KdUBv28pd1EFOwa8GNjAyU2P/EdBJo+hBKLl3nderOY18Qik1NlAx5nkT6nf1AKfSTj5kJJA9whms1Qo+CRIUNz97rw7bg5uA3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744294158; c=relaxed/simple;
	bh=5C9wq6oHt9FOf7UhohBJ7/eSFygw3ffaqdoaZahYkfU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RaJbc8P+7owmd3LXmk58RSIkiOF+nnRNGbEAgT/mZNT6z18g9xipa6NJBEIWz5eXrwL54KmVqTkNHO3V7SoP1keLfXx5PzKKixiYigIFRA1gv90SwL+lUVG/0mafQuq9/GVSHtUREH2t0XqMABFWEHd5aA0kYjynjHnP7X0qKoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZgNmq7Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B148C4CEDD;
	Thu, 10 Apr 2025 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744294156;
	bh=5C9wq6oHt9FOf7UhohBJ7/eSFygw3ffaqdoaZahYkfU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lZgNmq7ZXR975pEH2nKsTDt7vKt94z8M2nR4qN5g8svvUz7v/SUg1V8zQ18g2elAS
	 oCkbvLxsNykPvVoxPHnaJ/nyJjDoOOxWjdJSaf+fnU7g7EWfj3pKvwJzpqPdD5XKY8
	 AxIMXMlVX1rFQWpQ8JBRc7azrS5Ph8vCQvWyhV+g5kc7YsK8JG7Cn0oJt2/PjyELQW
	 rJ4ZrV2g/eel7oHyeqGQTKK6POM2DEYo3ex7c0ijtzYmyWaBQWXQH1PTxSsPtBfAfd
	 WfEq2BVelg50yktooOMj80u5pY0aA/ElKnp8JFYbZt++OZ6+W/YCq3ay/z+DZvWd0b
	 ZxpiGyTnbb6aA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3435F380CEF4;
	Thu, 10 Apr 2025 14:09:55 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <69eb3ff6-ae4c-47be-86ef-b83fc8327a3e@kernel.dk>
References: <69eb3ff6-ae4c-47be-86ef-b83fc8327a3e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <69eb3ff6-ae4c-47be-86ef-b83fc8327a3e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250410
X-PR-Tracked-Commit-Id: cf960726eb65e8d0bfecbcce6cf95f47b1ffa6cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a61ec0dd18de4e98f46dcb95808c7cae0c8e0acc
Message-Id: <174429419366.3685623.12332446547223739567.pr-tracker-bot@kernel.org>
Date: Thu, 10 Apr 2025 14:09:53 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 10 Apr 2025 07:24:52 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250410

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a61ec0dd18de4e98f46dcb95808c7cae0c8e0acc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

