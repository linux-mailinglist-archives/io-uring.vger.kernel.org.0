Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726E036A9AE
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhDYWfj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 18:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYWfi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 18:35:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C23C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:34:57 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n127so17115990wmb.5
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rXVNy81ybHBVnJPxj7Aq0WCqoumtgL1F5hYnXl2D4pc=;
        b=c8adTWqwlxe6qjs8RygUeNyhFYvk08sUPDL3Lq9gkjZmJjBd5XuQ7dHcrggYm/mfOm
         aZ8libZS5PHAo3uhXjUPiD+I7Z7YcdM+yWfA39fNi4L2e1PfNuWLO0Vm19Vmk01p1QeS
         cEYJn6L8AjlX7YbVloRHYA+Zzwx+C2B/N4q8WWV7Kw4GkYFsS21hG2Ks2GmU3dxaQ09I
         +DDrAKMj9yIR+rDz3INPFoNV5ON2Nz8ffewBty9aFMASd0SSZBXoPArlh78mvconcoSt
         jfF2ncQmnQht4HLTgkX8auiGb77M/tV0AiCPgAyJTmhnDND7IGudxyA2vykxGOgx4mNS
         5NDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rXVNy81ybHBVnJPxj7Aq0WCqoumtgL1F5hYnXl2D4pc=;
        b=IBus3JyffHjb4Spy0jnNoAtS4ITKfaZSB2YmYf76VNCG0BNlH5hG4lxf2g61JK0+hT
         Z5bkihcD+r+38fOTN7PZiMv+Kl9c+GWDXdhpBUE1QPBnVnzENMRR4llgfJ9WbZOjkp4N
         WseZnYX3ODzoSX7Lv8hD0XDSEWY9MHI3Ug285LsGzLrMMYNlCiZgzgizl6DfR3SGXriz
         hz3l6dVTgHMizg6aAFLZw/4bXL0LJxEuG4Jbu3OXCSmjBU+5fFjCH9EsPymM0rxT4rZl
         1lLv8qMKZ9jlokViCtgTgsH/iZqbYFs/drbJt73PtpZ/auhWLqMwfnhlsvQOa04/WqlD
         4GvQ==
X-Gm-Message-State: AOAM5333N6cx0Gpg70BjRk55jAgrLt7HWZCYzXPU6PrduWbnE/FYStoR
        ePy9hqR/FrawOLYwBOCq5BE=
X-Google-Smtp-Source: ABdhPJwDapsh+bb/W7cysTdzmCiNePPJtngJjm3vUGtyeqorv3GLtnNtwF+Uk2DVQb/NjHcOa4DZEQ==
X-Received: by 2002:a1c:e907:: with SMTP id q7mr8484720wmc.17.1619390096745;
        Sun, 25 Apr 2021 15:34:56 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id r2sm17353394wrt.79.2021.04.25.15.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 15:34:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] sqpoll cancellation
Date:   Sun, 25 Apr 2021 23:34:44 +0100
Message-Id: <cover.1619389911.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 is yet another SQPOLL cancellation fix (not critical),
2/2 cleans up after it and sqpoll recent fixes

p.s. can't locate without long bisecting which commit 1/2 fixes

Pavel Begunkov (2):
  io_uring: fix work_exit sqpoll cancellations
  io_uring: simplify SQPOLL cancellations

 fs/io_uring.c | 70 ++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 49 deletions(-)

-- 
2.31.1

