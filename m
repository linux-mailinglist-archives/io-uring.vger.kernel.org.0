Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0C53B5A0
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 11:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiFBJAK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 05:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiFBJAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 05:00:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEE4201FCC;
        Thu,  2 Jun 2022 02:00:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 359921F896;
        Thu,  2 Jun 2022 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654160399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ijo1/KEHcpVXOlVT44hrqS2IKLNCLVEBAwl1vFY0TA=;
        b=DD0J5dXdELDAuit1IL7OilJ6UQT9W/wwLcjy8W8o4G4lqsTGSvrwQWEarnEtVrZKH7vzNe
        htSZjAVyrxWFfQ1gBUS+j+EILArB9VOOe145jGMe+1UPeFsxNdxs2PIEDVRYtCEDSCtMpY
        1vkbNsvKCuE7lrPVdaWxH8jcJNZl8hI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654160399;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ijo1/KEHcpVXOlVT44hrqS2IKLNCLVEBAwl1vFY0TA=;
        b=P/L0tiYJhwQapcna9rCHSysbiguI1WylnEANvICiQU0B5K89dnuVBmGkvNhOWelzNY59nf
        IkrXxLO6bxgZPUAA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 20B852C141;
        Thu,  2 Jun 2022 08:59:59 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id BFC14A0633; Thu,  2 Jun 2022 10:59:58 +0200 (CEST)
Date:   Thu, 2 Jun 2022 10:59:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 11/15] fs: Optimization for concurrent file time
 updates.
Message-ID: <20220602085958.z2gosfb3ul7fa4o3@quack3.lan>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-12-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-12-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 01-06-22 14:01:37, Stefan Roesch wrote:
> This introduces the S_PENDING_TIME flag. If an async buffered write
> needs to update the time, it cannot be processed in the fast path of
> io-uring. When a time update is pending this flag is set for async
> buffered writes. Other concurrent async buffered writes for the same
> file do not need to wait while this time update is pending.
> 
> This reduces the number of async buffered writes that need to get punted
> to the io-workers in io-uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Thinking about this, there is a snag with this S_PENDING_TIME scheme. It
can happen that we report write as completed to userspace before timestamps
are actually updated. So following stat(2) can still return old time stamp
which might confuse some userspace application. It might be even nastier
with i_version which is used by NFS and can thus cause data consistency
issues for NFS.

								Honza

> ---
>  fs/inode.c         | 11 +++++++++--
>  include/linux/fs.h |  3 +++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 4503bed063e7..7185d860d423 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2150,10 +2150,17 @@ static int file_modified_flags(struct file *file, int flags)
>  	ret = inode_needs_update_time(inode, &now);
>  	if (ret <= 0)
>  		return ret;
> -	if (flags & IOCB_NOWAIT)
> +	if (flags & IOCB_NOWAIT) {
> +		if (IS_PENDING_TIME(inode))
> +			return 0;
> +
> +		inode_set_flags(inode, S_PENDING_TIME, S_PENDING_TIME);
>  		return -EAGAIN;
> +	}
>  
> -	return __file_update_time(file, &now, ret);
> +	ret = __file_update_time(file, &now, ret);
> +	inode_set_flags(inode, 0, S_PENDING_TIME);
> +	return ret;
>  }
>  
>  /**
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 553e57ec3efa..15f9a7beba55 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2151,6 +2151,8 @@ struct super_operations {
>  #define S_CASEFOLD	(1 << 15) /* Casefolded file */
>  #define S_VERITY	(1 << 16) /* Verity file (using fs/verity/) */
>  #define S_KERNEL_FILE	(1 << 17) /* File is in use by the kernel (eg. fs/cachefiles) */
> +#define S_PENDING_TIME (1 << 18) /* File update time is pending */
> +
>  
>  /*
>   * Note that nosuid etc flags are inode-specific: setting some file-system
> @@ -2193,6 +2195,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
>  #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
>  #define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
>  #define IS_VERITY(inode)	((inode)->i_flags & S_VERITY)
> +#define IS_PENDING_TIME(inode) ((inode)->i_flags & S_PENDING_TIME)
>  
>  #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
>  				 (inode)->i_rdev == WHITEOUT_DEV)
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
