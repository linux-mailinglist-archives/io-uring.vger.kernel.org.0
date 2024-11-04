Return-Path: <io-uring+bounces-4412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6429BB96D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33165B2101E
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1891C07E7;
	Mon,  4 Nov 2024 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A3aDwQiV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F470816
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735758; cv=none; b=BR1Idp3P5uWfSbknhffrsz9kPp/YxT2VtvmeH42r1CwYpifii6m1BBfF33aRKRAvRt/twmdBBERLdCrcZ+vMOZuQu/JI/SnfHcGDw9Aw8hqsFqpzsFdNvQQCbbkJhdinRj6EYXWxcwn9LmM0s2nq1qu7MPSJa/QINMJMe/F9xDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735758; c=relaxed/simple;
	bh=1ydpZfCyJMT+2b3ql8YhxuPSnBsBK1CfzFk1TzB+Avs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=crWNdvJK327DNeG30LCTpYxSs6OPVEK8sSG8FhJOZ187SGeiap0p6gxDd2Nh9GtzVQNn+Zuh3BfRNk3r2dNJLAlZUdxrMUwHUBBIPf9oUWJKMW0dWsBGWH3QLfIz7S6uzdetM7fn0ss4SiCo9DveLkdYFfn8Ij5L5a9iUGxBPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=A3aDwQiV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241104155551epoutp010e6247de2468d0e034723339fc8c57ec~Ezv8PtQ7e1630116301epoutp01j
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:55:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241104155551epoutp010e6247de2468d0e034723339fc8c57ec~Ezv8PtQ7e1630116301epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735751;
	bh=AH5OO6CLj5ytNXZ0U+ctDIjcZJUMTyFZsuKAHYqHpsE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=A3aDwQiV2DPQKfbDtWmRbKHiorM7JfBVVJlkVq60UTNtpT58Pk83h+p7NZLNvgV86
	 mELliW9QH6iNaevxc05yZ1oMy/9jhz+x1eZecMa1J2Wy1q+kImYJIOI2JfGDNeieKV
	 Ic/4D3BpPpyQoIsX4zLFpHZiWrRko4/ufIwThDiU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241104155551epcas5p2ceba2d2030c51507e52e22a92a2916c5~Ezv7qv4W71865918659epcas5p2J;
	Mon,  4 Nov 2024 15:55:51 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xhwzn28BZz4x9Pr; Mon,  4 Nov
	2024 15:55:49 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0C.CA.09800.58EE8276; Tue,  5 Nov 2024 00:55:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141427epcas5p2174ded627e2d785294ac4977b011a75b~EyXaBuB6s3053330533epcas5p2G;
	Mon,  4 Nov 2024 14:14:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104141427epsmtrp1951680db65d85ed654f857efd67449e3~EyXaAWEzH1329813298epsmtrp1P;
	Mon,  4 Nov 2024 14:14:27 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-1e-6728ee852624
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B5.68.35203.3C6D8276; Mon,  4 Nov 2024 23:14:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141425epsmtip2d47aa99a68a1870ba126da63ba39a31e~EyXXk6KtK3097330973epsmtip2V;
	Mon,  4 Nov 2024 14:14:24 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v7 00/10] Read/Write with meta/integrity
