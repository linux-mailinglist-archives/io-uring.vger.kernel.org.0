Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026030B730
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 06:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBBFiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 00:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhBBFiH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 00:38:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2682C061794
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 21:37:07 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c2so21486691edr.11
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 21:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=jx5w0a1LBef0Tcg+q5ejYdIu/avv96ApVQo2ehYae7w=;
        b=fGp4+WdRJs1J2nsJoiF3BfX3RcYikGPetqYBrdfP4aArGe/q4wVVqxgErk17ava0s4
         vZMBBSRKSNtgWLPt7y7i4HFbvO3ksoBh2cQtlBI2URTStJwjN1McyEORj6VLRrr7DT0R
         QIpmsyfkRNzzi5cKo/fy70TXWkJARqg7XVlMDAscCSOOmFy25Us88TlIc2FNmepuIq9q
         ivbTCQbtQQqiHXmL/9JbWXAViUPvBifvkhC6IbmxJXWJSyBwX9jhAyJldEsSUKZsrrX8
         B7PPahF7QNW31bWBH7clA+kOyC+AFdOOtn0achzL+RuGf8ouzTcETPqSDvaaPZZNEsiB
         GisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jx5w0a1LBef0Tcg+q5ejYdIu/avv96ApVQo2ehYae7w=;
        b=AcDo0I8Sva5A8AU12hGSvf7qqrzI/Bwg/4vVMMHV2h1lQbPouKNOSQjGhKNg6kT2M0
         xjQgBrEqN6LzT4FBuqo63QpQxviChCoIvr5dDfsiakFzTVtj+ax0/E5G+g3tDAN86AIm
         EVz1au+kR4Ec0f8CMLkkf3GF6J2VIt8NS2Rcnl3cHWP6OePdhkTnpG9eCxkSTg9QgaBN
         3256+IRtebJWduYxUt8a73o+eFoVG37i0WI0eXUQDfV1p12bfSH5n0CfjVRT0YofpBsO
         J06oAvD2cq7HcbLihNZsYgiLxoczscgzyYHFITO/vo363+D4eLa+0hl++BKSERsXNSON
         eXQg==
X-Gm-Message-State: AOAM5318qYeE8Y7g4sjyT3DiNTwamU9KgfdZnOkgxxdwh//gAWO3hxWT
        +b0Wpr0xmqcJ6JQEgqRrD8G+FPQmy2fT0BUdqR6JDxzaOZdiPg==
X-Google-Smtp-Source: ABdhPJxKdPu83h7j1o87/c+NtAOBuC2MNZvR231xmYitqymVkzvrkcSHjXWBMRaAPus3fSyGp+IoHJaOen/xqj6dnwQ=
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr21951477edb.181.1612244226292;
 Mon, 01 Feb 2021 21:37:06 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 00:36:57 -0500
Message-ID: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
Subject: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

started experimenting with sqpoll and my fastpoll accepts started
failing. was banging my head against the wall for a few hours... wrote
this test case below....

basically fastpoll accept only works without sqpoll, and without
adding IOSQE_FIXED_FILE to the sqe. fails with both, fails with
either. these must be bugs?

I'm running Clear Linux 5.10.10-1017.native.

i hope no one here is allergic to C++, haha. compilation command
commented in the gist, just replace the two paths. and I can fold
these checks if needed into a liburing PR later.

https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
