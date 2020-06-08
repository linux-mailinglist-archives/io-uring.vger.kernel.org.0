Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08A31F1EB3
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgFHSJv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFHSJv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:09:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A6C08C5C2;
        Mon,  8 Jun 2020 11:09:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k8so14206569edq.4;
        Mon, 08 Jun 2020 11:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIWEJW4Q8C9XcuWgJjB2jwWYwZN4pyQAGdOTG1h96zg=;
        b=qzTeSUpWoR4bybO84TI367AMQsEGeJ3vy3E/knlZxDU1zMYJsbww86WRTcuI0k66Tl
         uQrmV3LELsb4STm7O9YAeZbZPzHfDkZB6sQecsP8jOsG7O/4s6FXikcD/D0Zw3gJX5I5
         kZvlKYgzTz8Bju9SB/IBsXAJPTdTOEWLPiul6Dk8wm29WHxFT1UozC4KyGi4+Y80Anjl
         RrQs8tBS3NV9ZXiYozGyNdLqfI4fXwYjDr13M5HoxdfkFjSU4U8er2yEw041hl6DoCVK
         y5jZ+hl6q3iezz58ODV+zGrIErRrbUOfNTCVMJDFsApLKiNe2wxAjXADn1Flu1nNkRza
         K8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIWEJW4Q8C9XcuWgJjB2jwWYwZN4pyQAGdOTG1h96zg=;
        b=FHQyTOfbR+eKa+qbTylBB8nlPz8qXjgvvQA+svlrlhTSkdiISFJzgclXcQG/x1Y/xJ
         RayEUrs5MYep3yspJLbRLbDr5sQ274wZUakoK/2fraC9zChfp6JJlfub2IQbd4mMDbfR
         MCWSK6qWuIYlJktyyE5qamXaVOj5ZLDWul9zlAxqecO/IvvjisjdllTp8ak3saeb5jjw
         nW0qK01Kv1s74l2Q+MNLoIzj5LIf3DkEEU2UpYEet5UZ9DirXoSVfzBALBgnaFIjzrtR
         KK6+DYZVHtMJgmAlp7fBA5tJmrlk3tKfUSbJ4l7n/aryUySdpQgf6nmD7gUmEGMp2SPB
         yorg==
X-Gm-Message-State: AOAM531NwvTOuVXJovhLyjXwu215O+PlkQx/T5JJN5uh84N4nXyxzloa
        /ZTltuxhMQbDalJtObL3k0vML3NI
X-Google-Smtp-Source: ABdhPJzbDMdixD3UszhSEqM57ExPKwbhvKqvK/S4fRpxW4hSkOV3GC9Dz5qnN5KnfaLe2+4i5iIGEg==
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr22903144edp.148.1591639788205;
        Mon, 08 Jun 2020 11:09:48 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id ok21sm10515029ejb.82.2020.06.08.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:09:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, xiaoguang.wang@linux.alibaba.com
Subject: [PATCH 0/4] remove work.func
Date:   Mon,  8 Jun 2020 21:08:16 +0300
Message-Id: <cover.1591637070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As discussed, removing ->func from io_wq_work and moving
it into io-wq.

Pavel Begunkov (4):
  io_uring: don't derive close state from ->func
  io_uring: remove custom ->func handlers
  io_uring: don't arm a timeout through work.func
  io_wq: add per-wq work handler instead of per work

 fs/io-wq.c    |  10 ++-
 fs/io-wq.h    |   7 +-
 fs/io_uring.c | 221 +++++++++++++++-----------------------------------
 3 files changed, 74 insertions(+), 164 deletions(-)

-- 
2.24.0

