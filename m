Return-Path: <io-uring+bounces-13733-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id f0l7CnU9MGo5QQUAu9opvQ
	(envelope-from <io-uring+bounces-13733-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 19:59:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB2C68903D
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 19:59:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=TPqnN2jj;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13733-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13733-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67D33300C590
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 17:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EA22EA171;
	Mon, 15 Jun 2026 17:55:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6742E6116
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 17:55:35 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546137; cv=pass; b=LpAJQO/FVpzNrZn3C9M/sRhI2UG/cXnHYFaaMWSFJgRJipLbq8p3z62tXRTNpFKUXhKAnxnTpjnSeUySqX7asSeRHn4AOulKwHmAK1oBFVEuPouWKoKhSjG+Div04Wh/SpUyukMea2rQ/1b9pfea2W+CTAWIcvjbTik29vTI3No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546137; c=relaxed/simple;
	bh=2HNzc6BkLGmKQYsq0tLIIchOqSmzAZOzz0YcEeXHtEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaLC0XoGLtGVyR9QjUweRGx2b8JOsV2bywckUMg6PocdugDcZZqa/rxNnfPm3v1U5BRZReUoJYYJHGY+bWyFD3qXqmIvEHZDfhSVUp4hkwEQA2rRMtoWuIvAylpKXS+a4f95TlzBiy5NrCPBoIEjR7kmcZMzQW5JUEPsusOmc9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TPqnN2jj; arc=pass smtp.client-ip=209.85.210.52
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6de917a27so460550a34.2
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 10:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781546135; cv=none;
        d=google.com; s=arc-20240605;
        b=VwtnCcwYYUnbH8zjQAdoyF/uWYOAjOqm5x6lz+nYYW26oW0KOVrZ8j4wd1/jZNNMQy
         /xshq/x9DV70Fckj2L8sKZoHjYph5LopoQL/F4r1FJew6LOKBa7i3n0IiRk/Pc+X8BAF
         ESqxwMT/w6HkMbX62JTeo0FkR+AkFbofknD8oSIBMtVGpnv+MrVsItiv86En/8uo5sQa
         udLA3B/dy9vyGxowkrDYJsSS1Boyy0suTgepZ8gZpra6DKrRiwivtMPy7KCGrc0hzXRj
         ao7xKwCvLesPPO1bDeEJVEVojpD8Yqa7xPPO2dORhEivIFUdGtT0DvtP7UsadsKC45El
         RJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2HNzc6BkLGmKQYsq0tLIIchOqSmzAZOzz0YcEeXHtEE=;
        fh=8SanVj4MV0LZcXSROTGCY35wrAI3fk+fJGDl/3jrlWo=;
        b=ZyAoKeo4POQ4bLczHXre1XgWOQfFJm7aF9KxbgihQWUeUC1e0+lm3t3edejyeFuu9M
         GM7amyQHPCXTTp6b+JIuFwzTkCeAP5j2XBqBFcT416lR/RzclDyyuoYTtUzhBK//DGoX
         N2rNFrEExWbx+wj4yWEeWLw9uWdkt+Hl6lqhRxH69zJBNvHFvh9sNdIZntPbEzqoBw65
         1U6c+JOmqxkq0ZZVXnIHkl4TMXi85adJuYdddKGuXO19/FC0nRoRSutQBgRW5qfg3WTC
         K6W0rVh8MN0oPrUSx9wgzu36Sbw0fSypDsFb6pbOdZ+VW6Ux/kc8GC4bzkYk6sgnU0/x
         W09A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781546135; x=1782150935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2HNzc6BkLGmKQYsq0tLIIchOqSmzAZOzz0YcEeXHtEE=;
        b=TPqnN2jjO9khqD04ym1NAlm75qXyQiCSc8EtwD8LvTr0xpDCZq59vFOhyYyRwNPSWD
         T/UIC7hO0ayg/qyRoHrWIQwOQNteQ+hMqKM5HKto/d60i7VvcnPFraKoa+oSX6Ol4wLx
         +Lj5djQzU3shjG9YOU0MFMYU07xhcCxjpnOwwpRlT0Ar3FanH2KQhjXNl1fKMC+Q5acn
         aEAnsLR/bEm1NdLAWwAL41VCRD7a1+YmANXAVvYM0hfFsa98FwV3fPmtxh1LXUI95JkK
         mlIMRdNhoUZJixxeKL2A1w5X1gRcwE7CaoomAj2vCW7oEzwYEKmoK6czfuX1Lg7LP22e
         fLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546135; x=1782150935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2HNzc6BkLGmKQYsq0tLIIchOqSmzAZOzz0YcEeXHtEE=;
        b=VmDqP/EMnTYTFkVqv7MvOtvcdpJjToT8TVlut9JMhjlyIdcMq92EX8F8WJZucqGHbn
         trecJN0jKd5BG/samtfrNZb86+z2TvSWq3Q7a0m8Hj9TNwvXf5ZGhjbXhqJQlnAP0nch
         XAj2/K41Sm5bYRBvu7vFRh9dDvFWNcdUHoNucINKcWSGVDPT20h2mbhO5McC7uT6kmoj
         4wNJdZMF/UEaqas/IwHvnPPKwtmV7GAeo3wI2RsTl94JsTwS45Dtkw8lLtCljo9wd0pc
         Gm+4fNzfe7Lxy+35Q+EGML7KCC1UF14q2moi3wfWM9TVikDOu0P+L+opUfMI7DY9BfzG
         woMQ==
X-Gm-Message-State: AOJu0YwFEMV/wTdUqgsOOyh2ZW3FuDOxARpTW0oqyYlXxbtIvH8yyxYT
	7e3NqrRWwyQgP08kIKK7n1cY6ciElehZw457ZYP93fFx6R1SXWIi2M5SxOMLAzsv0/MiD4k3Pww
	WNVLVJhiInbgySF+acR22+s+Pg9Iba5N5ZYMUkXzQcwuw12Dv4TDCLG4=
X-Gm-Gg: Acq92OG1djA/KBnz4dr3y3DbJZH6bQKhJegIJiASOOx7tDG4shRULqYOk3/d9LdJROH
	UPk8aDJ+imMaFxmVQ0BSaSRIgA6im5042Pchk4YtEcxIikX/4iG2eonKzKbl0HOqLzgBeG0HLKN
	7m/QrpWb3O9c1oFRkGd9gP4vhsRvek0LDMWnkS++JtwN4KTvgMnvVuW4hKOkPxbJ5LaSdfuPcyq
	QH1wA8NOxOD7vUePcECUus3PxONOAuYjsPGzz23meDe9NoqBSWo1QbsmMFnNerIeA72Whddu5Sj
	nAfNalM=
X-Received: by 2002:a05:6830:6814:b0:7e5:f49b:35b9 with SMTP id
 46e09a7af769-7e78448f07emr6253600a34.0.1781546134675; Mon, 15 Jun 2026
 10:55:34 -0700 (PDT)
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
In-Reply-To: <9232ba9e-2ea5-4ed2-9043-15190e0f5d0e@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Jun 2026 10:55:23 -0700
X-Gm-Features: AVVi8CcTEjR-B7vTY05qwVlrMpE1kzymNDemPtn2nNj72J4whzQcoL_6McqvY-4
Message-ID: <CADUfDZoEhdom7cqRfKhMkhhRc0vmRpzRR-AZXndMhLnLa9KqYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: switch local task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13733-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6AB2C68903D

On Fri, Jun 12, 2026 at 8:11=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/12/26 6:21 AM, Jens Axboe wrote:
> > On 6/11/26 11:24 PM, Caleb Sander Mateos wrote:
> >> On Thu, Jun 11, 2026 at 7:23?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 6/11/26 7:14 PM, Caleb Sander Mateos wrote:
> >>>> This is great stuff! I had also observed these hotspots on a ublk
> >>>> workload. Since incoming ublk requests post task work to the ublk
> >>>> server's io_urings and completed ublk requests post task work to the
> >>>> client's io_urings, there is significant cross-CPU contention on the
> >>>> task work queues.
> >>>
> >>> Glad you like it! Once I post v2 tomorrow, perhaps you can try and ru=
n
> >>> some tests with and without and see how it does for you?
> >>
> >> Haven't tested v2 yet, but v1 shows a 4% IOPS improvement on a ublk
> >> 4-KB read workload. The workload has 8 CPUs (unpaired hypertwins)
> >> running fio with io_uring submitting I/O to the ublk devices and 32
> >> ublk server CPUs (paired hypertwins) servicing the requests, achieving
> >> around 4M IOPS. Both the client and server CPUs look completely busy.
> >
> > That's a pretty nice improvement! Would be curious to hear what v2 look=
s
> > like.

Looks the same as v1, which makes sense as both the client and server
are using IORING_SETUP_DEFER_TASKRUN.

I did observe fio seem to get stuck forever on one out of the 85 or so
runs, though. I'm a little concerned there might be a missing wakeup.
It was using the default iodepth_batch_complete_min=3D1 (waiting for
io_uring completions) and IORING_SETUP_DEFER_TASKRUN.

>
> And here's some more stuff on top you might find interesting. For a
> 6 NVMe drive test, it drops my task work usage from top-of-profiles
> to ~2%.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=3D=
io_uring-tw-mpscq-batch
>
> The patches sit on top of the io_uring-tw-mpscq branch.

Yeah there are some interesting ideas there.

The ublk server isn't using UBLK_F_BATCH_IO, so it unfortunately
wouldn't benefit from the task work batching for
UBLK_U_IO_COMMIT_IO_CMDS. The batching would probably need to be
scoped to the whole io_submit_sqes() in order to allow batching across
the multiple UBLK_U_IO_COMMIT_AND_FETCH_REQ commands. I'm also not
sure about the claim that __ublk_walk_cmd_buf() won't sleep;
ublk_batch_commit_io() calls io_buffer_unregister_bvec(), which could
sleep depending on the io_uring issue_flags.

The NVMe passthrough task work batching could definitely reduce
contention on the task work queue. I'll run a perf test.

Thanks,
Caleb

