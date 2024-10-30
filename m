Return-Path: <io-uring+bounces-4228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D179B6BB1
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 157061C23E2D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98EB1C4612;
	Wed, 30 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lrVmJIS1"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378121B373A
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311806; cv=none; b=Ef/I9P5HEE2GJ/ZwFhNklWoqVR4hD5WpJv8l+uRlNsD6q3/sRvsnM4bIQzNuvLsUep5KnTdueVhaSqtGL4X6Bptr9AesUtbOH17RHw0rNdVN0q47oYKjKCJGl5TNpc7gdlXIolOmDLErv6NboUXwr4N1oWXplzSwxx472k0M+TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311806; c=relaxed/simple;
	bh=uySovCPzGdRO4T2fBjI6JOc8f9KEYNiGdERyOA3vEUc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=GkSiP668RHbqbr5A8ye22jw/ZO6cRJTv53nbtZokGhwG7KpcSAzFZmIROB3SxWWPefTNcnHcp3KPvrYVu0C2ew8z7HrW6g7WBqgm001n9lBnTBqjGFNbkfk8mLOPrZ/rLBfIzNUnRuTvHG6WS2ek23NwmtAJzIQ7G2R/isTE+NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lrVmJIS1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241030181000epoutp02c93ea8317c817130201e5818d35c1923~DTWotWDq01935219352epoutp02Z
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241030181000epoutp02c93ea8317c817130201e5818d35c1923~DTWotWDq01935219352epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311800;
	bh=a3O5sWW2+Mj1ftBi0Pz4YEj1ciNh/vXL6x5dH91WqhY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=lrVmJIS10r13dcWgQZU7MDrdOUNQc67L22p8EbokpSW23Rl9tT/l/aOhB5rVTghra
	 v5mC/zFHGRAovpxeCVH35f+bVTNmVK0UjvGmFsn2uOlVIfbZnYLdoAfgu/Z0njGd/D
	 qtZpsmRwqvbHzXSs4hPmdI/bffe2Ej6cG+tdrkZ8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241030180959epcas5p25c940fe5d0bbdac38c7fab1b28767f49~DTWoKlyg71352813528epcas5p29;
	Wed, 30 Oct 2024 18:09:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XdwBt3Mc1z4x9Pp; Wed, 30 Oct
	2024 18:09:58 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.10.09420.67672276; Thu, 31 Oct 2024 03:09:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241030180957epcas5p3312b0a582e8562f8c2169e64d41592b2~DTWmaFOfi1252212522epcas5p3X;
	Wed, 30 Oct 2024 18:09:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030180957epsmtrp136f0e76291407c123302b697c6b4f5bd~DTWmZObQK0151201512epsmtrp1V;
	Wed, 30 Oct 2024 18:09:57 +0000 (GMT)
X-AuditID: b6c32a49-33dfa700000024cc-dc-672276768a8d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.78.08229.57672276; Thu, 31 Oct 2024 03:09:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030180955epsmtip2915365d1e5da8803076bdf1b5d7dc13b~DTWj-cohx0487504875epsmtip22;
	Wed, 30 Oct 2024 18:09:55 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v6 00/10] Read/Write with metadata/integrity
