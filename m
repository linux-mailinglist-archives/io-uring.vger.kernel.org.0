Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356B5456B07
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 08:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhKSHpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Nov 2021 02:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhKSHpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Nov 2021 02:45:08 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5314FC061574;
        Thu, 18 Nov 2021 23:42:03 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637307720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oBuVVC/kgOFHq2yevaI0CpADpfOSmZZoX+AnGukEpF8=;
        b=uity+CJUCct1Lwq62Wamd1z1OodLsIo/ZRbgo0K59Ny+AUG/j2zgw7g3fKEV1GuGIaqhAT
        W5lIXaJ63mNCp34bPiaztZ2GZTE/GM9GFUnQ2Tf3E1Pfy8PKx3j29o978w7kYkP4B+p9xk
        5jdofR73whVGcZ9CNMwDN6wnJrWFWCKYeNBfjNl/MqZZ428/aMuAnWkGcMaXNDGQ4MeDn4
        FfnGuzT8dNQl2pHGa0opar+68OJfAVzoX8jruEdx+HRPXrrGSGAfYMIuAIqGet2oKIVLsf
        Yf7OzNT7J8eklU60lMw9FqmnGONC+CDYSoSn/y/74f7qW2oXOWU9e4jc76csNw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 19 Nov 2021 08:41:58 +0100
Message-Id: <CFTL5A99FTIY.38WS1HS59BT2D@taiga>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Jens Axboe" <axboe@kernel.dk>
Cc:     "Johannes Weiner" <hannes@cmpxchg.org>,
        "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZWBkZHdsh5LtWSG@cmpxchg.org>
 <ec24ff4e-8413-914c-7cdf-203a7a5f0586@kernel.dk>
 <20211118135846.26da93737a70d486e68462bf@linux-foundation.org>
In-Reply-To: <20211118135846.26da93737a70d486e68462bf@linux-foundation.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu Nov 18, 2021 at 10:58 PM CET, Andrew Morton wrote:
> Nobody's aiming for perfection. We're discussing aiming for "better".
>
> What we should have done on day one was to set the default MLOCK_LIMIT
> to zero bytes. Then everyone would have infrastructure to tune it from
> userspace and we wouldn't ever have this discussion.

Setting aside perfection or not, what you're aiming for is about 1000=C3=97
more work. I'm not prepared to do that work. I'm not going to paint this
same bikeshed 100 times for each Linux distro we have to convince to
adopt a more sophisticated solution.
