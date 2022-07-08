Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7456C3A8
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 01:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbiGHSpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiGHSpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:45:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8884507A
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:45:49 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HAYKN002090
        for <io-uring@vger.kernel.org>; Fri, 8 Jul 2022 11:45:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9y2luESb+DOC46QiK+cdsNagpAAfYjxzofMw+ChasVA=;
 b=ZBpafXWzsJZSciyUMnrJKWS4WW64AkV4e30cpjt8H9wcBGPcGgdo8cI7BP8sgPhBmDvi
 1zpc+4rQHgP7OVRy2JDFezxvOqSKLTJ/tG66gqVDFNr4SEvEmudlL9cEpWyK7+e2Nq9c
 TOlWc3CXgZQRuket/pu/nAcrssy2EBKE6U8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h67d26d3y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:45:49 -0700
Received: from twshared9535.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:45:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 332D72BA20C5; Fri,  8 Jul 2022 11:45:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC liburing 1/2] add multishot recvmsg API
Date:   Fri, 8 Jul 2022 11:45:37 -0700
Message-ID: <20220708184538.1632315-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708184538.1632315-1-dylany@fb.com>
References: <20220708184538.1632315-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: CZVcVnOnOzQq75HgBL1vivfXJrr6p37j
X-Proofpoint-ORIG-GUID: CZVcVnOnOzQq75HgBL1vivfXJrr6p37j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_15,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds a new API to do multishot recvmsg. This is more complicated tha=
n
multishot recv as it requires handling a well known data layout copied by
the kernel.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h          | 59 +++++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  7 ++++
 2 files changed, 66 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index d35bfa9..3f18bd2 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -419,6 +419,13 @@ static inline void io_uring_prep_recvmsg(struct io_u=
ring_sqe *sqe, int fd,
 	sqe->msg_flags =3D flags;
 }
=20
+static inline void io_uring_prep_recvmsg_multishot(struct io_uring_sqe *=
sqe, int fd,
+						   struct msghdr *msg, unsigned flags)
+{
+	io_uring_prep_recvmsg(sqe, fd, msg, flags);
+	sqe->ioprio |=3D IORING_RECV_MULTISHOT;
+}
+
 static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int f=
d,
 					 const struct msghdr *msg,
 					 unsigned flags)
@@ -685,6 +692,58 @@ static inline void io_uring_prep_recv_multishot(stru=
ct io_uring_sqe *sqe,
 	sqe->ioprio |=3D IORING_RECV_MULTISHOT;
 }
=20
+static inline struct io_uring_recvmsg_out *io_uring_recvmsg_validate(
+	void *buf, int buf_len, struct msghdr *m)
+{
+	struct io_uring_recvmsg_out *ret;
+	size_t header =3D m->msg_controllen + m->msg_namelen + sizeof(struct io=
_uring_recvmsg_out);
+
+	if (buf_len < header)
+		return NULL;
+	ret =3D (struct io_uring_recvmsg_out *)buf;
+	if (buf_len < header + ret->payloadlen)
+		return NULL;
+	return ret;
+}
+
+static inline void *io_uring_recvmsg_name(struct io_uring_recvmsg_out *o=
)
+{
+	return (void*)&o[1];
+}
+
+static inline struct cmsghdr *io_uring_recvmsg_cmsg_firsthdr(struct io_u=
ring_recvmsg_out *o,
+							     struct msghdr *m)
+{
+	if (o->controllen < sizeof(struct cmsghdr))
+		return NULL;
+	return (struct cmsghdr *)((unsigned char*)io_uring_recvmsg_name(o) + m-=
>msg_namelen);
+}
+
+static inline void *io_uring_recvmsg_payload(struct io_uring_recvmsg_out=
 *o,
+					     struct msghdr *m)
+{
+	return (void*)((unsigned char*)io_uring_recvmsg_name(o) + m->msg_namele=
n + m->msg_controllen);
+}
+
+static inline struct cmsghdr *io_uring_recvmsg_cmsg_nexthdr(struct io_ur=
ing_recvmsg_out *o,
+							    struct msghdr *m,
+							    struct cmsghdr *cmsg)
+{
+	unsigned char *end;
+
+	if (cmsg->cmsg_len < sizeof (struct cmsghdr))
+		return NULL;
+	end =3D (unsigned char *)io_uring_recvmsg_payload(o, m);
+	cmsg =3D (struct cmsghdr *)((unsigned char *)cmsg + CMSG_ALIGN(cmsg->cm=
sg_len));
+
+	if ((unsigned char *)(cmsg + 1) > end)
+		return NULL;
+	if (((unsigned char *)cmsg) + CMSG_ALIGN(cmsg->cmsg_len) > end)
+		return NULL;
+
+	return cmsg;
+}
+
 static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int d=
fd,
 					const char *path, struct open_how *how)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index fbf6403..5e111b4 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -573,6 +573,13 @@ struct io_uring_file_index_range {
 	__u64	resv;
 };
=20
+struct io_uring_recvmsg_out {
+	__u32 namelen;
+	__u32 controllen;
+	__u32 payloadlen;
+	__u32 flags;
+};
+
 /*
  * accept flags stored in sqe->ioprio
  */
--=20
2.30.2

