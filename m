Return-Path: <io-uring+bounces-3722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A4B49A09E1
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A6711C221EB
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D4D2076BA;
	Wed, 16 Oct 2024 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G1V+LwY2"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAB7207A09
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082171; cv=none; b=hfZDzvWKhwdnrUEjVVUsCcZsMmYdRK34iHeYBHqhbONTEQ/YCd6HU1VCRub6ask9jgLrlIbBU+S7V+fcYZrA5gUAuvu+MpbXG1FqTA/1EeUFJTf8nZJ0HNrNmA9lv2+oT/yWkTThcZkMOLOhQj79oouo2ml5TNJyvq58r1xNRJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082171; c=relaxed/simple;
	bh=hVeJGTBYtVv2/e1F/w9T+eeXJx80a5UnVMQJFjNkC/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=F9puYKLcv0sfgDaebErMcsbfIC1s67tcasNnJRruRczunIlg6LHJ5YM6mtFuNk0vN55jm6vEZGf7EA/c9h/IP+kyj+dIK2yqXOWjI841ACXTwy7VdCu+2fg0toj0ecioh4W1YfVFDQX6rjlb6BTFLPqO/JsdRbXljzxZVJyDIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G1V+LwY2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241016123559epoutp0136298256fb2a35c50ef7a0727c6d670a~_7xAhZbwg1389913899epoutp01V
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:35:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241016123559epoutp0136298256fb2a35c50ef7a0727c6d670a~_7xAhZbwg1389913899epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082159;
	bh=Sb/pk9dMsOUBKGiAWHycBuaqxjexNbFNsplJgfsEHb8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=G1V+LwY2+to+A9Zf5wJhzfFPRW639e+PlNe++ijfsFXimVCp7csBAFsCi194Ce8lM
	 G8IydHpDAHiXPWhKFw8mfn8sVl04yXzcRFMuPfRCOXYHo1dMEVfAmm9VKaDzm0PzsL
	 ig3ZQTDTY2IiMccmrrjRxek/1a9EKD/lSix8WvFM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241016123558epcas5p249d01b1c8c13d512729893059b35cb99~_7w-Ssh671006810068epcas5p2u;
	Wed, 16 Oct 2024 12:35:58 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XT9Rw2J5Fz4x9Pv; Wed, 16 Oct
	2024 12:35:56 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	28.43.18935.C23BF076; Wed, 16 Oct 2024 21:35:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113705epcas5p1edc284b347de99bc34802b0b0c5e1b27~_69lYO5SU0521105211epcas5p13;
	Wed, 16 Oct 2024 11:37:05 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113705epsmtrp23868538cb4202b0e4491b76ae03ae845~_69lWXT6C1555115551epsmtrp2M;
	Wed, 16 Oct 2024 11:37:05 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-e3-670fb32ca9fe
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.9A.07371.165AF076; Wed, 16 Oct 2024 20:37:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113703epsmtip1e45fcbf9f84c0f65771cd12a2aa2f6d8~_69jWG5F32858028580epsmtip1J;
	Wed, 16 Oct 2024 11:37:03 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 00/11] Read/Write with meta/integrity
