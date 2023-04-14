Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAB6E2C98
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 00:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDNWze (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 18:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNWzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 18:55:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C34365AE
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:31 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 33EMsf7X001789
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=Mp2irU7H2qJwQZBSyHOcqvf0/VmcQsjcST8tdRRfLsM=;
 b=nKLiGyhTSHLp+BnCM05UT5rQKVyqezL9AFKG6Y+/qB1lFqoK7mwZ90eKEH1XZGLWMyP5
 hjevtBEvkivAgbOg4xxrYZEDRxN13PDsGECQq9CIXf5xdY+Bs6vre0eUa5HgbQQPOsmD
 QlfB2lUPdDaRiup5lAa3pfkQFjQEqU17tKR2IWA7+pSjfYWUGzR9pytyjk1L38ocnEjh
 zyU+K7DeirevKCcMH/IHemC/FvbfvjAYrTdmWgYpEG7eU1iUQHcYM2FauGn8z06+LFxy
 2/OL/xoTBkmmCIxzrq/sUM4bRl1jtaSp1YO0msDZk1MhPFckzNFKZR0LhpjAcU1czvdn AA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3pybpnsm97-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 15:55:30 -0700
Received: from twshared8568.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 14 Apr 2023 15:55:28 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id DD2AD8EDA7FA; Fri, 14 Apr 2023 15:55:24 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH v3 0/2] liburing: multishot timeout support
Date:   Fri, 14 Apr 2023 15:55:04 -0700
Message-ID: <20230414225506.4108955-1-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YwK6EJ7NGpptIwjZ-4F224Er6x2BZTQ4
X-Proofpoint-GUID: YwK6EJ7NGpptIwjZ-4F224Er6x2BZTQ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Changes on the liburing side to support multishot timeouts.

Changes since v2:

* Edited man page for io_uring_prep_timeout.3

David Wei (2):
  liburing: add multishot timeout support
  liburing: update man page for multishot timeouts

 man/io_uring_prep_timeout.3     |   7 +
 src/include/liburing/io_uring.h |   1 +
 test/timeout.c                  | 263 ++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+)

--=20
2.34.1

