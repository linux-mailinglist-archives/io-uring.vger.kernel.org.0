Return-Path: <io-uring+bounces-1628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5068B2857
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5224281D7A
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A715112C559;
	Thu, 25 Apr 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QdNVJyGe"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1A12C463
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070823; cv=none; b=h2U/c/5zFgm+5dVyE51bdA7Z1SslqIFqepaEJw1MA+FZ3CW9uAGzHo1RvQDGJvVzEjfVR80+ArCxcIkWyWZ9rJCJdP2mbvK7XSdOBdQ9RvwFN/k2MxLRdmWRUWg4gh3or01Aa4P30Qd5MMD109sO9lBs/cZxVg8YTLfRxF40jLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070823; c=relaxed/simple;
	bh=h/g7SrCdBNJfFbgaS9xsbVkJ2hSGYvQP2fdZoqHUugU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Ak9VFY+85yhe4u2DphVzoIXUdrKUfUYwmHFbcOTHKkHvnsG2t/wg9BTBvb9XMWCtYWNy9/unqp4aeuNZJMniVTvCUkCXi74EomTY7Cqb/R8nE2CM4MipoNGIXp/acntrpQjwsFanIm6+U/ijL2TAGz5otVQWfPM6srTRFVxIIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QdNVJyGe; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240425184652epoutp03bd4f0d5b060b2765492c7e1ef6d3e2ca~JmlJ0SitS2203222032epoutp03Z
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:46:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240425184652epoutp03bd4f0d5b060b2765492c7e1ef6d3e2ca~JmlJ0SitS2203222032epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070812;
	bh=TDCdrILbFtttdG8lji0oxmKuVLyeKWNP7JmMpo2fgk0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=QdNVJyGeaYAcCTTJbq3KE32DKw75kYsk7f22VL3rEYALQR+LDjceiMcQTNLdNM/FK
	 QvG6Iem/6zuqK/L6tXKSwTK50o22DNpUq4Xz8K6b2+FsRKh1ICVIWzqRzi86u0gQWk
	 MoUXu8oeCHOpT5a3lHAXJZW7GmyitzaXBCF6mRMI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240425184651epcas5p499b39d72a9156fecd9f95d89172ff94b~JmlJVZGeC1507915079epcas5p4X;
	Thu, 25 Apr 2024 18:46:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VQPwB28tDz4x9Pq; Thu, 25 Apr
	2024 18:46:50 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.AC.09688.A15AA266; Fri, 26 Apr 2024 03:46:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240425184649epcas5p42f6ddbfb1c579f043a919973c70ebd03~JmlH0KWwt1507515075epcas5p4T;
	Thu, 25 Apr 2024 18:46:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240425184649epsmtrp29af0648699d87d5f21516132f3c20000~JmlHzctEY0239002390epsmtrp2X;
	Thu, 25 Apr 2024 18:46:49 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-db-662aa51a4f8f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4E.D7.08924.915AA266; Fri, 26 Apr 2024 03:46:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184648epsmtip144b385e99aad1a1a23a04047950fa823~JmlGBoP2v2930429304epsmtip1e;
	Thu, 25 Apr 2024 18:46:47 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 00/10] Read/Write with meta/integrity
Date: Fri, 26 Apr 2024 00:09:33 +0530
Message-Id: <20240425183943.6319-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmuq7UUq00gxVXuC3mrNrGaLH6bj+b
	xevDnxgtXs1Yy2Zx88BOJouVq48yWbxrPcdicfT/WzaLSYeuMVrsvaVtMX/ZU3aL5cf/MTnw
	eFybMZHFY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f3mLx6NuyitHj8ya5AM6obJuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZu6dsYi/Y
	a1lxYP09tgbG+WpdjJwcEgImEm//zGDuYuTiEBLYzSjR+WwpI4TziVFi2+lVUM43RolzS74y
	w7TsvLcWKrGXUWLD7+esEM5nRomz1yaydTFycLAJaEpcmFwK0iAikCLxat1rsAZmgQOMEoue
	P2EDSQgLmEqcWfYCbCqLgKrE9+0HwOK8AuYS5zdfg9omLzHz0nd2iLigxMmZT1hAbGagePPW
	2WCHSwj0ckgcuvYCqsFFYu29ZlYIW1ji1fEt7BC2lMTnd3vZIOxkiUszzzFB2CUSj/cchLLt
	JVpP9TODPMAM9MD6XfoQu/gken8/YQIJSwjwSnS0CUFUK0rcm/QUapO4xMMZS6BsD4neT7MY
	QWwhgViJyW8+M01glJuF5INZSD6YhbBsASPzKkbJ1ILi3PTUYtMCo7zUcnhkJufnbmIEp1Ut
	rx2MDx980DvEyMTBeIhRgoNZSYT35keNNCHelMTKqtSi/Pii0pzU4kOMpsBgncgsJZqcD0zs
	eSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MKVvMn1kUzy/U+SZ
	n/KNg07Kd95umV8RxaLlv6LSInTpU5mjQf5nGBhn6P1QCfFlEC7sulv5irfsmn/Sa6bPNv0B
	vWfUzx49V719RpbNoc2njCf6W0ib/vn2ZIb6Vq7WaeWmn1dPPOtWPvPMzMMn/B30pEUMVJUF
	/U961z/V/dPiVfEyr/yAr/DeNw6GLYdnm04sOpc1Z6OSffeEhOPLTr9dpjZllo5ctO4JfbtC
	6+Q1uwTMH599IK6WuG52xCTFyGuXkncVrF+9bfaeohWPrn6z+MBh/lB9hmjwfV6TecbHbyfM
	YhP/t6+pVJ35yG+3sHO5qu6li6eub6pV2OP+Xq3AXVZyLWdT69ykJb8XrFViKc5INNRiLipO
	BABgwEvfNAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnK7kUq00gwuNRhZzVm1jtFh9t5/N
	4vXhT4wWr2asZbO4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC323tK2mL/sKbvF8uP/mBx4
	PK7NmMjisXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1ZxejxeZNcAGcUl01Kak5m
	WWqRvl0CV8buKZvYC/ZaVhxYf4+tgXG+WhcjJ4eEgInEzntrGbsYuTiEBHYzShxsPcwCkRCX
	aL72gx3CFpZY+e85O0TRR0aJi+17mLsYOTjYBDQlLkwuBakREciS2Nt/BayGWeAEo8Sh+YfB
	moUFTCXOLHvBDGKzCKhKfN9+gA3E5hUwlzi/+RozxAJ5iZmXvrNDxAUlTs58AnYEM1C8eets
	5gmMfLOQpGYhSS1gZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc+lqaOxi3r/qg
	d4iRiYPxEKMEB7OSCO/NjxppQrwpiZVVqUX58UWlOanFhxilOViUxHnFX/SmCAmkJ5akZqem
	FqQWwWSZODilGpi01M7ut5r8/+GDD/5LYrZM/dDKt6Fflidw7+TEqZVJK+/trrxxrkfNyO5q
	fv/8rcXLcpz5c8SNn/1TE/uSKxwb8vCXfHe3X8/mf958T/tsDi/1yTlnzRrxL1FlW6/sDfVt
	/QxGzJdyZ+8PDTSRqttcZXCsPn9SddLuys99UzZ91X6xXNHNurxs76uAK8Ycq2vCxbb+DXxR
	/zlo9cv0wxxnWK5lN3L+Sf/t+td8gUrUweBoL3azezO/7Y2Xj50qL8R0QLE0L1+HK7siQ8fR
	vHHdlL+ql8pPMsQ4P99dbdNXUdz1iO88Q3qw6M1DX3/2vOtxvFY3+YSc0Y//FnP2lJhJW9/k
	urjznICnhvDmI0osxRmJhlrMRcWJACHLJVbsAgAA
