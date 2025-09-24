Return-Path: <io-uring+bounces-9872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B21F7B9A885
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFFAC168325
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E4830CB22;
	Wed, 24 Sep 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XRsA3iS5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1130C629
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726749; cv=none; b=BowHPjVNxS3sqilA+JoA3eoIC4WZQgSFZk1UmSvN7xRm3OQ+PrmjN7zGPFXvwWBM2XTRGh0M/a5CR2jnX9kFnJB9AnH41whQdOFOu3KO1jqgDtQjOwq1ZAis1S3GVoeEzvLzMyFsniumo+FPZ7Y9KJ10iu3zH26m2n77Q73RMWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726749; c=relaxed/simple;
	bh=BBHLhSAo8m7GbJZJkFv6hT4iPrx4GTWR1FkHqqUgC1I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dwjyLO8Z5V/Sedee/75Q7duNxBJ2QUVP1toMHof2/9YfVvrVLFMQv2pUrEdYaK9ar3V30J/vkxpxgKCNLMmxwlYryBKBAJ4iYIgAy4yQIZBQ6BA3w1jAOMyz1kiWjrjuO6lFIePYkhZEK8EnY4p4xPsDY3Xswh237FjVI4VhQko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XRsA3iS5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58OEAWrN2958973
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=JE8jSrM72cIkGF70Ip
	p1CubDovJodENKxCYcDyMVqP4=; b=XRsA3iS5i/b0Dqf4JWWD+sL+bwv8CXcBtS
	RsEOoviQuCuzf/aeMcRZERtErNns99o9bYUyF0jGbgxsTMWT4om1ea8QxEeorH+s
	CPjka2nGLeRRgSmYVprcgjvevH+zKZLEr5XxB4LKIE4825yFRV0ouIGQv1pAJVNV
	lNYoomlK3UJLK/E1UxWK0W8kL5evXGidiNWsAmQOTJUtmoV89noaRsVC9yjp19in
	fODlcdlAJbjTL1a3tuQl8r10ubbuI5erhalWiAMucVrUBh3PvBV7KvfpjJ8GzzEA
	uvozTdFtaJoiaAaRzrNaMwAplIob9I/Xzqm0N319uayNo6VJ/Ajg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49c7mxc861-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:26 -0700 (PDT)
Received: from twshared10560.01.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 24 Sep 2025 15:12:23 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id F1966208B9DA; Wed, 24 Sep 2025 08:12:13 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <csander@purestorage.com>, <ming.lei@redhat.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/3] 
Date: Wed, 24 Sep 2025 08:12:06 -0700
Message-ID: <20250924151210.619099-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bK5_TMSmNXTbQ4-DeV8w2iu1O5MLZw3O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI0MDEzMSBTYWx0ZWRfX9io+nS9zRLEX
 GH7Vi6Ola8Xg6PzCPpheQzp1cddz5T7bb/M3G5vhcY+gEXIz7OiL/CUeTXmoL/sH5N58HaQYd2b
 HIJ3SVxhN56NN50GqN5MfrCNIW4GBIlZIr9zO5Q67EZO7TeLkoq3jjGup+LNX6lbO7uYKeNXMSk
 IyMe7Nko197RSgZ8syM4pCnuWy8CcrN/am92zwCwn3kjkdkQZEZTt5CmTWU1rKVd7iqqokWxV4+
 wkyyfMUAeY1l4+jKmj93/3aKQQhYq71ZA/Knu3wb2n21Qx/6nmGxLhzYxJlvJaU4pJlGqkphta/
 Cyy/xL4wtCBb8VBhlU+fHM4g4JG8EcFzQXZDbtxNSEl9ftSU8Cx6CtvKMGfLAM=
X-Authority-Analysis: v=2.4 cv=ErPSrTcA c=1 sm=1 tr=0 ts=68d40a5b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=V4SqXGhnfJXzwtRPjwsA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: bK5_TMSmNXTbQ4-DeV8w2iu1O5MLZw3O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Previous version:

  https://lore.kernel.org/io-uring/20250904192716.3064736-1-kbusch@meta.c=
om/

The CQ supports mixed size entries, so why not for SQ's too? There are
use cases that currently allocate different queues just to keep these
things separated, but we can efficiently handle both cases in a single
ring.

Changes since v2:

 - Define 128B opcodes to be used on mixed SQs. This is done instead of
   using the last SQE flags bit to generically identify a command as
   such. The new opcodes are valid only on a mixed SQ.

 - Fixed up the accounting of sqes left to dispatch. The big sqes on a
   mixed sq count for two entries, so previously would have fetched too
   many.

 - liburing won't bother submitting the nop-skip for the wrap-around
   condition if there are not enoungh free entries for the big-sqe.

kernel:

Keith Busch (1):
  io_uring: add support for IORING_SETUP_SQE_MIXED

 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
 io_uring/io_uring.c           | 27 +++++++++++++++++++++++----
 io_uring/io_uring.h           |  8 +++++---
 io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
 io_uring/opdef.h              |  2 ++
 io_uring/register.c           |  2 +-
 io_uring/uring_cmd.c          | 12 ++++++++++--
 io_uring/uring_cmd.h          |  1 +
 9 files changed, 103 insertions(+), 17 deletions(-)

liburing:

Keith Busch (3):
  Add support IORING_SETUP_SQE_MIXED
  Add nop testing for IORING_SETUP_SQE_MIXED
  Add mixed sqe test for uring commands

 src/include/liburing.h          |  50 +++++++++++
 src/include/liburing/io_uring.h |  11 +++
 test/Makefile                   |   3 +
 test/sqe-mixed-bad-wrap.c       |  89 ++++++++++++++++++++
 test/sqe-mixed-nop.c            |  82 ++++++++++++++++++
 test/sqe-mixed-uring_cmd.c      | 142 ++++++++++++++++++++++++++++++++
 6 files changed, 377 insertions(+)
 create mode 100644 test/sqe-mixed-bad-wrap.c
 create mode 100644 test/sqe-mixed-nop.c
 create mode 100644 test/sqe-mixed-uring_cmd.c

--=20
2.47.3


