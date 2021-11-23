Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63404598F8
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 01:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhKWALq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 19:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhKWALo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 19:11:44 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180ACC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:37 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id n29so35686084wra.11
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEuHEVw4By5HZ9TRA0+EwAJAI03jP/k43B8M3JqYSoU=;
        b=hgDM6yCPOqbvqDf3oAw7EHztQKErAbnYLkEkm1E4Z+wZ1js/qpROHHLFAp+ouJJYfL
         3EF2KbxA8jVLBWpHZswJsWsJr1/9d9H8yfQSLF+6PrF1G5IqGgOfu+MvZOhPCiHpjQc7
         krZyOD41bFwM5gZt+z2Du+Ntfkf0NE+uQqbiYC4yHfUpklGGbFLss4UHJDwHeFR/O6mZ
         xaET00s5IbnILS70KdDK+YNpJgZzBYLNenZChKnDXpcY6ZtroNj6klLYXCEMPmJPsmoF
         xJYPTty55ODF3h+xFfEk9Itoy/s51N+4GPZxjsv+6dGcEdzXzu+QLa/+2iIqUlNN/nvP
         BQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEuHEVw4By5HZ9TRA0+EwAJAI03jP/k43B8M3JqYSoU=;
        b=pNmLlwIOZOq8xElJlsHbxKzLQk2FxaJ2AjL294bMHqcfFufBNVMC2IJcbe61GOUkWv
         aCuGdqIJDKjG8NKmFmsaFnFlAphbaQSmVodQ0tvq3IyKzOr5vmXP33rItmqXWoEuzG16
         V6MNXgt5Qyf/Dl1Sdl6mNRlGzGOncGLZeExp/yeusAWTmD97n6G5GoSJQ6I26yuMXgS9
         7FXDWe8+y2AmEdnnmUY1GMIJy1DmPC9j3xxROTlBCyTzxpukkQYZXZQsXOOUQVW81H/z
         7KHrgPXt9btQRtGh7s0YKTp/GU4yCVrylv14mS0w2+tcHSPvSbn3KnGVPOluf2d/7U++
         2zVA==
X-Gm-Message-State: AOAM532wdFfgcRdznDqBfK33u9wY4J/DhUimNClAvLvCqaeCGAWjllpE
        Tw2GN6F1PC4H0NkZAT/5Dm8IUjWCjy4=
X-Google-Smtp-Source: ABdhPJxAzeU9swSbQzVv5Lf4EHuUusJlA7b3HD6EFz8XVR46Dxg1kJNDl772RcQNkzXg84U+L9OVVA==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr1754216wru.393.1637626115443;
        Mon, 22 Nov 2021 16:08:35 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id r62sm10139409wmr.35.2021.11.22.16.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:08:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next 0/4] for-next cleanups
Date:   Tue, 23 Nov 2021 00:07:45 +0000
Message-Id: <cover.1637524285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

random 5.17 cleanups

Pavel Begunkov (4):
  io_uring: simplify reissue in kiocb_done
  io_uring: improve send/recv error handling
  io_uring: clean __io_import_iovec()
  io_uring: improve argument types of kiocb_done()

 fs/io_uring.c | 102 ++++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

-- 
2.33.1

