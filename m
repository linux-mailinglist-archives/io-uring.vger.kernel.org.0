Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D75E9D2A
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiIZJPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiIZJO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 05:14:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CD51208A;
        Mon, 26 Sep 2022 02:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A31CB8076A;
        Mon, 26 Sep 2022 09:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE90AC433C1;
        Mon, 26 Sep 2022 09:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664183683;
        bh=dHs+YgAl2GmuM02+rSRwgCFpJ7OKLgE+oTY6U6YQ03U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIdexGJpR/ycF5w0nQivoFwFs9rr05K9AJjyXJ2+uTzeN+wvvWIaabK3i2cDSBeYG
         TaVc9VDVreQnaFtMJjWoYmCcAQZi5k4teYCLkYzSw0uBOAY9A3bzsa7JmOlyB7hZYY
         1aCcAQokeguse/wMCPJOOnRP8noBNv0qwPFarRXrlalLAV79WpH5eBX5+Z398+ankO
         lVQZMqZzq/pDdDpBLD0m2aT8ec5c3m68JG9xwiZ5rNWTkKBNs3lqffAeG/p+0v7Tlm
         oBsm/AQVLF52qVV3rfY/dYd9b2uIzvGt4Vkpswn2s1/wi7VrOZAJxCCCqllnn5lUO/
         XgVlJAyEOVtqA==
Date:   Mon, 26 Sep 2022 10:14:40 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk,
        josef@toxicpanda.com, fdmanana@gmail.com
Subject: Re: [PATCH v3 02/12] btrfs: implement a nowait option for tree
 searches
Message-ID: <20220926091440.GA1198392@falcondesktop>
References: <20220912192752.3785061-1-shr@fb.com>
 <20220912192752.3785061-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912192752.3785061-3-shr@fb.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 12, 2022 at 12:27:42PM -0700, Stefan Roesch wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
> or anything.  Accomplish this by adding a path->nowait flag that will
> use trylocks and skip reading of metadata, returning -EAGAIN in either
> of these cases.  For now we only need this for reads, so only the read
> side is handled.  Add an ASSERT() to catch anybody trying to use this
> for writes so they know they'll have to implement the write side.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/ctree.h   |  1 +
>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
>  fs/btrfs/locking.h |  1 +
>  4 files changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index ebfa35fe1c38..71b238364939 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>  			return 0;
>  		}
>  
> +		if (p->nowait) {
> +			free_extent_buffer(tmp);
> +			return -EAGAIN;
> +		}
> +
>  		if (unlock_up)
>  			btrfs_unlock_up_safe(p, level + 1);
>  
> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>  			ret = -EAGAIN;
>  
>  		goto out;
> +	} else if (p->nowait) {
> +		return -EAGAIN;
>  	}
>  
>  	if (unlock_up) {
> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>  		 * We don't know the level of the root node until we actually
>  		 * have it read locked
>  		 */
> -		b = btrfs_read_lock_root_node(root);
> +		if (p->nowait) {
> +			b = btrfs_try_read_lock_root_node(root);
> +			if (IS_ERR(b))
> +				return b;
> +		} else {
> +			b = btrfs_read_lock_root_node(root);
> +		}
>  		level = btrfs_header_level(b);
>  		if (level > write_lock_level)
>  			goto out;
> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  	WARN_ON(p->nodes[0] != NULL);
>  	BUG_ON(!cow && ins_len);
>  
> +	/*
> +	 * For now only allow nowait for read only operations.  There's no
> +	 * strict reason why we can't, we just only need it for reads so I'm
> +	 * only implementing it for reads right now.
> +	 */
> +	ASSERT(!p->nowait || !cow);
> +
>  	if (ins_len < 0) {
>  		lowest_unlock = 2;
>  
> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  
>  	if (p->need_commit_sem) {
>  		ASSERT(p->search_commit_root);
> -		down_read(&fs_info->commit_root_sem);
> +		if (p->nowait) {
> +			if (!down_read_trylock(&fs_info->commit_root_sem))
> +				return -EAGAIN;
> +		} else {
> +			down_read(&fs_info->commit_root_sem);
> +		}
>  	}
>  
>  again:
> @@ -2082,7 +2107,15 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  				btrfs_tree_lock(b);
>  				p->locks[level] = BTRFS_WRITE_LOCK;
>  			} else {
> -				btrfs_tree_read_lock(b);
> +				if (p->nowait) {
> +					if (!btrfs_try_tree_read_lock(b)) {
> +						free_extent_buffer(b);
> +						ret = -EAGAIN;
> +						goto done;
> +					}
> +				} else {
> +					btrfs_tree_read_lock(b);
> +				}
>  				p->locks[level] = BTRFS_READ_LOCK;
>  			}
>  			p->nodes[level] = b;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index df8c99c99df9..ca59ba6421a9 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -443,6 +443,7 @@ struct btrfs_path {
>  	 * header (ie. sizeof(struct btrfs_item) is not included).
>  	 */
>  	unsigned int search_for_extension:1;
> +	unsigned int nowait:1;
>  };
>  #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
>  					sizeof(struct btrfs_item))
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 9063072b399b..d6c88922d3e2 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -285,6 +285,29 @@ struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
>  	return eb;
>  }
>  
> +/*
> + * Loop around taking references on and locking the root node of the tree in
> + * nowait mode until we end up with a lock on the root node or returning to
> + * avoid blocking.
> + *
> + * Return: root extent buffer with read lock held or -EWOULDBLOCK.
> + */
> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *root)
> +{
> +	struct extent_buffer *eb;
> +
> +	while (1) {
> +		eb = btrfs_root_node(root);
> +		if (!btrfs_try_tree_read_lock(eb))
> +			return ERR_PTR(-EAGAIN);

There's a leak of the extent buffer here.
This fixes it up:

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 9d53bcfb6d9b..0eab3cb274a1 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -298,8 +298,10 @@ struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *root)
 
        while (1) {
                eb = btrfs_root_node(root);
-               if (!btrfs_try_tree_read_lock(eb))
+               if (!btrfs_try_tree_read_lock(eb)) {
+                       free_extent_buffer(eb);
                        return ERR_PTR(-EAGAIN);
+               }
                if (eb == root->node)
                        break;
                btrfs_tree_read_unlock(eb);


Thanks.

> +		if (eb == root->node)
> +			break;
> +		btrfs_tree_read_unlock(eb);
> +		free_extent_buffer(eb);
> +	}
> +	return eb;
> +}
> +
>  /*
>   * DREW locks
>   * ==========
> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
> index ab268be09bb5..490c7a79e995 100644
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -94,6 +94,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb);
>  int btrfs_try_tree_write_lock(struct extent_buffer *eb);
>  struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
>  struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root);
> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *root);
>  
>  #ifdef CONFIG_BTRFS_DEBUG
>  static inline void btrfs_assert_tree_write_locked(struct extent_buffer *eb)
> -- 
> 2.30.2
> 
