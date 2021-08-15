Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C29A3EC85E
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhHOJle (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhHOJld (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A3BC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:03 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o1-20020a05600c5101b02902e676fe1f04so9812901wms.1
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMHDPavswTo5MqTPEHGGALoRaekQpG5onvGK6WFC0Gw=;
        b=N2WBz19BmFvMcOadSp8N/rzq2hoPShurOBE/3QtmJ5u6ygkVIQ2/f8a2+bmGgBfuUk
         EFX1AWWuhEl+P/ih+Q5Z+0PgFzskCZX9xtuoB1DqFAB/6m544jzmlyM2l3PeMHZGPZDa
         o1Rpt6J4UU5pvbaeLQZ089tMEsO3+KqyD2OyhYAoEffxeJFa3yoHI2/XAa6wqL/F4xx6
         CArYUlzzkQEuwJlnmRIJG34KI56Kw1aE6eiKDsRJNDgEPAlpXR0SWIj1Q6Y6+6/k2F0k
         Ps9YK4+60iSoyBdkXEPrfnJ83cSl8UKGtUHCVb2XEay76h1j8GizXxr4WVfRGbiThXTe
         GxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMHDPavswTo5MqTPEHGGALoRaekQpG5onvGK6WFC0Gw=;
        b=gjqUGk9orN050ey+bHWNl3tFuvYJBpw5faUpfm0FQuBzJl8dtAob3yXOG9ahYKvwPD
         oLuZ2NIlmnjQjx1I0hV/ylHQ6eXO41nWtM4TOq1am0K7AHxBBUSh+IdNT2HTgvJ7mFi2
         sCF3W1/Pt8lC8ptpVUBRgFMe/9a5CdEOFxRNUvLEcjsgTqR7IQSLFrtyWY4w0fG3DgPq
         QJZEyeHW460tHnNG/2F0Pu5tZ8NP6H0x5s+DwTGWLoi7Tzhx+1+VWPgEHrw2ahUD6dZQ
         rDIRFBaPGDZVHdmpc59KJ3kaobbYJidJDm6UrUXwfPC7UkA3dtWE763iZsodU2dRY1Sl
         AaUw==
X-Gm-Message-State: AOAM5303qt2iyY8/TwqQ1fqBZYvlxUW0HoMAWjDw/GetEjciodN00yFF
        08NsQkfTmyThalyrrMm5RQCLmTsWYGc=
X-Google-Smtp-Source: ABdhPJxn+dHuXTwvrVwmbV2IXCUbxEf8WehfF9Ua9ynink8DBe8rxdZMHrBxVkhlxJRY1pjteVFehg==
X-Received: by 2002:a05:600c:4a29:: with SMTP id c41mr10215399wmp.86.1629020462524;
        Sun, 15 Aug 2021 02:41:02 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 for-next 0/5] 5.15 cleanups and optimisations
Date:   Sun, 15 Aug 2021 10:40:17 +0100
Message-Id: <cover.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some improvements after killing refcounting, and other cleanups.
With 2/2 with will be only tracking reqs with 
file->f_op == &io_uring_fops, which is nice.

6-9 optimise the generic path as well as linked timeouts.

v2: s/io_req_refcount/io_req_set_refcount (Jens)
    6-9 are added

Pavel Begunkov (9):
  io_uring: optimise iowq refcounting
  io_uring: don't inflight-track linked timeouts
  io_uring: optimise initial ltimeout refcounting
  io_uring: kill not necessary resubmit switch
  io_uring: deduplicate cancellation code
  io_uring: kill REQ_F_LTIMEOUT_ACTIVE
  io_uring: simplify io_prep_linked_timeout
  io_uring: cancel not-armed linked touts separately
  io_uring: optimise io_prep_linked_timeout()

 fs/io_uring.c | 165 ++++++++++++++++++++++++++++----------------------
 1 file changed, 94 insertions(+), 71 deletions(-)

-- 
2.32.0