Date: Wed, 16 Oct 2024 16:59:01 +0530
Message-Id: <20241016112912.63542-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJsWRmVeSWpSXmKPExsWy7bCmlq7OZv50gy3veSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOmNrxlLFgTljFva3bmBoYZ9p1MXJySAiYSPw8/ZKli5GLQ0hgD6PEtRULoJxPjBIPfvUy
	QTjfGCUWP94GlOEAa/kzQxkivpdR4sChj6wQzmdGiecnF7OAzGUTUJc48ryVEcQWEZgElLgc
	CmIzC5xilFj7SwHEFhawkPh35xJYDYuAqsSTJQ1gvbwClhKHO08zQtwnLzHz0nd2iLigxMmZ
	T1gg5shLNG+dzQyyWEJgLodE79P3bBANLhJ31j1ggbCFJV4d38IOYUtJfH63F6omXeLH5adM
	EHaBRPOxfVDL7CVaT/Uzg3zJLKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpJoXzkH
	ypaQ2HuuAcr2kDh+uZMVxBYSiJW49Hc30wRG+VlI3pmF5J1ZCJsXMDKvYpRKLSjOTU9NNi0w
	1M1LLYfHbHJ+7iZGcArWCtjBuHrDX71DjEwcjIcYJTiYlUR4J3XxpgvxpiRWVqUW5ccXleak
	Fh9iNAUG8kRmKdHkfGAWyCuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+J
	g1OqgSnne1r/zGf23mJux6cx3jCz4ZnloVi/6dFF4+xGs0M9HW92FLM3iNlErXhhyP789Pct
	Hntfpq7ezllizxw4TarSMpR558FWx5iLMSLXKjoEox8UvFzfkvZS+WTGrRt3Vjknvn3zIf7E
	+obDe/K3im4JWT9dwKGuh9/ib616yKqjz8+fne95/9YSg9ZSvdodf3QKXiwVMZ676l2EjOW0
	tfFJnqoX/2tP7z4XMDn9a9vBwmP8GhMj2oTPhth4P7wptk9aUHiCRdr57P+uxgbvlIs+mHMo
	WVTkKTz4+6uzhUeluUcmJcwj0VO+IHHeWodvyU2XG/ft0Tg2s0ty6sLE6cu3382tPM2aJzW5
	2chVU4mlOCPRUIu5qDgRABHGvf1KBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSnG7iUv50g/4bShYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYTDp0jdFi+5mlzBZ7b2lbzF/2lN2i+/oONovl
	x/8xWZyfNYfdgc9j56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweH5/eYvHo27KK0WPz6WqPz5vk
	AjijuGxSUnMyy1KL9O0SuDKmdjxlLJgTVnFv6zamBsaZdl2MHBwSAiYSf2YodzFycQgJ7GaU
	ODD5JFsXIydQXELi1MtljBC2sMTKf8/ZIYo+MkrMvXyRHSTBJqAuceR5KyNIQkRgFqPE4Vnz
	mUAcZoELjBJX9z0DqxIWsJD4d+cS2CgWAVWJJ0saWEBsXgFLicOdp6FWyEvMvPSdHSIuKHFy
	5hOwGmagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMj
	OB60NHYw3pv/T+8QIxMH4yFGCQ5mJRHeSV286UK8KYmVValF+fFFpTmpxYcYpTlYlMR5DWfM
	ThESSE8sSc1OTS1ILYLJMnFwSjUwmbwyfuAmvUX3xo6DXheeZma2LO/oXHvImb1HtDrtRc+p
	hvXPL5jHvvhiw6xqKXtvleOagj/50o0LjnLNM144+0x/o2/G72ML/Q1kEjj8JBQWl5bfXBB5
	dT7jg1jWULPlR/7uS77EwHS66JNDSE3AzZim2usLjtsdtue0X+U6vWry6yXPVJcJLEspNZrN
	EpNQuNd0FXv+t9spD/9UV4b7et/5ukji48nfU+UqUyrzjj9vneG0xCJPYcaMrcomOwqb/gY9
	e9Ozb/vGybnz3pg9UGVR+dmdfs357t3Ww+6KHcr/m3gKwm/JztilsWc53/2MF7nCErM/Mp1Q
	cGs5p9S92mH1mmy15zEqk2VWVD0oVWIpzkg01GIuKk4EAI7kmnL2AgAA
X-CMS-MailID: 20241016113705epcas5p1edc284b347de99bc34802b0b0c5e1b27
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113705epcas5p1edc284b347de99bc34802b0b0c5e1b27
References: <CGME20241016113705epcas5p1edc284b347de99bc34802b0b0c5e1b27@epcas5p1.samsung.com>

This adds a new io_uring interface to exchange meta along with read/write.

Interface:
Meta information is represented using a newly introduced 'struct io_uring_meta'.
Application sets up a SQE128 ring, and prepares io_uring_meta within second
SQE. Application populates 'struct io_uring_meta' fields as below:

