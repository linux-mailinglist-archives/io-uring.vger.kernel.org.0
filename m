Return-Path: <io-uring+bounces-12356-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAUXC0+emGmWKAMAu9opvQ
	(envelope-from <io-uring+bounces-12356-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 18:47:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A9C169D51
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 18:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EC807300407F
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 17:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20C42FD69F;
	Fri, 20 Feb 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NEKHxRpc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC8035957
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771609672; cv=pass; b=DX3KyGRtVF9GD1R4KQEfaODKzFaQOd/EVIOVMx5ZGEoPinBH3vZILNXC5QNNZJSotvKtIdt97NjMkoM9zdwwr33iuMQ9zMyTmAJCmlvAx8+zPxu59DyHYzoUnnegp1HxJnTe9qxRWaX/Ja4p5kjsc17xUkq5EN8W5wYfzrTL5TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771609672; c=relaxed/simple;
	bh=Y9eb+2i/y/0rmFF/uI6d9CeWg5pAv5OelEQTpGFPeJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KWksgcaqOwMKGm7YhLsV8j75a7dGdDvADSiQf3RmDxmXyhShB1jtQWN6SPkWA7SXpQWja+IdAvKvde+qpfbXgOeju1xz+7RcbbSSj0lEl2DEi05luKWTSLLVX0HMKlz4l/L3cTzr/RsB+jU3MU+CVAY6HSWzQkxcdsJSCjke9+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NEKHxRpc; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65a18bc4b1dso353457a12.3
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 09:47:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771609669; cv=none;
        d=google.com; s=arc-20240605;
        b=Y9ctDcZt0VutnvY3xAVEvDQ3TR5pAI+r1acYGBcED0MuKz95F+7o2bpC/nZsOzvg9F
         XcXFScNIFH1YUtv6v+5uK3+IW1VLK8HysPnY6Fk+7zAMFsHObWCtNk7TP1FeCdNEPjuR
         qpAkWH0ctHqugM7x/7wUNgOWAm2yahAPbAdVJuvHiruUzYU5ascoSflrdDC93xb35uAt
         jGkoZ0jeL1pcEnbWcbwJt3DDEvP1DQZOLDtuYX4922BNpGOuNG7glXXGE7oruigXK1Nm
         IGZxaYXta4uz7Q5r3R8/FkAPwmsVztPvPt6xYmojKCZ7cl6OxsS7yCAewiMI+cf0wu2p
         5Gbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y9eb+2i/y/0rmFF/uI6d9CeWg5pAv5OelEQTpGFPeJM=;
        fh=2KLrhX83hifvDkGXDHtD266+iOEzkW84A8aDYKv7rYk=;
        b=XunZABTN5jCNC+0EBBHzoxieJZxAFlypANBlqjZOEMbtuc3wsugNZPP0fMk2LDn3J2
         C3UIS2y8O6XimbaX+0hA++6EMrXN+UcwjFxZTp6sQ5vmVZxgSlfdbpOTZmr6XRCfPyhc
         xdiym61eYGOPE9hP7+EpU2K4SCql/8kfywMvILW416gtQtrM2NeeYkh8B0HHZhYTKoc4
         3vvhg6+TjrO/Z4TElZd6hDRhCIeehLWuVcqpYLb9qRf4r7ym369LlMRHXr3ewxtgqerS
         zGjVQQoHP/15YYEzQk8oSCcpI3PBt3pAOwgRwY1RchL6WBx6IvcEI6nNFnbj/006LE6l
         B57Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771609669; x=1772214469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9eb+2i/y/0rmFF/uI6d9CeWg5pAv5OelEQTpGFPeJM=;
        b=NEKHxRpczgU+UDLJmX0ntPHBwYzm0siD/hI6t/J7X6JtEqRvkKNYAAqpwn5v8KZ7pd
         o3nX29cz8o4ANlf3krvPhEFv8XMfl72WXpRyl09MDyavzJ9lFPm4pYsLDLT/0e6IZiuw
         +1bxnFi/nyhexA+2wu2eWBlE8f9wPIjK+HS+raQFIOi+3W5uBNxqT7D1W9Je9/wc2iOf
         AiDEU1g+TcmPJnpJrOKbjhvgWSFUu4duR/qoL3GotfQqSp9mTn/hks+wU5Cb/l6PCcu9
         u/wAIqcSmcxNt1uVtg8MHhrM/SzILZJFdOIzoBOJHfqtgyiyqSKBBx8/FLrRYKTH//md
         pYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771609669; x=1772214469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y9eb+2i/y/0rmFF/uI6d9CeWg5pAv5OelEQTpGFPeJM=;
        b=JDgrm8WeK9JiKAMUOl4+KG/gjEqyh7GFaQs2Hcwsrcw+wFYxl+uHsBAYHBBvSBGfRR
         G2hQYmRnTWp8KEP7jbkPrDZSOsKbioV32gYJAFM4fSQZvXGmYHGpJmwl0TLCM4n1KgM+
         6rAX+dwWRwtSmBi5Ovs0bnmE0oM62lV9ZDpZX+/Q20OEXuK9YtNy0TlfiGcyj1N3ZfAB
         nIKWjy8eelki288AoJdz3ozX6tLOCKcXwfBb3fYELZJd15QsW+KTA9SV5cdqvTj5Z/Cn
         c+QXTu/9b7i4/iPfw0Vjgn9w4NVfNzjC+PmhHLDg4nBNEtLH0HMa0Jt5Be7mV/iC6Xfu
         3BbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT186cy87bc0a0reBxCPGKOHP35lJTazPA36Mwfvcn9HQYMC0LqjomAY/k/JT5vRGZar3KvT4dhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLiAu4r0689IB+3Iw9c3t2Pvm9RGJU14bW5G58qOO/If6O2AXa
	iwsHxQt5ukYnD6qqyJJ+x3ZI+kDAGEM3dQNgOf6CGMVoSkzwrLg2jYLAH91gdPPG9Ik4WK23rwI
	IgRL8+LzTivgEuA+BR8q5WCSdjC63Uo7lSa/oLT+mCQ==
X-Gm-Gg: AZuq6aLky/n3Hqd7iTpgYle7qqmnQIn36B6HncUGMGBT60RhOkYtQdXWNaboyF4JOj/
	rLCftUYuUL2tQnPiv6xXxzdqdGSB+PiNxvqyIkgjNZ0YuKsMgR7YhbAsi5muPEOpPfeGMZ8vXpr
	jM/2wnYWVi/xTIhBphKi/nwt/jvvRmYRvKDDNgnlpHkvrAcQOAYBZOza6kWUl1jEMr4TpJjHdG/
	g1ZNXd49C33gjb437hVQ0MshNXk0I1LO+HulnK5DVqgpZcSoiqDEgg8gKinD6J0EdHVtxf57TnV
	+1//G3b2rXPNQjgRQR0=
X-Received: by 2002:a05:6402:518b:b0:659:7edb:17b4 with SMTP id
 4fb4d7f45d1cf-65ea4f288eamr132202a12.5.1771609669372; Fri, 20 Feb 2026
 09:47:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219172228.429479-1-csander@purestorage.com>
 <aZhuwOku9lFe33UM@fedora> <CADUfDZr3ksmd=ZZOhU4RJsqEzbxBHnDPCtOQXJ5ft=X7irWvPQ@mail.gmail.com>
 <aZiHlp8nOPgQFGMq@fedora> <CADUfDZoxW0m4nptfNYqmqFCdTj6zSaYOk1vYSKU5JztkjEjD=g@mail.gmail.com>
 <aZiMS9EZrOqEBhQL@fedora>
In-Reply-To: <aZiMS9EZrOqEBhQL@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 20 Feb 2026 09:47:38 -0800
X-Gm-Features: AaiRm53s86E4gHXC0k34rdUE13VMMBnLURvZ1nvvNYQnBupQcBAWT-zzyK13aNY
Message-ID: <CADUfDZoRFRzXd4c=qu+7i5nTqFi1BfC4DvaDXA1neov591ps3w@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>, 
	Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,lst.de,kernel.org,grimberg.me,vger.kernel.org,lists.infradead.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-12356-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,purestorage.com:dkim]
