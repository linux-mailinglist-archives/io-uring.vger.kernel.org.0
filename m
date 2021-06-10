Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF23A2F74
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFJPj4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 11:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhFJPj4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 11:39:56 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7E7C061760
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 08:37:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so6695660wmq.5
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 08:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOvhVRXq3Arm1hQbg/btXXQ8BTXjRmdQXn9vVP7doDo=;
        b=MdjRUvU0CrTSD4rFVIlrJibAsx1jJVjR2LS3W/Z+267UVLazAe1YjDWZC2p+082TgW
         +czb1vSG9CFonucNrqm0sptI6reALxxykH10AJ2xKFJWn9V4Pjr4DnMNK8+e3dDwutrs
         HdZf/l+C336cFEYxRoJpr3A1DhQm/GZYlBx78+fO8yvBXAKSGERjJJNZYgRmIkvzh8Ho
         8kbiBu4g5hMC4oS4vltBmpx9czoMjBNc2+58jxLYJyHpTXglMyspUT9VsSbbvdVGzLlt
         03rqk5dvQMZUJ/JApt4NrdkDcwPbwIx4AMfFJJUUpdAD7dAU4dXLtH+9riCReCYChx/h
         cwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOvhVRXq3Arm1hQbg/btXXQ8BTXjRmdQXn9vVP7doDo=;
        b=lT7CLorA4k+1lwSdeAqucgl511PjEGiBpfc9zecJJNthAG1+1Q0JyDlOdB6dYvxKy9
         O4Qph3u+cauIuGMtI5i4xU7IKMutc19lSuwZ5SaJyz8J1M5LnpLW0OVCmzUkYiaaoKOA
         4IORWqDBTBL0cC1cjAmRQ8S82eQzpR889CiUlW9UBHxgQUBESlioPmM6Wf6W7t1wmj9e
         tJa+j42pU1wgSgUzFaTXgwncJfggZxXocO+4THqDuOF5xv7lmMJCY5JJFOP5YHlyBlAI
         I11mJyDGL1gbCkWpPm9BIy6aIGAQUi5vBlIJB5paBzrzn6zvxUwV9IWTBz+4a7+ReDD3
         0oEQ==
X-Gm-Message-State: AOAM533Lq6tX7FK36yQ22RXTDw/LwPVIYQIKhYOekUwPgQu3lEhAs4KC
        BLQWJAWyrAHQMf0p5UDTYgU=
X-Google-Smtp-Source: ABdhPJw3ZrDf1FHsKbNv5jQt3joziIyWdGuSAImU5xDHqJd/5Uq/otNr84+3/QLDbHIffE0vc6xPGw==
X-Received: by 2002:a05:600c:3586:: with SMTP id p6mr5911070wmq.28.1623339478406;
        Thu, 10 Jun 2021 08:37:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id f184sm2388825wmf.38.2021.06.10.08.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:37:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 0/2] ABI change for registration/tagging
Date:   Thu, 10 Jun 2021 16:37:36 +0100
Message-Id: <cover.1623339162.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For more details see 1/2. The change is not as horrid as it may
look, just passing rsrc type not in struct but as arguments
deffered from IORING_REGISTER_*.

I do think it's a better API and might save us from putting
extra bits in the future. Suggestions are welcome.

Pavel Begunkov (2):
  io_uring: change registration/upd/rsrc tagging ABI
  io_uring: add feature flag for rsrc tags

 fs/io_uring.c                 | 42 ++++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h | 19 ++++++++--------
 2 files changed, 39 insertions(+), 22 deletions(-)

-- 
2.31.1

