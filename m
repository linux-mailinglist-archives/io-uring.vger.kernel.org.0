Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398C03042A8
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406363AbhAZPcf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 10:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406248AbhAZPca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 10:32:30 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29532C061A31
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:32:15 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gx5so23514179ejb.7
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bsoe97mkX7LyKZhx8HKdtJSI7rZvgXsFVOMAd7d8wEQ=;
        b=KqAc6I+XTNa01I883kwsZleK8LBZe7wRbphaHRTbfiPljkYkXYGFAjB2Ag1q6aOylO
         +U6Ifj3i5Qbi9fjp1Kv3hRCQDkqeLtOFeeJyGbcKZhwgfzUEPaTkXWjqv7TbDTYmrQWA
         NTFBXL/O/T51yen5oEUGAnI28HiZL2wCB+b07BG67satrNSFJ99up9fRL2EQuyJ4O8l1
         rbZGuUF9XkSXAyduI4s0OygV4XvPWcwozE/FwPbEEI3er6tyADhZF2Hk0cfzDIhQ7wFj
         AgeVhgq8mBEiYU7y0A6wvewkZiiZv7QCT8fioO+hukH9H/1dtWI9UaB9WVoTUH9NyQx9
         fIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bsoe97mkX7LyKZhx8HKdtJSI7rZvgXsFVOMAd7d8wEQ=;
        b=S1ExztDAu82kNjhaH0fWrxWQfY8K+bXElG+pZo+9Sd0cJ6xm3UjWLUbFgXRxaulVZt
         JgWTBph5Wdyl0uj/YAmSEEKPr6niBaSouaXIr59Jb+IGjhzTHCR40dD7EoD0e0LWSPC/
         y28uY0F8zVTHqisuCMywZLdt53T1lN2PcQfMCYxZN9Z1KhCxPSBNlPqAXgmkUewUjpww
         nE6x4rTm1NFdLK6zYpUq4Ynm5OD2nIuPQnaN4/VIp3KF/bOOBb+xY6phBl9BRsS/wkc5
         BVqYFn+BSAxboq0Hpj8qe2wxh7G44T2P9zo5gRRcrJvTdFbjEiRIpvNFIdYufKuO4O3z
         Gcag==
X-Gm-Message-State: AOAM532dgwGUSu2lbNT6zmdFoDPjWzAahWB6S5UhoE3vqRkn3ccAXF4+
        v1L0H9TOcmIL7K8FZvx7C8U=
X-Google-Smtp-Source: ABdhPJwMcQlZbj7A6NvvQQOGuIp2ucUMwzvgJlSkpV8LlfUBkoBFxhc0XOq9o+o9zgXV0sNwlKT/oA==
X-Received: by 2002:a17:906:3f89:: with SMTP id b9mr3667856ejj.204.1611675133979;
        Tue, 26 Jan 2021 07:32:13 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id k22sm12888978edv.33.2021.01.26.07.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 07:32:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.11 0/2] syzbot fixes
Date:   Tue, 26 Jan 2021 15:28:25 +0000
Message-Id: <cover.1611674535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2/2 is a reincarnated issue found by syzbot, fixed by cancel-all-reqs
patches before.

Pavel Begunkov (2):
  io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
  io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE

 fs/io_uring.c | 52 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

-- 
2.24.0

