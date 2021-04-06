Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3070B35563A
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 16:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbhDFOPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 10:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244364AbhDFOPN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 10:15:13 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609F8C06174A;
        Tue,  6 Apr 2021 07:15:05 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTmTt-0037iV-Fc; Tue, 06 Apr 2021 14:15:01 +0000
Date:   Tue, 6 Apr 2021 14:15:01 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGxs5b0pY4esY7J7@zeniv-ca.linux.org.uk>
References: <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
 <20210406123505.auxqtquoys6xg6yf@wittgenstein>
 <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
 <20210406132205.qnherkzif64xmgxg@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406132205.qnherkzif64xmgxg@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 06, 2021 at 03:22:05PM +0200, Christian Brauner wrote:

> Why is a another function in charge of checking the return value of an
> initialization function. If something like path_init() fails why is the
> next caller responsible for rejecting it's return value and then we're
> passing that failure value through the whole function with if (!err)
> ladders but as I said it's mostly style preferences.

Because otherwise you either need *all* paths leading to link_path_walk()
duplicate the logics (and get hurt whenever you miss one) or have "well,
in some cases link_path_walk() handles ERR_PTR() given to it, in some
cases its caller do" mess.

> > >         s = path_init(nd, flags);
> > > -       if (IS_ERR(s))
> > > -               return PTR_ERR(s);
> > 
> > Where has that come from, BTW?  Currently path_lookupat() does no such thing.
> 
> Hm? Are you maybe overlooking path_init() which assigns straight into
> the variable declaration? Or are you referring to sm else?

I'm referring to the fact that your diff is with an already modified path_lookupat()
_and_ those modifications have managed to introduce a bug your patch reverts.
No terminate_walk() paired with that path_init() failure, i.e. path_init() is
responsible for cleanups on its (many) failure exits...
