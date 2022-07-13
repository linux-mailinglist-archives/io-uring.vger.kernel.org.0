Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD13573100
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 10:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiGMIZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 04:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiGMIZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 04:25:43 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B513EBE
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:48 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CLjj2j011411
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kEoZzVMaUEv7lLMBq4KO6Kt4EYduFmFlHpr9xhQEsXQ=;
 b=cdKopK93CmpMMKKrVQ4OLlrx/pqOAUSyqTRVgDQLJTDoujXzG9gIA7aG4glGOrHMZjDg
 6gLUfyAREdsriOFF1IzSCEMohCkgVN1nr5NK3voeOifP4uTFqflQMLCY3LRNAkieZCL1
 I6gCNxL0ns/zXhrX0TSgRrTOTaxTPt9mx9k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5ftd4h-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:47 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 13 Jul 2022 01:23:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8BD052ED8C22; Wed, 13 Jul 2022 01:23:43 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <io-uring@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 1/3] net: copy from user before calling __copy_msghdr
Date:   Wed, 13 Jul 2022 01:23:19 -0700
Message-ID: <20220713082321.1445020-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713082321.1445020-1-dylany@fb.com>
References: <20220713082321.1445020-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VsOIRgPId_flSOvUer1rPY4vijgue7MP
X-Proofpoint-ORIG-GUID: VsOIRgPId_flSOvUer1rPY4vijgue7MP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

this is in preparation for multishot receive from io_uring, where it need=
s
to have access to the original struct user_msghdr.

functionally this should be a no-op.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/linux/socket.h |  7 +++----
 io_uring/net.c         | 17 +++++++++--------
 net/socket.c           | 37 ++++++++++++++++---------------------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..be24f1c8568a 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -416,10 +416,9 @@ extern int recvmsg_copy_msghdr(struct msghdr *msg,
 			       struct user_msghdr __user *umsg, unsigned flags,
 			       struct sockaddr __user **uaddr,
 			       struct iovec **iov);
-extern int __copy_msghdr_from_user(struct msghdr *kmsg,
-				   struct user_msghdr __user *umsg,
-				   struct sockaddr __user **save_addr,
-				   struct iovec __user **uiov, size_t *nsegs);
+extern int __copy_msghdr(struct msghdr *kmsg,
+			 struct user_msghdr *umsg,
+			 struct sockaddr __user **save_addr);
=20
 /* helpers which do the actual work for syscalls */
 extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
diff --git a/io_uring/net.c b/io_uring/net.c
index dc9190eafbe7..da7667ed3610 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -329,31 +329,32 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *r=
eq,
 				 struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
-	struct iovec __user *uiov;
-	size_t iov_len;
+	struct user_msghdr msg;
 	int ret;
=20
-	ret =3D __copy_msghdr_from_user(&iomsg->msg, sr->umsg,
-					&iomsg->uaddr, &uiov, &iov_len);
+	if (copy_from_user(&msg, sr->umsg, sizeof(*sr->umsg)))
+		return -EFAULT;
+
+	ret =3D __copy_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
 	if (ret)
 		return ret;
=20
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (iov_len =3D=3D 0) {
+		if (msg.msg_iovlen =3D=3D 0) {
 			sr->len =3D iomsg->fast_iov[0].iov_len =3D 0;
 			iomsg->fast_iov[0].iov_base =3D NULL;
 			iomsg->free_iov =3D NULL;
-		} else if (iov_len > 1) {
+		} else if (msg.msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
-			if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
+			if (copy_from_user(iomsg->fast_iov, msg.msg_iov, sizeof(*msg.msg_iov)=
))
 				return -EFAULT;
 			sr->len =3D iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov =3D NULL;
 		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
-		ret =3D __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
+		ret =3D __import_iovec(READ, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
 				     &iomsg->free_iov, &iomsg->msg.msg_iter,
 				     false);
 		if (ret > 0)
diff --git a/net/socket.c b/net/socket.c
index 96300cdc0625..843545c21ec2 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2358,25 +2358,20 @@ struct used_address {
 	unsigned int name_len;
 };
=20
-int __copy_msghdr_from_user(struct msghdr *kmsg,
-			    struct user_msghdr __user *umsg,
-			    struct sockaddr __user **save_addr,
-			    struct iovec __user **uiov, size_t *nsegs)
+int __copy_msghdr(struct msghdr *kmsg,
+		  struct user_msghdr *msg,
+		  struct sockaddr __user **save_addr)
 {
-	struct user_msghdr msg;
 	ssize_t err;
=20
-	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
-		return -EFAULT;
-
 	kmsg->msg_control_is_user =3D true;
 	kmsg->msg_get_inq =3D 0;
-	kmsg->msg_control_user =3D msg.msg_control;
-	kmsg->msg_controllen =3D msg.msg_controllen;
-	kmsg->msg_flags =3D msg.msg_flags;
+	kmsg->msg_control_user =3D msg->msg_control;
+	kmsg->msg_controllen =3D msg->msg_controllen;
+	kmsg->msg_flags =3D msg->msg_flags;
=20
-	kmsg->msg_namelen =3D msg.msg_namelen;
-	if (!msg.msg_name)
+	kmsg->msg_namelen =3D msg->msg_namelen;
+	if (!msg->msg_name)
 		kmsg->msg_namelen =3D 0;
=20
 	if (kmsg->msg_namelen < 0)
@@ -2386,11 +2381,11 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		kmsg->msg_namelen =3D sizeof(struct sockaddr_storage);
=20
 	if (save_addr)
-		*save_addr =3D msg.msg_name;
+		*save_addr =3D msg->msg_name;
=20
-	if (msg.msg_name && kmsg->msg_namelen) {
+	if (msg->msg_name && kmsg->msg_namelen) {
 		if (!save_addr) {
-			err =3D move_addr_to_kernel(msg.msg_name,
+			err =3D move_addr_to_kernel(msg->msg_name,
 						  kmsg->msg_namelen,
 						  kmsg->msg_name);
 			if (err < 0)
@@ -2401,12 +2396,10 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		kmsg->msg_namelen =3D 0;
 	}
=20
-	if (msg.msg_iovlen > UIO_MAXIOV)
+	if (msg->msg_iovlen > UIO_MAXIOV)
 		return -EMSGSIZE;
=20
 	kmsg->msg_iocb =3D NULL;
-	*uiov =3D msg.msg_iov;
-	*nsegs =3D msg.msg_iovlen;
 	return 0;
 }
=20
@@ -2418,8 +2411,10 @@ static int copy_msghdr_from_user(struct msghdr *km=
sg,
 	struct user_msghdr msg;
 	ssize_t err;
=20
-	err =3D __copy_msghdr_from_user(kmsg, umsg, save_addr, &msg.msg_iov,
-					&msg.msg_iovlen);
+	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
+		return -EFAULT;
+
+	err =3D __copy_msghdr(kmsg, &msg, save_addr);
 	if (err)
 		return err;
=20
--=20
2.30.2

