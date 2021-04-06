Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F83554BA
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 15:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbhDFNN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 09:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhDFNNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 09:13:25 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80E6C06175F;
        Tue,  6 Apr 2021 06:13:17 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTlW5-00373l-QV; Tue, 06 Apr 2021 13:13:13 +0000
Date:   Tue, 6 Apr 2021 13:13:13 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
References: <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
 <20210406123505.auxqtquoys6xg6yf@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406123505.auxqtquoys6xg6yf@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 06, 2021 at 02:35:05PM +0200, Christian Brauner wrote:

> And while we're at it might I bring up the possibility of an additional
> cleanup of how we currently call path_init().
> Right now we pass the return value from path_init() directly into e.g.
> link_path_walk() which as a first thing checks for error. Which feels
> rather wrong and has always confused me when looking at these codepaths.

Why?

> I get that it might make sense for reasons unrelated to path_init() that
> link_path_walk() checks its first argument for error but path_init()
> should be checked for error right away especially now that we return
> early when LOOKUP_CACHED is set without LOOKUP_RCU.

But you are making the _callers_ of path_init() do that, for no good
reason.

> thing especially in longer functions such as path_lookupat() where it
> gets convoluted pretty quickly. I think it would be cleaner to have
> something like [1]. The early exists make the code easier to reason
> about imho. But I get that that's a style discussion.

Your variant is a lot more brittle, actually.

> @@ -2424,33 +2424,49 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
>         int err;
> 
>         s = path_init(nd, flags);
> -       if (IS_ERR(s))
> -               return PTR_ERR(s);

Where has that come from, BTW?  Currently path_lookupat() does no such thing.
