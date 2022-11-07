Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E18561FC68
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 18:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiKGR7y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 12:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiKGR7i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 12:59:38 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC9B2A40C
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 09:56:19 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7Glixl007970
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 09:56:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=rKbQINmKWukh6tJOjHplZmnS+uoDK4d+/tWup2ptUOI=;
 b=QERIf5uzyf0uePa9WfFL07fW4ypnjP0s8jekVkXvgWhdyUTaCLWc5I4lhjWPZLuSplwZ
 nWdTiZSHbj3Sf//JZxCVNd9YVpXbgHwZKbHZQbgCoc6I1C7+u1vN1qJJ3fnQ54Zw4rND
 hymXybvrcraJj+4VKnF883NY10Ac75SZLES8e/HPaMz+pMU9XtvF/e/g7G3rUVLAwkHa
 7rUH5tbCfkTxYIrYtgj3PJqCa0yRRsI1NoPNpRCMKcZrfjHJHeogSx7QbLDBYvB8zaW3
 bvoP2bQvW1FJ9YEf4YD4xZsu5+kNz7V82GVH1READx99gnYhuwTU/1iWUFIwDRnMTXry YA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knmxss1mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 09:56:19 -0800
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 09:56:18 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 5C25FADF1C96; Mon,  7 Nov 2022 09:56:11 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <linux-fsdevel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 0/4] io_uring: use ITER_UBUF
Date:   Mon, 7 Nov 2022 09:56:06 -0800
Message-ID: <20221107175610.349807-1-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2f06ZlmvkR19rYQhvtRUrTUj6nr31nX-
X-Proofpoint-GUID: 2f06ZlmvkR19rYQhvtRUrTUj6nr31nX-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

ITER_UBUF is a more efficient representation when using single vector
buffers, providing small optimizations in the fast path. Most of this
series came from Jens; I just ported them forward to the current release
and tested against various filesystems and devices.

Usage for this new iter type has been extensively exercised via
read/write syscall interface for some time now, so I don't expect
surprises from supporting this with io_uring. There are, however, a
couple difference between the two interfaces:

  1. io_uring will always prefer using the _iter versions of read/write
     callbacks if file_operations implement both, where as the generic
     syscalls will use .read/.write (if implemented) for non-vectored IO.
=20
  2. io_uring will use the ITER_UBUF representation for single vector
     readv/writev, but the generic syscalls currently uses ITER_IOVEC for
     these.

That should mean, then, the only potential areas for problem are for
file_operations that implement both .read/.read_iter or
.write/.write_iter. Fortunately there are very few that do that, and I
found only two of them that won't readily work: qib_file_ops, and
snd_pcm_f_ops. The former is already broken with io_uring before this
series, and the latter's vectored read/write only works with ITER_IOVEC,
so that will break, but I don't think anyone is using io_uring to talk
to a sound card driver.

Jens Axboe (3):
  iov: add import_ubuf()
  io_uring: switch network send/recv to ITER_UBUF
  io_uring: use ubuf for single range imports for read/write

Keith Busch (1):
  iov_iter: move iter_ubuf check inside restore WARN

 include/linux/uio.h |  1 +
 io_uring/net.c      | 13 ++++---------
 io_uring/rw.c       |  9 ++++++---
 lib/iov_iter.c      | 15 +++++++++++++--
 4 files changed, 24 insertions(+), 14 deletions(-)

--=20
2.30.2

