Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D952A30F
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347439AbiEQNSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 09:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbiEQNSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 09:18:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7AE41F94;
        Tue, 17 May 2022 06:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED3C614A4;
        Tue, 17 May 2022 13:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFEAC385B8;
        Tue, 17 May 2022 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652793527;
        bh=/EUREbTS3LyoHsYjut8bYc/O9ZMXv63PeDjg8xMEuoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9zTth6EOx2/k9M4nc62KO2zsWg10ZVl4Tv5nxeCiZbc6X0dtiYYn+9mg7xJ9upxO
         vXs6OYI5PRVbN/lUhNfYTlckpoGQUTWME8hU0+sIGR5uwIGuY0XP6jU6WFBZYvV0+T
         ZXMXB4kuub6Jw0CRT5Hobwvws0w7tjmCxcjH8pek+YZUAawc0WXh91McyOnOyWoVyF
         qMFnyMti61cz5xCupTfJs8guc3e6J09B2PWo6Dwi79R7EXoJ1tEahhWfx844HfWSdN
         5S64GiG0cI/sRXYWRq/R5JVPYcNBzXZR/FLkdTPdF2nQiZnVSjWvrqHZnp9k+eLnDK
         O9+deqmWcMKDw==
Date:   Tue, 17 May 2022 15:18:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 06/16] fs: split off need_remove_file_privs()
 do_remove_file_privs()
Message-ID: <20220517131841.wjuy7mmqo3w2rdsv@wittgenstein>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-7-shr@fb.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 16, 2022 at 09:47:08AM -0700, Stefan Roesch wrote:
> This splits off the function need_remove_file_privs() from the function
> do_remove_file_privs() from the function file_remove_privs().
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

Just a few nits...

>  fs/inode.c | 57 ++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 9d9b422504d1..a6d70a1983f8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2010,17 +2010,8 @@ static int __remove_privs(struct user_namespace *mnt_userns,
>  	return notify_change(mnt_userns, dentry, &newattrs, NULL);
>  }
>  
> -/*
> - * Remove special file priviledges (suid, capabilities) when file is written
> - * to or truncated.
> - */
> -int file_remove_privs(struct file *file)
> +static int need_file_remove_privs(struct inode *inode, struct dentry *dentry)

I'd rather call this file_needs_remove_privs()?

>  {
> -	struct dentry *dentry = file_dentry(file);
> -	struct inode *inode = file_inode(file);
> -	int kill;
> -	int error = 0;
> -
>  	/*
>  	 * Fast path for nothing security related.
>  	 * As well for non-regular files, e.g. blkdev inodes.
> @@ -2030,16 +2021,37 @@ int file_remove_privs(struct file *file)
>  	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
>  		return 0;
>  
> -	kill = dentry_needs_remove_privs(dentry);
> -	if (kill < 0)
> -		return kill;
> -	if (kill)
> -		error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
> +	return dentry_needs_remove_privs(dentry);
> +}
> +
> +static int do_file_remove_privs(struct file *file, struct inode *inode,
> +				struct dentry *dentry, int kill)

and that __file_remove_privs() which matches the rest of the file since
here we don't have a lot of do_* but rather __* convention afaict.

> +{
> +	int error = 0;
> +
> +	error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
>  	if (!error)
>  		inode_has_no_xattr(inode);
>  
>  	return error;
>  }
> +
> +/*
> + * Remove special file privileges (suid, capabilities) when file is written
> + * to or truncated.
> + */
> +int file_remove_privs(struct file *file)

This is a generic comment, not aimed specifically at your change but we
really need to get better at kernel-doc...

Since you're already touching this code could you at least to the
exported function you're modifying add sm like:

/**
 * file_remove_privs - remove special file privileges (suid, capabilities) 
 * @file: file to remove privileges from
 * 
 * When file is modified by a write or truncation ensure that special
 * file privileges are removed.
 *
 * Return: 0 on success, negative errno on failure.
 */
int file_remove_privs(struct file *file)

This will then render on kernel.org/doc see e.g. lookup_one():
https://www.kernel.org/doc/html/latest/filesystems/api-summary.html?highlight=lookup_one#c.lookup_one

> +{
> +	struct dentry *dentry = file_dentry(file);
> +	struct inode *inode = file_inode(file);
> +	int kill;
> +
> +	kill = need_file_remove_privs(inode, dentry);
> +	if (kill <= 0)
> +		return kill;
> +
> +	return do_file_remove_privs(file, inode, dentry, kill);
> +}
>  EXPORT_SYMBOL(file_remove_privs);
>  
>  /**
> @@ -2093,15 +2105,22 @@ EXPORT_SYMBOL(file_update_time);
>  /* Caller must hold the file's inode lock */
>  int file_modified(struct file *file)

Similar I'd add sm like:

/**
 * file_modified - handle mandated vfs changes when modifying a file
 * @file: file that was was modified
 * 
 * When file has been modified ensure that special
 * file privileges are removed and time settings are updated.
 *
 * Context: Caller must hold the file's inode lock.
 *
 * Return: 0 on success, negative errno on failure.
 */
int file_remove_privs(struct file *file)

>  {
> -	int err;
> +	int ret;
> +	struct dentry *dentry = file_dentry(file);
> +	struct inode *inode = file_inode(file);
>  
>  	/*
>  	 * Clear the security bits if the process is not being run by root.
>  	 * This keeps people from modifying setuid and setgid binaries.
>  	 */
> -	err = file_remove_privs(file);
> -	if (err)
> -		return err;
> +	ret = need_file_remove_privs(inode, dentry);
> +	if (ret < 0) {
> +		return ret;
> +	} else if (ret > 0) {
> +		ret = do_file_remove_privs(file, inode, dentry, ret);
> +		if (ret)
> +			return ret;
> +	}

The else-if branch looks a bit unorthodox to me. I'd probably rather
make this:

	ret = need_file_remove_privs(inode, dentry);
	if (ret < 0)
		return ret;
	
	if (ret > 0) {
		ret = do_file_remove_privs(file, inode, dentry, ret);
		if (ret)
			return ret;
	}
>  
>  	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>  		return 0;
> -- 
> 2.30.2
> 
