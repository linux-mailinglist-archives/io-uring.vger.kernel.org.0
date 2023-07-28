Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6103976721D
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjG1Qmq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjG1Qmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:42 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6912C
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:41 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7748ca56133so22687239f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562560; x=1691167360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfXIoWZOPMTUuZ51sHKPtDeshXixERaT1oNJnhO0ex0=;
        b=It3a8uIRBWBxtFna+HZJERO/3/0f2r4nyuR/E+sjXiG9TQGNLD0TfIGecOO32rhhu/
         nQ0XUBk8WmxIZY4qJQaI/VevgEsW/CwC4nLk8hoIU8YxvQl3AwGLhkgFzwIi4tKY+8su
         Oyl/hwKdVV/FUPnGD472zaZePQjaJGgeRkhyHLD/8mRuCDBX3cOvi9Y040oyMhHLRBrG
         RlhjY65j/7wF/feBfAD43VQKB3zPIAz3pDn5QXxTz+Cy61LdylA3/pmWHZ7uMGveK7ci
         pMkLlV0TBFxQdPM9H7ZjTdWt8u9Brkuy2GgG3dCpn0Vy2XHOmVX/Rz+RtnHNAt8sddmh
         1lJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562560; x=1691167360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfXIoWZOPMTUuZ51sHKPtDeshXixERaT1oNJnhO0ex0=;
        b=YGIThXoi2Y3YoCLcbTWO2k3JQCPf0mLIuQD3Q+fm2RHxR+DWzPTxiyp8Vzt0BcvQCb
         rWc6i+4xarj409AsBtCRMHSnJAs18x4sOnMVb/Ma0I80TSBErd5rwLFjcvO5YeajfaOp
         t3l7IDSoCDan6gpyIjwXQtldv5K2b9x51jJrzTE+/D+Feh9GjrOeT7vxWcaKrKvLWnIC
         wwi43IPhEBQXe7L33lm8kLEs9ujlHiC61vCNIF7MhCTiYEKY0ejQyWfAwpkViFxThf3Z
         FKh2MblimTFfxvtQYCEeCU/GXzY2nfHJ0Nvz8aSgSlJR6cq7zI/3ENQctromdH1JAGML
         0GtQ==
X-Gm-Message-State: ABy/qLYPVuf8rmF88Twdf9RPCJERWLYqpn/aThnF3v8T3WM9GbfiGMq1
        aKuXoxIVdLsNMpiwTlK5s3K7ltCIEkj9u15AJeU=
X-Google-Smtp-Source: APBJJlEzCb2GsmXDbZPVVhgPc8nV4zB6aeu8Qzv2AhRcV6ADL3MsZjBM2Km9lPqN+1pk6fm737AOnQ==
X-Received: by 2002:a05:6602:14ce:b0:787:16ec:2699 with SMTP id b14-20020a05660214ce00b0078716ec2699mr113690iow.2.1690562560150;
        Fri, 28 Jul 2023 09:42:40 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/12] futex: Clarify FUTEX2 flags
Date:   Fri, 28 Jul 2023 10:42:24 -0600
Message-Id: <20230728164235.1318118-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

sys_futex_waitv() is part of the futex2 series (the first and only so
far) of syscalls and has a flags field per futex (as opposed to flags
being encoded in the futex op).

This new flags field has a new namespace, which unfortunately isn't
super explicit. Notably it currently takes FUTEX_32 and
FUTEX_PRIVATE_FLAG.

Introduce the FUTEX2 namespace to clarify this

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/futex.h | 16 +++++++++++++---
 kernel/futex/syscalls.c    |  7 +++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index 71a5df8d2689..0c5abb6aa8f8 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -44,10 +44,20 @@
 					 FUTEX_PRIVATE_FLAG)
 
 /*
- * Flags to specify the bit length of the futex word for futex2 syscalls.
- * Currently, only 32 is supported.
+ * Flags for futex2 syscalls.
  */
-#define FUTEX_32		2
+			/*	0x00 */
+			/*	0x01 */
+#define FUTEX2_32		0x02
+			/*	0x04 */
+			/*	0x08 */
+			/*	0x10 */
+			/*	0x20 */
+			/*	0x40 */
+#define FUTEX2_PRIVATE		FUTEX_PRIVATE_FLAG
+
+/* do not use */
+#define FUTEX_32		FUTEX2_32 /* historical accident :-( */
 
 /*
  * Max numbers of elements in a futex_waitv array
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index a8074079b09e..42b6c2fac7db 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -183,8 +183,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-/* Mask of available flags for each futex in futex_waitv list */
-#define FUTEXV_WAITER_MASK (FUTEX_32 | FUTEX_PRIVATE_FLAG)
+#define FUTEX2_MASK (FUTEX2_32 | FUTEX2_PRIVATE)
 
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
@@ -205,10 +204,10 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		if (copy_from_user(&aux, &uwaitv[i], sizeof(aux)))
 			return -EFAULT;
 
-		if ((aux.flags & ~FUTEXV_WAITER_MASK) || aux.__reserved)
+		if ((aux.flags & ~FUTEX2_MASK) || aux.__reserved)
 			return -EINVAL;
 
-		if (!(aux.flags & FUTEX_32))
+		if (!(aux.flags & FUTEX2_32))
 			return -EINVAL;
 
 		futexv[i].w.flags = aux.flags;
-- 
2.40.1

