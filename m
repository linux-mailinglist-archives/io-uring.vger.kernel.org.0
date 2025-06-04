Return-Path: <io-uring+bounces-8215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE537ACDFE7
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91079175629
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 14:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCCC290BC4;
	Wed,  4 Jun 2025 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.b="d/tOIGaA"
X-Original-To: io-uring@vger.kernel.org
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2F290D8F
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.30.2.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749046208; cv=none; b=VXLy+qEpl5xtts3+dg1IHM7gFjIM0iykGpSQXABSMQ1WN1PH56OvgKxGT3NMubxuoSkLP3actJcI+FlSjX84UZ7hM3pW66U2BjWbuCQaWt6cF5N/JrgNCI05Oeq7jrlopHH6scghBHQaOyzRk2iPZmTgActsqi229X8oe9Vq1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749046208; c=relaxed/simple;
	bh=XEK0tNPz14yoMAES4xlGAfHw8u4ip4yTqCDYO/O+wyQ=;
	h=To:From:Subject:MIME-Version:Content-Type:Date:Message-ID; b=b0iEcQG+Bh9LCHe2AEXWAdDRZTO4DZdYoV7f3D296BTGOjYvadmT1gYiHzwkdKzeesJCrmyFFMt3ckr2V5IXxfQ81cJpAcu/26/bHT4FdRx/PTImVr7BdjyKqJvtduSK/5sFGv7QC0+2rFAy6jOmyhPwHYpMQ9RlRplYGO3O6iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=csail.mit.edu; spf=pass smtp.mailfrom=csail.mit.edu; dkim=pass (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.b=d/tOIGaA; arc=none smtp.client-ip=128.30.2.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=csail.mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Message-ID:Date:Content-Type:
	MIME-Version:Subject:Reply-To:From:To:Sender:Cc:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TyClP7ZFxSST81r9/Vr/ZZ8vQj8HlfsNapgoEbQVUAo=; t=1749046206; x=1749910206; 
	b=d/tOIGaAFGj0L1LeoaD4Cy22c21LIpgvjKLTEOSJkG5t8DlZ/cj4hbIgX0EGavGrXRHOsnxAnxx
	vNLC61F4kYnKiOr2hbRqgzZ6IBhrsik85xqq/Nq/QO+R0QmQrHAAJQBgoteYVakH7KgHqH0hwL882
	4DHkS6ENTFtjsR4KNr074C3PvjpCT7aECKPmI6Xbxdnzy7wjN40iu2bx0PmFu7G1+TggnzVvEJ6kI
	K/IbplYBIdbVKc2vtVzTQ9jglvrTxhEEGFC8gAIVeo8OWtugLIVKoECfnl2wGo267gXDZZqKq0STj
	FYQGAOpiBKNZDENrPXUCTgC3p9G7tgJbzyHA==;
Received: from c-73-186-183-159.hsd1.nh.comcast.net ([73.186.183.159] helo=crash.local)
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <rtm@csail.mit.edu>)
	id 1uMod1-003eua-AZ;
	Wed, 04 Jun 2025 09:58:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by crash.local (Postfix) with ESMTP id 88E34231F669;
	Wed, 04 Jun 2025 09:58:02 -0400 (EDT)
To: Jens Axboe <axboe@kernel.dk>,
    Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
From: rtm@csail.mit.edu
Reply-To: rtm@csail.mit.edu
Subject: use-after-free if killed while in IORING_OP_FUTEX_WAIT
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Wed, 04 Jun 2025 09:58:02 -0400
Message-ID: <38053.1749045482@localhost>

--=-=-=
Content-Type: text/plain

If a process is killed while in IORING_OP_FUTEX_WAIT, do_exit()'s call
to exit_mm() causes the futex_private_hash to be freed, along with its
buckets' locks, while the iouring request still exists. When (a little
later in do_exit()) the iouring fd is fput(), the resulting
futex_unqueue() tries to use the freed memory that
req->async_data->lock_ptr points to.

I've attached a demo:

