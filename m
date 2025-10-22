Return-Path: <io-uring+bounces-10130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 069B2BFD966
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2F8C3A7948
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113011D63C7;
	Wed, 22 Oct 2025 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="e29GmMoN"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65EB224891
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153687; cv=none; b=OnMP926Df1KBfxmWSjqyZMQ2VryJeRL3Hhwt+14l/TUPK+AsAj4T4sBadmRTQo1n+UBWSnx0EVb2p5uK5/m/iDoBs6fTt/u05cpwrwQgdgq8uDMeXx5eLJasHsgkjE5MN8+dSAQ1xKuD/29iNYxffYdQLuIGZbtOB11RlG3IOYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153687; c=relaxed/simple;
	bh=tNZb2xKt7HalrPmrNe2v/FxVjHh+6ESGAgorbst8YQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b52EtD9zOtV101xsZab+6wqilZyqrN9v1eGDewUivTtu2NyHtBaEfsto/5CEXhq7jWpRi5nZEeROf7+6f2GL7HPD5znFyMcOdVWw7MEKkX1pXX2p/s9ZCi0tUCbDRy5YgssaZA2OHVC7dRSpp5VmjbaazL6fWIzZlv3wAynHa3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=e29GmMoN; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59ME9TQu3459161
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=fSbkFKBv6lXuhzsEyQTbJWSbES2tZiXcmF33OWmTyFs=; b=e29GmMoNG83w
	EMUscHvpttwxLPULuLZfArtjhBwKeMZjoMnNQQpSDkAJTYB2K9JZ4gkKSqgeAjRe
	/krVhW6tOz5Tllg3XGClu7jNnCkntJSfqos+z/6Qayh7QR58ip+a7FlV/JtBJQU1
	xj7WviLJ6fVE+M3gdCWwxuD+wjmfy+oQKqh+nQ0GuOGt5PB8PuQea+rjPzAVdngp
	A61frdRm5Gsz7Iv0+wtx1MIlnPPQpwBYg7Gg8+jMXzvyT5XEgKIH3ErAl80XP2XD
	naT/vXpwD3dvLMhTbLvmmyAjUfL11PHfIV5Bj8UatuYpu7lj2/kndkAjVD1TPWM7
	+i6jB7W+Qw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y0sjssbr-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:23 -0700 (PDT)
Received: from twshared13080.31.frc3.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 01B552F95CB8; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 6/6] test/fdinfo: add mixed sqe option to fdinfo test
Date: Wed, 22 Oct 2025 10:19:24 -0700
Message-ID: <20251022171924.2326863-7-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022171924.2326863-1-kbusch@meta.com>
References: <20251022171924.2326863-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: eT4dyGkhssTiRaWgopaifDJQsplmB8D2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX3fJlR1uiORCp
 wEbxZX3e8Lt8PmgwM+SPf9gZi3IvvHwM6mnT59+EdNih7rkgzJbL72v2tz8QMOfXHUNr6rK5zTH
 5ibrUKO9OJsIG9aykqvR6R1zTpx5neYvFUeyO0o9AcN6He67t6SrCH0CcKqMSuK4yCwqLLqxjfY
 FR0FbfWs2LrFKYhhXoaK43Zl/ME+AxaYjpWWkkMDaZVSAYVczgYnK/Wgf8eeagNL26GgOvCuLwX
 DeMuqv9PrYaSdTvgHsBlwJagMISJ2L0hWg7H0DC65Bd2csCYkSs+d1X6B+B45J/QeEXiT/awVtt
 HL7MVRhk/+t3BXNKDlWEhTz/jK2E0LDcWqWyWVLzO0WVXDhJwxk/PRlimRaoQi0ZnXr23YvQZXw
 9DTLXbT/h3UHyEc42cLG6yci1nct6g==
