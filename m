Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45350F4B4
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 10:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346046AbiDZIju (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 04:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345286AbiDZIhq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 04:37:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC78490CE4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:27 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q1NoRc016311
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=91JCWhzdgi9rHV5WV7OrxxcoeIXNcDKXuHb86QjxE+s=;
 b=UpjLBOOkhZlmDuiLDdKhtl+CULYgPLIJl+Ktwjlxie9gQKXxViyeRZl0ZV7yQ7wAMu7L
 sAVxSW090Oc1EcoRcO8iRXYAvAFLH/eGMolFJAiI3I9h7GpOCyCXvRHDGxAPWYEcHndv
 Q9Zp+s9UP6Z3obejT0SQKc3LZzMdftVFvMk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1gdvq5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 01:29:26 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 01:29:26 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id A8B3881D593A; Tue, 26 Apr 2022 01:29:13 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 0/4] io_uring: text representation of opcode in trace
Date:   Tue, 26 Apr 2022 01:29:03 -0700
Message-ID: <20220426082907.3600028-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: y4QAZYEzynfaOHNds1STRs5Qgl9ISxZR
X-Proofpoint-GUID: y4QAZYEzynfaOHNds1STRs5Qgl9ISxZR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


This series adds the text representation of opcodes into the trace. This
makes it much quicker to understand traces without having to translate
opcodes in your head.

Patch 1 adds a type to io_uring opcodes
Patch 2 is the translation function.
Patch 3 is a small cleanup
Patch 4 uses the translator in the trace logic

v2:
 - return "INVALID" rather than UNKNOWN/LAST
 - add a type to io_uring opcdodes to get the compiler to complain if any=
 are
   missing

v3:
  - rebase onto for-5.19/io_uring-socket

Dylan Yudaken (4):
  io_uring: add type to op enum
  io_uring: add io_uring_get_opcode
  io_uring: rename op -> opcode
  io_uring: use the text representation of ops in trace

 fs/io_uring.c                   | 101 ++++++++++++++++++++++++++++++++
 include/linux/io_uring.h        |   5 ++
 include/trace/events/io_uring.h |  42 +++++++------
 include/uapi/linux/io_uring.h   |   2 +-
 4 files changed, 132 insertions(+), 18 deletions(-)


base-commit: 1374e08e2d44863c931910797852589803997668
--=20
2.30.2

