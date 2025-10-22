Return-Path: <io-uring+bounces-10135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B2ABFDC01
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FA7B189A142
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6E82EC0A7;
	Wed, 22 Oct 2025 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ShQ4Gkbi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EFF2EB85C
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156018; cv=none; b=K47f7hElO9l/nNF7dKktYNcBh4aHgFIMMeNpPfZXOUXOe+y1RI9MjqrrG6hpnYAa9K8pevSyDRCTcEOR5RxoNFLMIsFbr2k6bCycDqGX7G5wGIvUp+HEHJ88v7AuB6pn/fDn2ErlN3mTUAy00MftWXd+uxbRYw3UtDAj56NOd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156018; c=relaxed/simple;
	bh=XqaRqsTtSUUnBYUgGOyIEJGmN5x92Z+04rx8jBGcgrw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WI/A/lItBF7VCyMvt+8dn5VNqKpSg+xOB9/iFqJjwyJ88C7ZFPBHpDj096l9l65ujSFthWR5YtwrbGHUcLds/am/hlg+o0x3Y6bWNtgaO2QO+8K/J7ZvmjHDbM8kEWRqYpCyxfD77gQ9OtB+YKi3YEs+zrSsUAc31wlIC9PPkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ShQ4Gkbi; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59MGdGBn2090430
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:00:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=wvJpEcDZjKZlqxCHS1
	SrOSNSh+3+mCrs/u1wwBg8TZQ=; b=ShQ4Gkbi1GCWhHgn5IK8zhPFu3IhT41tDv
	rRJrHEMoeSs/Kt2frzZXtVCYkjzf1f3rLWBoqOo307O692G3SvtjcfPCIsrmZTjl
	/tgZY1l3FBcgR1Xi9gcORip7S8hE9kKIAAC/0NNRBinGKJuoJ+/R6pPvXmJ19Hkd
	hrmWI2FHNoOrt9k9HfIcPQasuzxTv6vxLkK49bmCDBeiCbm3cEXuF5oMTO5JUEE5
	ArB+T/UdvM1lkEfSCT/8tq60zKwjZMml/BpntlnmRQp+6kn+GHm2kXeLA8Zz8GiX
	zV7bxRpwQek+c0XcQEn5PhG3Ig9eC5vUqVX6qh95GhXaBZDhxT5g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y2yu8phq-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:00:15 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 18:00:13 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id AC32A2F990E5; Wed, 22 Oct 2025 11:00:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] add man pages for new apis
Date: Wed, 22 Oct 2025 11:00:02 -0700
Message-ID: <20251022180002.2685063-1-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=Y+L1cxeN c=1 sm=1 tr=0 ts=68f91baf cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=VX0GCZM3_m6oCgL_IiUA:9
X-Proofpoint-ORIG-GUID: _IN2zUPFrFLDBPinen9LLvPI85Zp2QwU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0NiBTYWx0ZWRfX8tNkGNoq7Gwa
 12d1qxtUe+/w8jfT8zH1gsZwA7JLCwNYHGfx8mg/kFwd+RwSQCnCf2foiHWZQuPDBK6+iCdCOyP
 oGiocGJ3NfLx/FzqHryXFHVcKk/vL2lhjfRgUVscmZps7aXpuLXf7QzzY8JyzaxLx9tvnWvQm6d
 4TePU66QHzT0/dGqOMBEX0DgwbP6eYUGQnqH3+0+zbgiv1n4xEyU40aGXQVI+Bd3PDG3cYMSgQB
 B8vboQvcK6CrbEdwiJvDpURq3twP6qA5Vw9XsXnJyPV18g4LsDrxfQl6w0rLaBrhyAYSQq8Xuxz
 XKWvXVM7A5x/xZbj4v9sa6C52RX66u0oo9PbfwIh3IUKoeiTiM280/cMIp6laGjweFt9XalCRbK
 VMThd5nSqwMfBkNktJim4+BGP7mw4w==
X-Proofpoint-GUID: _IN2zUPFrFLDBPinen9LLvPI85Zp2QwU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Add manuals for getting 128b submission queue entries, and the new prep
functions.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 man/io_uring_get_sqe128.3        | 59 ++++++++++++++++++++++++++++++++
 man/io_uring_prep_nop128.3       | 30 ++++++++++++++++
 man/io_uring_prep_uring_cmd.3    | 37 ++++++++++++++++++++
 man/io_uring_prep_uring_cmd128.3 | 38 ++++++++++++++++++++
 4 files changed, 164 insertions(+)
 create mode 100644 man/io_uring_get_sqe128.3
 create mode 100644 man/io_uring_prep_nop128.3
 create mode 100644 man/io_uring_prep_uring_cmd.3
 create mode 100644 man/io_uring_prep_uring_cmd128.3

