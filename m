Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CBA468B69
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 15:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhLEOmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 09:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhLEOmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 09:42:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B51C061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 06:39:14 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t5so32335324edd.0
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 06:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAaEQJgtB5XbT8Lyn+i3WS63KoWC8neouCS/9w98NKU=;
        b=Wy382ORRD3pPd8eqdqgADSz4kksTH1l1Ww2i90Pv/lI1gHPkNmcGSC9jR+V7hp4ETj
         SsapdjGUzsEUQGOheSmOk8gkt5BWZt2GOTPlvLdwe+nE0+T7NwROQh7TkWEw+yXv013p
         NsSpKMANgxNytHdtjl4EKHECKVnWX4gLqHKvQB61GBE0wcRXjvcXSc0gvCRruAaquZSX
         PW09tIESBlyCF9EWukwHVX8kTa1bJWwQfQXx7IZKNoLM6MwTY/JZ0iJ3XguM+mBAI7Zi
         loOqe7rcKttFTfWTDIuefi1ZR0yL8lI/mqKKr/QcZAtqWot/ANX30NSbpxQOabgFhrzX
         JyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAaEQJgtB5XbT8Lyn+i3WS63KoWC8neouCS/9w98NKU=;
        b=Z6Z4z1bG09DKmXPO40mrfK5iqUguCK5slQiV1Rey32gBoom6gotA9M4szZp4CtRhy/
         Y4povITUgPY6syjkgaFob/5suYsZu0G8C5K/otTC1lwhf5mADZquDDEhr+QDW+6C3Ml/
         91mWxNqTGYD9x8kX6Yy3vnKd++ltnPuxRNaDKe4gUmGW4KWYJtystR72ND5vUD3CuKkx
         5Zs/gRzG7SXvTMyI4HmY/sYX0vLj5MNnhfL/xVZBcZ/dSUGHkJFvE6dMaRGXRenoXxNV
         ao+BQMeEYj99VEe9AaDzqpfLnECjn00QNn+HBmbvRND1d5z0JnkCKMDiRKT7DMtIWS/r
         IBlQ==
X-Gm-Message-State: AOAM533/TYloGxVqTUrebaYphzypAK6+miydXbb+Rr6BJSbYeTSw/eTn
        owTn5mlxwPrktyFgUZH7I+uSwbYiXMY=
X-Google-Smtp-Source: ABdhPJyd2+AXG/pfHx4xVbv3IHwixZeBYxpVCJY77JFzomba/+wxFxpla/e/C2Gr1BGbuYE97Rmsvw==
X-Received: by 2002:a17:906:8c3:: with SMTP id o3mr39255509eje.10.1638715153086;
        Sun, 05 Dec 2021 06:39:13 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id ar2sm5224935ejc.20.2021.12.05.06.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:39:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH v2 0/4] small 5.17 updates
Date:   Sun,  5 Dec 2021 14:37:56 +0000
Message-Id: <cover.1638714983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

3/4 changes the return of IOPOLL for CQE_SKIP while we can, and
other are just small clean ups.

v2: adjusted 3/4 commit message

Hao Xu (1):
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()

Pavel Begunkov (3):
  io_uring: simplify selected buf handling
  io_uring: tweak iopoll CQE_SKIP event counting
  io_uring: reuse io_req_task_complete for timeouts

 fs/io_uring.c | 91 +++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 53 deletions(-)

-- 
2.34.0