Date: Mon,  4 Nov 2024 19:35:51 +0530
Message-Id: <20241104140601.12239-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmum7rO410g2dv2S0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QO0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
	ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzZP2+xFvyOrHjzNriBcbpjFyMHh4SAicSm5Uld
	jFwcQgK7GSVmb7nICuF8YpT40/yYGcL5xijxa+t29i5GTrCO22d62CESexkltk/6BVX1mVGi
	Ye8UJpAqNgF1iSPPWxlBEiICexgleheeZgFxmAVeMkosXbWIBaRKWMBC4tSNFcwgNouAqsT2
	U4vBunkFLCUu3z3KCrFPXmLmpe/sEHFBiZMzn4D1MgPFm7fOBlstIbCFQ6LtwB02iAYXidPH
	10IdKyzx6vgWKFtK4mV/G5SdLvHj8lMmCLtAovnYPkYI216i9VQ/MyhomAU0Jdbv0ocIy0pM
	PbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhJvus8wgYwUEoiVWNCvMYFRfhaS
	b2Yh+WYWwuIFjMyrGCVTC4pz01OLTQuM81LL4RGbnJ+7iRGcqrW8dzA+evBB7xAjEwfjIUYJ
	DmYlEd55qerpQrwpiZVVqUX58UWlOanFhxhNgUE8kVlKNDkfmC3ySuINTSwNTMzMzEwsjc0M
	lcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglAJ6Je+G6KsvlooyLmY7Py/6rxKdZ3v+7433dzi5
	0+UeNnttV1Q+YfJe8csaDtaSpfO0nbVn1609s2L/XfWFb3bd37d2xZPFfrM6iupUZR4+/VFY
	n2N0Pe8t66lVE6pO/46JPLEt37yoM5CteBdT+TfTmxM4t0Ru5ro2P2GN5YzLpby7NxjWtjNU
	+3i0JnnpbDt7aIc705GYxLZPbHv/bpyyu/dAgmOWQK4S1/JtQUd+zRBkXjH7wQytSxv9Zh2/
	PLM0eld07e1IDcmlDQKPBH5oO744YHf8C+O7Tcr8stGcW/+X3wiU3P1aomLG5z6htGkCzy8s
	UTzj8TU2dXdE9doba28fMQhMmSoaFpZ0iOeuoRJLcUaioRZzUXEiAMb3InheBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvO7haxrpBne/Sll8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujNk/b7EW/I6sePM2uIFx
	umMXIyeHhICJxO0zPexdjFwcQgK7GSXav71ihUhISJx6uYwRwhaWWPnvOVTRR0aJvw8WM4Ek
	2ATUJY48bwUrEhE4wSgxf6IbSBEzSNGEL7NZQBLCAhYSp26sYAaxWQRUJbafgmjmFbCUuHz3
	KNQ2eYmZl76zQ8QFJU7OfALWywwUb946m3kCI98sJKlZSFILGJlWMUqmFhTnpucWGxYY5qWW
	6xUn5haX5qXrJefnbmIEx42W5g7G7as+6B1iZOJgPMQowcGsJMI7L1U9XYg3JbGyKrUoP76o
	NCe1+BCjNAeLkjiv+IveFCGB9MSS1OzU1ILUIpgsEwenVANTRvQiQ8/5lzTqFr02XH3AjeuN
	1sbJFt2bO6Ypn/Kd9jV2oWyI4a2lKu57Vbduibj+3pA16HGV4x6Ge3PTq/X1nRQWrb3VFsfN
	qnY1L9RxMnt4REpHWN2RC/+vM3K9/ZUvPOmLvWqEvHPzTTaJhsPPa5479KTtNnzGWpp472dC
	XuAJzT3XVLsNJya9ydle5vbTJGzRjryOaVpJrYXb/G6ZrPvGqHb9jfDBH3Ev2Z+H9d7trX2S
	dky0TDakx/S77po0Ld+deQLrViimGlnmuTiK8D//fca62uLgnGXmhTkRzftuPNj52+j8t80b
	zXd3r//yW9f8/vX5vw9Xz2a3it74YevUVwVvrli4K+4+OMFKiaU4I9FQi7moOBEAXt8liQoD
	AAA=
X-CMS-MailID: 20241104141427epcas5p2174ded627e2d785294ac4977b011a75b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141427epcas5p2174ded627e2d785294ac4977b011a75b
References: <CGME20241104141427epcas5p2174ded627e2d785294ac4977b011a75b@epcas5p2.samsung.com>

This adds a new io_uring interface to exchange additional integrity/pi
metadata with read/write.

The patchset is on top of block/for-next.

Interface:

A new meta_type field is introduced in SQE, which describes the type of metadata.
Currently one type "META_TYPE_PI" is supported. This meta type requires
application to setup a SQE128 ring. Application can use the second SQE to
pass following PI informaion:

* pi_flags: Three flags are exposed for integrity checks,
 namely IO_INTEGRITY_CHK_GUARD/APPTAG/REFTAG.
* len: length of the meta buffer
* addr: address of the meta buffer
* seed: seed value for reftag remapping
* app_tag: application-specific 16b value

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

Testing has been done by modifying fio to use this interface.
Example program for the interface is appended below [1].

Changes since v6:
https://lore.kernel.org/linux-block/20241030180112.4635-1-joshi.k@samsung.com/

- io_uring changes (bring back meta_type, move PI to the end of SQE128)
- Fix robot warnings

Changes since v5:
https://lore.kernel.org/linux-block/20241029162402.21400-1-anuj20.g@samsung.com/

- remove meta_type field from SQE (hch, keith)
- remove __bitwise annotation (hch)
- remove BIP_CTRL_NOCHECK from scsi (hch)

Changes since v4:
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

[1]

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
         struct io_uring_sqe_ext *sqe_ext;

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
         sqe_ext= (struct io_uring_sqe_ext *) (sqe + 1);
         sqe_ext->rw_pi.addr = (__u64)wmb;
         sqe_ext->rw_pi.len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         sqe_ext->rw_pi.flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         sqe_ext->rw_pi.app_tag = 0x1234;
         sqe_ext->rw_pi.seed = 10;

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
         sqe_ext= (struct io_uring_sqe_ext *) (sqe + 1);
         sqe_ext->rw_pi.addr = (__u64)rmb;
         sqe_ext->rw_pi.len = META_LEN;
         sqe_ext->rw_pi.flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         sqe_ext->rw_pi.app_tag = 0x1234;
         sqe_ext->rw_pi.seed = 10;

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

 block/bio-integrity.c         | 84 +++++++++++++++++++++++++++------
 block/blk-integrity.c         | 10 +++-
 block/fops.c                  | 42 +++++++++++++----
 drivers/nvme/host/core.c      | 21 +++++----
 drivers/scsi/sd.c             |  4 +-
 include/linux/bio-integrity.h | 25 +++++++---
 include/linux/fs.h            |  1 +
 include/linux/uio.h           |  9 ++++
 include/uapi/linux/fs.h       |  9 ++++
 include/uapi/linux/io_uring.h | 30 ++++++++++++
 io_uring/io_uring.c           |  8 ++++
 io_uring/rw.c                 | 88 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 13 files changed, 300 insertions(+), 45 deletions(-)

-- 
2.25.1


