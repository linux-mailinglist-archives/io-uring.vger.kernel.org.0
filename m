Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6081495DE
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 14:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAYNPE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 08:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgAYNPE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 25 Jan 2020 08:15:04 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B49742071A;
        Sat, 25 Jan 2020 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579958103;
        bh=YrMaopeIElCm2701zXAtNoG1FrkPY4mNmwga5Vke9n4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HM43GISKiUCkOtHkoJRrPKD5WczChvI38tbKfD4ANX9ncuxa/uPdT4u+2dBTyQ/IT
         NeLbmh2O77B/K9MUJMiaLZDhQ/EmeEpn567LBNLCmTp2Zi4S1Tn8L5py9qPqMRdpvu
         1BONPIqXGp+WRu87wcrIpBpQG0FqMsth4/ngMNP0=
Message-ID: <c49d8fb5f7a056cddfa19f9b48af878ac14536d2.camel@kernel.org>
Subject: Re: [PATCH 1/6] fs: add namei support for doing a non-blocking path
 lookup
From:   Jeff Layton <jlayton@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date:   Sat, 25 Jan 2020 08:15:01 -0500
In-Reply-To: <20200107170034.16165-2-axboe@kernel.dk>
References: <20200107170034.16165-1-axboe@kernel.dk>
         <20200107170034.16165-2-axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2020-01-07 at 10:00 -0700, Jens Axboe wrote:
> If the fast lookup fails, then return -EAGAIN to have the caller retry
> the path lookup. Assume that a dentry having any of:
> 
> ->d_revalidate()
> ->d_automount()
> ->d_manage()
> 
> could block in those callbacks. Preemptively return -EAGAIN if any of
> these are present.
> 
> This is in preparation for supporting non-blocking open.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/namei.c            | 21 ++++++++++++++++++++-
>  include/linux/namei.h |  2 ++
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b367fdb91682..ed108a41634f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1641,6 +1641,17 @@ static struct dentry *__lookup_hash(const struct qstr *name,
>  	return dentry;
>  }
>  
> +static inline bool lookup_could_block(struct dentry *dentry, unsigned int flags)
> +{
> +	const struct dentry_operations *ops = dentry->d_op;
> +
> +	if (!ops || !(flags & LOOKUP_NONBLOCK))
> +		return 0;
> +
> +	/* assume these dentry ops may block */
> +	return ops->d_revalidate || ops->d_automount || ops->d_manage;
> +}
> +

d_revalidate shouldn't block if LOOKUP_RCU is set.


>  static int lookup_fast(struct nameidata *nd,
>  		       struct path *path, struct inode **inode,
>  		       unsigned *seqp)
> @@ -1665,6 +1676,9 @@ static int lookup_fast(struct nameidata *nd,
>  			return 0;
>  		}
>  
> +		if (unlikely(lookup_could_block(dentry, nd->flags)))
> +			return -EAGAIN;
> +
>  		/*
>  		 * This sequence count validates that the inode matches
>  		 * the dentry name information from lookup.
> @@ -1707,7 +1721,10 @@ static int lookup_fast(struct nameidata *nd,
>  		dentry = __d_lookup(parent, &nd->last);
>  		if (unlikely(!dentry))
>  			return 0;
> -		status = d_revalidate(dentry, nd->flags);
> +		if (unlikely(lookup_could_block(dentry, nd->flags)))
> +			status = -EAGAIN;
> +		else
> +			status = d_revalidate(dentry, nd->flags);
>  	}
>  	if (unlikely(status <= 0)) {
>  		if (!status)
> @@ -1912,6 +1929,8 @@ static int walk_component(struct nameidata *nd, int flags)
>  	if (unlikely(err <= 0)) {
>  		if (err < 0)
>  			return err;
> +		if (nd->flags & LOOKUP_NONBLOCK)
> +			return -EAGAIN;
>  		path.dentry = lookup_slow(&nd->last, nd->path.dentry,
>  					  nd->flags);
>  		if (IS_ERR(path.dentry))
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 4e77068f7a1a..392eb439f88b 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -49,6 +49,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>  /* LOOKUP_* flags which do scope-related checks based on the dirfd. */
>  #define LOOKUP_IS_SCOPED (LOOKUP_BENEATH | LOOKUP_IN_ROOT)
>  
> +#define LOOKUP_NONBLOCK		0x200000 /* don't block for lookup */
> +
>  extern int path_pts(struct path *path);
>  
>  extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);

-- 
Jeff Layton <jlayton@kernel.org>

