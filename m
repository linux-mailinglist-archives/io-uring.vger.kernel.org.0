Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43D6342940
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCTABH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCTAA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:00:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26182C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=lddMzf2gqLTX53uyBkE5E+C0kS8qbzaBVKtm1wVVUPM=; b=QLzePT38toY5rWwhoF3B80R7Nz
        3j6hgCx2LTA2WvyRm/NcayBAIiTCGVizEAZf59MLd+1elhA3FDfBE3LId1ke8wcyhr5AIuZVpjTcF
        UGu/5S9a8CBIMxoIlUNtOWQiB61sNWEpDNekXdXORrj4aCOBtjrktHZktKUZiN3Hhw20RL1ox2CZK
        cBUkBbf7f7mAALycUTi/XlCaw/qmsFih1M39wtCxE250H/Cto9EDjCHCN5kmW/S3emzVZ8ufyfcrT
        EYPlZR1OxrZknAEx36acRErkA0pKvF56E8yN1apkIkJGm9FZzio9q15FMV+odE/Wsky/uRGBEjen4
        FUK6gMfSi17qLieq1FNINcBkwB9w9Md+nipIoN/9RwOu7s/xhUbnX1rqTRaECVfjFfuUuD//r7vV3
        hZwV47l380KyOwdo/41ImyNfdK8rIrXcDlNhkVkf4FrgOawKjC29WYWv0EQJa0Z6zVdyTC0W+z6jC
        B1ya5RwCWsYw2WbOOXvCWUez;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP32-0007Wj-7K; Sat, 20 Mar 2021 00:00:56 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 2/5] io_uring: io_sq_thread() no longer needs to reset current->pf_io_worker
Date:   Sat, 20 Mar 2021 01:00:28 +0100
Message-Id: <4933cd2a2b2e99cdbdce3310b869563a46bcf922.1616197787.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1616197787.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org> <cover.1616197787.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done by create_io_thread() now.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea2d3e120555..cf46b890a36f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6726,7 +6726,6 @@ static int io_sq_thread(void *data)
 
 	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-	current->pf_io_worker = NULL;
 
 	if (sqd->sq_cpu != -1)
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-- 
2.25.1

