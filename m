Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286C96EC712
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjDXHaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 03:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjDXH36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 03:29:58 -0400
Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BECE53;
        Mon, 24 Apr 2023 00:29:53 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 274B68C0DA8;
        Mon, 24 Apr 2023 07:29:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 937BC8C0D91;
        Mon, 24 Apr 2023 07:29:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1682321388; a=rsa-sha256;
        cv=none;
        b=i1VYIHVqcBq38YFvy6ObTOw3nGZBFrks8Jkp9bMNJlemw9MYMr3+qRcUeJrfrzkLzTeW/H
        BH4rN4z5LLJTim1JIAb5A5RhG8gA2v+lsAD+9JGz1D+9qSv3TUSWWIdX1SN1yoesfUY2sr
        ztPwJWIHyroyJnpCyIKKVsWwAUlecVeyul7oFsr3PqiPnBAy8kfgyn1x8m766YD8FEyhPc
        gCJyr9guBK0lFQYhnRsleNRBa82UAI55NYS5YIx09NXJcOWmmzOvtf0CoQ1L63HwnxaRdD
        lXdfRZBrsvRMMEJp6FexpPuOrK0WmoC4cRrMbAEBmMLwlznER10MHYN3//ZyFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1682321388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=xkn+0/xEzUELhMvEZfNFaqYe4uOX5uMuyqs9IjhPVzE=;
        b=mRlXnkJioK+gqIbuLLlHXxv0sKj9alkKRTuDMutYDiarQWW+eACnG/8eojlwMuvGoOHrce
        nn8TG6rg9MPuhA2J4HTG1vAVsZud5AlM4UK0vF6JtKpHQ4QtgO3yacDfPSZKUwLoflv9hm
        YBj9ntHIGYZAxQCg3N6tNTo6tZ9BSpcnthOfUULGUJfaTvmi/jHSNj1usmyUMdrEp2aGlb
        g9EFyv1PsmupifvPPPGdAvCYLwGRRkYl6JGWmFPwj2Edb4hT4H5Z+ux7X/OxR3ztQH8Lp5
        3h62RwXpsWB3r+X1g4IGeKQ8g3pa93LR4Sk9QFRcMAE6+lXmLwG5kLLK2bh34w==
ARC-Authentication-Results: i=1;
        rspamd-548d6c8f77-vc5xk;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=bugs@claycon.org
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Supply-Ski: 5099a5e03bb63a7d_1682321388899_1523740686
X-MC-Loop-Signature: 1682321388899:308728539
X-MC-Ingress-Time: 1682321388899
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.97.48.69 (trex/6.7.2);
        Mon, 24 Apr 2023 07:29:48 +0000
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4Q4cGN2G8Lz3K;
        Mon, 24 Apr 2023 00:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=claycon.org;
        s=dreamhost; t=1682321388;
        bh=xkn+0/xEzUELhMvEZfNFaqYe4uOX5uMuyqs9IjhPVzE=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=SPoanSj/h/pitmFSCkVNu5JJ4uBLBxOEt1chC9h5m8V6oeqZAhJs2HvF4RrYIP/rQ
         eEcl2XZQviKcBVZCHMLWEoV9uqJr+m43DXRPGBtsM1R9HCWhrBZTTc2CkmPamTKj6l
         M/NTskKIoLGk+PhGfpuZueXKZy2i/aL+rm3jkT1L1aIf3Q97GdjweJu4/9XjASx0op
         pcgoOlMnbU5ja36TK3s7WOi9u3D+Bd8sbrF7XMJZlFz2TjxPdoa+fkXmTJEXacRZ4C
         hpGdrJgYNqgIbYq0GYvVIzmbwcvikmx6b680z7Hkem8w+rWeeBaz7GNeM8ohmNxWTL
         2f7WnP1wc++xA==
Date:   Mon, 24 Apr 2023 02:29:46 -0500
From:   Clay Harris <bugs@claycon.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230424072946.uuzjvuqrch7m4zuk@ps29521.dreamhostps.com>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEXChAJfCRPv9vbs@codewreck.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 24 2023 at 08:43:00 +0900, Dominique Martinet quoth thus:

> Dave Chinner wrote on Mon, Apr 24, 2023 at 08:40:45AM +1000:
> > This doesn't actually introduce non-blocking getdents operations, so
> > what's the point? If it just shuffles the getdents call off to a
> > background thread, why bother with io_uring in the first place?
> 
> As said in the cover letter my main motivation really is simplifying the
> userspace application:
>  - style-wise, mixing in plain old getdents(2) or readdir(3) in the
> middle of an io_uring handling loop just feels wrong; but this may just
> be my OCD talking.
>  - in my understanding io_uring has its own thread pool, so even if the
> actual getdents is blocking other IOs can progress (assuming there is
> less blocked getdents than threads), without having to build one's own
> extra thread pool next to the uring handling.
> Looking at io_uring/fs.c the other "metadata related" calls there also
> use the synchronous APIs (renameat, unlinkat, mkdirat, symlinkat and
> linkat all do), so I didn't think of that as a problem in itself.

Having written code to create additional worker threads in addition
to using io_uring as a main loop, I'm glad to see this proposal back
again.  I think the original work was shot down much too hastily based
on the file positioning issues.  Really only two cases of directory
position are useful*, which can be expressed either as an off_t
(0 = rewind, -1 = curpos), or a single bit flag.  As I understand the
code, the rewind case shouldn't be any problem.  From a practical
viewpoint, I don't think non-blocking would see a lot of use, but it
wouldn't hurt.

This also seems like a good place to bring up a point I made with
the last attempt at this code.  You're missing an optimization here.
getdents knows whether it is returning a buffer because the next entry
won't fit versus because there are no more entries.  As it doesn't
return that information, callers must always keep calling it back
until EOF.  This means a completely unnecessary call is made for
every open directory.  In other words, for a directory scan where
the buffers are large enough to not overflow, that literally twice
as many calls are made to getdents as necessary.  As io_uring is
in-kernel, it could use an internal interface to getdents which would
return an EOF indicator along with the (probably non-empty) buffer.
io_uring would then return that flag with the CQE.


(* As an aside, the only place I've ever seen a non-zero lseek on a
directory, is in a very resource limited environment, e.g. too small
open files limit.  In the case of a depth-first directory scan, it
must close directories before completely reading them, and reopen /
lseek to their previous position in order to continue.  This scenario
is certainly not worth bothering with for io_uring.)

> > Filesystems like XFS can easily do non-blocking getdents calls - we
> > just need the NOWAIT plumbing (like we added to the IO path with
> > IOCB_NOWAIT) to tell the filesystem not to block on locks or IO.
> > Indeed, filesystems often have async readahead built into their
> > getdents paths (XFS does), so it seems to me that we really want
> > non-blocking getdents to allow filesystems to take full advantage of
> > doing work without blocking and then shuffling the remainder off to
> > a background thread when it actually needs to wait for IO....
> 
> I believe that can be done without any change of this API, so that'll be
> a very welcome addition when it is ready; I don't think the adding the
> uring op should wait on this if we can agree a simple wrapper API is
> good enough (or come up with a better one if someone has a Good Idea)
> 
> (looking at io_uring/rw.c for comparison, io_getdents() will "just" need
> to be adjusted to issue an async req if IO_URING_F_NONBLOCK is set, and
> the poll/retry logic sorted out)
> 
> Thanks,
> -- 
> Dominique Martinet | Asmadeus
