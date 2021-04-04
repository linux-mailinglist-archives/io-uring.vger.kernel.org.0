Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB69B3539B1
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhDDURc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 16:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhDDURc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 16:17:32 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D06C0613E6;
        Sun,  4 Apr 2021 13:17:27 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lT9BR-002XUa-Ug; Sun, 04 Apr 2021 20:17:22 +0000
Date:   Sun, 4 Apr 2021 20:17:21 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
References: <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 06:50:10PM +0000, Al Viro wrote:

> > Yeah, I have at least namei.o
> > 
> > https://drive.google.com/file/d/1AvO1St0YltIrA86DXjp1Xg3ojtS9owGh/view?usp=sharing
> 
> *grumble*
> 
> Is it reproducible without KASAN?  Would be much easier to follow the produced
> asm...

	Looks like inode_permission(_, NULL, _) from may_lookup(nd).  I.e.
nd->inode == NULL.

	Mind slapping BUG_ON(!nd->inode) right before may_lookup() call in
link_path_walk() and trying to reproduce that oops?
