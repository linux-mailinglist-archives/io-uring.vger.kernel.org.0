Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3663B53B5B2
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 11:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiFBJGJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 05:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiFBJGI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 05:06:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9900C2A8938;
        Thu,  2 Jun 2022 02:06:07 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3A71E1F896;
        Thu,  2 Jun 2022 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654160766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l44OiN4vGsVRHdHSJpLd57m3bWaWVKtWFbpqAF/m3Hw=;
        b=IxO/2d65WpbLfgT9ufhIODXn8IDb6XexQj96IdG/+xe9xZAFOlthz5ydM4D+gQdqv/wOLi
        yzDHydgAaJS3rjmE8DT14HsvXDc6bqyn+mlgB2E4Lvhfu0VSP/r54sL9BO0k21py9kUaol
        FKQNgrx5UlOGtc9I74/dNfmWy6B8B8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654160766;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l44OiN4vGsVRHdHSJpLd57m3bWaWVKtWFbpqAF/m3Hw=;
        b=rL7AE+O3o++6U8Y/ThRpbtwrlDsJCIUE0IVzvjk0Dr079n9JfocAZbdYO1tOjO1VnlxrXs
        L2W4QubcBnbv+ADQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2744A2C141;
        Thu,  2 Jun 2022 09:06:06 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C23B8A0633; Thu,  2 Jun 2022 11:06:05 +0200 (CEST)
Date:   Thu, 2 Jun 2022 11:06:05 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 10/15] fs: Add async write file modification handling.
Message-ID: <20220602090605.ulwxr4edbrsgdxtl@quack3.lan>
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

I've found one small bug here:

> diff --git a/fs/inode.c b/fs/inode.c
> index c44573a32c6a..4503bed063e7 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
...
> -int file_modified(struct file *file)
> +static int file_modified_flags(struct file *file, int flags)
>  {
>  	int ret;
>  	struct inode *inode = file_inode(file);

We need to use 'flags' for __file_remove_privs_flags() call in this patch.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
