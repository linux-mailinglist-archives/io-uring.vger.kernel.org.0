Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B05531F268
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 23:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBRWhh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 17:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBRWhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 17:37:31 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CF2C061756
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:50 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id i7so3552657wmb.0
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pr5XRSzOdHJDEvbk/ryN4KYOnBMyJU7DoyMeJwAAACk=;
        b=qzmn5jPFnA1CLvZ3+ETr5SCCte9v2okD4RMcPw4C5pIqrjIfGySfNSZP7XlLQbnVhw
         ETvAGAWTMX3TdhGJEK4t6XnphHvcT+ekEWjO3VR4rOOjPyExiocBH2bamUBjndjUrHJ8
         glbOJiq2cSTYtF3WqazaksHpn4UrCZR72fKcRP6ZcsDGnBWrncCp0yJPAC+/hsDL7oVQ
         L8VZ+Ua0ObAc0OHmeqy7CW2H+DZjhEjc4dGryIQg0My87HzTsARTihN0hVXsNwt/PDSj
         EBkdooOhxDIC3IJTmkW8SQMvpbOIAWXC1MLvMGPUe/TdviS8OGgTP+IWbfK1ggaVW7C7
         NJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pr5XRSzOdHJDEvbk/ryN4KYOnBMyJU7DoyMeJwAAACk=;
        b=Gn3DGpfCZ10VAjuqUWgA7wRzDNSjcW1oyUNSslNmRjzPg8/B/xS1SPPH78bBf5PI1g
         OeCIV6nYBuiTBVj+UAfjbD1kIqzBWgjVgb4Kzd31QD0cpqYA5aTpBAhWTX+Zd0oXASNc
         whqbarLG6LTQf1viRmkvQDmOMACjvzZidYBWkGxvZhTL0jm10yAL46RvcMDOdrwrqjKV
         l7PFvSk+Z92RMTMU4TGKWgQlPGk+38GKkphZw2NTBpH9nztd6DD5T6+r2uLClxFyDwow
         6au+JlTFrjinA0q/fmOgEq3v1CJiHzc3AKv86nqmNj9gBZs+cE9hhbQP7soHC7QBH8Wb
         qMkA==
X-Gm-Message-State: AOAM531CUdNKLZVQUnnpJ7zujTbLtT9rjX+Hpkpn2mR7hj3tgVAAXvmA
        xwuDvYoMCytui9I4bIYEVHbGtiHVrZGMKg==
X-Google-Smtp-Source: ABdhPJz615Z55Rg/V3l768segSGOOFcVba3Kt0Rl6XqV1WoHDr4HtmdqBobXlZC8YKg0R+ztzEUaYQ==
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr5588580wmq.28.1613687809466;
        Thu, 18 Feb 2021 14:36:49 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id w13sm9807439wrt.49.2021.02.18.14.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 14:36:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] fix nested uring_lock
Date:   Thu, 18 Feb 2021 22:32:50 +0000
Message-Id: <cover.1613687339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/3 is for backporting, two others are more churny, but do it right,
including trying to punt it to the original task instead of fallback,
aka io-wq manager.

Pavel Begunkov (3):
  io_uring: don't take uring_lock during iowq cancel
  io_uring: fail io-wq submission from a task_work
  io_uring: avoid taking ctx refs for task-cancel

 fs/io_uring.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

-- 
2.24.0