X-Rspamd-Queue-Id: D3A9C169D51
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 8:31=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Fri, Feb 20, 2026 at 08:22:29AM -0800, Caleb Sander Mateos wrote:
> > On Fri, Feb 20, 2026 at 8:11=E2=80=AFAM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > On Fri, Feb 20, 2026 at 07:55:33AM -0800, Caleb Sander Mateos wrote:
> > > > On Fri, Feb 20, 2026 at 6:25=E2=80=AFAM Ming Lei <ming.lei@redhat.c=
om> wrote:
> > > > >
> > > > > On Thu, Feb 19, 2026 at 10:22:23AM -0700, Caleb Sander Mateos wro=
te:
> > > > > > Currently, creating an io_uring with IORING_SETUP_IOPOLL requir=
es all
> > > > > > requests issued to it to support iopoll. This prevents, for exa=
mple,
> > > > > > using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> > > > > > zero-copy buffer registrations are performed using a uring_cmd.=
 There's
> > > > > > no technical reason why these non-iopoll uring_cmds can't be su=
pported.
> > > > > > They will either complete synchronously or via an external mech=
anism
> > > > > > that calls io_uring_cmd_done(), so they don't need to be polled=
.
> > > > >
> > > > > For sync uring command, it is fine to support for IOPOLL.
> > > > >
> > > > > However, there are async uring command, which may be completed in=
 irq
> > > > > context, or in multishot way, at least the later isn't supported =
in
> > > > > io_do_iopoll() yet.
> > > >
> > > > Can you describe the issues you envision in more detail?
> > >
> > > Basically IOPOLL doesn't support multishot request yet.
> > >
> > > For example, when io_uring_mshot_cmd_post_cqe() is called and new cqe=
 is
> > > queued, it can't be found from io_iopoll_check()<-io_uring_enter(IORI=
NG_ENTER_GETEVENTS).
> >
> > I don't think that's a new issue, though. You're right that
> > io_uring_mshot_cmd_post_cqe() assumes a non-REQ_F_IOPOLL request, so
> > it's up to the ->uring_cmd() implementation to ensure that (which ublk
> > already does). Since ublk's struct file_operations don't provide
> > ->uring_cmd_iopoll(), any ublk uring_cmds issued to an
> > IORING_SETUP_IOPOLL io_uring won't have REQ_F_IOPOLL set, so
> > io_uring_mshot_cmd_post_cqe() should work just fine.
>
> Please look in the following way:
>
> 1) without patch of `io_uring/uring_cmd: allow non-iopoll cmds with IORIN=
G_SETUP_IOPOLL`,
> multishot command submission can't succeed
>
> 2) with patch of "io_uring/uring_cmd: allow non-iopoll cmds with IORING_S=
ETUP_IOPOLL", people
> may see hang forever in io_uring_enter() if multishot command is submitte=
d
> in context IORING_SETUP_IOPOLL.

Okay, I see what you mean. If ctx->iopoll_list is nonempty and a
non-REQ_F_IOPOLL request posts a completion without going through task
work, io_iopoll_check() won't check for CQEs already posted outside of
iopoll. I think it should be simple enough to check for CQEs
unconditionally in the io_iopoll_check() loop.

Thanks,
Caleb

