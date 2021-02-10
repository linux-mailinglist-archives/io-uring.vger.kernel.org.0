Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D613165B4
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 12:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhBJLwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 06:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhBJLuQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 06:50:16 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B3FC06174A
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 03:49:35 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r21so2126006wrr.9
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 03:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r59g7EsorrB06WZwLElM2btubAlGnat8xE6V8V/7BHg=;
        b=YenI2VUgDnN7bZLavVnLHGpgU9Nyzsq/BvCua2nsr7xc+gcZxf/Qiy4pvMelZqQGcD
         x2823EX7shL1KrTc3o+T16kNPXZEt5psGWjrIqB0P5f9nHBQ8pyivPuEilRWrMI9EZHF
         nwVox4vlPb+GBP/LgUPunHks4au4pU9+tmPylVgQY+GnCeldWCnOjZLLLI6mjqHC/Pd5
         aRimaMvGFMmALXUhaYV5EzIQbVBCaWLCf/jEkbsW5NgZdx7+SRYrKUPMQsL8Y1GFiil/
         GLNoKDbNlzDVbUpUN8gPlAPHh8UcG2d7SiuD/67STbnuD4jApwCbeFVOchKuu9dvBzlb
         vGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r59g7EsorrB06WZwLElM2btubAlGnat8xE6V8V/7BHg=;
        b=BUy5T3XWjTTAdDyZdrweW4CxHB90Jl3k06HTRBmvELwGU87qo6A5Lmch6gn7eD2MwE
         GYx3fZkZQWHX9O+N3DvmSGWOSBcOpwglN9yLwFSYe8ZOiv0b0qLTPjnV3vsrJ9ENT60y
         WLre7dG9RK4YyeZw6ljQMZvJE4GaySd8nW0OLtOsEh8R30+dLcfkS4A8gK4TSSTA0yik
         DHtw5IDwIPAB4T71A2DLfHtzFffTtaTW2uIGKwKdxW7MchV3346HceOD4b3xFftTc7tE
         sloox202Uc963+rG+zWUnYZBRhPK50OtnNXaBzPbD9MdJNxuPv5jfZd0qJGdJYd0ylhH
         ro8Q==
X-Gm-Message-State: AOAM532rJepdmY+rwx1ylnOm94v9+frqNt+VViVuP9NuNQefW2vW3GsF
        /GtJyY77mx1f9GNYNVYXQklGIjYDaMEwew==
X-Google-Smtp-Source: ABdhPJw+QWbKl+h8d/ZkRYkfmPT3CwwtyFJYYrKIFPUF84jvJHwdX1zR6nBTX8PEk9aEImChwnlF1g==
X-Received: by 2002:a5d:4651:: with SMTP id j17mr3196234wrs.64.1612957774662;
        Wed, 10 Feb 2021 03:49:34 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id j11sm2811145wrt.26.2021.02.10.03.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 03:49:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] SQPOLL cancel files fix
Date:   Wed, 10 Feb 2021 11:45:40 +0000
Message-Id: <cover.1612957420.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2/2 is for the recent syzbot report. Quick and dirty, but easy to
backport. I plan to restructure (and clean) task vs files cancel later.

Pavel Begunkov (2):
  io_uring: cancel files inflight counting
  io_uring; fix files cancel hangs

 fs/io_uring.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

-- 
2.24.0

