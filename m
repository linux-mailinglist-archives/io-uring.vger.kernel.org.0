Return-Path: <io-uring+bounces-4489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0B59BF024
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C046285796
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68876201244;
	Wed,  6 Nov 2024 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KRYLDLfq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB91DFE10
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903310; cv=none; b=YbsriUt+8ap+dNs2UarN4Cj2YzExqKQrcCJUvCGNa7ZSvJ58KI54DdpXsShU80aYhP3hkDSyh/EbjwC95k2BB97PWMyAOUJIrzszp7DTwvTMIZk1dazdbD7yNpjq5/UrlAfpFR6bgA7/ni2xowcX5Uf9Di3SDEsdmwYmTKi9Zrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903310; c=relaxed/simple;
	bh=Q5tJjWp0SXxkFW77IV2tApMaLjv5ImWYCDQ0C42kuZc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Uz2CsZ0tqhiHG0Jnn885fHQCuoXfzuaJnonWPmtmeiSnV+gw3D0QTHIMCkm3FqjvTXaq64giF69PQPzx18tG2N2JOhp7Hm16FKwJ2m8QnhHzgAGPdRjnrWwFxHDLyA2nuTSPHaXrWp1IbP6ECfiB8qFKtUrzdD662naaVrZpLWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KRYLDLfq; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241106142824epoutp0178a1b683f261d568fb489631ecd232cd~FZ2KEYp3i1909819098epoutp01f
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241106142824epoutp0178a1b683f261d568fb489631ecd232cd~FZ2KEYp3i1909819098epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903304;
	bh=ikO2kdjpEe2Zs+Jg63bfEV/koAE9AeM+CUQkqhQ7zgk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=KRYLDLfqpSeXM9Rebnn7c6ufkHAbXA6Sc11VqRa3euuhnINE8euKdSNSlDpksv9kE
	 msy3IPHb2lkKQGGDvz7KKCFKmT4Jzgo1DLxRr90sDlOzSbVUYJFK12+OSpTzi+5bzB
	 nJcbfozDA/ftdpFbI/0dT7kJatZOvzSsAuptM8zk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241106142823epcas5p373d2604f774f0e133a5ffa63fb621485~FZ2I11GnW2414124141epcas5p3P;
	Wed,  6 Nov 2024 14:28:23 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xk6xx4GPtz4x9Pr; Wed,  6 Nov
	2024 14:28:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	90.44.37975.50D7B276; Wed,  6 Nov 2024 23:28:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241106122631epcas5p2575c59b7634e0077f8e5c654b5fd5dbb~FYLvQCGOx1874618746epcas5p2a;
	Wed,  6 Nov 2024 12:26:31 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241106122631epsmtrp14df4a3d5e45b9a8ed3654033e71670a8~FYLvOiIbl1944919449epsmtrp1I;
	Wed,  6 Nov 2024 12:26:31 +0000 (GMT)
X-AuditID: b6c32a50-0e7f370000049457-00-672b7d0574be
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	71.75.18937.7706B276; Wed,  6 Nov 2024 21:26:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122628epsmtip13211ddfd87cbca896539ba81607e32d3~FYLsrsTuU0656106561epsmtip1Y;
	Wed,  6 Nov 2024 12:26:28 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v8 00/10] Read/Write with meta/integrity
