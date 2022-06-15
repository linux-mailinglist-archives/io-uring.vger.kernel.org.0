Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CAB54C2C0
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiFOHkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiFOHki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 03:40:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74023A1A2
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:37 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EMcwoM032248
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=1iLpqixpOOn54MkERNpMuTCkjO5ZMCGuPdV7QkEPGHM=;
 b=HYMBSKe7QIyX2bHUfwGSS86snvIuLxtD/0dI+ZxQqDSLGfScKU052dYK977mUrzXGwZ1
 wjqews8TvUTTnxrBhbkDxvccoNPxPenvVWnzqUtNyIhVEXO/DNueBP4+4EqcpA38Ic0d
 NGqAfS4iTIzmd4+4kuxTBBzxhh4l/XWK2YM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gpddasf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:37 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 15 Jun 2022 00:40:35 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 12A291AEE43E; Wed, 15 Jun 2022 00:40:27 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/2] revert buf-ring test
Date:   Wed, 15 Jun 2022 00:40:23 -0700
Message-ID: <20220615074025.124322-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nHV1utEw9gsUqN7ArRcsrGFB1ilbPuPO
X-Proofpoint-ORIG-GUID: nHV1utEw9gsUqN7ArRcsrGFB1ilbPuPO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Revert the two patches for the buf-ring test as the NOP support is being
removed from 5.19

Dylan Yudaken (2):
  Revert "test/buf-ring: ensure cqe isn't used uninitialized"
  Revert "buf-ring: add tests that cycle through the provided buffer
    ring"

 test/buf-ring.c | 130 ------------------------------------------------
 1 file changed, 130 deletions(-)


base-commit: d6f9e02f9c6a777010824341f14c994b11dfc8b1
--=20
2.30.2

