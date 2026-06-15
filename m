Return-Path: <io-uring+bounces-13724-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id oQrYAeeqL2pGEQUAu9opvQ
	(envelope-from <io-uring+bounces-13724-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 09:33:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 932F668439A
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 09:33:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EtzjqvDf;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13724-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13724-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DFC153003349
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 07:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A587E3BBFB2;
	Mon, 15 Jun 2026 07:33:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440143BB100
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 07:33:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781508834; cv=none; b=ScUDcDdxugwmAhnwK4P8p3Yukqoo9rLtzxzcZj7QkkQDwyLm2xcFceTFGk9O5PbOp8uOVvrslau5WlAtHjlXa35PH3Of/DeB/AylTUIZ0HjXY08DAEg3No/dwCqWdvYqruAVdVAMHYgF01FpOLtwqwfJ9IpJ1djZsed1JPq/tCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781508834; c=relaxed/simple;
	bh=UKO5Fzq52IRnypXc8N4L/aXVjRpgy+y1Wd8PHlnQ4nA=;
	h=References:In-Reply-To:Message-Id:To:Cc:From:Mime-Version:
	 Content-Type:Date:Subject; b=FmM6K4LMKfYuLMpoo6RjYH7WTnIvfP452rB14GkqTgV6Xx16VLxsZVzsk83VEWYNw36DowSsmp0hEzQKHoPmdTcB/ICKOsmzj8fFqL2fqR5hLVeu77RHYYPCEI0o7E64ZZbnwN7hO3KJ51D9xyY1Bbmwq2iOJBSvu0U1NAYEVWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EtzjqvDf; arc=none smtp.client-ip=209.127.230.114
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1781508821; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UKO5Fzq52IRnypXc8N4L/aXVjRpgy+y1Wd8PHlnQ4nA=;
 b=EtzjqvDfI6U7xL0SXhM/mJpZ+Y/Wew/O+hkE22Mhq08hI8O0cFaLe2Hf/9QXmyEgILiOD3
 pYnS4cHPx15O7NBILebZshgYkDhlyeaGlJk82AqKG09q0sdOjb1svoYmfs/6fmHkndXayY
 kdHSGMjfc5f9Uii92PJl6ET9d6fN9BYNQt4yt0MCVkvxfIQxNTMfoo1NcSzpFSBECjEH1K
 k29vuz41eW0UF8JsTCgOjY8wC1Y94gM5QXN+3eolEwpfogIkOWcmYqAmC/la30HB4XxvQ4
 ILS6gd358Ne1fGL8DXM7sprnXbRwLDBzuErDiFyHmU73ozAv5CXLoUFI8ZlH1A==
References: <20260520031221.83210-1-changfengnan@bytedance.com>
	<469287b6-201a-497d-ac67-03e1336dd81a@kernel.dk>
In-Reply-To: <469287b6-201a-497d-ac67-03e1336dd81a@kernel.dk>
X-Lms-Return-Path: <lba+16a2faad3+2de43a+vger.kernel.org+changfengnan@bytedance.com>
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e79dfdc8.0374.4705.bd44.702afa9fc1bd@bytedance.com>
To: "peterz" <peterz@infradead.org>, "rostedt" <rostedt@goodmis.org>
Cc: "io-uring" <io-uring@vger.kernel.org>, 
	"linux-kernel" <linux-kernel@vger.kernel.org>, "axboe" <axboe@kernel.dk>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Jun 2026 15:33:36 +0800
Subject: Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans during teardown
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS(0.00)[m:peterz@infradead.org,m:rostedt@goodmis.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13724-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bytedance.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,bytedance.com:dkim,bytedance.com:email,bytedance.com:mid,bytedance.com:from_mime,vger.kernel.org:from_smtp,goodmis.org:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 932F668439A

Hi Peter & Steven:
Do you have time to help review this patch ?

Thanks.


> From: "Jens Axboe"<axboe@kernel.dk>
> Date:=C2=A0 Fri, May 22, 2026, 00:59
> Subject:=C2=A0 Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans=
 during teardown
> To: "Fengnan Chang"<changfengnan@bytedance.com>, <io-uring@vger.kernel.or=
g>, <linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <rostedt@goodmi=
s.org>
> On 5/19/26 9:12 PM, Fengnan Chang wrote:
> > We hit hard-lockup reports from iou-wrk threads stuck in
> > task_work_cancel_match() during io-wq teardown in syzkaller test.
> > The root cause is that teardown repeatedly rescans the submitter task's
> > full task_work list under pi_lock, once per matched item.
> >=C2=A0
> > Two spots are problematic:
> >=C2=A0
> > 1) io_wq_cancel_tw_create() loops calling task_work_cancel_match() to
> > =C2=A0 =C2=A0remove worker-creation callbacks one at a time. Each call =
re-walks
> > =C2=A0 =C2=A0the entire list from scratch while holding pi_lock.
> >=C2=A0
> > 2) io_worker_exit() unconditionally scans the submitter task_work list
> > =C2=A0 =C2=A0for its own create_work, even when it never queued one. Wi=
th many
> > =C2=A0 =C2=A0workers exiting simultaneously against a large unrelated t=
ask_work
> > =C2=A0 =C2=A0list, this adds up fast.
> >=C2=A0
> > Fix (1) by adding task_work_cancel_match_all() that unlinks all matchin=
g
> > callbacks in a single traversal, then iterating the returned list local=
ly.
> > Same try_cmpxchg() synchronisation as before, stops at the work_exited
> > sentinel.
> >=C2=A0
> > Fix (2) by skipping the cancel entirely unless create_state indicates a
> > pending create_work. Since create_state is exclusively owned via
> > test_and_set_bit_lock, at most one callback can be queued per worker, s=
o
> > the cancel is also simplified from a loop to a single call.
> >=C2=A0
> > With this fix the reproducer (FIFO-open + MSG_RING SEND_FD stress) no
> > longer triggers hard-lockup reports, and task_work_cancel_match samples
> > drop to microseconds.
>=C2=A0
> Looks good to me, nicer way to do this too.
>=C2=A0
> --=C2=A0
> Jens Axboe
>=C2=A0

