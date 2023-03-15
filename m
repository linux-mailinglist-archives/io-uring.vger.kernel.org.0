Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8416BB755
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 16:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjCOPQP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 11:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjCOPQO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 11:16:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABD0194
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 08:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678893330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=klsAdmpDB4z+ZchaS+AcWKxr35ntc4Y09NNAkUv1geU=;
        b=ivObFB3Pev2I4Roh4BHl+VcUSlrh5aryKE7ipsRwYHDXivxQnpmN7CAQDcPwwdTkIygYNg
        Ff6RYnaYgL7LaErcAps9IZNp6PiC427U3Jrfx2BdgkwNb9wyqSGLMmnd1A34+jTezC/ept
        cDx3SVqhskAcnjw35uv13lBLKuHOzJA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-HXATkYe3NYWFqMWqQT-8VQ-1; Wed, 15 Mar 2023 11:15:26 -0400
X-MC-Unique: HXATkYe3NYWFqMWqQT-8VQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D78488905A;
        Wed, 15 Mar 2023 15:15:26 +0000 (UTC)
Received: from localhost (unknown [10.39.194.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFCEA2166B26;
        Wed, 15 Mar 2023 15:15:25 +0000 (UTC)
Date:   Wed, 15 Mar 2023 11:15:24 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230315151524.GA14895@fedora>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora>
 <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8urKSKf1qwMBvKHj"
Content-Disposition: inline
In-Reply-To: <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--8urKSKf1qwMBvKHj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ming and Jens,
It would be great if you have time to clarify whether deadlocks can
occur or not. If you have any questions about the scenario I was
describing, please let me know.

Thanks,
Stefan

--8urKSKf1qwMBvKHj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQR4QsACgkQnKSrs4Gr
c8hjzwgAn+SZPIZn2y9FjP6ERKdX4s0YjhHbRilqhYEyv0tll174du5Dj2CQTp9W
JZQhZ06SnBd/qrMMvLDOEaWsY+w82I4ocsuxP2aPjFnGzYOOehWBzz7437aaukFj
z85x6hgQtU5AeyJBVk16LgIvDaTv75mWz2x1pqM9CDrt/soICx5hH5LAj6KUoUH5
mz/q7yf6hPTRQFSV9ffH/nBY2lwloDDjIP1XjXbt5mlGDlFgvBOig5KY02eAiYta
VMEPijSgWYrW20t/fQvDpVGr2KMtPgMGD9Q1aKSZYCimYh3y03/Zf8a8cqlwiMMn
v2KenhCTqYCSosdUO1B2CwJP6zDE7g==
=010Q
-----END PGP SIGNATURE-----

--8urKSKf1qwMBvKHj--

