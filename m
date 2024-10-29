Return-Path: <io-uring+bounces-4134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6DD9B504F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1B861C22A1F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEAE19992D;
	Tue, 29 Oct 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Pp6z8qvE"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042202107
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222608; cv=none; b=ZqiYJO6VrImIkSsueZm4EDUCOReTUvG+m40doCvslikTYf66QwqJR0z1+qnLe6hyFsjbODStpiTi+D27aKKzz+MI2JRnU1oP7p2x7so0MFvjdlqbZm3M7wIMllDr0gUaw7Cjscs+RO0CtXQkE6vEOzWbxn6MUpupjXgmfR3fJ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222608; c=relaxed/simple;
	bh=gEeBUncaGG6VOEBdFic4nzwQmdJRDUuOC3NR3ncyyRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=MbnUNwN1dgSllazbpzVxQw3SHjz8sx5rLg4Jkr9tSQ1QexCIqSdqrgkzRW0sE2qEO6b/Jgw+9ch0TDau8RvLFC3o4BXzA7y6TsA+UyJFnlRZRhuYd9oq/jymyPMucMn/ODSC6do4TQ2Xv59LgV2GyYOzP/zNIzGqo9aX+KCKecc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Pp6z8qvE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241029172316epoutp03a11f11ffb733a086a91278b1f8868683~C-Ei6CGbU0223102231epoutp03N
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241029172316epoutp03a11f11ffb733a086a91278b1f8868683~C-Ei6CGbU0223102231epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222596;
	bh=GjZAGo3wUEjj7FyWUUD5ob2LNyJHmYJnieKf4stef7w=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Pp6z8qvEp8FgZ6Dg+Txa5AfYXS8H3pCl/9DE5r5pSbo9VRkktSTPn7+tJOnjgl9NN
	 tT3k+fv4x66LP56jWwM5fEQYNHKkPZvnQmnkC2wLxMfxgIAIVcgmO0jCvPGIctF6ih
	 sEaqxSO12d880RxfWH5AOLjJdFTLgZVcq+z0BFLM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241029172315epcas5p2d887a4173ab905f78a9cbc0a004c2882~C-EiAGYtx0233202332epcas5p2p;
	Tue, 29 Oct 2024 17:23:15 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdHCQ09zxz4x9Pt; Tue, 29 Oct
	2024 17:23:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0C.C6.08574.10A11276; Wed, 30 Oct 2024 02:23:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241029163153epcas5p4ab83a94429a227bfc262423aa8a8dd26~C_XrwgEwN0724607246epcas5p4t;
	Tue, 29 Oct 2024 16:31:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241029163153epsmtrp1abc49daf64e699dcc51eade429bbf1e2~C_XrvkNqd0723107231epsmtrp1I;
	Tue, 29 Oct 2024 16:31:53 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-db-67211a01c1bc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5D.57.08229.9FD01276; Wed, 30 Oct 2024 01:31:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163150epsmtip2e9d58917a57d8b477319e04587f76a3d~C_XpbEg7W1012410124epsmtip28;
	Tue, 29 Oct 2024 16:31:50 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v5 00/10] Read/Write with meta/integrity
