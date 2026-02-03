Return-Path: <io-uring+bounces-12030-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO5HMymqgWn0IQMAu9opvQ
	(envelope-from <io-uring+bounces-12030-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 08:56:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F41D5E8C
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 08:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24CFE30602C9
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 07:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8102B3921EB;
	Tue,  3 Feb 2026 07:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="oOyr0gYm"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926B21F3B87;
	Tue,  3 Feb 2026 07:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770104847; cv=pass; b=IMbtWm1VwVLsaZBpobiktxlDJ+MPhq0U1NfSe5KXDz2hpQjHIQ6gttRZIkaNqe18zZ67BOcb29XV4MWupaupK9kFiaotUmuLwsiMQru8nOLYCDJ3pJeEikIwbegKZHxvWqTx51J3K9AR/lY6oTfQz4wPxMxG2aqEfoSVHj7rkdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770104847; c=relaxed/simple;
	bh=SsdcOtBUBdo5CNsR091pUUkEjbiGNYYvM4mDi5Urj0k=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ZPSXhNn3V5cqQVOsyrR66B7FjRi2na0WXR8jnvObMvZc/+QJId3FM9vWMLrUAkhEGD7M/I5xivlYcoozCH4/GQCxBlf4XcD5LLb4GakARDC6OSvJ1Yjyikh8AADvOjIYq+nbKkd3RE5/4C4nYpbpp9L3Zv36uqI44CME/iQFd6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=oOyr0gYm; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770104841; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PdWjYxXCDwnFA6qfmy7BWiVtZWP8SjMtcn/Jc5PkH9/rxq3mWmTXQ3VS/it4bgIKdiHJzb39MRz+ag69nkKa/JsBbEbeBwXVUQCerVbGFDSCOEAviiQ9TPr42I5ctX2eXsmSR6RXJu1U/v4CK5Z06bO+vXsO5FIWrkqYz3vzUkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770104841; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Hph0iT7rh0zp0cxOas67hYuj+Sk0dVLVyUBO04I33iw=; 
	b=FrU7IZtzoajaiMiK6Y1Qb1naJUWjPiL5g+0nolfHb4qkMhdjgzprVpR3YXSinxg1tZtdxV1giTf0vJwawBnNvDeYUuwN8qcd02JnAObDKwC+FeXkjQnYaugHNRWPw2PUcwTLIEI1NNA/PJ0oCKxl/AMmPRVn+kfJUwKizgjYEkM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770104841;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Hph0iT7rh0zp0cxOas67hYuj+Sk0dVLVyUBO04I33iw=;
	b=oOyr0gYmhIjUZ7L7TCf5p3XhlxSWdjuQ/c+H2+DE25hMVTe28OcH84OsQhoUYhn+
	gD+KTDL7Hp6EchWzfLNoeHR2PkjY7g56sYUQg/SX52jxyXQEu2krlrPZspEF0o9kbmw
	4+186i9qhHgVf2Qm+39XAqk0NnRbiWcBWEw+PzQI=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1770104839796296.587391034113; Mon, 2 Feb 2026 23:47:19 -0800 (PST)
Date: Tue, 03 Feb 2026 15:47:19 +0800
From: Li Chen <me@linux.beauty>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: "Pavel Begunkov" <asml.silence@gmail.com>,
	"io-uring" <io-uring@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19c22785df1.288e39fb101919.2611884700541801815@linux.beauty>
In-Reply-To: <147b6420-ad85-46b0-a8e6-3cb9265e4b15@kernel.dk>
References: <20260202143755.789114-1-me@linux.beauty>
 <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
 <19c20ef1e4d.70da0b662392423.5502964729064267874@linux.beauty> <147b6420-ad85-46b0-a8e6-3cb9265e4b15@kernel.dk>
Subject: Re: [PATCH v1 0/2] io_uring/io-wq: let workers exit when unused
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [7.35 / 15.00];
	URIBL_BLACK(7.50)[linux.beauty:mid,linux.beauty:dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	R_DKIM_ALLOW(0.00)[linux.beauty:s=zmail];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12030-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[linux.beauty];
	FORGED_SENDER_MAILLIST(0.00)[];
	GREYLIST(0.00)[pass,body];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[linux.beauty:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	R_SPF_ALLOW(0.00)[+ip4:172.234.253.10:c];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=2];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_SPAM(0.00)[0.839];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.beauty:mid,linux.beauty:dkim,kernel.dk:email]
X-Rspamd-Queue-Id: 78F41D5E8C
X-Rspamd-Action: add header
X-Spam: Yes

Hi Jens,

 ---- On Tue, 03 Feb 2026 10:29:50 +0800  Jens Axboe <axboe@kernel.dk> wrot=
e ---=20
 > On 2/2/26 5:37 PM, Li Chen wrote:
 > > Hi Jens,
 > >=20
 > >  ---- On Mon, 02 Feb 2026 23:21:22 +0800  Jens Axboe <axboe@kernel.dk>=
 wrote ---=20
 > >  > On 2/2/26 7:37 AM, Li Chen wrote:
 > >  > > io_uring uses io-wq to offload regular file I/O. When that happen=
s, the kernel
 > >  > > creates per-task iou-wrk-<tgid> workers (PF_IO_WORKER) via create=
_io_thread(),
 > >  > > so the worker is part of the process thread group and shows up un=
der
 > >  > > /proc/<pid>/task/.
 > >  > >=20
 > >  > > io-wq shrinks the pool on idle, but it intentionally keeps the la=
st worker
 > >  > > around indefinitely as a keepalive to avoid churn. Combined with =
io_uring's
 > >  > > per-task context lifetime (tctx stays attached to the task until =
exit), a
 > >  > > process may permanently retain an idle iou-wrk thread even after =
it has closed
 > >  > > its last io_uring instance and has no active rings.
 > >  > >=20
 > >  > > The keepalive behavior is a reasonable default(I guess): workload=
s may have
 > >  > > bursty I/O patterns, and always tearing down the last worker woul=
d add thread
 > >  > > churn and latency. Creating io-wq workers goes through create_io_=
thread()
 > >  > > (copy_process), which is not cheap to do repeatedly.
 > >  > >=20
 > >  > > However, CRIU currently doesn't cope well with such workers being=
 part of the
 > >  > > checkpointed thread group. The iou-wrk thread is a kernel-managed=
 worker
 > >  > > (PF_IO_WORKER) running io_wq_worker() on a kernel stack, rather t=
han a normal
 > >  > > userspace thread executing application code. In our setup, if the=
 iou-wrk
 > >  > > thread remains present after quiescing and closing the last io_ur=
ing instance,
 > >  > > criu dump may hang while trying to stop and dump the thread group=
.
 > >  > >=20
 > >  > > Besides the resource overhead and surprising userspace-visible th=
reads, this is
 > >  > > a problem for checkpoint/restore. CRIU needs to freeze and dump a=
ll threads in
 > >  > > the thread group. With a lingering iou-wrk thread, we observed cr=
iu dump can
 > >  > > hang even after the ring has been quiesced and the io_uring fd cl=
osed, e.g.:
 > >  > >=20
 > >  > >   criu dump -t $PID -D images -o dump.log -v4 --shell-job
 > >  > >   ps -T -p $PID -o pid,tid,comm | grep iou-wrk
 > >  > >=20
 > >  > > This series is a kernel-side enabler for checkpoint/restore in th=
e current
 > >  > > reality where userspace needs to quiesce and close io_uring rings=
 before dump.
 > >  > > It is not trying to make io_uring rings checkpointable, nor does =
it change what
 > >  > > CRIU can or cannot restore (e.g. in-flight SQEs/CQEs, SQPOLL, SQE=
128/CQE32,
 > >  > > registered resources). Even with userspace gaining limited io_uri=
ng support,
 > >  > > this series only targets the specific "no active io_uring context=
s left, but an
 > >  > > idle iou-wrk keepalive thread remains" case.
 > >  > >=20
 > >  > > This series adds an explicit exit-on-idle mode to io-wq, and togg=
les it from
 > >  > > io_uring task context when the task has no active io_uring contex=
ts
 > >  > > (xa_empty(&tctx->xa)). The mode is cleared on subsequent io_uring=
 usage, so the
 > >  > > default behavior for active io_uring users is unchanged.
 > >  > >=20
 > >  > > Tested on x86_64 with CRIU 4.2.
 > >  > > With this series applied, after closing the ring iou-wrk exited w=
ithin ~200ms
 > >  > > and criu dump completed.
 > >  >=20
 > >  > Applied with the mentioned commit message and IO_WQ_BIT_EXIT_ON_IDL=
E test
 > >  > placement.
 > >=20
 > > Thanks a lot for your review!
 > >=20
 > > If you still want a test, I'm happy to write it. Since you've already
 > > tweaked/applied the v1 series, I can send the test as a standalone
 > > follow-up patch (no v2).
 > >=20
 > > If kselftest is preferred, I'll base it on the same CRIU-style workloa=
d:
 > > spawn iou-wrk-* via io_uring, quiesce/close the last ring, and check t=
he
 > > worker exits within a short timeout.
 >=20
 > That sounds like the right way to do the test. Preferably a liburing
 > test/ case would be better, we don't do a lot of in-kernel selftests so
 > far. But liburing has everything.

Thanks for your suggestion. I just adapted my local test program to liburin=
g and posted the liburing
 PR here: https://github.com/axboe/liburing/pull/1529

Regards,
Li=E2=80=8B


