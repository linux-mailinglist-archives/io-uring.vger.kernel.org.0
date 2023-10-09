Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657CE7BD1DE
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 04:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjJICGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Oct 2023 22:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjJICGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Oct 2023 22:06:32 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3941A4;
        Sun,  8 Oct 2023 19:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H5J+pmpFJHpxWCN2Cnr5r60MCY9gzXDOvF8T3SwV1Go=; b=hyYaB/z01CgwAt7Psmq4R1on5s
        iTtr+FrM7Qrk7IatWIFutWDQLxBhJQtboPbJry/v0FwDGehndXK29cnxQfJBYo08awDUw2vYjWOkk
        qSObyb3r9mn99hHK+jdvdpODlffmEPp/7Wb/jtrc0r/QIVqG+O5bqcOxfVIl1ckKrxIrbn5u8ppXq
        p7Rjz5kEGq0TwCGhwLOzjv2nfULNuir08PMEURmWARjA1Lx4jyXatACshNZMYdAe+hmmv2xeYlZwY
        DoOu7Lh18lAw+B0/5jcPGDnBjdrrjX/NtyS/OciWoPsRiyEAn2fvmtX5B2Yr8k4M64C9z8p+AFf6P
        uQgvLVkg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpff5-00H42P-1B;
        Mon, 09 Oct 2023 02:06:23 +0000
Date:   Mon, 9 Oct 2023 03:06:23 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH] fs: add AT_EMPTY_PATH support to unlinkat()
Message-ID: <20231009020623.GB800259@ZenIV>
References: <20230929140456.23767-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929140456.23767-1-lhenriques@suse.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 29, 2023 at 03:04:56PM +0100, Luis Henriques wrote:

> -int do_unlinkat(int dfd, struct filename *name)
> +int do_unlinkat(int dfd, struct filename *name, int flags)
>  {
>  	int error;
> -	struct dentry *dentry;
> +	struct dentry *dentry, *parent;
>  	struct path path;
>  	struct qstr last;
>  	int type;
>  	struct inode *inode = NULL;
>  	struct inode *delegated_inode = NULL;
>  	unsigned int lookup_flags = 0;
> -retry:
> -	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
> -	if (error)
> -		goto exit1;
> +	bool empty_path = (flags & AT_EMPTY_PATH);
>  
> -	error = -EISDIR;
> -	if (type != LAST_NORM)
> -		goto exit2;
> +retry:
> +	if (empty_path) {
> +		error = filename_lookup(dfd, name, 0, &path, NULL);
> +		if (error)
> +			goto exit1;
> +		parent = path.dentry->d_parent;
> +		dentry = path.dentry;
> +	} else {
> +		error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
> +		if (error)
> +			goto exit1;
> +		error = -EISDIR;
> +		if (type != LAST_NORM)
> +			goto exit2;
> +		parent = path.dentry;
> +	}
>  
>  	error = mnt_want_write(path.mnt);
>  	if (error)
>  		goto exit2;
>  retry_deleg:
> -	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
> -	dentry = lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
> +	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> +	if (!empty_path)
> +		dentry = lookup_one_qstr_excl(&last, parent, lookup_flags);

For starters, your 'parent' might have been freed under you, just as you'd
been trying to lock its inode.  Or it could have become negative just as you'd
been fetching its ->d_inode, while we are at it.

Races aside, you are changing permissions required for removing files.  For
unlink() you need to be able to get to the parent directory; if it's e.g.
outside of your namespace, you can't do anything to it.  If file had been
opened there by somebody who could reach it and passed to you (via SCM_RIGHTS,
for example) you currently can't remove the sucker.  With this change that
is no longer true.

The same goes for the situation when file is bound into your namespace (or
chroot jail, for that matter).  path.dentry might very well be equal to
root of path.mnt; path.dentry->d_parent might be in part of tree that is
no longer visible *anywhere*.  rmdir() should not be able to do anything
with it...

IMO it's fundamentally broken; not just implementation, but the concept
itself.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