* meta_type: describes type of meta that is passed. Currently one type
"Integrity" is supported.
* meta_flags: these are meta-type specific flags. Three flags are exposed for
integrity type, namely BLK_INTEGRITY_CHK_GUARD/APPTAG/REFTAG.
* meta_len: length of the meta buffer
* meta_addr: address of the meta buffer
* seed: seed value for ref tag remapping
* app_tag: optional application-specific 16b value; this goes along with
INTEGRITY_CHK_APPTAG flag.

Block path (direct IO) , NVMe and SCSI driver are modified to support
this.

Patch 1 is an enhancement patch.
Patch 2 is required to make the user metadata split work correctly.
Patch 3 to 6 are prep patches.
Patch 7 adds the io_uring support.
Patch 8 gives us unified interface for user and kernel generated
integrity.
Patch 9 adds the support for block direct IO, patch 10 for NVMe, and
patch 11 for SCSI.

In patch 11 for scsi, we added a check to prevent scenarios where refcheck
is specified without appcheck and vice-versa, as it is not possible in
scsi. However block layer generated integrity doesn't specify appcheck.
For drives formatted with type1/type2 PI, block layer would specify refcheck
but not appcheck. Hence, these I/O's would fail. Any suggestions how this
could be handled?

Some of the design choices came from this discussion [1].

Example program on how to use the interface is appended below [2]
(It also tests whether reftag remapping happens correctly or not)

Tree:
https://github.com/SamsungDS/linux/tree/feat/pi_us_v4
Testing:
has been done by modifying fio to use this interface.
https://github.com/SamsungDS/fio/tree/priv/feat/pi-test-v5

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


[1] https://lore.kernel.org/linux-block/20240705083205.2111277-1-hch@lst.de/

[2]

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/blkdev.h>
#include <linux/io_uring.h>
#include <linux/types.h>
#include "liburing.h"

/* write data/meta. read both. compare. send apptag too.
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

         md = (struct io_uring_meta *) sqe->big_sqe_cmd;
         md->meta_type = META_TYPE_INTEGRITY;
         md->meta_addr = (__u64)wmb;
         md->meta_len = META_LEN;
         /* flags to ask for guard/reftag/apptag*/
         md->meta_flags = BLK_INTEGRITY_CHK_GUARD | BLK_INTEGRITY_CHK_REFTAG | BLK_INTEGRITY_CHK_APPTAG;
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

         md = (struct io_uring_meta *) sqe->big_sqe_cmd;
         md->meta_type = META_TYPE_INTEGRITY;
         md->meta_addr = (__u64)rmb;
         md->meta_len = META_LEN;
         md->meta_flags = BLK_INTEGRITY_CHK_GUARD | BLK_INTEGRITY_CHK_REFTAG | BLK_INTEGRITY_CHK_APPTAG;
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

Anuj Gupta (8):
  block: define set of integrity flags to be inherited by cloned bip
  block: copy back bounce buffer to user-space correctly in case of
    split
  block: modify bio_integrity_map_user to accept iov_iter as argument
  fs: introduce IOCB_HAS_METADATA for metadata
  block: add flags for integrity meta
  io_uring/rw: add support to send meta along with read/write
  block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
  scsi: add support for user-meta interface

Kanchan Joshi (3):
  block: define meta io descriptor
  block: add support to pass user meta buffer
  nvme: add support for passing on the application tag

 block/bio-integrity.c         | 73 +++++++++++++++++++++++++++++-----
 block/blk-integrity.c         | 10 ++++-
 block/fops.c                  | 44 +++++++++++++++-----
 drivers/nvme/host/core.c      | 21 ++++++----
 drivers/scsi/sd.c             | 25 +++++++++++-
 include/linux/bio-integrity.h | 30 ++++++++++++--
 include/linux/fs.h            |  1 +
 include/uapi/linux/blkdev.h   | 11 +++++
 include/uapi/linux/io_uring.h | 26 ++++++++++++
 io_uring/io_uring.c           |  6 +++
 io_uring/rw.c                 | 75 +++++++++++++++++++++++++++++++++--
 io_uring/rw.h                 | 15 ++++++-
 12 files changed, 300 insertions(+), 37 deletions(-)

-- 
2.25.1


