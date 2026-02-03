Return-Path: <io-uring+bounces-12027-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKoJIy5EgWnNFAMAu9opvQ
	(envelope-from <io-uring+bounces-12027-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 01:41:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E02A9D317E
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 01:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60C59304AAF2
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 00:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CDA1B4F1F;
	Tue,  3 Feb 2026 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="CC1vBsvq"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f119.zoho.com (sender4-pp-f119.zoho.com [136.143.188.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731C224F3;
	Tue,  3 Feb 2026 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770079074; cv=pass; b=Ui2+t/ulIpHIK9be8zv4Ews7fK9yink93mc7h2ZckUuHfvYa3jJmeI3RDJBZPpRbWlJIanI2y+1O5xDhMgJse/YJJ2hN3YadPHE+clqjtYtz2kRGfUs4Ei+n2OfGAkc3bPVSF32Ls1hs/lWjVshd/kMaVzPeuDqH/oNEkdkSAds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770079074; c=relaxed/simple;
	bh=HLYq8HaFrgc2mZ69+KQdlkuDS/lZPs/4GzvAXa+Z+GQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=k6CqftM8h0pTNUABO4+5pI0D/aiz6cZ7iy2rVr/T+F4OjRwGgsUc2j2s6u5QBXc689P39F7W5283kM6EqzgMP58bhHN+UCH7alDZzZgMbsg0Vpnn2pZ6rBcNN9a7XbzJeVmDLjilcYbPpcmQabrlpJ8QJnyZA/dhUDhgF5GqP1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=CC1vBsvq; arc=pass smtp.client-ip=136.143.188.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770079069; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YOxyrQHPXqSkYdgtFC68viuFD0XlM0w4u0WA7fP53Fwro8AawQRCnxm4Pk3X5B5SaQLJWdz0dqXtmM7m9GEjG9whQEegyGBu0c7QnQR/+L39eNwp3WaBTCM1BsbszzAJEjhyPeQiE061CWT7BF5w0sZ1QC090vNhhXeImlarUFs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770079069; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Z0DtPciCveknFOrkN3BaL9oakOYc7Xm5KM51zBUViX0=; 
	b=R68ll9TPXXl51D/ouoz1YRnYg6QmOaAzA1RUdcAT2CA5/bs6wx8JqPdefarE2em/Iu+SpuG0hL3qaKTooH7ZoMcP7oodLMm2KGXIcj4FBD/tr50nguOBGQ7jjfDrkiP5L+1uMSueljXEbn+/0GrQvrKsdQuk2D3XsGwssgAH44k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770079069;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Z0DtPciCveknFOrkN3BaL9oakOYc7Xm5KM51zBUViX0=;
	b=CC1vBsvqbWCDXApmkszWxTXy0MPnbV7f7egryxBaGRGLRT7m1Nt9ktz99Vw3/Rn1
	ROY4oXwkehiI07FVDWtAPOrD1viETTdsacT6XMvh+bufs21T7GPia0Yqu+LV7YdDnrP
	rj8Qvyju0ZKF8tJd4GVcvSHc6APUbbZGAwhI8gfE=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 177007906774157.91632638844089; Mon, 2 Feb 2026 16:37:47 -0800 (PST)
Date: Tue, 03 Feb 2026 08:37:47 +0800
From: Li Chen <me@linux.beauty>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: "Pavel Begunkov" <asml.silence@gmail.com>,
	"io-uring" <io-uring@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19c20ef1e4d.70da0b662392423.5502964729064267874@linux.beauty>
In-Reply-To: <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
References: <20260202143755.789114-1-me@linux.beauty> <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
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
X-Spamd-Result: default: False [-1.65 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[linux.beauty];
	TAGGED_FROM(0.00)[bounces-12027-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.beauty:+];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.beauty:mid,linux.beauty:dkim]
X-Rspamd-Queue-Id: E02A9D317E
X-Rspamd-Action: no action

Hi Jens,

 ---- On Mon, 02 Feb 2026 23:21:22 +0800  Jens Axboe <axboe@kernel.dk> wrot=
e ---=20
 > On 2/2/26 7:37 AM, Li Chen wrote:
 > > io_uring uses io-wq to offload regular file I/O. When that happens, th=
e kernel
 > > creates per-task iou-wrk-<tgid> workers (PF_IO_WORKER) via create_io_t=
hread(),
 > > so the worker is part of the process thread group and shows up under
 > > /proc/<pid>/task/.
 > >=20
 > > io-wq shrinks the pool on idle, but it intentionally keeps the last wo=
rker
 > > around indefinitely as a keepalive to avoid churn. Combined with io_ur=
ing's
 > > per-task context lifetime (tctx stays attached to the task until exit)=
, a
 > > process may permanently retain an idle iou-wrk thread even after it ha=
s closed
 > > its last io_uring instance and has no active rings.
 > >=20
 > > The keepalive behavior is a reasonable default(I guess): workloads may=
 have
 > > bursty I/O patterns, and always tearing down the last worker would add=
 thread
 > > churn and latency. Creating io-wq workers goes through create_io_threa=
d()
 > > (copy_process), which is not cheap to do repeatedly.
 > >=20
 > > However, CRIU currently doesn't cope well with such workers being part=
 of the
 > > checkpointed thread group. The iou-wrk thread is a kernel-managed work=
er
 > > (PF_IO_WORKER) running io_wq_worker() on a kernel stack, rather than a=
 normal
 > > userspace thread executing application code. In our setup, if the iou-=
wrk
 > > thread remains present after quiescing and closing the last io_uring i=
nstance,
 > > criu dump may hang while trying to stop and dump the thread group.
 > >=20
 > > Besides the resource overhead and surprising userspace-visible threads=
, this is
 > > a problem for checkpoint/restore. CRIU needs to freeze and dump all th=
reads in
 > > the thread group. With a lingering iou-wrk thread, we observed criu du=
mp can
 > > hang even after the ring has been quiesced and the io_uring fd closed,=
 e.g.:
 > >=20
 > >   criu dump -t $PID -D images -o dump.log -v4 --shell-job
 > >   ps -T -p $PID -o pid,tid,comm | grep iou-wrk
 > >=20
 > > This series is a kernel-side enabler for checkpoint/restore in the cur=
rent
 > > reality where userspace needs to quiesce and close io_uring rings befo=
re dump.
 > > It is not trying to make io_uring rings checkpointable, nor does it ch=
ange what
 > > CRIU can or cannot restore (e.g. in-flight SQEs/CQEs, SQPOLL, SQE128/C=
QE32,
 > > registered resources). Even with userspace gaining limited io_uring su=
pport,
 > > this series only targets the specific "no active io_uring contexts lef=
t, but an
 > > idle iou-wrk keepalive thread remains" case.
 > >=20
 > > This series adds an explicit exit-on-idle mode to io-wq, and toggles i=
t from
 > > io_uring task context when the task has no active io_uring contexts
 > > (xa_empty(&tctx->xa)). The mode is cleared on subsequent io_uring usag=
e, so the
 > > default behavior for active io_uring users is unchanged.
 > >=20
 > > Tested on x86_64 with CRIU 4.2.
 > > With this series applied, after closing the ring iou-wrk exited within=
 ~200ms
 > > and criu dump completed.
 >=20
 > Applied with the mentioned commit message and IO_WQ_BIT_EXIT_ON_IDLE tes=
t
 > placement.

Thanks a lot for your review!

If you still want a test, I'm happy to write it. Since you've already
tweaked/applied the v1 series, I can send the test as a standalone
follow-up patch (no v2).

If kselftest is preferred, I'll base it on the same CRIU-style workload:
spawn iou-wrk-* via io_uring, quiesce/close the last ring, and check the
worker exits within a short timeout.

Regards,
Li=E2=80=8B


