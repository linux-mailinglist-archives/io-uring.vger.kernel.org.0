Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B373B5017
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFZUng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUng (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC536C061574
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g198so551727wme.5
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKejrdZnoKRm6ptEkOHSv87zzjD5cnGVqiKa2o8W6yQ=;
        b=DT5ldnixj9FRUnBDJw5nvmhZFnbS1WX/EUU8DpBnNw3MsagMmGGVMTsGQXzOYXIdpU
         Ul/1RDHHm4boQOrsi8hMA1ujK3WGkkpsAABjEXq7S0RIRJmmZFMrG07u62lQS0kNq228
         ClLrgIkMAfTX9PN2Ir7p/FfyNqMI+flof2qV9JmlcEkZIBZy0zWYmcH4teGu8ozc0IE5
         8CZxzJ9cBXdoNeewFvQYvc92kjaXAD5n0eHDuXWoz54uAloId9nGfBr7MEWHSAMPDX71
         y3hlA7nBTJSk0E9FQv4Uc1TjaYftAJDKFdjhQRLnJC0mwz6e+d75pY2Vk8xW6JF3sV0z
         kOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKejrdZnoKRm6ptEkOHSv87zzjD5cnGVqiKa2o8W6yQ=;
        b=tHqRjelNzfaAn2T6pafRLPo6bicqZkyelAgpKHSemGoKQXXm+I55EislpKYHCvN046
         iVHdkVKqYgjvy/P+2syienT2TJlF7IlFAw1PzWqYGA6IJ+AWkvNgOxSFM8/VIgYy6jOR
         0Xmcql8BrUg16Iytk2QvRE1341b4LuZnVDwu9Ukeeih8vDOTteTbO9rRQf81rdH9y4kO
         MPHrsK8rGv2PifJ7SIWOovhmGk4MyO5NqVKcyxCp/ubdNdPeyrCseEckKZ1r42rgcLK7
         1lV99R1rP+yJ79Z/XvYUNEkRsUHPJzjSZWIWUu4OJWB+5XwQNBG/+9NgGGoEcFUNj+D+
         Te5g==
X-Gm-Message-State: AOAM531JoHw6yfDEZx8jsyrWVZNtiX70qPqtWqp7IdU5bFIcJh/kVabF
        PweFbja77yrR9X94GDF4dGoEbCLDOWFw1g==
X-Google-Smtp-Source: ABdhPJygI3rZt5zjl6iYfQewbleNY1K6BkUHxacQb22pJF1sgiLsEOgFPkk0JCTi+E6vkf0phFobmg==
X-Received: by 2002:a1c:23d8:: with SMTP id j207mr17976749wmj.56.1624740071448;
        Sat, 26 Jun 2021 13:41:11 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/6] small for-next optimisations
Date:   Sat, 26 Jun 2021 21:40:43 +0100
Message-Id: <cover.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Another pack of small randomly noticed optimisations with no
particular theme.

Pavel Begunkov (6):
  io_uring: refactor io_arm_poll_handler()
  io_uring: mainstream sqpoll task_work running
  io_uring: remove not needed PF_EXITING check
  io_uring: optimise hot path restricted checks
  io_uring: refactor io_submit_flush_completions
  io_uring: pre-initialise some of req fields

 fs/io_uring.c | 91 ++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 45 deletions(-)

-- 
2.32.0

