Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A4B32D4CE
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhCDOEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbhCDOEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:15 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A70C061760
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:35 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 7so27791448wrz.0
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkoR+RV76KPBGA0yMCMW+ZTVEJ0FNn6wDuIrkIikY18=;
        b=B7zXuxkgpH5NrUMIpRDfOMP/8YXdD4VZKvKpnDcXuqpITFFvaLqo4smnQ9ujRQu/ZN
         NvYeOSMobEJgCSspH3P1Bm3PA38PDVkmpyQau7jNx1o7o788YlS6VibHwXCzJEQYyZFU
         nUQ+AOlwHYRRTeJP01xXNrbvDdwQacC2PNPhwKXBAzCzX/WhFaBzXq6FBshhsmNZj+VD
         2ZwUDIkEaamYGJkVkw+AcuhUxGgMGRlkbmGvhdFtbwj5kD8wiQdy4S66tr4DyXbnrz+X
         tT4i0FZakhI3yusPICScG8vG2YPm9Elt1M2zSp8Erpf1vrNVz9xD49ReUZScTG8wag7F
         SyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkoR+RV76KPBGA0yMCMW+ZTVEJ0FNn6wDuIrkIikY18=;
        b=bX7pMLCg7xWlMQ8lbhYI9aM1M2AGsEvUhqHkYL4cmXdgqbztWpiCmLmYGZFZNzNxkV
         K/a3kyg/5Rysf+NGtmQY5AT/6QelslWpZO5nUAuAINJwwtzoe12N7Bi0wXSSa8ufFoOA
         /OXFOkEaV9NnmM0Y/Tm2AwXj/5RxdHMBeRm68/kiesCrHhZsIwIX/rhQbZNOniOfe2Xc
         MuBoL22Z+XMVMt+oENRfPPc0DHsQhqmCOL3j265mwsscwyaGtIaRE3k+L49Hxo5eKBo+
         tDDIk/rv/5TuHNifYLluGt23QaY4mI68rhwfHze0rO8DADW4F6UeCw36hj+8ORRdDxgx
         tDGA==
X-Gm-Message-State: AOAM532LWkYys1ItF/oEaXC5Bviqd6XxoXetV5RxsNH8Dp9Ic3GqChH/
        //z1X+XqefIIKT3/TPE+uHjSmKTzDdA=
X-Google-Smtp-Source: ABdhPJzcvzNrAB3gW6pQ7yk3XUhuo3Cxoujext7gtsUJolB+Cuy7rALwZk1fOdMI2huNdy8VSSupZg==
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr4158073wrw.183.1614866614160;
        Thu, 04 Mar 2021 06:03:34 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/8] remove task file notes
Date:   Thu,  4 Mar 2021 13:59:23 +0000
Message-Id: <cover.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 fixes a race for io-wq, can be considered separately

3-7 introduce a mapping from ctx to all tctx, and using that removes
file notes, i.e. taking a io_uring file note previously stored in
task->io_uring->xa. It's needed because we don't free io_uring ctx
until all submitters die/exec, and it became worse after killing
->flush().
There are rough corner in a form of not behaving nicely, I'll address
in follow-up patches.

8/8 just a very useful warning.

Pavel Begunkov (8):
  io_uring: cancel-match based on flags
  io_uring: reliably cancel linked timeouts
  io_uring: make del_task_file more forgiving
  io_uring: introduce ctx to tctx back map
  io_uring: do ctx initiated file note removal
  io_uring: don't take task ring-file notes
  io_uring: index io_uring->xa by ctx not file
  io_uring: warn when ring exit takes too long

 fs/io_uring.c            | 146 ++++++++++++++++++++++++++++++---------
 include/linux/io_uring.h |   2 +-
 2 files changed, 113 insertions(+), 35 deletions(-)

-- 
2.24.0

