Return-Path: <io-uring+bounces-2904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EABD495CAC4
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BBEF1F2799B
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFF9187353;
	Fri, 23 Aug 2024 10:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DMXeaswn"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9215187350
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410090; cv=none; b=QdxfSkU1hrWEk765U0pLmbkLuK4XMmd0PfyTb+SisUokPfjuR1AR67D56I7tGqftPXvDt87VqbOPh7ezhcpu34PUOB2q3ydGCiceFYwpxRbrrpmBHoDg7sbwzJgSFi7dZiL/cKkVfyE5L7QrL17b5ySUAo1BzlFblIZdZC6knvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410090; c=relaxed/simple;
	bh=EgOo2RdVvxEfaspXutVpouY3tst4yPfc+l642W7oIQo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=b5xGMWhTtKb64e0b1uxGA78ZXB7F45+PmpxifCQ9jVgE2vpkMk6hyujKnhdA0yQI0yHpv8/dXyPbDD6nbURNsnaxAktx28lq+zd6Y6OEag3RcSYmRmV7NwASo+IywpbwDYJb9g6t1xhMyDFbNj35RuSIL5JuLkuCyVYVeXx+PLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DMXeaswn; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240823104759epoutp04ffb5e5ec9b5b16be8bbbc2b2fd49db45~uVdTTigiR1659816598epoutp04F
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:47:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240823104759epoutp04ffb5e5ec9b5b16be8bbbc2b2fd49db45~uVdTTigiR1659816598epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410079;
	bh=ADBIpkeIB8Qi21TqEW0JFS/Lus6pDiHqXhO9uvgTh08=;
	h=From:To:Cc:Subject:Date:References:From;
	b=DMXeaswnxGx/c3Gfv1vTcRTWdtuAuSM993/lHvFWDTJkzLBIyQ9gUK6qiOMX+uxvV
	 5rCbXzj2Qe9PuzPxfTnS8XTeVgLOGdLt3sgcmQu0P/EraUGI1fRghuRrF9kHIohsfJ
	 KU62oyaz6xRKzqF8Ymef8zG+Dd10FfRoXhkfcqvQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240823104759epcas5p201ae2ecf4f855e66d2c4b5e06368aaf7~uVdS3L3pZ2862728627epcas5p2c;
	Fri, 23 Aug 2024 10:47:59 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WqxcF4njbz4x9Py; Fri, 23 Aug
	2024 10:47:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.7A.19863.DD868C66; Fri, 23 Aug 2024 19:47:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104552epcas5p226dbbbd448cd0ee0955ffdd3ad1b112d~uVbdEJJAv1853818538epcas5p2J;
	Fri, 23 Aug 2024 10:45:52 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240823104552epsmtrp1fce2f756964da5da85f1fe7c679dcebe~uVbdDfnuq0200102001epsmtrp1S;
	Fri, 23 Aug 2024 10:45:52 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-ce-66c868ddd764
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	EA.40.19367.06868C66; Fri, 23 Aug 2024 19:45:52 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104550epsmtip207cc970cee2c454ad86ac71f553e16a2~uVbbI4dcd1240712407epsmtip2T;
	Fri, 23 Aug 2024 10:45:50 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 00/10] Read/Write with meta/integrity
Date: Fri, 23 Aug 2024 16:08:00 +0530
Message-Id: <20240823103811.2421-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmuu7djBNpBheWKVg0TfjLbDFn1TZG
	i9V3+9ksbh7YyWSxcvVRJot3redYLCYdusZosf3MUmaLvbe0LeYve8pu0X19B5vF8uP/mBx4
	PHbOusvucflsqcemVZ1sHpuX1HvsvtnA5vHx6S0Wj74tqxg9Np+u9vi8SS6AMyrbJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsai1RtYCma4
	V8xu+83WwPjTsIuRk0NCwETi1bJuli5GLg4hgT2MEhu697NBOJ8YJRpa7jHCOW2nT7HAtPy4
	OwsqsZNRYtnci+wQzmdGiSl9D5lBqtgE1CWOPG9lBLFFBColnu/6AbaEWWATo8Sv68eYQBLC
	AhYS299uZgexWQRUJfb2LAGL8wLFX9y7ygaxTl5i5qXv7BBxQYmTM5+AncEMFG/eOpsZZKiE
	QCuHROvLi0AOB5DjIvH1pz1Er7DEq+Nb2CFsKYmX/W1QdrrEj8tPmSDsAonmY/sYIWx7idZT
	/WBjmAU0Jdbv0ocIy0pMPbWOCWItn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNTBBXOMh0X2M
	DyQsJBArcXveJuYJjPKzkDwzC8kzsxAWL2BkXsUolVpQnJuemmxaYKibl1oOj9nk/NxNjOB0
	qxWwg3H1hr96hxiZOBgPMUpwMCuJ8CbdO5omxJuSWFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OB
	CT+vJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+Jg5OqQYm3lP/uGZXbBJy
	trv+Qqxe+6aqQe4+l65epZ0CXp5W/9mb3Nunn1tmzfbqQqTPQX+etWnHJt2T//xn118vnkLm
	/5s5N101nZTJN8vyzgyxQwcOS51eHHXRbq/T+feKR1dvvd9ud+r5gyKPmXKKCjFnv3q9uThl
	f8H1H/d1/8RMdDHMuqZV6j/j9tW4nID86iWL82+KpWWsLvzuVPT5ub2FyfuQ1THz/Y52vY74
	cWHRfS6HOWKlrV2Fy3jn7W4t1Khf1tErNPFYXUdWjqf9HcnZV6o8vX+JJ56x+rrk5PzZxrMm
	NhQ+4EhIPHL+0FLJO2rl7Nv+vFb5N2+ul0+QSO/cem6zq1qnGHTXfs+6EbrslxJLcUaioRZz
	UXEiAOAkDb5ABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSvG5Cxok0g8kzjC2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mW
	WqRvl8CVsWj1BpaCGe4Vs9t+szUw/jTsYuTkkBAwkfhxdxYjiC0ksJ1RYuf5VIi4hMSpl8sY
	IWxhiZX/nrN3MXIB1XxklPj28QhYgk1AXeLI81ZGkISIQCOjxJbmLywgDrPADkaJdc8Wg1UJ
	C1hIbH+7mR3EZhFQldjbs4QJxOYFir+4d5UNYoW8xMxL39kh4oISJ2c+YQGxmYHizVtnM09g
	5JuFJDULSWoBI9MqRtHUguLc9NzkAkO94sTc4tK8dL3k/NxNjOCQ1wrawbhs/V+9Q4xMHIyH
	GCU4mJVEeJPuHU0T4k1JrKxKLcqPLyrNSS0+xCjNwaIkzquc05kiJJCeWJKanZpakFoEk2Xi
	4JRqYFp9aU/vnS9eG5sjF7peZt+vr+5T9v3Rita+6kTF+uq/544JihbzL1wzuz9V+4ahDltw
	TFBWnhCveqq9i/kLA72eP0G35K5U/eENn6LFfPRhg4fRQgPhlCTh1KPzaq8oXrJpMeCedDS/
	4vkE8wnHxZ65m4ed+bBwmdUXA/ZtTgu//dA8vljXLMDV0qtU5cOpCREnz0y/zf/Ru767rWDK
	HPfJvySe1Lpf2Cu6UpTpNfu9Y217t+8trQydY/z60371nLaTfJHPOfr1p/fKN9j0uh87X8x2
	Y9umdWuTgzW+PJfQVVnu8if8XejMBY68HIqHF5ya9jj++fLk16LKXSmfDt5y6J3ieMdMgzvh
	tvPtECWW4oxEQy3mouJEALqBhZroAgAA
