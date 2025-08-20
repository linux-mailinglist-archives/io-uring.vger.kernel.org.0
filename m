Return-Path: <io-uring+bounces-9094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C61F4B2D81B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 11:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3953A1C45372
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 09:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C582DBF45;
	Wed, 20 Aug 2025 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqBf5Gcc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EBA2877D2;
	Wed, 20 Aug 2025 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681220; cv=none; b=Y6hoHMEPe979PYXLhEydNWS2qd5pkbFV/pOBmvCrZ/P8WnXIcVRlrvWYcJ2uVql8s8BDRrDhGwzP32Hm42B+EnrAP2mYoXYR2Ead5CpoN3hYOlT34Cu3j7F0R5e9730rreKlpNtdSh/F1XH66KzJTADG3ISM49dox8ul8yl7CE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681220; c=relaxed/simple;
	bh=NA0WgRqw3iK6aEhn4hX4CjVc7Q0L3hsGDYQKznndRWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YW8Vf1wvchGMJhLEm/qsYrPY9GPvEsz6XkECr8NDrXw7QuA4Y8p/C6vWIvQXR2GTZj0pi+3Tyn1t5keD3MYkWhTYc9ZrRx/RB15RhCC2ELh7m+a7VM95WHh3B14Q+bWT3f0sMS4mV2AKIMpkTbuKQBG0J4lPXCalIgAf2ftLI2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqBf5Gcc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17CEC4CEEB;
	Wed, 20 Aug 2025 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755681220;
	bh=NA0WgRqw3iK6aEhn4hX4CjVc7Q0L3hsGDYQKznndRWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqBf5GccR7n65Mz4at6CBnL+CuX79mlimTW8KDfVDImioCe9WIpry36Nh3E/oB6ad
	 1eNnAx43HTGFnQbuES5FXVacpipmjoXoSyJJXCkAq3iv/LYO6rKirj39oKs/2SFa/B
	 hbgFRJgJCLhNopxNb6fOqQnvCrfiN3K8YCNoVh+OzDdRwdqbpGeYHY0OBgO9U1NbYJ
	 qdOqsMmIcjJLp56gKvu7Eoscj13cFo3zV4oIy5vLLTk+yWASWHDYT6VHPE/TVZTp3l
	 GhONlh9Or7tQyqm0mmz1zmgMN6SZPmT3HjSzm7S+wNjFc+7DbXogxK3j31gWeULEpb
	 HjX7qqQx5mvvA==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: io_uring / dio metadata fixes
Date: Wed, 20 Aug 2025 11:13:28 +0200
Message-ID: <20250820-beckenrand-anbringen-b821987f39be@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250819082517.2038819-1-hch@lst.de>
References: <20250819082517.2038819-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1341; i=brauner@kernel.org; h=from:subject:message-id; bh=NA0WgRqw3iK6aEhn4hX4CjVc7Q0L3hsGDYQKznndRWY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQsnbjv+PPWLUIvnt5WlJ7z25JDJTVQusykuFbs8tS61 y31zD/VOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbCE8Lwz8Au1DGmv/nP3/1W OkeSnlj7vw38Wu7Qcvf71HkRPU4X3zIybPRdOHn5wydq19hWzH8veXpGQtelipaQXUznm+6dD6g NYgIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 19 Aug 2025 10:24:59 +0200, Christoph Hellwig wrote:
> while trying to add XFS support for passing through metadata I ran
> into a few issues with how that support is wire up for the current
> block device use cases, and this fixes it.
> 
> Diffstat:
>  block/fops.c       |   13 ++++++++-----
>  include/linux/fs.h |    3 ++-
>  io_uring/rw.c      |    3 +++
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/2] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA availability
      https://git.kernel.org/vfs/vfs/c/d072148a8631
[2/2] block: don't silently ignore metadata for sync read/write
      https://git.kernel.org/vfs/vfs/c/2729a60bbfb9

