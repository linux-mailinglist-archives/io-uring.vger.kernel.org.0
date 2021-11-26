Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E000645F03A
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350592AbhKZPCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353956AbhKZPAn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:00:43 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB56C06139A
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:24 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v11so19077051wrw.10
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=im43KwSoYhK9ZigytTgMRmdPWExT+xDBOnC1/fj8ZzQ=;
        b=eTO7sZi502sOWlS0hGeu6xznEVzMhNlGrTXQliR7s0mQnd646ec0t+D956ZemMTLQs
         fP5tTarpELPhWroxf3BJGIGT2+CJ47yh4VoIizSBEpgTL2D0dahCvaL6LVlUYX3JAqnd
         t0E9/8fNMRV1t2TIR4vnW5AbKBKJiuKcfkBgX2r2fNSvhnKnJ9Z/xxlKR1O+DIq+bIqk
         /41k0gRNgL1hJfVm77Q87bO5fPRMwvz9Z6kEQpdx1t5gg9qCqp0eg7omXkAYYZZUbhaB
         51U23jkYST2zDKIz6irXaXFVUZJzQespIsnTCnVEYjP9LjcXnFHMNdHVTnzeaXKpIphq
         6o/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=im43KwSoYhK9ZigytTgMRmdPWExT+xDBOnC1/fj8ZzQ=;
        b=7+fWxUjxBWkQtLTWzY/sYkxCNK6RjPM+LvdInkHb1Ug2kSgw0KVgdRxsZFV4FXa/ud
         l7lmxTIggs0ZOuukr6vk6vFf/y5B4IE7hBHBS+myUTdjaKpaGIn8UBd2wLKz944M3Mzv
         0nemBFavp0Vfj77xL8t7UosauXhD1mVakRanFIqb/ZtdzsoyoJaii4lXbDnS680Aw4YA
         5aPPe0nF6BDuubNJw0+jgeZsxrYH+QZ7urSx2bcmnisUvF3ZXwncBGFXTVeyCVzMV//A
         loTvz/fwRw5aphqlA5eA5CeWNabeDolDHaND7lsUc+LN0u7ltf0U30Nh1klUNbQlCVAa
         Eo0A==
X-Gm-Message-State: AOAM5328SciQRDJvkDNv7qNLR7nCXyATo+Up7jXMEjX9ctA0wL5d48+o
        ioL7htnhM07jZdDIRK9tC6MoDYMwXhI=
X-Google-Smtp-Source: ABdhPJzlN3e+aqxTt0B494YlGEJXaF6CTcshc944kFq5LYg0EmC3BXpz6m1JeqWGgdGuEQJeGn7drg==
X-Received: by 2002:a5d:4443:: with SMTP id x3mr15008163wrr.189.1637937503275;
        Fri, 26 Nov 2021 06:38:23 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id j134sm6588640wmj.3.2021.11.26.06.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 06:38:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] 5.16 fixes for syz reports
Date:   Fri, 26 Nov 2021 14:38:13 +0000
Message-Id: <cover.1637937097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The second patch fixes the last five reports, i.e. deadlocks and
inconsistent irq state, all of the caused by the same patch and
are dups of each other.

1/2 is for another report, where tw of cancellation requests don't
handle PF_EXITING.

Pavel Begunkov (2):
  io_uring: fail cancellation for EXITING tasks
  io_uring: fix link traversal locking

 fs/io_uring.c | 65 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 20 deletions(-)

-- 
2.34.0

