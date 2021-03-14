Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA733A819
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhCNVBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNVBR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:17 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2588C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l12so7690075wry.2
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Hf07OTyIniRJPb/wOdoyp7AK7ymJtAGVsREw2LTclo=;
        b=n7MvJxGHL6ErcvTNaWme+QIMk8kPhfMudNy2EMEtwJ3KoSOzzVk0P+eYLH8Ra8GyTU
         DFvoDUcmdkrE8AOx9mPx7fkOL6+EBaQ8N6pGTf1cARtNoZcVWjvp0nKornUFj3Xfcg2T
         BbKykwcG3f9V2y60enbr5vct9zEDCPNQzfEyahT8hrgaZKX84g5lJAbkYIZS98OXwO56
         8Q/mPZyY2QWSubeCy9U2CKD5LN9QaGP+v/XZBTtACq8ZHW2Gu6FjpLOQDgjZ3VpFltzF
         4frIOmbnjBL8IWrZEMtT33SC2WA/Ip4dD2Ow15w4QlyI17KBYFygsSYah/QU+prC6Wwr
         GaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Hf07OTyIniRJPb/wOdoyp7AK7ymJtAGVsREw2LTclo=;
        b=R5hYm3uNkNkI7GYiR7Zh1QcguD384fozS9fg63Jy+Z21eefU0HCmvuXVS4yOR0gBse
         9Ti2pquIwSrpeaq9YrlNvVB4eYmylCa+5GjvRERtMU7NMJ8ebGwu2k0zkhSrcv395/pz
         ueV9KLuJcyR5kp/nSMiibAOXKlQ/6FAb+NzSIVu1X7/1O5VPWiYj2KeEmLAD01WomO3U
         I35nnt799Hh3Pp8sRt5Ib1o7bOk674omqMkY53+zlf9yGTNjP+JV3mD7q7G26z663Oke
         kVrtk8EJogd19bYt4O99wPfcrtsmJXsY1KT4WWhLw4i5R1an6g91BR2Yns6BnRBqC5wn
         XgYw==
X-Gm-Message-State: AOAM533ky7eOOlUPYsYoOFlC6luMuVRlc/U0Pa0n7HCS66KdcoUk1cQx
        GNr3t0f6xlm0uKrn3iERxlCO7jJoofL6yg==
X-Google-Smtp-Source: ABdhPJzKistrDabNdGZipmGV80oN5H4sXM/n+5BfEk9BG/757nSt/Afq4CZcvd7J2dHAql997c2G7A==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr23542775wrt.426.1615755675649;
        Sun, 14 Mar 2021 14:01:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/5] fixes
Date:   Sun, 14 Mar 2021 20:57:07 +0000
Message-Id: <cover.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fresh fixes, 3-5 are SQPOLL related 

Pavel Begunkov (5):
  io_uring: fix ->flags races by linked timeouts
  io_uring: fix complete_post use ctx after free
  io_uring: replace sqd rw_semaphore with mutex
  io_uring: halt SQO submission on ctx exit
  io_uring: fix concurrent parking

 fs/io_uring.c | 72 +++++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

-- 
2.24.0

