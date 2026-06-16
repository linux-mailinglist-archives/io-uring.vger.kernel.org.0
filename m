Return-Path: <io-uring+bounces-13755-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id etrlJFuwMWqzpAUAu9opvQ
	(envelope-from <io-uring+bounces-13755-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:21:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 074846952C2
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:21:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=Y04OWCq4;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13755-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13755-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE461303E6F7
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 20:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C1E309DDF;
	Tue, 16 Jun 2026 20:21:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DE4345725
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 20:21:42 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781641304; cv=pass; b=QF1dtf4Jbg38D1SwoBqkq07v64n0xux6m14xB6BAciKv7OYmN6uty4NHH8m0AWEqSruEpUO4fqf+sDK309HtcOB0Soggsnm6Irnv0AedDVhSSph53y5194JGC/+kmy9Ddtpk1294mBEPaIC+kZtlhW/h50TTomIVI+t02CjQLQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781641304; c=relaxed/simple;
	bh=owjXumvORgrsB3f+fp9qURXInHby4GglnzbmDUyPIWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+w8EIhj73+9B8DOF5cbVUJn3mEZXr4K6Q980yn9ka8Pe2Wpps71JzhYpb5iITjeEwbcwLKOjnPmOsJrUilccoyysBNxr1lpU+2XtG1cD6ddVvPozpEO9LlQ0yB9t7RVZo5QfWCHSOuyzcbx9iRanWQAI+azvAaleXBJfh8zFgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Y04OWCq4; arc=pass smtp.client-ip=209.85.161.46
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e82adae3fso123177eaf.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 13:21:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781641301; cv=none;
        d=google.com; s=arc-20240605;
        b=WzePiK8Ljm4fa33qSxayrnzqXQEMjsmKcK+vV5PJcfpzfkkzuBynxMW46Dj3MXIn4R
         BrY8458vU4LKByL2Xn8SvPCrz2tBRo5KPSHE3FtWlZ2porJeK9Nod5EY9ENrhmzTvMIT
         JX+HxMLl4lLtUFte8meogk5uqpmT+apvW0Yzs5USG3sMh5UC9UOAX+hrflqiOOZbuI5l
         U7U5ekpc/syx4+sHybpi/tS3jCISYlOF5vTFHBlLO/69r/wo6T1LpOCnWuI/phQoXIwU
         1COaPrXSNQlptiitcVeMj7n++ZojeafkkvC2xEe1JKtJ/LaDTuf93QqcU1B7YtfibSgN
         5CpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=owjXumvORgrsB3f+fp9qURXInHby4GglnzbmDUyPIWc=;
        fh=8SanVj4MV0LZcXSROTGCY35wrAI3fk+fJGDl/3jrlWo=;
        b=KZH4PdGlT+rrjnqKPE2cTW2yaO2DimhFk7h/tdq3yikgUHJmxdAWWzYoEEIV0NA74A
         UISmpnZVmz1rTWKBYgWLTq7lV3kEVtzhhJ7KsUbp/MFmBOz9Rpu2EXaAviji21A+6kun
         2Hs5LhC61p1ccqnsIT8a5cDiVq8cMKlQvbHO967fFDPNpl0os4GSmbVBfBAF+PDdwd/X
         BnHGWJl/YLqJ1U0fR7KGV7VhxFRDBFkahuXHHWti7MaLUGn3z0d5MKqDWsJX7wb9UDFY
         XXTp0rKwC4WDl+fYJhvmbHtl+qSCgAQBMmYLYzl6qdsRz5i1SUXz6Wq0r8FgnDrY6DKt
         8Q/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781641301; x=1782246101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owjXumvORgrsB3f+fp9qURXInHby4GglnzbmDUyPIWc=;
        b=Y04OWCq4KACMq/xoW+XZ3rKbmmYuy63Ne745wxDRtsqDthekRPHuR3BEhWuussxCc0
         dA7W5jBi1M+Oz/7v/+I0likn3v+k12N/CXROaEOblAIpcxGReRSowdZ+uK7xZeVaYPab
         L29HrQcJrB+VYDO7yBMjzwxDseNHB+8lk3UhGZ2MKCXRrc7gRm4UBdTI2WHjH/9KtyxM
         H/jK3OSvY8WbCXK5Gi2FoYf42bgKeNY8M7wZdwyF0dhlAdZas1q0qrJhK932w1E+6ugP
         zJLYaNVa89M+K09iez+oj4Xlcxe1PTLTXNhuwc9A8r/At+PrZRC4IfGzfhNrcmlxN2HN
         om5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781641301; x=1782246101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=owjXumvORgrsB3f+fp9qURXInHby4GglnzbmDUyPIWc=;
        b=dH5RVgIMxGQTbd00TfPQTPCmMvufoZ6pRdVrniUEKTzJvLOQkUxdSV4+Ct2bHkUTH4
         rEMalGExS0c1o2uENRtgCZkovfhTkdHBJS5yWOIrec7i7lVQF1oxWUxOOCd6mzcYLsdC
         1pumOg9c8kHZuDv43xniAynXdOWDPPHt0OYajEI7eBl7iknn5O+0Q2dyvKSh+yFH4SbG
         MhJ4QVPStRmc9cJcLfB3cwOtX5LTJmkQWWVoobpoqg7Km2jNLDrlmRgyg9eTbM6YpOeL
         0L/YyWG2qj4ctKjtEUFRO+PrCHVB7v5FSWqw3+mTO1agIXv6jSdx20y2Si88vFpFlJNk
         3/Aw==
X-Gm-Message-State: AOJu0YxVYqRjUkVeZMfUjkOTYNNQ3nWvdMhjBL+U2LGfdA8LAfND5X89
	PvaGWdH7kuhiVF9lIqztlU0YRkLKm07YNB1eZkLX8a7ABtWEwud19tHjSblxOZN+DNjraing/5+
	0cT45+ZdsgR0WEvrYjqVzipw/bS0kVvpSqRAhetxApA==
X-Gm-Gg: Acq92OEGKBao3pI2DlweeqmGz3pd8yAwTVYNMe8XWoVI6dlcV2+ZVpWQvRcO9GnkypW
	IWvNdWTKinKWI3DAnqcHup3nVFWqtKsp5X/Hn1tTuHPwdFYf63XX6kjK/+l/UMP6ozZcdsFokc6
	esbe2XsoHAGL75f8DkkL5Y4uTIIz3bRB2bJ7eHYfo0QJjTTYAh1bQzCyHUyqCGt2qgeMQdeKVs0
	JDrj2FV90MEZR+Y8M1E0nCSBu7i935UjsrdJUFW3OsgRCI0aRIKr2bG3a5qij+eMlaDN0+VfyoP
	vpWHLuo=
X-Received: by 2002:a05:6820:83da:20b0:69d:513e:1a69 with SMTP id
 006d021491bc7-6a0b5fe0ec1mr200556eaf.2.1781641301287; Tue, 16 Jun 2026
 13:21:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611160553.1486640-1-axboe@kernel.dk> <20260611160553.1486640-3-axboe@kernel.dk>
 <CADUfDZrzwvY6UpBBhLj1JynuNf5bo140+LbMYDOvU13=od+nkQ@mail.gmail.com>
 <4be7a6db-44bc-4125-867e-9d22c2809f1c@kernel.dk> <CADUfDZr-MMYBaP-e+y9+xuRhuiunO2sBTUCmwZyd7AgT8sVtiQ@mail.gmail.com>
 <1af6602f-590e-4ca5-b034-b09b3f40a8d1@kernel.dk> <9232ba9e-2ea5-4ed2-9043-15190e0f5d0e@kernel.dk>
 <CADUfDZoEhdom7cqRfKhMkhhRc0vmRpzRR-AZXndMhLnLa9KqYg@mail.gmail.com> <e0e6a5da-054e-494b-aad8-be08f040750f@kernel.dk>
In-Reply-To: <e0e6a5da-054e-494b-aad8-be08f040750f@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 16 Jun 2026 13:21:30 -0700
X-Gm-Features: AVVi8CdV5ZldM_jR82uuGz590ZfzfN2qndQllX-pdSSxM9NoYPLh_4yN9HH3g7w
Message-ID: <CADUfDZpkED1apEGoPk_8V8x_JQB8ogBD9E6KjaQ7SEybGnLrCw@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: switch local task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13755-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,vger.kernel.org:from_smtp,kernel.dk:email,purestorage.com:dkim,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 074846952C2

On Mon, Jun 15, 2026 at 11:00=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 6/15/26 11:55 AM, Caleb Sander Mateos wrote:
> > On Fri, Jun 12, 2026 at 8:11?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 6/12/26 6:21 AM, Jens Axboe wrote:
> >>> On 6/11/26 11:24 PM, Caleb Sander Mateos wrote:
> >>>> On Thu, Jun 11, 2026 at 7:23?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 6/11/26 7:14 PM, Caleb Sander Mateos wrote:
> >>>>>> This is great stuff! I had also observed these hotspots on a ublk
> >>>>>> workload. Since incoming ublk requests post task work to the ublk
> >>>>>> server's io_urings and completed ublk requests post task work to t=
he
> >>>>>> client's io_urings, there is significant cross-CPU contention on t=
he
> >>>>>> task work queues.
> >>>>>
> >>>>> Glad you like it! Once I post v2 tomorrow, perhaps you can try and =
run
> >>>>> some tests with and without and see how it does for you?
> >>>>
> >>>> Haven't tested v2 yet, but v1 shows a 4% IOPS improvement on a ublk
> >>>> 4-KB read workload. The workload has 8 CPUs (unpaired hypertwins)
> >>>> running fio with io_uring submitting I/O to the ublk devices and 32
> >>>> ublk server CPUs (paired hypertwins) servicing the requests, achievi=
ng
> >>>> around 4M IOPS. Both the client and server CPUs look completely busy=
.
> >>>
> >>> That's a pretty nice improvement! Would be curious to hear what v2 lo=
oks
> >>> like.
> >
> > Looks the same as v1, which makes sense as both the client and server
> > are using IORING_SETUP_DEFER_TASKRUN.
>
> OK, sounds good.
>
> > I did observe fio seem to get stuck forever on one out of the 85 or so
> > runs, though. I'm a little concerned there might be a missing wakeup.
> > It was using the default iodepth_batch_complete_min=3D1 (waiting for
> > io_uring completions) and IORING_SETUP_DEFER_TASKRUN.
>
> There's a bug in v2 where it can get missed, the in-tree code should
> have that fixed. It was the atomic_dec_and_test() and
> atomic_try_cmpxchg() in io_req_local_work_add() racing.

Great, glad it's already fixed.

>
> >> And here's some more stuff on top you might find interesting. For a
> >> 6 NVMe drive test, it drops my task work usage from top-of-profiles
> >> to ~2%.
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=
=3Dio_uring-tw-mpscq-batch
> >>
> >> The patches sit on top of the io_uring-tw-mpscq branch.
> >
> > Yeah there are some interesting ideas there.
> >
> > The ublk server isn't using UBLK_F_BATCH_IO, so it unfortunately
> > wouldn't benefit from the task work batching for
> > UBLK_U_IO_COMMIT_IO_CMDS. The batching would probably need to be
> > scoped to the whole io_submit_sqes() in order to allow batching across
> > the multiple UBLK_U_IO_COMMIT_AND_FETCH_REQ commands. I'm also not
> > sure about the claim that __ublk_walk_cmd_buf() won't sleep;
> > ublk_batch_commit_io() calls io_buffer_unregister_bvec(), which could
> > sleep depending on the io_uring issue_flags.
>
> It's very much just a POC series of things... I suspect to get the
> benefit of it, we'd need a bit of refactoring and reworking first. It
> was more to get the idea out/across, not going anywhere right now.
>
> > The NVMe passthrough task work batching could definitely reduce
> > contention on the task work queue. I'll run a perf test.
>
> Thanks!

I tried it out and the 4K read throughput looks a little lower
actually (about a 1.7% improvement over the baseline vs. 2.6% with
just v2). Since the workload is loading 24 NVMe devices, I suspect
there just isn't much to be gained from batching completions within a
single NVMe queue.

I do see the time in __ioreq_task_work_add() on the ublk server went
down from 1.04% to 0.43%, though there's now 0.67% in the newly added
io_local_work_flush_batch().

The time in update_io_ticks() (largely from blk_account_io_done() on
NVMe completions) increased from 0.18% to 1.11%, though I'm a little
surprised that would be caused by these patches.

Best,
Caleb