X-Authority-Analysis: v=2.4 cv=AoLjHe9P c=1 sm=1 tr=0 ts=68f91293 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=l6QAcN6IjzDfIqNr95oA:9
X-Proofpoint-ORIG-GUID: eT4dyGkhssTiRaWgopaifDJQsplmB8D2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/fdinfo.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/test/fdinfo.c b/test/fdinfo.c
index 49522a0a..422e4e6d 100644
--- a/test/fdinfo.c
+++ b/test/fdinfo.c
@@ -57,7 +57,7 @@ static void fdinfo_read(struct io_uring *ring)
=20
 static int __test_io(const char *file, struct io_uring *ring, int write,
 		     int buffered, int sqthread, int fixed, int nonvec,
-		     int buf_select, int seq, int exp_len)
+		     int buf_select, int seq, int exp_len, int mixed)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
@@ -66,9 +66,9 @@ static int __test_io(const char *file, struct io_uring =
*ring, int write,
 	off_t offset;
=20
 #ifdef VERBOSE
-	fprintf(stdout, "%s: start %d/%d/%d/%d/%d: ", __FUNCTION__, write,
+	fprintf(stdout, "%s: start %d/%d/%d/%d/%d/%d: ", __FUNCTION__, write,
 							buffered, sqthread,
-							fixed, nonvec);
+							fixed, nonvec, mixed);
 #endif
 	if (write)
 		open_flags =3D O_WRONLY;
@@ -107,6 +107,17 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int write,
=20
 	offset =3D 0;
 	for (i =3D 0; i < BUFFERS; i++) {
+		if (mixed && i & 1) {
+			sqe =3D io_uring_get_sqe128(ring);
+			if (!sqe) {
+				fprintf(stderr, "sqe get failed\n");
+				goto err;
+			}
+			io_uring_prep_nop128(sqe);
+			sqe->user_data =3D i;
+			continue;
+		}
+
 		sqe =3D io_uring_get_sqe(ring);
 		if (!sqe) {
 			fprintf(stderr, "sqe get failed\n");
@@ -171,9 +182,13 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int write,
 	fdinfo_read(ring);
=20
 	ret =3D io_uring_submit(ring);
-	if (ret !=3D BUFFERS) {
+	if (!mixed && ret !=3D BUFFERS) {
 		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
 		goto err;
+	} else if (mixed && ret !=3D BUFFERS + (BUFFERS >> 1)) {
+		fprintf(stderr, "submit got %d, wanted %d\n", ret,
+			BUFFERS + (BUFFERS >> 1));
+		goto err;
 	}
=20
 	for (i =3D 0; i < 10; i++) {
@@ -187,7 +202,13 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int write,
 			fprintf(stderr, "wait_cqe=3D%d\n", ret);
 			goto err;
 		}
-		if (cqe->res =3D=3D -EINVAL && nonvec) {
+		if (mixed && cqe->user_data & 1) {
+			if (cqe->user_data > 32) {
+				fprintf(stderr, "cqe user data %lld, max expected %d\n",
+					cqe->user_data, BUFFERS - 1);
+				goto err;
+			}
+		} else if (cqe->res =3D=3D -EINVAL && nonvec) {
 			if (!warned) {
 				fprintf(stdout, "Non-vectored IO not "
 					"supported, skipping\n");
@@ -253,15 +274,19 @@ err:
 	return 1;
 }
 static int test_io(const char *file, int write, int buffered, int sqthre=
ad,
-		   int fixed, int nonvec, int exp_len)
+		   int fixed, int nonvec, int exp_len, int mixed)
 {
 	struct io_uring ring;
-	int ret, ring_flags =3D 0;
+	int ret, ring_flags =3D 0, entries =3D 64;
=20
 	if (sqthread)
 		ring_flags =3D IORING_SETUP_SQPOLL;
+	if (mixed) {
+		ring_flags |=3D IORING_SETUP_SQE_MIXED;
+		entries =3D 128;
+	}
=20
-	ret =3D t_create_ring(64, &ring, ring_flags);
+	ret =3D t_create_ring(entries, &ring, ring_flags);
 	if (ret =3D=3D T_SETUP_SKIP)
 		return 0;
 	if (ret !=3D T_SETUP_OK) {
@@ -270,7 +295,7 @@ static int test_io(const char *file, int write, int b=
uffered, int sqthread,
 	}
=20
 	ret =3D __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec=
,
-			0, 0, exp_len);
+			0, 0, exp_len, mixed);
 	io_uring_queue_exit(&ring);
 	return ret;
 }
@@ -380,17 +405,18 @@ int main(int argc, char *argv[])
 	vecs =3D t_create_buffers(BUFFERS, BS);
=20
 	/* if we don't have nonvec read, skip testing that */
-	nr =3D has_nonvec_read() ? 32 : 16;
+	nr =3D has_nonvec_read() ? 64 : 32;
=20
 	for (i =3D 0; i < nr; i++) {
 		int write =3D (i & 1) !=3D 0;
 		int buffered =3D (i & 2) !=3D 0;
 		int sqthread =3D (i & 4) !=3D 0;
 		int fixed =3D (i & 8) !=3D 0;
-		int nonvec =3D (i & 16) !=3D 0;
+		int mixed =3D (i & 16) !=3D 0;
+		int nonvec =3D (i & 32) !=3D 0;
=20
 		ret =3D test_io(fname, write, buffered, sqthread, fixed, nonvec,
-			      BS);
+			      BS, mixed);
 		if (ret =3D=3D T_EXIT_SKIP)
 			continue;
 		if (ret) {
--=20
2.47.3


