Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E62888E3
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgJIMfk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 08:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbgJIMfk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 08:35:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1341C0613D2;
        Fri,  9 Oct 2020 05:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XGJ2pvgX56gVRYnrRVMGR+GD7jxHoOmPhdCN2nGgouw=; b=WAns9c/zAxoqwnw07v+/Bc7FWV
        Mhe8QGYrFGgcYu9BWNrONbC6WKTjFdTTN8n4/KE4GHh0GIyK44aAWBzsHomMunAQXreb3rrN5vzM8
        zh6JiOswUIW21ehAUTNdFSI5RkyZUTreNy1+KIcDT8CQ44FxtqvY5zKzzHDGUvyS8C1QGi4eiWgnT
        gyr14JnJFloqNmUWjUcTJinAmc2Mv6z7t2NjuNxgeVjl4LqtijqrthE6z59ZBcGTcxWmMpxArrEQt
        g7P52KMSjKXHymHLtntW0subRaXwTLvmUvKDjql8F7wtAQiKWyP7LWF8NCksoH6AO7PFCCnkNp05/
        MohsRPZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQrcX-0007Lz-Pw; Fri, 09 Oct 2020 12:35:37 +0000
Date:   Fri, 9 Oct 2020 13:35:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot <syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: KASAN: use-after-free Read in __io_uring_files_cancel
Message-ID: <20201009123537.GR20115@casper.infradead.org>
References: <0000000000001a684d05b1385e71@google.com>
 <3a98a77a-a507-954a-f2ec-e38af18c168f@gmail.com>
 <20201009121211.GQ20115@casper.infradead.org>
 <6da35bc9-d072-c18b-2268-15d37fa786df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6da35bc9-d072-c18b-2268-15d37fa786df@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 09, 2020 at 03:28:54PM +0300, Pavel Begunkov wrote:
> On 09/10/2020 15:12, Matthew Wilcox wrote:
> >> It seems this fails on "node->shift" in xas_next_entry(), that would
> >> mean that the node itself was freed while we're iterating on it.
> >>
> >> __io_uring_files_cancel() iterates with xas_next_entry() and creates
> >> XA_STATE once by hand, but it also removes entries in the loop with
> >> io_uring_del_task_file() -> xas_store(&xas, NULL); without updating
> >> the iterating XA_STATE. Could it be the problem? See a diff below
> > 
> > No, the problem is that the lock is dropped after calling
> > xas_next_entry(), and at any point after calling xas_next_entry(),
> > the node that it's pointing to can be freed.
> 
> Only the task itself clears/removes entries, others can only insert.
> So, could it be freed even though there are no parallel erases?

Not with today's implementation, but that's something that might
change in the future.  I agree it's probably the task itself that's
deleting the entry and causing the node to be deleted.

