Return-Path: <io-uring+bounces-3330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9AD98ABF7
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF0ED1C22FF5
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38C0199381;
	Mon, 30 Sep 2024 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PDIWA60H"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3233DCA62
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720461; cv=none; b=Z46J4ch04k1xaDSPuftpoK3UkwFbrv17G55FYjhlTOKR9GD/4HqE5lmXGY3dgmkqpAXwpTCr0JDiFj6VmzmimN8Rovadcsbx2FAg/siGimbyaAo8oAiCuJaAuBLVQcerTmICyqaqGbX4qzn91mXipWs0rC8D9g8A2cXJyNk693M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720461; c=relaxed/simple;
	bh=NJhNSEWfQuicmoWnOXbPshrUmZB5Ti5qi6HbF/7gcdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=g1P8k3b2hH9u1TVvqWkt4YMQNAzyyg0Z3WL6mEBT/iGMQINm5AksNwjsDdhlLGPT3asXXmmUMw6Hf18UeZD76sqhu98FnFRvpS1EyMiDGzQrBmwpmaRIm7tip8amzn5D/lGzCXgKvYk7S5Qk/9evcTOjdW3f7/Mo9nwQuY+IVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PDIWA60H; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240930182056epoutp04862b76dc8b689fb3062a64ea46df904b~6GJneasqo2709827098epoutp04i
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:20:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240930182056epoutp04862b76dc8b689fb3062a64ea46df904b~6GJneasqo2709827098epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727720456;
	bh=4LBDHSJVU1H97AxnvlyhnVRQZzY6KCoCAgte1h6Y9Ng=;
	h=From:To:Cc:Subject:Date:References:From;
	b=PDIWA60HsX66Yl+6XwMQcuV3CMKnrJla0HRWBvwhf4xdjjAzMLLAFTTHV6HAVDsES
	 XM5grzbVxVObCatYW2KVmn13bfWdUaorWL0HmOWQL0yOf2CUo+AZCR01BpCZlxNQrm
	 4xo9hvZh9WIKE2rdr83ydHlDnyL9g5XLv10wS1cU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240930182055epcas5p1846d3252efb056c9fe61062565594212~6GJmjkRcY1760617606epcas5p17;
	Mon, 30 Sep 2024 18:20:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XHTsK3WZsz4x9Pp; Mon, 30 Sep
	2024 18:20:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BB.C9.09420.50CEAF66; Tue,  1 Oct 2024 03:20:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240930182052epcas5p37edefa7556b87c3fbb543275756ac736~6GJkcXrLq2353623536epcas5p3t;
	Mon, 30 Sep 2024 18:20:52 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240930182052epsmtrp2c5610fcd20805f353e1d082217316a9e~6GJkbaWbv2734327343epsmtrp2g;
	Mon, 30 Sep 2024 18:20:52 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-38-66faec05defa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.79.18937.40CEAF66; Tue,  1 Oct 2024 03:20:52 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240930182049epsmtip23462ac72f0fbc210f05d50b83d060b98~6GJhYF2Fl2298222982epsmtip23;
	Mon, 30 Sep 2024 18:20:49 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
	dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v7 0/3] FDP and per-io hints
