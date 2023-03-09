Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB916B2935
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCIP5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 10:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIP5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 10:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF41E9CD8
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 07:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678377420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bXcNynDm4jw2e3d7SR5cmthgkE0sba83DjSsz8rM09o=;
        b=cVMYeyxeJWNfaEr55FGcdipCb55auu7fa0akpNc4oL19lIn2anIL4vyAVCyfA4O9zyvdD9
        SlTh59FSOvSOMGtv/diYN8An4t0GX3viannVZckoPribQzHJ7ubN/K7hCo8kh5PUq5zzJ+
        yaQHNbKSVodiHMABo2181LCabGAjawY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-MJq8SJyoNaiFsQ6RBrvZQw-1; Thu, 09 Mar 2023 10:56:57 -0500
X-MC-Unique: MJq8SJyoNaiFsQ6RBrvZQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D562D3C0E457;
        Thu,  9 Mar 2023 15:56:56 +0000 (UTC)
Received: from localhost (unknown [10.39.193.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5332840CF8ED;
        Thu,  9 Mar 2023 15:56:56 +0000 (UTC)
Date:   Thu, 9 Mar 2023 08:48:08 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: Resizing io_uring SQ/CQ?
Message-ID: <20230309134808.GA374376@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j3WOzlOhTqeqHYxJ"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--j3WOzlOhTqeqHYxJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
For block I/O an application can queue excess SQEs in userspace when the
SQ ring becomes full. For network and IPC operations that is not
possible because deadlocks can occur when socket, pipe, and eventfd SQEs
cannot be submitted.

Sometimes the application does not know how many SQEs/CQEs are needed upfront
and that's when we face this challenge.

A simple solution is to call io_uring_setup(2) with a higher entries
value than you'll ever need. However, if that value is exceeded then
we're back to the deadlock scenario and that worries me.

I've thought about userspace solutions like keeping a list of io_uring
contexts where a new io_uring context is created and inserted at the
head every time a resize is required. New SQEs are only submitted to the
head io_uring context. The older io_uring contexts are drained until the
CQ ring is empty and then destroyed. But this seems complex to me.

Another idea is a new io_uring_register(2) IORING_REGISTER_RING_SIZE
opcode:
1. Userspace ensures that the kernel has seen all SQEs in the SQ ring.
2. Userspace munmaps the ring fd.
3. Userspace calls io_uring_register(2) IORING_REGISTER_RING_SIZE with the new size.
4. The kernel allocates the new ring.
5. The kernel copies over CQEs that userspace has not consumed from the
   old CQ ring to the new one.
6. The io_uring_register(2) syscall returns.
7. Userspace mmaps the fd again.

How do you deal with changing ring size at runtime?

Thanks,
Stefan

--j3WOzlOhTqeqHYxJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQJ45gACgkQnKSrs4Gr
c8hk0wf9HIAHGmW22614rRJHisgmBEYB7B4FPY6aAGtSf6DPcbxT3MsLwZmlux5r
DJ/prhBRaUrHDYLkJ2qYjL1OSofZr/g38p1Dv+YHWRBgeYordkg/JbrsGfE9gygZ
x8cqvBWV0xvzGEj6SEHjvAiJQLBAV+EQ4XsJm7c5I/55X+kyKFXMJT6/BCTseaJd
KUNdwVpu2punsg7FWFHKnKA8olvs0+t68LWC5WyA883QsYKG+Gel9TUc93vy+Q/y
9oYOEqCqPNfNzUzkT0enuS8cDaTIEJfkLawZHGO3Nuq0OpdeUn4YAp16w7OKZ9Nu
X80JYdIWVZCailacp0/W8fZIz3BYbQ==
=AtIR
-----END PGP SIGNATURE-----

--j3WOzlOhTqeqHYxJ--

