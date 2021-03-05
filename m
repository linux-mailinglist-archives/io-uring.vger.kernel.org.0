Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348232E09B
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhCEEW0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEW0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:26 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCD7C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:25 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id e10so583542wro.12
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLBPJV5nKAwvnVe9KaIidjJloKcLPgXDvIgreyF17Mw=;
        b=oJ/e4TuJ+4af64nXMRlT/WYvQDBKIpmNUwVmYsJ4eMNiBWl3JBVc5vkTi2V7tA8dem
         JnzWEmt50y08Dw5GwSa46Vbx67VXzsi6o8uozWXsThxZHMit6J68wY6njrVUgBwO+p9C
         1BRXpyrHRqOOUiOSaY5xc1QkxHu4k9hNgcyAFaYby/fWQIEzBD01FWzO7Q/lI284VQBn
         sYrf65tZd+Uo/U1mOPwA10sdKCR7FFTJxDVvN3etQJ66FAXPkUEWbNn4Tf7RLB8wkrdQ
         YcCrmqGoyY+WdO1fo1d/S+QBgLzJfj96dxn+lQJQrhAVLTuLkfRqjBzLguT0ecapydzT
         GmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLBPJV5nKAwvnVe9KaIidjJloKcLPgXDvIgreyF17Mw=;
        b=VSyzkTcbe47a7bMuAGTfZj9q3rBlmxxO5QtmUnXQJJguqBMB5/JveaqPp/rrbutoLu
         Pf8veaSP+HvVLmQxhwQbaNV5jOVRVf0ODBj9SAQue2Em4U0Ut5ZYrv6GoNkLl+/pbkkf
         mDregFrwM/eg34rbAyJOOgxBqd70OW0+tb9T8jcgOXZTj+gmygOld1Hh0ofc5HF8tsLi
         AeWiu19YNJ+LsVU+dSzJKEaNCBh7D+VCQGqIR1qZg5zkvnY8Nq45UYrY0939XDjKb80c
         FBwCvcyhEpGNzhOxehDXeyj0GPfyjfy5hoMNdQN6+wz9KRfzjmjUY4yrtE5Wqll/xaqk
         OBIA==
X-Gm-Message-State: AOAM530RCzZMPufyicRpDb5l3NnDro5WvmHU+QqCYMr6Ty8PEdsml4wn
        kllUCOi4GyU1GGYDYXdNgO3nUZA54i/r2A==
X-Google-Smtp-Source: ABdhPJxkJw6O+DcM/RxmaK+iu1WEznYDoFy4eIMhQqSkNdQfMVygVB9ad33MerIxoot7z9KCZ8Z1sQ==
X-Received: by 2002:adf:a219:: with SMTP id p25mr7190722wra.400.1614918144407;
        Thu, 04 Mar 2021 20:22:24 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5.12 0/6] remove task file notes
Date:   Fri,  5 Mar 2021 04:18:18 +0000
Message-Id: <cover.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a mapping from ctx to all tctx, and using that removes
file notes, i.e. taking a io_uring file note previously stored in
task->io_uring->xa. It's needed because we don't free io_uring ctx
until all submitters die/exec, and it became worse after killing
->flush(). There are rough corner in a form of not behaving nicely,
I'll address in follow-up patches.

The torture is as simple as below. It will get OOM in no time. Also,
I plan to use it to fix recently broken cancellations.

while (1) {
	assert(!io_uring_queue_init(8, &ring, 0));
	io_uring_queue_exit(&ring);
}

Pavel Begunkov (6):
  io_uring: make del_task_file more forgiving
  io_uring: introduce ctx to tctx back map
  io_uring: do ctx initiated file note removal
  io_uring: don't take task ring-file notes
  io_uring: index io_uring->xa by ctx not file
  io_uring: warn when ring exit takes too long

 fs/io_uring.c            | 131 +++++++++++++++++++++++++++++++--------
 include/linux/io_uring.h |   2 +-
 2 files changed, 106 insertions(+), 27 deletions(-)

-- 
2.24.0

