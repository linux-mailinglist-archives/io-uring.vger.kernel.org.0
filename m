Return-Path: <io-uring+bounces-3279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8FD984236
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DB021C23BB1
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD501552F5;
	Tue, 24 Sep 2024 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J8EjFUUf"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B8C16C69F
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170375; cv=none; b=jsPwAztVdLP7zwkmhNZdEwwYhvpfz4NqV67Uarmd60h13nW00TcPQxDKTgh9f6xJiiX5N6qre8SdsOk5YPEqCdRDIGN3FsLvkmEoGfAD6D37Q+PG2NXxHu5EwZXgT6IiiEp7iMDky5NO7gsxCx7gWLoHjNcAY8X6skc3c7ArXBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170375; c=relaxed/simple;
	bh=VHEY5enqTMnC/+RG2f9x6q557yzmCYer09TIlKHohU4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=WJwavuOdJ8eXiZAOiD+Pic7qgFT/Tuy7B2UvQYhDv7VcK7NAZGwIhpDww7JsTksN9LZtruWkG8QOCLdxilz0iOYi6lu6XYLmctesBFsO6qUyvMn56MgA2taGlyKOR1Maqz2PWn534AzVE9zpV5L6OhfYRf/4rXRslzgU+EMqrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=J8EjFUUf; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240924093250epoutp0490715f80ddc33863658f4cf040f3675a~4JE0GrZXT2432124321epoutp04s
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240924093250epoutp0490715f80ddc33863658f4cf040f3675a~4JE0GrZXT2432124321epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727170370;
	bh=O/zo7RhP61a9O8LhrGF/ZtU+oupMYRBaBJMbkLt8RWE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=J8EjFUUfgBjp+HMXv7klApRcsEB61VDto7YGUaMRPQJsmLh/H9UAIOEgPeZxVkg/j
	 ybNYkLU8oxuhJ7vSCRt21OgGkl+aCAkHzmEeWzXUDOJ6mJ5ngvF9YuW3/GkM4qsnzY
	 OEtEcMds5gJjd7j9KpHN+DQu3WczJ5RsAUsy5+90=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240924093249epcas5p3fcbf7bcc0b66c56c798faa982378d7a9~4JEzWd1nY1076610766epcas5p3H;
	Tue, 24 Sep 2024 09:32:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XCZQl5qNKz4x9Q8; Tue, 24 Sep
	2024 09:32:47 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	11.BD.09640.F3782F66; Tue, 24 Sep 2024 18:32:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240924093247epcas5p4807fe5e531a2b7b2d6961d23bc989c80~4JExIvixO2460424604epcas5p4W;
	Tue, 24 Sep 2024 09:32:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240924093247epsmtrp12b64f86c2a37fd7b3e74534f718926df~4JExGlRU50907509075epsmtrp1Q;
	Tue, 24 Sep 2024 09:32:47 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-04-66f2873fcd23
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	36.C1.08964.E3782F66; Tue, 24 Sep 2024 18:32:46 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240924093243epsmtip2ac324fa66b8c50096f40fb2d889aea28~4JEuIOfcM0088900889epsmtip2D;
	Tue, 24 Sep 2024 09:32:43 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v6 0/3] per-io hints and FDP
