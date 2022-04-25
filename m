Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7426F50DCDE
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbiDYJkN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbiDYJjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 05:39:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F66465
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:31 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23OMWLL6001304
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=5ZfW4xYkW2nF3DD2Ayn40Sk7NTdO2yfSixyEYfqRfn8=;
 b=QeHj3KaW6ZVpjiJA9IYeJBgIYs9XrB6beGiGBXPhg05YsTCLB1YySI+68drcBHe1C0ps
 GZL202lzuzpG3VQZ8VeogzzHbCQQ1qtmBYatVLU7w13ByYXES5VxwHb3Qfv9x15yvwX3
 KwuaYaPjYiYcyOynOlOjdB3jS6fSH1tPcb8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmcsgs52w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 02:36:31 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 02:36:28 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id E630480E0995; Mon, 25 Apr 2022 02:36:19 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/3] text representation of opcode in trace
Date:   Mon, 25 Apr 2022 02:36:10 -0700
Message-ID: <20220425093613.669493-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: BZ6l4UTfc8DwrHwIbv8LpH3YZZauZyDz
X-Proofpoint-ORIG-GUID: BZ6l4UTfc8DwrHwIbv8LpH3YZZauZyDz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_06,2022-04-22_01,2022-02-23_01
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

Patch 1 is the translation function.
Patch 2 is a small cleanup
Patch 3 uses the translator in the trace logic

Dylan Yudaken (3):
  io_uring: add io_uring_get_opcode
  io_uring: rename op -> opcode
  io_uring: use the text representation of ops in trace

 fs/io_uring.c                   | 91 +++++++++++++++++++++++++++++++++
 include/linux/io_uring.h        |  5 ++
 include/trace/events/io_uring.h | 42 +++++++++------
 3 files changed, 121 insertions(+), 17 deletions(-)


base-commit: 155bc9505dbd6613585abbf0be6466f1c21536c4
--=20
2.30.2

