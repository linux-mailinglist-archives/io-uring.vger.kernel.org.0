Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F76EC7FD
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDXIlq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 04:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDXIlp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 04:41:45 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F0E48;
        Mon, 24 Apr 2023 01:41:42 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 46BEAC009; Mon, 24 Apr 2023 10:41:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682325701; bh=eico9CA8NETTY0+AtDEEdQCQcAv+OvlCAUKciOQojjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tau0J9eSqnJS64en/AQgIDFGmRUWNhYd0ox3xnyQ5zVKfdIpWvC6wAssvaXBp2KzA
         wT20elrs53lNYrduGVldUJ8xeOLBoL4HIyj41zml15QR4lXGrmeVOFGodCgC/WLmIC
         mzWTdOoXrBzCca3USZNp7WsJngy2G2UNcLbkWgLSEBPqXLXzAMt16F2USvVMTyjlVp
         I4s5odRmS2WWzWxSqoinJTehxAGbwQn0eOejgKcg3xXxFHJLG7Iyh/NMEC7pgjo0YX
         wxdHtj0TMjXQ3xJ+FCwAgXF4RbGvzSIylisLWCqmSkkSWAktNoIAGVPDh/mDpOBF3l
         Xa+HDa1PILA0g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 59CB0C009;
        Mon, 24 Apr 2023 10:41:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682325700; bh=eico9CA8NETTY0+AtDEEdQCQcAv+OvlCAUKciOQojjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MN9I73+z63Qabgec65lkgNTKom6HV21MWDMdmhLxw/OiLBWNZJSr90Gw5JhA8y1gv
         3pOzXBXBcHk4ohDcS+LbzAolsRgXYCrIG6pyVlLqY6jkeC99/gGxXBcE5kfp5N3mPs
         Rr5kCGfk10WsRLxzANY4J4gzOJ5In03ZTPl/WuITJ0j7Ey5YwfRoNlrt5oYNbSIRdx
         iHJpjsetlYocUMXv3U6GMRJdPtsbICOijw0PMC59rE2ZEwq3Jnf7WYsmdV5p5watE+
         ve1Np3OCj0m645te0nHhIRRDsUFEUDu97/0wVdyxp2QA/4ayXxa2dIRrIaFJU+Zjew
         ToAyMDVaqbUqg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 8c0edd9c;
        Mon, 24 Apr 2023 08:41:33 +0000 (UTC)
Date:   Mon, 24 Apr 2023 17:41:18 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Clay Harris <bugs@claycon.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZEZArsLzVZnSMG_o@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230424072946.uuzjvuqrch7m4zuk@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230424072946.uuzjvuqrch7m4zuk@ps29521.dreamhostps.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thanks!

Clay Harris wrote on Mon, Apr 24, 2023 at 02:29:46AM -0500:
> This also seems like a good place to bring up a point I made with
> the last attempt at this code.  You're missing an optimization here.
> getdents knows whether it is returning a buffer because the next entry
> won't fit versus because there are no more entries.  As it doesn't
> return that information, callers must always keep calling it back
> until EOF.  This means a completely unnecessary call is made for
> every open directory.  In other words, for a directory scan where
> the buffers are large enough to not overflow, that literally twice
> as many calls are made to getdents as necessary.  As io_uring is
> in-kernel, it could use an internal interface to getdents which would
> return an EOF indicator along with the (probably non-empty) buffer.
> io_uring would then return that flag with the CQE.

Sorry I didn't spot that comment in the last iteration of the patch,
that sounds interesting.

This isn't straightforward even in-kernel though: the ctx.actor callback
(filldir64) isn't called when we're done, so we only know we couldn't
fill in the buffer.
We could have the callback record 'buffer full' and consider we're done
if the buffer is full, or just single-handedly declare we are if we have
more than `MAXNAMLEN + sizeof(struct linux_dirent64)` left over, but I
assume a filesystem is allowed to return what it has readily available
and expect the user to come back later?
In which case we cannot use this as an heuristic...

So if we do this, it'll require a way for filesystems to say they're
filling in as much as they can, or go the sledgehammer way of adding an
extra dir_context dir_context callback, either way I'm not sure I want
to deal with all that immediately unless I'm told all filesystems will
fill as much as possible without ever failing for any temporary reason
in the middle of iterate/iterate_shared().
Call me greedy but I believe such a flag in the CQE could also be added
later on without any bad side effects (as it's optional to check on it
to stop calling early and there's no harm in not setting it)?


> (* As an aside, the only place I've ever seen a non-zero lseek on a
> directory, is in a very resource limited environment, e.g. too small
> open files limit.  In the case of a depth-first directory scan, it
> must close directories before completely reading them, and reopen /
> lseek to their previous position in order to continue.  This scenario
> is certainly not worth bothering with for io_uring.)

(I also thought of userspace NFS/9P servers are these two at least get
requests from clients with an arbitrary offset, but I'll be glad to
forget about them for now...)

-- 
Dominique Martinet | Asmadeus
