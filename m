Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8F333C343
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhCORDq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbhCORDL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:03:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BC1C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=kEoM72lkVC+PdYYkSYVqbtsUXWlrGgp7K51RM0FtiT0=; b=mrvE1rVvu40pokRGzOS9D1nKZl
        vlEItymnY4LfPMRdzHvdS0xijw/uXZ7xB1dn8CUd/RA8s0kfpqkyUFyxhQokbykAYHzOmTvBOxfTw
        GhORORd8ZexD2HPIc/bZpVfbGobt0KiMhimgb/g2B3fsqeZKuREay1AUFCeikDEflSDKWWaSeWHG8
        riT+8f/BG9k24q5hH/0VTjBCPdfL9uQOfpjT8tGrPJx98Sp3kKoEVaKTmvN2vpleMacAKOUvqyh89
        bfIpgrW8VY4wQ5ykuG5EtO+9PjSym+1k80HdHtTMr2bKZViewrpyTp0KuZWpqmFivNwzrcGsX0fR0
        5A0VAHw0oH7ozkGfQ56UHGS8V8T7FUT7X5PHzw1ppG0LKcGaiee55Wmc8w7reSMR/l09+cgoXXNVJ
        sibRCssw0ksfW9/VF5Eeq37b9Ps88F7N8w3KxtC2MczTObV9IQS9sIqK2bU4s0t0TjMNAd03BjRXL
        XzW/rxr3gSE98VivHbJ1CwtS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqcW-00057r-VJ; Mon, 15 Mar 2021 17:03:09 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 10/10] fs/proc: make use of io_wq_worker_comm() for PF_IO_WORKER threads
Date:   Mon, 15 Mar 2021 18:01:48 +0100
Message-Id: <980f0fcd1bfad216e288a92ecc134450bdb210dc.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/proc/array.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bb87e4d89cd8..e1d40d124385 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -92,6 +92,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include "../io-wq.h"
 
 #include <asm/processor.h>
 #include "internal.h"
@@ -105,6 +106,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
+	else if (p->flags & PF_IO_WORKER)
+		io_wq_worker_comm(tcomm, sizeof(tcomm), p);
 	else
 		__get_task_comm(tcomm, sizeof(tcomm), p);
 
-- 
2.25.1

