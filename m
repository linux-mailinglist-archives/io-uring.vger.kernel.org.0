Return-Path: <io-uring+bounces-5027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 561F39D7C65
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF0AB21706
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7A117DFF2;
	Mon, 25 Nov 2024 08:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fWPS/EA5"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF118827
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522062; cv=none; b=APBqMDvQiQnQGVNDMxh6FCMzMy8EeGFkQ4vqe5Lq3Sc4vI6pVzsnMcAgxW6fn3cf/LyIhQ3fl3RtgSXf90doZNQnLCx3iKqUgEtYT1Eai96MXiwLfUzCL+IGXH5uHXMnrBiyAB3KgGIJfYpwDXKqlqbshTpqcFGfIJD24bHbS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522062; c=relaxed/simple;
	bh=JUUPLSdthK/RNNFYXi353OKPRzObpPKOSiwWG4kEZG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=T8CHS66kf7Ylf95sWgrsNsGQCsC1cB01cboWyvHbvrYHabVbtEe5dJiWB1S2muAaXSFVWq3nghh7+3Iz0fn/IED1y8pR+JBaUuqqcRomAQaCCGd7Y35PgIa5F10harkZ5dgUlpfZhR+6H6zKTNFKb5fLTgAN8bp6CNnDjsxisW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fWPS/EA5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241125080732epoutp01ff7a0573562a9aa9eda864a7c595798f~LJ6CMxqUn0944409444epoutp01W
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241125080732epoutp01ff7a0573562a9aa9eda864a7c595798f~LJ6CMxqUn0944409444epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522052;
	bh=ClwvnqbV1bi7c8u/G0SkIRtHRJoPcIVUKcU59YiK3dU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fWPS/EA5pRaDJq83sDDZxabC8Mpv79sD6STMl56tkwL4DFZxLq/lOT8WbrkoVnE2I
	 VgZxADwgjmz3mv5P8l9ntM6iqCACkCi/zITurq+lOJBrsfyygh2S4ytDaqJ4vJD61d
	 g01RPVxoQ/vIqKDG0k4aMChW1VLK9Xl0yAaxF+O4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241125080731epcas5p3f134aed5eea0edc8c7905c885422dbee~LJ6Bm2kM00668206682epcas5p33;
	Mon, 25 Nov 2024 08:07:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xxdbj1Mrgz4x9QK; Mon, 25 Nov
	2024 08:07:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	43.D1.19933.14034476; Mon, 25 Nov 2024 17:07:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241125071431epcas5p3a3d9633606d2f0b46de2c144bb7f3711~LJLv1d3BX3164231642epcas5p3d;
	Mon, 25 Nov 2024 07:14:31 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071431epsmtrp2ab1a82e1b09583138fb5bce68f3bb3f5~LJLvy9JB80286002860epsmtrp2C;
	Mon, 25 Nov 2024 07:14:31 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-92-6744304185f4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	04.7E.18937.7D324476; Mon, 25 Nov 2024 16:14:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071428epsmtip11c5296627ecc407a63756864d0b895c3~LJLtLRd2h0236302363epsmtip1Y;
	Mon, 25 Nov 2024 07:14:28 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 00/10] Read/Write with meta/integrity