X-CMS-MailID: 20240823104552epcas5p226dbbbd448cd0ee0955ffdd3ad1b112d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104552epcas5p226dbbbd448cd0ee0955ffdd3ad1b112d
References: <CGME20240823104552epcas5p226dbbbd448cd0ee0955ffdd3ad1b112d@epcas5p2.samsung.com>

This adds a new io_uring interface to exchange meta along with read/write.

Interface:
Meta information is represented using a newly introduced 'struct io_uring_meta'.
Application sets up a SQE128 ring, and prepares io_uring_meta within second
SQE. Application populates 'struct io_uring_meta' fields as below:

* meta_type: describes type of meta that is passed. Currently one type
"Integrity" is supported.
* meta_flags: these are meta-type specific flags. Three flags are exposed for
integrity type, namely INTEGRITY_CHK_GUARD/APPTAG/REFTAG.
* meta_len: length of the meta buffer
* meta_addr: address of the meta buffer
* app_tag: optional application-specific 16b value; this goes along with
INTEGRITY_CHK_APPTAG flag.

Block path (direct IO) , NVMe and SCSI driver are modified to support
this.

The first three patches are required to make the user metadata split
work correctly.
Patch 4,5 are prep patches.
Patch 6 adds the io_uring support.
Patch 7 gives us unified interface for user and kernel generated
integrity.
Patch 8 adds the support for block direct IO, patch 9 for NVMe, and
patch 10 for SCSI.

Some of the design choices came from this discussion [2].

Example program on how to use the interface is appended below [3]

Tree:
https://github.com/SamsungDS/linux/tree/feat/pi_us_v3
Testing:
has been done by modifying fio to use this interface.
https://github.sec.samsung.net/DS8-MemoryOpenSource/fio/tree/feat/test-meta-v4

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

[1] https://lore.kernel.org/linux-block/719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com/

[2] https://lore.kernel.org/linux-block/20240705083205.2111277-1-hch@lst.de/

[3]

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

         md = (struct io_uring_meta *) sqe->big_sqe_cmd;
         md->meta_type = META_TYPE_INTEGRITY;
         md->meta_addr = (__u64)wmb;
         md->meta_len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         md->meta_flags = INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;

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

         md = (struct io_uring_meta *) sqe->big_sqe_cmd;
         md->meta_type = META_TYPE_INTEGRITY;
         md->meta_addr = (__u64)rmb;
         md->meta_len = META_LEN;
         md->meta_flags = INTEGRITY_CHK_APPTAG;
         md->app_tag = 0x1234;

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
  block: introduce a helper to determine metadata bytes from data iter
  block: handle split correctly for user meta bounce buffer
  block: modify bio_integrity_map_user to accept iov_iter as argument
  io_uring/rw: add support to send meta along with read/write
  block,nvme: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
  scsi: add support for user-meta interface

Kanchan Joshi (3):
  block: define meta io descriptor
  block: add support to pass user meta buffer
  nvme: add handling for app_tag

 block/bio-integrity.c         | 71 ++++++++++++++++++++++++++++++-----
 block/fops.c                  | 25 ++++++++++++
 block/t10-pi.c                |  6 +++
 drivers/nvme/host/core.c      | 24 +++++++-----
 drivers/nvme/host/ioctl.c     | 11 +++++-
 drivers/scsi/sd.c             | 25 +++++++++++-
 drivers/scsi/sd_dif.c         |  2 +-
 include/linux/bio-integrity.h | 33 ++++++++++++++--
 include/linux/blk-integrity.h | 17 +++++++++
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h | 32 ++++++++++++++++
 io_uring/io_uring.c           |  6 +++
 io_uring/rw.c                 | 70 ++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 | 10 ++++-
 14 files changed, 302 insertions(+), 31 deletions(-)

-- 
2.25.1


