Return-Path: <io-uring+bounces-9881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE52BA4F82
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 21:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DACE2A7E1B
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 19:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19C827F75F;
	Fri, 26 Sep 2025 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRp+Ubpu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85523A98E
	for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915031; cv=none; b=kRIZ6KQBjeN5wa9vHbQCs21+krpggpl83YzvR9p0zhcA0P39bisKXCrG33H5xiMBR/jfdUfChfITFVJlBzyK2GCzdCFtJAH1/JLaiSm+7hjJeE0zz/717iFvYibxhYxJB9FJuJS3zYc86k6Q1z1q/tzTC+67LLU967H4ku5Q3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915031; c=relaxed/simple;
	bh=dclFZbl0vA9qr78iBV60olDQ9bkbeXzfy8H6LbqGHD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=SDiirS4vGJwKAnhcl6n22PmUQDUP48sqCm4079W/okUqMa+xMs/oHy5ZCqD3UlEmtr5aooSY2iHkZt05TYko+/IokidU9mhK1hkoZMeVp5uMk3zg7aFL8t5FVOqpHEy9LSXu2cQbfqtTNpqfpxBWH7mM+8HYLFHJASTJdQrrVVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRp+Ubpu; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b28e1b87c31so371935866b.0
        for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 12:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758915028; x=1759519828; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dclFZbl0vA9qr78iBV60olDQ9bkbeXzfy8H6LbqGHD4=;
        b=VRp+Ubpu5IEtFSak2l1LSvijHIZTJsS1Pe6FUyKS3Iu9lsTLOiM2pxTPZEmSSJ91n0
         7NrD7NeNOKKD6TplWGk1lsEn8H/Ek+CmYjJAtCOG930HBFHfYJdjoZH/LPVbioXr9jGB
         iK0WSIGOLq7TbU8guPfBpwx6Ti8QIjcKHA7dqldaAHKEuY8MDij95xv0fJSM4lQVUtzu
         0+UFITTyXa9iUS8WRQUZsXtU6vektcInJH8wK7ZWyWkxJJq3u1vUZyKGkiU0R2bJaRQg
         yCYnPEzKIB1c1/DwohdgIHmFcB2h8iDeHE5SMdwOfdZW/29ah8KsUJKIhNLtMXowqBgF
         K7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758915028; x=1759519828;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dclFZbl0vA9qr78iBV60olDQ9bkbeXzfy8H6LbqGHD4=;
        b=U3EtbEIVCn1SY11fuABrHYYbrz1w+fy7yxYYmy9LDxtS8uZe1biaHaN5O+3w1IbpbG
         mSf6REBOH7Mrgxo8gp5zwuZG5g4IXalDqeDl6ShK/EGhnQF6sN7KFzm90W+2k/bNSIq+
         r4iUbaA8CX/MBenlFqTTSazC1OH0w06phOWk5ooCYSvxmsGDBcCtdg+8wx3Z1VsM6xJ5
         DOG8HXkaLFjjdmBihhr2mKDNrAxFB4dEiQvrgzqLsp0Sod2zs6fgB3sUKcwhQCZBvpQm
         2bTagxBBTwoyE74kxMZifSfD6wPY2A4xsmX+XEk4xZunw7Kxoig6TaC93onE9QzPHzs9
         LGEQ==
X-Gm-Message-State: AOJu0Yw+/K3zn4nkih/7x/5NMAAw94hnKoi0+0aDm38BPmy7AHc/ZM7d
	rTp9QcApTQfj6iqc5Z9ZmMdiuekOo4/sQ3rbxOWEFzWJHFpWEVnpYWwYw9QTEy+frLN55moKJ0c
	PtwilcKIX9w19MyR/6R4vrYlaYnWNtc9HPg==
X-Gm-Gg: ASbGncvB0nJlZJDOZTU6ctNef8cwt1QRYOswUHB9+8NZEpavonE7UyqXyPxLSctYMaM
	ag43ypzMqDvWiK73KvCy/b5qPHl3w2bnjBilCLHxVljLudRyZZmU39ocrjeIQpKWhhjHUSjZis6
	MNKTT3H+9xkdSgvs2dHsjBULH6fT6pXGwZSZqh5Ij4Xbbwn3mf/yMUSZlNH35xQLljUeM8en+Yd
	GyU5abm83Q6MFmy7pmBG2ae9zWpzVnFAq6u/4U=
X-Google-Smtp-Source: AGHT+IFldXYzXqFSy76CK+uqHErLr2j6a6CbKhtcjdO/6ZsEsUrsHvOCjFrYIBEAyJl8K/4Qq9z+faj6rLGtS5xUyic=
X-Received: by 2002:a17:907:72ce:b0:b32:e75d:b172 with SMTP id
 a640c23a62f3a-b34b9782cb5mr1002072866b.26.1758915028024; Fri, 26 Sep 2025
 12:30:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
 <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
In-Reply-To: <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
From: Shivashekar Murali Shankar <ssdtshiva@gmail.com>
Date: Fri, 26 Sep 2025 12:30:16 -0700
X-Gm-Features: AS18NWB5JjO2q5Qj3xLAaD6rmkKoHbbYdUIKPbJKaAX_QJ9ScsP7u5nJVrYr5hk
Message-ID: <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
Subject: Fwd: fio: ruh info failed
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am currently testing fio with io_uring on an FDP-capable drive, but
I see failures such as =E2=80=9Cfio: ruh info failed=E2=80=9D when trying t=
o run FDP
job files. This is run on an XFS file system on a mounted drive. Do we
have support for this?

Below is my fio job file:

[global]
ioengine=3Dio_uring
direct=3D1
bs=3D4k
iodepth=3D32
rw=3Dwrite
numjobs=3D1
group_reporting
fdp=3D1

[largedata]
filename=3D/mnt/nvme/largedata
size=3D30G
fdp_pli=3D1

--
Thanks and Regards,
Shivashekar Murali Shankar,

