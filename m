Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C7329E0B3
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 02:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgJ2B1B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 21:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729660AbgJ2B0S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 21:26:18 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A8C0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 18:26:18 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bl4ckb0ne.ca;
        s=default; t=1603934777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=vjkHej/xkPmo2O/ZggwEclN0209FXojsoBqEZWGx3Sg=;
        b=rCl+41cFogcRMEdw0AOM6Y68IMKDW+ntHVWi26ZNKlLOLq+5rrJm7wJ6H0xkTJ9br+D4Kg
        U5CIODiUn1cLqlUM1vIgvgjMHR1+OTsctVxR2ne1ImdqB41UzIdW+7VCv7kvcDoYczQjvF
        2XTD3KdvinY9aFOpKyiUjqBntQtSkC8=
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] examples: disable ucontext-cp if ucontext.h is not
 available
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Simon Zeni" <simon@bl4ckb0ne.ca>
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Date:   Wed, 28 Oct 2020 21:23:52 -0400
Message-Id: <C6OZDHZNAEV7.2KUIZYYGFKTWW@gengar>
In-Reply-To: <f728786a-cd29-9ea5-68e9-eb2a2df6ecdc@kernel.dk>
X-Spam-Score: 2.40
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed Oct 28, 2020 at 3:06 PM EDT, Jens Axboe wrote:
> The log for those would be interesting. rename/unlink is probably
> me messing up on skipping on not-supported, sq-poll-* ditto. The
> others, not sure - if you fail with -1/-12, probably just missing
> capability checks.

There you go
https://paste.sr.ht/~bl4ckb0ne/61a962894091a8442fc7ab66934e22930122ff18

