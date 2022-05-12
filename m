Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0B05248B7
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349939AbiELJSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 05:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242267AbiELJSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 05:18:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5856D205F2C
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:40 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwZc3022802
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=lC/lTbS1Cac4ah+UjmCrGwZl1dCdRXDsBkCYI6bUECo=;
 b=eAquaO422+CLCZX27/dM09ACxwlYorP2Xjo8nnc8XGyUR/a4hdDko14XHId0OyEJTRN8
 zIDeEuMAwjXDWtpaGv5PoyyZIjQ/UtepLIzwCqlwObc8OYrEgzr/mfs4OMSvVfUIwhbt
 KRulikZGIAsUNjdB2pqSoUO6bF3ZKQcuFcE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g055hs34u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 02:18:40 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 02:18:38 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 190198F02238; Thu, 12 May 2022 02:18:36 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/2] Fix poll bug
Date:   Thu, 12 May 2022 02:18:32 -0700
Message-ID: <20220512091834.728610-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: c3d-lca4ECQnPTdp7evoZ1rvO1EIONtK
X-Proofpoint-GUID: c3d-lca4ECQnPTdp7evoZ1rvO1EIONtK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This fixes a bug in poll wakeups, where it would wake up
unnecessarily. This is most obvious with sockets, where the socket will
wake both readers and writers when new read data is available, even if th=
e
socket is still not writable.

Patch 1 is a simple bug I noticed while debugging the poll problem
Patch 2 is the poll fix

Dylan Yudaken (2):
  io_uring: fix ordering of args in io_uring_queue_async_work
  io_uring: only wake when the correct events are set

 fs/io_uring.c                   | 5 +++--
 include/trace/events/io_uring.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)


base-commit: f569add47119fa910ed7711b26b8d38e21f7ea77
--=20
2.30.2

