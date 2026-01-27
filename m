Return-Path: <io-uring+bounces-11959-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFcOJgBKeWmXwQEAu9opvQ
	(envelope-from <io-uring+bounces-11959-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:28:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F799B643
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F70301544A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 23:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FA42F0C49;
	Tue, 27 Jan 2026 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILsp73sc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97952EE268
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 23:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769556447; cv=pass; b=MkWy0hDeUikKQBfF87HgrM/X+sPcMUcVnTvvjuUwoeo9ipgCe3W+r3MdZqwshb8lEnhekD1slD5XyU4UGhggG1CCPlYPb1m7pyA40LCD4FJzlA+tO5OpT/BRyhPZkmYmaxXt/EHO1rraCjuSAG/8VjZ7VfcPn+zr5Ud885fSUFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769556447; c=relaxed/simple;
	bh=AYwc74eV9qggYhoV9i6/Mg1El1/ghyO+Qal4FOeXrW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mYUY1tqK41EeKSDo2ouB200v+yCi/es1Jcu6sbAE+1snQWGirgSg56ThSxr7wNb4P3EKlpjrSDUl7ZxSvGAPBJZ3fE+XEoXLt7ulwESfgqrz/Ma4Zfy4Di6iCdv5As0SbLeRFoYMMrBwuQGD0n87MinTltn9ExJeYTEmPY3azTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILsp73sc; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88a288811a4so88716096d6.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 15:27:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769556445; cv=none;
        d=google.com; s=arc-20240605;
        b=KYcq7FIocxaFwJQvOxQon7hgoVNelsi/UfUX9W61lzQ8up5uA3YXcTmMXMiSA+P2yq
         SbIlmRv2Z5issI4h35ds+4eQyI5dsuendCuzF+75Rf79+ZwXLv33OQkzzjSNXmeWl00/
         Tk4Ajvjg004eCg6NorSrXWXH4/9ARSCPrWZ7Ugz8vpw638/o5uhLKb1NDlKXYurcfsb5
         3NTOr8zgVcrsDuDYzNTmBQ9fbeCCrjUR1yh89TbTlvLMGsVbeHdfH9d/oHFfWbIOspBR
         Y+DM2A6CoUFnbcuBgRNPgd8IlyXeuydWv996mHBj+kUzgGs8jArej0MCORuvJqLPgFgl
         rf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AYwc74eV9qggYhoV9i6/Mg1El1/ghyO+Qal4FOeXrW4=;
        fh=g9X6hZu7rQbPyiNWXB7EMrrHZ6mPbrDM/Zwzxcqf0Sg=;
        b=iuX3emzpHQV5kwPWKOsfDIjTMXIo91oHpxUUnM7R5ZgUwBXLkaI9g0LydCDEIDhGCj
         jp83dTElHSQkIqnhGery1HRLtpQCfNNQ4CSykBPYcb5Jg/sgQxH/GNmgRUDIp8Cc5pGK
         RxG42Zmrsg/Odc/YQ5abFi6Gwq6sJMGeXQcKWzcPt1wN2gZgMPVbRSvDSXYWHm07RSK6
         gLxhKn5S4daa8X+ilYQULWgxLHkaTsJG218QlWeWUcfySyomNB5Cjh6HvmfFZKOKqf9K
         Wsg2r2h3SsERTG+5MZG+DojfdueurIA3VHCg0s1QC5+FMJYXxow+kfN+lKfcCi2gc38y
         c73g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769556445; x=1770161245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYwc74eV9qggYhoV9i6/Mg1El1/ghyO+Qal4FOeXrW4=;
        b=ILsp73sckJWIKLaB56qHS+caMM2i40L2uVCjvwMMgVkAqYXMtdrPqNiyY2QTYuJwom
         d3pyx75OtB7RJvNrciX2j43PKVqh71QJDB5JakLr+SKUPno7bM85XR2QEje7p0ZR2u7K
         ktF4yN1oj1/tFAm7//jZEo3cpzlni1/FikBVfzeLdv+PAetLELk/71xfkyvuUlmg6ZeS
         d3ijcjCFPBzZYD+C1gIiQKENtdZEgfFau4Vv0Wa/dQspuScdnAZ3U6utg7tLK2SRNBJh
         9rs6WeMbHZ4coHl1/OeqrkMEFLDSjD5zYQUIb0LfQXkrcbKqjEUhTPTvEfzB7JXH3x5F
         6+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769556445; x=1770161245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AYwc74eV9qggYhoV9i6/Mg1El1/ghyO+Qal4FOeXrW4=;
        b=RwruPUFbSm+UZGen76awgrkT8ngx51398lXvTEDJ9ltfME2nr7BBjsaEpShT04fZLL
         Vh5kZJAF1ob9PAiDKf60+sDoNm/XJresgyNcmufYbzOSWKlvjaVR3e14vKHPYQF7RqFI
         SYXA560i5suAKyGZVmaGViNo2efMrTUmiX/wNIwq8CsqFvTQ8qw8w4nqr8yHq9PcH/xF
         F3v9g7lu6u8lFGGW8uYh2Efguq1KRgQjgKjXA0R/W+Jt3CgGwfeVYJDeagiD1ZJkJn1J
         oSJYLrl5/un5+wyg+XhDuQXlTS5gCO0+U5fi2CHpBWsXVDXueXQvLbtxf2N8eaBj3lGb
         FSNA==
X-Forwarded-Encrypted: i=1; AJvYcCUYpi9jDdjfGmWZk1zkM2GuaZKAl2AVgzMme1wQTVZovEhfSf75EYmMIWnPnC2GFQ4vC33A7jaWXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3xuH2sMU6VMkBgPi8YQnfMkmI5DPws3dXzj5s30ZBGmbhDPLt
	M+HFhbhVJZbkZ/GHKIpOY8qcqXQaGxaq0EFnnxbOs1wus/i/Il0vaecFJKq8fk+5YN3oqhtH5zP
	mcgfqO2FN0TnSR6ZKvIjPpD621cU8KZA=
X-Gm-Gg: AZuq6aKI7KoIEJ8YW1sO5fiTkpGUrUUpumIYXOOp33kQphNvR+GEe98/r2480ZIVrK1
	JGE0Q9+uAkbwcTtLXANt2M+TwVGNO3zwQTjibvjRbnrG+TUdLfF6FXZek1YFhVFy2IfzVu91feK
	JSglJ05NIoEUnCn0qasvEcj6Rq345QAEtS2XvR16b2DhON2wJPqO6uaAJUZk/T5k6+2KKJeNfPd
	jOVfskCMUmjkB15WUJaAjTBxkr93eFDDUBa8Aiubsq7rcntTKJ6IItBdIX/X29eNh4ajvyXoMhj
	CSX0
X-Received: by 2002:ac8:5a82:0:b0:4e7:2dac:95b7 with SMTP id
 d75a77b69052e-5032f8bc132mr41676081cf.37.1769556444715; Tue, 27 Jan 2026
 15:27:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <CAJnrk1Z-9rsP86Fc=57P9gy=vFjfjT8nuAgE2_snL3_vfbbBmg@mail.gmail.com> <d6eb86a9-c5b0-4660-8cf2-9c853b43b494@bsbernd.com>
In-Reply-To: <d6eb86a9-c5b0-4660-8cf2-9c853b43b494@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Jan 2026 15:27:13 -0800
X-Gm-Features: AZwV_Qi1is2emkh36NbqB_zTfNf86Up27ZSkGNzaTBu3cCTb0atNx0Jbg1JnqAQ
Message-ID: <CAJnrk1a_VE+9an2q_B=2=hPYjEQ_x3+zauekEqWoVD330qaM-Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/25] fuse/io-uring: add kernel-managed buffer rings
 and zero-copy
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com, 
	krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11959-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
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
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bsbernd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F3F799B643
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 2:44=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> On 1/27/26 21:12, Joanne Koong wrote:
> > On Fri, Jan 16, 2026 at 3:31=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> >>
> >> This series adds buffer ring and zero-copy capabilities to fuse over i=
o-uring.
> >> This requires adding a new kernel-managed buf (kmbuf) ring type to io-=
uring
> >> where the buffers are provided and managed by the kernel instead of by
> >> userspace.
> >>
> >> On the io-uring side, the kmbuf interface is basically identical to pb=
ufs.
> >> They differ mostly in how the memory region is set up and whether it i=
s
> >> userspace or kernel that recycles back the buffer. Internally, the
> >> IOBL_KERNEL_MANAGED flag is used to mark the buffer ring as kernel-man=
aged.
> >>
> >> The zero-copy work builds on top of the infrastructure added for
> >> kernel-managed buffer rings (the bulk of which is in patch 19: "fuse: =
add
> >> io-uring kernel-managed buffer ring") and that informs some of the des=
ign
> >> choices for how fuse uses the kernel-managed buffer ring without zero-=
copy.
> >
> > Could anyone on the fuse side review the fuse changes in patches 19 and=
 24?
>
> I will really do this week, getting persistently other "urgent" work :/
>

No worries, thank you Bernd!
>
> Sorry for late reviews,
> Bernd

