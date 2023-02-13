Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8F96941AC
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjBMJpK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 04:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjBMJol (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 04:44:41 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93EA3C21;
        Mon, 13 Feb 2023 01:44:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRV5S-00AXIL-A4; Mon, 13 Feb 2023 17:25:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Feb 2023 17:25:26 +0800
Date:   Mon, 13 Feb 2023 17:25:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     torvalds@linux-foundation.org, metze@samba.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210061953.GC2825702@dread.disaster.area>
X-Newsgroups: apana.lists.os.linux.kernel
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:
>
> IOWs, the application does not care if the data changes whilst they
> are in transport attached to the pipe - it only cares that the
> contents are stable once they have been delivered and are now wholly
> owned by the network stack IO path so that the OTW encodings
> (checksum, encryption, whatever) done within the network IO path
> don't get compromised.

Is this even a real problem? The network stack doesn't care at
all if you modify the pages while it's being processed.  All the
things you've mentioned (checksum, encryption, etc.) will be
self-consistent on the wire.

Even when actual hardware offload is involved it's hard to see how
things could possibly go wrong unless the hardware was going out of
its way to do the wrong thing by fetching from memory twice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
