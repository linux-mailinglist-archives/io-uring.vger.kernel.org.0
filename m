Return-Path: <io-uring+bounces-5477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D28B9F0CA9
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 13:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 799CE16643F
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 12:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DEB1DF721;
	Fri, 13 Dec 2024 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="TbEcGjai"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EECD1A0AF7
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 12:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734094018; cv=none; b=vENkZf6RFHP4GQVI0NajiBJSm6SFemQb5yihc1nw3gE/y8P8EfcRbnZ34IbxBvUMFnXZfNZSDGGhSuz6vYEh+LNoFbU6Hv6a+H8fIhx0sDp6tldmDtYr5Pn46OOkGWHPa0nlcJ2oSozhWbRtNQe/JuW0MQVlvcV+ALgQ7nN84uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734094018; c=relaxed/simple;
	bh=FizzQNMfYJYpGIUlG3svTjPfChZDtuv2fwFtfpjrEso=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kY4brCMVFrrt2iee98WHljxWReTDne3UizZsV6Lt89oya/FTroPy38i24tzwrwy8VhIoDUSL4/BokiAHL2uX/RHGDHDKMSk8joFGSnrN9id8SOBKnjRsh9c7QRUmu4j8uY2DVPnMtRv+Z4co8KN+Y7KuakZo4Kb2eKM64Zwdax0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=TbEcGjai; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BD7qPQm018813
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 04:46:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=xJ8+6khN1QLGsUgMZlX3B6H
	pCPyrBbuHoERWnx2myIo=; b=TbEcGjaiGZxXcgervFHtybYKOROWW5zqLa4lLYQ
	HY4wXB+Nf2ofALBGiGlnnh0DGyl1Jgu4uNlLq0evbpoomRhJsGUuxWnNtfqPOFXA
	IFgnd9Wa/6TDmXYfL8DKHI/rGL6CONfIt0UKQx6UEk8ZBg6lZ4H3+Zbl3w0vnFtU
	NFUE=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43ggwm16tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 04:46:55 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Dec 2024 12:46:54 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 981F79847C19; Fri, 13 Dec 2024 12:46:37 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>,
        Pavel Begunkov
	<asml.silence@gmail.com>
Subject: [PATCH] btrfs: check if task has died in btrfs_uring_read_finished()
Date: Fri, 13 Dec 2024 12:46:15 +0000
Message-ID: <20241213124626.130075-1-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: eM1PMJGa42Z_K7z1Rx6Kmr50jIiLBHh-
X-Proofpoint-ORIG-GUID: eM1PMJGa42Z_K7z1Rx6Kmr50jIiLBHh-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

If the task has died by the time we call btrfs_uring_read_finished(),
return -ECANCELED rather than trying to copy the pages back to
userspace.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
---
(This is quite possibly a resend. I intended this to be the sequel to
"[PATCH 1/2] io_uring/cmd: let cmds to know about dying task", but I
can't find it anywhere on the mailing lists now.)

 fs/btrfs/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 64cebc32fe76..6913967083fe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4754,6 +4754,11 @@ static void btrfs_uring_read_finished(struct io_ur=
ing_cmd *cmd, unsigned int iss
 	/* The inode lock has already been acquired in btrfs_uring_read_extent.=
  */
 	btrfs_lockdep_inode_acquire(inode, i_rwsem);
=20
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		ret =3D -ECANCELED;
+		goto out;
+	}
+
 	if (priv->err) {
 		ret =3D priv->err;
 		goto out;
--=20
2.45.2


