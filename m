Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11012355689
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhDFOXj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhDFOXj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 10:23:39 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A3BC06174A;
        Tue,  6 Apr 2021 07:23:31 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTmc4-0037of-6y; Tue, 06 Apr 2021 14:23:28 +0000
Date:   Tue, 6 Apr 2021 14:23:28 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGxu4OWMLE+XXy7Z@zeniv-ca.linux.org.uk>
References: <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
 <20210406123505.auxqtquoys6xg6yf@wittgenstein>
 <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
 <20210406132205.qnherkzif64xmgxg@wittgenstein>
 <YGxs5b0pY4esY7J7@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGxs5b0pY4esY7J7@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 06, 2021 at 02:15:01PM +0000, Al Viro wrote:

> I'm referring to the fact that your diff is with an already modified path_lookupat()
> _and_ those modifications have managed to introduce a bug your patch reverts.
> No terminate_walk() paired with that path_init() failure, i.e. path_init() is
> responsible for cleanups on its (many) failure exits...

I can't tell without seeing the variant your diff is against, but at a guess
it had a non-trivial amount of trouble with missed rcu_read_unlock() in
cases when path_init() fails after having done rcu_read_lock().  For trivial
testcase, consider passing -1 for dfd, so that it would fail with -EBADF.
Or passing 0 for dfd and "blah" for name (assuming your stdin is not a directory).
Sure, you could handle those in path_init() (or delay grabbing rcu_read_lock()
in there, spreading it in a bunch of branches), but duplicated cleanup logics
for a bunch of failure exits is asking for trouble.
