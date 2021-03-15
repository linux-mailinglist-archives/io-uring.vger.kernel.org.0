Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EFA33C339
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhCORDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhCORCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6B8C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=pbRJiWFuS2RkQdHkOSl/vwPblM4EoacKGYc2ePHKxbk=; b=UbdrFOigf1BJ5ynSCFoBF4GMHj
        dP19qhl+Z4xD8Q5Wg/TX1cVwotyWKyfRDxwI5ZgN0B3Ql2WWttgGqUSKrTBXwd+mr0kfJKHqDbfD1
        2C+Al4xjGcnR6MQ3QQ08Byw3CHAP6rnqMmpK+YnUKb2NCDKjBdPUBnQrtuTDQ8sz/YRol+9H1vu+J
        58H4V0sujPG0YQ1Fqsl8gMyIzJzUD2bekCUi+A2TLln7uC04yOgzDJOezERER/oU708OH0PjxXehW
        rQSOTDus3CZQT1c5tShlHcR1Cfv31gE34hVtWj1UaXqBbKvuLEQt1mEyaytm2SJMmYlkQgbvriz32
        YBQyipoXyDaCzdcIzD4Cv2ue1u5BeaX95g097JDlr2KrZ5diXSlHnqhu0UPm5+cY6wn/61Gj6yqN1
        8c4hUj5cIamYebnWi7hNRqhXaUK8+Q7rHSDw7GOneBtK6QL0XRgTnNerjnct4OujijuDABIGM8EtC
        iHhEc/cSPDIlY60GOaQpnIU4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbd-00056l-DG; Mon, 15 Mar 2021 17:02:13 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 02/10] io_uring: io_sq_thread() no longer needs to reset current->pf_io_worker
Date:   Mon, 15 Mar 2021 18:01:40 +0100
Message-Id: <f561ead97a51f820a7b776d7213e2834ec027002.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
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
index f048c42d8b8f..059bf8b9eb72 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6695,7 +6695,6 @@ static int io_sq_thread(void *data)
 
 	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-	current->pf_io_worker = NULL;
 
 	if (sqd->sq_cpu != -1)
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-- 
2.25.1

