Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704BE36C873
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 17:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhD0POs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 11:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbhD0POs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 11:14:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E484C061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:04 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e5so31201290wrg.7
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TDpOyeE1OoztUqdCUjzkw3uDoLL/go11RfBatCGRG1A=;
        b=E3MsfxAW7UAzzrVit8h2+S/qrJC2fkhaBzHwyJ9P/3q7Rl0+MEym8hLhXMauS0rGIR
         gnqiSFAm9glwM5k9Oce5uPY5G8X0S+Qu42Gd66Ud43uDfxBc9OubfNbpODwD0CggbmaP
         GUxsGYiTsz/b7AyQVvB+euFSZAh4EUF6PpvLSI9iRVd7FrPehPNL56YdJk4YOwma88un
         qGzr1HQyVmkriKN212cmJr5s/0fOKyBKtmvtVivu0o+YB26SSRrD9amcq92Q0cDHGtkT
         Uk4B6qFB/Z2nTTSXH1jyP06dcAx+C+R0IO+kLBYttvP98kstBY+PDh/Y7zo2UOC0HTZ5
         PtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TDpOyeE1OoztUqdCUjzkw3uDoLL/go11RfBatCGRG1A=;
        b=cpU06uAS/SvQH5mJb2bmsucuAKnWIYE++8VTw4+U4kZyGtRy4xw5/cSSoMg8RIG2at
         TA0NMeWuR5cyoM7S3FueKqKZ3fVxAhG+lurNdwoAECDXRmOzM2oqhfPT1GwFu4nHMQe8
         8ktWu511AZoeKAfPVxrE2HytZA/hcahhTHxVaAPdHb+6lAfMQl1aWV16hcXf5ML7xWEV
         HwlA5BujSbQECpiTeaoPVFWDhNsxc8/C91LUJRza+u86HfMaD5VihcBjPXeedgYiuTg2
         5qb7q4dfZ3fuZuJJd4loFM40Ewgs++AkoPlRyFl2cYRAv79UhtO4+nLptcPgSAe3FSYU
         7sNg==
X-Gm-Message-State: AOAM531cyxvJC8eNGY0dCsEwb6lFihPWlqVAhVwatkbmJD+ywCaTI4AB
        UV9DZ5/0CXe2cHPpxAZf4+SGEym1C2Q=
X-Google-Smtp-Source: ABdhPJzvZ/03TS5ytKlQWLZh5BLMyI/lC6UaqjoxjdrlkNvQcg0Dxjl1elPdHsOP7wRfi6k0Z4D8pA==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr22375613wrl.189.1619536443340;
        Tue, 27 Apr 2021 08:14:03 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i2sm1629630wro.0.2021.04.27.08.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:14:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 0/3] drain rsrc fix
Date:   Tue, 27 Apr 2021 16:13:50 +0100
Message-Id: <cover.1619536280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/3 is a rsrc-related follow up/fix after Hao's drain fix.
Other two are simple hardening.

Pavel Begunkov (3):
  io_uring: fix drain with rsrc CQEs
  io_uring: dont overlap internal and user req flags
  io_uring: add more build check for uapi

 fs/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.31.1

