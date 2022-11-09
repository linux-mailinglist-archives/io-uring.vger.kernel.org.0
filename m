Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36D96235DB
	for <lists+io-uring@lfdr.de>; Wed,  9 Nov 2022 22:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKIVdG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Nov 2022 16:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIVdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Nov 2022 16:33:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5194EDE8D
        for <io-uring@vger.kernel.org>; Wed,  9 Nov 2022 13:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668029528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=YDFpYilBoVtZz2GE0Fxd1FEB5yhCSnzsT9CiE4qMj48=;
        b=iv+Mg36ovU+g0jvi7+QjfrLQ5d0ktXRaHf52xfrEEG9pYlSuCPwJ9pb9u9bzndn3JYBSVl
        wpl1tbsI9LektOMpRnXKkSjRqZ9dykEmbL7TYJffItEfhk0eqoTnZj9oBbXJEZcvt91dyj
        aQE6l5oPdsSQTqZWcaZxYuGnEFAsZDw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-nVMyaZ6bPw6irLaaia7vRA-1; Wed, 09 Nov 2022 16:32:04 -0500
X-MC-Unique: nVMyaZ6bPw6irLaaia7vRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E49138149A6;
        Wed,  9 Nov 2022 21:32:04 +0000 (UTC)
Received: from localhost (unknown [10.39.192.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14606140EBF5;
        Wed,  9 Nov 2022 21:32:02 +0000 (UTC)
Date:   Wed, 9 Nov 2022 16:32:01 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Dylan Yudaken <dylany@meta.com>,
        Dominik Thalhammer <dominik@thalhammer.it>, rjones@redhat.com,
        jmoyer@redhat.com
Subject: liburing 2.3 API/ABI breakage
Message-ID: <Y2wcUfHyS7pjlGNy@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="khoCP9d5rpYIcCl0"
Content-Disposition: inline
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


--khoCP9d5rpYIcCl0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
While packaging liburing 2.3 for Fedora I came across API/ABI breakage.

By API compatibility I mean that source code that compiled against x.y
also compiles successfully against x.y+1. By ABI compatibility I mean
that executables linked against liburing.so.x continue to work when
upgrading from x.y to x.y+1.

Failure to maintain compatibility creates headaches for application
developers and distros because applications stop compiling or fail at
runtime.

Here are the liburing.h changes I'm concerned about. They were
introduced in commit c0ef135a033d ("Fix constant correctness error in
`getxattr`/`fgetxattr`") and commit 5698e179a130 ("fix len type of
fgettxattr etc"):

@@ -808,9 +989,9 @@ static inline void io_uring_prep_msg_ring(struct io_uri=
ng_sqe *sqe, int fd,

 static inline void io_uring_prep_getxattr(struct io_uring_sqe *sqe,
                                          const char *name,
-                                         const char *value,
+                                         char *value,
                                          const char *path,
-                                         size_t len)
+                                         unsigned int len)
 {
        io_uring_prep_rw(IORING_OP_GETXATTR, sqe, 0, name, len,
                                (__u64) (uintptr_t) value);
@@ -823,7 +1004,7 @@ static inline void io_uring_prep_setxattr(struct io_ur=
ing_sqe *sqe,
                                          const char *value,
                                          const char *path,
                                          int flags,
-                                         size_t len)
+                                         unsigned int len)
 {
        io_uring_prep_rw(IORING_OP_SETXATTR, sqe, 0, name, len,
                                (__u64) (uintptr_t) value);
@@ -832,10 +1013,10 @@ static inline void io_uring_prep_setxattr(struct io_=
uring_sqe *sqe,
 }

 static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
-                                          int         fd,
+                                          int fd,
                                           const char *name,
-                                          const char *value,
-                                          size_t      len)
+                                          char *value,
+                                          unsigned int len)
 {
        io_uring_prep_rw(IORING_OP_FGETXATTR, sqe, fd, name, len,
                                (__u64) (uintptr_t) value);
@@ -843,11 +1024,11 @@ static inline void io_uring_prep_fgetxattr(struct io=
_uring_sqe *sqe,
 }
=20
 static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
-                                          int         fd,
-                                          const char *name,
-                                          const char *value,
-                                          int         flags,
-                                          size_t      len)
+                                          int          fd,
+                                          const char   *name,
+                                          const char   *value,
+                                          int          flags,
+                                          unsigned int len)
 {
        io_uring_prep_rw(IORING_OP_FSETXATTR, sqe, fd, name, len,
                                (__u64) (uintptr_t) value);

Issues:

1. Going from const char * to char * is API breakage. This is mitigated
   by the fact that applications should have passed non-const pointers
   in the first place because getxattr and fgetxattr modify value.
   Technically this is still API breakage because applications that
   previously compiled could now encounter a compilation error.

2. Going from size_t to unsigned int is ABI breakage. This is mitigated
   on CPU architectures that share 32-bit/64-bit registers (i.e. rax/eax
   on x86-64 and r0/x0/w0 on aarch64). There's no guarantee this works
   on all architectures, especially when the calling convention passes
   arguments on the stack.

With a bit of luck today's applications won't be affected in practice;
xattrs are used relatively rarely and there are mitigating factors.

Please review for API/ABI breakage when merging code.

Thanks,
Stefan

--khoCP9d5rpYIcCl0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNsHFAACgkQnKSrs4Gr
c8ipFwgAidQ4JGXKQygvSej5uhHqINMZLW2vQyXL1u2ZZhsuBEKdvhdYRyWKo9sk
T3CBjk9+Ab57M3YfG1dbf9jWoVQdPpUuXOUX+KHX5sexCvwnMUemt3N8DfgVCaXH
K3Y/7BwHBVvK1EkUMazAaxKmPFbL5RpZPHvmgvJ7B9bdHXF+aE6CZTYMNkXJeZF7
GuSR4QDYQFviZTjWYeNe5Bc/vF+Dt1zFiOdsbNUzfBbMJLlfU7Ty3zzaO5o3Qamj
mH6SeVeaq8DNwv8lZhn0ruLIHu6tjlOKOJ+jzSN38zjbOdGG2sJ90CVanYwEabjU
81nzKsrreUK+GpNpSU5Bk4i/32GXsw==
=loPz
-----END PGP SIGNATURE-----

--khoCP9d5rpYIcCl0--