# cc uring46b.c
# ./a.out
killing child
BUG: spinlock bad magic on CPU#0, kworker/u4:1/26
Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b711b
Current kworker/u4:1 pgtable: 4K pagesize, 39-bit VAs, pgdp=0x000000008202a000
[6b6b6b6b6b6b711b] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
Oops [#1]
Modules linked in:
CPU: 0 UID: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.15.0-11192-ga82d78bc13a8 #553 NONE 
Hardware name: riscv-virtio,qemu (DT)
Workqueue: iou_exit io_ring_exit_work
epc : spin_dump+0x38/0x6e
 ra : spin_dump+0x30/0x6e
epc : ffffffff80003354 ra : ffffffff8000334c sp : ffffffc600113b60
...
status: 0000000200000120 badaddr: 6b6b6b6b6b6b711b cause: 000000000000000d
[<ffffffff80003354>] spin_dump+0x38/0x6e
[<ffffffff8009b78a>] do_raw_spin_lock+0x10a/0x126
[<ffffffff811e6552>] _raw_spin_lock+0x1a/0x22
[<ffffffff800eb80c>] futex_unqueue+0x2a/0x76
[<ffffffff8069e366>] __io_futex_cancel+0x72/0x88
[<ffffffff806982fe>] io_cancel_remove_all+0x50/0x74
[<ffffffff8069e4ac>] io_futex_remove_all+0x1a/0x22
[<ffffffff80010a7e>] io_uring_try_cancel_requests+0x2e2/0x36e
[<ffffffff80010bf6>] io_ring_exit_work+0xec/0x3f0
[<ffffffff80057f0a>] process_one_work+0x132/0x2fe
[<ffffffff8005888c>] worker_thread+0x21e/0x2fe
[<ffffffff80060428>] kthread+0xe8/0x1ba
[<ffffffff80022fb0>] ret_from_fork_kernel+0xe/0x5e
[<ffffffff811e8566>] ret_from_fork_kernel_asm+0x16/0x18
Code: 4517 018b 0513 ca05 00ef 3b60 2603 0049 2601 c491 (a703) 5b04 
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Fatal exception
---[ end Kernel panic - not syncing: Fatal exception ]---

Robert Morris
rtm@mit.edu


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=uring46b.c
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHN0ZGxpYi5o
PgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVkZSA8
c3lzL3N5c2NhbGwuaD4KI2luY2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvdWlvLmg+
CiNpbmNsdWRlIDxsaW51eC9mcy5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHVuaXN0
ZC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4KI2luY2x1
ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPGxpbnV4L2lvX3VyaW5nLmg+CgppbnQgZGlyZmQg
PSAtMTsKaW50IHBmZHNbMl07CmludCBzb2NrID0gLTE7CgovLwovLyBhZGFwdGVkIGZyb206Ci8v
IGh0dHBzOi8vdW5peGlzbS5uZXQvbG90aS9sb3dfbGV2ZWwuaHRtbAovLyBodHRwczovL2dpdGh1
Yi5jb20vc2h1dmViL2lvX3VyaW5nLWJ5LWV4YW1wbGUKLy8KCiNkZWZpbmUgUVVFVUVfREVQVEgg
MQojZGVmaW5lIEJMT0NLX1NaICAgIDEwMjQKCnN0cnVjdCBhcHBfaW9fc3FfcmluZyB7CiAgICB1
bnNpZ25lZCAqaGVhZDsKICAgIHVuc2lnbmVkICp0YWlsOwogICAgdW5zaWduZWQgKnJpbmdfbWFz
azsKICAgIHVuc2lnbmVkICpyaW5nX2VudHJpZXM7CiAgICB1bnNpZ25lZCAqZmxhZ3M7CiAgICB1
bnNpZ25lZCAqYXJyYXk7Cn07CgpzdHJ1Y3QgYXBwX2lvX2NxX3JpbmcgewogICAgdW5zaWduZWQg
KmhlYWQ7CiAgICB1bnNpZ25lZCAqdGFpbDsKICAgIHVuc2lnbmVkICpyaW5nX21hc2s7CiAgICB1
bnNpZ25lZCAqcmluZ19lbnRyaWVzOwogICAgc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlczsKfTsK
CnN0cnVjdCBzdWJtaXR0ZXIgewogICAgaW50IHJpbmdfZmQ7CiAgICBzdHJ1Y3QgYXBwX2lvX3Nx
X3Jpbmcgc3FfcmluZzsKICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZXM7CiAgICBzdHJ1Y3Qg
YXBwX2lvX2NxX3JpbmcgY3FfcmluZzsKfTsKCnN0cnVjdCBmaWxlX2luZm8gewogICAgb2ZmX3Qg
ZmlsZV9zejsKICAgIHN0cnVjdCBpb3ZlYyBpb3ZlY3NbXTsgICAgICAvKiBSZWZlcnJlZCBieSBy
ZWFkdi93cml0ZXYgKi8KfTsKCmludCBpb191cmluZ19zZXR1cCh1bnNpZ25lZCBlbnRyaWVzLCBz
dHJ1Y3QgaW9fdXJpbmdfcGFyYW1zICpwKQp7CiAgICByZXR1cm4gKGludCkgc3lzY2FsbChfX05S
X2lvX3VyaW5nX3NldHVwLCBlbnRyaWVzLCBwKTsKfQoKaW50IGlvX3VyaW5nX2VudGVyKGludCBy
aW5nX2ZkLCB1bnNpZ25lZCBpbnQgdG9fc3VibWl0LAogICAgICAgICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGludCBtaW5fY29tcGxldGUsIHVuc2lnbmVkIGludCBmbGFncykKewogICAgcmV0
dXJuIChpbnQpIHN5c2NhbGwoX19OUl9pb191cmluZ19lbnRlciwgcmluZ19mZCwgdG9fc3VibWl0
LCBtaW5fY29tcGxldGUsCiAgICAgICAgICAgICAgICAgICBmbGFncywgTlVMTCwgMCk7Cn0KCmlu
dCBhcHBfc2V0dXBfdXJpbmcoc3RydWN0IHN1Ym1pdHRlciAqcykgewogICAgc3RydWN0IGFwcF9p
b19zcV9yaW5nICpzcmluZyA9ICZzLT5zcV9yaW5nOwogICAgc3RydWN0IGFwcF9pb19jcV9yaW5n
ICpjcmluZyA9ICZzLT5jcV9yaW5nOwogICAgc3RydWN0IGlvX3VyaW5nX3BhcmFtcyBwOwogICAg
dm9pZCAqc3FfcHRyLCAqY3FfcHRyOwoKICAgIG1lbXNldCgmcCwgMCwgc2l6ZW9mKHApKTsKICAg
IHMtPnJpbmdfZmQgPSBpb191cmluZ19zZXR1cChRVUVVRV9ERVBUSCwgJnApOwogICAgaWYgKHMt
PnJpbmdfZmQgPCAwKSB7CiAgICAgICAgcGVycm9yKCJpb191cmluZ19zZXR1cCIpOwogICAgICAg
IHJldHVybiAxOwogICAgfQoKICAgIGludCBzcmluZ19zeiA9IHAuc3Ffb2ZmLmFycmF5ICsgcC5z
cV9lbnRyaWVzICogc2l6ZW9mKHVuc2lnbmVkKTsKICAgIGludCBjcmluZ19zeiA9IHAuY3Ffb2Zm
LmNxZXMgKyBwLmNxX2VudHJpZXMgKiBzaXplb2Yoc3RydWN0IGlvX3VyaW5nX2NxZSk7CgogICAg
aWYgKHAuZmVhdHVyZXMgJiBJT1JJTkdfRkVBVF9TSU5HTEVfTU1BUCkgewogICAgICAgIGlmIChj
cmluZ19zeiA+IHNyaW5nX3N6KSB7CiAgICAgICAgICAgIHNyaW5nX3N6ID0gY3Jpbmdfc3o7CiAg
ICAgICAgfQogICAgICAgIGNyaW5nX3N6ID0gc3Jpbmdfc3o7CiAgICB9CgogICAgc3FfcHRyID0g
bW1hcCgwLCBzcmluZ19zeiwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwgCiAgICAgICAgICAgIE1B
UF9TSEFSRUQgfCBNQVBfUE9QVUxBVEUsCiAgICAgICAgICAgIHMtPnJpbmdfZmQsIElPUklOR19P
RkZfU1FfUklORyk7CiAgICBpZiAoc3FfcHRyID09IE1BUF9GQUlMRUQpIHsKICAgICAgICBwZXJy
b3IoIm1tYXAiKTsKICAgICAgICByZXR1cm4gMTsKICAgIH0KCiAgICBpZiAocC5mZWF0dXJlcyAm
IElPUklOR19GRUFUX1NJTkdMRV9NTUFQKSB7CiAgICAgICAgY3FfcHRyID0gc3FfcHRyOwogICAg
fSBlbHNlIHsKICAgICAgICBjcV9wdHIgPSBtbWFwKDAsIGNyaW5nX3N6LCBQUk9UX1JFQUQgfCBQ
Uk9UX1dSSVRFLCAKICAgICAgICAgICAgICAgIE1BUF9TSEFSRUQgfCBNQVBfUE9QVUxBVEUsCiAg
ICAgICAgICAgICAgICBzLT5yaW5nX2ZkLCBJT1JJTkdfT0ZGX0NRX1JJTkcpOwogICAgICAgIGlm
IChjcV9wdHIgPT0gTUFQX0ZBSUxFRCkgewogICAgICAgICAgICBwZXJyb3IoIm1tYXAiKTsKICAg
ICAgICAgICAgcmV0dXJuIDE7CiAgICAgICAgfQogICAgfQoKICAgIHNyaW5nLT5oZWFkID0gc3Ff
cHRyICsgcC5zcV9vZmYuaGVhZDsKICAgIHNyaW5nLT50YWlsID0gc3FfcHRyICsgcC5zcV9vZmYu
dGFpbDsKICAgIHNyaW5nLT5yaW5nX21hc2sgPSBzcV9wdHIgKyBwLnNxX29mZi5yaW5nX21hc2s7
CiAgICBzcmluZy0+cmluZ19lbnRyaWVzID0gc3FfcHRyICsgcC5zcV9vZmYucmluZ19lbnRyaWVz
OwogICAgc3JpbmctPmZsYWdzID0gc3FfcHRyICsgcC5zcV9vZmYuZmxhZ3M7CiAgICBzcmluZy0+
YXJyYXkgPSBzcV9wdHIgKyBwLnNxX29mZi5hcnJheTsKCiAgICBzLT5zcWVzID0gbW1hcCgwLCBw
LnNxX2VudHJpZXMgKiBzaXplb2Yoc3RydWN0IGlvX3VyaW5nX3NxZSksCiAgICAgICAgICAgIFBS
T1RfUkVBRCB8IFBST1RfV1JJVEUsIE1BUF9TSEFSRUQgfCBNQVBfUE9QVUxBVEUsCiAgICAgICAg
ICAgIHMtPnJpbmdfZmQsIElPUklOR19PRkZfU1FFUyk7CiAgICBpZiAocy0+c3FlcyA9PSBNQVBf
RkFJTEVEKSB7CiAgICAgICAgcGVycm9yKCJtbWFwIik7CiAgICAgICAgcmV0dXJuIDE7CiAgICB9
CgogICAgY3JpbmctPmhlYWQgPSBjcV9wdHIgKyBwLmNxX29mZi5oZWFkOwogICAgY3JpbmctPnRh
aWwgPSBjcV9wdHIgKyBwLmNxX29mZi50YWlsOwogICAgY3JpbmctPnJpbmdfbWFzayA9IGNxX3B0
ciArIHAuY3Ffb2ZmLnJpbmdfbWFzazsKICAgIGNyaW5nLT5yaW5nX2VudHJpZXMgPSBjcV9wdHIg
KyBwLmNxX29mZi5yaW5nX2VudHJpZXM7CiAgICBjcmluZy0+Y3FlcyA9IGNxX3B0ciArIHAuY3Ff
b2ZmLmNxZXM7CgogICAgcmV0dXJuIDA7Cn0KCmludCBzdWJtaXRfdG9fc3EoY2hhciAqZmlsZV9w
YXRoLCBzdHJ1Y3Qgc3VibWl0dGVyICpzKSB7CiAgICBzdHJ1Y3QgZmlsZV9pbmZvICpmaTsKCiAg
ICBpbnQgZmlsZV9mZCA9IG9wZW4oZmlsZV9wYXRoLCBPX1JET05MWSk7CiAgICBpZiAoZmlsZV9m
ZCA8IDAgKSB7CiAgICAgICAgcGVycm9yKCJvcGVuIik7CiAgICAgICAgcmV0dXJuIDE7CiAgICB9
CgogICAgc3RydWN0IGFwcF9pb19zcV9yaW5nICpzcmluZyA9ICZzLT5zcV9yaW5nOwogICAgdW5z
aWduZWQgaW5kZXggPSAwLCBjdXJyZW50X2Jsb2NrID0gMCwgdGFpbCA9IDAsIG5leHRfdGFpbCA9
IDA7CgogICAgb2ZmX3QgZmlsZV9zeiA9IDI7CiAgICBvZmZfdCBieXRlc19yZW1haW5pbmcgPSBm
aWxlX3N6OwogICAgaW50IGJsb2NrcyA9IChpbnQpIGZpbGVfc3ogLyBCTE9DS19TWjsKICAgIGlm
IChmaWxlX3N6ICUgQkxPQ0tfU1opIGJsb2NrcysrOwoKICAgIGZpID0gbWFsbG9jKHNpemVvZigq
ZmkpICsgc2l6ZW9mKHN0cnVjdCBpb3ZlYykgKiBibG9ja3MpOwogICAgaWYgKCFmaSkgewogICAg
ICAgIGZwcmludGYoc3RkZXJyLCAiVW5hYmxlIHRvIGFsbG9jYXRlIG1lbW9yeVxuIik7CiAgICAg
ICAgcmV0dXJuIDE7CiAgICB9CiAgICBmaS0+ZmlsZV9zeiA9IGZpbGVfc3o7CgogICAgd2hpbGUg
KGJ5dGVzX3JlbWFpbmluZykgewogICAgICAgIG9mZl90IGJ5dGVzX3RvX3JlYWQgPSBieXRlc19y
ZW1haW5pbmc7CiAgICAgICAgaWYgKGJ5dGVzX3RvX3JlYWQgPiBCTE9DS19TWikKICAgICAgICAg
ICAgYnl0ZXNfdG9fcmVhZCA9IEJMT0NLX1NaOwoKICAgICAgICBmaS0+aW92ZWNzW2N1cnJlbnRf
YmxvY2tdLmlvdl9sZW4gPSBieXRlc190b19yZWFkOwoKICAgICAgICB2b2lkICpidWY7CiAgICAg
ICAgaWYoIHBvc2l4X21lbWFsaWduKCZidWYsIEJMT0NLX1NaLCBCTE9DS19TWikpIHsKICAgICAg
ICAgICAgcGVycm9yKCJwb3NpeF9tZW1hbGlnbiIpOwogICAgICAgICAgICByZXR1cm4gMTsKICAg
ICAgICB9CiAgICAgICAgZmktPmlvdmVjc1tjdXJyZW50X2Jsb2NrXS5pb3ZfYmFzZSA9IGJ1ZjsK
CiAgICAgICAgY3VycmVudF9ibG9jaysrOwogICAgICAgIGJ5dGVzX3JlbWFpbmluZyAtPSBieXRl
c190b19yZWFkOwogICAgfQoKICAgIG5leHRfdGFpbCA9IHRhaWwgPSAqc3JpbmctPnRhaWw7CiAg
ICBuZXh0X3RhaWwrKzsKICAgIGluZGV4ID0gdGFpbCAmICpzLT5zcV9yaW5nLnJpbmdfbWFzazsK
ICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSA9ICZzLT5zcWVzW2luZGV4XTsKICAgIHNxZS0+
ZmxhZ3MgPSAwOwogICAgc3FlLT5vZmYgPSAwOwogICAgc3JpbmctPmFycmF5W2luZGV4XSA9IGlu
ZGV4OwogICAgdGFpbCA9IG5leHRfdGFpbDsKCiAgICBzcWUtPmxlbiA9IDA7CiAgICBzcWUtPm9w
dHZhbCA9IDB4ODAwMDAwMDA7CgogICAgc3RhdGljIGNoYXIgYnVmWzMyXTsKICAgIG1lbXNldChi
dWYsIDB4ZmYsIHNpemVvZihidWYpKTsKICAgICoobG9uZyopYnVmID0gMHhmZmZmZmZmZjAwMDAw
MDAwOwogICAgc3FlLT5hZGRyID0gKF9fdTY0KSBidWY7CgogICAgc3FlLT5vcGNvZGUgPSBJT1JJ
TkdfT1BfRlVURVhfV0FJVDsKICAgIHNxZS0+ZmxhZ3MgPSAyOwogICAgc3FlLT5mZCA9IDEzMDsK
CiAgICBpZigqc3JpbmctPnRhaWwgIT0gdGFpbCkgewogICAgICAgICpzcmluZy0+dGFpbCA9IHRh
aWw7CiAgICB9CgogICAgaW50IHJldCA9ICBpb191cmluZ19lbnRlcihzLT5yaW5nX2ZkLCAxLDEs
CiAgICAgICAgICAgIElPUklOR19FTlRFUl9HRVRFVkVOVFMpOwogICAgaWYocmV0IDwgMCkgewog
ICAgICAgIHBlcnJvcigiaW9fdXJpbmdfZW50ZXIiKTsKICAgICAgICByZXR1cm4gMTsKICAgIH0K
CiAgICByZXR1cm4gMDsKfQoKaW50Cm1haW4oKQp7CiAgc3RydWN0IHJsaW1pdCByOyAgIAogIHIu
cmxpbV9jdXIgPSByLnJsaW1fbWF4ID0gMDsKICBzZXRybGltaXQoUkxJTUlUX0NPUkUsICZyKTsK
CiAgdW5saW5rKCJ6Iik7CiAgc3lzdGVtKCJlY2hvIGhpID4geiIpOwoKICBpbnQgcGlkID0gZm9y
aygpOwogIGlmKHBpZCA9PSAwKXsKICAgIHN0cnVjdCBzdWJtaXR0ZXIgKnM7CgogICAgZGlyZmQg
PSBvcGVuKCIuIiwgMCk7CgogICAgc29ja2V0cGFpcihBRl9VTklYLCBTT0NLX1NUUkVBTSwgMCwg
cGZkcyk7CiAgICB3cml0ZShwZmRzWzBdLCAiYSIsIDEpOwogICAgd3JpdGUocGZkc1sxXSwgImIi
LCAxKTsKCiAgICBzb2NrID0gc29ja2V0KEFGX0lORVQsIFNPQ0tfREdSQU0sIDApOwogICAgCiAg
ICBzID0gbWFsbG9jKHNpemVvZigqcykpOwogICAgaWYgKCFzKSB7CiAgICAgIHBlcnJvcigibWFs
bG9jIik7CiAgICAgIGV4aXQoMCk7CiAgICB9CiAgICBtZW1zZXQocywgMCwgc2l6ZW9mKCpzKSk7
CiAgICAKICAgIGlmKGFwcF9zZXR1cF91cmluZyhzKSkgewogICAgICBmcHJpbnRmKHN0ZGVyciwg
IlVuYWJsZSB0byBzZXR1cCB1cmluZyFcbiIpOwogICAgICBleGl0KDApOwogICAgfQogICAgCiAg
ICBpZihzdWJtaXRfdG9fc3EoInoiLCBzKSkgewogICAgICBmcHJpbnRmKHN0ZGVyciwgIkVycm9y
IHJlYWRpbmcgZmlsZSB6XG4iKTsKICAgICAgZXhpdCgwKTsKICAgIH0KCiAgICBwcmludGYoImNo
aWxkIGV4aXRpbmdcbiIpOwogICAgZXhpdCgwKTsKICB9CgogIHNsZWVwKDEpOwogIHByaW50Zigi
a2lsbGluZyBjaGlsZFxuIik7CiAga2lsbChwaWQsIDkpOwogIHVzbGVlcCgyMDAwMDApOwp9Cg==
--=-=-=--

