Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A5869C4D0
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 05:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBTEzH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Feb 2023 23:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTEzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Feb 2023 23:55:06 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF979753;
        Sun, 19 Feb 2023 20:55:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pTyCK-00DEmI-ML; Mon, 20 Feb 2023 12:54:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Feb 2023 12:54:44 +0800
Date:   Mon, 20 Feb 2023 12:54:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y/L9FO3IbPS8/n4g@gondor.apana.org.au>
References: <20230210061953.GC2825702@dread.disaster.area>
 <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
 <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
 <Y+riPviz0em9L9BQ@gondor.apana.org.au>
 <CALCETrXr8vRPqEjhSg7=adQcM7OfWs_+fn2xP5OQeLXAaLzHHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXr8vRPqEjhSg7=adQcM7OfWs_+fn2xP5OQeLXAaLzHHQ@mail.gmail.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 17, 2023 at 03:13:14PM -0800, Andy Lutomirski wrote:
>
> I can certainly imagine TLS or similar protocols breaking if data
> changes if the implementation is too clever and retransmission
> happens.  Suppose 2000 bytes are sent via splice using in-kernel TLS,
> and it goes out on the wire as two TCP segments.  The first segment is
> dropped but the second is received.  The kernel resends the first
> segment using different data.  This really ought to cause an integrity
> check at the far end to fail.

The TLS layer is completely separate from TCP so it's like any
normal TCP user from user-space.  IOW the encrypted data will be
held by TCP until acknowledged so during retransmission it will
simply resend the previously encrypted data rather than encrypting
the same data twice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
