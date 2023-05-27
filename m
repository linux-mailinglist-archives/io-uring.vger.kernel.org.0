Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3FB7131C6
	for <lists+io-uring@lfdr.de>; Sat, 27 May 2023 03:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjE0BtV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 May 2023 21:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjE0BtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 May 2023 21:49:20 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA019A;
        Fri, 26 May 2023 18:49:16 -0700 (PDT)
User-agent: mu4e 1.10.3; emacs 29.0.91
From:   Sam James <sam@gentoo.org>
To:     info@bnoordhuis.nl, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org, kernel@gentoo.org
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
In-Reply-To: <20230506095502.13401-1-info@bnoordhuis.nl>
Date:   Sat, 27 May 2023 02:48:34 +0100
Message-ID: <87ttvy1r3c.fsf@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi,

New libuv is indeed in the wild now and CMake uses it, so I end up
getting
a tonne of:
```
[ 1763.697364] isc-net-0000: epoll_ctl support in io_uring is deprecated
and will be removed in a future Linux kernel version.
```

Could you confirm if this patch looks likely to land so we know if it's
OK
to backport it downstream?

Thank you!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iOUEARYKAI0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCZHFhmF8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MA8cc2FtQGdlbnRv
by5vcmcACgkQc4QJ9SDfkZBX0wD+Pd15Cd9i8DhmGvLSJRdz+ra6VguwbNZVwusY
+NrcvoQA/1SzXYYp3MOHLPjQJE7At7A2VUR9lLDoJzrUlkEENfIB
=c4wr
-----END PGP SIGNATURE-----
--=-=-=--
