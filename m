Return-Path: <io-uring+bounces-12737-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SG2hCDL2uWnnPwIAu9opvQ
	(envelope-from <io-uring+bounces-12737-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 01:47:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 651782B4B11
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 01:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD55C3096ED2
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 00:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7987019CC28;
	Wed, 18 Mar 2026 00:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ExNgbjHz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BCF288D2
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773794843; cv=pass; b=BuE6EFQpnQuEORSzPk2lsoDG7z/FmUyhdXBd9OUpGQumAgYVIA4ksJpoZRpb8EpKnXtkWn6M95Yf1vNkKS66RJKXjpcyRUlUStymOKxaZdrJhjGjVT6BSA2vXNY9ZCD+nYRbvIHARHCa6QjCrQrNlB7DX3cBZ3Sk1ALJHLXljcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773794843; c=relaxed/simple;
	bh=a0Tx2z8UvkbAUvJg+i+g3WbtJXoGw+tuT11Txazk2lM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JumIm7l30WmRfdF2SM6RjFFSwYn3Ff2gl8RDYtRSDZyjPNr7+i8mTHE5ldfmZGx4rHty5QL02az5wTAdzUhUBhnu46iN4bhCa+u/0ljCNgZb0wNlvBKWPhRAvx4qvkWFDevucTvHa0tzx5WB72ahJuOtjEEu5y26Xv32alc1mNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ExNgbjHz; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4172269edceso298283fac.3
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 17:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773794841; cv=none;
        d=google.com; s=arc-20240605;
        b=KmlNjAffdwbvWVaUeiItuwRtGP0MLLpcu3cLEz1LgpgduTngnxaznGf21MsCnxemss
         Sotgwmafxa7CA8UnJKSou4sGK2xic6/vUcAsFU2HqimKOfbUAd4jZQZYS4jSmI+vTD4R
         AoH8OqPayUi4ZVga1Amvi3kNNQWwcPstH/ogvAyaUqHe6PKNkmOViZ9R7UAWb6P6lRGt
         sRXEKGQXiy7GIrqEPHRBXiQU4iDvYyg8GTkVgV/7BsoScmDwRbWf0LBfaHRWbUFGAQka
         DJMPwnovf00MQYJ/ULKvXQ2FNbklSOsUe6a/vaXF2GMl+vrpLwJYeg3f3sLdSfbWD+oG
         0Siw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zyk4gA0DbxFLS3vhGRrLRfM6spOnrF/9lDtrQsrBl/g=;
        fh=WioMRdy7svrohcKIZZaeDEw1JncSACcAZm9b96neOCk=;
        b=jY+vBCn3f+9By82yL71jIwr8WfANu8BF6JBwFyKDQ31wude1pGObjhRLJt4oGe/JZ1
         32CrRaKVSNN6FkeqZUIyPMLAQ941Lsity87R5oVkJVlgTyjqVMekjahZ3lMl9TaZ/cU3
         C7STLLPrwrrLC7ehygZXHCWkebTVHO/8BxapKrEIghY7UVmTa4Qd3XKU+bvd+5vINDeN
         +3maIe3DYjVEndYoqXj4zrW8cbjexXQuRyOkAiExMIXs/qp+phYxZ0W0NyK/lBPKRBn+
         +NGOPC0d5eWhIF0MwVCQJlEJeD9PQjonk+wdpUc+nZgn2S9Ib/sLrLDXnLeLD2BTPkyI
         ZRVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773794841; x=1774399641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyk4gA0DbxFLS3vhGRrLRfM6spOnrF/9lDtrQsrBl/g=;
        b=ExNgbjHz57KJc1gCijKMVF8ueaIpOTIof0NyPL/j+GUjC2k1s+U2L00yQ/UvwfdggP
         OnV5bkj5p+mgKMuVULOtTRB+4/URG1194eAYcQHllAkVf2pDyJMEooJd2zowoCx0OxPv
         NSQD8CR9x8mxQ7G6eIasnP5NPIzQoE6jZPwEb6fujQyCbxMSZP9rbKTFai88+YMlNA6z
         79taEbsgM+otBveC4x3DAMa8Tu/YKFZ+n+EQ+sfaCBrTMdN28FVZ6ShLTqpZD7Ds+nXd
         JGIo2Q6Oxqr+GlVA2E4/I9Nrw9LxJq6fPhLDuLUn2b5oyU/aZ4AbFmvUKfIwHZ/t3tvY
         +T4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773794841; x=1774399641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zyk4gA0DbxFLS3vhGRrLRfM6spOnrF/9lDtrQsrBl/g=;
        b=qR7D9Qu2Hkt0ExmBGBKqnJLovlD64FlrgzDean5zPa/2IV7HssfUG4PWXO920B/t4y
         sK0bEz5MRW+OQzpwJYl7zi+y+HEsv16i9e7JuQeO2ULN6LpdTAImB32mvelgN29Y7iRS
         ff1h0hBe8kQs9NDh+wGnN5yH9P1za5FyEZcxrpE0b25v9UgTwR37/aRcbfQPbY899m9h
         coce90rruTKz+cBBNXuD+h4F+YA/4Ef8vlVPtPPTzK/JEVgZKv3RJB7Q87Dwu5bEarqG
         A2OVS5is7024ACm1HUHMRyWq+LL/rnvP7JSVPpbRuiQorSeGGKUXR17OjTRuRgWdhUFn
         gFXg==
X-Forwarded-Encrypted: i=1; AJvYcCW3crQQTF6asRGhnYA4GY/i0ib54wS9mlUcwDSJASU1O6Q7F/FSanxWDRWeic1R1TyLY8PkHDoGDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxcKUVLMQJKBnbpNZg7GY8+cWEgI4Qv22MSnT9RQPDBLh8xKK1
	+GXaASHB5xxJmDBdzWajOba3wqLL4sJTul4Ohj2JtBqbRsoSsg/cnroGrN3hIFKxBT6Px2hyPTT
	5jXs+1VvtfayxeVpm9Tdbx3JHtnY0kI8U5DQ/ZzQuuBph54x7mKtgc5g=
X-Gm-Gg: ATEYQzwvO0jhkk+2y+1tFfqju6ux/tohmfmDEpXyaKUrDdyxmuhxKyLxZg/uBUZwi44
	5DdyAf3QmZu2RHfVHQStZMNQbPj07r/wcrexsVZgMDb3VqSo4hRN33WOXvHZH9p/E8rLViaDyko
	GL70gxlQmET7ZRaocZHccBnksRS4bhmpjoAv3OWZxicLrsXT0hBU1rrk8nqPc5tMgRfM96+Hmbi
	FfyA78+LjFfcMEf18v7XV71qPcdJNibks7Qamz89AyWQTd3s7tRzlZTeyB4xcMU3p9lhoZWMyhk
	aMWHsFSd
X-Received: by 2002:a05:6830:438b:b0:7d7:664c:7114 with SMTP id
 46e09a7af769-7d7ca6776f6mr1004746a34.4.1773794840750; Tue, 17 Mar 2026
 17:47:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302172914.2488599-1-csander@purestorage.com>
 <177369928494.700746.8101380068186003544.b4-ty@kernel.dk> <307e4126-91ed-4ca8-9eb0-3f24f1490aa8@kernel.dk>
In-Reply-To: <307e4126-91ed-4ca8-9eb0-3f24f1490aa8@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 17 Mar 2026 17:47:08 -0700
X-Gm-Features: AaiRm50fXeMnnwNEqTWQp199CEE9NlmeVQCNSmHF--sYgGOecuoeLi0cfofOaFs
Message-ID: <CADUfDZp-Fq4TAdOcvjwSO4G3sZzekzVsyT_yMsoC9D-2=5aLyw@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12737-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 651782B4B11
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 16, 2026 at 6:01=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/16/26 4:14 PM, Jens Axboe wrote:
> >
> > On Mon, 02 Mar 2026 10:29:09 -0700, Caleb Sander Mateos wrote:
> >> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> >> requests issued to it to support iopoll. This prevents, for example,
> >> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> >> zero-copy buffer registrations are performed using a uring_cmd. There'=
s
> >> no technical reason why these non-iopoll uring_cmds can't be supported=
.
> >> They will either complete synchronously or via an external mechanism
> >> that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
> >> io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.
> >>
> >> [...]
> >
> > Applied, thanks!
> >
> > [1/5] io_uring: add REQ_F_IOPOLL
> >       commit: 9165dc4fa969b64c2d4396ee4e1546a719978dd1
> > [2/5] io_uring: remove iopoll_queue from struct io_issue_def
> >       commit: 7995be40deb3ab8b5df7bdf0621f33aa546aefa7
> > [3/5] io_uring: count CQEs in io_iopoll_check()
> >       commit: 3a5e96d47f7ea37fb6adf37882eec1521f8ca75e
> > [4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOL=
L
> >       commit: 23475637b0c47e5028817c9fd4dabe8f7409ca6c
> > [5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
> >       commit: f144dbac4b177cfd026e417ab98da518ff3372cb
>
> Caleb, want to send the liburing tests and documentation updates too?

Sure. What type of file do you recommend using for non-iopoll
uring_cmds? Most of them seem to have relatively specific hardware
(e.g. blkdev_uring_cmd, nvme_dev_uring_cmd) or kernel configuration
(e.g. ublk_ch_uring_cmd, io_mock_cmd) requirements, as well as
requiring elevated permissions. Maybe io_uring_cmd_sock would be the
most general?

Best,
Caleb