Date: Wed,  6 Nov 2024 17:48:32 +0530
Message-Id: <20241106121842.5004-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmhi5rrXa6Qe8xKYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQP0jpJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWn
	wKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2PmjGbGgp8xFX/P/mNrYLzu3MXIwSEhYCLx4pN0
	FyMXh5DAHkaJr4e/s0A4nxgl7n9cxgTn7Dr2hLmLkROsY9/XW8wQiZ2MEpPProRq+cwosefK
	EUaQKjYBdYkjz1sZQRIiIIN7F54Gq2IWeMkosXTVIhaQ7cICFhKzH3CDNLAIqEr8WfyYHcTm
	BQov6rvOArFOXmLmpe9QcUGJkzOfgMWZgeLNW2eDnSEhsIVD4seKi0wQDS4S/c8uQzULS7w6
	voUdwpaSeNnfBmWnS/y4/BSqvkCi+dg+RgjbXqL1VD8zyG3MApoS63fpQ4RlJaaeWscEsZdP
	ovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPiZYLL8HOERKIlXj3eB/zBEb5WUjemYXknVkI
	mxcwMq9ilEotKM5NT002LTDUzUsth0dtcn7uJkZwutYK2MG4esNfvUOMTByMhxglOJiVRHj9
	o7TThXhTEiurUovy44tKc1KLDzGaAgN5IrOUaHI+MGPklcQbmlgamJiZmZlYGpsZKonzvm6d
	myIkkJ5YkpqdmlqQWgTTx8TBKQX0zBFn5z2pu98zxxglrXI8len9mrmUf6NoZbKsxpT50+99
	1pwqY3JPoH3nnGOC1i37dhmKrff/5/+w45hMBZ+P7J6Z/++9zXupqnJyIb89g6C2lcCJrOYO
	4aQpXw5n+PDazfWzd4jyuNxf1bf/MnPd+cmFQqxTlq4rVmI0epJQrW4y++d0xc4LZXUuuuUf
	j3Nbb5l5sfXtrKx9e6d8Fry+v/P823szWl8q8TDWb/hS9VDlgqGVEOs+4edrzndcKv/6dZbe
	thTH/pNCNi4zlk81WPmmW6ld682yw+u0k9Il1zG9ev3zYy/LV5W0yhk3lnlKau3m2Ppgzwst
	2RbT5FsLwk9dLXZsPdptU9Iva7VQiaU4I9FQi7moOBEAK8XF0mAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnG55gna6wdbPohYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoErY+aMZsaCnzEVf8/+Y2tg
	vO7cxcjJISFgIrHv6y1mEFtIYDujxIZn+RBxCYlTL5cxQtjCEiv/PWfvYuQCqvnIKPFw/WNW
	kASbgLrEkeetYEUiAicYJeZPdAMpYgYpmvBlNksXIweHsICFxOwH3CA1LAKqEn8WP2YHsXmB
	wov6rrNALJCXmHnpO1RcUOLkzCdgcWagePPW2cwTGPlmIUnNQpJawMi0ilE0taA4Nz03ucBQ
	rzgxt7g0L10vOT93EyM4WrSCdjAuW/9X7xAjEwfjIUYJDmYlEV7/KO10Id6UxMqq1KL8+KLS
	nNTiQ4zSHCxK4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6pBqZi1u8Kn3fNFnj5LPkhe47UlL/Z
	B+ZZxdge2LCzz3eW7s6uyD57zusJ3F3cjFm3xKde1/6wo2NB69EH635uMg/M7k3RdJ4YNfFW
	e8BPH622vIhTTH//Pdiv2/L/2yLLvGM2E5Z8e9UvGJNw/LrQ5uNb6tzn86V+7mU7vEnjfYWQ
	tJfclAfbJX7Er1XOumCptfZ6Nt+2c+rPDtjE3932I3jPitufWffw+vC/eX+DwT9JxtxnlfH2
	JmWj9gJ95zPbX+5xjsxOZNsT0m86f7md599JL+25dQ2ltLT7r15zf5f7RrZ/8YbVjw6Gt9mz
	CgUdia9Zf+bRx//xRVkzQmW7Re7Yr10Yyl6esTjmTMD5yCVKLMUZiYZazEXFiQC3A8qfBQMA
	AA==
X-CMS-MailID: 20241106122631epcas5p2575c59b7634e0077f8e5c654b5fd5dbb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122631epcas5p2575c59b7634e0077f8e5c654b5fd5dbb
References: <CGME20241106122631epcas5p2575c59b7634e0077f8e5c654b5fd5dbb@epcas5p2.samsung.com>

Hi Jens,
Please consider this series for inclusion.

This adds a new io_uring interface to exchange additional integrity/pi
metadata with read/write.

The patchset is on top of block/for-next.

Interface:

A new ext_cap field is introduced in SQE, which describes the type of extended
capability. Currently one type "EXT_CAP_PI" is supported. This ext_cap requires
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

	 sqe->ext_cap = EXT_CAP_PI;
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

         sqe->ext_cap = EXT_CAP_PI;
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
 block/fops.c                  | 45 ++++++++++++++----
 drivers/nvme/host/core.c      | 21 +++++----
 drivers/scsi/sd.c             |  4 +-
 include/linux/bio-integrity.h | 25 +++++++---
 include/linux/fs.h            |  1 +
 include/linux/uio.h           |  9 ++++
 include/uapi/linux/fs.h       |  9 ++++
 include/uapi/linux/io_uring.h | 34 ++++++++++++++
 io_uring/io_uring.c           |  8 ++++
 io_uring/rw.c                 | 88 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 13 files changed, 306 insertions(+), 46 deletions(-)

-- 
2.25.1


