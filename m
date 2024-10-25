Return-Path: <io-uring+bounces-4043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B5D9B11CD
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 23:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA2CAB21A8B
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 21:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3172E1FB8AF;
	Fri, 25 Oct 2024 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mQ1IgskG"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29520EA25
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 21:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729892392; cv=none; b=X2esQv0nU+rA/jA18osXXv3iSupg9WOYww2yHKkd8Ic6XU2YdMk0+iUYl5tWHf3ldR/k2LZayZXOyCzxnCTK33nfCKchnuCnVKWrNcbouciHFTWm4sPHNWazzMXsL1kRD4wuNMrDEza7FHvIHdAg69kVPZOGrefMsryqlIO30kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729892392; c=relaxed/simple;
	bh=QNBnH7bi6WbGlj2rf3vDcTyaJMrmau3H7p98DlJvp0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQHh7MoxTC/UohV1xHUzs01zc88MKpPvcB4P8s00gwv1WXvx67vRi+L1OqZleiLhTEwLyLFRrDmEJ3Z1KoKZjvUixsQivfBsg7cbrOPGuQHZnjClfhGBdREFRMGeePglaxVcTZpvvc93iaJQs5/yg5H9fJNyGdYw89vneuQemzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mQ1IgskG; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PKXQUR014215
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:39:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=QDSowptOyZLvK9oAHCxfP0iFBCixlqbp/+dl8U+g3G0=; b=mQ1IgskGRUZF
	aHWIeAvxdctEjZ1ozlJxEG/DMeww3ySl+lsIJ/kdShKTO5W63NGWopSwifiIeuLr
	NjMrYPvALK8GNbcTbZnWtwsAxHqOQ8nYuub97UWRdkCxKAjOEkAfLrt1yCY4m10J
	kotD3iBXuL5/I5kA71zbLcMmVicPJ7cCfBg6tJsvvNFJpBQzpbX4ipirCOjJdCoc
	r7PbUdHzE14HEc2/mmhOBWFzIa0YRTnLRDKX+CR/L13/CtXR6FvbYlq3leSgdFxI
	7SRXa09EVoqgafM6OLC6aIf+2evSaRsXITQHTFDxJ+G2Uyh2VlRpQp4TZnfQehY1
	4xHhFHwbkQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42g657wbjc-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:39:49 -0700 (PDT)
Received: from twshared10900.35.frc1.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 25 Oct 2024 21:39:46 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B3E041476D744; Fri, 25 Oct 2024 14:37:06 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <hch@lst.de>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, <bvanassche@acm.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv9 7/7] scsi: set permanent stream count in block limits
Date: Fri, 25 Oct 2024 14:36:45 -0700
Message-ID: <20241025213645.3464331-8-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241025213645.3464331-1-kbusch@meta.com>
References: <20241025213645.3464331-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: BSghIwIFNtwgil65YEXt82dXO74pmxiJ
X-Proofpoint-ORIG-GUID: BSghIwIFNtwgil65YEXt82dXO74pmxiJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

The block limits exports the number of write hints, so set this limit if
the device reports support for the lifetime hints. Not only does this
inform the user of which hints are possible, it also allows scsi devices
supporting the feature to utilize the full range through raw block
device direct-io.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76adc..235dd6e5b6688 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3768,6 +3768,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_config_protection(sdkp, &lim);
 	}
=20
+	lim.max_write_hints =3D sdkp->permanent_stream_count;
+
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
--=20
2.43.5


