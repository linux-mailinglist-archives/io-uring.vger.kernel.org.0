Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2552A3A7
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245528AbiEQNlm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 09:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346978AbiEQNk5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 09:40:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0603DA1B2;
        Tue, 17 May 2022 06:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97EF46151C;
        Tue, 17 May 2022 13:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C7FC34113;
        Tue, 17 May 2022 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652794855;
        bh=DtXyuYsoVHp4WKCWrjxULv0/73a7Urgp+edL/JG+Lck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rkqm0KO5f/hKnhFTEmPFWLA2L1VS5S3viQFX/ROdgk8v6vbyT+SZrLav6CqMz/Tif
         0F/zjJx2agc3078IjxhCQlMu+TKtoUse2hukZj1zr41ICc3206eF+TWjzp8a6kFbue
         JC3Kv8W0xU/JFu3t05MGhmeZFvaZVBqf5SBW2aftP1+Q19t//llBp9g20IYYs2aqI9
         mUsiU+3wX0pPCJnGx6PZzQ27f+aAQXHWC1K1Vx22MIiKVn1xcsHoMDnmtksDCTG9HL
         0NwE0qYSezpPwz/Yx1VubMbgovRDEnGttZxVHOD4/lWCi/JsPMH0oeP7vH5njZQWCf
         pgzA6zO1Pje/A==
Date:   Tue, 17 May 2022 15:40:49 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 07/16] fs: split off need_file_update_time and
 do_file_update_time
Message-ID: <20220517134049.tfxbsbdscalblsmv@wittgenstein>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-8-shr@fb.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 16, 2022 at 09:47:09AM -0700, Stefan Roesch wrote:
> This splits off the functions need_file_update_time() and
> do_file_update_time() from the function file_update_time().
> 
> This is required to support async buffered writes.
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/inode.c | 71 ++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 47 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index a6d70a1983f8..1d0b02763e98 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2054,35 +2054,22 @@ int file_remove_privs(struct file *file)
>  }
>  EXPORT_SYMBOL(file_remove_privs);
>  
> -/**
> - *	file_update_time	-	update mtime and ctime time
> - *	@file: file accessed
> - *
> - *	Update the mtime and ctime members of an inode and mark the inode
> - *	for writeback.  Note that this function is meant exclusively for
> - *	usage in the file write path of filesystems, and filesystems may
> - *	choose to explicitly ignore update via this function with the
> - *	S_NOCMTIME inode flag, e.g. for network filesystem where these
> - *	timestamps are handled by the server.  This can return an error for
> - *	file systems who need to allocate space in order to update an inode.
> - */
> -
> -int file_update_time(struct file *file)
> +static int need_file_update_time(struct inode *inode, struct file *file,
> +				struct timespec64 *now)

I think file_need_update_time() is easier to understand.

>  {
> -	struct inode *inode = file_inode(file);
> -	struct timespec64 now;
>  	int sync_it = 0;
> -	int ret;
> +
> +	if (unlikely(file->f_mode & FMODE_NOCMTIME))
> +		return 0;

Moving this into this generic helper and using the generic helper
directly in file_update_atime() leads to a change in behavior for
file_update_time() callers. Currently they'd get time settings updated
even if FMODE_NOCMTIME is set but with this change they'd not get it
updated anymore if FMODE_NOCMTIME is set. Am I reading this right?

Is this a bugfix? And if so it should be split into a separate commit...

>  
>  	/* First try to exhaust all avenues to not sync */
>  	if (IS_NOCMTIME(inode))
>  		return 0;
>  
> -	now = current_time(inode);
> -	if (!timespec64_equal(&inode->i_mtime, &now))
> +	if (!timespec64_equal(&inode->i_mtime, now))
>  		sync_it = S_MTIME;
>  
> -	if (!timespec64_equal(&inode->i_ctime, &now))
> +	if (!timespec64_equal(&inode->i_ctime, now))
>  		sync_it |= S_CTIME;
>  
>  	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
> @@ -2091,15 +2078,49 @@ int file_update_time(struct file *file)
>  	if (!sync_it)
>  		return 0;
>  
> +	return sync_it;
> +}
> +
> +static int do_file_update_time(struct inode *inode, struct file *file,
> +			struct timespec64 *now, int sync_mode)
> +{
> +	int ret;
> +
>  	/* Finally allowed to write? Takes lock. */
>  	if (__mnt_want_write_file(file))
>  		return 0;
>  
> -	ret = inode_update_time(inode, &now, sync_it);
> +	ret = inode_update_time(inode, now, sync_mode);
>  	__mnt_drop_write_file(file);
>  
>  	return ret;
>  }

Maybe

static int __file_update_time(struct inode *inode, struct file *file,
			      struct timespec64 *now, int sync_mode)
{
	int ret = 0;

	/* try to update time settings */
	if (!__mnt_want_write_file(file)) {
		ret = inode_update_time(inode, now, sync_mode);
		__mnt_drop_write_file(file);
	}

	return ret;
}

reads a little easier and the old comment is a bit confusing imho. I'd
just say we keep it short. 

> +
> +/**
> + *	file_update_time	-	update mtime and ctime time
> + *	@file: file accessed
> + *
> + *	Update the mtime and ctime members of an inode and mark the inode
> + *	for writeback.  Note that this function is meant exclusively for
> + *	usage in the file write path of filesystems, and filesystems may
> + *	choose to explicitly ignore update via this function with the
> + *	S_NOCMTIME inode flag, e.g. for network filesystem where these
> + *	timestamps are handled by the server.  This can return an error for
> + *	file systems who need to allocate space in order to update an inode.
> + */
> +
> +int file_update_time(struct file *file)

My same lame complaint as before to make this kernel-doc. :)

/**
 * file_update_time - update mtime and ctime time
 * @file: file accessed
 *
 * Update the mtime and ctime members of an inode and mark the inode or
 * writeback. Note that this function is meant exclusively for sage in
 * the file write path of filesystems, and filesystems may hoose to
 * explicitly ignore update via this function with the _NOCMTIME inode
 * flag, e.g. for network filesystem where these imestamps are handled
 * by the server. This can return an error for ile systems who need to
 * allocate space in order to update an inode.
 *
 * Return: 0 on success, negative errno on failure.
 */
int file_update_time(struct file *file)

> +{
> +	int err;
> +	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
> +
> +	err = need_file_update_time(inode, file, &now);
> +	if (err < 0)
> +		return err;

I may misread this but shouldn't this be err <= 0, i.e., if it returns 0
then we don't need to update time?

> +
> +	return do_file_update_time(inode, file, &now, err);
> +}
>  EXPORT_SYMBOL(file_update_time);
>  
>  /* Caller must hold the file's inode lock */
> @@ -2108,6 +2129,7 @@ int file_modified(struct file *file)
>  	int ret;
>  	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
>  
>  	/*
>  	 * Clear the security bits if the process is not being run by root.
> @@ -2122,10 +2144,11 @@ int file_modified(struct file *file)
>  			return ret;
>  	}
>  
> -	if (unlikely(file->f_mode & FMODE_NOCMTIME))
> -		return 0;
> +	ret = need_file_update_time(inode, file, &now);
> +	if (ret <= 0)
> +		return ret;
>  
> -	return file_update_time(file);
> +	return do_file_update_time(inode, file, &now, ret);
>  }
>  EXPORT_SYMBOL(file_modified);
>  
> -- 
> 2.30.2
> 
