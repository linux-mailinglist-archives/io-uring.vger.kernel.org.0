Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B535D514
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhDMCDX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbhDMCDW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:22 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05C3C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id y124-20020a1c32820000b029010c93864955so9720115wmy.5
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdA9khZVdzHn61olgVoKb2aaNiyYDl76rirlMElUNMU=;
        b=g8PNmUkivMr2h8SJAq9H4mT49TNn4QKL70xGGKnxhCAVJGmOMG+KueGQmKzjgColzm
         LoXCvxqFerScVZH0iZRkWUbovldEf1huiA4nsc6k8peWDjVLS9noQnFXqVUGthGpUIfD
         h3UA1zxaihkOmBdHwYghMuWpEd1NRyhLy+DH5kpAuKeWVsLNyM2/LBF5k5rais6Nyckf
         L1jCVxVKNd0Hw8VkGyqbNjyhjOEJKEyHE5IyQDHVfJxxQ3gB7IWruQZ+0wblqSE/3jJO
         sr1q+oq0mALq8+DEBJk4sbUQyKZHhbN7Uz9XC8LBSoUWLBVwgdVJK/xEVd1U+uvbnB8u
         G+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdA9khZVdzHn61olgVoKb2aaNiyYDl76rirlMElUNMU=;
        b=i396w+pl18OhbN5DxilKBGJ2XOK+D86kpsnOrCZA5CeNCCMQ6MezG7kWsPwxtWrftG
         5zaoyVziv2hhCNytjtbx5Nn6dlaU+AsKp2sQ0hiVZiREK8HYciXRM3ZxS7cQcs/n3044
         I9d4Cl9+XJE4rDy6ZYp2y6SPm7I1lE+t6DChUE9fKdfv4QqA+ZhmN8gTsTY1XEhBWi4O
         QWz0j/WHnu8H+LCsvpbHS52OuPSU9wOgDODWHHHjlkkP7L9IFf65nXgalOms9gkXSu2g
         Qx+hMbI9d2fxMbZNhHLPbVs8sOeqj0AldFHDqppR9xHGkUK+05SYS6HHhusGJJeaoXK7
         AzEw==
X-Gm-Message-State: AOAM530t38BJWhS0SOj4cFA0UPC584rzPGjwCxsjHcr1PIW1iJQt6sGU
        sLwvRUP0aUIf5evUAFY4//ZFSF1ETBE=
X-Google-Smtp-Source: ABdhPJzmAxAdCzOlbJcJxpaTcNTTA59v4BdxzINkO8IFEjZYd27rYBokd4/WadjmDUxPk/0jEbgAoA==
X-Received: by 2002:a1c:f404:: with SMTP id z4mr1683794wma.39.1618279382642;
        Mon, 12 Apr 2021 19:03:02 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 0/9] another 5.13 pack
Date:   Tue, 13 Apr 2021 02:58:37 +0100
Message-Id: <cover.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 are fixes

7/9 is about nicer overflow handling while someones exits

8-9 changes how we do iopoll with iopoll_list empty, saves from burning
CPU for nothing.

Pavel Begunkov (9):
  io_uring: fix leaking reg files on exit
  io_uring: fix uninit old data for poll event upd
  io_uring: split poll and poll update structures
  io_uring: add timeout completion_lock annotation
  io_uring: refactor hrtimer_try_to_cancel uses
  io_uring: clean up io_poll_remove_waitqs()
  io_uring: don't fail overflow on in_idle
  io_uring: skip futile iopoll iterations
  io_uring: inline io_iopoll_getevents()

 fs/io_uring.c | 236 ++++++++++++++++++++++----------------------------
 1 file changed, 104 insertions(+), 132 deletions(-)

-- 
2.24.0

