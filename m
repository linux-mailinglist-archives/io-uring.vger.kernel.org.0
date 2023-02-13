Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF556941A4
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 10:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjBMJo0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 04:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjBMJoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 04:44:24 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D7C65B;
        Mon, 13 Feb 2023 01:44:16 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRV8C-00AXUe-BO; Mon, 13 Feb 2023 17:28:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Feb 2023 17:28:16 +0800
Date:   Mon, 13 Feb 2023 17:28:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     david@fromorbit.com, metze@samba.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+oCsDslHb4fTt3d@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgXvRKwsHUjA9T9Tw6n5x1pCO6B+4kk0GAx+oQ5qhUyRw@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Ok, so I decided to try to take a look.
> 
> Somebody who actually does networking (and drivers in particular)
> should probably check this, but it *looks* like the IPv4 TCP case
> (just to pick the ony I looked at) gores through
> tcp_sendpage_locked(), which does
> 
>        if (!(sk->sk_route_caps & NETIF_F_SG))
>                return sock_no_sendpage_locked(sk, page, offset, size, flags);
> 
> which basically says "if you can't handle fragmented socket buffers,
> do that 'no_sendpage' case".
> 
> So that will basically end up just falling back to a kernel
> 'sendmsg()', which does a copy and then it's stable.
> 
> But for the networks that *can* handle fragmented socket buffers, it
> then calls do_tcp_sendpages() instead, which just creates a skb
> fragment of the page (with tcp_build_frag()).
> 
> I wonder if that case should just require NETIF_F_HW_CSUM?

NETIF_F_SG already depends on checksum offload (either via
NETIF_F_HW_CSUM or something else that is equivalent).

So are you guys just imagining non-existant problems?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
