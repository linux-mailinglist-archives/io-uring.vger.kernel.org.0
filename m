Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B97569419B
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 10:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjBMJoT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 04:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjBMJoQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 04:44:16 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EE212A;
        Mon, 13 Feb 2023 01:44:13 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRVA5-00AXXK-D2; Mon, 13 Feb 2023 17:30:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Feb 2023 17:30:13 +0800
Date:   Mon, 13 Feb 2023 17:30:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Laight <David.Laight@aculab.com>
Cc:     torvalds@linux-foundation.org, david@fromorbit.com,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+oDJR03MjoQJsNJ@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304d5286b6364da48a2bb1125155b7e5@AcuMS.aculab.com>
X-Newsgroups: apana.lists.os.linux.kernel
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

David Laight <David.Laight@aculab.com> wrote:
>
> It is also worth remembering that TCP needs to be able
> to retransmit the data and a much later time.
> So the application must not change the data until it has
> been acked by the remote system.

I don't believe changing the data on retransmit violates any
standards.  Correct me if I'm wrong :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
