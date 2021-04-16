Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEE53616C1
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 02:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhDPA1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 20:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDPA1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 20:27:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305FEC061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so21256212wrt.5
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yikmZNxXD5s4Kl0dHs2RSuRBb86yT5dUIv506LoOs7w=;
        b=M2mW2xlGoiAQq3mUd6Xw+/do5jygEIGSel/CdVXBsCNdu75haRdhWRfAQp3NMhtMvS
         jb7Ig8Wr2j4FXjJPY/voDFXLBimNvb1Il+6OhMd1RTSyKd0YIOtUxA1r5F7TYQtfXaLe
         ioXiDoy26UdmVYreWDH7lvC5tY4nh8SFyPhVHJIGzAgL/60QIIbJ1PflsDZr1+Ro67Vy
         3y1gdunK1mwUAAQaQzwlZYCtzfEHK3RToZ+uCmUm9DqZiHVJ8XX0DDrKVV5RV+kFeee2
         GudkM9e3qQ1EHdU05nTVNGpJ7cCag2u9BnAJSy5Fa+CVitEKf4r1c8+vhE4tuwEWvPvT
         +OCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yikmZNxXD5s4Kl0dHs2RSuRBb86yT5dUIv506LoOs7w=;
        b=C7vDQyRx38y0zuXZbHGhzcyBKK0nwEYFBtZZfN1yAAYc/a0N3VcHn+0cQERIs62sEw
         koyI8nJ+riTu+S+2cdqe6wPWhgV1f2q0piv5XtYKQS2xOdadSIFzuCOwe/J4/d7Msx+w
         yzxdO5Ic+zabPeMGQxeTYjM9QaSASOXv50V+i3abcVhMq80x8p1IYmjgjkWKJLY+2SDx
         FoXdiyYJIGGgOl1hBa2cwGZmnyxJ6kaUo2XZuTKZkEV930zJPrf2fRpqRstpLjHZpdA+
         IQUZzodlQyx2e6ttlJ7sZCHvT1tC33CZWfA1xL3E0/OQoFmYXqv2vzRaOAKs5MbZaQRq
         +5jw==
X-Gm-Message-State: AOAM532HimbPXalbhB84zGCkVh74xq+3XHoVpUc6ECAwF4SNqK+RU2bQ
        PyR+i9+ruS/gIAPvd8HuDxQ=
X-Google-Smtp-Source: ABdhPJx2i8ZSOBLrNMjMRYO9SCHVsjeDH1PcP9lHVQ46cTjekM8+YUvqpNOtt3h1Y+tKpfHb+sDoZg==
X-Received: by 2002:adf:a119:: with SMTP id o25mr5997591wro.36.1618532829021;
        Thu, 15 Apr 2021 17:27:09 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id x15sm5611421wmi.41.2021.04.15.17.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 17:27:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
Subject: [PATCH 0/2] fix hangs with shared sqpoll
Date:   Fri, 16 Apr 2021 01:22:50 +0100
Message-Id: <cover.1618532491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.

Pavel Begunkov (2):
  percpu_ref: add percpu_ref_atomic_count()
  io_uring: fix shared sqpoll cancellation hangs

 fs/io_uring.c                   |  5 +++--
 include/linux/percpu-refcount.h |  1 +
 lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.24.0