Date: Mon, 25 Nov 2024 12:36:23 +0530
Message-Id: <20241125070633.8042-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmpq6jgUu6wcprrBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsaVhnVMBa+jKppv/GVqYOx06mLk5JAQMJG4dfs5
	cxcjF4eQwG5Gia8dLYwQzidGiYNLpjPDOWfWr2eBafm14BcLRGInUNW2d6wQzmdGiRs9m1lB
	qtgE1CWOPG8FmyUisIdRonfhabAWZoGXjBJLVy0CmyUsYCnx7PQ3ZhCbRUBVYtuZzewgNq+A
	hcSOwyuYIPbJS8y89B0qLihxcuYTsF5moHjz1tlgB0oIbOGQ2PHiBxtEg4tE56e7UM3CEq+O
	b2GHsKUkPr/bC1WTLvHj8lOomgKJ5mP7GCFse4nWU/1AQzmAFmhKrN+lDxGWlZh6ah0TxF4+
	id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JJ7efAU2XkggVqLzdD/bBEb5WUjemYXknVkI
	mxcwMq9ilEwtKM5NTy02LTDKSy2Hx21yfu4mRnDC1vLawfjwwQe9Q4xMHIyHGCU4mJVEePnE
	ndOFeFMSK6tSi/Lji0pzUosPMZoCw3gis5Rocj4wZ+SVxBuaWBqYmJmZmVgamxkqifO+bp2b
	IiSQnliSmp2aWpBaBNPHxMEp1cDEkfVQ882empAJ7/P2lm5p+x3ZE98auSlcgU/B46X46o/h
	O7bK1N3TeCV+en/sqY1pOpI/feNUHuY7fDxntsOidc957q+TrnTkONQ7xh07wXU7e4/QzY0m
	pjYF7zhW/l8U9enzXif9Tyd/mbpoP3Bynl7fkNFlOTu9xjpUY9r6qxZyUavUd9t+O6P3vKDn
	mW/0Fd0dRauCvh97I2490/Lv0+Rr7vKbBFMK1URXGO+pDnv1T/+w28+ova3Tmnj577/pnuWQ
	G3nlyZtbJ4qK9v+yDm/gKzXztX30rKTD3GjHwj2N/x9xbVeyDd8pG55ldS9nP2fG+Z0nH8t0
	vs/UK+FLtp/Wp+LSGHSo4skzLnslluKMREMt5qLiRAARYcl4YQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSnO51ZZd0g+5H3BYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEr40rDOqaC11EVzTf+MjUw
	djp1MXJySAiYSPxa8Iuli5GLQ0hgO6PE+un97BAJCYlTL5cxQtjCEiv/PWeHKPrIKDH3eS8T
	SIJNQF3iyPNWsCIRgROMEvMnuoEUMYMUTfgymwUkISxgKfHs9DdmEJtFQFVi25nNYBt4BSwk
	dhxewQSxQV5i5qXvUHFBiZMzn4D1MgPFm7fOZp7AyDcLSWoWktQCRqZVjKKpBcW56bnJBYZ6
	xYm5xaV56XrJ+bmbGMERoxW0g3HZ+r96hxiZOBgPMUpwMCuJ8PKJO6cL8aYkVlalFuXHF5Xm
	pBYfYpTmYFES51XO6UwREkhPLEnNTk0tSC2CyTJxcEo1MDVnTreIuN13ebPqmUvib4q1LCMl
	rrBWZPeoKXGFOGZUCeTN7vjSIVH1buthJu6Et++U59kmPv2weWehVKgGu0Ou3m/JlSZXvrIw
	SU4PvnGcgWmnzpcffdvkov6LZr36foW57UgdQ/tOe6eDcsm1zs93HTMJePJnQ3wx/42Hp8L6
	QnQZ/yq8CQlbOvGf2eNJEyWOVC3dPM+K3fDmzBq/3watcw6tCvWdvdy1cq8b7/MC3qc6S41N
	vf5GLLjZJRKnNbdlmXnpwd+T1snE94bteHGal2PmPPlL//n/3au0Diu3da+5Gcq4xe3B/muz
	Dj2Z1Pr23Myo7Sc/z4jJ+fLb9FxvZuz9wIaod1zP1q9Re6rEUpyRaKjFXFScCAA/k21/BwMA
	AA==
X-CMS-MailID: 20241125071431epcas5p3a3d9633606d2f0b46de2c144bb7f3711
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071431epcas5p3a3d9633606d2f0b46de2c144bb7f3711
References: <CGME20241125071431epcas5p3a3d9633606d2f0b46de2c144bb7f3711@epcas5p3.samsung.com>

This adds a new io_uring interface to exchange additional integrity/pi
metadata with read/write.

Example program for using the interface is appended below [1].

The patchset is on top of block/for-next.

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

Changes since v9:
https://lore.kernel.org/linux-block/20241114104517.51726-1-anuj20.g@samsung.com/

- pass PI attribute information via pointer (Pavel)
- fix kernel bot warnings

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
         char *data_str = "data buffer";
         int fd, ret, blksize;
         struct stat fstat;
         unsigned long long offset = DATA_LEN * 10;
         struct t10_pi_tuple *pi;
         struct io_uring_sqe_ext *sqe_ext;
	 struct io_uring_attr w_pi, r_pi;

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

         ret = io_uring_queue_init(8, &ring, 0);
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

	 sqe->attr_type_mask = ATTR_FLAG_PI;
	 w_pi.attr_type = ATTR_TYPE_PI;
         w_pi.pi.addr = (__u64)wmb;
         w_pi.pi.len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         w_pi.pi.flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         w_pi.pi.app_tag = 0x1234;
         w_pi.pi.seed = 10;
	 w_pi.pi.rsvd = 0;
	 sqe->attr_ptr = (__u64)&w_pi;

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

	 sqe->attr_type_mask = ATTR_FLAG_PI;
	 r_pi.attr_type = ATTR_TYPE_PI;
         r_pi.pi.addr = (__u64)rmb;
         r_pi.pi.len = META_LEN;
         r_pi.pi.flags = IO_INTEGRITY_CHK_GUARD | IO_INTEGRITY_CHK_REFTAG | IO_INTEGRITY_CHK_APPTAG;
         r_pi.pi.app_tag = 0x1234;
         r_pi.pi.seed = 10;
	 r_pi.pi.rsvd = 0;
	 sqe->attr_ptr = (__u64)&r_pi;

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
  io_uring: introduce attributes for read/write and PI support
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
 block/fops.c                  | 45 ++++++++++++++-----
 drivers/nvme/host/core.c      | 21 +++++----
 drivers/scsi/sd.c             |  4 +-
 include/linux/bio-integrity.h | 25 ++++++++---
 include/linux/fs.h            |  1 +
 include/linux/uio.h           |  9 ++++
 include/uapi/linux/fs.h       |  9 ++++
 include/uapi/linux/io_uring.h | 31 +++++++++++++
 io_uring/io_uring.c           |  2 +
 io_uring/rw.c                 | 82 +++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 13 files changed, 291 insertions(+), 46 deletions(-)

-- 
2.25.1


