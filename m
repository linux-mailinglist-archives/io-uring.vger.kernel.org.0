Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1F327F01
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 14:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhCANHh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 08:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbhCANHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 08:07:10 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87956C0617AB
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 05:06:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w11so16056696wrr.10
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 05:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKZiA6+pphPNK/ZTzyFgKnz1O7WlZD7FkJmARaGtKJE=;
        b=OEO+4sN74xxt7T4n3VqXBzjSidMI0rV5HSR8IkNkkx7Mqc8NHDMS1ZsP53SlTtlhfG
         9BRiG2LZH2hnLKdMsL5wF4k+mpt8/EJuDYJ2OTRLxZhHfSYQnM1QU1UqogxmVueGRnts
         WQsVYsA9ikwpUvT9WSf3v+hoXYzHY69/B0H/W5x39W3UMQUVWrFtF01Bg2PUe5eHMi3d
         mRWYPpwhk5muq+KELNz0dL2u6jC+mmikFk1bKHCbBpwZKc1F6ZOWHXiwhMDkecSkeNDc
         NiHvmVpA16YB7MFxSq8CZtgY/IT1Rv1331NnTQhT06XYIaMjWk8AC2bwJcFGEDyWHD+p
         xFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKZiA6+pphPNK/ZTzyFgKnz1O7WlZD7FkJmARaGtKJE=;
        b=mvlAqfCQThXCVor86wmWm0tt52VAYF9hRL/kkzUZpPIBD7BI5NmvL2W1kHAIO1PkR/
         TY8DWMV59MoknmdhPh4RLUveLNQSxvVpbiByRXruSzuqMImKeP9hBw/WRgbosjiSpFRc
         rCvmHvR+GA1zQJqlH9K8b+4TTd6iIkwXj4NqDuVP3ZubwxkXNSEyu/L/VQ8jE+FH69wp
         9/BpDSzJSGlkXA3RNr6VoFsT4AZmfnMw6o4tV7XBYhKLXqKMJegwmJ4kTxxrcnSiyYE/
         DhuWJX2HLyNwLZwKxecJifFc6jVOXz95SZ+Z6Tgu8BELztx/8bLQtFyANMiGNddrUy2o
         4nfQ==
X-Gm-Message-State: AOAM532/4GAFHBHJV9U7z8IrtXEN3u9tnIGyXMkDjHKbV35rUvVASkZ9
        YSsVWc5eq3c4rnMxwR9P+T2wVvD4kFPYBQ==
X-Google-Smtp-Source: ABdhPJzUhakUX3ehwvMA84U7BklLAbVbS8z8wPvbYy5W9LC4HEIkXSs1lJq7lC/MfLmnBjCMbnPDoQ==
X-Received: by 2002:adf:e603:: with SMTP id p3mr13773958wrm.360.1614603974324;
        Mon, 01 Mar 2021 05:06:14 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id j16sm1898903wmi.2.2021.03.01.05.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:06:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/2] kill sqo_dead
Date:   Mon,  1 Mar 2021 13:02:14 +0000
Message-Id: <cover.1614603610.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove not needed anymore sqo_dead and some other leftovers

Pavel Begunkov (2):
  io_uring: kill sqo_dead and sqo submission halting
  io_uring: remove sqo_task

 fs/io_uring.c | 50 +++-----------------------------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

-- 
2.24.0

