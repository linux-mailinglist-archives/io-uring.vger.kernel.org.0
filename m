Return-Path: <io-uring+bounces-13624-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wzrXHP5YJWpAHQIAu9opvQ
	(envelope-from <io-uring+bounces-13624-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 13:41:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1756507A3
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 13:41:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uq0y5Vmr;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13624-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13624-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E54983011C4A
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 11:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AD1347FC0;
	Sun,  7 Jun 2026 11:41:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628C8257855
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 11:41:46 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780832507; cv=pass; b=ZnYgsmhg/Mvy7yodAERsEFYfeBK4lmWCNrUrXispSvV3dBLzN+mwg4LW5BAtj3fCjawdrQuZEt/vw7bAAi+vzvyBRqMwYeKqI2AProMEeBBF5cULT2lSRE/kPM2o7hH42Of3y7OM1Z2W8XSxBlD9y6wlrYXtBPwohcPR6RXOgx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780832507; c=relaxed/simple;
	bh=cd4op8EMAfBbr67PhLqjml+gtV+nTWmVie6BgLlAtJM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tPQTmHWrt0QxplUSoVzvnfPCquKPjzaPZJejwQBRUaWjzYXKfCXE5BAJw1VENTy2SXW7Albd+flDsYOR0wjDCBkJ1LnEohAt8B8mkBGgsi4dHRtbRnNKU1zOfsCgem2m3f0LUzflosvqZdSf+AU9S5flVcvPbEyOkRvO4YYenSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uq0y5Vmr; arc=pass smtp.client-ip=209.85.210.47
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e718d46a6aso1060491a34.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 04:41:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780832505; cv=none;
        d=google.com; s=arc-20240605;
        b=ZK4C1H7f0oPYb2M3G7v2aAxqJWcXoMqS7oKvAqTJHtuch0zk+HKM2oXAkcyWf2642v
         bApy72WHdyOxPEKJ9J6/T8FzRBSAhhKOz/XbHr+CTum9PjNw7hq/QF+phNssCpjED1h2
         x9loh6O/4JLa0rfW/NrNKmPr2HbAI55fhDSevAbJNDkd9nz7f46fnLoMjqQIxom+pMnd
         9WOQue4KHo8p3lFu3KDMmfBZ5wd9DeSRezAXYLpUjVrC707CUl/n1dQlvjJFp5VKJuxb
         81VZx7MCy7ydtGuzd8xead0KJZFJ0TOqVqtYHo6FZ+eDMIEETWisXGbJ7Lb/JljN9x7Z
         C9/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=cd4op8EMAfBbr67PhLqjml+gtV+nTWmVie6BgLlAtJM=;
        fh=gUm5lrEWRp8ngaLT8YMql1hxYFZzKp7vBKN/HWUBx1Y=;
        b=KF8WY5rzgKVMwTGMgeI2t/yjNC1V+WGdoUKALB7fkxlFMnk4G2iOy7KYGTPay6Rqoy
         HCQXENPNaGo4eHWre1w4NmhbkyNASlm5x6WBpcNvleLOQDyAmD6mssNDXkKSeXTO6tm6
         d7tfrpyPih9IqB+XFgOONuVg0uGcwGE0SKfCfbMQQCgxhfq0ZDYUrw7VEoafVyTn4C7S
         jTmRXk3g5A03XNQgniHX1t0WtgHDg87DEPqFG3/q8O36c6nSmH8ohPIj7SH7qofXF6Qi
         ++5drAoe7NRAXnKUGESyua1WUDK+r60ZgQMKzmprBZHBM0TDzc8dQoQuMiehfBW2K8HX
         0Bdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780832505; x=1781437305; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cd4op8EMAfBbr67PhLqjml+gtV+nTWmVie6BgLlAtJM=;
        b=Uq0y5Vmr8366ngmsy5BMcPEnNEQMCOBplBR3EeHyLRHNFMSYZwbfY3CDSY9j8Ky32x
         9eZgqGGU1sh7m7lh5+xxZeSWL9oCLu3dj8rlariDG1zNP2UD1vuF9At4axcKOYfBd+aL
         KfRlvANP5vdDm/rG6hpWOLyuwTS5WdCNeaQoV/HaYm7DpJcNYELxqumMsJK0UGDu+8IA
         4U1FO1JEAdCwik6KCBKMwnaDZ8BhbDwv3w8QNyiBu7kC8Ij28iLxxySXZU+DrrmwZK0Q
         YYViXpWovtaxHLCQGfAmGiJ3Ysr2Ir7oHXxfrIo+DGeAPBQIZNyAWAN192Gc6ky42Mys
         8Bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780832505; x=1781437305;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cd4op8EMAfBbr67PhLqjml+gtV+nTWmVie6BgLlAtJM=;
        b=m3TcmZyBMlh0qu41fCFOoZSfc8A8D0kpVAtiApyspXNALy8rh0JAwcrIdS+9wDbdLk
         Shc1KTn1iiRcWCrioTFgNqD4vCZehl83MV9nMY3x+co6kRZSHcxw7KoSiuv/oqDVT4EZ
         oZy6GrBCHWYxHPtXKgSNnCqftfRdpsPtjFXPDfNgFzhXPF1zuZgWoNCqaFNeSVOdj5Px
         29Nr03UWiY1cFD7ztLQQqn+/XAa+eNJHu6Wlv1VwG5KfvsuMko1Kr/wIbBRQ54f1k51m
         ROBdw9hefeKf7+AQQEZCDdwKFecoffhbKit+WpvwKxGq1RZGlwpzwiVIX435k4Ifkw8m
         9c7w==
X-Gm-Message-State: AOJu0YyNAOYEGV5uUE8g7XaWv5Dw9t8ssJ+m0dyZHb7GCPA0maF8Nhyq
	0OCxTjekoQDH8bj+NkFhcKZWrfdCX96a49li0WJdPj+vLlv0t7Qc8awH7QzznkClnmfhxRfbSWS
	rpFIIJ+thevWLWuBrwd4WMRp6R6D7eF/4bkPq
X-Gm-Gg: Acq92OEVxgZSBw6YvxTVyPnV4wtIIVfvWrLothK3Zoe0EeVGUa8+VXBr/iRRJ4s+hFs
	WV/FOdvcK+uy1FG0wM6uszfaqbUnNWxNq5RkHIFCRidIhGLUAPjdp/XgzrgWr+p3Q6Rl6PaBn/C
	3uFdVPDVCqBT4MN4LV8lxnAboKiwbFlwcg/80FmxBMdPDHJdS2U4acLd21FsPvMwOV5OkjFL0/w
	EuppiMnKv3TQF5zvmq5Ea9Zyp/X75eGPe9wvcTryMM6oQ8tsvBocBRX6IRNdqJcmnpOKEt8O9P3
	7siwO5cM6E1E+bSscw==
X-Received: by 2002:a05:6820:2223:b0:69e:89dd:1759 with SMTP id
 006d021491bc7-69e89dd1b51mr1436861eaf.21.1780832505331; Sun, 07 Jun 2026
 04:41:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Federico Brasili <federico.brasili@gmail.com>
Date: Sun, 7 Jun 2026 13:41:34 +0200
X-Gm-Features: AVVi8Cfjw8IpdihcdWVHkhlp3D5t5Hr0IdHWESJXvbGaP7otGgZERv_8jwiJQDY
Message-ID: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
Subject: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink non-INC
 pbuf ring len and affect later READ operations
To: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13624-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[federicobrasili@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[federicobrasili@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DC1756507A3

Hi,

I found a reproducible io_uring provided-buffer ring issue on Ubuntu
kernel 7.0.0-22-generic.

A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
ring can persistently shrink the user-visible buffer descriptor
length. The modified length is not rolled back when the receive fails
with -EAGAIN/no data, and a later unrelated io_uring operation, such
as IORING_OP_READ from a pipe, consumes the corrupted length.

This is not a demonstrated privilege escalation. The demonstrated
impact is deterministic unprivileged provided-buffer ring metadata
corruption across unrelated io_uring operations.

Tested kernel:

Linux ubuntu 7.0.0-22-generic #22-Ubuntu SMP PREEMPT_DYNAMIC Mon May
25 15:54:34 UTC 2026 x86_64 GNU/Linux

Summary:

Create an io_uring instance as an unprivileged user.

Register a non-INC provided-buffer ring with two buffers:

entry0.len = 4096

entry1.len = 4096

Submit IORING_OP_RECV with:

IOSQE_BUFFER_SELECT

IORING_RECVSEND_BUNDLE

req_len = 1

MSG_DONTWAIT

empty AF_UNIX SOCK_DGRAM socket

The receive fails with -EAGAIN, but entry0.len is changed from 4096 to 1.

Submit a later unrelated IORING_OP_READ from a pipe using the same
provided-buffer group with req_len = 4096.

The READ returns only 1 byte, because it uses the previously corrupted
entry0.len.

A second READ then consumes entry1 normally and returns 4096 bytes,
showing that head/bid accounting remains coherent and the corruption
is localized to the poisoned descriptor.

Observed output from clean unprivileged reproduction:

[INIT] uid=1002 entry0.len=4096 entry1.len=4096 tail=2
[STEP1] RECV BUNDLE on empty socket, req_len=1, expected CQE=-EAGAIN
[CQE_RECV_BUNDLE] res=-11 flags=0x0 user=0x1111
[AFTER_RECV_BUNDLE] entry0.len=1 entry1.len=4096 changed_buf0=0
changed_buf1=0 guard_before=0 guard_after=0
[STEP2] write pipe bytes=4096, then IORING_OP_READ req_len=4096 using
same pbuf group
[CQE_READ1] res=1 flags=0x1 user=0x6666
[AFTER_READ1] entry0.len=1 entry1.len=4096 changed_buf0=1
changed_buf1=0 guard_before=0 guard_after=0
[STEP3] write second pipe bytes=4096, then second IORING_OP_READ
req_len=4096 without republish
[CQE_READ2] res=4096 flags=0x10001 user=0x7777
[AFTER_READ2] entry0.len=1 entry1.len=4096 changed_buf0=1
changed_buf1=4096 guard_before=0 guard_after=0
[RESULT] PASS: unprivileged RECV_BUNDLE -EAGAIN poisoned pbuf len and
later IORING_OP_READ consumed the corrupted len.

Why this looks like a bug:

The failed receive should not persistently alter the provided-buffer
descriptor in a way that affects future unrelated operations. In this
case, a no-data/-EAGAIN RECV_BUNDLE changes entry0.len from 4096 to 1,
and that corrupted length is later consumed by IORING_OP_READ from a
pipe.

The suspected root cause is in the non-INC provided-buffer ring BUNDLE
selection path:

io_ring_buffers_peek()
if (len > arg->max_len) {
len = arg->max_len;
if (!(bl->flags & IOBL_INC)) {
arg->partial_map = 1;
if (iov != arg->iovs)
break;
WRITE_ONCE(buf->len, len);
}
}

The descriptor length is modified during buffer selection/peek before
the receive operation has completed successfully. If the receive later
fails with -EAGAIN/no data, the buffer is recycled but the modified
buf->len is not restored.

Additional observations:

The issue reproduces as an unprivileged user.

The effect crosses io_uring operations: RECV affects a later READ.

The effect crosses subsystems: socket receive affects pipe read.

The second READ correctly uses entry1 and returns 4096 bytes, so this
does not appear to be a head/bid desync in the tested case.

No kernel crash, OOB write, UAF, or privilege escalation has been demonstrated.

Expected behavior:

If IORING_RECVSEND_BUNDLE fails with -EAGAIN/no data, the
provided-buffer ring descriptor should not be persistently modified,
or the original len should be restored during recycle/rollback.

Actual behavior:

The failed BUNDLE receive leaves entry0.len shortened to the requested
length, and later unrelated operations using the same provided-buffer
group consume that corrupted length.

I can provide the minimal C reproducer and full output if useful.

Thanks,
Federico

