Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE152B621
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiERJ1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 05:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiERJ0T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 05:26:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E377032EC7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652865978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ypcpodAUASkv2JRtUgvGkuSNnlg6pyR+DbkEGLpR0CU=;
        b=O0j480m5XvneQVymiWKzzm7bs26zqMtk8RWNpmPj9al5cSEHC2M2BqqSqWbYza4TvzUovN
        5L81/QLkpql4B0Jy3peaoVvs5XU5dGCYZ7zDc7ZbzfVjBlAtNUACdxmWKrKiVLEUAGnuUA
        0XDkNtetSDfGIRzbxAejJOfuQ3BdrmA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-c5i0cXoiNx-h4snN6HF6yw-1; Wed, 18 May 2022 05:26:14 -0400
X-MC-Unique: c5i0cXoiNx-h4snN6HF6yw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 283DE29DD9A3;
        Wed, 18 May 2022 09:26:14 +0000 (UTC)
Received: from localhost (unknown [10.39.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A33D61410F36;
        Wed, 18 May 2022 09:26:13 +0000 (UTC)
Date:   Wed, 18 May 2022 10:26:12 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <YoS7tNfivgBpjTyB@stefanha-x1.localdomain>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uQ+KaxYJkHU8tzHK"
Content-Disposition: inline
In-Reply-To: <20220517055358.3164431-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--uQ+KaxYJkHU8tzHK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> Another thing ubd driver handles is to copy data between user space buffer
> and request/bio's pages, or take zero copy if mm is ready for support it in
> future. ubd driver doesn't handle any IO logic of the specific driver, so
> it is small/simple, and all io logics are done by the target code in ubdserver.

On the topic of zero copy I guess there are two obvious approaches:

1. An mm solution that grants ubdsrv access to the I/O buffer pages. I
   think ZUFS had a strategy based on pinning server threads to CPUs and
   then having a per-CPU vma that can be changed cheaply
   (https://lwn.net/Articles/756625/).

2. A sendfile/splice solution where ubdsrv replies with <fd, offset,
   length> tuples instead of I/O completion and the UBD driver performs
   the I/O on behalf of ubdsrv.

   (A variation is to give ubdsrv a file descriptor so it can call
   sendfile(2) or related syscalls itself without ever having direct
   access to the I/O buffer pages.)

   This direction leads to LBA TLB designs like the old dm-userspace
   target
   (https://listman.redhat.com/archives/dm-devel/2006-April/msg00114.html)
   where the kernel keeps a TLB of <lba, length, fd, offset> so it can
   avoid sending requests to userspace when there is a TLB hit.
   Userspace's job is to program mappings into the LBA TLB and handle
   the slow path (e.g. allocating writes or compressed blocks). IMO the
   downside of this approach is that it's best to have it from the
   beginning - it's hard to retrofit existing ubdsrv code that is
   intended to process every I/O request instead of populating the LBA
   TLB.

Stefan

--uQ+KaxYJkHU8tzHK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKEu7QACgkQnKSrs4Gr
c8hcrwf+P3WvSIRwNhL/xjq3Z8mKE7lFw+gRRfZNQtYOp5HrCrT5Hrf7sK7O821K
CWm3Q4Lo48aK49PNqX9L8CDOvrTVVzP0OM5FuL3hTFAzcDHiHU4Iin3PlEGZkCWP
BBe0eU9oAEwGcYIQeSAsPrbEGR2cUBWkWobrNkkFTGgmyUOjSknFPKCi7O2i28l8
YXOk7nz67bxgxq5zb3YQR30KkB6gK3Uvuw9/PgnMSEq6LfPCXWrL+DUOSZaX8Gdt
07OCcsafkrDtPQSM6+X4jMyqkKjLc+I8Lv2w7fo2/tZYzG8ZCSE6Vn7Q6KHHv8w5
/8YbuHFdC5TuSMZ6Ui/fkKYVgoeegg==
=cB8L
-----END PGP SIGNATURE-----

--uQ+KaxYJkHU8tzHK--

