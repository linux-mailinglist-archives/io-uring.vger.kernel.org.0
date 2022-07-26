Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C617E5812EF
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiGZMPS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiGZMPR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:15:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD1FAE70
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:15 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0rR8e010368
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fvuLvGOXfPpDawfY17s+47uVGXBsXbTXyOIpofQR6Tc=;
 b=PdgXfs48EWXKZUg78cReGEbgL3D+7i23C1FkGa9TH0IOWTPkvgTSR4EDrSOQfrJN31e7
 oTiLkOmqD9siiFlZBsOlX25WkB9CLHDC51IHFyAHUrUOSVri+SLf3P/e+6+uWKhTRc64
 sDRSoad7AHrFz9KDIytgQBTIfNlld84E5ck= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbwny4s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:15 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 05:15:12 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0C97B397A78C; Tue, 26 Jul 2022 05:15:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/5] more consistent multishot recvmsg API parameter names
Date:   Tue, 26 Jul 2022 05:14:58 -0700
Message-ID: <20220726121502.1958288-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726121502.1958288-1-dylany@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lTpCwPUyisxLPMV0ruqqj7_zy-z0MLWk
X-Proofpoint-ORIG-GUID: lTpCwPUyisxLPMV0ruqqj7_zy-z0MLWk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make the parameters more consistent with for example cmsg(3), and with
itself (in the form of buf_len).

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cffdabd71144..d3cbdb037b32 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -734,9 +734,9 @@ static inline void io_uring_prep_recv_multishot(struc=
t io_uring_sqe *sqe,
 }
=20
 static inline struct io_uring_recvmsg_out *
-io_uring_recvmsg_validate(void *buf, int buf_len, struct msghdr *m)
+io_uring_recvmsg_validate(void *buf, int buf_len, struct msghdr *msgh)
 {
-	int header =3D m->msg_controllen + m->msg_namelen +
+	int header =3D msgh->msg_controllen + msgh->msg_namelen +
 				sizeof(struct io_uring_recvmsg_out);
=20
 	if (buf_len < header)
@@ -751,42 +751,42 @@ static inline void *io_uring_recvmsg_name(struct io=
_uring_recvmsg_out *o)
=20
 static inline struct cmsghdr *
 io_uring_recvmsg_cmsg_firsthdr(struct io_uring_recvmsg_out *o,
-			       struct msghdr *m)
+			       struct msghdr *msgh)
 {
 	if (o->controllen < sizeof(struct cmsghdr))
 		return NULL;
=20
 	return (struct cmsghdr *)((unsigned char *) io_uring_recvmsg_name(o) +
-			m->msg_namelen);
+			msgh->msg_namelen);
 }
=20
 static inline void *io_uring_recvmsg_payload(struct io_uring_recvmsg_out=
 *o,
-					     struct msghdr *m)
+					     struct msghdr *msgh)
 {
 	return (void *)((unsigned char *)io_uring_recvmsg_name(o) +
-			m->msg_namelen + m->msg_controllen);
+			msgh->msg_namelen + msgh->msg_controllen);
 }
=20
 static inline size_t
 io_uring_recvmsg_payload_length(struct io_uring_recvmsg_out *o,
-				int buf_length, struct msghdr *m)
+				int buf_len, struct msghdr *msgh)
 {
 	unsigned long payload_start, payload_end;
=20
-	payload_start =3D (unsigned long) io_uring_recvmsg_payload(o, m);
-	payload_end =3D (unsigned long) o + buf_length;
+	payload_start =3D (unsigned long) io_uring_recvmsg_payload(o, msgh);
+	payload_end =3D (unsigned long) o + buf_len;
 	return payload_end - payload_start;
 }
=20
 static inline struct cmsghdr *
-io_uring_recvmsg_cmsg_nexthdr(struct io_uring_recvmsg_out *o, struct msg=
hdr *m,
+io_uring_recvmsg_cmsg_nexthdr(struct io_uring_recvmsg_out *o, struct msg=
hdr *msgh,
 			      struct cmsghdr *cmsg)
 {
 	unsigned char *end;
=20
 	if (cmsg->cmsg_len < sizeof(struct cmsghdr))
 		return NULL;
-	end =3D (unsigned char *) io_uring_recvmsg_cmsg_firsthdr(o, m) +
+	end =3D (unsigned char *) io_uring_recvmsg_cmsg_firsthdr(o, msgh) +
 		o->controllen;
 	cmsg =3D (struct cmsghdr *)((unsigned char *) cmsg +
 			CMSG_ALIGN(cmsg->cmsg_len));
--=20
2.30.2

