Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F8A6B4DD3
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjCJQ73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 11:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjCJQ7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 11:59:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A8A1F4B2
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 08:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678467400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MEXbWR4Mui1qGAf1N0KRjooVxPuGH4qpgY7EflKN58I=;
        b=ecFrTRVXnOPlT49qJra/W9i0tQW4skGcX0FcRBbADkmc826VfCM+fioaZGzBWqbwAD0G9J
        ow+sM8BU5tTvCa/tHp1UIsj+e/aCXo05eUbT9WUPzczzgtOO2yLTqZur1NKUtAxylRByQ4
        g0pCJ2tNmkYKNCypHnVBSwyfNsLWIm8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-fluu-AfhOnGFHF-1KlcnRQ-1; Fri, 10 Mar 2023 11:56:36 -0500
X-MC-Unique: fluu-AfhOnGFHF-1KlcnRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 372F43C0E463;
        Fri, 10 Mar 2023 16:56:36 +0000 (UTC)
Received: from localhost (unknown [10.39.192.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1BE2C15BA0;
        Fri, 10 Mar 2023 16:56:30 +0000 (UTC)
Date:   Fri, 10 Mar 2023 11:56:28 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230310165628.GA491749@fedora>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora>
 <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="51HGqewKny2lCSCR"
Content-Disposition: inline
In-Reply-To: <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--51HGqewKny2lCSCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 10, 2023 at 11:14:04PM +0800, Ming Lei wrote:

Hi Ming,
Another question about this:

Does the io worker thread pool have limits so that eventually work
queues up and new work is not able to execute until in-flight work
completes?

In that case, even if io_uring_enter(2) accepts requests without
returning EBUSY/EAGAIN, it seems like there is still a deadlock scenario
when work that is executing depends on later work that is unable to
execute.

Stefan

--51HGqewKny2lCSCR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQLYTwACgkQnKSrs4Gr
c8gG6AgAu87F3b5QYS13JNKxh8pAPJxLQ3iahYPtWjhN+y73YUqTrqRgFeo3hl0T
0AtKuv6fupkgJ3tVVyU4D4nS9eeHs12D4A77zkWu6lBUcueWOW7iQyN0iRvgqUfp
axPfuCKtHmXF5NGajANSJgZr9+YB2+fvKGNkN4nrMDNzrL+QLj75ZgvcXHRTDmW/
awfDpwwmYXHW48oUbAevlZn3qcEfxTJPmf5+r/HFaG3EpyNdcI2ZnR6Shd7Y8Y8u
VN4hwGADBfk8f9yUSC4oDJ49qRbv7N9WZjZJKGBZPuVz6MzrL40WR9fY2cKVEDkV
fQ2vJMq9UnyHvqfc/r8qUS6cTB+F0A==
=7T95
-----END PGP SIGNATURE-----

--51HGqewKny2lCSCR--

