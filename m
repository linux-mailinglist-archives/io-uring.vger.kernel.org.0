Return-Path: <io-uring+bounces-13882-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1CWyH4VgSWqM0wAAu9opvQ
	(envelope-from <io-uring+bounces-13882-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 21:35:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2963708410
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 21:35:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nSwyqJdW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13882-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13882-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 34F7D3005585
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2026 19:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6072DCC05;
	Sat,  4 Jul 2026 19:35:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4EA2749DF
	for <io-uring@vger.kernel.org>; Sat,  4 Jul 2026 19:35:29 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783193731; cv=pass; b=JZSIvYo8zPh6IOCHgMbYmOl6kiHc60TME/L2r62RYYTB534SbtmokflsziDdDGJqPu1JtgA0MSAQDEcLtp9PcCtR7wqEuCI4LfTcLV0JYIKefOeMNuCIQ2LzctGOJjVrTyMJEmSKb9dvyP8QyNHOOXCynWMgmj/kX17v+xNnaLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783193731; c=relaxed/simple;
	bh=b3CrwKqyAv3Jz/2LrARYpMrBZn1vkwKWk+FaB7Pi51g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LSw9qQmU6Sz4T9dbOcdVZBP8QOXsRXwjDZ1f+8hiTNaj3d4SavNrP4NRT2oN1iKsBe1ZHdywsYmoh0l4e1X6PxnnD5sagRgHR/3UQ51ottI/kGH+N4K8nkE2AeA0Lhu1KIZrJLNFfCc+90BlGLNal73Ss+8W1lzqrAF4TeUEOHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nSwyqJdW; arc=pass smtp.client-ip=209.85.208.176
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39b2acd2414so8636291fa.1
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2026 12:35:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783193728; cv=none;
        d=google.com; s=arc-20260327;
        b=DxsDgchX0CLBLbNtjG1h3h02/1IWx1wzMD0ul1PjtYPfc0nqYOEzto0aRS4KA6FGn6
         sOYpY3E1YoOgNpze7K/A3ctYYwn0TRSBLh6pYJFPpiYVfyZ7cGi3FR2oVhdjgu3Cm3WG
         2RfashkN+Ud+4Kai4qmRDTS4891cdLf4RuUhQaG7j9kWHbBxpdAlZIqijNpW8SX24bHX
         xCXIfDPRDo31eK5qT0WfXjmee5WDgYZIe3c/bXAeVyGxyPfGXG8S3bDom1lCsm0zo+2h
         RfpWAZ2zg/+3hjvJnioYVCNrxH24mZuBGFsqhn0so/d0vpviDgQ0HqLKwr9+OiCqkT5d
         yJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9Rt6ng2Di7J7/cJojtwgESlRRb/8HwpdA97QWHatp4=;
        fh=aa6MUOcK5F58p5HBzVhl8mjFetjob2b8/6OIMGfulv4=;
        b=Tvsl7ER4EcVRFbdnb69vOD2F3OwmBI+r/eSqYhM9Ktkq71mSmT4CGJ+8RF5IZMfQyb
         kss+aWQs1rjoZtzC5sw6ZpoBDnOKgYe37lsrcEjcVB9TOmzNlT1EarPAIcNmyrv+vE1v
         HTTN/PQJpfDNhqvV/ekGrBEf4CDEKZ70bzpajnloJGtxttJGM+ZvDkukTU4Lsu8Gb1cy
         OkhGf/D2PzOsnJUqbYYJ003CJ8TVQ2j4AFvg9X9JLDZpnjIFLlOlo3qA7GWHM89XTETU
         jPc2l/z1cdN2W5cs0uVWcV1JrgR9Z8gc618aSV6wvdf+HnSAgSjXe2yXTuZNFdDOP42j
         v6tQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783193728; x=1783798528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9Rt6ng2Di7J7/cJojtwgESlRRb/8HwpdA97QWHatp4=;
        b=nSwyqJdWjVT/j7LcivqrHBkks5KIWIWm6hWolGqv0jsfAWUoxDHvojyrxfANE8sJrC
         z9pv/P6/uw5rVWbQegqxVUZ8to6aR08A7pddNO24i37C1RaegYBjTbum164YJkeFA2qn
         VR6ZODZUOMc3GcEcrrv8EvEAuoBBk1nG1Z/ZXzKuSVp60qP9g/crkEac1rQYpDeES/ie
         po9o7yI1hzNK66ww1HmZHp+0kg+bJoP5mWVdnRCmKHp3U1H5OBTZ/Kq7S+xAhecgcXUv
         5H/yFENRmrLF2Qk6/X6jT+1dqE2Fx628+hLpimLCVQBfa+sFnmleQrjZy2JRtSMVzh5H
         1/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783193728; x=1783798528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H9Rt6ng2Di7J7/cJojtwgESlRRb/8HwpdA97QWHatp4=;
        b=PeiUcvImg01EeMvVdPeY/g164ysxuoEYBnQlp/IO2c71I8wIhBsAYBKX3RiC93pOfa
         eWyFeyxcG40itGTxFFczjfmcSQIYRyso2dQKTLOuTQMQnazfOuXL5Wn3vEvOdA5J9z/o
         db7SiPAEIC+QcD3xzFOwDKbqtf2ObkoBtH7USFWtBApbMQPMauYM5Z5BPIInh+yhCxH7
         EyYRTiynC+3jEvXBgiV8d4Xbp68gPsYvuLx1B4HQRFSM3J3GsUfSranKA/HbGw9pIoZC
         6h5SU7Dj/+M0BVK9AU6Q63mZyMBnn5rJgLu22Kxu9PAiPbITfelmDkqmYYt1HJCi5bEK
         zIig==
X-Forwarded-Encrypted: i=1; AHgh+RoSswpkJwcKsInHADkLMNSfkDFPccKoT8Rk+b5gn08jYqGhSgOB1CutDYduBH9Kd8ZP9YPjNoCOgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxW8aUf/eylrkfXUDR11p1HCebhlU3bR8/bkNWG7xBtq3e+pFhb
	q/DedJwNUK9jPfF9fE3+QOcF6mXN9jcexiQlisGhI34gu9koXu3sE4+2OYvOfqvhiZ148jALeDL
	TEmo5Kz0+/BW0ZDXdhNFOBfYN9SuDfHcSFB1Ftms=
X-Gm-Gg: AfdE7cn5U/jF5WM0/Q9QRUnWwaJSpdgH/E/s4MV+rPNqHmfH51afFKux2dVGcIPkRn2
	jcgG3xHRc5v+wPakkhbDwVAsncgOauIb4WFds91a3j9U6nO3eL6nUuT/gyZ6sZxG7n7LLk4HwQn
	yWErF72asMNN9u7dgeMhXigLIllSpPUUMrSekRV1WZ6zrmi8LwMzmhuC1/na3grBiWxB25NOgKJ
	h8EkrBS3ZbA8fLRJI4tIakDCuhS4hzIZb7WL98VPq0zQRsi76ratdqgrRH06lgK6xR22uElrxr/
	XB9f0FAJNTmQOM3TWKUDFhV6VmTytLZtjgqK84+OwjqFNQ==
X-Received: by 2002:a2e:bcc3:0:b0:39a:e32c:39a3 with SMTP id
 38308e7fff4ca-39b53d2a01emr7413741fa.35.1783193727408; Sat, 04 Jul 2026
 12:35:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk> <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk> <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk> <aj6tTiAB2NIol9Tf@kbusch-mbp>
 <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
 <CA+KFGSoZXejMvA5WNBSy=TVxiEiJs1-bxHXkewk8HtCR5m8sEw@mail.gmail.com> <akk8Xhyntk9_weMp@kbusch-mbp>
In-Reply-To: <akk8Xhyntk9_weMp@kbusch-mbp>
From: Ben Carey <benjamin.james.carey3@gmail.com>
Date: Sat, 4 Jul 2026 15:35:14 -0400
X-Gm-Features: AVVi8CdRhhmFxzVkRU_FPFIKktQ95fjFtGart1pTCz4easwVYT9WMQEJxTJa2yY
Message-ID: <CA+KFGSoGVBzsnhht5Opo2PCf33M0uiLjK7BNQ-t2DjTDudwXrw@mail.gmail.com>
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13882-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F2963708410

On Sat, Jul 4, 2026 at 1:01=E2=80=AFPM Keith Busch <kbusch@kernel.org> wrot=
e:
>
> What exactly do you have in mind? Shouldn't you expect to spend most of
> your CPU time in the polling loop? As long as you keep the queues busy,
> there's something to poll, so blk_hctx_poll is exactly where you want to
> see the software be in a perf report. Seeing a high poll CPU utilization
> means the software is efficient compared to the hardware. If we spend
> very little time in the polling loop, then either you have incredibly
> quick hardware, and let's face it, Optane SSDs are EOL and a generation
> behind on link speeds so that's not gonna get there anymore, or our
> software dispatch stack has an inefficiency somewhere.

This is a fair point and I also think exposes some flaws with using perf
runtime reports for justifying a fix.

I'm most definitely not qualified to suggest this as a passable alternative=
,
but when polling a tagset, is there a way to check if the tagset's been
completed by another thread? Maybe break out if, for each polled request,
request->state =3D=3D MQ_RQ_COMPLETE? I'm unsure how to translate the param=
eters in
blk_hctx_poll into the set of requests being waited on.

> If you have many pollers competing against a very low utilized queue,
> then I think you have an application level problem mismatched to the
> feature.

You're right, the test case above doesn't give a fair representation of the
issue.

> The only thing the jiffie timeout may show a problem is when you stop
> dispatching, which should only affect the time to close the ring when it
> lost the polling race with a peer on the last IO it is looking for, but
> should not affect individual IO latency.

We measured the disk latency usage with a simple kernel patch and confirmed
that individual IO latency is not impacted by the timeout issue.

We've seen, however, that the timeout can occur a large number of times eve=
n
with high queue saturation. When running the fio job below we observed the
timeout 132757 times, which I'm concerned could negatively impact bandwidth=
.

fio --bs=3D128K --direct=3D1 --iodepth=3D256 --runtime=3D200 --rw=3Drandrea=
d \
    --time_based \
  --ioengine=3Dio_uring --hipri=3D1 --fixedbufs=3D0 --registerfiles=3D0 \
    --sqthread_poll=3D0 \
  --numjobs=3D32 --name=3Djob0 --output-format=3Djson --clocksource=3Dclock=
_gettime \
  --filename=3D/dev/nvme0n1

