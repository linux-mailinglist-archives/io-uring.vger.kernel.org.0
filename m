Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C572F82B0
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbhAORmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbhAORmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:15 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA86C0613C1
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k10so8127874wmi.3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KFjTYLo8zZ68j4ZdTc7bnrJIU6oCYRv6tQc1PF4jRs=;
        b=aRvyGQQ6guxOUpNxhGIHjY9WaQszvXHV0A1EA15CiExJxD3yA/tPw3Z/wlkJ0J8onU
         bZBfnWn5TqDTxJmAGUz5r9Lh7WdiJCi0afnBYaYhmXrzjUn9lOEQtMJ56Ary7Q/eQIPt
         VOadtfqEUjS2kwPECq997s1hYy+c21ZoTtPRz0oj8a51TjdxWk9ALwpNbqB+3RQqz4YZ
         Ei/Wf36xqB+gDy28sV7XHJTwHFumAjmhgdYuy9stDkhIrul7LtdQdrhukrX7j1Wjkm+M
         hAEztfqcSLLU+tWaul16tnk5Gzz87sKtk465XNj+AIArFQKn2Zw1WLoxyMsEce7KWqeF
         xWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KFjTYLo8zZ68j4ZdTc7bnrJIU6oCYRv6tQc1PF4jRs=;
        b=Q3maHe+Wt2NVV80k3sJA411xoeTnLubsO0AS7P1pi7cxrbRfaqWgSrNWgwkstjU5UW
         P0Iqy1njTzhN0FNTxAJmTMWIZyKk0p0kcQ8I6xyO9bZE0+wTICoJByOF8RdIiBJxCz9g
         d0boOR8OWsj8S9d52wauP/bwpVvz0qivZzXo+22A/mwpxe9WfvW0qLs0oLOPntriKnpe
         bhSXWhTORcdGSU4S9xT6OlO3yK7C4nkYKY0mNmniRK38zqiD8a2aVV5Ne6ELdVyBCPr9
         gP7bzUpmNAyVJDpi3qxvc0HK09aNidJLx5EK08RC+YIs7l/8itAdiYyxYKISv3ahpMTw
         rMyg==
X-Gm-Message-State: AOAM533fVc7gfBCL1WrAnz8cSKq4o3q2ZurWaEQXH6U/P7hGNPCJl4vj
        ryrMlZeE14n/Kto//zFU41w=
X-Google-Smtp-Source: ABdhPJzHeL8hr8ukuxrEowgdL+s4j+RnIeq2h6fBUQN0D+ckJN7Xy27wL5AUe6LGuRiyofYJIVBe1Q==
X-Received: by 2002:a1c:5459:: with SMTP id p25mr9353503wmi.19.1610732494265;
        Fri, 15 Jan 2021 09:41:34 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 0/9] Bijan's rsrc generalisation + prep parts
Date:   Fri, 15 Jan 2021 17:37:43 +0000
Message-Id: <cover.1610729502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I guess we can agree that generic rsrc handling is a good thing to have,
even if we have only files at the moment. This consists of related
patches from the Bijan's longer series, doesn't include sharing and
buffer bits. I suggest to merge it first. It's approx half of the all
changes.

Based on 5.12 with a few pathes from 5.11 cherry-pick to reduce merge
conflicts, because of merging/etc. may wait for a week or so for the
next rc before potentially being merged. This also addressed tricky
merge conflicts where it was applying and compiling well but still
buggy.

Bijan, for the changed patches I also dropped your signed-off, so
please reply if you're happy with the new versions so we can
add it back. There are change logs (e.g. [did so]) in commit messages
of those.

Mapping to the original v5 series:
1-5/9 (1-5/13 originally), mostly unchanged
6/9 -- my own prep
7/9 (7/13 originally), only file part
8/9 (10/13 originally), only file part
9/9 (11/13 before), unchanged

Bijan Mottahedeh (8):
  io_uring: rename file related variables to rsrc
  io_uring: generalize io_queue_rsrc_removal
  io_uring: separate ref_list from fixed_rsrc_data
  io_uring: add rsrc_ref locking routines
  io_uring: split alloc_fixed_file_ref_node
  io_uring: create common fixed_rsrc_ref_node handling routines
  io_uring: create common fixed_rsrc_data allocation routines
  io_uring: make percpu_ref_release names consistent

Pavel Begunkov (1):
  io_uring: split ref_node alloc and init

 fs/io_uring.c                 | 355 ++++++++++++++++++++--------------
 include/uapi/linux/io_uring.h |   7 +
 2 files changed, 216 insertions(+), 146 deletions(-)

-- 
2.24.0

