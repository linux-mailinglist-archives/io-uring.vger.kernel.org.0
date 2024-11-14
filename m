Return-Path: <io-uring+bounces-4680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F929C88A5
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C3361F225E7
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF8C1F8900;
	Thu, 14 Nov 2024 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FUPskEiX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D7C1F8186
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583039; cv=none; b=L9OdX77SRgW6PKkiZWhgOfH5ehxO93MkyUlATiwGxG0+n3Wh509+5vU4PKoyMNyXg70/JDzfZWnD7O20fJUo6I+pWg1qM2c2xBvHbksygTrYlSo42HRwmHIVb1SYJakmkIM/J5ifLfZYydmF1pfNc4fmOAkgMjX+jXa7NeJLZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583039; c=relaxed/simple;
	bh=gaquD2octgV2v7EQv0ib4VIEev89KJv1gvJqH3JUN04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=smnNvNl/3luQgOZKT4ZwZn1w5Wvs+OtSmqUorw0KA3Z6Th1PHO1Q6z8cEp4HmooqDVvGxKhBEM6BSonqaWV6tYQEnuZyBcTEk4BYceE2AbpJzdHz7vrzDInEhrcSxkkPkm7nPE2hP1ig/tNpsFxEhFsFJeP99seDVoJ89PmaF20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FUPskEiX; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241114111707epoutp02eba7f5d7f2fdc724c34d7409b849fb2d~H0Zbbd5xc0202502025epoutp021
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241114111707epoutp02eba7f5d7f2fdc724c34d7409b849fb2d~H0Zbbd5xc0202502025epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583027;
	bh=3FdKV1Wv4Xsw/+85FgxRrOt0GL+RFqV5XkjSF/+rAdw=;
	h=From:To:Cc:Subject:Date:References:From;
	b=FUPskEiXEuN7zFVfE3zQT1gnSVlHoc/X4EsrvQ/fNKzKdEWkqSj71eOOWjIKeyL9H
	 +kxHUqAIIdSyCRBwlURPzOWmKnDTjbRm41KTga0O8YF4vDcZYMThAOHwSFa1XbcMyL
	 1Sv1rT2vMXbVX2/d06Lm4ah2jkPxsfEZT5gwXNDE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241114111706epcas5p223610d9d3b7635ac6890efeabc4e36e0~H0ZamRoH30689906899epcas5p2c;
	Thu, 14 Nov 2024 11:17:06 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XpyKX70mRz4x9Pt; Thu, 14 Nov
	2024 11:17:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.99.09770.03CD5376; Thu, 14 Nov 2024 20:17:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241114105326epcas5p103b2c996293fa680092b97c747fdbd59~H0EwCxj3t1325013250epcas5p1m;
	Thu, 14 Nov 2024 10:53:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241114105326epsmtrp2247251f85d6872910a76e29fd18d771b~H0EwA1vWe1919419194epsmtrp2w;
	Thu, 14 Nov 2024 10:53:26 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-99-6735dc30ab74
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E8.90.35203.6A6D5376; Thu, 14 Nov 2024 19:53:26 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105324epsmtip2d1a18eb15d736183da016a1503504c24~H0EtpfC7-0885508855epsmtip2k;
	Thu, 14 Nov 2024 10:53:23 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 00/11] Read/Write with meta/integrity
Date: Thu, 14 Nov 2024 16:15:06 +0530
Message-Id: <20241114104517.51726-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmuq7BHdN0g5bfhhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkbD4dKCC7EVS+Y/Y2xgnOLSxcjJISFgItG2/wwT
	iC0ksJtRomGqWBcjF5D9iVHi5qv7zBDON0aJ5a+72WE6Nn2cDJXYyyjReLufEcL5zCjxZNdu
	ZpAqNgF1iSPPW8ESIgJ7GCV6F55mAXGYBV4ySixdtYgFpEpYwEKiadIERhCbRUBVYvamyWDd
	vAKWEj8ffWOF2CcvMfPSd3aIuKDEyZlPwHqZgeLNW2eD3SEhsIVD4szJ3VAHukj86Wxmg7CF
	JV4d3wIVl5L4/G4vVDxd4sflp0wQdoFE87F9jBC2vUTrqX6goRxACzQl1u/ShwjLSkw9tY4J
	Yi+fRO/vJ1CtvBI75sHYShLtK+dA2RISe881QNkeEhd/3WWDhHCsxLmeKywTGOVnIXlnFpJ3
	ZiFsXsDIvIpRMrWgODc9tdi0wCgvtRwes8n5uZsYwclay2sH48MHH/QOMTJxMB5ilOBgVhLh
	PeVsnC7Em5JYWZValB9fVJqTWnyI0RQYxhOZpUST84H5Iq8k3tDE0sDEzMzMxNLYzFBJnPd1
	69wUIYH0xJLU7NTUgtQimD4mDk6pBqaUs968z7xn3VtrHHjIdvqU9l/K7Ck7DGz23bEpP7mL
	lz/r4mUeLu/UpU9f/5A+fyDl474gA9t4gYNeJx2SuWeW5Cu5Gx2YdkqBZbHbdevv7+viNKJ/
	J0x8fcViWuCxiq+vWp+t92ONKzm40ppha36z6FTGHSxJCypfJ7Ar1qSe1V1/n3Xuv6mlLYUK
	pnZPSr5LbpuUK3l07oWY41MlZH3NDRkP/GA+quzP/tVsk2O8UE9beo1vaC3P5viLha3yZxlr
	9/b9Dlh8Xl/kgr2dT5xOwqINr5/nXAhy2qm3aEMzR/mMLRxBWqcNdcr7mp9WuTZty0gOUnx9
	Os5fP27yq8bLiv+tF5zSeSKqdoR7pRJLcUaioRZzUXEiAGoj9CpfBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvO6ya6bpBmvvyll8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujIbDpQUXYiuWzH/G2MA4
	xaWLkZNDQsBEYtPHycxdjFwcQgK7GSU+HTjMApGQkDj1chkjhC0ssfLfc3aIoo+MElebWplB
	EmwC6hJHnreCFYkInGCUmD/RDaSIGaRowpfZYJOEBSwkmiZNACtiEVCVmL1pMlgzr4ClxM9H
	31ghNshLzLz0nR0iLihxcuYTsF5moHjz1tnMExj5ZiFJzUKSWsDItIpRMrWgODc9t9iwwDAv
	tVyvODG3uDQvXS85P3cTIzhutDR3MG5f9UHvECMTB+MhRgkOZiUR3lPOxulCvCmJlVWpRfnx
	RaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUamAojbjf+vqm/LblcUKmcV37N
	3pciL47vYP2lzqBRPilCU84116BG0kxL5m2R9hWDzm9n0qZ9y3mk+c1ZJiX0Xppm3QPW1Zfm
	bny64pnqlvMaNkt036jdrxNJMp7brL114axNrQdFD/JKN+pH9IZwGG1KXxMaqPNBtGbtW5F/
	ZvrVGx8eazvZd9zm395XKopSiw+cOm6y1Oesz5cfW3uEpsw5tuEvo7l97oW+3Mtp7m4rPni7
	c32YPPX305CMqcX7l53d9dFy2syZz9Z39ajONJScz+Icu2Ex948cFgZHkwnrapW2Xp69SGQS
	28muWQeqwtj0vrKbBR6If5e9m9cq3LHIwbmII9m/dXbPhhlq85RYijMSDbWYi4oTAWBW1UIK
	AwAA
