Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC64FE5DD
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357675AbiDLQd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349863AbiDLQd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:33:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D0B5E147
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23C0jrtH032695
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=aieyOoQjElV+1yHY4ofNprLGHOfx4cTB9R/S9Mt9YWM=;
 b=kTPBHuGjkQ4l/Mu81WgtVpG7SpzFExkrcLl3/kEHKJ3zoowyFxr5Z0Kk4RAuF633tzQX
 EwzalpGbfkqbjBm8Vr6sLrslNLpntewyDuDE90dJoc/atgDT45snWZIUU/OpzbxHVSHS
 y4v9IvWA/GDlicg45DdLMpJ1GnT2x83Esrk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fcy5qv47u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 12 Apr 2022 09:30:57 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 16E457456060; Tue, 12 Apr 2022 09:30:47 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/4] io_uring: verify that reserved fields are 0
Date:   Tue, 12 Apr 2022 09:30:38 -0700
Message-ID: <20220412163042.2788062-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lg5y0r-wZgQhnodLxsCkm9W2tBi9sgVY
X-Proofpoint-GUID: lg5y0r-wZgQhnodLxsCkm9W2tBi9sgVY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A few reserved fields are not verified to be 0. In preparation for possib=
ly using these fields later we should verify that they are passed as 0.

One extra field I do not have confidence in verifying is up.nr in io_regi=
ster_files_update(). Should this also be checked to be zero?

Patch 1 in this series just moves a validation out of __io_register_rsrc_=
update as it was duplicated
Patch 2-4 add verifications for reserved fields

Dylan Yudaken (4):
  io_uring: move io_uring_rsrc_update2 validation
  io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
  io_uring: verify resv is 0 in ringfd register/unregister
  io_uring: verify pad field is 0 in io_get_ext_arg

 fs/io_uring.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


base-commit: 0f8da75b51ac863b9435368bd50691718cc454b0
--=20
2.30.2

