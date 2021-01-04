Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC12E8F53
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbhADCDj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbhADCDi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:03:38 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E93C061574
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:02:58 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k10so17158391wmi.3
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+jN5BEtXWpy2NHPOnJMURrww+E69gesNPZ1GiNl3XQ=;
        b=i3KRNE3JGnI8vqd2rUpr2+1yfBO3V0z4IaTiLsvmAQO44skZd0e2VFMQqvKOmugKtk
         cRgoSGki7h/QhQdiN02/k5UqJXMtkkx/8h7RboPF4QsXuJP419NnvioHb0bqtFWt4OJ2
         KgNJtI9XRs3nyDm4969qwjCOs9vw1Kyu9af0TTrvYpULcwwn4KJdRlACRkc9QS8R+X59
         pOBbmAEea8+uSYs0gT0DAeBJTzvWbWu+BOZA02bNTHYPBrba06WaXVESeNr6FWqGQaLD
         gTZJvx/2tZXt9f2hURJU5U2OcJIUXHCiFky4KHf2d4K4n59M2NtdrR6SUYs0ILNhBRKb
         JudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+jN5BEtXWpy2NHPOnJMURrww+E69gesNPZ1GiNl3XQ=;
        b=ZVWvrwVvbrYxbnBFExyhWpqLkYdQoPruYqkBhZQPZsepRxXdMrfnMmKYGbFPq/VhSe
         D7V74ALDsdIzd9s1AWlay2BOwnBKqoq0AwsRniDk3oJFbnPHKoNEkNOO6hjvExTmUB9K
         pPZMPy23sZVowzdYEE5f/SIDsdlXMnVPGMK1OSVwg9cfQSiZCIzMGoKTOcGb1tdEugVc
         71mgovnlylGh2wDRkdLXeV/6K4FGMkje1nEnGP0lCPkQhX6STxZCMFRkinUOn8S59/ES
         GHM0Q8J9GdpOCs4QXQi+T0NmEnXybKq2Ii00cbSOsmW3C5LXeWy7cZKjqw4TJDnt5VnC
         atjA==
X-Gm-Message-State: AOAM5317gXDjT1PZgXdOfs7UEUcY0mBODztOd2Oo+47t79FwIQKpJaEn
        GRiXu3W5eSfJ35E7GSQGswHlga5lsvPDZA==
X-Google-Smtp-Source: ABdhPJwa0JJvClLdRLpja+gFCPmhl8S1K1bqpeeQwKLNIky1MTrkc0YhVTGG80QeGX/JX5QLMRu0Rg==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr24817451wml.106.1609725776287;
        Sun, 03 Jan 2021 18:02:56 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:02:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/6] bunch of random fixes
Date:   Mon,  4 Jan 2021 01:59:13 +0000
Message-Id: <cover.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v2:
- add 3/6 to trigger eventfd for iopoll
- add 5/6, yet another iopoll sync fix
- rework 6/6 (Jens)

Pavel Begunkov (6):
  io_uring: drop file refs after task cancel
  io_uring: cancel more aggressively in exit_work
  io_uring: trigger eventfd for IOPOLL
  io_uring: dont kill fasync under completion_lock
  io_uring: synchronise IOPOLL on task_submit fail
  io_uring: patch up IOPOLL overflow_flush sync

 fs/io_uring.c | 146 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 87 insertions(+), 59 deletions(-)

-- 
2.24.0

