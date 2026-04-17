Return-Path: <io-uring+bounces-13064-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0L71GwCg4mmB8QAAu9opvQ
	(envelope-from <io-uring+bounces-13064-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 23:02:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBE841E97A
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 23:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E0E5304997F
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 21:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B5F3370EB;
	Fri, 17 Apr 2026 21:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5TxPB2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D8A2BEFED
	for <io-uring@vger.kernel.org>; Fri, 17 Apr 2026 21:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776459757; cv=pass; b=A39wkr09iEoSHiSru4RtlMoFmU8JezNTIa1XDOVAxTHN4mcL4A8SZiT9Lt5lHeP0JzqSMgJP6j7Fyqjc1iwd4AucmZbCYbI6hj6AlV4casc9b0pA5tVMQ2Wuvei+1NZtNL3DZV10zeQxmykfyp3SQ74TJmuemDUIHNhpZaLNAIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776459757; c=relaxed/simple;
	bh=ldLskh1xFyY9LjS3JUCJCZqJWyAYipdzRp7+NJODLRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=umwjWONUJoWYKcpeD4yXt7aB8oMw6fKLEoWMM45dhfwEVcDmeMk0+AGFY2ZO2guS/SF8NGERSe1jEvBXOXjy2KXRqeMe3waJxaRjWSriLjhi50yS1+OFPCwySjdEKc50GzJEzecOWXaT9vAC35l//RXJUZqAZJKqZUwJm3xcWyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q5TxPB2G; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d70c30767so1274805f8f.0
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2026 14:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776459754; cv=none;
        d=google.com; s=arc-20240605;
        b=SXXjtmcYRKTf6slYGExQ/i/VhTpZ6hdodLuVqgaSHYywSqcCnSewNMqDYS9PYf1Wx0
         zsFyuI22aIH0cZmtrEqd8K8Fa3CNz99aKbD2Vc83oT6icmXN2sfG9R9baJenvZ5K8Vj1
         D33EUhwTLmL0bUE0TOqRrOz1c1Z3Jjy2vzDBo2mUkeopKq9Y4TsXQjtdNYzmg1DaOerF
         zqPUk09aMhK1PHKlTaItAUA/GXtjQLzOJlY0HbkK+syO0BCyKtQpuiXcT5OsBT70N1CZ
         ANHOKiR0u5pbU/PxLwnZOeRE/9GtQ2NsJNDRddI8cUthL/HYG97UqXsNOrMYbKLN0o9D
         Wcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=STzWu05WxWgbbMhX2ONEineRl8NEoNmuhfJo1fCqMWY=;
        fh=p8hBUpuQWj+6IhjHY5p3laEDHTaoGhT8QXG0gqukLM0=;
        b=eBgI2RQWw2VAufbpjL/WXviwoAM++O2adp9xha6PO2GhVXBnI0FgU8fj0HNajP80zk
         dGRZaZVAMKX16ToWnNFTjo+vu0OrNYKUMKbFUHIMRYKmxe/nrFM3/LtShCCMB6+TdXrZ
         42QAX1Fy0ziuVHw+8Fymr1y5IjGLB1ZsmU/qcY+1ZgA1zeDzqOVIRtQgNjBhUaojDLvc
         M5ehtAcfn2nLusfEPnllUd8AIXiyHSmIWgfnIaSfxLdtJ+Dc8r+aQiBZQmjY4SbRTxbA
         DSHJb0Zv+WiIY5c4Rv/YO1ZdZeZRQ+eFJg7h4ckaV1YumzFqL/A5tQs2CFPJcQeVjKfT
         E1FA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776459754; x=1777064554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STzWu05WxWgbbMhX2ONEineRl8NEoNmuhfJo1fCqMWY=;
        b=q5TxPB2GC1zik4ZXZSuShB3pD8gqLI2znKArvD9tP77UtlBQETK+F2jRy5eGd0EZKt
         aTHo6gVIyeFr2wimirJj8w4qqRn4l7/5O8pXee4DxRfYaSl3COErYI6tv3eNoL3DafO6
         NHcuSheJfdvAzpd3z78eJbuUZZ1/RYnZk4y3S8/5CN3tFmbAl2qmvGnJmMP1chf3hzFU
         yEuuORYzGORq0VfmS/aspIeEE5VH7N/jvZYLaH3Ie/R3hifAc7A8xkZRCcyXaEQvHwso
         sVJtZJyY3JoPoUNyxovk76c3DDocm0FnQe4s7aln1X0yusmdc+sRDgmHv9qU1ximM32R
         byKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459754; x=1777064554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=STzWu05WxWgbbMhX2ONEineRl8NEoNmuhfJo1fCqMWY=;
        b=Ibjv525LGimAplhMXS/+Z2AvwZssVKnQ3kcxsFRWMVxgLPYPeuR4fd93tYI6V2FvYV
         ueVIG2ts6eks/i+pdLiApxk0OYxuZ1F09CQHYOowUc6IbEArkOZkTRnaR+U278qKFo8R
         DHxT1Plx5Pg61GQS3STIKgZH0ijmbMZGx9A5u4L39h5snx0UOTNwTnnTp9intiPfe8IA
         6j33bPiO2WywSfwaQf9dCz6QOwG2Y2xeMt5zJwbNOd+hFTtqMId6eTjGbxox7gsVVLgM
         f9QqbPTbvtJx9EeS95Ida6Kw8+7kOo7/WvYKxygsOlbzjs3nF61FQU8Z0hUbCRSSdztf
         tacw==
X-Forwarded-Encrypted: i=1; AFNElJ8dLtHP0h+3SQypHFLO+XSP3fJ7oSv6SJEZwN7EkX8SlRNTH3uBMiPPCvfPYQVi0/jiXxrM/Lj1MQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFznAIUxw8At2OdiUNhsH+uIFLbl9j2+U6LIIwOQUNzmq3yiKo
	JQkkJNEsdqQXAJgT/yFVR1m454lsxMlAtr0OvX5A4HlFSeKRV+kgedKCO3mAuc8bYJptWcslqJW
	t22RLDov5tfamtVYULwRPn60Xo7Cotho=
X-Gm-Gg: AeBDiet8Ty9AC2VuPf8RP7R1RyarAecQwPQHy5mMSsto3K9PuIuQXJ4R4Phv2Y/ODrT
	rTr3bje4jhMvOJeHesHumJGgIDDJgO8AYPFNFnAFS8vAQKFPbD2OkdeLkVSVNVWKWQauVoetFez
	cZCrn7R9WVEuFmLWNVY+rvRudiSChtSs6YXplo1ziKAPKn5q1MCEJHPh6VP1+XlriP8cD/yO8K/
	/jngOOpP4p1SxhYa+8DjMcC4MHziUc/uqr9Vab7/6Oeb/J1tPTtiBRdPyS4DKZs+KdQp40XANwA
	ajOhSyug1M+adTDS
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id
 ffacd0b85a97d-43fe40329ecmr6082677f8f.5.1776459753917; Fri, 17 Apr 2026
 14:02:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com> <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
In-Reply-To: <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 17 Apr 2026 14:02:22 -0700
X-Gm-Features: AQROBzDJomy37fRGlsjcaUyKE3fC4JNz7SjvTUIC4c85XEUUQ5LxX27GEuS9umY
Message-ID: <CAJnrk1Yw3=z7W_my4pLG6avBeDZkUp3j1LZk-RVpGv2vAsw-ZA@mail.gmail.com>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Bernd Schubert <bernd@niova.io>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev, 
	io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	"Lei, Ming" <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13064-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,niova.io:email]
