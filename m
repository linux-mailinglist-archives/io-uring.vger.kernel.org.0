Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0279C28A3E8
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbgJJWzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731245AbgJJTFM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:12 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC5BC08EADB
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:12 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 13so12920015wmf.0
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VL6j6YSMb4UExyJgLJzWW8xTGFSNORehDfl/DyQluMI=;
        b=kmp6GpVcKRVM1AhZj5OU+z2K6p1Mbp8q9hCZxfUMGctgPCufzSzMlq54dF4WJF+AYz
         gk3lLd7JKCdhLHLg7aE/5UXBNfqTQVum58eD12lrqDevS2EiW+2b3R1SsWNBeJsTagiW
         EE7aI/EPGI1FGt6oqTS0pOzAqDQUkozkutOoKTF635MrkaZAKQ9V3QoanzhqCzUTu+uw
         EGEMw0w5tpEYouvkZA+qkf8DTC1WNKo2d3vU4ksEF0rOgOqAY5yNofe3gE1290g4zcQv
         bKrVTvP3ZurJo3Ui6BsYtOR07BjA0m74eBZNL9OBDyHDfR7s3Jh7DV0yx43NdAt21ZSA
         dvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VL6j6YSMb4UExyJgLJzWW8xTGFSNORehDfl/DyQluMI=;
        b=DY+zEaA7ZpeAYwn51nQqPV2TSqU05B1Baqz+2R130WH6PjzF0vgL0bM/xzvgSChOAJ
         QKxV4IqTKbkCqZqURiYub/K/Un4VHjRGRKgdNfCZHJAHgXWZUSKSUHre/2KBwAjVPcXq
         XbCwq2g2FE386BYFZb5uPHOec8X3jngCmXECJ6gC9gQGQdQX3L7kuSEEDA/mQ+M2sQ77
         SQ9GNxrxBNFDY0tryZkLQ3W/dqJLZQtURXjDCmFEZixymq5pPIe7olxUofhYVTtT5iZd
         7lEn9whqOzcoZwU++TbY7UUIxHMbNpRv+/ruxJNhp5Q7Wqho0Zfu+HP99TkWFvSLDKoH
         ZkRA==
X-Gm-Message-State: AOAM5324kLOHWMizYXQfBE8YWGWrsbRDXxiVRIQghLboPSWEXpLBwhwO
        F6hbI/EBJ+HHfPe6xSiU+Bz2NYegSz4Pag==
X-Google-Smtp-Source: ABdhPJy4efy38Wt+eT4pOCy/yBx1KeZY/LeRVfPIiA99C+njkbICOPhMY16pGD29pWVYHE6dUlw9UQ==
X-Received: by 2002:a1c:63c3:: with SMTP id x186mr3680548wmb.66.1602351431457;
        Sat, 10 Oct 2020 10:37:11 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 00/12] bundled cleanups and improvements
Date:   Sat, 10 Oct 2020 18:34:04 +0100
Message-Id: <cover.1602350805.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Only [1] considerably affects performance (as by Roman Gershman), others
are rather cleanups.

[1-2] are on the surface cleanups following ->files changes.
[3-5] address ->file grabbing
[6-7] are some preparations around timeouts
[8,9] are independent cleanups
[10-12] toss around files_register() bits

Pavel Begunkov (12):
  io_uring: don't io_prep_async_work() linked reqs
  io_uring: clean up ->files grabbing
  io_uring: kill extra check in fixed io_file_get()
  io_uring: simplify io_file_get()
  io_uring: improve submit_state.ios_left accounting
  io_uring: use a separate struct for timeout_remove
  io_uring: remove timeout.list after hrtimer cancel
  io_uring: clean leftovers after splitting issue
  io_uring: don't delay io_init_req() error check
  io_uring: clean file_data access in files_register
  io_uring: refactor *files_register()'s error paths
  io_uring: keep a pointer ref_node in file_data

 fs/io_uring.c | 275 ++++++++++++++++++++------------------------------
 1 file changed, 107 insertions(+), 168 deletions(-)

-- 
2.24.0

