Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68252176530
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCBUqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:46:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38793 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgCBUqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:46:17 -0500
Received: by mail-wr1-f66.google.com with SMTP id t11so1563492wrw.5;
        Mon, 02 Mar 2020 12:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5U6brnYffZxReA0kc3Jp7ZTXC79Yajeh0djgdMH+iI=;
        b=XC91BGVCZc7l/5ZGrZKw+VW7prczhjWcoCZtbTdeW7KTEMATYI/HnrNQCrUR1cBZ56
         5utAErOdMYJMSI3aZNq0YOIKW9dcFxO4bbC20lIPIU2QuS1CuTu6qpiO8FhJy7zxApv+
         3SZdVSKH/nALB1EVRf3jItM2Ik+CFQgcu1x7GjZZ2Gis5yJWL6qoiVW0pRqSnGJtFE1u
         ngdtRVVk5b7xE4SOynVeyk+LpJcVAmMQYWddTWRUych8y5dMhaG3vH7B4GMKmVH1meOw
         jzLXbUQApVB0aFaZYUF2KqHS2UxNCh+JDrue6KOVzknOR3COFGi3e6d2EfDc7SOoyvfl
         CnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5U6brnYffZxReA0kc3Jp7ZTXC79Yajeh0djgdMH+iI=;
        b=i483VP+MewsSlxr3fh7YL3FDFnPt0m+skNWLnDpVg2uI8nh/O/Vs6YH6rstpwg1gbh
         hq5ATfchTn64lZFWf1TQxrsnR+wh92pVv0iwavbgU4BcJymiJmfEzo6d2MZXhrcUZ3Kl
         p97mAlmbpKcIQctNVn8dLRppHMAjTp4A6Cx3vibpmwVMnvCpX+XYisb3OdU98tlP6XkX
         yIL5+FF95UhFawND6tZ+0W6pn46J5Kdadq9RsBdyFdQzpG3ct5ur0m76JjpyAAZ+EWF5
         KOQnLHsAMCesrjGfjqJGbAq86eI2P4xiog5CMl5JrZ/5PtOUWeazjtj/d4zkegnbHL5M
         xICg==
X-Gm-Message-State: ANhLgQ0JH0KRQlel5HFrpaSzHxU8UkGjxvwEdmb5ta6GnQehTQpa1kq1
        ncA56Au9TripgTdk0vokhLkYKeqp
X-Google-Smtp-Source: ADFU+vsaI2473we3lCjICmTKFASGiAITQ4XJhtOdYKPmnYnn0PfWCwNLO2Dux+aaC/3N8/vX2rH91Q==
X-Received: by 2002:a5d:6891:: with SMTP id h17mr1264571wru.259.1583181975129;
        Mon, 02 Mar 2020 12:46:15 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id b14sm20186549wrn.75.2020.03.02.12.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 12:46:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] nxt propagation
Date:   Mon,  2 Mar 2020 23:45:15 +0300
Message-Id: <cover.1583181841.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

*splitted the patchset*

The next propagation bits are done similarly as it was before, but
- nxt stealing is now at top-level, but not hidden in handlers
- ensure there is no with REQ_F_DONT_STEAL_NEXT

v2:
- fix race cond in io_put_req_submission()
- don't REQ_F_DONT_STEAL_NEXT for sync poll_add

Pavel Begunkov (4):
  io_uring: clean up io_close
  io_uring: make submission ref putting consistent
  io_uring: remove @nxt from handlers
  io_uring: get next req on subm ref drop

 fs/io_uring.c | 366 +++++++++++++++++++++++---------------------------
 1 file changed, 167 insertions(+), 199 deletions(-)

-- 
2.24.0