X-Rspamd-Queue-Id: EEBE841E97A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 7:46=E2=80=AFAM Bernd Schubert <bernd@niova.io> wro=
te:
>
> Hi Ming,
>
> On 4/16/26 15:49, Ming Lei wrote:
> > Hi Bernd,
> >
> > On Tue, Apr 14, 2026 at 5:33=E2=80=AFAM Bernd Schubert <bernd@niova.io>=
 wrote:
> >>
> >> And my current primary goal is to let ublk to support multiple buffer
> >> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> >
> > Ublk server is just one liburing application, and it supports all gener=
ic
> > io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
> > in theory.
> >
> > It really depends on how your ublk server is implemented.
> >
> > Maybe you can share your motivation first before discussing kbuf/pbuf s=
upport.
> > If it is for DMA,  there are other candidates too, such as hugepage,
> > recent added
> > UBLK_U_CMD_REG_BUF, ...
> Joanne had actually removed kBuf and switched to pBuf alone and that
> simiplifies things a bit.

Hi Bernd,

>
> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
> saturate streaming bandwidth, but still want to get smaller IOs through,
> for these smaller IOs you don't want to assign the 1MB buffer for each
> queue entry / tag.

Have you considered having separate rings take separate payload sizes
instead of having each ring support multiple different payload sizes?
I think this gives a few non-trivial benefits over per-ring
multi-buffer-size support:

