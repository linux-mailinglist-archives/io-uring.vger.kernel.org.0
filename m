Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8417D4FE5DE
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357696AbiDLQdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357698AbiDLQd3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:33:29 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3DA5E14C
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:00 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23C9IF60029511
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RuVFmwVdExl/MSNgXRVfM40+Dn5quq+Xx3wa/wo0YZg=;
 b=YU4IXVG54QSv/U92CSB4orcEqCT+laHyTbGiLeOWy58ZTe2lEuzHgkshiyvvM2EOUK5n
 Apnz09nGKH5IiqPd8k3Kwac2AuPQPfPesiJY3+dWDjaB6n49LzdAbD7rfjC7i/RI3QLm
 agdm5/Ty+WrHTymRQjetoPqUEohL5w5XCKk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fd6p3t9x3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 12 Apr 2022 09:30:57 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 5042D745606E; Tue, 12 Apr 2022 09:30:49 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 4/4] io_uring: verify pad field is 0 in io_get_ext_arg
Date:   Tue, 12 Apr 2022 09:30:42 -0700
Message-ID: <20220412163042.2788062-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412163042.2788062-1-dylany@fb.com>
References: <20220412163042.2788062-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: z0GMDYnOpXwrNaQmlqsNr9jJZSbIWz3x
X-Proofpoint-GUID: z0GMDYnOpXwrNaQmlqsNr9jJZSbIWz3x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure that only 0 is passed for pad here.

Fixes: c73ebb685fb6 ("io_uring: add timeout support for io_uring_enter()"=
)
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a84bfec97d0d..6b1a98697dcf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10711,6 +10711,8 @@ static int io_get_ext_arg(unsigned flags, const v=
oid __user *argp, size_t *argsz
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
+	if (arg.pad)
+		return -EINVAL;
 	*sig =3D u64_to_user_ptr(arg.sigmask);
 	*argsz =3D arg.sigmask_sz;
 	*ts =3D u64_to_user_ptr(arg.ts);
--=20
2.30.2