Date: Tue, 24 Sep 2024 14:54:54 +0530
Message-Id: <20240924092457.7846-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHO/de9i7U6m1BPTIBy1YY4CIbCxwKhCm0WzKFMVk5GmxwYYl9
	uQ8ixkmGl4my5GKIi04SD3EZYkIkCNFYwI2m2lJwhAEiXChFAWHUCBfaZdfyv8/5nd/3fM/3
	PNg49ybLm50p1zAquVjKZ3kQbT2BQYLYg/PpodVzweiksQ2gxtEyFipZbiXQdM88QBVzizia
	yV8i0ND3HRg629iHoZmiXwhUdbwAQ9ZmA45ujCyQqG/lDgvpTdcAOlaRD1DXcDC60NVPoC/r
	J0l0xryMoa+nZwlksZndkMVwkoxbT18d2EF3GEZJ2jL2DUFf/VlLtxgPseiWeT1Jn6s9QHcO
	5bHou5PDBD17cZBF61qNgP7pdC9JL7T40i3WO1jimt1Z0RJGnMaoeIw8VZGWKc+I4e9ISn41
	OTwiVCgQRqFIPk8uljEx/PiERMH2TKk9Op+XLZZq7aVEsVrN37I1WqXQahieRKHWxPAZZZpU
	KVKGqMUytVaeESJnNC8JQ0NfDLc3pmRJKs/ewJSX1ubM9pa55YGeJ0uAOxtSIthkaSAdzKU6
	Aew9klsCPOw8D+DtqctuzsF9ANtNi+QjxZStFXdOdAH42w/drsECgNWmfruEzWZRgfDXcq2j
	7kUVY7BwvAJ3qHHKBqBpKMHBntRmaB0ZxRxMUM/DyzOdhIM5VCS0LFaxnG5+8MSVB6Sz/jTs
	P2ElnOv4wYLzVavGkCpwh2O9h1yCeGhbsLi26glvmVtd7A1vlhW7OAuOT4wTTt4P28/p3Jwc
	C/MeXl8NgNsDNH+3xem1BpYuWTFHGVIc+Fkx19ntD8f0ky7lBvhHZa2LaThY3wgc7VxqLxyt
	++hz4Gt4LIDhsQCG/71OA9wINjJKtSyDUYcrhXLm4/+uMlUhawGrbz7o9XYwOj4XYgIYG5gA
	ZON8L45+6G46l5Mm/iSXUSmSVVopozaBcPupHsW916Uq7J9GrkkWiqJCRREREaKosAghfwNn
	uuhUGpfKEGuYLIZRMqpHOozt7p2HHfxne+mft+KkmUWvPJEY9mCgir8IvYNjbg/f8yJ94pt1
	xsmm/d0ywVfdPjWnVkYG69ikQeeuwdqu5QerQjbnHDZy/HJ952ideenexTnetnXPfDo4MVEf
	0zDQAC9lj9e8tZJUvmnXBZvuvXfisIdRr3X7ek5ZX57Zd13tEXflBYlnwvsp5/O2HsD2fJiv
	7/BP8rp/ZiPGy0pP0Oa8cYy2Ba0176vvOpJd5yuKLRdIyADetsrS6P6j1o7DnqKCshpZ4abd
	DR/sHBs+vutZ/Rf+AY3LP2YQBKnZ+3dKWOD0U8XfCgqr8fXm35tYPu/2xUbPwIE3AyR7xirf
	zpfujKz8a6D2OQWfUEvEwiBcpRb/C8tarjh8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvK5d+6c0g80rbCzmrNrGaLH6bj+b
	Rde/LSwWrw9/YrSY9uEns8W7pt8sFjcP7GSyWLn6KJPFu9ZzLBazpzczWTxZP4vZ4vGdz+wW
	R/+/ZbOYdOgao8WUaU2MFntvaVvs2XuSxWL+sqfsFsuP/2OyWPf6PYvF+b/HWS3Oz5rD7iDm
	cfmKt8fOWXfZPc7f28jicflsqcemVZ1sHps+TWL32Lyk3mP3zQY2j49Pb7F4vN93lc2jb8sq
	Ro8zC46we3zeJOex6clbpgC+KC6blNSczLLUIn27BK6MGSsfMxXs5694f6SftYHxMHcXIyeH
	hICJxLO/W5i7GLk4hAR2M0r0HZjECpEQl2i+9oMdwhaWWPnvOTtE0UdGiZmPZzN2MXJwsAlo
	SlyYXAoSFxGYwSRxasVBNhCHWaCdSeLaxLvMIN3CAjoST+7cZQKxWQRUJY69280CYvMKmEuc
	/zmbDWKDvMTMS9/ZIeKCEidnPgGrYQaKN2+dzTyBkW8WktQsJKkFjEyrGCVTC4pz03OLDQsM
	81LL9YoTc4tL89L1kvNzNzGCI1JLcwfj9lUf9A4xMnEwHmKU4GBWEuGddPNjmhBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXFe8Re9KUIC6YklqdmpqQWpRTBZJg5OqQampKcL7P5O6GfV3sRXb6A6
	4/cC46sSGzlPeIbcmp2a05Tz7LJrXnPtafZ5kw4kLTaN/Pr+2pTnOfPvPjq/vl7BcULntY3T
	TwT17Sy48a2Sz3fRWt9b1e2et4IOs6zu2Bq8Mas6325hiRjzcq7NU67Vi17Ylf13KetpeXbG
	ksXBYUfk2P9scP93PFTFMnFb0ouJ32+ySc2LmWQv3KqTuWWpI1v8gePH5p26122v3cGckbT7
	R4LARsWXErbW3RsUjwZflZ1twrW/mWHjhqqY2Jo0+6u7ok75l70N7nnb57ljg0/LMrZcqScL
	VdId3I7psTNrHF+lGDdhkt6d1fNyzGyS9ex8/SS+3enKKvu3191CiaU4I9FQi7moOBEA0UbF
	+zcDAAA=
X-CMS-MailID: 20240924093247epcas5p4807fe5e531a2b7b2d6961d23bc989c80
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093247epcas5p4807fe5e531a2b7b2d6961d23bc989c80
References: <CGME20240924093247epcas5p4807fe5e531a2b7b2d6961d23bc989c80@epcas5p4.samsung.com>

Another spin to incorporate the feedback from LPC and previous
iteration. The series adds two capabilities:
- FDP support at NVMe level (patch #1)
- Per-io hinting via io_uring (patch #3)
Patch #2 is needed to do per-io hints.

The motivation and interface details are present in the commit
descriptions.

Testing:
Done with fcntl and liburing based custom applications.
On raw block device, ext4, xfs, btrfs and F2FS.
Checked that no regression occurs for application that use per-inode
hints.
Checked that per-io hints, when passed, take the precedence over per-inode
hints.

Changes since v5:
- Drop placement hints
- Add per-io hint interface

Changes since v4:
- Retain the size/type checking on the enum (Bart)
- Use the name "*_lifetime_hint" rather than "*_life_hint" (Bart)

Changes since v3:
- 4 new patches to introduce placement hints
- Make nvme patch use the placement hints rather than lifetime hints

Changes since v2:
- Base it on nvme-6.11 and resolve a merge conflict

Changes since v1:
- Reduce the fetched plids from 128 to 6 (Keith)
- Use struct_size for a calculation (Keith)
- Handle robot/sparse warning

Kanchan Joshi (3):
  nvme: enable FDP support
  block, fs: restore kiocb based write hint processing
  io_uring: enable per-io hinting capability

 block/fops.c                  |  6 +--
 drivers/nvme/host/core.c      | 70 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h      |  4 ++
 fs/aio.c                      |  1 +
 fs/cachefiles/io.c            |  1 +
 fs/direct-io.c                |  2 +-
 fs/fcntl.c                    | 22 -----------
 fs/iomap/direct-io.c          |  2 +-
 include/linux/fs.h            |  8 ++++
 include/linux/nvme.h          | 19 ++++++++++
 include/linux/rw_hint.h       | 24 ++++++++++++
 include/uapi/linux/io_uring.h | 10 +++++
 io_uring/rw.c                 | 20 ++++++++++
 13 files changed, 162 insertions(+), 27 deletions(-)

-- 
2.25.1


