Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E866D53B54F
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 10:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiFBIoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 04:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiFBIoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 04:44:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC5038D85;
        Thu,  2 Jun 2022 01:44:03 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6F89721B1F;
        Thu,  2 Jun 2022 08:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654159442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hFYJc+foy0kL9AQh3F2/xhQWy8ou48B+B8HKY3UwAao=;
        b=rF1vC06UFf+8ahNW34M/a5R0s6h+SOT9rzekfmKAQKR5o0m5fT+cfrM87kxaKY6abayhCs
        im7mz1hzHuil+Ee/udcpBzD2vmeDLFnertXuVKq/FYbYVRvFRh6c0uMFJ4/ByBkWSu62w2
        5Jzq/V6wOMoUqjvV72uhhT2BwCUuLB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654159442;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hFYJc+foy0kL9AQh3F2/xhQWy8ou48B+B8HKY3UwAao=;
        b=evLTtgjsj/1Qiv+nnXaQPZ2fzhM9ic9DBvG36WT/b/J1RCH555s7OCcWcztOC2Gz4pUO5x
        GedJZ5oRDu6pQmAQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A5ED2C141;
        Thu,  2 Jun 2022 08:44:02 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E4475A0633; Thu,  2 Jun 2022 10:44:01 +0200 (CEST)
Date:   Thu, 2 Jun 2022 10:44:01 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 09/15] fs: Split off inode_needs_update_time and
 __file_update_time
Message-ID: <20220602084401.iahhjzompyn5nejx@quack3.lan>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-10-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 01-06-22 14:01:35, Stefan Roesch wrote:
> This splits off the functions inode_needs_update_time() and
> __file_update_time() from the function file_update_time().
> 
> This is required to support async buffered writes.
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 76 +++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 50 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index ac1cf5aa78c8..c44573a32c6a 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2049,35 +2049,18 @@ int file_remove_privs(struct file *file)
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
> +static int inode_needs_update_time(struct inode *inode, struct timespec64 *now)
>  {
> -	struct inode *inode = file_inode(file);
> -	struct timespec64 now;
>  	int sync_it = 0;
> -	int ret;
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
> @@ -2086,15 +2069,50 @@ int file_update_time(struct file *file)
>  	if (!sync_it)
>  		return 0;
>  
> -	/* Finally allowed to write? Takes lock. */
> -	if (__mnt_want_write_file(file))
> -		return 0;
> +	return sync_it;
> +}
> +
> +static int __file_update_time(struct file *file, struct timespec64 *now,
> +			int sync_mode)
> +{
> +	int ret = 0;
> +	struct inode *inode = file_inode(file);
>  
> -	ret = inode_update_time(inode, &now, sync_it);
> -	__mnt_drop_write_file(file);
> +	/* try to update time settings */
> +	if (!__mnt_want_write_file(file)) {
> +		ret = inode_update_time(inode, now, sync_mode);
> +		__mnt_drop_write_file(file);
> +	}
>  
>  	return ret;
>  }
> +
> + /**
> +  * file_update_time - update mtime and ctime time
> +  * @file: file accessed
> +  *
> +  * Update the mtime and ctime members of an inode and mark the inode for
> +  * writeback. Note that this function is meant exclusively for usage in
> +  * the file write path of filesystems, and filesystems may choose to
> +  * explicitly ignore updates via this function with the _NOCMTIME inode
> +  * flag, e.g. for network filesystem where these imestamps are handled
> +  * by the server. This can return an error for file systems who need to
> +  * allocate space in order to update an inode.
> +  *
> +  * Return: 0 on success, negative errno on failure.
> +  */
> +int file_update_time(struct file *file)
> +{
> +	int ret;
> +	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
> +
> +	ret = inode_needs_update_time(inode, &now);
> +	if (ret <= 0)
> +		return ret;
> +
> +	return __file_update_time(file, &now, ret);
> +}
>  EXPORT_SYMBOL(file_update_time);
>  
>  /**
> @@ -2111,6 +2129,8 @@ EXPORT_SYMBOL(file_update_time);
>  int file_modified(struct file *file)
>  {
>  	int ret;
> +	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
>  
>  	/*
>  	 * Clear the security bits if the process is not being run by root.
> @@ -2123,7 +2143,11 @@ int file_modified(struct file *file)
>  	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>  		return 0;
>  
> -	return file_update_time(file);
> +	ret = inode_needs_update_time(inode, &now);
> +	if (ret <= 0)
> +		return ret;
> +
> +	return __file_update_time(file, &now, ret);
>  }
>  EXPORT_SYMBOL(file_modified);
>  
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
