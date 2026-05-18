Return-Path: <io-uring+bounces-13409-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMZHNHUzC2qgEgUAu9opvQ
	(envelope-from <io-uring+bounces-13409-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:42:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 521295702F7
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA605308E09B
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630A62BE644;
	Mon, 18 May 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="rksVrHvw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03F43F9267;
	Mon, 18 May 2026 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118583; cv=none; b=Ftrl5Uds1ijzJORY5bXMAaIiMN7eqFBhcB1E78lKu7fYob69k+m3GNvsNlN8Q6/TxohLSoUOMZ6mdqZ/HBXDn7NuCh97PZ95F3+SB+jDmNe0lBzchlkNSzY6RTxoljHdFfk/lbmzWAbF8POyZwPJrjyvnOJDzA+PHmtC1B6fbyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118583; c=relaxed/simple;
	bh=ugsWDGGPZC8bQpr9CLD1la9fbD4agwDvtWnhrmBS3DM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WJTpj902hYw1GlJdQePL1BW8gMhnopSxiDqfqo23L2IiWLXjFtj5GJx2UVD08KPmUGvLkcVTEHEbvu7gORO3XntmdUp5Wrb12j74NTvMBshWO/YIVOZ19INB3t95OsS7fPuYB75akFth8BoQta0pIgzmBMLFU4lu0rvhPdH5pWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=rksVrHvw; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IAKp6r2173324;
	Mon, 18 May 2026 08:36:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=jKJonzgQAZbOdQ53pS
	rOTQNV7/Pfkb+kPgaujQEE2VY=; b=rksVrHvwptoxgDXoqXCvEAtdB3eQOLqDmR
	0xaG0j3jd4D5z7wR/Hhz4GUHzT8TDyQU2nIx2xquI9p91drmpXsfvS8SkB9X3WFd
	pYNFaM0v9EPUuKmCPBcRS3YfLMjvOOzlhXHiRKndjx/Bs/lo9nksdw0T8wYLyUtx
	Mn4+7lbB4uwzp5AxcOT+reW+6Yf/0GZ3E3W6n84heSPWqGui6oTo4NAY2rSF1/Tk
	huq+9NMSk4n0QKptnVnFTbn0/dNS1conCe8p9WwF70XesgxkCbucxqwE/x06oRl/
	rLhV8k9tGy82luRXD2TI0l5YLpHCd1+VAskPB7EH5ArzT0P3fmnA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e6np69rad-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:10 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:09 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
        "Jens
 Axboe" <axboe@kernel.dk>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Vishwanath Seshagiri <vishs@fb.com>
Subject: [PATCH v2 0/6] io_uring/zcrx: add CQE based notifications and stats reporting
Date: Mon, 18 May 2026 08:35:23 -0700
Message-ID: <20260518153532.2835502-1-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfXxHUamKYPukSG
 5GeRXtxgHrlrU2kT8s2PBZ68lR6vP2y/cjjt0k5n7RXU0xViM16hU/lDFriNavixU/Murt0u7QT
 jGQhAW4VgBAVAH3UiUk7HAl+b6eZgK39BvN8uEJMfsKacB0lzHPBaBsafcUaADBqLSvKdib+KVw
 0WjqENOQ9UdGArTcBrmWeP2FVkT4lkah3Uw53N7uuD/R61c4+7A0TqEZPXqKyr/yEstRw5xDWLf
 tEzU4kPRzORVxvIiGmanNx9IzKuLcSj1qkuWnvKSe7TTfqFdOu9TX+rWa3WbSjIgX1lPQmExcd9
 3ws4FJGlkx4oefb4t46zprlkRH//MvcMw8daINw/vTi7YfSM0UFzKTt5JjpTfQaGQeaTvkE4koO
 Sujpzr084RxKKpBT5QJwmG2kTg5dNH0DjP1IiMJOZZFV7VPszVI8LOogPyJ1mNQv1MvsuZkQ9pR
 jkyvQ2Yyhy8xWKg0qgQ==
X-Authority-Analysis: v=2.4 cv=Pr2jqQM3 c=1 sm=1 tr=0 ts=6a0b31ea cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=NhOMyWKnmVta6MYugR0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: nlxn9_SD6l87l-KKaAz2kiYhGc7hOp7g
X-Proofpoint-ORIG-GUID: nlxn9_SD6l87l-KKaAz2kiYhGc7hOp7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [0.96 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.63)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13409-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 521295702F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The zcrx path can encounter various conditions that lead to internal
fallbacks or errors. These errors can have a large impact on performance
and functionality but are not yet not being reported to the user which
is then unable to take action.

This series addresses this problem by adding a new notification system
paired with a statistics structure. The notification system currently
report out of buffer and packets that fallback to copy. The statistics
structure report the number and total size of packets that were copied
rather than received via the zero-copy path.

The out of buffer notification allows the user to actually adjust the
buffer sizing when registering zcrx support for the ifq. Some future
work could allow the user to add more memory on the fly to the pool so
the page allocator doesn't run out of memory.

This series can be tested using the include kselftest modification and
using the liburing series that updates headers and tests/examples so
that it uses notifications and statistics.

Changes in v2:
- Rebase on top of Pavel's branch that now uses a single CQE per notif
- Change notification mask to type (ie one CQE per event)
- Use a type rather than a mask for rearm as well
- Update tests to use single typei
- Update documentatiopn to state that notif CQEs are sent for a single
  event
- Fix zero init of zcrx_query_notif __resv field
- Rename resv1 to __resv1
- Reduce __resv2 size to match io_uring_query_opcode size
- Verifies that stats_offset is 0 if FLAG_STATS is zero
- Added zcrx notif query sequence to documentation
- Add _copy_fallback to test name

---

Clément Léger (4):
  io_uring/zcrx: notify user on frag copy fallback
  io_uring/zcrx: add shared-memory notification statistics
  Documentation: networking: document zcrx notifications and statistics
  selftests: iou-zcrx: add notification and stats test for zcrx

Pavel Begunkov (2):
  io_uring/zcrx: add ctx pointer to zcrx
  io_uring/zcrx: notify user when out of buffers

 Documentation/networking/iou-zcrx.rst         | 121 ++++++++++++
 include/uapi/linux/io_uring/query.h           |  12 ++
 include/uapi/linux/io_uring/zcrx.h            |  36 +++-
 io_uring/io_uring.c                           |   2 +-
 io_uring/io_uring.h                           |   1 +
 io_uring/query.c                              |  16 ++
 io_uring/zcrx.c                               | 180 +++++++++++++++++-
 io_uring/zcrx.h                               |  11 +-
 .../selftests/drivers/net/hw/iou-zcrx.c       | 114 ++++++++++-
 .../selftests/drivers/net/hw/iou-zcrx.py      |  49 ++++-
 10 files changed, 517 insertions(+), 25 deletions(-)

-- 
Clément Léger

