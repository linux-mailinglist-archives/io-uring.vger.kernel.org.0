Return-Path: <io-uring+bounces-10633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EC446C5CF26
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 12:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7ACFC4F2350
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 11:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BE731618E;
	Fri, 14 Nov 2025 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swCOEUwF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830D31618B;
	Fri, 14 Nov 2025 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763120851; cv=none; b=MbDKiIIThg6TFWSALCSgLusnviEubfjMZpUYmk7vDjw3L2w5VjUPs9VYRUcBjiQshnDxmOCW5iAyhEPFCC1eI1uyAa2aPyztiCfJgulqPTxtjG/UYc8m9YJ7Y73XdMeIMzQgscTY4XK2qwgO3duV9FtiRo+MqvnPO3HFW3QQHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763120851; c=relaxed/simple;
	bh=RYmfyxnd44YBm9qRxknxIsvpnN+q7uX4ZyGg3dXJhWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3jb5ilBryEVy9CDe9N5KvFlwgJjzKoT5xP1RTZ5aBNByGZ0U8We0gKXweSOxkZMwTy9KdLZDw2dvUie4f3eZZoWynvKXKj1WNWSRATWls1G3evnbxiOpV1dWO60TgsfBaFT+HxnJlqw9IOV8NN5fBeW+5G1fHhhQKWJzDRyggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swCOEUwF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0E5C16AAE;
	Fri, 14 Nov 2025 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763120850;
	bh=RYmfyxnd44YBm9qRxknxIsvpnN+q7uX4ZyGg3dXJhWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swCOEUwFDZh8N+CoqAHwqJnNTs9ArbLrXSHUkfNMxzE0dAsJhXF1YK0h4dinnNmnh
	 AxVxjv5ZiMIo4scYa777S1WkauAAN9o2XKahy9hEbqn/U2842NbuRuc5I6XW6dqlqA
	 js/BsvNShGpxDkicSX8r01+7sPT2FuMggxoJjoYPJ67bQZ8mPA914Zoz5kZQm+JBlr
	 AlPBH7CQ4rI4BXLRjmBRToIydgTB2iVCEgK6lGYWeRIqcetLLIjk8J/JU6oJ/4pqJj
	 EGXUjf2huxpfz9kJQt2bM1LOJjtnPvGO//3QQwl+NRSuQ3elsMJow5RcDmNUzEqbeT
	 kfRsAo79aRA1Q==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: enable iomap dio write completions from interrupt context v2
Date: Fri, 14 Nov 2025 12:47:23 +0100
Message-ID: <20251114-postfach-entgleisen-90917e292b3b@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170633.1453259-1-hch@lst.de>
References: <20251113170633.1453259-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1669; i=brauner@kernel.org; h=from:subject:message-id; bh=RYmfyxnd44YBm9qRxknxIsvpnN+q7uX4ZyGg3dXJhWs=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSKi50R1z5mnR649NWxqalN2uIdtnbppw8FT7raXLQk9 w5HV3t4RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQYEhj+Z65YkBj3kLsuZgWb 5ZumxbsTSq58lD8XN8lo9s1pn+8IcjEyrJ1yW/njkUn8TOtexN3lKy0SN9wrE/wowcDz2E92xnm TeQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 13 Nov 2025 18:06:25 +0100, Christoph Hellwig wrote:
> Currently iomap defers all write completions to interrupt context.  This
> was based on my assumption that no one cares about the latency of those
> to simplify the code vs the old direct-io.c.  It turns out someone cared,
> as Avi reported a lot of context switches with ScyllaDB, which at least
> in older kernels with workqueue scheduling issues caused really high
> tail latencies.
> 
> [...]

Applied to the vfs-6.19.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-6.19.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.19.iomap

[1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
      https://git.kernel.org/vfs/vfs/c/56749ed317e2
[2/5] iomap: always run error completions in user context
      https://git.kernel.org/vfs/vfs/c/222f2c7c6d14
[3/5] iomap: rework REQ_FUA selection
      https://git.kernel.org/vfs/vfs/c/845c50436431
[4/5] iomap: support write completions from interrupt context
      https://git.kernel.org/vfs/vfs/c/a4ae47e5d2bc
[5/5] iomap: invert the polarity of IOMAP_DIO_INLINE_COMP
      https://git.kernel.org/vfs/vfs/c/65a466aef147

