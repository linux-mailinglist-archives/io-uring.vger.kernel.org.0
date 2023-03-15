Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4E6BBCE3
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 20:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCOTDB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOTCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 15:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2CFC178
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 12:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678906912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HvObpj6uQuBdJz6toMh8iz29NVNsM8BfFU1OiMr3Po=;
        b=eQjd2MOl6/P+Qa47iQR9u7F+MfYo0jf6j6McZhhIKuomslAZZsE4vNEMs6pHwLuSvthlOJ
        Ige5gSGsE7Devq2axFQbN4ADFxCSy/AkV4V11yGnYm14QuEc0Q34E50GM8Zbiyo2PXNFDD
        UdEZZ6J8NL3H6fTYzEGlx/Btr3tdmjk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168--yvfuxZnOmuP4JtGsDdq1A-1; Wed, 15 Mar 2023 15:01:50 -0400
X-MC-Unique: -yvfuxZnOmuP4JtGsDdq1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF3561C0513D;
        Wed, 15 Mar 2023 19:01:49 +0000 (UTC)
Received: from localhost (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A628202701E;
        Wed, 15 Mar 2023 19:01:49 +0000 (UTC)
Date:   Wed, 15 Mar 2023 15:01:47 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230315190147.GA7517@fedora>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora>
 <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
 <20230315151524.GA14895@fedora>
 <bc332b16-2ef6-80ea-40c4-27547c3b2ea0@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yqaOjnDWlH2ji2vQ"
Content-Disposition: inline
In-Reply-To: <bc332b16-2ef6-80ea-40c4-27547c3b2ea0@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--yqaOjnDWlH2ji2vQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 09:19:39AM -0600, Jens Axboe wrote:
> On 3/15/23 9:15=E2=80=AFAM, Stefan Hajnoczi wrote:
> > Hi Ming and Jens,
> > It would be great if you have time to clarify whether deadlocks can
> > occur or not. If you have any questions about the scenario I was
> > describing, please let me know.
>=20
> I don't believe there is. In anything not ancient, you are always
> allowed to submit and the documentation should be updated to
> describe that correctly. We don't return -EBUSY for submits with
> overflow pending.

Thank you both for the discussion! It has helped.

Stefan

--yqaOjnDWlH2ji2vQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQSFhsACgkQnKSrs4Gr
c8h7rAgAwUuNLwMYdGSIGxv10eWbPx0Y/ZwswL7yfTpw9Z7oIpNsgpxAvezPYvtN
WshMulNKSCvCzIeRS3XAwm0ozJwQ7GYOU8EMHfrTvvW4YR6bAjaN4avm4FSu9ATD
uI6PucXt/BIrKnhth/nLJALFprdTCMcpxEAu/8BNmGDXqqmF6Lj18kEftEB/mPrz
EU+L4MjZlitDxfDp832YzOxCHxcS4YQzW9k+F4UI9FEKfX/Lv0r40mGjll87PABz
ws6gKpBobeb5GdTPS0ZL/oYCK/FosyqF6Xxa3bpzUp6taERI4VK4woIqYygp/t58
hHRPy1zQcHHT9cumYtjzB3/zdtMjnw==
=goh6
-----END PGP SIGNATURE-----

--yqaOjnDWlH2ji2vQ--

