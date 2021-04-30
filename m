Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46D136FB35
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhD3NLJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 09:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhD3NLJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 09:11:09 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98B6C06174A
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:20 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k128so37818901wmk.4
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZNytVrq1bZBZ4yzyhiMIiQXlbmx4yoh/zlBhKFe90w=;
        b=BxDV5yk1iSmO6X1uTRCiue+6Mab5HqJnnop71YAkZFp1JLW9+kUYiKe66cksHy16ej
         IiBGeEC/PunNBo7+EgNCxlvirOqEvR+IAJW7EWTmAmE6WBx/8GbVuzD4VgzDmOO57mPI
         AFYZPhFpM7dBYKEgiXPIZMc8G1RvM9+9pl0BQlA3MohybjfNI6RoIDRtfwzIH7T5XjeX
         GDBWM5or7JZY3F0d357OR50kgWAd++pXglFGY1tBOYmi0bpVE2NmiadgpMSLtZazh/DX
         uAeABIRU8/WAHMm08KHVKjC2MAnsBMdrpub4D6DbQVvmBFfBFYGRPO5c2J2se9q/6xm5
         jSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZNytVrq1bZBZ4yzyhiMIiQXlbmx4yoh/zlBhKFe90w=;
        b=myWEVHEU2RpW8kBuF2V+MojM9uk17E4WoX5xhCJJ7ya2SVIGJTFmgVFaJ+KZzsQiKP
         wjgcwa1V5ogxtLaTYrF+X2iSp7Kqv4+VeEJJJmaMU3JFrEMGRG38YZXqRcePMTwoh5A9
         3LmLTYzrzHtg3NvdTktGMNCg8H2s5aheqOiZY+71W+EmZwO8SkLEJENvih00NgtuI6vt
         FXDVsSyqU4AqxT9WXMCmyeYz4TPVa5CM+AQW6ENrDWc3AF7oy/IAH5m1IQ66sewF9yZp
         YMMAzcgklfFsQhXj+CX91xspzd8MTQYBJnmmdHJ6I4VTX+qzu1qAM3GVE1WaJea17QH9
         Jguw==
X-Gm-Message-State: AOAM531JjOkzGGbKYpHynes/k6NFwNpC78hSoiMaNRq1uyLjJPviRv4A
        1Ng18QSvBchQTICy8S6XEOs=
X-Google-Smtp-Source: ABdhPJzNp02qKR5RO/9IEM7ftV9A0HnkTW4KcbO9/2cE5EX8hzk3Bck+3c5juVP3o50UkyATpIZXMg==
X-Received: by 2002:a05:600c:4a22:: with SMTP id c34mr4357045wmp.160.1619788219791;
        Fri, 30 Apr 2021 06:10:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id v13sm2292925wrt.65.2021.04.30.06.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 06:10:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] ctx fields reshuffling pt1
Date:   Fri, 30 Apr 2021 14:10:06 +0100
Message-Id: <cover.1619788055.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First round of cleaning up struct io_ring_ctx fields. Just moving
around, and only in a way that shouldn't hurt perfomance.

Pavel Begunkov (2):
  io_uring: shuffle rarely used ctx fields to end
  io_uring: localise fixed resources fields

 fs/io_uring.c | 67 +++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

-- 
2.31.1

