Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B49670E71F
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 23:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbjEWVF5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 17:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjEWVF4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 17:05:56 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C2E53;
        Tue, 23 May 2023 14:05:30 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E7209C01F; Tue, 23 May 2023 23:05:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684875928; bh=7wM8P/MBRnqqCsZVNJ6/C5t2N2QFk9ozbdYpVlIoyqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sgXIXxBmN28MFmNWXPLzC5bXaS2SRuIIpD9bddxDscF5GeOTuXshQP42isOuARmhh
         3QtDCDdysYR2FqIG/t5jTK2JtJcvTABjrN/oxLRgAi+O8H4NujXdclfbjaaC70rwUo
         WP9u2kBExArYTDQXMuNlmr2dZwyXAOxnXLhXVcNr5K7Kj9q2ypUFize9noG6DagMtm
         j0Dm/lkGHYzbE3+P9f4ixlYU0ak8Kr5JT1y7E0FWYoOL+5wlQd2MAPWzAevFX31tQv
         3C27hZceyzxttstkuSKhtln6XB0QHvK+wiLd3Qrx3Xvj0K/1v5oQAsq17XZABpEVjg
         3vm/K2bGqvwcg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 20E76C009;
        Tue, 23 May 2023 23:05:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684875928; bh=7wM8P/MBRnqqCsZVNJ6/C5t2N2QFk9ozbdYpVlIoyqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sgXIXxBmN28MFmNWXPLzC5bXaS2SRuIIpD9bddxDscF5GeOTuXshQP42isOuARmhh
         3QtDCDdysYR2FqIG/t5jTK2JtJcvTABjrN/oxLRgAi+O8H4NujXdclfbjaaC70rwUo
         WP9u2kBExArYTDQXMuNlmr2dZwyXAOxnXLhXVcNr5K7Kj9q2ypUFize9noG6DagMtm
         j0Dm/lkGHYzbE3+P9f4ixlYU0ak8Kr5JT1y7E0FWYoOL+5wlQd2MAPWzAevFX31tQv
         3C27hZceyzxttstkuSKhtln6XB0QHvK+wiLd3Qrx3Xvj0K/1v5oQAsq17XZABpEVjg
         3vm/K2bGqvwcg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 36d2147c;
        Tue, 23 May 2023 21:05:21 +0000 (UTC)
Date:   Wed, 24 May 2023 06:05:06 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 6/6] RFC: io_uring getdents: test returning an EOF
 flag in CQE
Message-ID: <ZG0qgniV1DzIbbzi@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
 <20230422-uring-getdents-v2-6-2db1e37dc55e@codewreck.org>
 <20230523-abgleichen-rotieren-37fdb6fb9ef3@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230523-abgleichen-rotieren-37fdb6fb9ef3@brauner>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Christian Brauner wrote on Tue, May 23, 2023 at 04:30:14PM +0200:
> > index b15ec81c1ed2..f6222b0148ef 100644
> > --- a/io_uring/fs.c
> > +++ b/io_uring/fs.c
> > @@ -322,6 +322,7 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> >  {
> >  	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> >  	unsigned long getdents_flags = 0;
> > +	u32 cqe_flags = 0;
> >  	int ret;
> >  
> >  	if (issue_flags & IO_URING_F_NONBLOCK) {
> > @@ -338,13 +339,16 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> >  			goto out;
> >  	}
> >  
> > -	ret = vfs_getdents(req->file, gd->dirent, gd->count, getdents_flags);
> > +	ret = vfs_getdents(req->file, gd->dirent, gd->count, &getdents_flags);
> 
> I don't understand how synchronization and updating of f_pos works here.
> For example, what happens if a concurrent seek happens on the fd while
> io_uring is using vfs_getdents which calls into iterate_dir() and
> updates f_pos?

I don't see how different that is from a user spawning two threads and
calling getdents64 + lseek or two getdents64 in parallel?
(or any two other users of iterate_dir)

As far as I understand you'll either get the old or new pos as
obtained/updated by iterate_dir()?

That iterate_dir probably ought to be using READ_ONCE/WRITE_ONCE or some
atomic read/update wrappers as the shared case only has a read lock
around these, but that's not a new problem; and for all I care
about I'm happy to let users shoot themselves in the foot.
(although I guess that with filesystems not validating the offset as
was pointed out in a previous version comment having non-atomic update
might be a security issue at some point on architectures that don't
guarantee atomic 64bit updates, but if someone manages to abuse it
it's already possible to abuse it with the good old syscalls, so I'd
rather leave that up to someone who understand how atomicity in the
kernel works better than me...)

-- 
Dominique Martinet | Asmadeus
