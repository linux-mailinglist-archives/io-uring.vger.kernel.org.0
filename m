Return-Path: <io-uring+bounces-11626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B17D1C218
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 03:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A676630382AB
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 02:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6F92E401;
	Wed, 14 Jan 2026 02:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="bzoAywCi"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA4B2FD7B1;
	Wed, 14 Jan 2026 02:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768357629; cv=none; b=Bm1UlAztk8s/pzm24Clq4J9bk0hQPwT/jRj+SDGq6a7oEJUs2rV61nIyFGa4wxOwVth1Oob/XyMJu1MDo/1BUWNs444QkeiDM7ReIf4ZtRKgrinsCD+boOwjvj9wAerjUllnIm6ztnkrrQrwyUppAtJct83wruzBgXI/ymC1XPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768357629; c=relaxed/simple;
	bh=KRw0sEW0sfE1PeiOADfC/SViXep7k2UXvxSF+N6fMFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzwMgvIiUplBPqrrdMDGbagub02iKtQ5HI4HJc6Q+32VOQIp2M5Eg+XSU4ihkWjgNS8Ml9T2fufoKwm7USlpyx7//Xs6uXqF+j285YtWU2KEkYchjn6gd9tmrmNXOSSGaAvtDrAXE+vscfRV+pT/AszMFDgTXLZLA5Nu3gtO2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=bzoAywCi; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zUeuKcPL8xR1Vd3/n2rJTuoUFpep1n7NReyWZY7SnbQ=; b=bzoAywCiajDLKB5VPBAbQwpnnR
	DZ9CcgL2np9MCd9eQYOcBh7gq5tgarREAsi1lRMhgThW2C6NnM9nYkkXkkD+seXWaYTbQ3XxBuay1
	UuuquzsvyV59EmLVdRTt0WQFkugoUz3+2wefBXQO1ZltL/xyGaLEOWOzuMB0kuO672Yr/ZXy4/0nN
	VbDzJlMVBxWXzzyesuoTo+OEAeT4tCnUSId+gFRQkyxeMb2VxKdxBweBQSsO/muxSGRxTITRc8Y/X
	G3MQdx5zkEN+CjKFoUt9mihXnvr3zErUM/wOg1HgtVG+HYl660VC54/lE8O/UKqIniRwI4z17Veb7
	eA8WGudg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfqca-0000000G62s-03jQ;
	Wed, 14 Jan 2026 02:28:32 +0000
Date: Wed, 14 Jan 2026 02:28:31 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH 0/8] experimental struct filename followups
Message-ID: <20260114022831.GS3634291@ZenIV>
References: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
 <20260112-manifest-benimm-be85417d4f06@brauner>
 <20260114021547.GR3634291@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114021547.GR3634291@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Jan 14, 2026 at 02:15:47AM +0000, Al Viro wrote:
> 	* Exports.  Currently we have getname_kernel() and putname()
> exported, while the rest of importers is not.  There is exactly one
> module using those - ksmbd, and both users in it are doing only one
> thing to resulting filename: passing it to vfs_path_parent_lookup().
> No other callers of vfs_path_parent_lookup() exist.
> 
> 	Options:
> A) replace vfs_path_parent_lookup() with
> int path_parent_root(const char *filename, unsigned int flags,
>                      struct path *parent, struct qstr *last, int *type,
> 		     const struct path *root)
> {
> 	CLASS(filename_kernel, name)(filename);
> 	return  __filename_parentat(AT_FDCWD, name, flags, parent, last,
> 					    type, root);
> }
> have that exported and used in fs/smb/server/vfs.c instead of
> vfs_path_parent_lookup(); unexport getname_kernel() and putname().

Sorry, can't do - one of those is inside a retry loop.  Pity, that...

