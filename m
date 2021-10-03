Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A14420142
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 13:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhJCLNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 07:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhJCLNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 07:13:34 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A24CC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 04:11:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id bd28so52895983edb.9
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 04:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edzK0t/Stl28eLS+nQgJizbFsXy2MWopNRhGTkiGQ3E=;
        b=M9xKlZFVI8kCe65V5JQh//L09xAPqmdLBOcuLEl+z0akQI+lzTaIeMph4NN32RgvdQ
         7aKM4BKDS6Y7QQ5n9ro0j/8uYloJqGaQ5vvSjz5wG41kRt9cKgI4mmMyiJ9MoLcGHZ4t
         GiMYMQCTARoQtaGczGvlDCOJMFR5U/ZuD14Lz9pF+bxiiXBVtF5/PY2ODKR/BGWlZ0ik
         dVR/RFGh8NrBAJ8ayho1MhvB+Mcdy64HNMiQm5taAH2OFXuvhZbqe1MVl0Vl71jrwIVR
         QnZzI30VM1Bv/Vezdt9/jsKDjdw6IlR2S2iVYkXyOLx7N2P3Gshd0Y71ttWJbss0RQqY
         KqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edzK0t/Stl28eLS+nQgJizbFsXy2MWopNRhGTkiGQ3E=;
        b=vmMVoEfZFiZlaLOhdO6SvrGdo77TifJuhZvhHCkfAlf9IZb4GrszhpY+abMOY7wDb8
         LFdicZG9QlEevSxneVOyK9QmXCZ86/xC5nkQfWlRx4teQijN0LNfMlJvWGhWH3hLB/Fg
         rPPQmXKiBBVFGWcZJnp2GFzFEO2Ge0W5E7Vyb27HDTXpgebjaDvnimZKntgphnJNEtHY
         Wx9lDVRFybClX8Jj+6lkCEDFeYRaTXb6zsWAmotfFTDMmgINCxlq2rC/KBcVyo6Jxi9y
         UetE0D/M/WYezsfs3+NT34jyTF4rTLF4RpR/IZ/zx6/hdvxG/caUfRh0LG9H+bE1rCX/
         W4xQ==
X-Gm-Message-State: AOAM530wXcg17Gvhz9nUzrBYRAloxXXDY/a41pO8WmUJzP5iKbMpFEmp
        ldPtYHsm+oJTl65q+AJk7stGdwP9fio=
X-Google-Smtp-Source: ABdhPJwhNLWQKFFi3h1uoBEdAIrLZVpOqHXkdCy9gyqe/SmaH5qOSHvm12qoDj/1xGgoMmMUFpDweA==
X-Received: by 2002:a50:cd87:: with SMTP id p7mr10391498edi.294.1633259505675;
        Sun, 03 Oct 2021 04:11:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id r6sm210492edd.89.2021.10.03.04.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 04:11:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/2] timeout tests
Date:   Sun,  3 Oct 2021 12:10:58 +0100
Message-Id: <cover.1633259449.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 tests IORING_TIMEOUT_ETIME_SUCCESS,
2/2 works around a pretty rare test timeout false failures

Pavel Begunkov (2):
  io_uring: test IORING_TIMEOUT_ETIME_SUCCESS
  io_uring: fix SQPOLL timeout-new test

 src/include/liburing/io_uring.h |  1 +
 test/timeout-new.c              | 22 +++++++----
 test/timeout.c                  | 67 +++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 8 deletions(-)

-- 
2.33.0