X-CMS-MailID: 20240425184649epcas5p42f6ddbfb1c579f043a919973c70ebd03
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184649epcas5p42f6ddbfb1c579f043a919973c70ebd03
References: <CGME20240425184649epcas5p42f6ddbfb1c579f043a919973c70ebd03@epcas5p4.samsung.com>

This adds a new io_uring interface to specify meta along with
read/write. Beyond reading/writing meta, the interface also enables
(a) flags to control data-integrity checks, (b) application tag.

Block path (direct IO) and NVMe driver are modified to support
this.

First 5 patches are enhancements/fixes in the block/nvme so that user meta buffer
(mostly when it gets split) is handled correctly.
Patch 8 adds the io_uring support.
Patch 9 adds the support for block direct IO, and patch 10 for NVMe.

Interface:
Two new opcodes in io_uring: IORING_OP_READ/WRITE_META.
The leftover space in SQE is used to send meta buffer, its length,
apptag, and meta flags (guard/reftag/apptag check for now). Example
program on how to use the interface is appended below [1]

Another design choice will be not to introduce the new opcodes, and add
new RWF_META flag instead. Open to that in next version.
As for new meta flags, RWF_* seemed a bit precious to use. Hence took the route
to carve those within the SQE itself.

Performance:
of non-meta io is not affected due to these patches.

Testing:
has been done by modifying fio to use this interface.
https://github.com/SamsungDS/fio/commits/feat/test-meta-v2

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
         sqe->opcode = IORING_OP_WRITE_META;
         sqe->meta_addr = (__u64)wmb;
         sqe->meta_len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         sqe->meta_flags = META_CHK_APPTAG;
         sqe->apptag = 0x1234;

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
         sqe->opcode = IORING_OP_READ_META;
         sqe->meta_addr = (__u64)rmb;
         sqe->meta_len = META_LEN;
         sqe->meta_flags = META_CHK_APPTAG;
         sqe->apptag = 0x1234;

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


Anuj Gupta (6):
  block: set bip_vcnt correctly
  block: copy bip_max_vcnt vecs instead of bip_vcnt during clone
  block: copy result back to user meta buffer correctly in case of split
  block: avoid unpinning/freeing the bio_vec incase of cloned bio
  block: modify bio_integrity_map_user argument
  io_uring/rw: add support to send meta along with read/write

Kanchan Joshi (4):
  block, nvme: modify rq_integrity_vec function
  block: define meta io descriptor
  block: add support to send meta buffer
  nvme: add separate handling for user integrity buffer

 block/bio-integrity.c         | 69 +++++++++++++++++++++++--------
 block/fops.c                  |  9 +++++
 block/t10-pi.c                |  6 +++
 drivers/nvme/host/core.c      | 36 ++++++++++++++++-
 drivers/nvme/host/ioctl.c     | 11 ++++-
 drivers/nvme/host/pci.c       |  9 +++--
 include/linux/bio.h           | 23 +++++++++--
 include/linux/blk-integrity.h | 13 +++---
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h | 15 +++++++
 io_uring/io_uring.c           |  4 ++
 io_uring/opdef.c              | 30 ++++++++++++++
 io_uring/rw.c                 | 76 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 | 11 ++++-
 14 files changed, 276 insertions(+), 37 deletions(-)


base-commit: 24c3fc5c75c5b9d471783b4a4958748243828613
-- 
2.25.1


