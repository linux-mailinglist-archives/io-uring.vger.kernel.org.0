Return-Path: <io-uring+bounces-10782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0583BC842FD
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 10:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 909453A494D
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 09:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222922417C3;
	Tue, 25 Nov 2025 09:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sctjiYa/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB9A263F54;
	Tue, 25 Nov 2025 09:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764062319; cv=none; b=o3d70eGqDmJ/qspVfoSiqOrMneSs6LqGGyIAhRoK5NV1GvEVbT9r/qX8s8Ju8bt/WmriUFOgshE53gQH1PufGvQGq2NJhHkfOQtHsmyE+ktpjlsYfOLliFocm7oyfQXXqc85toCHL91A8g3ybVSUppzHuWZGqFlipbpS/XDRJ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764062319; c=relaxed/simple;
	bh=U9iYrYsglLkG8TnBDbI9yrwUWiI8plUWD8Oh3w7r1lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pug8qhPlHqLSY3p2qkdJb/rZI/H3zF1g2ZKKsdS++5sflR683fnaXiQ+5Z8mcpD1+7QO94sTfFlrY+bdFBLzsctoiciHztP0csErL/NUcQxKibqkJL4I3XH9V6ZxaO87wMGVRT9Ci3Mt+bTPhkaLNN5lMVTsa78YPQzsJiImAeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sctjiYa/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62470C4CEF1;
	Tue, 25 Nov 2025 09:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764062318;
	bh=U9iYrYsglLkG8TnBDbI9yrwUWiI8plUWD8Oh3w7r1lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sctjiYa/DATKoaFc3hWyAe155qdsmeZ0LOX1jyiLgNBS5DiZw+4snbDy8w3moMIlw
	 qD25hlXOxRpAQw7ks/SOJcVlNOSn2alp+vSe+skncJ9fnv47blkRv/OO1HEnfaLieL
	 Pdfx8nRHNYcPX7bTnyTH+HvgbdCM1/yJVva5Dr3pvCvteXBjjd4kwFh15WUdPqWtXT
	 KDE5JgmgqxTmE7mMVxru75iVNEw+PlMkuj4dLF4KAWCHoOTXoPZcis8CK0XFDtFgFD
	 fKp2aeOAxiijY6s+DoOEPPdvCjJNOF89n2osZI1BVl6VydJ00KKVQTPicDc0+hBj82
	 /u0YfbHQEuJ6g==
Date: Tue, 25 Nov 2025 10:18:32 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, 
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, 
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v2
Message-ID: <20251125-loten-fabuliert-c0fb6b195b53@brauner>
References: <20251120064859.2911749-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>

On Thu, Nov 20, 2025 at 07:47:21AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> commit 66fa3cedf16a ("fs: Add async write file modification handling.")
> effectively disabled IOCB_NOWAIT writes as timestamp updates currently
> always require blocking, and the modern timestamp resolution means we
> always update timestamps.  This leads to a lot of context switches from
> applications using io_uring to submit file writes, making it often worse
> than using the legacy aio code that is not using IOCB_NOWAIT.
> 
> This series allows non-blocking updates for lazytime if the file system
> supports it, and adds that support for XFS.
> 
> It also fixes the layering bypass in btrfs when updating timestamps on
> device files for devices removed from btrfs usage, and FMODE_NOCMTIME
> handling in the VFS now that nfsd started using it.  Note that I'm still
> not sure that nfsd usage is fully correct for all file systems, as only
> XFS explicitly supports FMODE_NOCMTIME, but at least the generic code
> does the right thing now.

It's a bit too close to the merge window for my taste and we have about
17 pull request topics for this cycle already.

So I'll take this for vfs-6.20.iomap. As usual I'll create that branch
now so that the patches don't get lost and will rebase once v6.19-rc1 is
out.

