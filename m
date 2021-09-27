Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01441953A
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhI0NmI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbhI0NmH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:42:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7BDC061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n2so11777761plk.12
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IB/dqccYq7c0UGYr2VtYrQ7Ywht+iYJ5N5qC+nMdYF4=;
        b=BDhW4Q/2zP6hxezMbfnbfZxujsUcuC0t5Nar+v96DnEGTiZ5Sz0qOFKBJqMLUVl0+F
         lIz/DHIIi+FAoTa3muZD2DRxavVKt7UQv/0R1lpR5K9YxVLV2YFgTcOyh2Oc0puFWWmD
         WZ5zp1uame+ZMJ9Dnge4s13lHMVTwvvC7rI13JziGCOfiAod6EoOH33sAp57kMTuQMXu
         RR8+htlss5vAGiQM/zNThtAqy6pwk5UdnugjEb11PTadIkOX4xODYOT5zcFX092c9Zhy
         YwED9ssBaMgkBv01bGoSg1YTSBidQhsFu9E47VnlczLunqxzB4+UYdPJ3+MEnR80tzem
         rhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IB/dqccYq7c0UGYr2VtYrQ7Ywht+iYJ5N5qC+nMdYF4=;
        b=5JmIoQ5ps/l3iEMOPKmTO6LXN2XLMN1UQ/6jFgz7fvonZtirSnCg9D7opSjghCaARj
         4DQ2bokrfXeAHZhpMT2mpHZez5zNFHoWwyc7WfiEFHxQY27g88FtfTHw8fnV0SJ4BV0J
         02L68xfKYPivCNoHJTKfm68l36TcUaG6ErAbvLXUIQylFYPH/Ow5gnzSBG0Tk+9RNhZO
         Hn1a5Jt0yHEEJc1mYsYjSCXGo3lQxguw/NQ5CaSBDAf6BauZXWL8igiApqxZ3xgtY0to
         KnT+rHCe05NWjlygA4/QiqXTYRU0qffL37/V1pqZWXiA5ZL68CDtd89tDIXI5AJgdYB5
         2sGg==
X-Gm-Message-State: AOAM533yPyJmqpqqm9Ix/DIIYKB67MI7BJWz56P65rbt8sUF5WcAz8pL
        HxYymnydS5xfUVGd9LlYj9c=
X-Google-Smtp-Source: ABdhPJyKqU+fSNP0/cAJ3APQDOaYMUZD/UXU2/COnLv1bLUVf3qB/dRZo8kJZ27PHesqeFM/LFGOsg==
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr19973497pjk.13.1632750029380;
        Mon, 27 Sep 2021 06:40:29 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id b21sm17306914pfv.96.2021.09.27.06.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 06:40:29 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io_uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 0/2] Fix endianess issue and add srand()
Date:   Mon, 27 Sep 2021 20:40:21 +0700
Message-Id: <20210927134023.294466-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
References: <7e5e3e4c-5f42-8a17-a051-d7e6a5ced9c9@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 27, 2021 at 8:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/26/21 10:37 PM, Ammar Faizi wrote:
> > The use of `rand()` should be accompanied by `srand()`.
>
> The idiomatic way that I usually do it for these tests is:
>
> srand(getpid());
>
> Shouldn't really matter, but we may as well keep it consistent.

v2: Use getpid() for the random seed.

----------------------------------------------------------------
Ammar Faizi (2):
      test: Fix endianess issue on `bind()` and `connect()`
      test/accept-link: Add `srand()` for better randomness

 test/232c93d07b74-test.c |  9 +++++----
 test/accept-link.c       | 14 ++++++++++----
 test/accept.c            |  5 +++--
 test/poll-link.c         | 11 +++++++----
 test/shutdown.c          |  5 +++--
 test/socket-rw-eagain.c  |  5 +++--
 test/socket-rw.c         |  5 +++--
 7 files changed, 34 insertions(+), 20 deletions(-)

---
Ammar Faizi



