Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD44F333D84
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhCJNSJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhCJNR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:17:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D9C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:57 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u14so23290925wri.3
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hUvJw+nztEkQwbMVn5m6adCtpe5L76ypZpp/8RPHslQ=;
        b=Mdd6MGwiOEB+YEgMFZcdRjwvoUX6qobXLM9hrBIySSddQnBLLCb5G+2Yso+V0WFZ3/
         G4Kr8hBfoBzpgDC8ctLuflmhNUOAfxcJOCwC5d33aTtK53qUz/R+eFzzxeISY02RTwAh
         VLzP8jLNqsQARxlc55eFTMv38wJr/ytf91j864NvXlJgmjPrpj8SSMLEzE/tQUsYG1Ot
         N7Kp6mtTYLk9VzuEXvukvGHz/wi8Tk+pdfbPWacXCQFWtndNWef1BsReiiOSBDJjO5Qk
         9TE8u1fKoIH/44SF8qprFGUAXX0oqVPqzV54wNubPRPn+7dCAWuBqPyb0hbr7Q9/9ifQ
         cpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hUvJw+nztEkQwbMVn5m6adCtpe5L76ypZpp/8RPHslQ=;
        b=TU0xJJHwLJLXY6xzazQoW711VF/VVhOE3rCu1CuTJm9nOWVnXPTDiOrABYICLa7Mh0
         JJMr7+OmvTmApwJ6Rm6OlSQJ0jdGFSM2Hl2ql9Cp47yiLaf/17MIfa0SgJ3CZPaUrLuB
         e1H6LMJ1Ycv1uRaQbcAnxar9fzr1vMIgSpZ7PYo5ORD43dwUIAcGb88wxME1icUqNubW
         SRl595zCcI3F8tHOeeVPLj21lGCO1YpCbFhWikcF+AntN1LWlL41siMwr/DfuO81u5sq
         XuL+H9AIlS33/EexVJM5xEGi/JJ4Oj+RLMNaO5Zz5x0Za+lsyYsVJ3jART9MduweNSxb
         pFAQ==
X-Gm-Message-State: AOAM530s+aF5kCXiqQsdjgWrSJAZH0VcQlOTKj+aizjBGrrtltN3gvSx
        oDo6fDE42HJqtMKPbRscCDw=
X-Google-Smtp-Source: ABdhPJyH81hPyEwmKwdyO1ejJ8Apr4Sngh45H1Nocu8Xvc5kSpBPRk3JTb028UlaggUXIzgXCj3FiA==
X-Received: by 2002:adf:fecc:: with SMTP id q12mr3454197wrs.317.1615382276149;
        Wed, 10 Mar 2021 05:17:56 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id u63sm9328004wmg.24.2021.03.10.05.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:17:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/3] sqpoll fixes/cleanups
Date:   Wed, 10 Mar 2021 13:13:52 +0000
Message-Id: <cover.1615381765.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All can go 5.12, but 1/3 is must have, 2/3 is much preferred to land
5.12. 3/3 is meh.

Pavel Begunkov (3):
  io_uring: fix invalid ctx->sq_thread_idle
  io_uring: remove indirect ctx into sqo injection
  io_uring: simplify io_sqd_update_thread_idle()

 fs/io_uring.c | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

-- 
2.24.0

