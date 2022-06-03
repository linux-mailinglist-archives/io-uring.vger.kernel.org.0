Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3153C8EE
	for <lists+io-uring@lfdr.de>; Fri,  3 Jun 2022 12:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbiFCKsc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jun 2022 06:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiFCKsa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jun 2022 06:48:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717F23A5E0;
        Fri,  3 Jun 2022 03:48:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 26D0621BAF;
        Fri,  3 Jun 2022 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654253308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lL0sA5XjtLFXOSPYhZwL9fsYRctZLSHfZMiugzXEhy0=;
        b=MPG+EDLZ7zWtvgYAuhwBRZAbEQTvwn0S2ojkdsEWGzgDARk6FtZCjTh6LDLjkoAh1HAeN1
        qLdFYFKplq7W9P08Xhuw0g0LCJVECJgSB6rKoueH+O4alAy0avP5ZySJH0mkHhLwkCpn5C
        z7KWS13dFbs4yhmJFUkRSLpn/FLQ6gg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654253308;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lL0sA5XjtLFXOSPYhZwL9fsYRctZLSHfZMiugzXEhy0=;
        b=virjceIuMs1e0WcsnZvBKAq6RwjObIP8bs1bt75KotsmFk5fqGF4hiId5i+c8xrxXcVouG
        cD1xxqDFti5G2ZAg==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BB5F02C141;
        Fri,  3 Jun 2022 10:48:27 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F3E10A0633; Fri,  3 Jun 2022 12:12:02 +0200 (CEST)
Date:   Fri, 3 Jun 2022 12:12:02 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org, axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 10/15] fs: Add async write file modification handling.
Message-ID: <20220603101202.sabns7qs4cv4z2yp@quack3.lan>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-11-shr@fb.com>
 <20220602090605.ulwxr4edbrsgdxtl@quack3.lan>
 <06c41c2d-4265-3dad-ad97-755ade33a8fa@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06c41c2d-4265-3dad-ad97-755ade33a8fa@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 02-06-22 14:00:38, Stefan Roesch wrote:
> 
> 
> On 6/2/22 2:06 AM, Jan Kara wrote:
> > On Wed 01-06-22 14:01:36, Stefan Roesch wrote:
> >> This adds a file_modified_async() function to return -EAGAIN if the
> >> request either requires to remove privileges or needs to update the file
> >> modification time. This is required for async buffered writes, so the
> >> request gets handled in the io worker of io-uring.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > I've found one small bug here:
> > 
> >> diff --git a/fs/inode.c b/fs/inode.c
> >> index c44573a32c6a..4503bed063e7 100644
> >> --- a/fs/inode.c
> >> +++ b/fs/inode.c
> > ...
> >> -int file_modified(struct file *file)
> >> +static int file_modified_flags(struct file *file, int flags)
> >>  {
> >>  	int ret;
> >>  	struct inode *inode = file_inode(file);
> > 
> > We need to use 'flags' for __file_remove_privs_flags() call in this patch.
> > 
> 
> I assume that you meant that the function should not be called _file_remove_privs(),
> but instead file_remove_privs_flags(). Is that correct?

No, I meant that patch 8 adds call __file_remove_privs(..., 0) to
file_modified() and this patch then forgets to update that call to
__file_remove_privs(..., flags) so that information propagates properly.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
