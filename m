Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C2678919F
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjHYWQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjHYWQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:16:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772352707
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:16:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bf7a6509deso10111585ad.3
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693001779; x=1693606579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppeQOWgbWz5gqWZs/rbytV4GhpZ82FSsmBh/giRYIfc=;
        b=oGxnlMh0S/WiVEBqRgXg0XkOHzHqDpTBvnGnagMxXiK0WZOe1Z4r+2p1ptsCZGDnWB
         pXEktmY/ad0PuwAxCgT0YcHOMRjDsuwyrAXCFtdwEmAj+muyxYQXIE+r39jHMvXhT5B0
         o+SPYmvdCE0AaqEX44rBk89wjuy74zXAp3Vwzk0u1JPoPtSJh1DrCjw1RqWqiFdJpqby
         tMNly65LV0QvaLstk47azhvzcHLQyEtc8q2u/G93EQr7wDi/F72WQh2TPKv7ILrD/tve
         HoezaGEwtih61yu0zT7giO0Mqh1qaOyneAEL9vdEIb12mBB0wZbgWFOwNbvY6RzLwUwH
         OW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693001779; x=1693606579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppeQOWgbWz5gqWZs/rbytV4GhpZ82FSsmBh/giRYIfc=;
        b=etDS5kwrmaiswqEeRrPle70PBKaVIbmto5lsgdt8rzxKzf68lQugPnydlNWiKHC/l2
         ow6VIiOufsQzXs2ia1tit9IkCOqTD19NZUyl2F4uaKKN7ePFcm2h+zTMXg3dcRCTr5Sq
         1rzuMi9GD9q3viwNQPYxJvlKBrpSiE0wCE68d14YbV+zPCY+owtol9n/5HTnVKJ5gwOV
         qlOE3cBzT0tYJSsqV4UHAbUW0MuM4RX/UdcnvARLTnKjTYvyCskJqCUNJwFj28qVy5H2
         L5p0aSVOdqRMjLmQ6gfe1PSepFigFn09cq5Om7dj43yAOeBzj22uoDDpRPU+b6By4nAy
         SRLw==
X-Gm-Message-State: AOJu0Yz2dqpPqiFBvkgsZAreDJcRrZBLAEd7GYBGWhRJHrzYXtIMsAGb
        FRLVZ0oEt0d97vD8xTKaFobyzg==
X-Google-Smtp-Source: AGHT+IEjt82Q7/ukix1Bwi0HcqOCAUCGzooSpz1T14B8KRhD3u7v0lApveU1bnKvxuVgpN4iNhxk8w==
X-Received: by 2002:a17:903:264e:b0:1bd:c338:ae14 with SMTP id je14-20020a170903264e00b001bdc338ae14mr16243879plb.12.1693001778913;
        Fri, 25 Aug 2023 15:16:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b001c0bf60ba5csm2276046pln.272.2023.08.25.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:16:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZf6F-006Va3-0j;
        Sat, 26 Aug 2023 08:16:15 +1000
Date:   Sat, 26 Aug 2023 08:16:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 25/29] xfs: support nowait for xfs_buf_item_init()
Message-ID: <ZOkoL8nuXJDVZM1H@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-26-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-26-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 25, 2023 at 09:54:27PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> support nowait for xfs_buf_item_init() and error out -EAGAIN to
> _xfs_trans_bjoin() when it would block.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_buf_item.c         |  9 +++++++--
>  fs/xfs/xfs_buf_item.h         |  2 +-
>  fs/xfs/xfs_buf_item_recover.c |  2 +-
>  fs/xfs/xfs_trans_buf.c        | 16 +++++++++++++---
>  4 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 023d4e0385dd..b1e63137d65b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -827,7 +827,8 @@ xfs_buf_item_free_format(
>  int
>  xfs_buf_item_init(
>  	struct xfs_buf	*bp,
> -	struct xfs_mount *mp)
> +	struct xfs_mount *mp,
> +	bool   nowait)
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	int			chunks;
> @@ -847,7 +848,11 @@ xfs_buf_item_init(
>  		return 0;
>  	}
>  
> -	bip = kmem_cache_zalloc(xfs_buf_item_cache, GFP_KERNEL | __GFP_NOFAIL);
> +	bip = kmem_cache_zalloc(xfs_buf_item_cache,
> +				GFP_KERNEL | (nowait ? 0 : __GFP_NOFAIL));
> +	if (!bip)
> +		return -EAGAIN;
> +
>  	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
>  	bip->bli_buf = bp;

