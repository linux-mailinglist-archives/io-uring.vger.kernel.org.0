Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DD2736D66
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjFTNdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjFTNdJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:33:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D421AC
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687267941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NfXu7ThUqIAPlREOD/9ZogTFEytOZvW1rKqxsps37BQ=;
        b=GZm/fdG9J6uooogzPjVma3dZn8iNwlERHhxPLsh+5D3Ty/0dw3B694/48O0rZruiRhsMNM
        9N+XP1NCN6wCb+Tc7njacr54chUB27LfVp1WD01uSM6WdNA/wgq4QwCpeiPWR/XI4OaCaz
        xDf35z2aORWcCKWWgS+qYwh9pzFfs9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-949fe7ktNAyxR3WBA60G7w-1; Tue, 20 Jun 2023 09:32:11 -0400
X-MC-Unique: 949fe7ktNAyxR3WBA60G7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD94D185A7B6;
        Tue, 20 Jun 2023 13:32:03 +0000 (UTC)
Received: from localhost (unknown [10.39.193.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4493B492B01;
        Tue, 20 Jun 2023 13:32:02 +0000 (UTC)
Date:   Tue, 20 Jun 2023 15:31:52 +0200
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     io-uring@vger.kernel.org
Cc:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: False positives in nolibc check
Message-ID: <20230620133152.GA2615339@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q6XRqsd2F7TXQVoh"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--q6XRqsd2F7TXQVoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
The nolibc build is enabled on x86-64, i686, and aarch64 since commit
bfb432f4cce5 ("configure: Always enable `CONFIG_NOLIBC` if the arch is
supported").

When I build the liburing 2.4 rpm package for Fedora i686, nolibc is
enabled but the following compilation error occurs:

  gcc -fPIC -O2 -flto=auto -ffat-lto-objects -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -m32 -march=i686 -mtune=generic -msse2 -mfpmath=sse -mstackrealign -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection  -Wno-unused-parameter -DLIBURING_INTERNAL  -nostdlib -nodefaultlibs -ffreestanding -fno-builtin -shared -Wl,--version-script=liburing.map -Wl,-soname=liburing.so.2 -o liburing.so.2.4 setup.os queue.os register.os syscall.os version.os nolibc.os -Wl,-z,relro -Wl,--as-needed  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes  -nostdlib -nodefaultlibs
  make[1]: Leaving directory '/builddir/build/BUILD/liburing-2.4/src'
  /usr/bin/ld: /tmp/cca16k90.ltrans0.ltrans.o: in function `__io_uring_submit':
  /builddir/build/BUILD/liburing-2.4/src/queue.c:388: undefined reference to `__stack_chk_fail_local'

This is caused by the stack protector compiler options, which depend on
the libc __stack_chk_fail_local symbol.

The compile_prog check in ./configure should use the final
CFLAGS/LDFLAGS (including -ffreestanding) that liburing is compiled with
to avoid false positives. That way it can detect that nolibc won't work
with these compiler options and fall back to using libc.

In general, I'm concerned that nolibc is fragile because the toolchain
and libc sometimes have dependencies that are activated by certain
compiler options. Some users will want libc and others will not. Maybe
make it an explicit option instead of probing?

I've included a downstream patch in the Fedora package that disables
nolibc for the time being.

Thanks,
Stefan

--q6XRqsd2F7TXQVoh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSRqkgACgkQnKSrs4Gr
c8icYAf/YYTeQkjGUarKizyQ+527NAf8GBqT+tef3s1x8tSWjbajX6s8mr2B1V0c
ShYnYh8p7LRkKRf/FsrO2ZQK478d0wH1JW6/cDLXxKzxfsldnHrbDMZlsTzghEuK
J8yQcebdNjgXGdk3vGC1UsSDWNKDQbYJiN/oyZEj/rXzo4A7uvORJhJinB+qNR5G
Wj0AyJBn1NcftPpa3I4UaJxvgD7AtFKFEtoJwSOUwNrfSkb5phAhD2HtQ7MZWNkL
cHkYOwmAjJ63PcqJri+8hTY72MLG2mUNoz2Vr5p5+QScJiLAvTnaYIuoMsXwtbVd
1PPhtGL/pxd5CIqkoowJZ0agofda9Q==
=dIJQ
-----END PGP SIGNATURE-----

--q6XRqsd2F7TXQVoh--