* less head-of-line blocking - with a single ring, the large io
requests can block smaller metadata requests until the io completes,
since fuse processes cqes sequentially from a single ring. Separate
rings would allow smaller requests to proceed independently of io
* makes kernel-side request dispatching more efficient + simpler  - if
for example there's 10 different rings and each of them supports 4
categories of buffer sizes, imo it gets non-trivially complicated to
find an available ring that supports the payload size that needs to be
sent, if there's lots of parallel requests going on. In the worst
case, we would have to check each of the 10 rings' various categories
of buffer sizes to see if there's a slot that's big enough.
* simpler kernel-side buffer management - keeping track of the payload
buffers in the ring becomes a lot simpler, since there's just one
buffer size the ring supports
* more dynamic / deterministic scalability - I think you mentioned on
another thread you were interested in dynamically adding ents to
rings. Having separate rings for separate payload sizes would make
independently scaling queues based on workload characteristics a lot
easier. for example if there were 10 rings that each support 4
different buffer sizes, one question I would have is which ring would
the extra entry be added to? It kind of seems like at request dispatch
time, it would have to do that non-trivial ent searching logic across
all rings mentioned earlier to find that extra ent?

These are just my 2 cents, but it kind of seems t o me that having
separate rings take separate payload sizes could be more scalable for
your use case?

Thanks,
Joanne

> Zero copy is currently still out of question for us, although I will
> look into your recent work for integration of eBPF and if erasure
> coding, compression and checksums could be done with that (I guess
> checksums is the easy part).
>
> Ublk already has UBLK_F_NEED_GET_DATA, but that has two issues
> - needs another round trip (testing on my laptop shows a perf loss of 10
> to 15% per queue)
> - It does not release the application buffer on read. I have an idea how
> to fix that, but here at Niova we would like to go the dynamic memory
> appraoch with pBufs to avoid additional round trip overhead.
>
> Idea with pBufs: Several pBufs registered per queue at registration
> time. Every pBuf represents a different IO size. Optionally as with
> Joannes patches [1] the buffers can get pinned to avoid mapping to pages
> for every access.
> I'm currently working on a patch series with some luck will sent an RFC
> tomorrow. The harder part compared to fuse is that ublk_drv does not
> have its own queues/lists so far. This is my first work on block layer -
> I'm not sure if internal struct request queuing is allowed at all.
> Testing will show in a bit :)
>
>
> Thanks,
> Bernd
>
>
> [1]
> https://lore.kernel.org/linux-fsdevel/20260402162840.2989717-1-joannelkoo=
ng@gmail.com/T/#mb8f96895aa2773424005ee06bb62ae980e95e604
>
>