I see filesystem shutdowns....

> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 016371f58f26..a1e4f2e8629a 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -57,13 +57,14 @@ xfs_trans_buf_item_match(
>   * If the buffer does not yet have a buf log item associated with it,
>   * then allocate one for it.  Then add the buf item to the transaction.
>   */
> -STATIC void
> +STATIC int
>  _xfs_trans_bjoin(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	int			reset_recur)
>  {
>  	struct xfs_buf_log_item	*bip;
> +	int ret;
>  
>  	ASSERT(bp->b_transp == NULL);
>  
> @@ -72,7 +73,11 @@ _xfs_trans_bjoin(
>  	 * it doesn't have one yet, then allocate one and initialize it.
>  	 * The checks to see if one is there are in xfs_buf_item_init().
>  	 */
> -	xfs_buf_item_init(bp, tp->t_mountp);
> +	ret = xfs_buf_item_init(bp, tp->t_mountp,
> +				tp->t_flags & XFS_TRANS_NOWAIT);
> +	if (ret < 0)
> +		return ret;
> +
>  	bip = bp->b_log_item;
>  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
>  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> @@ -92,6 +97,7 @@ _xfs_trans_bjoin(
>  	xfs_trans_add_item(tp, &bip->bli_item);
>  	bp->b_transp = tp;
>  
> +	return 0;
>  }
>  
>  void
> @@ -309,7 +315,11 @@ xfs_trans_read_buf_map(
>  	}
>  
>  	if (tp) {
> -		_xfs_trans_bjoin(tp, bp, 1);
> +		error = _xfs_trans_bjoin(tp, bp, 1);
> +		if (error) {
> +			xfs_buf_relse(bp);
> +			return error;
> +		}
>  		trace_xfs_trans_read_buf(bp->b_log_item);

So what happens at the callers when we have a dirty transaction and
joining a buffer fails with -EAGAIN?

Apart from the fact this may well propagate -EAGAIN up to userspace,
cancelling a dirty transaction at this point will result in a
filesystem shutdown....

Indeed, this can happen in the "simple" timestamp update case that
this "nowait" semantic is being aimed at. We log the inode in the
timestamp update, which dirties the log item and registers a
precommit operation to be run. We commit the
transaction, which then runs xfs_inode_item_precommit() and that
may need to attach the inode to the inode cluster buffer. This
results in:

xfs_inode_item_precommit
  xfs_imap_to_bp
    xfs_trans_read_buf_map
      _xfs_trans_bjoin
        xfs_buf_item_init(XFS_TRANS_NOWAIT)
	  kmem_cache_zalloc(GFP_NOFS)
	  <memory allocation fails>
      gets -EAGAIN error
    propagates -EAGAIN
  fails due to -EAGAIN

And now xfs_trans_commit() fails with a dirty transaction and the
filesystem shuts down.

IOWs, XFS_TRANS_NOWAIT as it stands is fundamentally broken. Once we
dirty an item in a transaction, we *cannot* back out of the
transaction. We *must block* in every place that could fail -
locking, memory allocation and/or IO - until the transaction
completes because we cannot undo the changes we've already made to
the dirty items in the transaction....

It's even worse than that - once we have committed intents, the
whole chain of intent processing must be run to completionr. Hence
we can't tolerate backing out of that defered processing chain half
way through because we might have to block.

Until we can roll back partial dirty transactions and partially
completed defered intent chains at any random point of completion,
XFS_TRANS_NOWAIT will not work.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
