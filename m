Return-Path: <io-uring+bounces-12351-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELupOjCEmGnKJQMAu9opvQ
	(envelope-from <io-uring+bounces-12351-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 16:56:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F9F1691AA
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 16:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36FA2304D1C8
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 15:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D917534E75D;
	Fri, 20 Feb 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="K/tThXO7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635D275B03
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771602947; cv=pass; b=GOCuR7OylZz+KCYBqn7UuQP3EyTXZuVVyOtLAHH/p5o1UzoKwk4Upy/LUChSg8+bBcQPeIM6pLv6G3xFEyNXiMR0r36gDFcS2Ma5epY6/aVqYGY2XlMeAcabRMzFaWme+HyjALBpAJZCvZyPWc2N8QPacSoE4PfdfIeKCNHIvg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771602947; c=relaxed/simple;
	bh=dLDcj/2tl6eJ1rtbmAcD53HOSalhKLNKFMA/3qFufx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FgUahXsKNcCkl/EthEUvDlcWV4cPIKcIW9jZ4pc3E9CAecSsUJPsFwq2/KmHuDL7lO56jPVQkvKkHbNEdLvXfMQyLVeIx65V9Ver8PC082Vq9Eb8/A0QIAJjxF8qwV6EYloZq4kF60enncgnOK8lA8Fzmz44d4CY6gaGbd07OZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=K/tThXO7; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65c1d6c2459so327162a12.0
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 07:55:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771602945; cv=none;
        d=google.com; s=arc-20240605;
        b=ZMp2rS33ZEOdFTVHQyWIOfEY87TBwMm6Au1Aeb6BODq3igYd621ClmnrIkUMTlT3+W
         GET1nKqP1VtJsgFXgW1BiYXzNmhbFxO5v7lr7IDkdv+/X9UU+mLaIlxPlutesA6PK3BG
         /WFU8F4p9sx91hoRl/xxIZk1D2CQXWOaIbvEcAzr2qVUZK8sNNtfqvYxJ44npv6hpcwD
         P08SLW7mqXKK7FZP8n5a3Q7fcj8hG8bOVPj0HPafIsQcHdS3LepYXagzmy1m8KG7mc78
         LfFj++zkTjTCG49Hi3as2oWm7D11dfk8AACVSXPCI4ryHpa5324w1BBu7Qx1A9SGrL+j
         YixQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dLDcj/2tl6eJ1rtbmAcD53HOSalhKLNKFMA/3qFufx8=;
        fh=rOipEAWLnEeMZacxQbZ6nGmCA0ayS5LZGmO/E1BOLc8=;
        b=UmVGObF4IAXnGx56xrtQ2DOnUXIm5IF5+kxrPN4pVApe7cGp0/6p/wzAYsMlRH3T44
         ng9oSRzNZIKlz5h/U6W1iSdBUD6kLY1cubMPJuF8AsvfpMzyZy2oOHQ114h5CZ7IqmzS
         hB3/KTIWqfWuf2/Qe8NdRlQun6ojXbnz1yYO/1LIqbEXHTQkSr1q7a2KbRUk7Fmjtj5F
         of+jlrWTzzFABI8cBhSflK21VS5PdW3kkp0Y+heZdGXLbY1ev4RnB4MlNj+CqGIAOFp7
         z08NZnPVmN6pt+fqO5k6VMbKc0lNd1eqGMdXg0jFVTilutwmf5PSki1W/upkQQ0auQBe
         SrMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771602945; x=1772207745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLDcj/2tl6eJ1rtbmAcD53HOSalhKLNKFMA/3qFufx8=;
        b=K/tThXO7RxNEWVNNuJohbQfgINL7EGpNG8IHOHCirzS6PkOJlgTFLDw7YRewqm62Ic
         cVKsGqC3QMUs9bGkg2GcZfY4LLC0USblPCMhQkf5DOIzrQCtyan3d/vGU8PpoIjFtzzP
         VkqeYP1JmD0P0VMKNYa+/OoOPE00tQPWm1CyfWsVRm3FhboVYIzHLUfj/NovDybAaypE
         aoTfiIRl/8hefnMuNQiZGzl2ElIOfgPZ1f6+Zm1Y2L6SGpQvAGBlde+2ANWgZQ4Rt9KW
         SyJTH7tz+u9WcnCz95c6rNOsUlOmJLtPjlPjw0CvJpy+lyRtuYyzNbengo4YEsSqnfVy
         cNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771602945; x=1772207745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dLDcj/2tl6eJ1rtbmAcD53HOSalhKLNKFMA/3qFufx8=;
        b=b2yZyH5yC0zHy/Ucq6kIEvG7R9VbqPu0vncHNCIUOn43ZBumc8R0vzhYyaHHvFa5RO
         0nYeaKQqr1CXrv/B+inmsyEwWnvlb4R5/K56n0szXgzAJ1OS74rP4HNvlLuuXFyjI8S4
         IfR9ZT3MFAqgy6JXaznrkOPrl7JaXw/leFCjQNl1gssLdeaJeUFqi9+A+rMeAq6+vLjH
         I6MNLHRJE1puQQQvvN9t9KoZCvJrpmThWl/shClN6u1b1/QCosxF6oZuL0wPT+NdTdm5
         e4o0MuJUvunPW6t7FyPySgSKzHwfSAhk8ogos2HDsmBtHX08hqvSN+nlN6XC7T6YzmvE
         C89Q==
X-Forwarded-Encrypted: i=1; AJvYcCVeiK8wpZWDc7NM76558vk2HuzdNDzkXPBCc485NY6USUWjdoooOjxGgb18mBQGr1k4kTWckzF8Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAO2w8C8xt6f6c5DzgHWZSJnCJ7ygrWRe7+usp00LJ9FRLDa9/
	hQQDPKtJVpg9EC/ZZHuPCxS2bkvIAzuBMbafGGU5d/RYopCYaxRJIRRKo5yelIm6DuUDJjh4HXo
	rFmFoIPooe8fp9lzvUoBcLCdYEcmg55hzyzHHXFuBuA==
X-Gm-Gg: AZuq6aJ7v7Tz6vAypOpIDpKttcSFjUGlMt5RMQbTZPMjCL1hOpoPQqKRsQKIrmybIaK
	oicXqg5vz7mLXlYp1k5FRHwly10cFPsI4Tu1OzLoRYF7dEAiFMBoKYdUGaJ5nruHw+Aw2ev2awf
	3V/rlw11k3k/nLZFGONM/AfqzPeg22zHcRu8eHchdQcMYxjIAp82mJAtFBo8vykIOL9FOitbRtL
	jXG4b7bxCrX3YhRtLsgUdzJ8KPPXEQDpA1kozc856bJtN2ncxTuz/rTJMUQ4batxgzP+ERNLgHc
	63CfhagC
X-Received: by 2002:a05:6402:50d0:b0:65c:37a2:e4a1 with SMTP id
 4fb4d7f45d1cf-65ea4f1cf0fmr14335a12.4.1771602944840; Fri, 20 Feb 2026
 07:55:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219172228.429479-1-csander@purestorage.com> <aZhuwOku9lFe33UM@fedora>
In-Reply-To: <aZhuwOku9lFe33UM@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 20 Feb 2026 07:55:33 -0800
X-Gm-Features: AaiRm51MVVjjjGK3SmCWXzLeh33JdwAmlc7hUGmZViVX5bC_jsF58uq-g-XjQ_g
Message-ID: <CADUfDZr3ksmd=ZZOhU4RJsqEzbxBHnDPCtOQXJ5ft=X7irWvPQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,lst.de,kernel.org,grimberg.me,vger.kernel.org,lists.infradead.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-12351-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 80F9F1691AA
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 6:25=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Thu, Feb 19, 2026 at 10:22:23AM -0700, Caleb Sander Mateos wrote:
> > Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> > requests issued to it to support iopoll. This prevents, for example,
> > using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> > zero-copy buffer registrations are performed using a uring_cmd. There's
> > no technical reason why these non-iopoll uring_cmds can't be supported.
> > They will either complete synchronously or via an external mechanism
> > that calls io_uring_cmd_done(), so they don't need to be polled.
>
> For sync uring command, it is fine to support for IOPOLL.
>
> However, there are async uring command, which may be completed in irq
> context, or in multishot way, at least the later isn't supported in
> io_do_iopoll() yet.

Can you describe the issues you envision in more detail?

io_uring_cmd_done() can already be called in irq context. Even if the
request is not REQ_F_IOPOLL, any completion from irq context must call
io_uring_cmd_done() with IO_URING_F_UNLOCKED because an interrupt
handler can't acquire a mutex. That means the completion will be via
task work. The mutex acquisition in io_uring_cmd_del_cancelable()
would be a problem in irq context, so ->uring_cmd() implementations
that use io_uring_cmd_mark_cancelable() will have to call
io_uring_cmd_done() from task context, which both ublk and fuse
already do.

I missed that the SOCKET_URING_OP_TX_TIMESTAMP uring_cmd may use
apoll, so that one will probably have to be prohibited on
IORING_SETUP_IOPOLL io_urings.

Best,
Caleb

