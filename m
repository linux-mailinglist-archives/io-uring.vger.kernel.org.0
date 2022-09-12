Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14A55B61C0
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiILT2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiILT22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7324455E
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:24 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CG6lUU003051
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ChjfSENQchEUBM4cPfbpSt1QO05k//yXuIWwWjuVJaY=;
 b=pakKpLO8FmSLNVjyONwmzsdGLp6w8Oudhf6n+b+BgYnfg8b90pWxLv3VfkmjBcFKxQ+B
 qMGy566NT/Qco6I7r5FApmAPpc+uU+pblE+sjHP64Bi9VDaWoZLuvbDsEQ71cZCFn9GG
 Jz89GMOfT1CUkdhjSiYSVKlp99qgoUJKddw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgr9smhan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:23 -0700
Received: from twshared13579.04.prn5.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:22 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 311CF208523E; Mon, 12 Sep 2022 12:27:54 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 12/12] btrfs: enable nowait async buffered writes
Date:   Mon, 12 Sep 2022 12:27:52 -0700
Message-ID: <20220912192752.3785061-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jZDVdxTI6BULXZo2bQLIHJP1v3d4Pyp5
X-Proofpoint-GUID: jZDVdxTI6BULXZo2bQLIHJP1v3d4Pyp5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_13,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable nowait async buffered writes in btrfs_do_write_iter() and
btrfs_file_open().

In this version encoded buffered writes have the optimization not
enabled. Encoded writes are enabled by using an ioctl. io-uring
currently do not support ioctl's. This might be enabled in the future.

Performance results:
  For fio the following results have been obtained with a queue depth of
  1 and 4k block size (runtime 600 secs):

                 sequential writes:
                 without patch           with patch      libaio     psync
  iops:              55k                    134k          117K       148K
  bw:               221MB/s                 538MB/s       469MB/s    592M=
B/s
  clat:           15286ns                    82ns         994ns     6340n=
s

For an io depth of 1, the new patch improves throughput by over two times
(compared to the exiting behavior, where buffered writes are processed by=
 an
io-worker process) and also the latency is considerably reduced. To achie=
ve the
same or better performance with the exisiting code an io depth of 4 is re=
quired.
Increasing the iodepth further does not lead to improvements.

The tests have been run like this:
./fio --name=3Dseq-writers --ioengine=3Dpsync --iodepth=3D1 --rw=3Dwrite =
\
  --bs=3D4k --direct=3D0 --size=3D100000m --time_based --runtime=3D600   =
\
  --numjobs=3D1 --filename=3D...
./fio --name=3Dseq-writers --ioengine=3Dio_uring --iodepth=3D1 --rw=3Dwri=
te \
  --bs=3D4k --direct=3D0 --size=3D100000m --time_based --runtime=3D600   =
\
  --numjobs=3D1 --filename=3D...
./fio --name=3Dseq-writers --ioengine=3Dlibaio --iodepth=3D1 --rw=3Dwrite=
 \
  --bs=3D4k --direct=3D0 --size=3D100000m --time_based --runtime=3D600   =
\
  --numjobs=3D1 --filename=3D...

Testing:
  This patch has been tested with xfstests, fsx, fio. xfstests shows no n=
ew
  diffs compared to running without the patch series.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4dc6484ff229..16052903fa82 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2107,13 +2107,13 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, s=
truct iov_iter *from,
 	if (BTRFS_FS_ERROR(inode->root->fs_info))
 		return -EROFS;
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
-		return -EOPNOTSUPP;
-
 	if (sync)
 		atomic_inc(&inode->sync_writers);
=20
 	if (encoded) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EOPNOTSUPP;
+
 		num_written =3D btrfs_encoded_write(iocb, from, encoded);
 		num_sync =3D encoded->len;
 	} else if (iocb->ki_flags & IOCB_DIRECT) {
@@ -3755,7 +3755,7 @@ static int btrfs_file_open(struct inode *inode, str=
uct file *filp)
 {
 	int ret;
=20
-	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
=20
 	ret =3D fsverity_file_open(inode, filp);
 	if (ret)
--=20
2.30.2

