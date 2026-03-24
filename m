Return-Path: <io-uring+bounces-12820-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODSkCD7AwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12820-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B547319546
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 361793030D39
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D5E36C9C8;
	Tue, 24 Mar 2026 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TsO4F/EV"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6533E2746
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370296; cv=none; b=AzARqUo8WfP/M4NtBunDiqOtlmL5vSeRpvQ7Kb7rhxGYVxzFCdSZsjAYG2Cmk8PNPFHyfgztaUapsHRvIQvhEtdFB8G3lu/X4dgrvoYfBr/JLOFsW1UXtW2nwQXs8slUC7KyGJGGTgaB+j9Omm1Mr0B//wXMNUxNvqZ9acxIHsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370296; c=relaxed/simple;
	bh=2Bb/RF/VPpC8KCvfK4vddY8KZNiu6ASUhczZuHKAKck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SqduVIK8qrnUWbNMQeI40QALdPLJzds0Mg600dPK1tXt58QKyuJm3m5weYqTRHul9F9uynFsOZ+z6ljJfry53Sh9pmkPRFWC770OI/oMDi3YdS2Lhd2lJKnBvjgwFz8emSy1cRyDEocdmFwJcN4ZCT6PK5flMNHVvICkXKtODwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TsO4F/EV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nDHgnn5BQJFF66frkgHQM1vC4reIunM/ZdGzCKK26S0=;
	b=TsO4F/EVU3l2C4aX1+/c3u1qsu7bhLM2JdvgZ98LVqfj9B/EF/wUWdva3P6TguZn5WjszW
	gKj8XCl83F+Vo12rAK0+uE38rEMHDNKqQkJS3asDln4YccBl7ldLn67h32ir0n2fL7Wy2N
	Y5mmEYdwZrB2YJbeY68EhFr7d5mCd7Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-L4qH02sYNCypsYR_SvyxZA-1; Tue,
 24 Mar 2026 12:38:10 -0400
X-MC-Unique: L4qH02sYNCypsYR_SvyxZA-1
X-Mimecast-MFC-AGG-ID: L4qH02sYNCypsYR_SvyxZA_1774370289
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBEB61800371;
	Tue, 24 Mar 2026 16:38:08 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0052F1800765;
	Tue, 24 Mar 2026 16:38:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 0/12] io_uring: add IORING_OP_BPF for extending io_uring
Date: Wed, 25 Mar 2026 00:37:21 +0800
Message-ID: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12820-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8B547319546
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

Add IORING_OP_BPF for extending io_uring operations, follows typical cases:

- buffer registered zero copy [1]

Also there are some RAID like ublk servers which needs to generate data
parity in case of ublk zero copy

- extend io_uring operations from application

Easy to add one new syscall with IORING_OP_BPF

- extend 64 byte SQE

bpf map can store IO data conveniently

- communicate in IO chain

IORING_OP_BPF can be used for communicate among IOs seamlessly without requiring
extra syscall

- pretty handy to inject error for test purpose

Any comments & feedback are welcome!


[1] lpc2024: ublk based zero copy I/O - use case in Android

https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf

V3:
	- add per-buffer iterator kfuncs for addressing Caleb's concern about
	  complicated kfunc interface, kernel mapped buffer produced by the
	  iterator can be read/written from bpf prog in zero copy style

	- rename to bpf_ext

	- change tests to copy between uring_buf and arena, which may match
	  with raid's use case

	- misc cleanup


V2:
	- per-ring struct ops (Stefan Metzmacher, Caleb Sander Mateos)
	- refactor io_import_fixed()/io_prep_reg_iovec()/io_import_reg_vec()
	  for allowing to handle multiple buffers for single request
	- kernel selftests
	- all kinds of comments from Caleb Sander Mateos
	- support vectored and registered vector buffer



Ming Lei (12):
  io_uring: make io_import_fixed() global
  io_uring: refactor io_prep_reg_iovec() for BPF kfunc use
  io_uring: refactor io_import_reg_vec() for BPF kfunc use
  io_uring: prepare for extending io_uring with bpf
  io_uring: bpf: extend io_uring with bpf struct_ops
  io_uring: bpf: implement struct_ops registration
  io_uring: bpf: add BPF buffer descriptor for IORING_OP_BPF
  io_uring: bpf: add per-buffer iterator kfuncs
  bpf: add bpf_uring_buf_dynptr to special_kfunc_list
  selftests/io_uring: add io_uring_unregister_buffers()
  selftests/io_uring: add BPF struct_ops and kfunc tests
  selftests/io_uring: add buffer iterator selftest with BPF arena

 include/linux/io_uring_types.h                |  14 +-
 include/uapi/linux/io_uring.h                 |  40 +
 init/Kconfig                                  |   7 +
 io_uring/Makefile                             |   1 +
 io_uring/bpf-ops.c                            |   7 +-
 io_uring/bpf_ext.c                            | 755 ++++++++++++++++++
 io_uring/bpf_ext.h                            |  71 ++
 io_uring/io_uring.c                           |   9 +-
 io_uring/io_uring.h                           |   6 +-
 io_uring/opdef.c                              |  16 +
 io_uring/rsrc.c                               |  46 +-
 io_uring/rsrc.h                               |  68 +-
 kernel/bpf/verifier.c                         |  12 +
 tools/include/io_uring/mini_liburing.h        |  10 +
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/.gitignore   |   2 +
 tools/testing/selftests/io_uring/Makefile     | 173 ++++
 .../selftests/io_uring/bpf_ext_basic.bpf.c    |  94 +++
 .../selftests/io_uring/bpf_ext_basic.c        | 215 +++++
 .../selftests/io_uring/bpf_ext_memcpy.bpf.c   | 305 +++++++
 .../selftests/io_uring/bpf_ext_memcpy.c       | 517 ++++++++++++
 .../io_uring/include/bpf_ext_memcpy_defs.h    |  18 +
 .../selftests/io_uring/include/iou_test.h     |  98 +++
 tools/testing/selftests/io_uring/runner.c     | 206 +++++
 24 files changed, 2646 insertions(+), 47 deletions(-)
 create mode 100644 io_uring/bpf_ext.c
 create mode 100644 io_uring/bpf_ext.h
 create mode 100644 tools/testing/selftests/io_uring/.gitignore
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_basic.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_memcpy.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_memcpy.c
 create mode 100644 tools/testing/selftests/io_uring/include/bpf_ext_memcpy_defs.h
 create mode 100644 tools/testing/selftests/io_uring/include/iou_test.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c

-- 
2.53.0


