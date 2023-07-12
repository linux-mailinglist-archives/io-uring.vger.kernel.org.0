Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B32750D9F
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjGLQLG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjGLQLG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:11:06 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9C510FA;
        Wed, 12 Jul 2023 09:11:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 9C522C024; Wed, 12 Jul 2023 18:11:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689178263; bh=DACiLjAb3AxPaF1XXgn3qSxuUGuVuveN9I8X5nP9hrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Awe2b9hjp+1Vo4EojeNxTVULmjWG9L6gPgEqyIS1lyEfLr0z4DKlY17Yoncm+f7IS
         qyzpvwn9zY1KhRiBJIhbJsDKo8aUJn34ROPhCV2xEhFhZQmtmwAERLSaL+ZsRiJ86w
         laEi553UW1CPYbf8tyKKXaghsoQLuEhenru/wrH1U3Iybt1QPFeoSjXUm565ITNBoa
         CbxpUAdwypMBBPXLdrBgX+YskRow8GgunUAU2tKRBlNdPfiaB1yDEBDRvP4rkqja41
         N/nDl4iHFAH52IAzEZAi0Rk5I14jz5ZINZ8CXlh6kQ8MqAHDGFeu6Oa6ha4ZZDtJiT
         O1KougDBlfAYQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 276DDC009;
        Wed, 12 Jul 2023 18:10:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689178262; bh=DACiLjAb3AxPaF1XXgn3qSxuUGuVuveN9I8X5nP9hrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5z/a8SiZtnpMsSTm/QCmABSzZr/jEga/M6ieJtKFvysF64sk/LtbjU2r4I1sSOjp
         7fHTuKaqYfooSq6mxaJJYbzkVT6ZTd/La5cwEoJNl/zcEiRt7V5BwXq/tba/bxjnM7
         /cZMBAiMkVEG9/vibzQpmVJ1WfVWHmNsOnl+xzBuyEfwe8y8MhqMCg/jFO/69NG3yz
         O4EWqVSoZVZSFqkHJMbRW8ELqvLuAw1t+ZVNQ0rGE8Oa+vyhO59XtssHTU3NGeg8dM
         EmZih2csq0HhVyxpcfva3MoLz3wDwj2pvFahV492PRlG7LevgCBlnCavPGLKRjz8IL
         Ji2Zig2N/5pQQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c9b915ae;
        Wed, 12 Jul 2023 16:10:56 +0000 (UTC)
Date:   Thu, 13 Jul 2023 01:10:41 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Message-ID: <ZK7QgRyUIHNC8Nk6@codewreck.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev>
 <ZK1H568bvIzcsB6J@codewreck.org>
 <858c3f16-ffb3-217e-b5d6-fcc63ef9c401@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <858c3f16-ffb3-217e-b5d6-fcc63ef9c401@linux.dev>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu wrote on Wed, Jul 12, 2023 at 03:53:24PM +0800:
> > > +		if (file_count(file) > 1)
> > 
> > I was curious about this so I found it's basically what __fdget_pos does
> > before deciding it should take the f_pos_lock, and as such this is
> > probably correct... But if someone can chime in here: what guarantees
> > someone else won't __fdget_pos (or equivalent through this) the file
> > again between this and the vfs_getdents call?
> > That second get would make file_count > 1 and it would lock, but lock
> > hadn't been taken here so the other call could get the lock without
> > waiting and both would process getdents or seek or whatever in
> > parallel.
> > 
> 
> This file_count(file) is atomic_read, so I believe no race condition here.

I don't see how that helps in the presence of another thread getting the
lock after we possibly issued a getdents without the lock, e.g.

t1 call io_uring getdents here
t1 sees file_count(file) == 1 and skips getting lock
t1 starts issuing vfs_getdents [... processing]
t2 calls either io_uring getdents or getdents64 syscall
t2 gets the lock, since it wasn't taken by t1 it can be obtained
t2 issues another vfs_getdents

Christian raised the same issue so I'll leave this to his part of the
thread for reply, but I hope that clarified my concern.


-----

BTW I forgot to point out: this dropped the REWIND bit from my patch; I
believe some form of "seek" is necessary for real applications to make
use of this (for example, a web server could keep the fd open in a LRU
and keep issuing readdir over and over again everytime it gets an
indexing request); not having rewind means it'd need to close and
re-open the fd everytime which doesn't seem optimal.

A previous iteration discussed that real seek is difficult and not
necessarily needed to I settled for rewind, but was there a reason you
decided to stop handling that?

My very egoistical personal use case won't require it, so I can just say
I don't care here, but it would be nice to have a reason explained at
some point

-- 
Dominique Martinet | Asmadeus
