Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9E52A066
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 13:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiEQL20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 07:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiEQL2Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 07:28:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A4F37A1C;
        Tue, 17 May 2022 04:28:23 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 67C321F383;
        Tue, 17 May 2022 11:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652786902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3wqdcvLYWrYzghVSBNiA5efGrOvm2RRy916DXEi5jaA=;
        b=jCwF+yZnKGecO7iFeHrW5jnZf1awNRcaGA7uajnkuCgRjuy1kBMd+YFLwiv0HDIjX1yhga
        fMa+JBFvSL2+l2VHykDVabTFLpVrqhbBHQEdLDevGQPHBBx+GFzSrKd++OuEd03yZBobtT
        XPJy/8ThNHtu0I1CI6A4k2NwyV+ZlCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652786902;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3wqdcvLYWrYzghVSBNiA5efGrOvm2RRy916DXEi5jaA=;
        b=lUqiH+SkWL+XNb6mdFmo3rRUAfka+mCV86TFi8DeiFlKYwkiGHmf5RG89e1k62qiM/mg/1
        642epCCyoE+Au3BQ==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 562B52C141;
        Tue, 17 May 2022 11:28:22 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 8E957A0631; Tue, 17 May 2022 13:28:16 +0200 (CEST)
Date:   Tue, 17 May 2022 13:28:16 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 08/16] fs: add pending file update time flag.
Message-ID: <20220517112816.ygkadxcjcfcirauo@quack3.lan>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-9-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-9-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon 16-05-22 09:47:10, Stefan Roesch wrote:
> This introduces an optimization for the update time flag and async
> buffered writes. While an update of the file modification time is
> pending and is handled by the workers, concurrent writes do not need
> to wait for this time update to complete.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/inode.c         | 1 +
>  include/linux/fs.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 1d0b02763e98..fd18b2c1b7c4 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2091,6 +2091,7 @@ static int do_file_update_time(struct inode *inode, struct file *file,
>  		return 0;
>  
>  	ret = inode_update_time(inode, now, sync_mode);
> +	inode->i_flags &= ~S_PENDING_TIME;

So what protects this update of inode->i_flags? Usually we use
inode->i_rwsem for that but not all file_update_time() callers hold it...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
