Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E439499B
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhE2Af2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 20:35:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43931 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229559AbhE2Af2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 May 2021 20:35:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8D0445C00C8;
        Fri, 28 May 2021 20:33:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 28 May 2021 20:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm1; bh=W9m/5buG1zeb0H5rrcyHnA3tGrYgwT0J47EYZa9BVq0=; b=I756SUq2
        MfN3V15KgiGkJy9esayMw8b4oGdZfA/1dqdH8JNPXbCuPY/irYc6f2EvPsuidjMQ
        TIOGKgIsJO32U9KYn36WXqtzjwt20T3/zG9pgUPClTKNr1Qf5uOjmqH0kZyg4oRk
        DOY66BVXPVAWd3fFRyGK4O3ReokxDdEBcmPG79iv6odjhzsSq9MTgKr2+6m1wDd1
        EM81K49fgY1ewFWajK6SMNgQYCzaxebfSNSF9WzKrTDDpVoruTeK9HVf1tb3a7LL
        p0E9t0V25qEajI9WUZ76jBwKsbXzFk9HvPKI8ClKDYvmQLtC2NV/UAlSZSfV0KJA
        sJqG0ZRUgSlwDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=W9m/5buG1zeb0H5rrcyHnA3tGrYgw
        T0J47EYZa9BVq0=; b=nqtrOppG/iyFB1W3JLLX2Anl1YXGj3hF4mXWY3GxQZ738
        lBQ4DZV7fc1Z3+kEP5N4dupvNihQryabN1SEfrFn3HTN8VuXHh3+Rk8EyOjX0XX0
        +INTrPRKSUb7Me1tZtlv7P+uDQnXJMyZGVmoOZh5R/UGY17RHqmF5HZHALgT6KgY
        Wn6ayuOzUgrAy15dKQ73c1I7aXE4kyajJx/U5i0zUu1J1AgfAelk4cc40FhX1ex6
        c1wdJfszMjvLrc45Y9I1qSCwtJGZVNFZgqi+UidwiCgGTe74apLTbay8PRrOjHyR
        bA5L0kY7ntm9r7oUmbLkn1XP7ebihKvObk/eo8A8Q==
X-ME-Sender: <xms:8IuxYIyOefjLBMsy4_ZMfdDsLyorimlZufyVNGjvwWpm4zCVRW7mWQ>
    <xme:8IuxYMSV2RpisEcfKEQg6HHvFhrqiae4Q0J8Utw3ji8haSa-fpRDPHk__-qOOvsxY
    Y7gSq7RpzBi6Jp-Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehttdertddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeivdeileegueeutdefudfhfeethefhvedvleejtefguefgtdeltddutedvheek
    ffenucfkphepuddtjedrudegvddrfeefrddutdefnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:8IuxYKU0Q-vYrTHQDK3pxD_elkQkMBAsLo0ouCUROR7YHDeMu5YOCg>
    <xmx:8IuxYGgU6W-tFNN0UMeUOU6JCygDHlDBXsEuPUyyLDHZ1Rh3wY-BYg>
    <xmx:8IuxYKDktkqs2JUTkNDp9JHEYlnvws7FloFPM6AVTqry0uhn-BgEfQ>
    <xmx:8IuxYL5EF9dMO8G_XCNwxZLtFRKoqfvje9O6fGOgV-TLNJ31In4GdA>
Received: from intern.anarazel.de (107-142-33-103.lightspeed.sntcca.sbcglobal.net [107.142.33.103])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 28 May 2021 20:33:52 -0400 (EDT)
Date:   Fri, 28 May 2021 17:33:50 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Memory uninitialized after "io_uring: keep table of pointers to
 ubufs"
Message-ID: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I started to see buffer registration randomly failing with ENOMEM on
5.13. Registering buffer or two often succeeds, but more than that
rarely. Running the same program as root succeeds - but the user has a high
rlimit.

The issue is that io_sqe_buffer_register() doesn't initialize
imu. io_buffer_account_pin() does imu->acct_pages++, before calling
io_account_mem(ctx, imu->acct_pages);

Which means that a random amount of memory is being accounted for. On the first
few allocations this sometimes fails to fail because the memory is zero, but
after a bit of reuse...

It only doesn't fail as root because the rlimit doesn't apply.

This is caused by

commit 41edf1a5ec967bf4bddedb83c48e02dfea8315b4
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   2021-04-25 14:32:23 +0100

    io_uring: keep table of pointers to ubufs

Greetings,

Andres Freund
