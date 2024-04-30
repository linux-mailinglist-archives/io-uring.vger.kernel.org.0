Return-Path: <io-uring+bounces-1685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 699EC8B75E6
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 14:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A6B61F22498
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F72A171089;
	Tue, 30 Apr 2024 12:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFPOBSoY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D4F13F43D;
	Tue, 30 Apr 2024 12:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480836; cv=none; b=kDjq1IQ++tJIhaEpOslMYWYLLhMTXYWYfwjfnYt115NufxMQpLgQ9At1JVQ/JWU69zcw01CpjpdD2dv+ZJoGWOPlBB68f5tr2pSBJ0R0SOw/wunsrWczKHw/4YTUabjX/z02qHT8Dh95ahtECGHdIV0jqT0Bq9O5ojgguhV7Lwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480836; c=relaxed/simple;
	bh=L1Aic3xKzmIUnbMtx7dn18xXuu7pZty9NcrqDKTeuSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKWd8ssXUeHCKWJblb1Ji+myyXaGb2PNhm5hBeuynOW4E60IkE4J74JnTdZSMcuhbA1AAB4/GtqLjmBd+K5QxyeBgfwGKW0IPZVtatOGsIhRLFk4S++7e4V4nS2g2W0sEWp4B4y97ys5aXi+h/9JevxAuzh/S3nFgZLSd0cPIJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFPOBSoY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BEFC2BBFC;
	Tue, 30 Apr 2024 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714480835;
	bh=L1Aic3xKzmIUnbMtx7dn18xXuu7pZty9NcrqDKTeuSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFPOBSoYBWDlnA1pUzMNku5YhKYgJIyeFt+nCXrgIDzAbVv6chpGNDPF2tp25cwSt
	 bOgUAhhMoZlvRJEgG9hu86gODCfiDkPOj9YQpIJ/kA/NLknUP7pKeJw8DgYQFEeL21
	 r4edywvo2zCazHNSN+o/2YibPIBxeacaHPl5VKu6Nk8Vn7Oz/SracQ9Q4VqUSsA3ca
	 dGEMBNGZ3/H9dJ7lUFFn6VaYOC9btjdPKDqc5t8YioS1Jj/11mSgYl1eqZ3wNAB3OA
	 j3yMoy211eF0DNz6lld3xsQT4gZ+mbOOJW9I76K0V/y3/wktoX+j2qElTEOaPOOn3j
	 gGRw3ouNI+Vng==
From: Christian Brauner <brauner@kernel.org>
To: cgzones@googlemail.com,
	cgoettsche@seltendoof.de
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 1/2] fs: rename struct xattr_ctx to kernel_xattr_ctx
Date: Tue, 30 Apr 2024 14:40:15 +0200
Message-ID: <20240430-machbar-jogginganzug-7fd3cff2c3ed@brauner>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240426162042.191916-2-cgoettsche@seltendoof.de>
References: <20240426162042.191916-1-cgoettsche@seltendoof.de> <20240426162042.191916-2-cgoettsche@seltendoof.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1792; i=brauner@kernel.org; h=from:subject:message-id; bh=L1Aic3xKzmIUnbMtx7dn18xXuu7pZty9NcrqDKTeuSY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQZPNvp2Bi3a/usql//CnpXfvbykf/aFlH/fJNtQJZt1 AoHUz2mjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk4MDAy/FdaeEPxYKpuavrU /9sigo+8NnrBq22wZLL4tO7pdg+UtjEyXGvwW6Z/6keDpOsz0fh52/4klhgsb/H6cMnXN9vo/EJ hJgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 26 Apr 2024 18:20:15 +0200, Christian Göttsche wrote:
> Rename the struct xattr_ctx to increase distinction with the about to be
> added user API struct xattr_args.
> 
> No functional change.
> 
> 

So I've picked that series up as this is still a useful addition.
Obviously too late for this merge window.

However, I stated multiple times that we're not going to add *xattrat()
variants that allow to set or get xattrs with AT_EMPTY_PATH on O_PATH
file descriptors. Not just because conceptually setting and getting
xattrs should be treated akin to read/write wrt to O_PATH but also
because it makes the concept of an O_PATH more and more meaningless if
we can do ever more things we it.

But it will also break assumptions of code that would be surprised if an
O_PATH fd suddenly can be used to set and get xattr. So I'll fix it up
so AT_EMPTY_PATH is handled to exclude O_PATH file descriptors.

---

Applied to the vfs.xattr branch of the vfs/vfs.git tree.
Patches in the vfs.xattr branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.xattr

[1/2] fs: rename struct xattr_ctx to kernel_xattr_ctx
      https://git.kernel.org/vfs/vfs/c/836c8e8bb147
[2/2] fs/xattr: add *at family syscalls
      https://git.kernel.org/vfs/vfs/c/71491cbe0205

