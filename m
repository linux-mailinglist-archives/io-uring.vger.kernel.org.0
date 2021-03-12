Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE2339374
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 17:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCLQdA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 11:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhCLQch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 11:32:37 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7202BC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:37 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so4851272wma.0
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oic12ynnA116c3rRDMkhLFGv0dT8rmC5wo9T3QNB9nk=;
        b=i/qtZOqkzx20SJT+Ln4++WqQmbGWsEBkW1PXs4GdNcarn8YsWFThO9xcQ4YHiMRYDa
         CL1wNhB35iLTtsVZzKmw1vrXxP8hNQ/MlCc9Gp9nwrNGF2NN4Ux56Ynw5yjYdlqowS2o
         dY6J/rv82oq3RS9Ts38bOlozY0EPSQy9SSd04xFKTvk93lk3P4UR4X3DBp2Rl4Mf7FqR
         O0auWBlfbbJNSeYdHIfb5Bjy++PGqoYFOVXI6XxQuifrVwJBQQh2Cgug/fXOAYwAoLqI
         mHeLSmRNlQ7riei5O0XpzvHsZNT2lv6V09UDrSBD6arQaVq1VTpG3mTT+WPRJaql5y4/
         iGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oic12ynnA116c3rRDMkhLFGv0dT8rmC5wo9T3QNB9nk=;
        b=YyZW+nTwB0IWw/dDA0XaRGO3h1c7qcOVbK9uzFvVb0KygjX434b2xAKQyng5SfYEk+
         9uGbnE+MQbzkb4CURiTjzMlMKe5KEOgVND5cdZpOG/VjLVE4+reZTqZjG/MAKfix1vts
         qHP0TW9YZu1eKlJYzfKioTyg10weHuvdin99Ak9LldJWVPw0xVAfAG6+4Tzi8oR2s2hX
         r7xSv2T5HAoJf9xFIxeP7X+XM/sl54cGm0GdS7NyFd7DAGb5hCv92ZgtoGGqntXwgt1Z
         52YdrJUbK0BOfzf+8lpJAd91NkQbGvH+YIuXH1GtfEtZ2wJJN9uGbgXUXsYc4EQtOseN
         9CmA==
X-Gm-Message-State: AOAM533W6p5oGPi0aqVS/OTaLvyhwU8pnKYaxJkEK3hvvpv/ypUWGJAK
        ufZElnT8poK9IVt7uNzkWtREoZGZ4HbIPA==
X-Google-Smtp-Source: ABdhPJwgpvUuWNyYnQS/Pb3uLJzsvXTj4BwONKZN0vvflyeLYYVkmOjXrcB1Uc/fDCqqsSyfI661Qg==
X-Received: by 2002:a05:600c:2cd8:: with SMTP id l24mr13800990wmc.88.1615566756181;
        Fri, 12 Mar 2021 08:32:36 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.203])
        by smtp.gmail.com with ESMTPSA id e8sm2631265wme.14.2021.03.12.08.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:32:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] cancellation tests
Date:   Fri, 12 Mar 2021 16:28:31 +0000
Message-Id: <cover.1615566409.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

resend 2/2 + two IORING_OP_ASYNC_CANCEL tests in 1/2

Pavel Begunkov (2):
  tests: add more IORING_OP_ASYNC_CANCEL tests
  tests: test that ring exit cancels io-wq

 test/io-cancel.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++
 test/ring-leak.c |  65 +++++++++++++++++
 2 files changed, 244 insertions(+)

-- 
2.24.0

