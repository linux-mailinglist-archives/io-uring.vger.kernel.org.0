Return-Path: <io-uring+bounces-4259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E02FB9B763E
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 09:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D760281E0C
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 08:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BEE15382E;
	Thu, 31 Oct 2024 08:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="IvbfBnAp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4938E150981
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 08:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730362804; cv=none; b=GIP5kK+EDGdDcLDcH4s91NUSOKbOriocBhYyDQHZHCqEFXsvLiht2t18CIOFU2WSCJymnKDEmv130f4bV1Rz87kuXvRqk6K4VuHr8DDmcW+aQ+dhCLCcRZa1VPBpifbdYgrOtoe6ja5QaOp5Lqg8Ly9L7t+uLHxJrrr6RZy6bJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730362804; c=relaxed/simple;
	bh=CX8S5Y9npSRGCV5zzlSrljLQ2sJgae3kpGxmZLzONUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GsecDgkWMEvmaHrncXAaTBxIKEgDycgLHUqJOgMtWgMr8xqopbpcW+KAFWeaaN11awAUc2apDd68qKaQN8tOdBwcqjTJtkW0R8VDlVatw/KBOk/Jzac77CC96rnX9xT+RgjGoPlzOPWlCjLrvzmbNhAFMfLhbvATSqC9KEbWmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=IvbfBnAp; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so985955a12.2
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1730362800; x=1730967600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHihNpINELIVjK3l3rTKLlYaMgvUEcgArJNIc8J5kNA=;
        b=IvbfBnApArGei0oWtsKAVEQG7VN+j4k7cjcjTAljywxgnGUC21T9V6QusjJWA3dt6I
         VrXhYiqpPum6wLLZDFVlf0zkIFU+v+pazOyV09JB6bgxo84wXzWapcahqdFZlKg93ogP
         UiKP7hq6tcPL0cWefutUKOo6HddaoS1mlBmJPMziW6i+/NBk5FDKKnogYyw87CkPxjdH
         0Si/EAGAQ5vjveNofRNgnsIqf1ZQBXTLGxau/Dh+9eRKVnC9wwN2mx8grS1P+Euy+7E5
         H/fSDBOvpigv2t60Hvsbum6EqrOZt1lOUf0nW2IWLltzZmWydrOWrPquA3dvfSKnDnzK
         q0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730362800; x=1730967600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHihNpINELIVjK3l3rTKLlYaMgvUEcgArJNIc8J5kNA=;
        b=VgUqwi5uvtZaPuS9mDLpOn459j0yPdzMZ2CrnNCeriucORA9HzEkZ8uAti3Shd/Eq6
         hqmOJUmO2LXFdIBSHuopnA08iaTRGvrAXRMNFIqSo8zWievnNeVeiXxgxe+utcL609+L
         y6oV8Byv7Z71JgZwiY3cVjEx8bd8VIKF2SnaywHZIOyjQdXC9unKwaM6xfy1BMRjDb8+
         ju4aK6nUywZByqio3DuCwfX/x7qQMqrXXAgWRk05vrMb+xP8niTZ4QptZcqamHJTU/uL
         5lEOdBZrmxSegurkfC6LSUclkY0OD98NtB1HWCA5IUbPIy2ior0EJy2zUxbEmr638p5q
         STDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcUp15cHsEVX/mXrCTerLpcxIh1bhNxqjO9CwPKiG8ndNP4S1s8lGonw0070HrMBgjY77gOgfm2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJrl0v0Po6q5MtOutWba/UxEAD/QJwN7EAKguvrrIwOPpB2bit
	ORkz+QL+e9AuWOfe2O2wTGJrB+s80qqMX1Fnf826hdMP+yoDo4fRXUwQDsgtgw7aJuKGvIpZiYt
	hlBxnz8IBh1aLsUtjRXI0rHsxc9UxOyMKiNf5kNG4b/3+RtD1
X-Google-Smtp-Source: AGHT+IH8+r7Wg2Co4/bqHDcfHF1OtsjwdU/NhWvyCsNdTstwhoydYvHp6WgT8/ZbDKKPHXfyJqAdxDuKmLBM29l3xGo=
X-Received: by 2002:a05:6402:13c7:b0:5c9:547d:99 with SMTP id
 4fb4d7f45d1cf-5cbbf889742mr15743282a12.2.1730362800416; Thu, 31 Oct 2024
 01:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com> <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
From: Hans Holmberg <hans@owltronix.com>
Date: Thu, 31 Oct 2024 09:19:51 +0100
Message-ID: <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 11:33=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Wed, Oct 30, 2024 at 05:57:08PM +0100, Christoph Hellwig wrote:
> > On Wed, Oct 30, 2024 at 10:42:59AM -0600, Keith Busch wrote:
> > > With FDP (with some minor rocksdb changes):
> > >
> > > WAF:        1.67
> > > IOPS:       1547
> > > READ LAT:   1978us
> > > UPDATE LAT: 2267us
> >
> > Compared to the Numbers Hans presented at Plumbers for the Zoned XFS co=
de,
> > which should work just fine with FDP IFF we exposed real write streams,
> > which roughly double read nad wirte IOPS and reduce the WAF to almost
> > 1 this doesn't look too spectacular to be honest, but it sure it someth=
ing.
>
> Hold up... I absolutely appreciate the work Hans is and has done. But
> are you talking about this talk?
>
> https://lpc.events/event/18/contributions/1822/attachments/1464/3105/Zone=
d%20XFS%20LPC%20Zoned%20MC%202024%20V1.pdf
>
> That is very much apples-to-oranges. The B+ isn't on the same device
> being evaluated for WAF, where this has all that mixed in. I think the
> results are pretty good, all things considered.

No. The meta data IO is just 0.1% of all writes, so that we use a
separate device for that in the benchmark really does not matter.

Since we can achieve a WAF of ~1 for RocksDB on flash, why should we
be content with another 67% of unwanted device side writes on top of
that?

It's of course impossible to compare your benchmark figures and mine
directly since we are using different devices, but hey, we definitely
have an opportunity here to make significant gains for FDP if we just
provide the right kernel interfaces.

Why shouldn't we expose the hardware in a way that enables the users
to make the most out of it?

