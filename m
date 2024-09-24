Return-Path: <io-uring+bounces-3291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F85984B49
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 20:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32800281BED
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 18:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BF41ACDF6;
	Tue, 24 Sep 2024 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F77ItNXM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AFA1AC88B
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 18:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203551; cv=none; b=MZ9B+vJW7i5YoMROgWYHkMA0jkvH3NazP3yEyACmYwaHYRxgcUuL20CvMqLrRX2ZcokMra0LSDPNgjbSV21i7zcOiA9xMtYLEK0o5jvmtgq+memYI0psWZ5iUlgthUljttnCB78bd7XDsFoY9Kl6KmbfT10kZTz81ENuJ4c4V/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203551; c=relaxed/simple;
	bh=77SorwxOIRmi3jzUugpEUXi2Dt3q3MUfMeGpb+cLdSM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S8HI6mdV/CRzHYLDcaWtNbCtzjCcC1ED0fMJHIrkvSf10ZOI7EXOh6xe/Qh16a1py/N9ssItUP5qIIOluiFLvZq+6k0f8+BlH0MrrgP0ADT+UHYKq4w7ASridU3vna1WkICIF9k7tOieKYKpDuVm4dskYupNGFMzCGBeDcej5z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F77ItNXM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F50C4CEC4;
	Tue, 24 Sep 2024 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727203550;
	bh=77SorwxOIRmi3jzUugpEUXi2Dt3q3MUfMeGpb+cLdSM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=F77ItNXM4tyxkaRyjJ3qC3Zde56Cc/LtjUvqIJORocutQL62kqcqGzbVhpwOTFSnT
	 RyjaaqagCelQPIX8Uege61AydGgGLA62F95VeHc1xpvGL1kgyGmGjrK2Qj9ece1C5C
	 h8eEc/a2XGkBbuJa4g76hd1qowmUg1rXmq52ZMQBqUNi6YzRTH6wMrNiz6Su+P45bw
	 BEHFSZeRcY8uZ98YUKLp+z+0pZne1y6EpnSFJBGIVSdKZXxNB8hiEdgCalzZ9vOQm6
	 I+90opotlf8nzGuDVxNbTsDRT94A9smbrJdXpCfzRdPd8pdxwYMf3t9UZj6kIlZF4X
	 CjWL19JZUvPcA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CF83806656;
	Tue, 24 Sep 2024 18:45:54 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <4aaa45b3-ddef-4278-88da-fb9f4bbd96ec@kernel.dk>
References: <4aaa45b3-ddef-4278-88da-fb9f4bbd96ec@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4aaa45b3-ddef-4278-88da-fb9f4bbd96ec@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240922
X-PR-Tracked-Commit-Id: eac2ca2d682f94f46b1973bdf5e77d85d77b8e53
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3147a0689dd9793990ff954369ffcdf2de984b46
Message-Id: <172720355306.4158342.10461333103672248212.pr-tracker-bot@kernel.org>
Date: Tue, 24 Sep 2024 18:45:53 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 22 Sep 2024 01:04:30 -0600:

> git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240922

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3147a0689dd9793990ff954369ffcdf2de984b46

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

