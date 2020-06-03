Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C549C1ED0CD
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgFCNa6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgFCNa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:30:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C054C08C5C0;
        Wed,  3 Jun 2020 06:30:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so1943672wmh.2;
        Wed, 03 Jun 2020 06:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGjCUOsGdfKlJ9VnKd1mR0+GUIRosXAw/THX8Bc02Vk=;
        b=DNDTfTGhpO5nB1m7cm1QYBY77T2zOcyoovTbpSWsQdWFsajVwYvfUcrZOAK0WYY14q
         1OgUukL3LkwW9anpYThwoS/58u+ZpCKOYwW8bD2LLjSPovhUm/cqT9tZ6zymXtCGUQHO
         7CKG2vBWkFVTgPzF5OOAYfEczr3IBluIOkkrsGKBZSRx9iXVEOyfl0snwmLtikCvymZ/
         ZofTQ4QK1mY3JXndJ9ylD34DV+cUFl8zy6jKOv8A7WV1UdEcL1dpAWysQJuUjJKp2ie4
         cpc5RVDyo2vs6VhD7aRJt7lF0OYOBnMJz+kMiUWIrOEgKh+kgqVY70tA7q0XguIMsWlr
         /r5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGjCUOsGdfKlJ9VnKd1mR0+GUIRosXAw/THX8Bc02Vk=;
        b=TgELAqkYPDScx7yGhFmwmT/znsrIWDXNk3Z1LmJtuLdu+z5EvEHUVHZS9myPzidfQo
         TrbWsJsH7lZfA9oz/QAJhkwdjI+4zcNO07UsQSDfyfaDVtOL0wMv2VazM5/a/CBxWOJn
         99XPLGVK5G01Ohiz4iRpwmTxIodL9DN+hOAmwqrR9kA20v2YWZp2PuvDF2s8/VT+Jxzr
         d8I2dLqeY0skQLVyJlGbfB+ltXHsXuFYoRkk8eYxPQUzptWI2Xyt5rHOXtu23hetGcxH
         5IeuDncJF8ibN+BU/Jt4Bsu2tTSixxY0CAOySMCo+FLOn0goa17zsUIRoDpQXCwly2U0
         HMDg==
X-Gm-Message-State: AOAM530GwcIM3husHoZzEI2scJjZIPQ2NnANzDZyO26Evu/MSPklnZDu
        BOIU4WxOtDozjICsa0kkOX7x4VV9
X-Google-Smtp-Source: ABdhPJwuKKM3n/LbLmI2KK1c0+/gw7FFn8alqgyPo2w1W1clPgP0AZ/ricDBrGXkiLwN6Mtsv6Zu8Q==
X-Received: by 2002:a1c:23d2:: with SMTP id j201mr8705549wmj.186.1591191056921;
        Wed, 03 Jun 2020 06:30:56 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id a1sm3189716wmd.28.2020.06.03.06.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 06:30:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] forbid fix {SQ,IO}POLL
Date:   Wed,  3 Jun 2020 16:29:28 +0300
Message-Id: <cover.1591190471.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
moved in the common path later, or rethinked entirely, e.g.
not io_iopoll_req_issued()'ed for unsupported opcodes.

3 others are just cleanups on top.


v2: add IOPOLL to the whole bunch of opcodes in [1/4].
    dirty and effective.

Pavel Begunkov (4):
  io_uring: fix {SQ,IO}POLL with unsupported opcodes
  io_uring: do build_open_how() only once
  io_uring: deduplicate io_openat{,2}_prep()
  io_uring: move send/recv IOPOLL check into prep

 fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

-- 
2.24.0

