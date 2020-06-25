Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E560A20A1CA
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405742AbgFYPXL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405359AbgFYPXL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 11:23:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32E5C08C5DB;
        Thu, 25 Jun 2020 08:23:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j94so6299013wrj.0;
        Thu, 25 Jun 2020 08:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vo+qhqZWFGjWoiOqnFYx6rC9T2u5bhyVmXxaUCAoQyw=;
        b=mdyHNzLVGborKGIx3RFAfmPFRplBJWpiiMTBh9Xq45KLigBjp+s1wXzOmmlghEEgQC
         fiwVruFttVGBnCC0vghQ2gfkwjDsHKntS/LmquNAAj/Wqqxd+cmKetiYAbpmcp9rmnvk
         GLUzHtjbqDvd3pcdCT8buzUJIlLrHObGCVxMz8FeRKBk4q+AWt7iaE+01ANzjIU9dzH1
         6jJ5Z8UvDep67p1ET/mwlhl/ZYC9R9RDVr1KeXxXH23xB/XbuakovPum7Kqx1DDzjule
         ai8NBrZHSv4yhMcBxR5AeiuJ4vP82d3wQem/gvzGPFcFX2tEHo4SJSCg3BUwxgQIoWpM
         X9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vo+qhqZWFGjWoiOqnFYx6rC9T2u5bhyVmXxaUCAoQyw=;
        b=N4X8NmdbZxNmNDPiNS/J5NEj7vlt1+F78VYIqJEoR/alJRaI7T9BWROJvZpf451p1E
         w2xAjUBUT04Dy6cWLsslZdq0nC1hh7cma6ZSqoiXEJkxN3L+JplimD9pn0V62/AsyU1U
         1zo+iN6uukCoNvIDZURj81VghREegPUzhOwroXfW/1mW4KyMfJgc9KuZ3BNO5YoitTN5
         LPRRtS8J+QKveerTA6wWni2hgr0m5IL2o8QPOQG+dOGd/Ja8w5gbAroegQ5tF7fWRSyR
         Zddgp7n2gkao6F6hW1z5Eduf+9cuptuAP3EiT4cWkp8mjizOBp0EnoYFuET8ZVzyKqWY
         Jamw==
X-Gm-Message-State: AOAM530lHfQbY33WVp9e3T4dqYv9YY5ozERRRz0ggECW8cJUc3yaRdpK
        ydJ1QRJOrYa0sIQTCeIVUoi8ECXe
X-Google-Smtp-Source: ABdhPJz+In0MpxwJQerxA308OX/Df0w5fv+DABgOPpUAhCtqNDQFbJQoB9/oWbD2s/lNJ9tBUwPfyw==
X-Received: by 2002:a5d:5483:: with SMTP id h3mr38040824wrv.10.1593098588097;
        Thu, 25 Jun 2020 08:23:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id r1sm31560403wrn.29.2020.06.25.08.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-5.9 0/2] clean io_wq->do_work()
Date:   Thu, 25 Jun 2020 18:20:52 +0300
Message-Id: <cover.1593095572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Small io-wq cleanups after getting rid of per-work callbacks.

Pavel Begunkov (2):
  io-wq: compact io-wq flags numbers
  io-wq: return next work from ->do_work() directly

 fs/io-wq.c    |  8 +++-----
 fs/io-wq.h    | 10 +++++-----
 fs/io_uring.c | 53 ++++++++++++++++++++-------------------------------
 3 files changed, 29 insertions(+), 42 deletions(-)

-- 
2.24.0