Date: Tue, 29 Oct 2024 21:53:52 +0530
Message-Id: <20241029162402.21400-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmui6jlGK6waT5phYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbXLVeYCnZFV8zb8pKxgfGoUxcjJ4eEgInEpb7X
	rF2MXBxCArsZJU4t2cUE4XxilPh1qp0NwvnGKNH78wobTMvD/81QVXsZJbbfmwrlfGaUOLNp
	HlgVm4C6xJHnrYwgCRGBPUDtC0+zgDjMAi8ZJZauWsQCUiUsYCGxof8NI4jNIqAq8a9xOzOI
	zStgKbHp/gEmiH3yEjMvfWeHiAtKnJz5BKyXGSjevHU2M8hQCYEdHBI3532COtBF4si9iewQ
	trDEq+NboGwpiZf9bVB2usSPy0+hFhRINB/bxwhh20u0nuoHGsoBtEBTYv0ufYiwrMTUU+uY
	IPbySfT+fgLVyiuxYx6MrSTRvnIOlC0hsfdcA5TtIfHy/k8WkJFCArESh/cWTGCUn4Xkm1lI
	vpmFsHgBI/MqRsnUguLc9NRk0wLDvNRyeNQm5+duYgSnay2XHYw35v/TO8TIxMF4iFGCg1lJ
	hHd1rGy6EG9KYmVValF+fFFpTmrxIUZTYBBPZJYSTc4HZoy8knhDE0sDEzMzMxNLYzNDJXHe
	161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYog9zZMqvaeq3tvS8OT3zDt9Pfj+eb5dyYu8sWi0V
	vXdKaZbs88UXolvPs6scvHVKpPnMgdMzHHtjVd/nrW/3/nVLJ/m610NV96u57p9mT3M2uLgs
	5aP/Frbvi62v3u+bUdZz+5Mn+yYh7/J/t7MtBa4tXD7x6YH+2qtr+6we8yceNZsxqe555Hv9
	5Qq+uX2zt/u0XVLzLko/dGrdXWV7hmhz32O3dwht8F+xxdze4JDdt/tM0ou4J619zu2RbHZv
	R1L+fE2PY9IiB6L2BR590sT2K+B+0C7Gu0dEVeTPbGLUOn24ynDR1lWhtjG8FQ8Pl68/2lVU
	IZK7QMb+/TX/1POf3nw++1PjdNGfKfFbTZRYijMSDbWYi4oTAQ6cdydgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvO5PXsV0g21fOC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxtctV5gKdkVXzNvykrGB
	8ahTFyMnh4SAicTD/81MXYxcHEICuxklFu3/yQ6RkJA49XIZI4QtLLHy33N2iKKPjBKdW7Yx
	gSTYBNQljjxvBSsSETjBKDF/ohtIETNI0YQvs1lAEsICFhIb+t+AFbEIqEr8a9zODGLzClhK
	bLp/gAlig7zEzEvf2SHighInZz4B62UGijdvnc08gZFvFpLULCSpBYxMqxglUwuKc9Nziw0L
	DPNSy/WKE3OLS/PS9ZLzczcxgiNHS3MH4/ZVH/QOMTJxMB5ilOBgVhLhXR0rmy7Em5JYWZVa
	lB9fVJqTWnyIUZqDRUmcV/xFb4qQQHpiSWp2ampBahFMlomDU6qBybti/fQTO5+48u1c11k5
	k83TgDs8+KSphL8EU7wM66TgCRwvpvlvM9u38I1mT1DirOWftaLntT52viXdNK9S/4xz8lXP
	jH6fa51nlnn3Ox7nZbxy3ED1oNTrn4Lzlx9hZwj8bxe0Vdxq/s25x321ZG+ZJ7v7zdDgSnud
	ffr9Vt3EyTxWpT6eP/a+YtvqLdWj4d67+/eJzRKP5rgX7yqucLf87Ca6R+mQnGvrZZfwm+4f
	GZ62v5JKvP3tx8qFXx7HfZnSHy2rax6b+v/krmbO6oSV5yxqLePZyu882SDZuH5yZhXrZg3J
	y7l1DLtanWWu3bwp777QW53vSf/7S6m7JdLavKdlOG0RCly0a2ODEktxRqKhFnNRcSIAWt9X
	6wsDAAA=
X-CMS-MailID: 20241029163153epcas5p4ab83a94429a227bfc262423aa8a8dd26
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163153epcas5p4ab83a94429a227bfc262423aa8a8dd26
References: <CGME20241029163153epcas5p4ab83a94429a227bfc262423aa8a8dd26@epcas5p4.samsung.com>

This adds a new io_uring interface to exchange meta along with read/write.

The patchset is on top block for-next [1] and keith's cleanup patch [2].

