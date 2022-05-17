Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399A352A447
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 16:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbiEQOHJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 10:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348454AbiEQOHC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 10:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C44CE4CD65
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 07:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652796406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bg665HrNuvrqLGhtUkpmUDqyIrWAj2xvJx1ld4vx7g=;
        b=S7AaVWsK+7WhkmOPELa5dP/ROtV1o2Yx1itIWkTtVPHDPFHm0qcxuHeLBr6OTmUTpmXUIG
        w9zNemTO6uKDCJASnPywA/d8A6t6RXykoZTzBAwA9EGMmjPLnUxLeNR7tU9EEAwffmxYu7
        TggT7i/HC+DpRWax/9H+1TwlhI1KfMI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-YNL4P8y7OJaFDTHMxVXhGw-1; Tue, 17 May 2022 10:06:39 -0400
X-MC-Unique: YNL4P8y7OJaFDTHMxVXhGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 446E11C0CE7B;
        Tue, 17 May 2022 14:06:36 +0000 (UTC)
Received: from localhost (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CB63400DFB5;
        Tue, 17 May 2022 14:06:35 +0000 (UTC)
Date:   Tue, 17 May 2022 15:06:34 +0100
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
Message-ID: <YoOr6jBfgVm8GvWg@stefanha-x1.localdomain>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uCYJ7l6rM0lflhAj"
Content-Disposition: inline
In-Reply-To: <20220517055358.3164431-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--uCYJ7l6rM0lflhAj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Here are some more thoughts on the ubd-control device:

The current patch provides a ubd-control device for processes with
suitable permissions (i.e. root) to create, start, stop, and fetch
information about devices.

There is no isolation between devices created by one process and those
created by another. Therefore two processes that do not trust each other
cannot both use UBD without potential interference. There is also no
isolation for containers.

I think it would be a mistake to keep the ubd-control interface in its
current form since the current global/root model is limited. Instead I
suggest:
- Creating a device returns a new file descriptor instead of a global
  dev_id. The device can be started/stopped/configured through this (and
  only through this) per-device file descriptor. The device is not
  visible to other processes through ubd-control so interference is not
  possible. In order to give another process control over the device the
  fd can be passed (e.g. SCM_RIGHTS).=20

Now multiple applications/containers/etc can use ubd-control without
interfering with each other. The security model still requires root
though since devices can be malicious.

FUSE allows unprivileged mounts (see fuse_allow_current_process()). Only
processes with the same uid as the FUSE daemon can access such mounts
(in the default configuration). This prevents security issues while
still allowing unprivileged use cases.

I suggest adapting the FUSE security model to block devices:
- Devices can be created without CAP_SYS_ADMIN but they have an
  'unprivileged' flag set to true.
- Unprivileged devices are not probed for partitions and LVM doesn't
  touch them. This means the kernel doesn't access these devices via
  code paths that might be exploitable.
- When another process with a different uid from ubdsrv opens an
  unprivileged device, -EACCES is returned. This protects other
  uids from the unprivileged device.
- When another process with a different uid from ubdsrv opens a
  _privileged_ device there is no special access check because ubdsrv is
  privileged.

With these changes UBD can be used by unprivileged processes and
containers. I think it's worth discussing the details and having this
model from the start so UBD can be used in a wide range of use cases.

Stefan

--uCYJ7l6rM0lflhAj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKDq+oACgkQnKSrs4Gr
c8gciAf+JxH0nZCAHY7X+muFxCm6VDyKoarHuOh9NAWV2JRk5Bb12LHTTfl0+1yn
UeZAQuRg7ez0Ur8CXPkc+5FCgBR/Ahqm7iThJ6tns+mErvKkducPXLiLXudZn11o
mdFgAI8bi2W/REoCKLYAweBWHLm2WnKVsL/wVfCDnpXWjE6HCVsFlYmQlBCWN0wD
HolEityrNvgAQeW/hVYV/2Lo6/OVBiLqU6gxMrHUvWlj0WMoLhkhLA4FIDNxs04i
RJYZODQv9jr+tDjYZ+s1ZN8H8AnKkRVTCcMpg76ADhuNMUQjQINGdgSty7uixy4a
BrIMVdd/t/ldnse1423hFtYsqmKnPg==
=OqHO
-----END PGP SIGNATURE-----

--uCYJ7l6rM0lflhAj--

