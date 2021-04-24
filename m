Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F036A395
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhDXX1W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhDXX1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8165EC061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=SxWhzli2V8cUMoSqEcaz3O5Fc3f6giYFtVvBHknD29w=; b=w70UPW077XdBTjiHna+ns6GsE2
        8eMYepcNYZgAlbqcS9Y4F/+GsyDmCAqw95Rp9uBla0fvYC8Gtg+xdX/8UqrPHCt4FWofQNUEuiUBq
        ZNmBQfA6eevNeziWT032A7Vxme7zwoimhN5L4D+Mg80KC8X+SESI4ULT0AKuKQRAhnUb8/6EXTLlu
        JEu95am6Ks7O6Qxwc3wLDtD1NcF2fUPL7zcf68W4EOdwjMhSx2xoqAY+qNWvE9HrIUrwRW+vCNrne
        vRvUkUsMVJE8HnNVNeWshRF4l0TvHFVsqNAP7Ss8oyICXx6gagNFi1u4kEKfiIo+hRhLsVY9QLuMc
        xrnSJw1d1Ny9lwCCNlLDFzjhFoD31h6/AxFRxOs8usFwLpldKAAVGos5M3hNMCIhTgRWebW/pPW9f
        JvI8/5J2B4wr+dTuTvrxPyvsUQTcVqFS6cVRtCVg0lPKjZNg3Wtrv6LADHBbn4rrKRKu+Hs98Xo3A
        t9EPEo2Dba/RyHUmr9vK6QmJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfd-0007WN-L9; Sat, 24 Apr 2021 23:26:41 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 2/6] io_uring: io_sq_thread() no longer needs to reset current->pf_io_worker
Date:   Sun, 25 Apr 2021 01:26:04 +0200
Message-Id: <431348b3cd0674838253036cbfd78ea0a0d5c9ab.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619306115.git.metze@samba.org>
References: <cover.1619306115.git.metze@samba.org>
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
index 58f12bfbfb44..234c4b8a015c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6786,7 +6786,6 @@ static int io_sq_thread(void *data)
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-	current->pf_io_worker = NULL;
 
 	if (sqd->sq_cpu != -1)
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-- 
2.25.1

