Return-Path: <io-uring+bounces-12147-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id vwL/OjC1i2kGZAAAu9opvQ
	(envelope-from <io-uring+bounces-12147-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 23:46:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 814D311FCD2
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 23:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E842230186AF
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 22:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D58246762;
	Tue, 10 Feb 2026 22:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V28/LLyf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2F2288CB
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 22:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770763567; cv=pass; b=V7GVo2gvgG9LR6+sc4sVlKyHtrujR/NfTSSQolL3HMTIcc19Wi6iN12m1xFqGNui6EMotHVgnj/yMPojf060jagqvHdALy57KYKv6rzW7EuOyuAC4IaFXXVmeZF83Oe///nyf5esZMHixkWadWiYwQoYMOKazhWLiLSIl/KZnFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770763567; c=relaxed/simple;
	bh=12FJbWw4+xBxh+NpvJwBEEYrJ6Qv6Y3miaeedWMKtso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qaexV2x2R0vRa0fxKGagkqMXvezbwMjByFqARgeVFAXgs1JNihni1n5x5GdGFpSFE/2PtGN3f8TEexwmpjkySTrNk2m1zyrnCvFRCiKfYN0/KBVt9EZ7GhVYGE4KUU8w2+O+MCpKekLpVW8Y6IKRfkdLQuOYmcGffF3YX26sIVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V28/LLyf; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-896ff127650so43119636d6.3
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 14:46:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770763564; cv=none;
        d=google.com; s=arc-20240605;
        b=AGOqXQIjUdiIVqCCsm2pg5I4DxoTYeVtzjFdZ6V7hRhLbQXtyoKYylnpxdmmpxIW6g
         izRZV9J8gfjgFdNZdmKeRSEUielB+6Z7g9Yi2PGwtDyLCXbCjMMjYs2ucaa2Yq0bgpVW
         Y0pWIslQ0kDFul6E8q9U3qncTrASauSGKcj592UoBVDDeRbm3txa+G6787TBbj+NoAUL
         8spO7X9g57FcXIen9JV3Dn89wujgyF9aABEWMwaiFyLJoT8O+T7HQudE5xr4kPeTpUlf
         QcOGBOXCYBgDcspzpCsTN8RUI7S5BqnxDWL5W0J4Z8a35X7P2xWv7fIesFH/bjMuqaFU
         O0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=12FJbWw4+xBxh+NpvJwBEEYrJ6Qv6Y3miaeedWMKtso=;
        fh=56w/P7GiZzcuvK19hCUSVBWoC5HcP0TsQFoyF7CkyCI=;
        b=JibPKMihOBm72jm+A/areY4VSl0RK+ao8ThgLN4gWMZUDPlE/LNk5sXFIEWDbjMaiK
         7IkwbWpjNrxBK/MRy16mnpDL5hnS9YFdyZuKd5Q3W0ooswgCG0oOpDdy4sfqKlH5TG8e
         HDXdr6iS3FZra5v7wDMdL1XDq1FdBdzlJ1Ibw3MGyKazjZqhtIOTmtKELtXj18RnrASe
         XVNfbMsr6Ho8YoNgnfLh2T14mLYcD4hBpJ7UmuiGqVU9/mxvi25X5Z7FNC1D1w2zhiHv
         ZdrlZd4dOWcOD9MVGMba9oj9AzbPbFlrETEfH+3m6rAtSL/9gTXsWsv64Psw0um6lhWF
         e9LA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770763564; x=1771368364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12FJbWw4+xBxh+NpvJwBEEYrJ6Qv6Y3miaeedWMKtso=;
        b=V28/LLyfAdXDkp+MEr6u2AoWX+WIPn4RCkpNrNTK19iUovEdUwrQrEZ5Jff8g/E74k
         /2thXm+be0WF36zIWeWADGX4TCgmjmphDKmOoyDfg5vrCS6TfJKahpsmosKsd7b9D1pc
         /Odd88V7GNRhMNjMixmvUdAZ8WQxldMYTHgLiyPhCHtZKiJvRc0g+kz/6y60KttZT1Cm
         IPs1CBSWdPALDi0ctvM54L7MyqxPnOnIlkHnMgBlY+ctOci07ZgpFCwfZZFqLqIDYAH5
         xZaJsKSjKu/cyKL5gc1MDaeCY8nYWCSYyZRtL1Ez0q5GyVTNbmqR9gwz4HR4ytStB7su
         1y8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770763564; x=1771368364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=12FJbWw4+xBxh+NpvJwBEEYrJ6Qv6Y3miaeedWMKtso=;
        b=jm59rd/iiOEJB5rUx9KDv08JQ3C3elMmlTybWedwCWXRvYbbfXh15Q8W2gZtsi++cF
         54GIJBllf97rj8WSSaMfrTlnE68Ygx2qDz4F6UzZbx0DFFf5t+ag3KrVpf0tXSeoQdsR
         TSasZlQcRwTnRjULPLbNdKt6FlqAM713PXo5tUERbhTzXWsEAFEOJ+IyqLeB0p8Ibyti
         IVI6PmSX1Xptj/4kG3rEVyJhiQ4ZyCO2hYMYvKDLokkKvDdZvy6Bi9IB8LAPNDe26k1v
         Ya4GvUFz4r7RBhexE9fTfcpXle1VH4KNJR4DHPVMKgVcjUDWhxgXntndWhVBvdWhIvZE
         XDYw==
X-Gm-Message-State: AOJu0YzDS5lYW7rOMRyPrUcYyqt+6w+OGHV6/S9BFcPV8sAh3C+R2WA2
	JfIEOXG/O1x4N1QT6u3cyHddBbyVMQk7ZPnU/wlOrc5qwdnMJoVK/yagOnfMD2k5nACg8aiIi3Y
	szr5Z4neC7aJ02P5BPNAqx+08nuzvRik=
X-Gm-Gg: AZuq6aJHhuDE3MZ+e+OZ20UoN4o11JyL0yh29t1whSMJyxm57t5j9fpoH1hM6iMN4eV
	JrYDtOdfb7wrQSYAQ5OhTlAOofCLSW+ouGYugJNNYHjZ8OudqnekYcawfieyKeBEp955NCLHeNM
	5ua2F8+Go/5YOqa2jHy/7+ctnLS0q+zSAQW8ykBMJDSGoCebuhxedoQHXpBOsu4uXQmvBjRUy5Z
	IPGwhFPksCsLdWKFiWjJT8+3j7i2nBGBYIfQpiLX4gFCnnUmvOPOv9mi6cN5Ua/gx3tb9l9JJ8t
	FHgbVA==
X-Received: by 2002:ad4:5fc8:0:b0:894:6d0b:502 with SMTP id
 6a1803df08f44-8971b1557d1mr9636906d6.59.1770763563791; Tue, 10 Feb 2026
 14:46:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com> <27cebab8-fb11-4199-a668-25aa259ef3b1@kernel.dk>
In-Reply-To: <27cebab8-fb11-4199-a668-25aa259ef3b1@kernel.dk>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Feb 2026 14:45:53 -0800
X-Gm-Features: AZwV_QjbtlzlBXXRS01qYJcEXXAvXsYwL1evZF8Yasl_STJCiCpqtLwPBpaLCgc
Message-ID: <CAJnrk1ZmZ_EtQXc5BYqzNxV=Mx3q+K_WnbNTNKpOVugHz0q_1g@mail.gmail.com>
Subject: Re: [PATCH v1 00/11] io_uring: add kernel-managed buffer rings
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de, 
	bernd@bsbernd.com, hch@infradead.org, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12147-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 814D311FCD2
X-Rspamd-Action: no action

On Mon, Feb 9, 2026 at 4:55=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/9/26 5:28 PM, Joanne Koong wrote:
> > Currently, io_uring buffer rings require the application to allocate an=
d
> > manage the backing buffers. This series introduces kernel-managed buffe=
r
> > rings, where the kernel allocates and manages the buffers on behalf of
> > the application.
> >
> > This is split out from the fuse over io_uring series in [1], which need=
s the
> > kernel to own and manage buffers shared between the fuse server and the
> > kernel.
> >
> > This series is on top of the for-next branch in Jens' io-uring tree. Th=
e
> > corresponding liburing changes are in [2] and will be submitted after t=
he
> > changes in this patchset are accepted.
>
> Generally looks pretty good - for context, do you have a branch with
> these patches and the users on top too? Makes it a bit easier for cross
> referencing, as some of these really do need an exposed user to make a
> good judgement on the helpers.

Thanks for reviewing the patches. The branch containing the userside
changes on top of these patches is in [1]. I'll make the changes you
pointed out in your other comments as part of v2. Once the discussion
with Pavel is resolved / figured out with the changes he wants for v2,
I'll submit v2.

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commits/fuse_zero_copy/

>
> I know there's the older series, but I'm assuming the latter patches
> changed somewhat too, and it'd be nicer to look at a current set rather
> than go back to the older ones.
>
> --
> Jens Axboe

