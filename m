Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583FB3492CB
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCYNMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCYNM0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:26 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4FFC0613D7
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:25 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1148755wmi.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DSwDKdrpGPAviy10BtXl3mIo5IDs0GVyu9tUaxjk8II=;
        b=vCCD4nyHNs36jhOfsKF+nR9qM2pjD93CQq8QzS/OSvjNrBKq91z55QGTxUEAtui2p4
         aXt+ldR2bUOfiMHfHebEtYxzPEiouBmVTrwMR36KHFuFGgsxWurEFBXv4Au6ZK4vjrYA
         ALlDLAiU7MEHwhHoV9QEZVOo1OAAKHxWaimeIwkxVp4HuY95UHZogwZYxGzMRIaK+BHC
         1Aaa+dHFfr9cnEHhceJjpQqLfM2msNYJM400A25/Zx5TG3fJbPyBqHxtwLP0WBs4OaBS
         2ujhnDy56XnbX+3TBjLIaF9aTGbRbbbRPeR5g5WDXQZSL9U8m1kHNDhUcVQBE3u++arj
         8JIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DSwDKdrpGPAviy10BtXl3mIo5IDs0GVyu9tUaxjk8II=;
        b=RVm3AUxDUpTFl79MT1QgPVwZgNR2/MNRVUW+BYin2gspnDR8NdgM3EuWA1OsduG/qi
         q+aVsJDs/ahihZEApko6WbE6MiRrJbBIvjAvx8d/TbllHZwinI6mMVgQ8/cQIsPXFkTt
         822EC06lO4g9Uy7Htft56vUOqrUTPcFnDdzPcYLd29M0h8owAcCo+p0U/t+3ijeNuW13
         RsMGh6TKDSOpJ/EAo4/IT8l5X4YQJkva/o61TLnuJGhMkspKYikZku1cdWW+6xfuY52I
         Ge16ctK2taEZ2LaSYnpyOseF4tTZHxhu1nh55VbOKnbMC9fjbv7QZWVi3/N7iI7NJ6ru
         JruQ==
X-Gm-Message-State: AOAM5334slZew01vhSquxx2Go9iozGT5U7PI86nCYRad40EKxzamIdGZ
        NPD7L8GFUdGeNfCJRrKhehSpBg3fWJ+rgQ==
X-Google-Smtp-Source: ABdhPJycrzgWzyakjW6nvm8pPpIBF9lp52I40XcWJGTzGdKJ15ko+rlh0wp84TTDYAHxBimD+tBZmw==
X-Received: by 2002:a05:600c:b57:: with SMTP id k23mr7735056wmr.145.1616677943964;
        Thu, 25 Mar 2021 06:12:23 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 09/17] io_uring: remove useless is_dying check on quiesce
Date:   Thu, 25 Mar 2021 13:07:58 +0000
Message-Id: <11c2a6b222cc3bae50e4643edebd45a4fc9737d3.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

rsrc_data refs should always be valid for potential submitters,
io_rsrc_ref_quiesce() restores it before unlocking, so
percpu_ref_is_dying() check in io_sqe_files_unregister() does nothing
and misleading. Concurrent quiesce is prevented with
struct io_rsrc_data::quiesce.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9da4a1981560..a57fe91f06d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7005,6 +7005,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 {
 	int ret;
 
+	/* As we may drop ->uring_lock, other task may have started quiesce */
 	if (data->quiesce)
 		return -ENXIO;
 
@@ -7067,12 +7068,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	unsigned nr_tables, i;
 	int ret;
 
-	/*
-	 * percpu_ref_is_dying() is to stop parallel files unregister
-	 * Since we possibly drop uring lock later in this function to
-	 * run task work.
-	 */
-	if (!data || percpu_ref_is_dying(&data->refs))
+	if (!data)
 		return -ENXIO;
 	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
-- 
2.24.0

