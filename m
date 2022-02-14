Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427F64B594D
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiBNSEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 13:04:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350259AbiBNSEp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 13:04:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B2760D9A
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:04:37 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21EI1xYe006932
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:04:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=fg+Q5ikBcF4fYhVds3w69f3Evg2g2beVJyOiZLxZ6g8=;
 b=cIOF8yM93BdjTZihiRU7760/GV5N9ZH1TLPry9U7TGGUYoO3kFVOzvS1UVw6yRPnWITb
 0ivNHa+Tz4O0+manMJyKmSMiTyIKL4H++kCU7bI9nK2P3a+mNCBPnTse3JTn9JCpFe6G
 E8KuEj8cs3r0kUFWZhswEvOhl/MLLcUMxQU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7hv53sns-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 10:04:36 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 10:04:36 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C1C06ABC0529; Mon, 14 Feb 2022 10:04:33 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/2] io-uring: use consisten tracepoint format
Date:   Mon, 14 Feb 2022 10:04:28 -0800
Message-ID: <20220214180430.70572-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NN0uEDHHbxcNnh4wjbZCurwOteZZrS8v
X-Proofpoint-GUID: NN0uEDHHbxcNnh4wjbZCurwOteZZrS8v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 mlxlogscore=453 priorityscore=1501 malwarescore=0 phishscore=0
 clxscore=1015 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202140107
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So far the tracepoints haven't used a consistent format. This change
adds consistent formatting for the io-uring tracepoints. This makes it
easier to follow individual requests.

Where it makes sense it uses the following format:
- context structure pointer
- request structure pointer
- user data
- opcode.



Stefan Roesch (2):
  io-uring: add __fill_cqe function
  io-uring: Make tracepoints consistent.

 fs/io_uring.c                   |  42 +++--
 include/trace/events/io_uring.h | 320 +++++++++++++++-----------------
 2 files changed, 178 insertions(+), 184 deletions(-)


base-commit: 754e0b0e35608ed5206d6a67a791563c631cec07
--=20
2.30.2

