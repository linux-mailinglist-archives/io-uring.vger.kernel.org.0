Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5932AA54C
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 14:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgKGNTi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 08:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNTh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 08:19:37 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0ADC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 05:19:37 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w1so4106866wrm.4
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 05:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wR+R6MRYvlXMMLVxlqdavUUVc30LMA78uuQfFY4zv7k=;
        b=VaNcg1ieXOMf27Lmf2EWWzuvAVxBnoZh4yBhB1MLAOAopeAcaT6XhCH1eMa48hfT+K
         zhql0sY+IIxRo5jUQoGLhyGHP/88ftCT89yP9uBFWZZxRJFs/c93T9ToW+GM1kn+CpFt
         V+8mxYluWpPRvozTGSDavA/P4vd9H+uwsmHRfgxSphtdEUVVl/AzBR5GU+stkgHp8Mtl
         pAxlhpM6GZFcdOuJa6HBzGnPeeptGcC5YR0GpkMyRpl059avq/rgXqjbgasG+iQOixYv
         dHHSJ/HTyIoWEEV/DATngj5vKd6b8sIME1V5zqEq6BDvzkXlveCeuFUP8v2nwbUk41nE
         DGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wR+R6MRYvlXMMLVxlqdavUUVc30LMA78uuQfFY4zv7k=;
        b=EMhMrRJh9HZIfZ8pyi03TrG2+NgBdSuKLuHQM4UbYfb0KIpO2xYggtIoKRxcv/K+oR
         wW8NscC6xHLP907UO98jx6149QcJjqWFzDsLxKnJ/AMn63la0TTRMZFpQ3REX8ZSK75/
         Yk56RIXKDB5jkkOygxIr9NpnBy/4jkX/c0YM/aSAFdbxDCrCyn0VBW61TDHkTPTOlqAh
         HUybQ3FW2jvoyrGWw0h3sNRulDFDPIfNYxh6ccbu13hTn5hGH00KddL/vA6pc3MvMS9D
         G5SenMxYOflvCJy3Ja8BehHCOlWILmJ4/jA0UOa6AK38PdQcPGIo77brM3VLsgQ/QhfB
         RVZQ==
X-Gm-Message-State: AOAM531pvhdswL1glq/HkkLvpVrN7NM1SB0X8c86siar3+Ma1tudasdx
        MrU3l+2KertHzsEwPlaP1MPiWKL9318=
X-Google-Smtp-Source: ABdhPJxdt/k/da0LUdFOyQ3oMQLiBPRMPZhTNTtO7imTdrGkjoArRhfv/sHiHpRpMLJHlk64EpmUEA==
X-Received: by 2002:adf:eb08:: with SMTP id s8mr8365020wrn.12.1604755176226;
        Sat, 07 Nov 2020 05:19:36 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id f1sm6411810wmj.3.2020.11.07.05.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:19:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH 5.11 0/3] rw import_iovec cleanups
Date:   Sat,  7 Nov 2020 13:16:24 +0000
Message-Id: <cover.1604754823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a couple of things duplicated, it's how we get
len after import, vars in which we keep it, etc. Clean
this up.

David Laight (1):
  fs/io_uring Don't use the return value from import_iovec().

Pavel Begunkov (2):
  io_uring: remove duplicated io_size from rw
  io_uring: inline io_import_iovec()

 fs/io_uring.c | 58 ++++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

-- 
2.24.0