Interface:
A new meta_type field is introduced in SQE, which describes type of meta
that is passed. Currently only one type "PI" is supported. Meta information
is represented using a newly introduced 'struct io_uring_meta_pi'.
Application sets up a SQE128 ring, and prepares io_uring_meta_pi within
second SQE. Application populates 'struct io_uring_meta_pi' fields as below:

* pi_flags: these are meta-type specific flags. Three flags are exposed for
integrity type, namely IO_INTEGRITY_CHK_GUARD/APPTAG/REFTAG.
* len: length of the meta buffer
* addr: address of the meta buffer
* seed: seed value for ref tag remapping
* app_tag: optional application-specific 16b value; this goes along with
INTEGRITY_CHK_APPTAG flag.
* rsvd: reserved space for storage tag.

Block path (direct IO) , NVMe and SCSI driver are modified to support
this.

Patch 1 is an enhancement patch.
Patch 2 is required to make the bounce buffer copy back work correctly.
Patch 3 to 5 are prep patches.
Patch 6 adds the io_uring support.
Patch 7 gives us unified interface for user and kernel generated
integrity.
Patch 8 adds support in SCSI and patch 9 in NVMe.
Patch 10 adds the support for block direct IO.

Some of the design choices came from this discussion [3].

Example program on how to use the interface is appended below [4]
(It also tests whether reftag remapping happens correctly or not)

Tree:
https://github.com/SamsungDS/linux/tree/feat/pi_us_v5
Testing:
has been done by modifying fio to use this interface.
https://github.com/SamsungDS/fio/tree/priv/feat/pi-test-v6

Changes since v4;
https://lore.kernel.org/linux-block/20241016112912.63542-1-anuj20.g@samsung.com/

- better variable names to describe bounce buffer copy back (hch)
- move defintion of flags in the same patch introducing uio_meta (hch)
- move uio_meta definition to include/linux/uio.h (hch)
- bump seed size in uio_meta to 8 bytes (martin)
- move flags definition to include/uapi/linux/fs.h (hch)
- s/meta/metadata in commit description of io-uring (hch)
- rearrange the meta fields in sqe for cleaner layout
- partial submission case is not applicable as, we are only plumbing for async case
- s/META_TYPE_INTEGRITY/META_TYPE_PI (hch, martin)
- remove unlikely branching (hch)
- Better formatting, misc cleanups, better commit descriptions, reordering commits(hch)

Changes since v3:
https://lore.kernel.org/linux-block/20240823103811.2421-1-anuj20.g@samsung.com/

- add reftag seed support (Martin)
- fix incorrect formatting in uio_meta (hch)
- s/IOCB_HAS_META/IOCB_HAS_METADATA (hch)
- move integrity check flags to block layer header (hch)
- add comments for BIP_CHECK_GUARD/REFTAG/APPTAG flags (hch)
- remove bio_integrity check during completion if IOCB_HAS_METADATA is set (hch)
- use goto label to get rid of duplicate error handling (hch)
- add warn_on if trying to do sync io with iocb_has_metadata flag (hch)
- remove check for disabling reftag remapping (hch)
- remove BIP_INTEGRITY_USER flag (hch)
- add comment for app_tag field introduced in bio_integrity_payload (hch)
- pass request to nvme_set_app_tag function (hch)
- right indentation at a place in scsi patch (hch)
- move IOCB_HAS_METADATA to a separate fs patch (hch)

Changes since v2:
https://lore.kernel.org/linux-block/20240626100700.3629-1-anuj20.g@samsung.com/
- io_uring error handling styling (Gabriel)
- add documented helper to get metadata bytes from data iter (hch)
- during clone specify "what flags to clone" rather than
"what not to clone" (hch)
- Move uio_meta defination to bio-integrity.h (hch)
- Rename apptag field to app_tag (hch)
- Change datatype of flags field in uio_meta to bitwise (hch)
- Don't introduce BIP_USER_CHK_FOO flags (hch, martin)
- Driver should rely on block layer flags instead of seeing if it is
user-passthrough (hch)
- update the scsi code for handling user-meta (hch, martin)