diff --git a/man/io_uring_get_sqe128.3 b/man/io_uring_get_sqe128.3
new file mode 100644
index 00000000..25db811a
--- /dev/null
+++ b/man/io_uring_get_sqe128.3
@@ -0,0 +1,59 @@
+.\" Copyright (C) 2020 Jens Axboe <axboe@kernel.dk>
+.\" Copyright (C) 2020 Red Hat, Inc.
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_get_sqe128 3 "October 22, 2025" "liburing-0.7" "liburing Ma=
nual"
+.SH NAME
+io_uring_get_sqe128 \- get the next available 128-byte submission queue =
entry
+from the submission queue
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "struct io_uring_sqe *io_uring_get_sqe128(struct io_uring *" ring ")=
;"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_get_sqe128 (3)
+function gets the next available 128-byte submission queue entry from th=
e
+submission queue belonging to the
+.I ring
+param.
+
+On success
+.BR io_uring_get_sqe128 (3)
+returns a pointer to the submission queue entry. On failure NULL is retu=
rned.
+
+If a submission queue entry is returned, it should be filled out via one=
 of the
+prep functions such as
+.BR io_uring_prep_uring_cmd128 (3)
+and submitted via
+.BR io_uring_submit (3).
+
+Note that neither
+.BR io_uring_get_sqe128
+nor the prep functions set (or clear) the
+.B user_data
+field of the SQE. If the caller expects
+.BR io_uring_cqe_get_data (3)
+or
+.BR io_uring_cqe_get_data64 (3)
+to return valid data when reaping IO completions, either
+.BR io_uring_sqe_set_data (3)
+or
+.BR io_uring_sqe_set_data64 (3)
+.B MUST
+have been called before submitting the request.
+
+.SH RETURN VALUE
+.BR io_uring_get_sqe128 (3)
+returns a pointer to the next submission queue event on success and NULL=
 on
+failure. If NULL is returned, the SQ ring either wasn't created with 128=
-byte
+entries (IORING_SETUP_SQE128 or IORING_SETUP_SQE_MIXED) or is currently =
full
+and entries must be submitted for processing before new ones can get all=
ocated.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR io_uring_sqe_set_data (3)
diff --git a/man/io_uring_prep_nop128.3 b/man/io_uring_prep_nop128.3
new file mode 100644
index 00000000..4e0c012b
--- /dev/null
+++ b/man/io_uring_prep_nop128.3
@@ -0,0 +1,30 @@
+.\" Copyright (C) 2022 Samuel Williams
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_nop128 3 "October 22, 2025" "liburing-2.2" "liburing M=
anual"
+.SH NAME
+io_uring_prep_nop128 \- prepare a nop request
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_nop128(struct io_uring_sqe *" sqe ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_prep_nop128 (3)
+function prepares nop (no operation) request for a 128-byte entry. The
+submission queue entry
+.I sqe
+does not require any additional setup.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+None
+.SH SEE ALSO
+.BR io_uring_prep_nop (3),
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
diff --git a/man/io_uring_prep_uring_cmd.3 b/man/io_uring_prep_uring_cmd.=
3
new file mode 100644
index 00000000..b8a95233
--- /dev/null
+++ b/man/io_uring_prep_uring_cmd.3
@@ -0,0 +1,37 @@
+.\" Copyright (C) 2022 Samuel Williams
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_uring_cmd 3 "October 22, 2025" "liburing-2.2" "liburin=
g Manual"
+.SH NAME
+io_uring_prep_uring_cmd \- prepare a uring_cmd request
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_uring_cmd(struct io_uring_sqe *" sqe ","
+.BI "                                           int " cmd_op ","
+.BI "                                           int " fd ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_prep_uring_cmd (3)
+function prepares uring_cmd (fd specific) request. The submission queue =
entry
+.I sqe
+is setup to use the filedescriptor
+.I fd
+to send file descriptor specific
+.IR cmd_op .
+
+The reserved fields are initialized to 0. Otherwise the caller has to se=
t up
+any submission queue entry's operation specific fields.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+None
+.SH SEE ALSO
+.BR io_uring_prep_uring_cmd128 (3),
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
diff --git a/man/io_uring_prep_uring_cmd128.3 b/man/io_uring_prep_uring_c=
md128.3
new file mode 100644
index 00000000..41853c51
--- /dev/null
+++ b/man/io_uring_prep_uring_cmd128.3
@@ -0,0 +1,38 @@
+.\" Copyright (C) 2022 Samuel Williams
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_uring_cmd128 3 "October 22, 2025" "liburing-2.2" "libu=
ring Manual"
+.SH NAME
+io_uring_prep_uring_cmd128 \- prepare a uring_cmd request
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_uring_cmd128(struct io_uring_sqe *" sqe ","
+.BI "                                           int " cmd_op ","
+.BI "                                           int " fd ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_prep_uring_cmd128 (3)
+function prepares uring_cmd (fd specific) request for a 128 byte submiss=
ion
+queue entry. The submission queue entry
+.I sqe
+is setup to use the filedescriptor
+.I fd
+to send file descriptor specific
+.IR cmd_op .
+
+The reserved fields are initialized to 0. Otherwise the caller has to se=
t up
+any submission queue entry's operation specific fields.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+None
+.SH SEE ALSO
+.BR io_uring_prep_uring_cmd (3),
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
--=20
2.47.3


