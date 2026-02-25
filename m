Return-Path: <io-uring+bounces-12407-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOcyLum1nmnwWwQAu9opvQ
	(envelope-from <io-uring+bounces-12407-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 09:42:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 323B7194587
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 09:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C383D303EE87
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 08:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF81280330;
	Wed, 25 Feb 2026 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nv/z5j1F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcbIZZXN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6F311C2A
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008916; cv=pass; b=cLXdHneEzCPwMEtPWInttFJ97f8CaJkSWcxCSZ7m14a5mgOqJOTrfV/Vzf/DxgfvDq2Hkd0WeeJzYNpYe2VdMXmqjIyc3oZevYhv3btsWqqKgl095vLTrPQq4+BuDMaG5G173qnQHAEwU3GbD+7oOuod6+gm5CDcQPZqJ2AfBqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008916; c=relaxed/simple;
	bh=wVVF4M39OF22CFnDgc/z5jD1ft5G9WshuJgs6Fku9AY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kr2tZe3M9zjvF6sSozBf7jydBp+gaJhU6r7/byfVmplZAzeBUo5aG6QKR93HNQaIabxeTurPf1rCXgemTv7cXZVQjfhna7CX4mFFAfAxDpFNKEZuInvRa5m+CFdScVWQPXbGNVQjXgM5C0JSN17KHUtO6aBzx9RLG6SPRgMCH9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nv/z5j1F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcbIZZXN; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772008914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GqJeychEvw+Ibn3A7j/Js2jJAC0aUjfqbjGzdXbGj0U=;
	b=Nv/z5j1FmDy7WKw7AnhZtxbE/d+B7m/YiUR1y1AWaSR1RbH5+uGd0zzE3GGvVvwf34Gv2O
	i8ashFMX7QUQ22SEF2+u7RTkA6kXLAPBeoET5TNi7/IY90rCoHxk1CH/UnmzUAvwXE9JXx
	ohA84g7gIHM49haOwz7feA7r6PGPDHc=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-8GiiOGt0OFqM4jQY85BA7g-1; Wed, 25 Feb 2026 03:41:51 -0500
X-MC-Unique: 8GiiOGt0OFqM4jQY85BA7g-1
X-Mimecast-MFC-AGG-ID: 8GiiOGt0OFqM4jQY85BA7g_1772008911
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5fdf3735e16so6872959137.1
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 00:41:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772008911; cv=none;
        d=google.com; s=arc-20240605;
        b=agY2jRfStrna+sGudZfU8MO+MXYjc/yuz8UZ5sbYfjRK+kCnuTzOXsTzsmkR5Df/ox
         1DlSft/aJH5DJuKN11s4C/wM6watKPbzeQ9ynjq7U5yUOTfbB5EiYzVrYL8bQhLPzxRK
         tWQqO6Ku6jRwM0MPJGqzFCW0V8wClVK4GzNIZ2Ncu/CFoAkcR0+YwELmbeLnFpaYOedF
         VvqVn6gwRFk0koU/+RolNPD0/d5tZZLg9vGxNNIPLxvZstzpMZQzI1cHFWyv4EkNu9gi
         Ubi78lmKAMTpecTX29/rdk/Nf/yaw1IRC0YlwvBepu1TjNLHoR9cLIsU4wUkm5rghZD2
         Fn7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GqJeychEvw+Ibn3A7j/Js2jJAC0aUjfqbjGzdXbGj0U=;
        fh=GerZlkXbE4evd5GXoEkVo5AGpoD6iPp8H0u9+8lNxQ4=;
        b=kMDzjgUm8s3yihpDUXyZshHwmNZmqWr8uV57S4FO2X7ga5P9Co5q4vDrDDQNR8N8a7
         EDtSrmAz8EjTojvLC+shH0zFkHAbd16/s0kdEY8YE+1qpwEp2Tgw+AxIp+PRIxIBPmMo
         dHeUeLoNB0NVGoLUB6wctF82MgRd0lYD9Ai1Y0FBKYlkWef5tVflKhBtcRTLFqUDOYsi
         QvDfLjiiznz6JRUREUy+GbZasqwku9hTFUxFjOd+psnu+rAYtm8xWi5wr2YNfVBnOPGc
         K0ZErE63p3hGxCmfamz31EUkgZaT2xTKNXw8ZeCeXzQzRnmh1pb58xiWZitHgL4J183K
         uDuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772008911; x=1772613711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqJeychEvw+Ibn3A7j/Js2jJAC0aUjfqbjGzdXbGj0U=;
        b=WcbIZZXNI0llbF3G4MSFw8HB1IYSLylhDLdPglsGJsL1lXscQCoc+POoryeSiJTC4p
         Por8nHjh7/H2iK2cEXpTCD5TTLTcC7vTVD8a/gx0FOQ4CdS/v8Fnenym83MGcFL1drGQ
         y0vPk/F/pkifkRd3bHv3ucpYGl2H0ZskpEkc5gJfzCODa3V+2iJPWuXbMx2gKwFjOgNr
         bklsye0+l4GxzEVHRsAV2deFm3e6tedn7917ahyJGB9PbcCgabQZyRzRKz6lEPdASMqw
         MbDjijGsIF6CkfvisUr2hmjg338GKzsGHJWUEIBOS3gsjVo6RR1M4kP1F4vYcpVEJt9K
         V6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008911; x=1772613711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GqJeychEvw+Ibn3A7j/Js2jJAC0aUjfqbjGzdXbGj0U=;
        b=cAd2BT53tQlp4d3v4gj1g5Q2hjMpvfTY65DKoF15qoC6MiXWGkEbzuLnq+bGGpWOgi
         iyj4BZLqcNPlfWTvCcCbz209AoXM3wnC056OZRMG0L43nAvD8ZOOLxfv0BraFnNS+ZAY
         +Odgub/wuJJWWQLkP/1m2Oq6u3cPzU2dk8lV1zi2djvy3cCdGqMs8bRqujTYJwIVCnNI
         ynn9gmQZvOl3B8V08f3rNPV1hi0r/VtH7Dr2aLc4sfqRQRA6wZPQa7b4FF5vVd7VT849
         QRgIQIeI7/cFNbcVq7iY+wf62hKnKdheAR10UIYs3tCSOw3lHpOXGDOhTBo/iUZhYyV/
         3LLA==
X-Forwarded-Encrypted: i=1; AJvYcCUdhuX7YR3rwsrqbJJ4JOEkNURVT9B8SttKYpxxDoPw3wT489lgMbmMIELUJSWgl5FzmtwpeBft2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvsWJu1zBDnH4XLL6TFYKCklEeSUSpFr03PJ8TbfbPJZQWghL9
	LRvPEKkLfcJVWoH+slb+oDNdLf1lRTMRBp8MW9VlL0EYDfDlXX0GImtA25vrVs9yD/gzmZsfxf2
	HxFqsoznFY9t5xlETkmnFswZzw9jVQ5IjV37Xen7kQeK69lQuPLQSnRG5G0zAlcO5NUKK8Jg9SY
	z0DcrDree0VgxPtiWvwybScF3r8X/YUUWuiZOAqpviyu4FKg==
X-Gm-Gg: ATEYQzyEcWfYCH2fZh0UaLZQtWdyhjMrv8Um/+xsZvYA1xjzXP0qEFj62S8Uc1izYAz
	Af9yeYN5lwk0C7uiOtGSQQKiM54IVE8xFYX+eu9xKoN1ZLMX7N1zXXW6/cgu7VK4HVop82bM5I1
	CBpUAsaHaULxbjXzPhDWvbFqcnDBZhYrJXUT2ww527HB7nh0XH+sFienBeGWVroJlP/S55CAigD
	aCXtys=
X-Received: by 2002:a05:6102:5487:b0:5f5:3a9a:7db0 with SMTP id ada2fe7eead31-5ff063b0789mr551587137.41.1772008911105;
        Wed, 25 Feb 2026 00:41:51 -0800 (PST)
X-Received: by 2002:a05:6102:5487:b0:5f5:3a9a:7db0 with SMTP id
 ada2fe7eead31-5ff063b0789mr551578137.41.1772008910672; Wed, 25 Feb 2026
 00:41:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771327059.git.asml.silence@gmail.com> <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
 <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com> <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
 <591a7f0e-7b78-42f1-9486-163249f5e306@gmail.com> <CACVXFVPx5AcC9y9xVPCaahDeumNGm4TSkkfhsJ8w+wmW52JQ4w@mail.gmail.com>
 <ed7b85d0-38d0-413c-a28a-f3b0d1a72a13@gmail.com>
In-Reply-To: <ed7b85d0-38d0-413c-a28a-f3b0d1a72a13@gmail.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 25 Feb 2026 16:41:38 +0800
X-Gm-Features: AaiRm50Lx0aBOKCi5jnRjGuV36AuW0E3_hU5uBR8m0P2oxYndDd8egjED4cAIfE
Message-ID: <CAFj5m9L_WPH_du4GMVYGBdYA_NX1kbGtJpAP0hbfuEjuk5faZw@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, io-uring <io-uring@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Xiao Ni <xni@redhat.com>, 
	Caleb Sander Mateos <csander@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk,redhat.com,purestorage.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12407-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 323B7194587
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 12:30=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 2/23/26 15:23, Ming Lei wrote:
> > On Sat, Feb 21, 2026 at 6:35=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>
> >> On 2/20/26 17:45, Alexei Starovoitov wrote:
> >>> On Fri, Feb 20, 2026 at 3:41=E2=80=AFAM Pavel Begunkov <asml.silence@=
gmail.com> wrote:
> >>>>
> >>>> I had such examples, but selftests is not the best place for that.
> >>>> It can use abstractions, and I want to make them reusable instead
> >>>> of people copy-pasting from selftests.
> >>>
> >>> Sure, but please still post them as extra patches so it's easier
> >>> to see what's the end result.
> >>>
> >>> Also please reply to that thread:
> >>> https://lore.kernel.org/bpf/CALTww28QMg=3DYXqKWpWLZrLO+xiqOe3LGyput8d=
x68-dnQsxg=3Dg@mail.gmail.com/
> >>>
> >>> It's not clear to me whether your io_uring+bpf setup will work
> >>> for Xiao's use case.
> >>> I don't think we need 2 ways of doing it.
> >>
> >> We discussed this with Ming on the list before, that's one of the use
> >> cases I target as well, there is no reason why it shouldn't work. The
> >> difference is that this approach gives a flexible framework for
> >> extensibility and covers a good bunch of other needs, which is exactly
> >> the reason I moved from a BPF opcode approach, while Ming's proposal i=
s
> >> more specific but argued to be a way easier to plug into ublk servers.
> >> If you ask me, we need a solution that covers a broader spectrum of
> >> use cases, but I guess it all can be argued in either way.
> >
> > One big drawback of  Pavel's approach is that it needs a totally
> > different userspace
> > implementation for using BPF, which is just hard to use in existing
> > io_uring applications.
>
> Not really, it depends on how you write it. If you need to rewrite CQ

I meant SQE has to be allocated & built in bpf prog, then it is inevitable
to move application logic into bpf prog.

If the logic is complicated, it is one big thing.

raid5 is a great example with complicated fast io code path, I'd suggest so=
meone
or Xiao or Caleb, try it. Compare your approach to the bpf opcode and draw
some useful conclusions.  Code should be more convincing.

For bpf opcode approach I believe Xiao has already built an example.


Thanks,
Ming