Changes since v1:
https://lore.kernel.org/linux-block/20240425183943.6319-1-joshi.k@samsung.com/
- Do not use new opcode for meta, and also add the provision to introduce new
meta types beyond integrity (Pavel)
- Stuff IOCB_HAS_META check in need_complete_io (Jens)
- Split meta handling in NVMe into a separate handler (Keith)
- Add meta handling for __blkdev_direct_IO too (Keith)
- Don't inherit BIP_COPY_USER flag for cloned bio's (Christoph)
- Better commit descriptions (Christoph)

Changes since RFC:
- modify io_uring plumbing based on recent async handling state changes
- fixes/enhancements to correctly handle the split for meta buffer
- add flags to specify guard/reftag/apptag checks
- add support to send apptag


[1] https://git.kernel.dk/cgit/linux-block/log/?h=for-next

[2] https://lore.kernel.org/linux-block/20241016201309.1090320-1-kbusch@meta.com/

[3] https://lore.kernel.org/linux-block/20240705083205.2111277-1-hch@lst.de/

[4]

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/fs.h>
#include <linux/io_uring.h>
#include <linux/types.h>
#include "liburing.h"

/*
 * write data/meta. read both. compare. send apptag too.
 * prerequisite:
 * protected xfer: format namespace with 4KB + 8b, pi_type = 1
 * For testing reftag remapping on device-mapper, create a
 * device-mapper and run this program. Device mapper creation:
 * # echo 0 80 linear /dev/nvme0n1 0 > /tmp/table
 * # echo 80 160 linear /dev/nvme0n1 200 >> /tmp/table
 * # dmsetup create two /tmp/table
 * # ./a.out /dev/dm-0
 */

#define DATA_LEN 4096
#define META_LEN 8

struct t10_pi_tuple {
        __be16  guard;
        __be16  apptag;
        __be32  reftag;
};

