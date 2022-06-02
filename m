Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A7953B5A8
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiFBJE0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 05:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiFBJEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 05:04:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255E629567F;
        Thu,  2 Jun 2022 02:04:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D5D4D1F8C7;
        Thu,  2 Jun 2022 09:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654160662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JE43XyBt4F5UgiXwc28I6/EZJk5orkohdPvv7VBq3fc=;
        b=1EygryP8IZBxvX5Dm8V9QrLjLSUC5warF6xeSo7WDFTpuDOLZtYse5K3UYInwH7Uji/Yk8
        9/DU+l++DiAqxrL6UlAAXhKZEynEINg+In9DAGX91t/phB/gzj64O3OqVOx7olrxZlNZ1v
        t8pvgkUqvkjKehd81PQGqWLsGS8nkYM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654160662;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JE43XyBt4F5UgiXwc28I6/EZJk5orkohdPvv7VBq3fc=;
        b=lqHGf8ktY+F61PtWn475PsO8oaOQmFYHWYtnt1vYxO0mTRqfhECY/wOP4uiefU8mzp/Bfq
        6i1aw7cPWfQEnJDQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C14E52C141;
        Thu,  2 Jun 2022 09:04:22 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 76764A0633; Thu,  2 Jun 2022 11:04:22 +0200 (CEST)
Date:   Thu, 2 Jun 2022 11:04:22 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 08/15] fs: add __remove_file_privs() with flags
 parameter
Message-ID: <20220602090422.jkqou4ydyxxqiwsw@quack3.lan>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-9-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-9-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 01-06-22 14:01:34, Stefan Roesch wrote:
> This adds the function __remove_file_privs, which allows the caller to
> pass the kiocb flags parameter.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 57 +++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 9d9b422504d1..ac1cf5aa78c8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2010,36 +2010,43 @@ static int __remove_privs(struct user_namespace *mnt_userns,
>  	return notify_change(mnt_userns, dentry, &newattrs, NULL);
>  }
>  
> -/*
> - * Remove special file priviledges (suid, capabilities) when file is written
> - * to or truncated.
> - */
> -int file_remove_privs(struct file *file)
> +static int __file_remove_privs(struct file *file, unsigned int flags)
>  {
>  	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = file_inode(file);
> +	int error;
>  	int kill;
> -	int error = 0;
>  
> -	/*
> -	 * Fast path for nothing security related.
> -	 * As well for non-regular files, e.g. blkdev inodes.
> -	 * For example, blkdev_write_iter() might get here
> -	 * trying to remove privs which it is not allowed to.
> -	 */
>  	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
>  		return 0;
>  
>  	kill = dentry_needs_remove_privs(dentry);
> -	if (kill < 0)
> +	if (kill <= 0)
>  		return kill;
> -	if (kill)
> -		error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
> +
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
> +
> +	error = __remove_privs(file_mnt_user_ns(file), dentry, kill);
>  	if (!error)
>  		inode_has_no_xattr(inode);
>  
>  	return error;
>  }
> +
> +/**
> + * file_remove_privs - remove special file privileges (suid, capabilities)
> + * @file: file to remove privileges from
> + *
> + * When file is modified by a write or truncation ensure that special
> + * file privileges are removed.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int file_remove_privs(struct file *file)
> +{
> +	return __file_remove_privs(file, 0);
> +}
>  EXPORT_SYMBOL(file_remove_privs);
>  
>  /**
> @@ -2090,18 +2097,28 @@ int file_update_time(struct file *file)
>  }
>  EXPORT_SYMBOL(file_update_time);
>  
> -/* Caller must hold the file's inode lock */
> +/**
> + * file_modified - handle mandated vfs changes when modifying a file
> + * @file: file that was modified
> + *
> + * When file has been modified ensure that special
> + * file privileges are removed and time settings are updated.
> + *
> + * Context: Caller must hold the file's inode lock.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
>  int file_modified(struct file *file)
>  {
> -	int err;
> +	int ret;
>  
>  	/*
>  	 * Clear the security bits if the process is not being run by root.
>  	 * This keeps people from modifying setuid and setgid binaries.
>  	 */
> -	err = file_remove_privs(file);
> -	if (err)
> -		return err;
> +	ret = __file_remove_privs(file, 0);
> +	if (ret)
> +		return ret;
>  
>  	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>  		return 0;
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
