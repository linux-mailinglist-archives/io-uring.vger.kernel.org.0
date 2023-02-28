Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6995F6A5640
	for <lists+io-uring@lfdr.de>; Tue, 28 Feb 2023 11:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjB1KEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Feb 2023 05:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjB1KEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Feb 2023 05:04:46 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1428241E8;
        Tue, 28 Feb 2023 02:04:43 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4CC051C0AB2; Tue, 28 Feb 2023 11:04:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1677578682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PrbtGwVMliIbWZT0OYnrU2d2yuZ2nEFZOBvI8l29GB8=;
        b=LqaTO24qPrmtGp5ZMzGEt8cgK1Ms7VbDBkUk2qtYeBBhNev75eS7Isvz8bjEk2BBDb3VRW
        1RoA1QirznIw/VA+mIZp+7fG62IJOtiFE6FibiU4CrP7CloStEXSMMA7ixdGOw6I620QWE
        27lHdBAg9ZWzBoUiWqXGyu0pEWSq0z8=
Date:   Tue, 28 Feb 2023 11:04:41 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
Subject: Re: ublk-nbd: ublk-nbd is avaialbe
Message-ID: <Y/3RuWZKaYrTj/rT@duo.ucw.cz>
References: <Y8lSYBU9q5fjs7jS@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="whO3mXYgpG0S++jq"
Content-Disposition: inline
In-Reply-To: <Y8lSYBU9q5fjs7jS@T590>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--whO3mXYgpG0S++jq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> ublk-nbd[1] is available now.
>=20
> Basically it is one nbd client, but totally implemented in userspace,
> and wrt. current nbd-client in [2], the transmission phase is done
> by linux block nbd driver.

There is reason nbd-client needs to be in kernel, and the reason is
deadlocks during low memory situations.

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--whO3mXYgpG0S++jq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY/3RuQAKCRAw5/Bqldv6
8hAlAJ9tjXVm1Wf/cB3GwYbCq7ktq/mEggCfZcAtI59uSIwUHOgZo3dpRqw+RDc=
=2aTW
-----END PGP SIGNATURE-----

--whO3mXYgpG0S++jq--
