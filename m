Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF05C52A3D0
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 15:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbiEQNtI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 09:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiEQNtH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 09:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E14E4C790;
        Tue, 17 May 2022 06:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A58B81890;
        Tue, 17 May 2022 13:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6F0C34116;
        Tue, 17 May 2022 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652795344;
        bh=ptVftuJ5so5El75pHlR/1Uw+fbkvm5Gy0tQ0MngQe8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxll6opapEVoVsMd4liJdySaUQU0qYFhokppKb8FDuH1YGhkL21HUOyo75gCaOak1
         eSzwAvm7MZUgNKYNJ+KomK6YqKCDdmToWHrcIUTVM3NrVMta/1vlUgf5quV2ob8n+C
         9RXEOPANp2YTnhPYagJD092oV7nPqPcJhNECSuPTL2pMeY2PvUY8VXMeXsZ6ZojHVa
         q6LbSNMqhah+7brNWjvFdW/3GqHfEaPerBD+nes3UENH+dfAG83mpg34yh3wzUc/t+
         0J/C9lehGg286KghCEeQR3/h1/JIPer3QMexX5uuHcLVNp7V6MUk5sC9T2EZsptDKH
         LiH/eIGO7uP7g==
Date:   Tue, 17 May 2022 15:48:54 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC PATCH v2 08/16] fs: add pending file update time flag.
Message-ID: <20220517134854.qxb7cif7hvbsbkgd@wittgenstein>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-9-shr@fb.com>
 <20220517112816.ygkadxcjcfcirauo@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517112816.ygkadxcjcfcirauo@quack3.lan>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 17, 2022 at 01:28:16PM +0200, Jan Kara wrote:
> On Mon 16-05-22 09:47:10, Stefan Roesch wrote:
> > This introduces an optimization for the update time flag and async
> > buffered writes. While an update of the file modification time is
> > pending and is handled by the workers, concurrent writes do not need
> > to wait for this time update to complete.
> > 
> > Signed-off-by: Stefan Roesch <shr@fb.com>
> > ---
> >  fs/inode.c         | 1 +
> >  include/linux/fs.h | 3 +++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 1d0b02763e98..fd18b2c1b7c4 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -2091,6 +2091,7 @@ static int do_file_update_time(struct inode *inode, struct file *file,
> >  		return 0;
> >  
> >  	ret = inode_update_time(inode, now, sync_mode);
> > +	inode->i_flags &= ~S_PENDING_TIME;
> 
> So what protects this update of inode->i_flags? Usually we use
> inode->i_rwsem for that but not all file_update_time() callers hold it...

I think the confusion might come about because file_modified() mentions
that the caller is expected to hold file's inode_lock()... Another
reason why we should probably add more kernel doc with a "Context:" line
explaining what locks are expected to be held to these helpers.
