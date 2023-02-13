Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569F169405C
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 10:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjBMJIh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 04:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMJIg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 04:08:36 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDAF1206F;
        Mon, 13 Feb 2023 01:08:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRUoP-00AWqI-Sv; Mon, 13 Feb 2023 17:07:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Feb 2023 17:07:49 +0800
Date:   Mon, 13 Feb 2023 17:07:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     luto@kernel.org, david@fromorbit.com, willy@infradead.org,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+n95VtIG09MxZde@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg2Mb4ZgRuBthw6O0KLhZNksGBQNs73386Gdg4gHny=XA@mail.gmail.com>
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
>  -     if (!(sk->sk_route_caps & NETIF_F_SG))
>  +     if (!(sk->sk_route_caps & NETIF_F_SG) ||
>  +         !(sk->sk_route_caps & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM)))
>                return sock_no_sendpage_locked(sk, page, offset, size, flags);

NETIF_F_SG depends on checksum offload so it should already be
calling sock_no_sendpage_locked if checksum offload is not
supported.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
