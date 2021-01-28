Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAFC307E58
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhA1Spy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 13:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhA1Snz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 13:43:55 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111F5C061574
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 10:43:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z6so6403603wrq.10
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 10:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UeFVTCDJ3Ta2Yp4qVDUhE2CcARPr3visx2OeFXrrTtQ=;
        b=SuyepYb2Muhal+IRwibrxGbmFFDGSVuHwEO7WnYoCJ/CPWNYHOkWZ9w4sXqpS3dkYi
         AcXxuGtpkVk1CbJOywkSSmbW+YOQEkB6WsJEJeqwChVN7Rv7bDepi1sr1TyP1ZA5gx7l
         /usIO9t9CrfnuxoCEuHNaDqMGvk3smDM+q7o3M+eQ/kH2KjnWiNyxD4540RgCCALqlkh
         nuyxFBF4e3klBcTI7xFlAHW3GhVJ0Q+lXSxnBzEeAjyUivB5iMfQLtvQAK6RmtskkNO5
         Xt+mlKXD+GiS4BwoxgIXoZFjBf1Y4hKk3J+cZS0uSU+UDtcTpdXrybzbukBVIm5UsIUf
         YExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UeFVTCDJ3Ta2Yp4qVDUhE2CcARPr3visx2OeFXrrTtQ=;
        b=D8zR2B6Edh+Iv4ajPf0mPFMQDWrQRcSMh705NNqhpUqgORjHPHpEG1OV0jehLYGwxY
         AUfP3D+iBu89odsB9/H9jzyzpGKmggLvIXHfK8R+4wHGkc/KXC8L7jz8bHs5z79zPpnP
         4xhavPxL/EuJijBhYPqSZ41Kmwy0tSp5xQT4tbt8BnqX37yeyq+T6I8oetnqBUmGxolA
         thythL+vikWDuFdK1TYqpAHK4Bq8hdJ6LEX8bHRufunCqzxxAnRTPbgByhIA0eTv5mdd
         4D4VPKxVcwyKCgMbXdzzxBPqyeDhPywTrK1ydehL4C317D+P3L2YrPyzqdRuBR9Apep6
         /Jjg==
X-Gm-Message-State: AOAM530JdzcxrOsZ4ATNsovuCCPzCKFrqdunE9VcjoWTBkQcZ9VhzwAL
        sqi39QdJ8hvmfs+lhSQJZ1w=
X-Google-Smtp-Source: ABdhPJytdkpUN5iciXOzSwqXULk4OJPhdi9VA7MWGklCEIRMwow1/1k/BxznwvBm9lEZNhVpJ0GlLQ==
X-Received: by 2002:a05:6000:1105:: with SMTP id z5mr482863wrw.15.1611859393842;
        Thu, 28 Jan 2021 10:43:13 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id y18sm7916386wrt.19.2021.01.28.10.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:43:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] io_uring-file req cancel syzbot reports
Date:   Thu, 28 Jan 2021 18:39:23 +0000
Message-Id: <cover.1611859042.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixes for two latest syzbot reports

Pavel Begunkov (2):
  io_uring: fix list corruption for splice file_get
  io_uring: fix sqo ownership false positive warning

 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.24.0

