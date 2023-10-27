Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9EC7D9FBC
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 20:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjJ0SUH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 14:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjJ0SUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 14:20:06 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C55218F
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:04 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RE5Y2O006162
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=jAGKyWeA8QTcQMk/vfy8VOIt2qAQYrVxiznwPWy89lU=;
 b=muaMpsn5JwFC8QzqI6QwjpDHnwsPDP3VcazR0bJrhYgTvVu/Y4KL3B4u5y9Np88Xzo55
 VFpcmtq5RKRGhn1kA3RIjd7yOF9lPqxN2ckEB5YH++RXDxG6LtUFggYfyCQkZZJtyYW7
 T4IXiL2H64qdPfENsG96qWNc9I1UNtfjvtkcF3ObyKoz5LtyKN5XqbzuSbEUKs8ge0Oc
 WqcteQj1S72NijhUQpyx2hFTjtZZ5jl6U/EJyX3HtflLrigEBvCNKyfFphkO9PDGGBRo
 QJu+ewZG4Pgq1SUtKblUchWwPjVEyUe/KhDwrTIsNgXvVu5xS1SVFKnfNHWjZIkCZMRD Cw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3u0c4pu41c-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:04 -0700
Received: from twshared10830.02.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 11:19:59 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 6F25520D093C6; Fri, 27 Oct 2023 11:19:50 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/4] iouring: remove IORING_URING_CMD_POLLED
Date:   Fri, 27 Oct 2023 11:19:28 -0700
Message-ID: <20231027181929.2589937-4-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231027181929.2589937-1-kbusch@meta.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: iYNZy2NE31A37c8QR0TP0K7r9Zw9XEVJ
X-Proofpoint-ORIG-GUID: iYNZy2NE31A37c8QR0TP0K7r9Zw9XEVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_17,2023-10-27_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

No more users of this flag.

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

