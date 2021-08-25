Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220843F7CDE
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbhHYTxG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 15:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhHYTxG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 15:53:06 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43753C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g138so262727wmg.4
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BczqmCl91HMwzZgAQiEre8KSQN0EsTWpuQhH0lc0AF4=;
        b=thXekMzyxAJocnvfV5LhIZInoAnDsxVrdhoI8kllYSRtrMgGkwiuzVHluQ5461Sn/9
         NXE8VRZwn/dJB0ZRbdjziNJqLNsxVRWI5hgF2LNh1X8ydSeeu2C9XOOVIGXyK5auBR2S
         U5VJkwIzOSr7pSSeWqdAnyYfkVWszdwB2X//TNHpsOfd57eZKJ4XeMkw7Uqw/StqQkww
         Yc7oW+5XUFYenyqEXJRzW6xjmOBXS21jpStSBqrovYwL+jc2JlMSMv1S5rD/ZGy3+umd
         iRvWtNOzkAHMwP/acZZaH+s+ZcKq5EGcHGwkubYwOEjkutJanIt6aY7qsk5b2wF3h4SK
         3KWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BczqmCl91HMwzZgAQiEre8KSQN0EsTWpuQhH0lc0AF4=;
        b=qtbkC3n9YR+VilFZ9b4fq+LafdIq7/qoiGffze2xS3D4MTzLNIMbCWlKSj5XMgrbKk
         X5eFyzLOsbZN3wSkSyygPkrYCxKHj5VZaISImKmmBpIqy5Odr9CSeuoz/MDmln/ZWU0L
         xFMceC8DsUrAwDlj/oIkA58lHwkXyXSPSH24wZn7AOtikifCl8h0mdotIxdfifWrwWvd
         vSczfu8KfPT97E/28oGSW8kmRBGtpd83FoNoRHOfnph4uqHbYgdPTd/BL1EnPgyG+mFp
         1ABqosL0L9g0PQIy8aAiQHjbTE6GesKAELQ1XZk8KAQwQ+adtO9NRP0R1RiLCL4Rv84Y
         QKNQ==
X-Gm-Message-State: AOAM5306Xk/0SHzzbhXjgee/REzuhOpL/jPfGA8soKsNkKiNisSAwE1a
        VmfsZrvVfMK+tzXI9ragEllYtcFVVZE=
X-Google-Smtp-Source: ABdhPJxOC3WkogqqWb35lVq+umcCm1EfmRqLYT2h+HsxbGwzW1fc9bEn9Y1PjPJAtbV76OvUVKDDSQ==
X-Received: by 2002:a05:600c:c8:: with SMTP id u8mr170218wmm.47.1629921138932;
        Wed, 25 Aug 2021 12:52:18 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id m12sm820386wrq.29.2021.08.25.12.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 12:52:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/2] 5.15 small improvements
Date:   Wed, 25 Aug 2021 20:51:38 +0100
Message-Id: <cover.1629920396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just two small patches following past and potential problems

Pavel Begunkov (2):
  io_uring: clarify io_req_task_cancel() locking
  io_uring: add build check for buf_index overflows

 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.32.0

