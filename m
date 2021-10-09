Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B72427DD5
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 00:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhJIWR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 18:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhJIWR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 18:17:27 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86EFC061762
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 15:15:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i12so29042204wrb.7
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 15:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdK87AHGTdDKvs2NAFRMnPn/DENdRC1tYqC/NKfUHQU=;
        b=nN/u3ItMoMmzx5psuUGxCj3RqdERTg9ZRUUtzYATquijkDFuSWa+Qqy4PWubP8XAaO
         SKyX5/ox98OVU9QjDEOU6WLhfAHqVCwY6aNtt+HZtM7cO+rfUQS6vMpnA41FYsSIWmjY
         5m7ZLKmIzH5MfK2dyznNxJ2CP4LkvjDNn3O9oR0PGDhZwCB6HAGTV1pFxvvl+UazctmX
         rWEYDyPVRjIJzj0yhhh60Y4dLJWoXvy+yaPI68GU8YFaYxyeFWDx4/YiGvEwnrsI0RXf
         X/0QqoUW/6C6JC/Qs+MgDxbx76Q3jSabATZ57wV6s2HjgbH4Uox2+aLEAH/WPASepyrb
         zmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdK87AHGTdDKvs2NAFRMnPn/DENdRC1tYqC/NKfUHQU=;
        b=ggwB405HH+jypQgPHmMqUwUIqhrl4ckYTn/6R79Nb5R0pMI0pbdkQehcOHGA6/JjZd
         YapKuzfFSXX52JxuiRJxxRz/kOsn4q1UlMhDx4qncYHTVB7H9EpeqGm93npHmmXFPytI
         6cU3IEWtfH6CWbabMdy+dixZbr94qszIwHxT/8izL9bLtU2RbgywkSBV01yRT5TUs1WF
         efNjrnDxiYWg0BAK0DyVOS8vNAnLGr2pbb+mh3KeQBbyMc3Ja1Ic2oguYAlG6sE5QpCQ
         6d0fx2pNPSRB0qKLBc7xs3kLgruXW2yb/YbOgJXgs2GduSGdKEY3FcdZyk9hEuHwYEVC
         OQ6w==
X-Gm-Message-State: AOAM533BSGfEEsWtsaEDC7m34V3P7j2nrIVF134yF+socghyXMVK2Qyp
        j6jKxhmLD3dvp4nFTTbDVt/XRFn5QGw=
X-Google-Smtp-Source: ABdhPJzO4kM2Ak7ZTrErEP/TSuhsWWvMOge+zBfxrgMrr9TNDGCmEkkmCmgiYr3wusx8aa7mKcDkvA==
X-Received: by 2002:a1c:720f:: with SMTP id n15mr11728441wmc.173.1633817726869;
        Sat, 09 Oct 2021 15:15:26 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id g70sm3261147wme.29.2021.10.09.15.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:15:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] yet another optimisation for-next
Date:   Sat,  9 Oct 2021 23:14:39 +0100
Message-Id: <cover.1633817310.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

./io_uring -d 32 -s 32 -c 32 -b512 -p1 /dev/nullb0

3.43 MIOPS -> ~3.6 MIOPS, so getting us another 4-6% for nullblk I/O

Pavel Begunkov (2):
  io_uring: optimise io_req_set_rsrc_node()
  io_uring: optimise ctx referencing

 fs/io_uring.c | 59 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)

-- 
2.33.0

