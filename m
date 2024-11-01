Return-Path: <io-uring+bounces-4296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B789B8BED
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 08:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2B901C20F9C
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 07:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4E71514FB;
	Fri,  1 Nov 2024 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="NZ5YhjI/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7DD14A60F
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 07:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730445403; cv=none; b=Tvxate98NSJUjcIDwZYoFecMyEChIOJX7hHLfCPSqSY/AqIhWAOnAK1+a8bqzHwa/6SLd8x9kGkwwJusDGNHkSwxotUzX9fNaPddoilE3Np/YoQ1FAhtoPdfcenVYPAmDu+yrotITvpznGZl+/Mw4p4XJ0n+Any1if/Z3cjgABo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730445403; c=relaxed/simple;
	bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KV4IZ2EG7RPOiy4nCRNrz3Ca80TaAnMEIYIWd9n0Fo3n7gBpdDxyapW4i5iTAyXno2uu7oTo2Si0JpPs0h0HzYrDuInQTRlx4T9+yZko108MNIZeVGZElwPLp3eXfY9IBVFegeXa/h6vm4iu+EwSEq8lTZ6hFHusZc+/ezPIGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=NZ5YhjI/; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9e71401844so37522166b.3
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 00:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1730445400; x=1731050200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
        b=NZ5YhjI/QzbKbot9LZj/s/PnuoSwE7SDMqcPCeQYuJ+7n6IOBNv31yBBmLvlxktdGZ
         qoIpyid9UUQAzj8HeAF+8TlnFPDDktY5LB165duPAA6hBrruOiSpUKatt4X643kgmito
         HaY3ZSia8eZUDg0fmUMxZvay+k0NUx/S6n1p64fnyA+yW8K4MCtIZSunqrecam4i4keN
         JptqsQK8zGvTOuWP8crEqnp6J4py8WNVVYN6mGLi2FQKkulx7YLI9cBybST+Wa1IKRmN
         whtzItZno0fzo9tPiwsZkJOIZ2Orpt5yt6Dgw79bOo5KKZN3ShH5c8Kd+Fcq0g2qSh85
         AR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730445400; x=1731050200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
        b=H1eES72Ju+JPZK7md5IbBzu2GQPMJbORqZe/6R3rlpAHf611G0yhAXOp8XS6eiV7RE
         T1r6UggPt37r13tJrmLYZKO1LvZ5a0XlFz+2amsmhz43PtHJPmA2I4EVjnkqtlr+siBk
         MckQGrw7IeSjScEH9NzNDyMy0G9hVc7YsM/Rndj9L7t9vB0T35msPtfaYWladzdyKjql
         TJM02Hqx0xJ3xA1CFqI5iJCIFHEV+tonN4ouBBVknClND3f24AT1n1cIiqJMybQK1xeY
         gUEv0NsQZPdkmpKQyOKIVyYQJ4xydmqlMXahSEV/qtDZyGh9pOMRn3DVYqIG6do+RFC+
         3l8g==
X-Forwarded-Encrypted: i=1; AJvYcCWarr27iKEGjZJd79zYRWv/lyxbp28/ObtlbbKnHVZgMe6lMt4Uw2ZKH1Zuc+Pg8zdAIAk9WshJcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2cw2CA88MeukpADnBADHtbYXVL8PgPgkjfi9Pn1ZfZh9b+KRh
	tyd8VCtFH2BgErNGOGE6UCAoHU9nUswv7cdGZp6ZOBwSYy1wwV9MwwMI6RfUzu698TaoTboe+gS
	fF1oYC17U7y5CmR2Ve4aLt2dexIsWI3Tye7GhPg==
X-Google-Smtp-Source: AGHT+IGPuhXjQfdSyl9CCnBDb8kfQdLr1OP5WRts8Y+TKi58ZMd9VxEJGiFKfBDiAyZu0iCHQTVa3iEX7i7W0CHxx4g=
X-Received: by 2002:a17:907:7e8f:b0:a99:dde6:9f42 with SMTP id
 a640c23a62f3a-a9e50b935bcmr454552666b.47.1730445399842; Fri, 01 Nov 2024
 00:16:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com> <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com> <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
 <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
From: Hans Holmberg <hans@owltronix.com>
Date: Fri, 1 Nov 2024 08:16:30 +0100
Message-ID: <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 3:06=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Thu, Oct 31, 2024 at 09:19:51AM +0100, Hans Holmberg wrote:
> > On Wed, Oct 30, 2024 at 11:33=E2=80=AFPM Keith Busch <kbusch@kernel.org=
> wrote:
> > > That is very much apples-to-oranges. The B+ isn't on the same device
> > > being evaluated for WAF, where this has all that mixed in. I think th=
e
> > > results are pretty good, all things considered.
> >
> > No. The meta data IO is just 0.1% of all writes, so that we use a
> > separate device for that in the benchmark really does not matter.
>
> It's very little spatially, but they overwrite differently than other
> data, creating many small holes in large erase blocks.

I don't really get how this could influence anything significantly.(If at a=
ll).

>
> > Since we can achieve a WAF of ~1 for RocksDB on flash, why should we
> > be content with another 67% of unwanted device side writes on top of
> > that?
> >
> > It's of course impossible to compare your benchmark figures and mine
> > directly since we are using different devices, but hey, we definitely
> > have an opportunity here to make significant gains for FDP if we just
> > provide the right kernel interfaces.
> >
> > Why shouldn't we expose the hardware in a way that enables the users
> > to make the most out of it?
>
> Because the people using this want this interface. Stalling for the last
> 6 months hasn't produced anything better, appealing to non-existent
> vaporware to block something ready-to-go that satisfies a need right
> now is just wasting everyone's time.
>
> Again, I absolutely disagree that this locks anyone in to anything.
> That's an overly dramatic excuse.

Locking in or not, to constructively move things forward (if we are
now stuck on how to wire up fs support) I believe it would be
worthwhile to prototype active fdp data placement in xfs and evaluate
it. Happy to help out with that.

Fdp and zns are different beasts, so I don't expect the results in the
presentation to be directly translatable but we can see what we can
do.

Is RocksDB the only file system user at the moment?
Is the benchmark setup/config something that could be shared?

