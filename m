Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A527C7D2E
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 07:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjJMFr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 01:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJMFrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 01:47:25 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D664B7
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 22:47:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qrB14-0006Nk-RV; Fri, 13 Oct 2023 07:47:18 +0200
Received: from [2a0a:edc0:2:b01:1d::c0] (helo=ptx.whiteo.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1qrB13-001KAR-0Y; Fri, 13 Oct 2023 07:47:17 +0200
Received: from sha by ptx.whiteo.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qrB12-00EDtH-U8; Fri, 13 Oct 2023 07:47:16 +0200
Date:   Fri, 13 Oct 2023 07:47:16 +0200
From:   Sascha Hauer <sha@pengutronix.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Problem with io_uring splice and KTLS
Message-ID: <20231013054716.GG3359458@pengutronix.de>
References: <20231010141932.GD3114228@pengutronix.de>
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
 <20231012133407.GA3359458@pengutronix.de>
 <f39ef992-4789-4c30-92ef-e3114a31d5c7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39ef992-4789-4c30-92ef-e3114a31d5c7@kernel.dk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 12, 2023 at 07:45:07PM -0600, Jens Axboe wrote:
> On 10/12/23 7:34 AM, Sascha Hauer wrote:
> > In case you don't have encryption hardware you can create an
> > asynchronous encryption module using cryptd. Compile a kernel with
> > CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
> > webserver with the '-c' option. /proc/crypto should then contain an
> > entry with:
> > 
> >  name         : gcm(aes)
> >  driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
> >  module       : kernel
> >  priority     : 150
> 
> I did a bit of prep work to ensure I had everything working for when
> there's time to dive into it, but starting it with -c doesn't register
> this entry. Turns out the bind() in there returns -1/ENOENT.

Yes, that happens here as well, that's why I don't check for the error
in the bind call. Nevertheless it has the desired effect that the new
algorithm is registered and used from there on. BTW you only need to
start the webserver once with -c. If you start it repeatedly with -c a
new gcm(aes) instance is registered each time.

I think what I am doing here is not the intended use case of cryptd and
only works by accident.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
