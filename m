Return-Path: <io-uring+bounces-2343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0074917FED
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F9271C21D1F
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E314D17F4F0;
	Wed, 26 Jun 2024 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XU7uaino"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A60E17F4E8
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402111; cv=none; b=XCtdGRQgKx+bOt/I0h0MnOVOg9WBkjne+svfxLproCDqenHV4B3/50AzbF+CZRKKny/3VwiRqttGq40LZ2P7o2MJ5F6aHo5katfC4eL0l0J5HAYCOdmYlWMk2yd2+sVNgXklpCpZ0HEdsvvzby5KI0UbA3qxoxOBOu/lr5kkJZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402111; c=relaxed/simple;
	bh=W3RMzDViQh4gqMhmybXU7mNEOtXMO8SRkOTSDiQ6Dlg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Rw3M5F1RKMFRN3UJI4AgrNwa6S6StgMttJ66iIphq5rMIt/sDRwELk1mNvV86j8E//u/Az8M2oClPxvij+lC1i20y9QIaFOKhX26GsUhNPO/foufAY+KFUjK/81z+I8TDUfKz4f3s9e0kY6bdWv4NZ581sKBtySO9ZseTN3XGrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XU7uaino; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240626114140epoutp020996a4cc7d29cab3919c3903c7e49e85~cixnb2-RU0090100901epoutp02f
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:41:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240626114140epoutp020996a4cc7d29cab3919c3903c7e49e85~cixnb2-RU0090100901epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402100;
	bh=AiYF3SvzbJSOOU9YaBYI5hh4dDdtFAHbd8Yk/ZuJRac=;
	h=From:To:Cc:Subject:Date:References:From;
	b=XU7uainox3ieFkj6lKbJp4RdHjSxbscYsynXkRgnoHINyLyphuJVTq78cdPvyWYbZ
	 jzOwYxA1h84tSyyS82CjXotDwqmj384maHxOlMG9LoKq2HVxEMgLu/NfHCdla1aJCL
	 /LD/lvcvBnrDqCYvbX2n2H84h2WmXanQo5rBJBBA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240626114140epcas5p35428e65ab929ff0f1a7e2ab94d35cb2f~cixm1JCu02483924839epcas5p3Y;
	Wed, 26 Jun 2024 11:41:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W8KXy3bLBz4x9Pp; Wed, 26 Jun
	2024 11:41:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.5B.06857.27EFB766; Wed, 26 Jun 2024 20:41:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c~chlSN__Xh1180011800epcas5p3P;
	Wed, 26 Jun 2024 10:14:15 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240626101415epsmtrp24b09ca7def050861363084196318513a~chlSNPRkx1187111871epsmtrp2I;
	Wed, 26 Jun 2024 10:14:15 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-25-667bfe72c043
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	54.3C.18846.7F9EB766; Wed, 26 Jun 2024 19:14:15 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101413epsmtip10ad8b44a48c3bfcd84e91742fe72acdf~chlQLwbJ20093400934epsmtip1c;
	Wed, 26 Jun 2024 10:14:13 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 00/10] Read/Write with meta/integrity
Date: Wed, 26 Jun 2024 15:36:50 +0530
Message-Id: <20240626100700.3629-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmum7Rv+o0g64dQhZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbrH8+D8mi4kdV5kcuDx2zrrL7nH5bKnH
	plWdbB6bl9R77L7ZwObx8ektFo/3+66yefRtWcXo8XmTXABnVLZNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCZSgpliTmlQKGAxOJiJX07m6L80pJU
	hYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjAWnnjAVHLKvmHaykb2B8b92
	FyMnh4SAicTxzXeZuhi5OIQEdjNKTO76xQLhfGKUaJvVyA7nLH23jrGLkQOs5fx3qKKdjBIN
	q1uhnM9ARdebmEDmsgmoSxx53soIYosI1EqsbJ3ODmIzC9RJzLrxH8wWFrCQ+LZ9AwuIzSKg
	KnG39ThYLy9QvO/sGWaI++QlZl76zg4RF5Q4OfMJC8QceYnmrbOZQRZLCPxll+j9vJgNosFF
	4tiVw1DNwhKvjm9hh7ClJD6/2wtVky7x4/JTJgi7QKL52D5GCNteovVUPzPIl8wCmhLrd+lD
	hGUlpp5axwSxl0+i9/cTqFZeiR3zYGwlifaVc6BsCYm95xqgbA+Jw88gaoQEYiU2n1/BNIFR
	fhaSd2YheWcWwuYFjMyrGCVTC4pz01OLTQuM81LL4RGbnJ+7iRGcWrW8dzA+evBB7xAjEwfj
	IUYJDmYlEd7Qkqo0Id6UxMqq1KL8+KLSnNTiQ4ymwDCeyCwlmpwPTO55JfGGJpYGJmZmZiaW
	xmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwSV06ezAkplKL902/L59o+6n4xONtZzf1
	ebz+mXbzeP683H86i/NmCdv/YXe/vrjfVOnICl2xglnxziLx3ebPnSdu+KrZ7bZv8nqhk4oq
	Bz6yFN6amhThs/uaV9r5mg+CRqf/XCzxkuPVWGqU9v+y7mLNNT1my9u7f7xbOctzzhJJmWOc
	t6/cKO999u94zZTErt9BhcqLJmowOopWM/2ZoeMlcu6pg5V9sJoT82Gzd1JHv6c7KczdVnRz
	xzWf2KReyercF8yR7ryHdJ7sEvVY6W34v/DK1W06Kq8nr1zw9O3n1TIf4qxn5ZgvrnCoXtSm
	rbOFJ/QnV+feh0eXsgY6yEyu/cRf9uBsovaf6XkcSizFGYmGWsxFxYkAzcFFljYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnO73l9VpBj9viVk0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpu8Xy4/+YLCZ2XGVy4PLYOesuu8fls6Ue
	m1Z1snlsXlLvsftmA5vHx6e3WDze77vK5tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZC049
	YSo4ZF8x7WQjewPjf+0uRg4OCQETifPfWboYuTiEBLYzSjz4t4uxi5ETKC4hcerlMihbWGLl
	v+fsEEUfGSWmNu4DS7AJqEsced7KCJIQEWhllDgwtQXMYRZoYpRY9eAEG0iVsICFxLftG1hA
	bBYBVYm7rceZQGxeoHjf2TPMECvkJWZe+s4OEReUODnzCVg9M1C8eets5gmMfLOQpGYhSS1g
	ZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERzgWkE7GJet/6t3iJGJg/EQowQHs5IIb2hJ
	VZoQb0piZVVqUX58UWlOavEhRmkOFiVxXuWczhQhgfTEktTs1NSC1CKYLBMHp1QDU+Ktr73l
	C30vWey+FfYmRmqB7pJPD9Xddr/IcxWZfmrmBt5pe+Kcbu32OLesaeN87UQmpS2HhUMEI1jO
	HHhUfa0vO2KS0sy+iX+n8Gi6zN/z/vm7Za4hnb184k2cAntCrPRUOxte/frFcDPU8svn/ztP
	Cx+Uqvjz/fP6jnUvLk1T+rZJ4avKuWilmVfVS403xKVfzTt/71/nzyajUwXbTFRm72LaW971
	i0lKleOd5Qft6wbGEx8GWsXY9QgoMrUaHDEOzmVze5h0p8fN7tWu6V6/1Pj5mFe5LTlxxnjP
	rKavR89H+M3fzvvdY/KqwMwU+8lzVwmLMNzc+GGPvPLj/50Jcrkqx9PrL1YnyxUVLVdiKc5I
	NNRiLipOBAAQh07h3wIAAA==