int main(int argc, char *argv[])
{
         struct io_uring ring;
         struct io_uring_sqe *sqe = NULL;
         struct io_uring_cqe *cqe = NULL;
         void *wdb,*rdb;
         char wmb[META_LEN], rmb[META_LEN];
         char *data_str = "data buffer";
         int fd, ret, blksize;
         struct stat fstat;
         unsigned long long offset = DATA_LEN * 10;
         struct t10_pi_tuple *pi;
         struct io_uring_meta_pi *md;

         if (argc != 2) {
                 fprintf(stderr, "Usage: %s <block-device>", argv[0]);
                 return 1;
         };

         if (stat(argv[1], &fstat) == 0) {
                 blksize = (int)fstat.st_blksize;
         } else {
                 perror("stat");
                 return 1;
         }

         if (posix_memalign(&wdb, blksize, DATA_LEN)) {
                 perror("posix_memalign failed");
                 return 1;
         }
         if (posix_memalign(&rdb, blksize, DATA_LEN)) {
                 perror("posix_memalign failed");
                 return 1;
         }

         memset(wdb, 0, DATA_LEN);

         fd = open(argv[1], O_RDWR | O_DIRECT);
         if (fd < 0) {
                 printf("Error in opening device\n");
                 return 0;
         }

         ret = io_uring_queue_init(8, &ring, IORING_SETUP_SQE128);
         if (ret) {
                 fprintf(stderr, "ring setup failed: %d\n", ret);
                 return 1;
         }

         /* write data + meta-buffer to device */
         sqe = io_uring_get_sqe(&ring);
         if (!sqe) {
                 fprintf(stderr, "get sqe failed\n");
                 return 1;
         }

         io_uring_prep_write(sqe, fd, wdb, DATA_LEN, offset);

	 sqe->meta_type = META_TYPE_PI;
         md = (struct io_uring_meta_pi *) sqe->big_sqe;
         md->addr = (__u64)wmb;
         md->len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         md->pi_flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;
         md->seed = 10;

         pi = (struct t10_pi_tuple *)wmb;
         pi->guard = 0;
         pi->reftag = 0x0A000000;
         pi->apptag = 0x3412;

         ret = io_uring_submit(&ring);
         if (ret <= 0) {
                 fprintf(stderr, "sqe submit failed: %d\n", ret);
                 return 1;
         }

         ret = io_uring_wait_cqe(&ring, &cqe);
         if (!cqe) {
                 fprintf(stderr, "cqe is NULL :%d\n", ret);
                 return 1;
         }
         if (cqe->res < 0) {
                 fprintf(stderr, "write cqe failure: %d", cqe->res);
                 return 1;
         }

         io_uring_cqe_seen(&ring, cqe);

         /* read data + meta-buffer back from device */
         sqe = io_uring_get_sqe(&ring);
         if (!sqe) {
                 fprintf(stderr, "get sqe failed\n");
                 return 1;
         }

         io_uring_prep_read(sqe, fd, rdb, DATA_LEN, offset);

         sqe->meta_type = META_TYPE_PI;
	 md = (struct io_uring_meta_pi *) sqe->big_sqe;
         md->addr = (__u64)rmb;
         md->len = META_LEN;
         md->pi_flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;
         md->seed = 10;

         ret = io_uring_submit(&ring);
         if (ret <= 0) {
                 fprintf(stderr, "sqe submit failed: %d\n", ret);
                 return 1;
         }

         ret = io_uring_wait_cqe(&ring, &cqe);
         if (!cqe) {
                 fprintf(stderr, "cqe is NULL :%d\n", ret);
                 return 1;
         }

         if (cqe->res < 0) {
                 fprintf(stderr, "read cqe failure: %d", cqe->res);
                 return 1;
         }

	 pi = (struct t10_pi_tuple *)rmb;
	 if (pi->apptag != 0x3412)
		 printf("Failure: apptag mismatch!\n");
	 if (pi->reftag != 0x0A000000)
		 printf("Failure: reftag mismatch!\n");

         io_uring_cqe_seen(&ring, cqe);

         pi = (struct t10_pi_tuple *)rmb;

         if (strncmp(wmb, rmb, META_LEN))
                 printf("Failure: meta mismatch!, wmb=%s, rmb=%s\n", wmb, rmb);

         if (strncmp(wdb, rdb, DATA_LEN))
                 printf("Failure: data mismatch!\n");

         io_uring_queue_exit(&ring);
         free(rdb);
         free(wdb);
         return 0;
}

Anuj Gupta (7):
  block: define set of integrity flags to be inherited by cloned bip
  block: modify bio_integrity_map_user to accept iov_iter as argument
  fs, iov_iter: define meta io descriptor
  fs: introduce IOCB_HAS_METADATA for metadata
  io_uring/rw: add support to send metadata along with read/write
  block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
  scsi: add support for user-meta interface

Christoph Hellwig (1):
  block: copy back bounce buffer to user-space correctly in case of
    split

Kanchan Joshi (2):
  nvme: add support for passing on the application tag
  block: add support to pass user meta buffer

 block/bio-integrity.c         | 84 ++++++++++++++++++++++++++++-------
 block/blk-integrity.c         | 10 ++++-
 block/fops.c                  | 42 ++++++++++++++----
 drivers/nvme/host/core.c      | 21 +++++----
 drivers/scsi/sd.c             |  4 +-
 include/linux/bio-integrity.h | 19 ++++++--
 include/linux/fs.h            |  1 +
 include/linux/uio.h           | 10 +++++
 include/uapi/linux/fs.h       |  9 ++++
 include/uapi/linux/io_uring.h | 29 ++++++++++++
 io_uring/io_uring.c           |  9 ++++
 io_uring/rw.c                 | 79 +++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 13 files changed, 290 insertions(+), 41 deletions(-)

-- 
2.25.1


