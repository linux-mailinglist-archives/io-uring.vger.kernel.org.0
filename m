Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699F445CE88
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 21:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244854AbhKXVBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 16:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbhKXVBb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 16:01:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0396C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:20 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so16194574edd.3
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tU+DmN9W20Qayr+XDrTHdT2YEe8mYh5uJWiheD22Fz0=;
        b=BaHQBYFGqQT9CzTFy898vgRQl1QV4puKDRAXuboZphikgp6gFPxemKasizjPApVGlh
         FxuVjl2KeQHq1aEntoEUQYdbKnVAcjWoUuoEQWvkH8CvWpiLIvKl8rL6hri2PloS+XoX
         9Vl1VYnB1efpbPpgX/rz/3MFZsB56Pv19d9QvYShR0RQPmqj8HD0BjrHO802+ZwNDpuc
         c/xTAX6vwMRFfq9w0uKjOwHs6AQaoiCS+/Yn7eXt96XmZ2TCMNnm7048cpUReu/XaWOB
         8uW9tj53YyyFbpMZBBCpf9TpbaQg114xp16yZtGO6HdtRUIr4ErHonDqGd99IZh2/bKv
         pZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tU+DmN9W20Qayr+XDrTHdT2YEe8mYh5uJWiheD22Fz0=;
        b=xJsd2+aFZ30xxGkb2nEmuunAy2dkVpaPlnSyRDJJxxVhlW43FXbNL1gDJoHviDMyyy
         OYhlIB6lDv5jyy/eJZBBUjt6VJHkDIG5dWzuuLAV460X+ISFOs5/2yutZbapFDDURqdD
         0vQeqrsfQX5zm6yU8+sXFRnEeVLeB4c6V45esDzCNIsLsxV1B6+Q7Y4CjT8cpLAUjT8B
         FLgZOqPvwcKOTKSvEGd8jgFES+9Ij2cGDM+WWWyP7OT0EtqdnP6mmACU/2AcZ9SNWndl
         Axl8XW82LQ/Kr1udWYtFUn3Jl9zPKOPlY2hh6XFQ0Qoc+IaKukQVOwv+ZAhiNOf4hBiy
         PAwQ==
X-Gm-Message-State: AOAM533ClTyBe5jaOk/1q1eV4S0p6LhvbH8lwmsNgs+Nqjo9N5USnqnJ
        bFuYx1mek96NeofD6V7tcORZk88Oy1w=
X-Google-Smtp-Source: ABdhPJw05AZVVNv3MnbHHQaDoSKWjSlyTBYhq0xzERY1v/f7aVZSDks1GG4aeA6m70MuoFeeDQxDHg==
X-Received: by 2002:a50:da48:: with SMTP id a8mr29720676edk.146.1637787499347;
        Wed, 24 Nov 2021 12:58:19 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.168])
        by smtp.gmail.com with ESMTPSA id h7sm745843edb.89.2021.11.24.12.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:58:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/2] cqe skip tests
Date:   Wed, 24 Nov 2021 20:58:10 +0000
Message-Id: <cover.1637786880.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add tests for IOSQE_CQE_SKIP_SUCCESS

v2: rebase
    update io_uring.h
    use IORING_FEAT_CQE_SKIP for compat checks

Pavel Begunkov (2):
  io_uring.h: update to reflect cqe-skip feature
  tests: add tests for IOSQE_CQE_SKIP_SUCCESS

 .gitignore                      |   1 +
 src/include/liburing/io_uring.h |   4 +
 test/Makefile                   |   1 +
 test/skip-cqe.c                 | 338 ++++++++++++++++++++++++++++++++
 4 files changed, 344 insertions(+)
 create mode 100644 test/skip-cqe.c

-- 
2.34.0

