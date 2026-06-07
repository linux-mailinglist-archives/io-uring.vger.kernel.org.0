Return-Path: <io-uring+bounces-13626-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tovGC97PJWr2MAIAu9opvQ
	(envelope-from <io-uring+bounces-13626-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 22:09:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA3F65172E
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 22:09:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qs74HTsh;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13626-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13626-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 68A643002B6B
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 20:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6796A32D0D4;
	Sun,  7 Jun 2026 20:08:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96F831F98C
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 20:08:46 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780862928; cv=pass; b=SVtJtS2wOR/VKeZhHF0Ma2sIHn+T5H526uDr2/ydnq2Fx8h+Wvu/+INWHgW/fNUliUFsCReqptCQdPELsLx/xv+x5Sx6vsmh3cMjkYMgz/9q9+mNopdxjxlLbKzGqPcluo0ngBTwXs6TW+bXdb7vFf7iBo4wM+LeS5wxqYnlyVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780862928; c=relaxed/simple;
	bh=l50HDFLTHwvg5StCLr5dBGyEudy5UTde5PCBDwbkfMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khGdg4iyUzAz5dil9y6qsAXRD61wnExOTBl3lybDP8j0ZKyjiDQMMPy1j5o1fy0VaGHgSXxN9erVn+bHSmpG/Hn8rSI28t6nm39w+K18HVN0yXbws4I/EJKwWOs9Xe1fsZVJ6Dr2Plje3MmrWfM5nBxhmsCv4W14N/3X/pAkNBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qs74HTsh; arc=pass smtp.client-ip=209.85.167.170
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4863eae4526so1560965b6e.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 13:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780862926; cv=none;
        d=google.com; s=arc-20240605;
        b=YTixpmOkXuo+M4aXGGFVydafdBYgNlLiN2NJI77xWzmjLq+bDHseXYpGeAHRfFpflw
         vaSa9Ws49ghoQ1iOpKRgw+zhvB5dkHcCE/JH+HDw+alxstFhZx1T+tQyWVAi5QyZCDlJ
         YtX1fr6w28Pu9oqM6Hf9fdaT3UrzMKEuuNZc2JVTMHkp1Sdsl+MO7P6AhP1SFnkkHjtw
         bTHaqgs9dpUGoR4mCKzcXcBd0fn4apyRfWo9fgipELQ/JRZIZ1r4xVA9zrLsGBmLsC98
         H7roox/n0hiwiN6jqsqx+Zi1FsWLgmIrbLDfckUAF52qCwkeFuOKVdU1tp/Dc9RfniTx
         DGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7BrAaVoeOhT03V7fgLIYctCwTasfp3HGLqLPmDURmi8=;
        fh=UjUPYjCyuUY2Mb2LfpQI9V6TSxwVKRTjKeLIVK2k6xw=;
        b=XalCOlncc6Jp4cQJCTEg8iE7prZKfmZIFkFwoMOEaib6aFp5+Z7g2mXeiJyFBuD3Ob
         QxQR/j18hp4kgkjZT+qkmkv+WRgVgmq8DvQfegQnYDLuBtpqSHBoxjuux0Tx3zXnBskG
         B/uulySAJ0JznLpStu3zwUH4tfm0a1ZZIAF4g7/upIOpRdIoeIOlARm9q4Lq2DCefpHK
         ndO7bQuqyeT6DHAAkvIyoKvTaIke1Vkp2Z/c8jPmWyOkpay//eEJYN7Ugu1aEE7IKqwY
         Edvx336hZf8JssKIcXUlINX/S9KCUPhW4t+J50eUOs650LAxkV4kRp96qZoYTrBgp2Ia
         1LGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780862926; x=1781467726; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7BrAaVoeOhT03V7fgLIYctCwTasfp3HGLqLPmDURmi8=;
        b=qs74HTshB3Jv03EfsyIBW/M+c4+fsgWk6Qq2mY0oDVbsBZGOb+1ogXD0H8EZb2Wbkn
         3ZsWdL9XAHVdv3DNwC70UHTWdi4sTic+mRgLtJVQJHfZCAgVL6DKvf7dL5aEZEE0C6sP
         7nSYJVfC2Q489h8Je0on7pYVZ9O/PdklJCgklD9nT3ztzRwe989MKMOMdDEruQi2rgCj
         8SuDbrcTKbl9psdq6xn1XRr481sYHr/ZYrihDFrjkCjdzDZbEqU0+NrqFCjtwjJP+BXR
         +c6qgH+xaXDQauoUiqezHG+31Jo0i1aff3uQ4w5SYSp1vYubsj59EOSijYIqt720okvK
         JI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780862926; x=1781467726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BrAaVoeOhT03V7fgLIYctCwTasfp3HGLqLPmDURmi8=;
        b=aNT0F1CIN7sekyu8tpEuD+VrJZ11i6aLZWhl3rZPsz3kB92041SaEixghaLOhiyyw0
         WWTKhAr4KbXYF0jn1gKydCxJ+ztVA92G873J6hYlJnC+7IzietenClvs0hC8M251oDGY
         RgqZe8xY5GSK4LHVDUUXPARqa9QduRmhtAtETBQaFA1/eL4DNrENRgZY7ujivGfCYACd
         zGkxPDmaO1tiqsJskUliByxbDG/q//6jvfsnbyJ+x/SpML1VEz0qRu0fklv1CaELO9Kg
         OXjGZ+CyXqPlqo81SWWQjWkqW/GdegM8ARJ9KUpcMl4Wo3CycrCsCHw3bq8Dho8uKxxE
         9Mhg==
X-Gm-Message-State: AOJu0YwAXSL94aAMwwOmg1zFT50Te5Lm7YwJQbwxZ452gsSu8Bkj/zEE
	rB+OUNL1WPD5HMcunGn6VtTgxAAzG0ETS3EgWZOpxvxT6d52AHLKvIKKpTpwLTGLp5xm5Ht/mho
	arvCTc2BkVcuw6vGaEXdt1+t2ViA3bRXz6R+K
X-Gm-Gg: Acq92OFknU7MTOO+xpkF6yGdNraV+K8Uz8UuULob9MARYZUKa+7kmCN8yAVVYVQ2Kkj
	4y94Ulv95dPtZ4PA+hIbEBiqUJvsMQ13Af/whUTSbksfl/TYGtB3R+YVHt8Dy8DwJG7eE6pnopO
	xlK0np7n6kuHz9SgGz3d2TiH5GLdib+mF7uY8Q5qGmvSKZf+vZIfwTGxASi8g7PmhS/0dG++aTQ
	UXUu46/DGPeaMfsYvla9/qOkKP3QWJ3ZLFihqWZo3w89WyUwxUyKdoDVFL6F1BZXgXnfdsjf1sj
	A78e6qDmgT6ED360rg==
X-Received: by 2002:a05:6808:690a:b0:485:467f:a321 with SMTP id
 5614622812f47-4868dbf2788mr7007256b6e.12.1780862925509; Sun, 07 Jun 2026
 13:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
 <71417fb0-4060-4823-8e4f-f216ce0235d4@kernel.dk>
In-Reply-To: <71417fb0-4060-4823-8e4f-f216ce0235d4@kernel.dk>
From: Federico Brasili <federico.brasili@gmail.com>
Date: Sun, 7 Jun 2026 22:08:32 +0200
X-Gm-Features: AVVi8Cdq5nalMsRu_gLMRY7jDh0A9d7yYC0M3DlduL0EmAp0fOvJunKzu7Ck8kw
Message-ID: <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink
 non-INC pbuf ring len and affect later READ operations
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000011e5860653af76e3"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13626-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[federicobrasili@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	HAS_ATTACHMENT(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[federicobrasili@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2EA3F65172E

--00000000000011e5860653af76e3
Content-Type: text/plain; charset="UTF-8"

Hi Jens,

Sure, attaching the minimal reproducer and the output from my Ubuntu
7.0.0-22-generic test system.

The reproducer runs unprivileged and demonstrates:

1. non-INC provided-buffer ring with entry0.len = 4096 and entry1.len = 4096
2. IORING_OP_RECV + IOSQE_BUFFER_SELECT + IORING_RECVSEND_BUNDLE on an
empty SOCK_DGRAM socket
3. CQE returns -EAGAIN, but entry0.len is changed from 4096 to 1
4. a later unrelated IORING_OP_READ from a pipe using the same buffer
group returns 1 byte instead of 4096
5. a second READ uses entry1 and returns 4096, so head/bid accounting
appears coherent in this repro

I am not claiming privilege escalation from this. The demonstrated
issue is persistent provided-buffer descriptor length corruption after
a failed/no-data RECV_BUNDLE, affecting a later READ operation.

Thanks,
Federico

Il giorno dom 7 giu 2026 alle ore 21:07 Jens Axboe <axboe@kernel.dk> ha scritto:
>
> On 6/7/26 5:41 AM, Federico Brasili wrote:
> > Hi,
> >
> > I found a reproducible io_uring provided-buffer ring issue on Ubuntu
> > kernel 7.0.0-22-generic.
> >
> > A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
> > ring can persistently shrink the user-visible buffer descriptor
> > length. The modified length is not rolled back when the receive fails
> > with -EAGAIN/no data, and a later unrelated io_uring operation, such
> > as IORING_OP_READ from a pipe, consumes the corrupted length.
> >
> > This is not a demonstrated privilege escalation. The demonstrated
> > impact is deterministic unprivileged provided-buffer ring metadata
> > corruption across unrelated io_uring operations.
> >
> > Tested kernel:
> >
> > Linux ubuntu 7.0.0-22-generic #22-Ubuntu SMP PREEMPT_DYNAMIC Mon May
> > 25 15:54:34 UTC 2026 x86_64 GNU/Linux
> >
> > Summary:
> >
> > Create an io_uring instance as an unprivileged user.
> >
> > Register a non-INC provided-buffer ring with two buffers:
> >
> > entry0.len = 4096
> >
> > entry1.len = 4096
> >
> > Submit IORING_OP_RECV with:
> >
> > IOSQE_BUFFER_SELECT
> >
> > IORING_RECVSEND_BUNDLE
> >
> > req_len = 1
> >
> > MSG_DONTWAIT
> >
> > empty AF_UNIX SOCK_DGRAM socket
> >
> > The receive fails with -EAGAIN, but entry0.len is changed from 4096 to 1.
> >
> > Submit a later unrelated IORING_OP_READ from a pipe using the same
> > provided-buffer group with req_len = 4096.
> >
> > The READ returns only 1 byte, because it uses the previously corrupted
> > entry0.len.
> >
> > A second READ then consumes entry1 normally and returns 4096 bytes,
> > showing that head/bid accounting remains coherent and the corruption
> > is localized to the poisoned descriptor.
> >
> > Observed output from clean unprivileged reproduction:
> >
> > [INIT] uid=1002 entry0.len=4096 entry1.len=4096 tail=2
> > [STEP1] RECV BUNDLE on empty socket, req_len=1, expected CQE=-EAGAIN
> > [CQE_RECV_BUNDLE] res=-11 flags=0x0 user=0x1111
> > [AFTER_RECV_BUNDLE] entry0.len=1 entry1.len=4096 changed_buf0=0
> > changed_buf1=0 guard_before=0 guard_after=0
> > [STEP2] write pipe bytes=4096, then IORING_OP_READ req_len=4096 using
> > same pbuf group
> > [CQE_READ1] res=1 flags=0x1 user=0x6666
> > [AFTER_READ1] entry0.len=1 entry1.len=4096 changed_buf0=1
> > changed_buf1=0 guard_before=0 guard_after=0
> > [STEP3] write second pipe bytes=4096, then second IORING_OP_READ
> > req_len=4096 without republish
> > [CQE_READ2] res=4096 flags=0x10001 user=0x7777
> > [AFTER_READ2] entry0.len=1 entry1.len=4096 changed_buf0=1
> > changed_buf1=4096 guard_before=0 guard_after=0
> > [RESULT] PASS: unprivileged RECV_BUNDLE -EAGAIN poisoned pbuf len and
> > later IORING_OP_READ consumed the corrupted len.
> >
> > Why this looks like a bug:
> >
> > The failed receive should not persistently alter the provided-buffer
> > descriptor in a way that affects future unrelated operations. In this
> > case, a no-data/-EAGAIN RECV_BUNDLE changes entry0.len from 4096 to 1,
> > and that corrupted length is later consumed by IORING_OP_READ from a
> > pipe.
> >
> > The suspected root cause is in the non-INC provided-buffer ring BUNDLE
> > selection path:
> >
> > io_ring_buffers_peek()
> > if (len > arg->max_len) {
> > len = arg->max_len;
> > if (!(bl->flags & IOBL_INC)) {
> > arg->partial_map = 1;
> > if (iov != arg->iovs)
> > break;
> > WRITE_ONCE(buf->len, len);
> > }
> > }
> >
> > The descriptor length is modified during buffer selection/peek before
> > the receive operation has completed successfully. If the receive later
> > fails with -EAGAIN/no data, the buffer is recycled but the modified
> > buf->len is not restored.
> >
> > Additional observations:
> >
> > The issue reproduces as an unprivileged user.
> >
> > The effect crosses io_uring operations: RECV affects a later READ.
> >
> > The effect crosses subsystems: socket receive affects pipe read.
> >
> > The second READ correctly uses entry1 and returns 4096 bytes, so this
> > does not appear to be a head/bid desync in the tested case.
> >
> > No kernel crash, OOB write, UAF, or privilege escalation has been demonstrated.
> >
> > Expected behavior:
> >
> > If IORING_RECVSEND_BUNDLE fails with -EAGAIN/no data, the
> > provided-buffer ring descriptor should not be persistently modified,
> > or the original len should be restored during recycle/rollback.
> >
> > Actual behavior:
> >
> > The failed BUNDLE receive leaves entry0.len shortened to the requested
> > length, and later unrelated operations using the same provided-buffer
> > group consume that corrupted length.
> >
> > I can provide the minimal C reproducer and full output if useful.
>
> Please do, no point in me recreating one for it. Then it can also get
> turned into a regression test cor liburing. Reproducers also mean more
> than a thousand words in an email, it tells us exactly what is bring run
> and what is going wrong. Or in some cases, what the wrong expectations
> are.
>
> --
> Jens Axboe

--00000000000011e5860653af76e3
Content-Type: application/x-gzip; 
	name="iouring_pbuf_reproducer_for_jens.tar.gz"
Content-Disposition: attachment; 
	filename="iouring_pbuf_reproducer_for_jens.tar.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_mq47sg4y0>
X-Attachment-Id: f_mq47sg4y0

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
qqiivxn9Hw6JPToAUAAA
--00000000000011e5860653af76e3--