Date: Wed, 30 Oct 2024 23:31:02 +0530
Message-Id: <20241030180112.4635-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmpm5ZmVK6wbZmQYuPX3+zWMxZtY3R
	YvXdfjaL14c/MVrcPLCTyWLl6qNMFu9az7FYzJ7ezGRx9P9bNotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsaRNWtYCpYEVnR8e8fawNhm1cXIwSEhYCJxbDtP
	FyMXh5DAbkaJY5vnMEI4nxgl9q05zALhfGOUeDnvCZDDCdbx9fxZdojEXkaJv7cWM0M4nxkl
	fl2fyw4yl01AU+LC5FKQBhGBpYwSK69Hg9QwCzQxSTw/swhskrCAjcTEny1g9SwCqhLX/ieB
	hHkFzCWe72lmhFgmLzHz0nd2iLigxMmZEEcwA8Wbt84G2yshsIdDYsuym6wQDS4S+54cYIKw
	hSVeHd/CDmFLSbzsb4OysyUePHoA9U2NxI7NfVC99hINf26wgtzDDHT/+l36ELv4JHp/P2GC
	BBevREebEES1osS9SU+hOsUlHs5YAmV7SJxefpsFpFxIIFZi9T+JCYxys5A8MAvJA7MQdi1g
	ZF7FKJlaUJybnlpsWmCYl1oOj8nk/NxNjOBkrOW5g/Hugw96hxiZOBgPMUpwMCuJ8FoGKaYL
	8aYkVlalFuXHF5XmpBYfYjQFBupEZinR5HxgPsgriTc0sTQwMTMzM7E0NjNUEud93To3RUgg
	PbEkNTs1tSC1CKaPiYNTqoFpMfs7f/EvszKZausq+pnuHSz9fMPolNavMpFJn5U37n/hemBZ
	MbPTg5xJ3k9v5jduu7M06p7gYUd+s4frJ8Z9zHRYtGnli/9MpWYO+st/B6hNr//vylgq4x/J
	cij+YW3d5B2ruaVNdmZe28t+3+uf9huT6TYa356Yta6/O3VyQ2PHuTjX0L1Jh4w3RPI/fZW+
	f4Ni1M6ifcHbgmt4VknuWb493fpbeM7W7dvKy++eZl9ezz3TbLNkiGGWkSBr4RevpxEnzije
	uREwdXnFDs+JvEuvZ2bxTp+43IRxc0hgtLPLeuEilWqeD+cm8O0507/YV/vFBPk5uSFMB5M7
	3darF61ezBnVvn1ixpfPHzIeKbEUZyQaajEXFScCAHbVg4xPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvG5pmVK6wbbZGhYfv/5msZizahuj
	xeq7/WwWrw9/YrS4eWAnk8XK1UeZLN61nmOxmD29mcni6P+3bBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxpE1a1gKlgRWdHx7x9rA
	2GbVxcjJISFgIvH1/Fn2LkYuDiGB3YwS29c/YoNIiEs0X/vBDmELS6z89xyq6COjxLcDB5m7
	GDk42AQ0JS5MLgWJiwisZ5Q4u3cCC4jDLNDDJLH8/B+wbmEBG4mJP1vYQRpYBFQlrv1PAgnz
	CphLPN/TzAixQF5i5qXv7BBxQYmTM5+wgNjMQPHmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56
	brFhgWFearlecWJucWleul5yfu4mRnDcaGnuYNy+6oPeIUYmDsZDjBIczEoivJZBiulCvCmJ
	lVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUamPL1lsb/VmkxLSv6
	wONhFnz+jM/LJctOPRYsnGUQ49CQoqKpvvVy38HLRQWyd6fy3pPuVry774SYel/xhEjdr14P
	j06q8rYL6Fv11fv6Y/G9jLzup/hcqvy4Q7grao7LzfxRtFmW/0hMnvHn2OizPWtWK1/ZML9z
	Trr++ogldwvOyEfNvr13n7vLnyPuJh5/drdHffcWPHfWNdR+/v3ji+qYLvJVSH3Wuf721omL
	t5Qm7fg+9fDFVaI7Pigl6nDO133U5RAZutRoz1ynQ7fXfJby+Oasc3flMbMN/pK50iKOYW2n
	f5/Mb4vWKCq6vfnh4flPZPwy81hl3z8t4pjqUBBTr7F3V6b8UdVW77O8RUosxRmJhlrMRcWJ
	ACEIpYQKAwAA
X-CMS-MailID: 20241030180957epcas5p3312b0a582e8562f8c2169e64d41592b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030180957epcas5p3312b0a582e8562f8c2169e64d41592b2
References: <CGME20241030180957epcas5p3312b0a582e8562f8c2169e64d41592b2@epcas5p3.samsung.com>

This adds a new io_uring interface to exchange additional integrity/pi
metadata with read/write.

The patchset is on top of block/for-next.

Interface:

Application sets up a SQE128 ring, and populates a new 'struct io_uring_meta_pi'
within the second SQE. This structure enables to pass:

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

Changes since v5:
https://lore.kernel.org/linux-block/20241029162402.21400-1-anuj20.g@samsung.com/

- remove meta_type field from SQE (hch, keith)
- remove __bitwise annotation (hch)
- remove BIP_CTRL_NOCHECK from scsi (hch)

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

[1]
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/io_uring.h>
#include <linux/types.h>
#include "liburing.h"

/* write data/meta. read both. compare. send apptag too.
* prerequisite:
* unprotected xfer: format namespace with 4KB + 8b, pi_type = 0
* protected xfer: format namespace with 4KB + 8b, pi_type = 1
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
         char *meta_str = "meta";
         int fd, ret, blksize;
         struct stat fstat;
         unsigned long long offset = DATA_LEN;
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

         strcpy(wdb, data_str);
         strcpy(wmb, meta_str);

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

         md = (struct io_uring_meta_pi *) sqe->big_sqe;
         md->addr = (__u64)wmb;
         md->len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         md->pi_flags = IO_INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;
         md->seed = 0;

         pi = (struct t10_pi_tuple *)wmb;
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

         md = (struct io_uring_meta_pi *) sqe->big_sqe;
         md->addr = (__u64)rmb;
         md->len = META_LEN;
         md->pi_flags = IO_INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;
         md->seed = 0;

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
         io_uring_cqe_seen(&ring, cqe);

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
 include/linux/bio-integrity.h | 26 ++++++++---
 include/linux/fs.h            |  1 +
 include/linux/uio.h           |  9 ++++
 include/uapi/linux/fs.h       |  9 ++++
 include/uapi/linux/io_uring.h | 16 +++++++
 io_uring/io_uring.c           |  4 ++
 io_uring/rw.c                 | 71 ++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 13 files changed, 266 insertions(+), 45 deletions(-)

-- 
2.25.1


