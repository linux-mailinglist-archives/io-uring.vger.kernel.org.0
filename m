Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7E50DCD7
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 11:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiDYJkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 05:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbiDYJjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 05:39:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E74C32
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:31 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23OMWLL5001304
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fx5xAAxerqcTWNxWVEFn5ZE2X7yhIYvL63VK+uP9QYA=;
 b=cRF9JWh23lRfENez7Mv5CaQf9d4x0e5xD59VBGRDpYStP9xnRxQVYnhMbWN+EpWpcTPM
 VDyn18ymv7iRYnFyb57RA7yL4YjfWqYT4e/lgRPdphW7paZv0LG8c5ftVb9YNZw3iUc0
 awFrSKKkBxzQYDvSsR8BfcRsb3u1Hs/X5I8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmcsgs52w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:30 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 02:36:29 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 9D48780E099F; Mon, 25 Apr 2022 02:36:21 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/3] io_uring: add io_uring_get_opcode
Date:   Mon, 25 Apr 2022 02:36:11 -0700
Message-ID: <20220425093613.669493-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425093613.669493-1-dylany@fb.com>
References: <20220425093613.669493-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6JT4HMJ9glOBvWdFsKXwHrwbFEleJOFC
X-Proofpoint-ORIG-GUID: 6JT4HMJ9glOBvWdFsKXwHrwbFEleJOFC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_06,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In some debug scenarios it is useful to have the text representation of
the opcode. Add this function in preparation.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c            | 91 ++++++++++++++++++++++++++++++++++++++++
 include/linux/io_uring.h |  5 +++
 2 files changed, 96 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e57d47a23682..326695f74b93 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1255,6 +1255,97 @@ static struct kmem_cache *req_cachep;
=20
 static const struct file_operations io_uring_fops;
=20
+const char *io_uring_get_opcode(u8 opcode)
+{
+	switch (opcode) {
+	case IORING_OP_NOP:
+		return "NOP";
+	case IORING_OP_READV:
+		return "READV";
+	case IORING_OP_WRITEV:
+		return "WRITEV";
+	case IORING_OP_FSYNC:
+		return "FSYNC";
+	case IORING_OP_READ_FIXED:
+		return "READ_FIXED";
+	case IORING_OP_WRITE_FIXED:
+		return "WRITE_FIXED";
+	case IORING_OP_POLL_ADD:
+		return "POLL_ADD";
+	case IORING_OP_POLL_REMOVE:
+		return "POLL_REMOVE";
+	case IORING_OP_SYNC_FILE_RANGE:
+		return "SYNC_FILE_RANGE";
+	case IORING_OP_SENDMSG:
+		return "SENDMSG";
+	case IORING_OP_RECVMSG:
+		return "RECVMSG";
+	case IORING_OP_TIMEOUT:
+		return "TIMEOUT";
+	case IORING_OP_TIMEOUT_REMOVE:
+		return "TIMEOUT_REMOVE";
+	case IORING_OP_ACCEPT:
+		return "ACCEPT";
+	case IORING_OP_ASYNC_CANCEL:
+		return "ASYNC_CANCEL";
+	case IORING_OP_LINK_TIMEOUT:
+		return "LINK_TIMEOUT";
+	case IORING_OP_CONNECT:
+		return "CONNECT";
+	case IORING_OP_FALLOCATE:
+		return "FALLOCATE";
+	case IORING_OP_OPENAT:
+		return "OPENAT";
+	case IORING_OP_CLOSE:
+		return "CLOSE";
+	case IORING_OP_FILES_UPDATE:
+		return "FILES_UPDATE";
+	case IORING_OP_STATX:
+		return "STATX";
+	case IORING_OP_READ:
+		return "READ";
+	case IORING_OP_WRITE:
+		return "WRITE";
+	case IORING_OP_FADVISE:
+		return "FADVISE";
+	case IORING_OP_MADVISE:
+		return "MADVISE";
+	case IORING_OP_SEND:
+		return "SEND";
+	case IORING_OP_RECV:
+		return "RECV";
+	case IORING_OP_OPENAT2:
+		return "OPENAT2";
+	case IORING_OP_EPOLL_CTL:
+		return "EPOLL_CTL";
+	case IORING_OP_SPLICE:
+		return "SPLICE";
+	case IORING_OP_PROVIDE_BUFFERS:
+		return "PROVIDE_BUFFERS";
+	case IORING_OP_REMOVE_BUFFERS:
+		return "REMOVE_BUFFERS";
+	case IORING_OP_TEE:
+		return "TEE";
+	case IORING_OP_SHUTDOWN:
+		return "SHUTDOWN";
+	case IORING_OP_RENAMEAT:
+		return "RENAMEAT";
+	case IORING_OP_UNLINKAT:
+		return "UNLINKAT";
+	case IORING_OP_MKDIRAT:
+		return "MKDIRAT";
+	case IORING_OP_SYMLINKAT:
+		return "SYMLINKAT";
+	case IORING_OP_LINKAT:
+		return "LINKAT";
+	case IORING_OP_MSG_RING:
+		return "MSG_RING";
+	case IORING_OP_LAST:
+		return "LAST";
+	}
+	return "UNKNOWN";
+}
+
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1814e698d861..24651c229ed2 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -10,6 +10,7 @@ struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
+const char *io_uring_get_opcode(u8 opcode);
=20
 static inline void io_uring_files_cancel(void)
 {
@@ -42,6 +43,10 @@ static inline void io_uring_files_cancel(void)
 static inline void io_uring_free(struct task_struct *tsk)
 {
 }
+static inline const char *io_uring_get_opcode(u8 opcode)
+{
+	return "";
+}
 #endif
=20
 #endif
--=20
2.30.2

