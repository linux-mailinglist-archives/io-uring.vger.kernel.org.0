Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29F41BC3B1
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgD1PaG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 11:30:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:45866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgD1PaG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 28 Apr 2020 11:30:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7984AE7F;
        Tue, 28 Apr 2020 15:30:03 +0000 (UTC)
Date:   Tue, 28 Apr 2020 17:30:22 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        lkp@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        ltp@lists.linux.it
Subject: Re: [LTP] [fs] ce436509a8: ltp.openat203.fail
Message-ID: <20200428153022.GC4244@yuki.lan>
References: <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200427135210.GB5770@shao2-debian>
 <20200427142733.GD7661@rei>
 <20200428005126.6wncibudt6ohghvc@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428005126.6wncibudt6ohghvc@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!
> > > commit: ce436509a8e109330c56bb4d8ec87d258788f5f4 ("[PATCH v4 2/3] fs: openat2: Extend open_how to allow userspace-selected fds")
> > > url: https://github.com/0day-ci/linux/commits/Josh-Triplett/Support-userspace-selected-fds/20200414-102939
> > > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
> > 
> > This commit adds fd parameter to the how structure where LTP test was
> > previously passing garbage, which obviously causes the difference in
> > errno.
> > 
> > This could be safely ignored for now, if the patch gets merged the test
> > needs to be updated.
> 
> It wouldn't be a bad idea to switch the test to figure out the ksize of
> the struct, so that you only add bad padding after that. But then again,
> this would be a bit ugly -- having CHECK_FIELDS would make this simpler.

Any pointers how can be the size figured out without relying on the
E2BIG we are testing for? Does the kernel export it somewhere?

-- 
Cyril Hrubis
chrubis@suse.cz
