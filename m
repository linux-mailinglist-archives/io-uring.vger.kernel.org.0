Return-Path: <io-uring+bounces-13114-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEAqOB6y6GmIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13114-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BDF4456E5
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1CE953020EE7
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A063C7E1B;
	Wed, 22 Apr 2026 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="gf0Fi2pm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A73563D4;
	Wed, 22 Apr 2026 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857344; cv=none; b=smw/RpBY/4v1U1Rx3rr3DgMhv+EbcW0RSHpBMWrJvvLox2fF7FS+mqQlfoFhO+rrTvqXkskW8yov0VbT3P2YRPY2gtzppKzTG7YlvK13q56utCYcidFd7OFiVy5YtdMzFffHTC6swQQa/yzk4qeb4SPxS2PGyqaThKM3yBX+FG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857344; c=relaxed/simple;
	bh=FzbePGzFBdErQ3s5Csbqg5Vgrr+jfEYdeWw9kQex5A8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ITra2H0YXMiTMX8Tc8hKangAuPj2jXlqvoncbzS6iXrhFr7CYCkHXwTe/JWw3CSQb16Ocu+le2YSgwDJG61JmoZ4hNw4yvoFtbjHTzQ/wPesBHw5y4m+f9Z0WZ1hhHX8yE1cnYtnbokqY0EwYy86FXLaciaCwPJJYY1/AjKU8cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=gf0Fi2pm; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIbXpM331412;
	Wed, 22 Apr 2026 04:28:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=tysJw3Dgx5kUTargNJ
	Q936PGOmCF2QJX/b1YsfVS2nY=; b=gf0Fi2pmZvpHwNPBzMGm60sDJZaEc67NCb
	A8ZfKN859e7/sfvCDklulhgx8Ul+pa9vPAyLZyECFfeuIyd9ccPfgMFSETqvq64c
	zbkIbiczCv06xWPeqokQzzPq6aaFcz4a4sz11uW0jKoT0z3dqSXBgPo/uXKQeIsU
	1cdhW+xmMzPNoN4rlwRlciGjcV5dVsQG0yJdhm0RgUv0YIfBYdWE+bW9dcf5amHJ
	Q85TR/iGRCOXdH5qF5orFYytNU78lngYIXqOT/ZD3F0x8Xe55LOs7XiAnlSd9JRW
	A55cU84cGABoDAvX/vTNPHhIk0bW13pmWcC02mh0uR27mUkaPV6w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepa4m84-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:28:53 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:28:52 +0000
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
Subject: [PATCH 0/5] io_uring/zcrx: add CQE based notifications and stats reporting
Date: Wed, 22 Apr 2026 04:25:11 -0700
Message-ID: <20260422112522.3316660-1-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: e12mLqYuvmssPF0gn3B2XGfhETDuw8fl
X-Authority-Analysis: v=2.4 cv=N9oZ0W9B c=1 sm=1 tr=0 ts=69e8b0f5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=UEycfHfI_E6E8hJArawA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: e12mLqYuvmssPF0gn3B2XGfhETDuw8fl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfX4Ueoxaa9+N6R
 JgF5iOjljLP8kOqTbgmeu2UysVNmyEDfSsx32ap+/RP9VCVBupyauXGhfA0KjlS4f7PKxTypmP0
 Q0xaQsgKY5PcZvR5EtXTDIIVUZgrUkSJl7xxwxGkpEcYuw0hwHf/iieyaFA8Yt9nKAKm7SoYGrf
 LLYd98B7lkFt42r9lbBXn+zvo5JnYfwGeewATivfO+kEhO/G19+F4rmmWNgJDCl/IvJfexG0dw0
 laqqf1rKQlW8iDvgPYsFlaDdYC9C0Fn5XLf3jSAXQanLsRUJUJ6chMbqCB4BK97tYgrl2ldTR6o
 m36UBaogHaq0EIHFYnMs9qe5+lASYjGw9OdnnJPnuQmtWqRKde5uolMF/dcw1lFvrLx3PChzRHU
 IZt2BsC14BFW0/6ffFTJ8cEnvjt1FbmFaIlZlgU3CmiSXXZepBphPhn/tpleui4/dL4Is7ojqfe
 F6bfZNYe6SL8YxaCIdA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [1.01 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13114-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:dkim,meta.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5BDF4456E5
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

Clément Léger (4):
  io_uring/zcrx: notify user on frag copy fallback
  io_uring/zcrx: add shared-memory notification statistics
  Documentation: networking: document zcrx notifications and statistics
  selftests: iou-zcrx: add notification and stats test for zcrx

Pavel Begunkov (1):
  io_uring/zcrx: notify user when out of buffers

 Documentation/networking/iou-zcrx.rst         | 106 ++++++++++++
 include/uapi/linux/io_uring/query.h           |  12 ++
 include/uapi/linux/io_uring/zcrx.h            |  34 +++-
 io_uring/query.c                              |  14 ++
 io_uring/zcrx.c                               | 151 +++++++++++++++++-
 io_uring/zcrx.h                               |  13 +-
 .../selftests/drivers/net/hw/iou-zcrx.c       | 112 +++++++++++--
 .../selftests/drivers/net/hw/iou-zcrx.py      |  49 +++++-
 8 files changed, 475 insertions(+), 16 deletions(-)

-- 
Clément Léger

