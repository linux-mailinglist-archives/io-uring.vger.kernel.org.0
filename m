Return-Path: <io-uring+bounces-183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 407377FFE06
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 22:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71BC41C210E6
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 21:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DBEA5DF27;
	Thu, 30 Nov 2023 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SpE9/xT/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24E6A8
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:28 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AULK8Fk028718
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=VEidoiORX4ge6SiYkCKT3Jolq/YhnrPITBAKfRKTwZ0=;
 b=SpE9/xT/40dWuKtM5eiStUDnJFibt06btJzlpU70wwKtyQDAM4FLjfMJ2HOQZ9/lGqqb
 AngB05kR0LxTNTuD/diV1KgPvf3tLWR+IpAZQcWGcQU6386Hr/L58CbZLgL4u89TC2CD
 HUadDC0kKvC0BNYVuxBFHsHZ3uteK9UY00rvjzbdTsKfWWUiM3FgV2z2YO9IsINFiKR5
 AcnXuPRsLJrWSa+V5isM6ewg+H87j01DTBexPn0iOKjuw3PkOyuqNBXzgpojeZbMQkVP
 HhxvxU9YIlXRMRu/M18s8u8zZy45Od70ROwQsSbsT7n7EZoDzwWyPuTExV8lGhQrrr6C bg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uphtvxqhd-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:27 -0800
Received: from twshared4634.37.frc1.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 13:53:23 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 6BED4226BF689; Thu, 30 Nov 2023 13:53:10 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 3/4] iouring: remove IORING_URING_CMD_POLLED
Date: Thu, 30 Nov 2023 13:53:08 -0800
Message-ID: <20231130215309.2923568-4-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130215309.2923568-1-kbusch@meta.com>
References: <20231130215309.2923568-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VW4LLCaQx4fZ5ni0pHq48EpnDuEvGGrx
X-Proofpoint-GUID: VW4LLCaQx4fZ5ni0pHq48EpnDuEvGGrx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-30_22,2023-11-30_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

No more users of this flag.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index aefb73eeeebff..fe23bf88f86fa 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -28,7 +28,6 @@ enum io_uring_cmd_flags {
=20
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
 #define IORING_URING_CMD_CANCELABLE	(1U << 30)
-#define IORING_URING_CMD_POLLED		(1U << 31)
=20
 struct io_uring_cmd {
 	struct file	*file;
--=20
2.34.1


