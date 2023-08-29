Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7180F78C3AD
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 13:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjH2Lxw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 07:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjH2Lxa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 07:53:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF84194;
        Tue, 29 Aug 2023 04:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YZxpYOTF14BVcouqFhbahruwZXBLTSy2TCKsEoryGgA=; b=kNMS0YeYJE43XRXxkVUmLf2G+X
        0F+Ci8x/vmTvip6eYnQqjlZo85hPiq+1XBtqpwy24WfkqxJcN3oDroYdU0hmUGTZO8DmOvrKcLnsA
        I7wiz/QgNWUfJcZJ1P+jwtCGJuvaBfIm6i+nYBm4G4q1TzqZrEd8vmeeXhUF+nfDcEVXWTUFH8hQX
        gmgzKK6rDBAyLZFUyKz32+/IHnRsGl+xYuxNBS8JVzpCmXVMJxm/LAsn2AL2YmcWHqJedjjw347sz
        rnlxqkUfOTw1wHOoS2VuCxy8fDxR1A9rikvDXoQ9fhtzraRL7eHJTnjVX6n6aHUnUp8GZkipnoXzv
        988YMF3g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qaxHQ-006P4x-1X; Tue, 29 Aug 2023 11:53:08 +0000
Date:   Tue, 29 Aug 2023 12:53:07 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Message-ID: <ZO3cI+DkotHQo3md@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
> On 8/28/23 05:32, Matthew Wilcox wrote:
> > On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> > > From: Hao Xu <howeyxu@tencent.com>
> > > 
> > > Add a boolean parameter for file_accessed() to support nowait semantics.
> > > Currently it is true only with io_uring as its initial caller.
> > 
> > So why do we need to do this as part of this series?  Apparently it
> > hasn't caused any problems for filemap_read().
> > 
> 
> We need this parameter to indicate if nowait semantics should be enforced in
> touch_atime(), There are locks and maybe IOs in it.

That's not my point.  We currently call file_accessed() and
touch_atime() for nowait reads and nowait writes.  You haven't done
anything to fix those.

I suspect you can trim this patchset down significantly by avoiding
fixing the file_accessed() problem.  And then come back with a later
patchset that fixes it for all nowait i/o.  Or do a separate prep series
first that fixes it for the existing nowait users, and then a second
series to do all the directory stuff.

I'd do the first thing.  Just ignore the problem.  Directory atime
updates cause I/O so rarely that you can afford to ignore it.  Almost
everyone uses relatime or nodiratime.
