Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BC074FC67
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjGLAxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjGLAxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:53:36 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE5610C2;
        Tue, 11 Jul 2023 17:53:34 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 592A3C022; Wed, 12 Jul 2023 02:53:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689123211; bh=2PPbmxBCLNWUIUosy0ZPyfGZ8m9XBDaifkxbeh8u6bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tnjgNiwjS8zADT9HIHqgj1KhmU3H99WqmosM91ZheV8H1RAjQy8NxbaqujyIWgior
         BNlLNtKXEffCX0Ob41psLINXNTu1YZCb0BZdddHPuPheuHaFH3Hmx/3pdbMO2Qcium
         PIoi7HdhPS4s88EdhdwibG7SHbOWW6tDUIjKIXpavbM/rmGES58pwpfH5NRe+uggmW
         wP83jsoPFeVSs+jTmGXK011jOLKXKF+VBUvP94hBFuF2NgWXg7FkfqThXfUpa0pcC2
         528Gfp8EwBjS0pCaXlzIfNmgSJvLO6KbtfR1x3t96EckFjyZ7HxBYZ/kc7dByANRn1
         H8yHrEnMOL5MQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 259ACC009;
        Wed, 12 Jul 2023 02:53:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689123210; bh=2PPbmxBCLNWUIUosy0ZPyfGZ8m9XBDaifkxbeh8u6bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BfjSsW56/jhSaZcdZyaOrRdhhnO03sigwZ1bUPnOYPhgBOxie5Qej/AjBlB/0jH0W
         35YoO3Js4npRlU0KTEPInACxnM9krjp9UII6AzKri1Q9W2YeWkhflzVGVScsrPggRI
         4n7TqGDWuifAhypsvrVQElawvK1YjHFzBjWPYuNxaGLNTQwHTqTdKO7IxEuHq51DDg
         a3cxOon2/ve+gSodu5ZDlxh4AAIpBW9fFh4jbHUFkLDNACNxHaMC7M3JUOyIXEx8kd
         XdE/22YZ9yR4EPpjy93yeggBjHFGQVbGVvkt5Okvyo39FpitM2oy6t0YYtarCsG0Se
         rsz4BVdJb8dNA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 312b30bf;
        Wed, 12 Jul 2023 00:53:24 +0000 (UTC)
Date:   Wed, 12 Jul 2023 09:53:09 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v3 0/3] io_uring getdents
Message-ID: <ZK35dZN7pYg0VuF0@codewreck.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
 <5264f776-a5fd-4878-1b4c-7fe9f9a61b51@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5264f776-a5fd-4878-1b4c-7fe9f9a61b51@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe wrote on Tue, Jul 11, 2023 at 05:51:46PM -0600:
> > So what filesystem actually uses this new NOWAIT functionality?
> > Unless I'm blind (quite possibly) I don't see any filesystem
> > implementation of this functionality in the patch series.

I had implemented this for kernfs and libfs (so sysfs, debugfs, possibly
tmpfs/proc?) in v2

The patch as of v2's mail has a bug, but my branch has it fixed as of
https://github.com/martinetd/linux/commits/io_uring_getdents

(I guess these aren't "real" enough though)

> > I know I posted a prototype for XFS to use it, and I expected that
> > it would become part of this patch series to avoid the "we don't add
> > unused code to the kernel" problem. i.e. the authors would take the
> > XFS prototype, make it work, add support into for the new io_uring
> > operation to fsstress in fstests and then use that to stress test
> > the new infrastructure before it gets merged....
> > 
> > But I don't see any of this?
> 
> That would indeed be great if we could get NOWAIT, that might finally
> convince me that it's worth plumbing up! Do you have a link to that
> prototype? That seems like what should be the base for this, and be an
> inspiration for other file systems to get efficient getdents via this
> (rather than io-wq punt, which I'm not a huge fan of...).

the xfs poc was in this mail:
https://lore.kernel.org/all/20230501071603.GE2155823@dread.disaster.area/

I never spent time debugging it, but it should definitely be workable

-- 
Dominique Martinet | Asmadeus
