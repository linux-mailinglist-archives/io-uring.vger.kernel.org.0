Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542C553100F
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiEWKwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 06:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiEWKv4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 06:51:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259A82E9D1;
        Mon, 23 May 2022 03:51:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 348AC1F8FC;
        Mon, 23 May 2022 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653303113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=er9JYArnLSJeQuHrUgEU6Pg3HhcWIglyAYqRTH2CiW0=;
        b=BKTR8X/ocHJX69A557i5YSZLaDBaiQBIdAwGZx2Kh8YY1pfzT8IaH0twOttAKHtIj/dDiK
        wQL5V90y6BlcT5aSJeq0fy8X1E+120v+oQwONU6zNNRrHNA38fslpFUTpT8CmlP5504vue
        O6i5N9ceNydatQKdydO1C81gHH4vxAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653303113;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=er9JYArnLSJeQuHrUgEU6Pg3HhcWIglyAYqRTH2CiW0=;
        b=DAfS6cAwiJcK146v8X+p9SwPWrG9J5hbRbAAHzs6Ign2VMVVRZ1Z1Nx8VYKxQbDrwFf+xd
        dSOIxDRANxdGGFCA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1F92B2C141;
        Mon, 23 May 2022 10:51:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B547EA0632; Mon, 23 May 2022 12:51:52 +0200 (CEST)
Date:   Mon, 23 May 2022 12:51:52 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 12/17] fs: Optimization for concurrent file time
 updates.
Message-ID: <20220523105152.36hpyx7jd2fsy2i5@quack3.lan>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-13-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-13-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri 20-05-22 11:36:41, Stefan Roesch wrote:
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

...

> @@ -2184,10 +2184,17 @@ int file_modified_async(struct file *file, int flags)
>  	ret = file_needs_update_time(inode, file, &now);
>  	if (ret <= 0)
>  		return ret;
> -	if (flags & IOCB_NOWAIT)
> +	if (flags & IOCB_NOWAIT) {
> +		if (IS_PENDING_TIME(inode))
> +			return 0;
> +
> +		inode->i_flags |= S_PENDING_TIME;
>  		return -EAGAIN;
> +	}
>  
> -	return __file_update_time(inode, file, &now, ret);
> +	ret = __file_update_time(inode, file, &now, ret);
> +	inode->i_flags &= ~S_PENDING_TIME;
> +	return ret;
>  }
>  EXPORT_SYMBOL(file_modified_async);

You still didn't address my concern that i_flags is modified without the
protection of i_rwsem here. That can lead to corruption of i_flags value
and rather nasty (and hard to debug) consequences. You can use
inode_set_flags() here to make things kinda safe. The whole inode->i_flags
handling is a mess but not yours to resolve ;)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
