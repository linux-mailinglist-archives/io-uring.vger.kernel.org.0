Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B193932EBD5
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCENDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhCENCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:43 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055A2C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:43 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l12so2007716wry.2
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UO91/1F3mRTry1BK9FhceGYXzHooxrEnL6AoyH0GeWY=;
        b=Obaj/ngwN0d09N8hwcsYsN2UNLKGpAoWEf6opIG5dz26AGjGJfTpkO00Rz4/apO0Uj
         fP/wDSvbUEDsAA3gfGwlTBze22AQvGfVdD8BWAcIrgB4MWqA4m2/Q9SOUeL9xh7eIj/E
         H815/+PaAJxs338c82FMb4hcPi53llRQh9+HjN009r9cMsg+AatDTfQ95HjYz/IqMtY8
         pGHD0jBZDRDmqSgtX44OHMpALzdOFfyaLRJMz/GofQJ0e39AO9AW3xHQeKmzQnR8kXNn
         8J+dEkuctcMBl1XidDKaKb6urDHnA5uWoQ1j3f+7zT/dV6/7CN8KKmAYa2rhGKSJ7y3D
         kbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UO91/1F3mRTry1BK9FhceGYXzHooxrEnL6AoyH0GeWY=;
        b=DmEhEaJrMTeMoUrHjzorbluKdrXHulWCPDBUP3XgFctCjawLi5dA9GA6eUdSylU0k4
         cadQg2SPB6+bK9C3zqcEKsTm/VaHLGr+Hj5QvShy/RpFmKx9e79LEnmiWGBNVOi+qF1n
         V0MP6V4R8fUCaZy6sWxYUFKyv/lZ+rUgMHSgORNSN7MOEL4jhF/NrP0Myn7AiWOGA3GI
         gz3Sr1sXNTiKo8HgTWbR74cS6d/+SQUBLYQdMZPq3RXrQC1bJWIqKR7JSsU1iXsxUQd+
         qwg2A5zvOMYCk0qAHifLAmnflV86jEeE4LOoBZKv3rf6EyffN4SLWRZ1t+WaWnM6D6DX
         NGpQ==
X-Gm-Message-State: AOAM531I2OvbbBlV9ANqdoqDd9IbrNjgTgRPGjYjMygt/yMqQXuc2sFL
        MbBpTMwEoAXnO4/Z88MLhQ4=
X-Google-Smtp-Source: ABdhPJyGE2cwxoeldqfXNi0LlTJfX4yW9KrCLgX/93bAcTkUlaA6zQ5Ln88PHLcKPzLakJgKXYDxQQ==
X-Received: by 2002:adf:f0cb:: with SMTP id x11mr9066926wro.206.1614949361744;
        Fri, 05 Mar 2021 05:02:41 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 5.12 0/6] remove task file notes
Date:   Fri,  5 Mar 2021 12:58:35 +0000
Message-Id: <cover.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a mapping from ctx to all tctx, and using that removes
file notes, i.e. taking a io_uring file note previously stored in
task->io_uring->xa. It's needed because we don't free io_uring ctx
until all submitters die/exec, and it became worse after killing
 ->flush(). There are rough corner in a form of not behaving nicely,
I'll address in follow-up patches.

The torture is as simple as below. It will get OOM in no time. Also,
I plan to use it to fix recently broken cancellations.

while (1) {
	assert(!io_uring_queue_init(8, &ring, 0));
	io_uring_queue_exit(&ring);
}

v2: rebase (resolve conflicts)
    drop taken 2 patches
v3: use jiffies in 6/6 (Jens)

Pavel Begunkov (6):
  io_uring: make del_task_file more forgiving
  io_uring: introduce ctx to tctx back map
  io_uring: do ctx initiated file note removal
  io_uring: don't take task ring-file notes
  io_uring: index io_uring->xa by ctx not file
  io_uring: warn when ring exit takes too long

 fs/io_uring.c            | 131 +++++++++++++++++++++++++++++++--------
 include/linux/io_uring.h |   2 +-
 2 files changed, 106 insertions(+), 27 deletions(-)

-- 
2.24.0