Date: Mon, 30 Sep 2024 23:43:02 +0530
Message-Id: <20240930181305.17286-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVDTZRy/57ffXkAHPxncnqgQdyedKLDVwIdOIgm7H7k/uMzs6jxc7Mfb
	2It7KUE7CA+JgUiECIMQiaC2O4iJAgHJjQgtA0qxxgmSDCUYzFhiyFsbm+V/n+/n+Xy/n/t8
	n+dh0fwcjEBWulxDqeTiTB7DG7/ctyM0jG57nMJvucBBNYbLABnHzjCQbq0NR7N9CwBVPFii
	ofm8ZRxZejsx1F1fhqGvjf0Yms8fxFH1uZMYsrboaWjytoOJ+tfnGKjMfAug8oo8gHpGd6Lu
	nms4Ot84xURNA2sYap6142hodYCOhvQ1zFe55I2b+8lO/RiTHBpvxckbP2tJk6GQQZoWypjk
	xYYcssuSyyD/mhrFSft3IwyypM0AyOt13zsPfzpOOkxBpMk6hyX6vivdk0aJJZQqmJInKyTp
	8tQY3v4DSa8lRUbxBWGCaLSbFywXy6gYXrwoMez19EznDnjBH4gztU4qUaxW8yJe2aNSaDVU
	cJpCrYnhUUpJplKoDFeLZWqtPDVcTmleFvD5L0Y6hUekacVdwwzllS3HVswjIBeUsnXAiwUJ
	IVw6dQfTAW+WH9EFoO3+bbq7WADwK9sM7lJtFPqiuCcdZ6w/ekSdANb3XmW6CweAhrpahg6w
	WAxiBxz+TOvi/YlyDFqMho1JNGIVQLNF5MIcYhc0Dp3f4HFiO6zuu0p3YTaBYH/+LeB22wqr
	fn3EdPNb4LUqq2fOVnjyUjXNZQCJAi+4OD/laYiHQ6uzuBtz4MxAG9ONA6FjvofhxlI4cXfC
	ozkBOy6W0N04Fuau/E53BaA5A7R8G+H28oGnl62Yi4YEG35yys+t3gbHy6Y8nVz4R2WDB5NQ
	33mT4V7cYVhkrqWVgiD9Uwn0TyXQ/29WB2gG8AylVMtSKXWkUiCnPvzvLpMVMhPYeP2hCR1g
	bOJBuBlgLGAGkEXj+bPHzUspfmyJOCubUimSVNpMSm0Gkc61fkoLDEhWOL+PXJMkEEbzhVFR
	UcLol6IEPC57Nv9ziR+RKtZQUopSUqonfRjLKzAXi20UvGk/F33XKH//BBZQlxEXNtMwqC+c
	1LF2cw9Z3iqS+RpGC/78hXz0Rbdc11oynf1DsndTZU5nCtF6JAmwL8w5Qu+L38jale3T/GXt
	3NGFON/nSr8pZB4os+ZfetYnbO8hk4jzMGRtb1XteM2VzVPLi8PHr4s6KFmAbdOxpZHRj4jf
	emcLirkhvW+fPZ2Sau8pWdw0EnsvtGsga/vm9cOadjPe/reXZGfGw9Z60VF7wjaWbaBdOENN
	Nt1p/PifSW55x0p85XTC4LSwRK2q8M944Xmj7/jB9bwgHfMsflBqu5dvj4gVzb1HcnqbHyta
	LenKd3IDihO79mnHpBx+TgjOw9VpYkEoTaUW/wv9VadwhgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWy7bCSvC7Lm19pBnfu6FnMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLG4e2MlksWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Ht/5zG5x9P9bNotJh64xWkyZ1sRosfeWtsWevSdZLOYve8pusfz4PyaLda/fs1ic/3uc1eL8
	rDnsDuIel694e+ycdZfd4/y9jSwel8+Wemxa1cnmsenTJHaPzUvqPXbfbGDz+Pj0FovH+31X
	2Tz6tqxi9Diz4AhQ8nS1x+dNch6bnrxlCuCP4rJJSc3JLEst0rdL4Mro2X2BrWC/YMWfQ1cZ
	Gxgn8HYxcnJICJhI9D85xdrFyMUhJLCdUeLgjKlMEAlxieZrP9ghbGGJlf+es0MUfWSU6D/w
	CKiIg4NNQFPiwuRSkLiIwAomiW1P/rKAOMwC7UwS1ybeZQbpFhbQkVh9fj4LiM0ioCox+/AJ
	VhCbV8BC4mjrNUaIDfISMy99Z4eIC0qcnPkErJ4ZKN68dTbzBEa+WUhSs5CkFjAyrWIUTS0o
	zk3PTS4w1CtOzC0uzUvXS87P3cQIjk2toB2My9b/1TvEyMTBeIhRgoNZSYT33qGfaUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1M5ebHPAwbpMTKpmy7
	2xZzIeH/kuBT+u/+X7N4IBPm4XM3stP6gvzpO/cOXP273NTS4NeEU6WzX5yKaAq5bZ29P6Wp
	p/+8wbmQkr7UxZ+bn7Mpvf9c91eofuILF8uVyYtnH2p5zOs2tceJLXOmgFu8+waJf00N5kt3
	bfr92sX88QIGHpco+X3SrOw+2snrU1bs4C6I2PPqOv+D2uRrqb9+NYe+NF6XIvTXbPaDkvOa
	/SXsRj4LuEXTJ9/8mHBc+0JKU+U23nN/7HbMY5Hd789xMKJ534VXtu8vXl6f08Roybqn/MuW
	AztarOxXBkesm1C45e8G19nrl7QKFBu4mt6TWnsosOOX60y9lh6Z3ysMlViKMxINtZiLihMB
	v38qDjwDAAA=
X-CMS-MailID: 20240930182052epcas5p37edefa7556b87c3fbb543275756ac736
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240930182052epcas5p37edefa7556b87c3fbb543275756ac736
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>

Another spin to incorporate the feedback from LPC and previous
iterations. The series adds two capabilities:
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

Changes since v6:
- Change io_uring interface to pass hints as SQE metadata (Pavel, Hannes)

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
 include/uapi/linux/io_uring.h | 19 ++++++++++
 io_uring/rw.c                 | 24 ++++++++++++
 13 files changed, 175 insertions(+), 27 deletions(-)

-- 
2.25.1


