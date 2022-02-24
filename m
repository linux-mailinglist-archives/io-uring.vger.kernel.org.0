Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7F4C29DC
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 11:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiBXKwi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 05:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiBXKwf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 05:52:35 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8CED19BB
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:52:05 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21NK8KPF014073
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:52:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=oxqLGrDACpEzyruEGJo2A4mG59WpOKHx+fnLQwmM/M0=;
 b=J0P0tzZlOY65psZve/2Ua3Fphe+spK/FnS0WCOVVK2xCrc9ZY5flx9rmLxKoPEA4Jfrc
 bFnkpj3XSM0M41ay0RdOd/hHeDTiRSR93+N+HwLzcefgrIFDhM31b+b9KjwtICX0T3xF
 W3EoWHba/DvVOpJmtlPjwdvn+0qZKvS3yUs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3edupnv4dp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:52:05 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 02:52:01 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 0AE504996E27; Thu, 24 Feb 2022 02:51:58 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: documentation fixup
Date:   Thu, 24 Feb 2022 02:51:57 -0800
Message-ID: <20220224105157.1332353-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ChH8fLeOCZOXKtQ5WRh8uyu0qNWtf9dI
X-Proofpoint-GUID: ChH8fLeOCZOXKtQ5WRh8uyu0qNWtf9dI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 mlxlogscore=896 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240063
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix incorrect name reference in comment. ki_filp does not exist in the
struct, but file does.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e796d40ee8e9..8f26c4602384 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -830,7 +830,7 @@ enum {
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
  * access the file pointer through any of the sub-structs,
- * or directly as just 'ki_filp' in this struct.
+ * or directly as just 'file' in this struct.
  */
 struct io_kiocb {
 	union {

base-commit: f78708d0a1802ca7c44c4131d08f3883d0b8e9b8
--=20
2.30.2

