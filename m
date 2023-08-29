Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16178BF63
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 09:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjH2Hmc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 03:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjH2HmK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 03:42:10 -0400
Received: from out-243.mta1.migadu.com (out-243.mta1.migadu.com [IPv6:2001:41d0:203:375::f3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B13D1A2;
        Tue, 29 Aug 2023 00:42:04 -0700 (PDT)
Message-ID: <ca10040f-b7fa-7c43-1c89-6706d13b2747@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693294923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kzCYK+m1dXoYq1GdX9wRq/xLcjMjzBwHZbogX1zaiXI=;
        b=wx9qXfUOb6FlguPiqwy6R82+yQxWta9+fR66YAQ2/1ZdnqJnQPp1kHU4jR8nRlngim3iOe
        HThmnzNEUSaEuQwHiVi+WxF88JyUG2K+H0WcvTm70cW04LSIUXyP6AZ74VPb7aBxP9rojs
        L1LrBvpa76A1LVLwfY5LHU6MjnCVZUs=
Date:   Tue, 29 Aug 2023 15:41:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 02/11] xfs: add NOWAIT semantics for readdir
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
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
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-3-hao.xu@linux.dev>
 <ZOu1xYS6LRmPgEiV@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZOu1xYS6LRmPgEiV@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/23 04:44, Matthew Wilcox wrote:
> On Sun, Aug 27, 2023 at 09:28:26PM +0800, Hao Xu wrote:
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -2643,16 +2643,32 @@ xfs_da_read_buf(
>>   	struct xfs_buf_map	map, *mapp = &map;
>>   	int			nmap = 1;
>>   	int			error;
>> +	int			buf_flags = 0;
>>   
>>   	*bpp = NULL;
>>   	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
>>   	if (error || !nmap)
>>   		goto out_free;
>>   
>> +	/*
>> +	 * NOWAIT semantics mean we don't wait on the buffer lock nor do we
>> +	 * issue IO for this buffer if it is not already in memory. Caller will
>> +	 * retry. This will return -EAGAIN if the buffer is in memory and cannot
>> +	 * be locked, and no buffer and no error if it isn't in memory.  We
>> +	 * translate both of those into a return state of -EAGAIN and *bpp =
>> +	 * NULL.
>> +	 */
> 
> I would not include this comment.

No strong comment here, since this patch is mostly from Dave, it's
better if Dave can ack this.

> 
>> +	if (flags & XFS_DABUF_NOWAIT)
>> +		buf_flags |= XBF_TRYLOCK | XBF_INCORE;
>>   	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
>>   			&bp, ops);
> 
> what tsting did you do with this?  Because you don't actually _use_
> buf_flags anywhere in this patch (presumably they should be the
> sixth argument to xfs_trans_read_buf_map() instead of 0).  So I can only
> conclude that either you didn't test, or your testing was inadequate.
> 


The tests I've done are listed in the cover-letter, this one is missed, 
the tricky place is it's hard to get this kind of mistake since it runs
well without nowait logic...I'll fix it in next version.

>>   	if (error)
>>   		goto out_free;
>> +	if (!bp) {
>> +		ASSERT(flags & XFS_DABUF_NOWAIT);
> 
> I don't think this ASSERT is appropriate.
> 
>> @@ -391,10 +401,17 @@ xfs_dir2_leaf_getdents(
>>   				bp = NULL;
>>   			}
>>   
>> -			if (*lock_mode == 0)
>> -				*lock_mode = xfs_ilock_data_map_shared(dp);
>> +			if (*lock_mode == 0) {
>> +				*lock_mode =
>> +					xfs_ilock_data_map_shared_generic(dp,
>> +					ctx->flags & DIR_CONTEXT_F_NOWAIT);
>> +				if (!*lock_mode) {
>> +					error = -EAGAIN;
>> +					break;
>> +				}
>> +			}
> 
> 'generic' doesn't seem like a great suffix to mean 'takes nowait flag'.
> And this is far too far indented.
> 
> 			xfs_dir2_lock(dp, ctx, lock_mode);
> 
> with:
> 
> STATIC void xfs_dir2_lock(struct xfs_inode *dp, struct dir_context *ctx,
> 		unsigned int lock_mode)
> {
> 	if (*lock_mode)
> 		return;
> 	if (ctx->flags & DIR_CONTEXT_F_NOWAIT)
> 		return xfs_ilock_data_map_shared_nowait(dp);
> 	return xfs_ilock_data_map_shared(dp);
> }
> 
> ... which I think you can use elsewhere in this patch (reformat it to
> XFS coding style, of course).  And then you don't need
> xfs_ilock_data_map_shared_generic().
> 

How about rename xfs_ilock_data_map_shared() to 
xfs_ilock_data_map_block() and rename 
xfs_ilock_data_map_shared_generic() to xfs_ilock_data_map_shared()?

STATIC void xfs_ilock_data_map_shared(struct xfs_inode *dp, struct 
dir_context *ctx, unsigned int lock_mode)
{
  	if (*lock_mode)
  		return;
  	if (ctx->flags & DIR_CONTEXT_F_NOWAIT)
  		return xfs_ilock_data_map_shared_nowait(dp);
  	return xfs_ilock_data_map_shared_block(dp);
}


