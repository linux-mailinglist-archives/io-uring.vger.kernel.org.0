Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D406955D3
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 02:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBNBW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 20:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBNBW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 20:22:28 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6D08A56;
        Mon, 13 Feb 2023 17:22:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRk1G-00ArAi-1U; Tue, 14 Feb 2023 09:22:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Feb 2023 09:22:06 +0800
Date:   Tue, 14 Feb 2023 09:22:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+riPviz0em9L9BQ@gondor.apana.org.au>
References: <20230210061953.GC2825702@dread.disaster.area>
 <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
 <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 13, 2023 at 10:01:27AM -0800, Andy Lutomirski wrote:
>
> There's a difference between "kernel speaks TCP (or whatever)
> correctly" and "kernel does what the application needs it to do".

Sure I get where you are coming from.  It's just that the other
participants in the discussion were thinking of stability for the
sake of TCP (or TLS or some other protocol the kernel implements)
and that simply is a non-issue.

Having a better way to communicate completion to the user would be
nice.  The only way to do it right now seems to be polling with
SIOCOUTQ.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
