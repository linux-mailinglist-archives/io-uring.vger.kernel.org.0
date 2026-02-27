Return-Path: <io-uring+bounces-12452-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDAqIePCoWkVwQQAu9opvQ
	(envelope-from <io-uring+bounces-12452-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:14:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C1D1BAA3F
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2E3FD3010783
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13A039E6E6;
	Fri, 27 Feb 2026 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b="cSXygthZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6923AE62
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208854; cv=pass; b=t5mcOMbK6uYcZXsT9TcMa5D7P/1DYT5wvdKsZVxwHbWgsBHFKVR/7YXEEfX52gc1QcvYqM3q5TR/0hSzDSYe62FNiSgtNfXMnhExKAKDWsReOhAxRiIMv9b6hXOCpVprFsxZB06kb2m/SQbC91AxCfE2/4pZPeYJYQNKAjFxdqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208854; c=relaxed/simple;
	bh=RDVHrsvD/nMrKcdQC6Qlssi8nAT29GJ82+AUHrahiC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZxMa+99oFz9Kn9NcyDh7yNE6q60mHs5OvZZdR8s3ibJlOWK5y38QV/q8vOSgXvUGsCGFBbGnwwWg47aKlLF3J3pTTbdk3gjFQzGWriudCeD/aF/V3rqZYa/erGvxPCOeMJsB2e/P8Hu47k4RjctQXNK7VTEfGAONJOjbQ0yi9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries; spf=pass smtp.mailfrom=p2p.industries; dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b=cSXygthZ; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=p2p.industries
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c5a7785b4so3547535a12.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 08:14:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772208852; cv=none;
        d=google.com; s=arc-20240605;
        b=Ng6oeiKJlejvXGYC428iyNCAJpHxgjbU62o99fcbYeCZeJJqHytVSXxt9IMDALZA5i
         21VktlZB4cb+49DE9hPQ3prmFG+F3qCmmYE2r7Pcwm94iAUJVXwrZzZTy0Xl70xX82Pe
         V1fAVwF3hmpcjGxI3yNYDYR37deEPNFfjbuJISovnX0myhoeq4ZgTdoVo8l+c3RnLcAH
         mdbiErtBHXgNDxWKULs5IT3rCY8w2zpQ07yEW2RLM3uIgcnpV9M8IwwTo04H5RK3KF2O
         OSMnhAcY0qj9HbPplWr1EG6xcu5dz/d0DKXnsHPbz6eUGXRPlt4We/e0sU/BhNAOibBM
         sU4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EuhUnQIPvmsvPWxX1LkP6je2ZMIaRFoju8evpbHyzk0=;
        fh=JwgYpn38fL+FX3u3bOtC52P9P0oQ6Z7bKZBleScUyls=;
        b=VQSQ2NmIv1lhCm84Fjvh0oa3OFWrF9aka5HzsvttdG589+enUK38LAnJ60+KSyhDVm
         Xnh/KZKKIVbYiBcoUqRy/uT1HIhVxRgsdt7c2+XVbQMqwxSn3FKAMolDrSA8p6LCjYTt
         5mze3lHoJfpYswMWAqJITpFRXhivtx5AoH8thmo7LGR/jk5N5D5tNFPk68Z61XHeiqs/
         HW81GPYI/VFNg++We2ui9e6WKIqeb82Zu54XR60kcQtSSWx6HL5y1oe/+sgzAux2n/WS
         V9+HuymXShfxTG6g0Rld6CvLTq+UeKwKYzj8yJP6npUuvxQZGuO0Y2jyuRrKa7t14Eom
         tpaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=p2p.industries; s=google; t=1772208852; x=1772813652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuhUnQIPvmsvPWxX1LkP6je2ZMIaRFoju8evpbHyzk0=;
        b=cSXygthZDMukqUYqbW1epkvNM9ur24HFL8HHvJUhlvpZvrUAe/xGWt60YYgg0kHTNf
         HwGZ4wI0i5bZDgahi4fAO5Qk+Or/b3G7RTt4y43J9d8NZjAXS9Na7S+qKVyGVUMswgup
         xV9AZiqcWJih8jwavc83ZjTmeGpXAv4PmrHhOWE+6GQEfGMmYozqT063kZ6EeaVAzjCO
         2xaSDpEf5BsKejLB1jmXQZ7lrKqKMEeVYcauyh0c+Q/QbQfNhck6P0rh29TuhLB/8Llf
         xFb2M2nCA5BV/2+UOw8CftqSaTUVp4KYefln+Qf0s4kIQqfH4jtS0udEvNwhMFc3O4RW
         uqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772208852; x=1772813652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EuhUnQIPvmsvPWxX1LkP6je2ZMIaRFoju8evpbHyzk0=;
        b=GzhMUi8H1DOArjFCNwE3mufSfR2iNMAOIPIFFqSKefO7Sjb0o68fr7IK6JZUYjF+4C
         E6Ih5h4l70p0UPPdkykZlS9OgoX+Vaie4BnNpRiRTYbfkKbZ5IXYAbptJg1Nte7MwJQq
         dkLdw5Fvzyyao0TXn5yPczarml8c+f4glGwRliaysSYwifTsSpStVK1Sl3lh6KBpSFwE
         ZqhC8VhZR8lGuERHLXImHzKiAqFCkG4MAn2ysRMzYEDe8ERN+kqmktPkkxIq/kC5frV0
         gaa06Ux5GkheT3F4uRPvN6GvbZMIC9L26kup+UJ7dBp0TTP9U2hSjtc38nS1fMIeKTTE
         yAhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsPhGFNqemOFoYAzrzNvudivxIFmEsK3HfddCiNVI6wiId6V0mocwi7hEmVNO5FlehNsSgO7Lc1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqpoCGq6+w79zdkzlvUitCXKc7HShYWvIEwyFA5e1V0qEfXzWi
	65sFEIVugrinS01OwgeiTnIks0J0gZGQw/IapK/qbAnkjGXFmjtEys/JqqYC0DxqiL1xF5Bxz+D
	ZAVyi9cO2tpViVGn9IN91eYBYJ69nvEoymRQfMiYwjg==
X-Gm-Gg: ATEYQzxx5lVU9Lp877YTzd06jyEpwj87Frdn0o7cPfV40M0LjBpY0/lWu5U6051X1MK
	kSJlR5wQiWrGVqGyfTY5L1TT9mPW0KcTaCwMi2jJ9LRIZRUhEBbQeV6VQ6UrTu0mbqoKOcxLZdu
	MOfnat0eIQ8WwYHaAGNcODa4VMciGiTuLar99PetIIQ2H8GJW9Rp0UZak+oAhRGq5ayNqK4Uw2F
	EEoRAF0+kpqLUNa4mIXlGxSGkGPhBVXEA4ALs0aPgOHadCigfEeerK4b4e3v+WnuIJfOPVgxkDb
	6uq72BPkZGaOiNcTirJTzfI+2YoQL3Yyvn5V
X-Received: by 2002:a05:6402:26c9:b0:658:cb40:66ea with SMTP id
 4fb4d7f45d1cf-65fdd6bdd03mr2113947a12.2.1772208851546; Fri, 27 Feb 2026
 08:14:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226220310.758404-1-hannes@stillwind.ai> <ad61f286-5a4b-4ec7-9586-6fbf58e961bd@samba.org>
In-Reply-To: <ad61f286-5a4b-4ec7-9586-6fbf58e961bd@samba.org>
From: Hannes Furmans <hannes@p2p.industries>
Date: Fri, 27 Feb 2026 17:14:00 +0100
X-Gm-Features: AaiRm53mUzGZzviw5KPZ9ftr4jP7IUQSB3MDLETsRCnSmLZSaaOkBXW71eeMBHo
Message-ID: <CAKKrEi2Fv07qR3hTDtfQLQuYNhPqUj=FmMks=OP2bQpRnF=BMw@mail.gmail.com>
Subject: Re: [PATCH] io_uring/net: don't fail linked ops when done_io > 0
To: Stefan Metzmacher <metze@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Hannes Furmans <hannes@stillwind.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[p2p.industries,none];
	R_DKIM_ALLOW(-0.20)[p2p.industries:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12452-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hannes@p2p.industries,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[p2p.industries:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,p2p.industries:dkim]
X-Rspamd-Queue-Id: 23C1D1BAA3F
X-Rspamd-Action: no action

Hi Stefan,

Am 27.02.26 um 14:59 schrieb Stefan Metzmacher:
> That's by design, if a MSG_WAITALL calls fails it means
> not call data the caller expected arrived or were sent.
> When there's a LINK after that the linked operation likely
> relies on all expected data being processed! Otherwise
> the message stream can get out of sync and causes corruption.

You're right =E2=80=94 a short MSG_WAITALL read should sever the IO_LINK
chain. The v1 patch was wrong to guard req_set_fail() on done_io > 0.

> Let's assume I want to send a message header with
> IO_SEND linked with a IO_SPLICE to send the payload.
>
> If IO_SEND returns short the situation needs to be
> recovered by the caller instead of letting the
> IO_SPLICE give more data to the socket.

Agreed, the linked operation expects the complete data.

> So the current behavior is exactly what MSG_WAITALL
> gives you. If you don't want that why are you using it
> at all?

The actual bug is narrower. I traced the root cause with kTLS.

When IORING_OP_RECV is used with MSG_WAITALL on a kTLS socket,
the recv completes successfully (ret >=3D min_ret, full requested
amount received). But kTLS calls put_cmsg(SOL_TLS,
TLS_GET_RECORD_TYPE) for every first record of a recvmsg call
(tls_sw.c:1843). Since io_recv sets up the msghdr with
msg_control=3DNULL and msg_controllen=3D0, put_cmsg sets MSG_CTRUNC.

Then io_recv hits the else-if branch:

    } else if ((flags & MSG_WAITALL) &&
               (msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
        req_set_fail(req);
    }

This sets REQ_F_FAIL on a fully successful recv. The CQE shows
the full byte count, but the linked write gets -ECANCELED.

I confirmed this with ftrace =E2=80=94 the recv completes with
result=3D67108864 (exactly 64MB requested), then
io_uring_fail_link fires immediately after from an io-wq worker.
I also confirmed with a plain recvmsg debug tool that kTLS
returns msg_flags=3D0x88 (MSG_EOR | MSG_CTRUNC) on every call.

Your commit 0031275d119e says "For IORING_OP_RECVMSG we also
check for the MSG_TRUNC and MSG_CTRUNC flags" but the code
applies the check to IORING_OP_RECV as well. MSG_CTRUNC is
meaningful for IORING_OP_RECVMSG (user provides a cmsg buffer).
It's meaningless for IORING_OP_RECV which never has a cmsg
buffer.

I'll send a v2 that only removes MSG_CTRUNC from the io_recv
check.

Thanks,
Hannes

