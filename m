Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90644528DF2
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345436AbiEPTbZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 15:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345443AbiEPTbY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 15:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 024922BB26
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 12:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652729473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=RAcicosbrzNtKq22oJlMdmRA4Z34sYOSW6vqrZPUyF0=;
        b=ObpJdIjEkGXP/VFR6RIH9NX1SgIdppQB0EP3n48jVFEc8jlSfNTbrPLEy6wtvcD5EMQqki
        EQbdMQqfPyQj+XrvwrUVvHb9BSUeoFSmXZr+W6IqG+HJLmcUZSxh85YEeEcrXeOQHqHTeK
        eSTzYcvnngeukSntCd39UJM+zeeTQ5s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-DCgS7vFaPTi9XkWYiP2xVw-1; Mon, 16 May 2022 15:31:09 -0400
X-MC-Unique: DCgS7vFaPTi9XkWYiP2xVw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCE983C1E321;
        Mon, 16 May 2022 19:31:08 +0000 (UTC)
Received: from localhost (unknown [10.39.192.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 714ED555087;
        Mon, 16 May 2022 19:31:08 +0000 (UTC)
Date:   Mon, 16 May 2022 20:29:25 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     ming.lei@redhat.com
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        kwolf@redhat.com, sgarzare@redhat.com
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Message-ID: <YoKmFYjIe1AWk/P8@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6o93nD4/ZHY926/y"
Content-Disposition: inline
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--6o93nD4/ZHY926/y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
This looks interesting! I have some questions:

1. What is the ubdsrv permission model?

A big usability challenge for *-in-userspace interfaces is the balance
between security and allowing unprivileged processes to use these
features.

- Does /dev/ubd-control need to be privileged? I guess the answer is
  yes since an evil ubdsrv can hang I/O and corrupt data in hopes of
  triggering file system bugs.
- Can multiple processes that don't trust each other use UBD at the same
  time? I guess not since ubd_index_idr is global.
- What about containers and namespaces? They currently have (write)
  access to the same global ubd_index_idr.
- Maybe there should be a struct ubd_device "owner" (struct
  task_struct *) so only devices created by the current process can be
  modified?

2. io_uring_cmd design

The rationale for the io_uring_cmd design is not explained in the cover
letter. I think it's worth explaining the design. Here are my guesses:

The same thing can be achieved with just file_operations and io_uring.
ubdsrv could read I/O submissions with IORING_OP_READ and write I/O
completions with IORING_OP_WRITE. That would require 2 sqes per
roundtrip instead of 1, but the same number of io_uring_enter(2) calls
since multiple sqes/cqes can be batched per syscall:

- IORING_OP_READ, addr=(struct ubdsrv_io_desc*) (for submission)
- IORING_OP_WRITE, addr=(struct ubdsrv_io_cmd*) (for completion)

Both operations require a copy_to/from_user() to access the command
metadata.

The io_uring_cmd approach works differently. The IORING_OP_URING_CMD sqe
carries a 40-byte payload so it's possible to embed struct ubdsrv_io_cmd
inside it. The struct ubdsrv_io_desc mmap gets around the fact that
io_uring cqes contain no payload. The driver therefore needs a
side-channel to transfer the request submission details to ubdsrv. I
don't see much of a difference between IORING_OP_READ and the mmap
approach though.

It's not obvious to me how much more efficient the io_uring_cmd approach
is, but taking fewer trips around the io_uring submission/completion
code path is likely to be faster. Something similar can be done with
file_operations ->ioctl(), but I guess the point of using io_uring is
that is composes. If ubdsrv itself wants to use io_uring for other I/O
activity (e.g. networking, disk I/O, etc) then it can do so and won't be
stuck in a blocking ioctl() syscall.

It would be nice if you could write 2 or 3 paragraphs explaining why the
io_uring_cmd design and the struct ubdsrv_io_desc mmap was chosen.

3. Miscellaneous stuff

- There isn't much in the way of memory ordering in the code. I worry a
  little that changes to the struct ubdsrv_io_desc mmap may not be
  visible at the expected time with respect to the io_uring cq ring.

Thanks,
Stefan

--6o93nD4/ZHY926/y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKCphUACgkQnKSrs4Gr
c8hrNAgAm3whe7oUQEB6dbQEsZj/jlnxPIiZq/Fr9/qmzrwAuaYZbQb7wxSij7gS
agI4tPMiNTdweZSwBQgDzsfaKTZPVJ1Hg7e3a2a8KO2rXgIpuroUVG9D5UIU5cbv
H1DysO+LRPe82xUkKTzeU6i4iUdIXar5R7hUCPUPZq/0+VMYHfbwwnXz3D37w/4i
YPYKxaq6uPB75kcC95XiztGm69CXTsSu8Uy6VRE11WEqy0fI5T+mkCx0CecxpKQW
fMpCO8VMcQKD4el7KiexTboeqA2kxbi1PxJninlh5S9zA8roQpUpLDS6LhwNlQeb
43+1hxRTFOsSai6oZzonuQaQdYi2Cg==
=vNPr
-----END PGP SIGNATURE-----

--6o93nD4/ZHY926/y--

