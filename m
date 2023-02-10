Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095536917A0
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 05:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjBJEo7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 23:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjBJEo6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 23:44:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7917C5AB17;
        Thu,  9 Feb 2023 20:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0tCVHXe8f8F6G11LlPtTlRNrXgXbYpXdoKqs4d7eeYU=; b=vVQhWqE8+N5tZRyw5ALi5xJuMB
        Op0AEOpA+p5htuG3aw2R/+TJsUZPd/E5aMDL1bU5/67LywoO+UE0Yq00FD+lgtln5H3j+o0cLqC9z
        goP3j0aIA7hqEDWa1xjyYXInKqVOCQP66MObM/ZBXr2sAhp+ReejusDW8arm9RhOZGob5TDeMGEsy
        LOPVuZ9Xn61NhZ8CwuNz6PGIf9ZYYHwY8Cg40oFfhriUy4OjmUIHHc5coFETmANPdo5BLrZ3MFFui
        BZLPMQkw69EMYCGAdud4RacK/JkDS2fNvqgobfiZFwKSUxWFlprFyFwufkMdpScF+gmBlHLNrmFFb
        CTf0eH9w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQLH7-002p17-Jw; Fri, 10 Feb 2023 04:44:41 +0000
Date:   Fri, 10 Feb 2023 04:44:41 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+XLuYh+kC+4wTRi@casper.infradead.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210040626.GB2825702@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 03:06:26PM +1100, Dave Chinner wrote:
> So while I was pondering the complexity of this and watching a great
> big shiny rocket create lots of heat, light and noise, it occurred

That was kind of fun

> to me that we already have a mechanism for preventing page cache
> data from being changed while the folios are under IO:
> SB_I_STABLE_WRITES and folio_wait_stable().

I thought about bringing that up, but it's not quite right.  That works
great for writeback, but it only works for writeback.  We'd need to track
another per-folio counter ... it'd be like the page pinning kerfuffle,
only worse.  And for such a rare thing it seems like a poor use of 32
bits of per-page state.  Not to mention that you can effectively block
all writes to a file for an indefinite time by splicing pages to a pipe
that you then never read from.

