Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8B5483F9
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 12:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiFMKMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 06:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiFMKMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 06:12:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96113B7
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:11 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D6RDjK005867
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=PWBsxGAUN5tLRemPSHT4sBleAsAvBvu9zOxMlI4MrMY=;
 b=USxRchZlfu/N+ldsGgykwJ1cNnBh1uzPNA5PGTfHvYo5YlPeWZdjPiubpIZl+LtlcuQz
 1xhU6TQurIemA4UvCXKG63YM1sYoQ2+Js++OMpLoPVljxk9Q6IZNQelQK07ph49myulv
 kt722r7jcIZ/pds7Il6GEsG3LblFQkG7t8M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmrjxycpr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:10 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 03:12:06 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1A2301992ADD; Mon, 13 Jun 2022 03:12:04 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/3] io_uring: fixes for provided buffer ring
Date:   Mon, 13 Jun 2022 03:11:54 -0700
Message-ID: <20220613101157.3687-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -uertzbvaCxNkLJAhW9DvmjfLU1WBeQW
X-Proofpoint-ORIG-GUID: -uertzbvaCxNkLJAhW9DvmjfLU1WBeQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This fixes two problems in the new provided buffer ring feature. One
is a simple arithmetic bug (I think this came out from a refactor).
The other is due to type differences between head & tail, which causes
it to sometimes reuse an old buffer incorrectly.

Patch 1&2 fix bugs
Patch 3 limits the size of the ring as it's not
possible to address more entries with 16 bit head/tail

I will send test cases for liburing shortly.

One question might be if we should change the type of ring_entries
to uint16_t in struct io_uring_buf_reg?

Dylan Yudaken (3):
  io_uring: fix index calculation
  io_uring: fix types in provided buffer ring
  io_uring: limit size of provided buffer ring

 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
--=20
2.30.2

