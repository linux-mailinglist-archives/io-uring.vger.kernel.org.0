Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309A953B555
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 10:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiFBIpC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 04:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiFBIo5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 04:44:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E73D1EDD1A;
        Thu,  2 Jun 2022 01:44:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D138421B24;
        Thu,  2 Jun 2022 08:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654159494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S2GAifzgoN5qperBFrPRQqqXGrgJ2Ve4bhJ9JZz2TjQ=;
        b=1ZYukKT+NhPuSmeueIcsKDqNOufRFsNPY/kw5uOtt5anATUAbbS6l8ZNuCBNb+SOD8VXiq
        GYxFoGa2i3Dgn9rbTd3esYgGdvpzVXFHg03yQZZ8ej5AFCtgCnFZHDWaHG5ESSsiN0lkBs
        SO/C7Z/SzrJe0Pe9KZx/vnPF1J9Xg8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654159494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S2GAifzgoN5qperBFrPRQqqXGrgJ2Ve4bhJ9JZz2TjQ=;
        b=323tc8bIu3tL/1FOjB5RYKBrHju575zOeDEXKvZv0sRYcMkPtcAyzMEt9RqQGtuj8eH5cc
        NPutDATJm8rAkTDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BD1A52C141;
        Thu,  2 Jun 2022 08:44:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 6899CA0633; Thu,  2 Jun 2022 10:44:54 +0200 (CEST)
Date:   Thu, 2 Jun 2022 10:44:54 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 10/15] fs: Add async write file modification handling.
Message-ID: <20220602084454.2uj4ehvzm3eav5ww@quack3.lan>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-11-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-11-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 01-06-22 14:01:36, Stefan Roesch wrote:
> This adds a file_modified_async() function to return -EAGAIN if the
> request either requires to remove privileges or needs to update the file
> modification time. This is required for async buffered writes, so the
> request gets handled in the io worker of io-uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c         | 43 +++++++++++++++++++++++++++++++++++++++++--
>  include/linux/fs.h |  1 +
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index c44573a32c6a..4503bed063e7 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2116,17 +2116,21 @@ int file_update_time(struct file *file)
>  EXPORT_SYMBOL(file_update_time);
>  
>  /**
> - * file_modified - handle mandated vfs changes when modifying a file
> + * file_modified_flags - handle mandated vfs changes when modifying a file
>   * @file: file that was modified
> + * @flags: kiocb flags
>   *
>   * When file has been modified ensure that special
>   * file privileges are removed and time settings are updated.
>   *
> + * If IOCB_NOWAIT is set, special file privileges will not be removed and
> + * time settings will not be updated. It will return -EAGAIN.
> + *
>   * Context: Caller must hold the file's inode lock.
>   *
>   * Return: 0 on success, negative errno on failure.
>   */
> -int file_modified(struct file *file)
> +static int file_modified_flags(struct file *file, int flags)
>  {
>  	int ret;
>  	struct inode *inode = file_inode(file);
> @@ -2146,11 +2150,46 @@ int file_modified(struct file *file)
>  	ret = inode_needs_update_time(inode, &now);
>  	if (ret <= 0)
>  		return ret;
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
>  
>  	return __file_update_time(file, &now, ret);
>  }
> +
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
> +int file_modified(struct file *file)
> +{
> +	return file_modified_flags(file, 0);
> +}
>  EXPORT_SYMBOL(file_modified);
>  
> +/**
> + * kiocb_modified - handle mandated vfs changes when modifying a file
> + * @iocb: iocb that was modified
> + *
> + * When file has been modified ensure that special
> + * file privileges are removed and time settings are updated.
> + *
> + * Context: Caller must hold the file's inode lock.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int kiocb_modified(struct kiocb *iocb)
> +{
> +	return file_modified_flags(iocb->ki_filp, iocb->ki_flags);
> +}
> +EXPORT_SYMBOL_GPL(kiocb_modified);
> +
>  int inode_needs_sync(struct inode *inode)
>  {
>  	if (IS_SYNC(inode))
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bdf1ce48a458..553e57ec3efa 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2392,6 +2392,7 @@ static inline void file_accessed(struct file *file)
>  }
>  
>  extern int file_modified(struct file *file);
> +int kiocb_modified(struct kiocb *iocb);
>  
>  int sync_inode_metadata(struct inode *inode, int wait);
>  
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
