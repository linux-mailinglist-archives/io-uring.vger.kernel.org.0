Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650516ECAC1
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 12:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjDXK4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 06:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjDXK4B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 06:56:01 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB296102;
        Mon, 24 Apr 2023 03:55:58 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 815D2C009; Mon, 24 Apr 2023 12:55:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682333757; bh=+MS0YxqaeDtTZBNGlET6Bd6fdmX1lesQ7s2T+3IowkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8o83q94cpPGl/a7SF7ImB6UTuXI2BoJUKa0N7Q8xkNqrbsCNPQRaqkJ2VgheLeYV
         JPk+XhyR23XoxcdvGBtpKAwkCNuNAC2ess20oVJZnITyk/v/r1+Fs9kw6+U6XuTJzK
         HAYoxKzAYPvZmbOvnUtPef+96r/V++ZgZY9v1jQWrKjstNpagwNwO8+IVCH+cKiWsk
         oW4qfr5az2PUUZJvcKagUZmKP9Mjq5oQtIAfChhoclyf6xmh0pZbB6EeRjeNItsaHl
         ssUbhdVU6Xvmclat8GJ1ekn+OBS18w0nkcUtQAeQgaaXNePvetsCYCJoIYYtSCVzrq
         3mAPEdef8SuNw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id EB381C009;
        Mon, 24 Apr 2023 12:55:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682333755; bh=+MS0YxqaeDtTZBNGlET6Bd6fdmX1lesQ7s2T+3IowkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0RzYoi9iXNy228EY05MbLAIEdBX/JB8uhpqqlusGM/sOecPaXUlqY4TjsOUzqgMes
         ZIa/j2x2iFeFManKGI/t3s2puKbc1MOvLSzNa4tHMjLmfsoaNvkE3mHPyQ7/hqfqgL
         Hjowrd/Ree7FjcoUqN4ksHZTexYdNQUuXf5RRTNi4gHrRbqMRoyCKz3ELnjaT/yBuD
         JH8MD7UBZHL+AAFjloO3yE4FrEUw/P6F7ByAJN/SXBznUAvx1hPMt96vT/qyzxzznK
         X8VSKmNoJDHwdfGNSXenwyhOCgRot2xLcPilBI6nxNSbRYbFJ5+E0HZ81Y29WP4ZhH
         DTYCUF03F0y0Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 66df0b02;
        Mon, 24 Apr 2023 10:55:50 +0000 (UTC)
Date:   Mon, 24 Apr 2023 19:55:35 +0900
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
Message-ID: <ZEZgJ6OkU9O-07mT@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230424072946.uuzjvuqrch7m4zuk@ps29521.dreamhostps.com>
 <ZEZArsLzVZnSMG_o@codewreck.org>
 <20230424092054.q6iiqqnrohenr5d2@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230424092054.q6iiqqnrohenr5d2@ps29521.dreamhostps.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clay Harris wrote on Mon, Apr 24, 2023 at 04:20:55AM -0500:
> > This isn't straightforward even in-kernel though: the ctx.actor callback
> > (filldir64) isn't called when we're done, so we only know we couldn't
> > fill in the buffer.
> > We could have the callback record 'buffer full' and consider we're done
> > if the buffer is full, or just single-handedly declare we are if we have
> > more than `MAXNAMLEN + sizeof(struct linux_dirent64)` left over, but I
> > assume a filesystem is allowed to return what it has readily available
> > and expect the user to come back later?
> > In which case we cannot use this as an heuristic...
> > 
> > So if we do this, it'll require a way for filesystems to say they're
> > filling in as much as they can, or go the sledgehammer way of adding an
> > extra dir_context dir_context callback, either way I'm not sure I want
> > to deal with all that immediately unless I'm told all filesystems will
> > fill as much as possible without ever failing for any temporary reason
> > in the middle of iterate/iterate_shared().
> 
> I don't have a complete understanding of this area, but my thought was
> not that we would look for any buffer full condition, but rather that
> an iterator could be tested for next_entry == EOF.

I'm afraid I don't see any such iterator readily available in the common
code, so that would also have to be per fs as far as I can see :/

Also some filesystems just don't have a next_entry iterator readily
available; for example on 9p the network protocol is pretty much exactly
like getdents and a readdir call is issued continuously until either
filldir64 returns an error (e.g. buffer full) or the server returned 0
(or an error); if you leave the v9fs_dir_readdir{,_dotl}() call you
loose this information immediately.
Getting this information out would be doubly appreciable because the
"final getdents" to confirm the dir has been fully read is redundant
with that previous last 9p readdir which ended the previous iteration
(could also be fixed by caching...), but that'll really require fixing
up the iterate_shared() operation to signal such a thing...

> > Call me greedy but I believe such a flag in the CQE could also be added
> > later on without any bad side effects (as it's optional to check on it
> > to stop calling early and there's no harm in not setting it)?
> 
> Certainly it could be added later, but I wanted to make sure some thought
> was put into it now.  It would be nice to have it sooner rather than later
> though...

Yes, if there's an easy way forward I overlooked I'd be happy to spend a
bit more time on it; and discussing never hurts.
In for a penny, in for a pound :)

-- 
Dominique Martinet | Asmadeus
