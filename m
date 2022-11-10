Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8948D623969
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 03:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiKJCBx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Nov 2022 21:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiKJB7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Nov 2022 20:59:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DC61F2E3
        for <io-uring@vger.kernel.org>; Wed,  9 Nov 2022 17:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668045527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=1hVSUd4YaY6HwwWOKR0jXW16HT+uN3MPbG1vVO4zXwA=;
        b=a4bSPVV5e1/K1ppioFhqGbHGJJDv6a4TKw9IWVbR9QOppAHbLf9L7MTeSvRJKkjGF0YXEp
        KvoN6n3Ax/bU8OZ/gEHbAfBvDaSqBat/AlxbIIV8iz4bB1fR7g1pFCL5NKgbR91wdY8lzf
        /q5SdEls0KMymdQLiiGCwEyLZOWemXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-vS3pbUNcOMmmjpYkALR_9g-1; Wed, 09 Nov 2022 20:58:43 -0500
X-MC-Unique: vS3pbUNcOMmmjpYkALR_9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93827101A528;
        Thu, 10 Nov 2022 01:58:42 +0000 (UTC)
Received: from localhost (unknown [10.39.192.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B441140EBF5;
        Thu, 10 Nov 2022 01:58:40 +0000 (UTC)
Date:   Wed, 9 Nov 2022 20:58:39 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Dylan Yudaken <dylany@meta.com>,
        Dominik Thalhammer <dominik@thalhammer.it>, rjones@redhat.com,
        jmoyer@redhat.com
Subject: Re: liburing 2.3 API/ABI breakage
Message-ID: <Y2xaz5HwrGcbKJK8@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qx/8DVgGN8OKrBZC"
Content-Disposition: inline
In-Reply-To: <Y2wcUfHyS7pjlGNy@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--qx/8DVgGN8OKrBZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> 2. Going from size_t to unsigned int is ABI breakage. This is mitigated
>    on CPU architectures that share 32-bit/64-bit registers (i.e. rax/eax
>    on x86-64 and r0/x0/w0 on aarch64). There's no guarantee this works
>    on all architectures, especially when the calling convention passes
>    arguments on the stack.

Good news, I realized that io_uring_prep_getxattr() and friends are
static inline functions. ABI breakage doesn't come into play because
they are compiled into the application.

The const char * to char * API breakage issue still remains but there's
a pretty good chance that real applications already pass in char *.

Thanks,
Stefan

--qx/8DVgGN8OKrBZC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNsWs8ACgkQnKSrs4Gr
c8gYcQf9Hw9WxJP3vPIb4AElcN5oFDtnEYXHcpQrLBtDzxUCKj5t+W+DVxYKKEpv
umxU8676NeV9oXcZX14KRgRmOH9oxr7Blsp0zQ6ZV0eHgm+VZ2ygLiwL5Bx24oKp
xRgFIS/gm3WwwT5ggPxRqXLzLsg6v9mdJ0RvpRnnpHqAjVivT5IxRJS+44DC1sxW
8isjJaY+rHUOz9c//YBv+KnheBu+h5/RpYVzGQPAyGMOvgAnWGqeE4zI3KqjuRth
pQOEEwX9UIIaHZ/amAlY7jPe0X3d3U/wAWF+QoldyGZp0aZ4lCATEqmF4NXQFpGM
nnP+q8mEb/uBnSGrJzYBpI7TyFZ/YA==
=tRWF
-----END PGP SIGNATURE-----

--qx/8DVgGN8OKrBZC--

