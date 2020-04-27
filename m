Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F121BA65A
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgD0O1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 10:27:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:39968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgD0O1z (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 27 Apr 2020 10:27:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F424AE0A;
        Mon, 27 Apr 2020 14:27:52 +0000 (UTC)
Date:   Mon, 27 Apr 2020 16:27:33 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Josh Triplett <josh@joshtriplett.org>, linux-arch@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, lkp@lists.01.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        ltp@lists.linux.it
Subject: Re: [LTP] [fs] ce436509a8: ltp.openat203.fail
Message-ID: <20200427142733.GD7661@rei>
References: <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200427135210.GB5770@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135210.GB5770@shao2-debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!
> commit: ce436509a8e109330c56bb4d8ec87d258788f5f4 ("[PATCH v4 2/3] fs: openat2: Extend open_how to allow userspace-selected fds")
> url: https://github.com/0day-ci/linux/commits/Josh-Triplett/Support-userspace-selected-fds/20200414-102939
> base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next

This commit adds fd parameter to the how structure where LTP test was
previously passing garbage, which obviously causes the difference in
errno.

This could be safely ignored for now, if the patch gets merged the test
needs to be updated.

-- 
chrubis@suse.cz