X-CMS-MailID: 20241114105326epcas5p103b2c996293fa680092b97c747fdbd59
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105326epcas5p103b2c996293fa680092b97c747fdbd59
References: <CGME20241114105326epcas5p103b2c996293fa680092b97c747fdbd59@epcas5p1.samsung.com>

This adds a new io_uring interface to pass additional attributes with
read/write. It can be done using two ways.

1. Passing the attribute information via user pointer.
2. Passing the attribute information inline with SQE/SQE128.

We have had discussions in the past about using the SQE128 space for passing
PI fields. Still if there are concerns about it, can we please consider
this patchset for inclusion only with the user pointer approach for now
(and drop patch 7)?

Example program for using the interface is appended below [1].
In the program, write is done via inline scheme and read is done via user
pointer scheme.

The patchset is on top of block/for-next.

Block path (direct IO) , NVMe and SCSI driver are modified to support
this.

Patch 1 is an enhancement patch.
Patch 2 is required to make the bounce buffer copy back work correctly.
Patch 3 to 5 are prep patches.
Patch 6 and 7 adds the io_uring support.
Patch 8 gives us unified interface for user and kernel generated
integrity.
Patch 9 adds support in SCSI and patch 10 in NVMe.
Patch 11 adds the support for block direct IO.

Changes since v8:
https://lore.kernel.org/io-uring/20241106121842.5004-1-anuj20.g@samsung.com/

- add option of the pass the PI information from user space via a
  pointer (Pavel)

Changes since v7:
https://lore.kernel.org/io-uring/20241104140601.12239-1-anuj20.g@samsung.com/

- change the sign-off order (hch)
- add a check for doing metadata completion handling only for async-io
- change meta_type name to something more meaningful (hch, keith)
- add detail description in io-uring patch (hch)

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
         int fd, ret, blksize;
         struct stat fstat;
         unsigned long long offset = DATA_LEN * 10;
         struct t10_pi_tuple *pi;
         struct io_uring_sqe_ext *sqe_ext;
	 struct io_uring_attr_pi pi_attr;
	 struct io_uring_attr_vec attr_vec;

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

	 sqe->attr_inline_flags = ATTR_FLAG_PI;
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

         sqe->nr_attr_indirect = 1;
	 sqe->attr_vec_addr = (__u64)&attr_vec;
	 attr_vec.type = ATTR_TYPE_PI;
	 attr_vec.addr = (__u64)&pi_attr;
         pi_attr.addr = (__u64)rmb;
         pi_attr.len = META_LEN;
         pi_attr.flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         pi_attr.app_tag = 0x1234;
         pi_attr.seed = 10;

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


Anuj Gupta (8):
  block: define set of integrity flags to be inherited by cloned bip
  block: modify bio_integrity_map_user to accept iov_iter as argument
  fs, iov_iter: define meta io descriptor
  fs: introduce IOCB_HAS_METADATA for metadata
  io_uring: introduce attributes for read/write and PI support
  io_uring: inline read/write attributes and PI
  block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
  scsi: add support for user-meta interface

Christoph Hellwig (1):
  block: copy back bounce buffer to user-space correctly in case of
    split

Kanchan Joshi (2):
  nvme: add support for passing on the application tag
  block: add support to pass user meta buffer

 block/bio-integrity.c         |  84 ++++++++++++++----
 block/blk-integrity.c         |  10 ++-
 block/fops.c                  |  45 +++++++---
 drivers/nvme/host/core.c      |  21 +++--
 drivers/scsi/sd.c             |   4 +-
 include/linux/bio-integrity.h |  25 ++++--
 include/linux/fs.h            |   1 +
 include/linux/uio.h           |   9 ++
 include/uapi/linux/fs.h       |   9 ++
 include/uapi/linux/io_uring.h |  40 +++++++++
 io_uring/io_uring.c           |   5 ++
 io_uring/rw.c                 | 160 +++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 |  14 ++-
 13 files changed, 381 insertions(+), 46 deletions(-)

-- 
2.25.1


