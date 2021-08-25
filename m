Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902A13F7502
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbhHYMY0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 08:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbhHYMY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 08:24:26 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC3C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:40 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k20-20020a05600c0b5400b002e87ad6956eso2779956wmr.1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 05:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUz/EKxjddMnednMk3X//QOjermnX9+9kOBlpEvXtUw=;
        b=iWpLyUOXT+m3y3GNGMc2hRvY3KETbx18m2TGpIvTMO5X7bVBTHsIhwlZ1/WOpVHOqe
         zmiWwDkXGALOnalEVKNwouwzeqReF/4uwi2IkbkYA51DuvWBwqb1BRb98l2+jn2mlrtY
         8C5xXTAUVNztvZDGR53auEkIghEIqdbkcR2j6ZmeMzsTr98tU50g5TYbZqSZtW1Z41pP
         cvgA9zkT9g2myTZJV4XWd3iVSi9h+TE4Q2KSAsZyDhdtcYNd+iXEMRV23KzYQ0Ue7trV
         76DqtH84F+eLAb022I9X0etP7iFvQG+SKqsh1BEka2rYT3VWgTS6ukh0AOCjpMKlJL8j
         YUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUz/EKxjddMnednMk3X//QOjermnX9+9kOBlpEvXtUw=;
        b=Nd+IX34tpPlr7D/r/wDixAV9ITd4+baDyzOuHqwCd19TaT4wTntWRLS8GVgnw0KNns
         AAYeTw5ZKzZU4Tf8CWZIbNxjEW1mScrwY5O8VauEhhI4/VuuWTJ3MVIX7AhFp4ujAl5w
         2s9VjeW4XwIpOQt+o+pVURw1qQWD5j34ySCOCEUlx7ztACEQfEMuSZKM8k60cH8rpEC4
         ca8E4ti0uCX5uCP69mrdKfbbmNea4yhg3v+Fm2lWRCHCval6JhBnVDcummmbwJo4x9yT
         b7OfhmXha+SWHuoeOhYdiEAUbSBoPb3speR5ib+nQi0Y2MYiykgDmETQ6RbnBSi2kihZ
         sDww==
X-Gm-Message-State: AOAM5305NNLA1kuD6K01LaUxf5FrBQenvKYW5YRzqUFRa7U3sfVU5uSy
        4EISjKXxVd+stP02BwAj2eSkuxTQDfY=
X-Google-Smtp-Source: ABdhPJxhkLvoo1Trs7ZRjwg0+fbTRqOROsyVglhhcE+IW8XZ1eq+ivc5GikKc2Sq8+b8KQOKQ1/9KA==
X-Received: by 2002:a05:600c:510a:: with SMTP id o10mr9109235wms.84.1629894219364;
        Wed, 25 Aug 2021 05:23:39 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id l12sm5226199wms.24.2021.08.25.05.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:23:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] liburing.h helpers cleanup
Date:   Wed, 25 Aug 2021 13:23:00 +0100
Message-Id: <cover.1629893954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper for preparing multishot poll requests + a poll mask
conversion cleanup.

Pavel Begunkov (2):
  liburing.h: add a multipoll helper
  liburing.h: dedup poll mask conversion

 src/include/liburing.h   | 25 +++++++++++++++++--------
 test/poll-mshot-update.c |  3 +--
 2 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.32.0

