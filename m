Return-Path: <io-uring+bounces-5798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC25AA08EC3
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 12:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9FD516A0AF
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 11:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A674520C01C;
	Fri, 10 Jan 2025 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9qL+GOK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69E20B207;
	Fri, 10 Jan 2025 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506868; cv=none; b=HBkXVHf/x8Y5S+kptVfPrCYOS2cxgrwDyGq5fOgFSCRQAiApxMg+eOcJKPxQK98z0IynwQ+QhEXJgh+H4oDvLNTW0yIPu2+pYhZV5Gjm++Fz8mrwnCH8WjYDFmOFhKOx0/7S3DZDMB0jk85xX161hxtqIhFQ4VW0vqxeZ50/5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506868; c=relaxed/simple;
	bh=j8da2wEF4Pe5R2H3BFAb4skhJmQUo2Hi4EaYfyKuS94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f39HponssXbv/0OVbHSKlqsIIp7ztJi1MP5xyhIwpdJ0ikPWT++UnxvBqxOme8maUQ0m6wo9+ZdKX5/dD3Mcly0XW4rN36fgAuhDWW8NtL4BKQgeZuR+0xp383Wkr4/W2QHd9Cm/TitJXq1eExweKdfV6ziU/DyxKHi8cCNu5rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9qL+GOK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5105C4CEDF;
	Fri, 10 Jan 2025 11:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506868;
	bh=j8da2wEF4Pe5R2H3BFAb4skhJmQUo2Hi4EaYfyKuS94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9qL+GOKVKL5YQQDFK23UX+/Nlc+IzVQt9brWCZv+UXbE2aqVhBsUbMb3pLrYx2L9
	 pJLwx7iJktKWA8Ts3l4PDfCi4ljzB1lZovKs1zOiNM0vqXmwZOiZ1J6BXxiU4JLqzR
	 +T4Lq+nohB86t4mtMXHA1wAow79nQU8TIGRx9Vs1CUD3XWwvB4OoDJXzQK6jptLZKN
	 UwJ1sXjh90gCGhjjOqUI2zd0O6Ef4sBOKWSkRpN+co2ccyUGaY8N/LWRsorLOWkxKb
	 gPSgbQJdIQ5eLTrAptmflCb+7TltyYDkyST84sLOrcOqdn+veqY9weNGkldnoFuinP
	 1z5NL8IB4L2bw==
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()
Date: Fri, 10 Jan 2025 12:00:53 +0100
Message-ID: <20250110-respekt-mausklick-176ab50a5b7e@brauner>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250107162649.GA18886@redhat.com>
References: <20250107162649.GA18886@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1595; i=brauner@kernel.org; h=from:subject:message-id; bh=j8da2wEF4Pe5R2H3BFAb4skhJmQUo2Hi4EaYfyKuS94=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQ3/H3b6xFy9OgJp8i9veK3bCOFpa6L/ppyet/hD52iv UkfbzZe7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIgDojw///X6ZuVV+/bOd9 d8PgiTu2FyUtOFzOrscicSV4lWm4nxfD/5QTeXeNoz86XzRfXPCMVS7mtpVj/+lAT/3ZmsvDpKV OsgIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 07 Jan 2025 17:26:49 +0100, Oleg Nesterov wrote:
> Linus,
> 
> I misread fs/eventpoll.c, it has the same problem. And more __pollwait()-like
> functions, for example p9_pollwait(). So 1/5 adds mb() into poll_wait(), not
> into __pollwait().
> 
> WangYuli, after 1/5 we can reconsider your patch.
> 
> [...]

Applied to the vfs-6.14.poll branch of the vfs/vfs.git tree.
Patches in the vfs-6.14.poll branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.14.poll

[1/5] poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()
      https://git.kernel.org/vfs/vfs/c/cacd9ae4bf80
[2/5] poll_wait: kill the obsolete wait_address check
      https://git.kernel.org/vfs/vfs/c/10b02a2cfec2
[3/5] io_uring_poll: kill the no longer necessary barrier after poll_wait()
      https://git.kernel.org/vfs/vfs/c/4e15fa8305de
[4/5] sock_poll_wait: kill the no longer necessary barrier after poll_wait()
      https://git.kernel.org/vfs/vfs/c/b2849867b3a7
[5/5] poll: kill poll_does_not_wait()
      https://git.kernel.org/vfs/vfs/c/f005bf18a57a