X-CMS-MailID: 20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c
References: <CGME20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c@epcas5p3.samsung.com>

This adds a new io_uring interface to exchange meta along with read/write.

Interface:
Meta information is represented using a newly introduced 'struct io_uring_meta'.
Application sets up a SQE128 ring, and prepares io_uring_meta within unused
portion of SQE. Application populates 'struct io_uring_meta' fields as below:

* meta_type: describes type of meta that is passed. Currently one type
"Integrity" is supported.
* meta_flags: these are meta-type specific flags. Three flags are exposed for
integrity type, namely INTEGRITY_CHK_GUARD/APPTAG/REFTAG.
* meta_len: length of the meta buffer
* meta_addr: address of the meta buffer
* apptag: optional application-specific 16b value; this goes along with
INTEGRITY_CHK_APPTAG flag.

Block path (direct IO) and NVMe driver are modified to support
this.

The first patch is borrowed from Mikulas series[1] to make the metadata split
work correctly.
Next 5 patches are enhancements in the block/nvme so that user meta buffer
is handled correctly (mostly when it gets split).

Patch 8 adds the io_uring support.
Patch 9 adds the support for block direct IO, and patch 10 for NVMe.

Example program on how to use the interface is appended below [2]

Tree:
https://github.com/SamsungDS/linux/tree/feat/pi_us_v2
Testing:
has been done by modifying fio to use this interface.
https://github.com/samsungds/fio/commits/feat/test-meta-v3

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

[1] https://lore.kernel.org/linux-block/719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com/

[2]

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
	 struct io_uring_meta *md;

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

	 md = (struct io_uring_meta *) sqe->cmd;
	 md->meta_type = META_TYPE_INTEGRITY;
	 md->meta_addr = (__u64)wmb;
	 md->meta_len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
	 md->meta_flags = INTEGRITY_CHK_APPTAG;
         md->apptag = 0x1234;

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

	 md = (struct io_uring_meta *) sqe->cmd;
	 md->meta_type = META_TYPE_INTEGRITY;
	 md->meta_addr = (__u64)rmb;
	 md->meta_len = META_LEN;
	 md->meta_flags = INTEGRITY_CHK_APPTAG;
         md->apptag = 0x1234;

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

Anuj Gupta (5):
  block: set bip_vcnt correctly
  block: copy bip_max_vcnt vecs instead of bip_vcnt during clone
  block: Handle meta bounce buffer correctly in case of split
  block: modify bio_integrity_map_user to accept iov_iter as argument
  io_uring/rw: add support to send meta along with read/write

Kanchan Joshi (4):
  block: introduce BIP_CLONED flag
  block: define meta io descriptor
  block: add support to pass user meta buffer
  nvme: add handling for user integrity buffer

Mikulas Patocka (1):
  block: change rq_integrity_vec to respect the iterator

 block/bio-integrity.c         | 75 ++++++++++++++++++++++++++-----
 block/fops.c                  | 28 +++++++++++-
 block/t10-pi.c                |  6 +++
 drivers/nvme/host/core.c      | 85 ++++++++++++++++++++++++-----------
 drivers/nvme/host/ioctl.c     | 11 ++++-
 drivers/nvme/host/pci.c       |  6 +--
 include/linux/bio.h           | 25 +++++++++--
 include/linux/blk-integrity.h | 16 +++----
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h | 30 ++++++++++++-
 io_uring/io_uring.c           |  7 +++
 io_uring/rw.c                 | 68 ++++++++++++++++++++++++++--
 io_uring/rw.h                 |  9 +++-
 13 files changed, 308 insertions(+), 59 deletions(-)

-- 
2.25.1


