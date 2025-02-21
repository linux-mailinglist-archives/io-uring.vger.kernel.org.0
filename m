Return-Path: <io-uring+bounces-6620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C86A3FEA1
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 19:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE88E1886BC0
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3442D2512D3;
	Fri, 21 Feb 2025 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myuxO11s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8411D5AA7;
	Fri, 21 Feb 2025 18:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162097; cv=none; b=ni7PIgyqStLCeI56s/8e2M0wFYlm2Zka2gzGKgdBQKTsInLA6BVxQknsDIaL0NPtDlbHaLOrozTmr3vtcjY54UcGL9pt4gw52m+9ryUsH/9TFqQ8TM2kahw4wBfOsxJdW0uEDTynRq1KN32FlnQJlqJfjJDrk59vRzGzozmylsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162097; c=relaxed/simple;
	bh=xGu2/tWFtIyMuPt72shxeRhtxZJkL40X71Yv0ccweGM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mcVE98hc4aVwkcJSYC26fJTPCtXOc2ft9M3oxyx+qz5CJWRB22b8ESOZljzCKFfLQ2MaAfyXT0LrL6mI8859S/oSSgnwZCtas7YorZ3ZkE8OXsqXPTsgXcvSWDyy3Zhiciq9cX4m6fmwzLjijBYwcYRx7q/P206dbLVOJJR+9jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myuxO11s; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e05717755bso3563896a12.0;
        Fri, 21 Feb 2025 10:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740162094; x=1740766894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGu2/tWFtIyMuPt72shxeRhtxZJkL40X71Yv0ccweGM=;
        b=myuxO11sM63ZTOIvMsJfjFtLTDSdue9wXEXjKA3UF2SGLddQPmDUCzMafoREuDlQMB
         K7JEw9m1a2JD9F88jDAu48EiG9IAFzZa4KosuGCltDmpXwW1lD7vIaP296rTyh9xLMXF
         HwBbyLKUNpQ2B0uc5ej5rmTaVd913csLnA31pXwGUZ20l3Yrz3SK5Tj37Ffj8t6xkpVs
         vhE4GUM6Cr/oHn4CyT/+Bx7/Cd7oNzmGwb5VGcE1nDJ8cYzyJ8ctKgUrM3nBMPExQ0M+
         TZqhgo+CMeYI9PCmGoonOvvPHEoCgkJnzpxFFIetewtnLvKZR1r+l15nTFNl3Mhbir0y
         KyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740162094; x=1740766894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGu2/tWFtIyMuPt72shxeRhtxZJkL40X71Yv0ccweGM=;
        b=PEFztrQYTkYGJQDXKJvPvib8OZsjyEk4nfY8wA7+TzeVh1QIxbEo8yiXpxstQXIuNT
         CLRSlSuSFfN1bkTVOf1pcCea1T6R9Id9dcxvrTsD0OILR36AuMq6SH7STGrVsg5DAsPc
         SygAYU5R8Aanh5mcCYnmVys9zFDuE8BZoOHN9CMgykK9/TkVUuln4dpbe1PAhWYe71bc
         v8sEwbBzCDhv/nKFzzqP4NaEp/makUIIpcZHkwnpKdzUoWTv/0NvulgswAMq3JgF2cXs
         XDwLyp1rltDpma2PXRNtQdjgG6mWUqq8FJp9C1rVF/9lWYHERtWh628qPLTL83q/z663
         U+Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVfbpr2SW6GASurC5E59M0JaQRn/rDukaXKDJJ7HGgflCJX/mbJw72GVzElf81yW/iGUnAdwHKuIKKMF1j5@vger.kernel.org, AJvYcCVrDMvQ30wBpdg9WihyH0slHYM1nPAI2OKx3Gf419M5Uv5J++VmGyWMOpXRjQYKUSMhjQfJPTIFulUiJp3tIg==@vger.kernel.org, AJvYcCXat8tRqu5sWIYomDWlfCBEmG7SNHbT1GqAD7NVWUkVc1L0Hu1nx89/cW+NahlL+7otVpXTaVR1jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxheyYPPf6KS2+bEneCuI0wn4Uw4cctWyzfwkAdqmSw4MrfMywC
	FZyRpm/iVlQjmO4hbj7JKjMBhq7FPWdyzV78mJtxxRoMZJrqo7/Rodg3ZlKo7LaEIHsBAR1VuLZ
	BQTMWLZCXbgwcYh9U852X4upg/c7RtwOFi4w=
X-Gm-Gg: ASbGncvZYwbILisAuTGetolBfxNZZptjPLi5e2t1FgOIrSXnYTTYISXCSLWUjxJXov+
	6bxG1m3e4b7vvaBflKiJ7iptYHqthL+da34MAB2xblSM6cr+P90wtSCOFB6NaARHTxLZYhYQ3OY
	fCAutqZNs=
X-Google-Smtp-Source: AGHT+IGAXQbZmEyYSm2cckq1LgM24GijWrp6yugCR8LkdKI64YmBYY9MYbhB2iionSsM5w9BNttxIpsT6D8TZ3DaET8=
X-Received: by 2002:a17:907:9496:b0:abb:b330:5bd6 with SMTP id
 a640c23a62f3a-abc09a14d28mr449276766b.21.1740162093299; Fri, 21 Feb 2025
 10:21:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com> <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com> <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
In-Reply-To: <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Feb 2025 19:21:22 +0100
X-Gm-Features: AWEUYZlViBnnfMt9FmjLqnP2gd1ECjQAwovRr4fRzmcyZ2aBSuE9xulwHzBJ9Os
Message-ID: <CAOQ4uxieuFTN4Ni4HoBsEvTPW_odWSo78-5shJTh3T2A-vzP=g@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Moinak Bhattacharyya <moinakb001@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 7:13=E2=80=AFPM Moinak Bhattacharyya
<moinakb001@gmail.com> wrote:
>
> I don't have the modifications to libfuse. What tree are you using for
> the uring modifications? I dont see any uring patches on the latest
> master liburing.
> >> It is possible, for example set FOPEN_PASSTHROUGH_FD to
> >> interpret backing_id as backing_fd, but note that in the current
> >> implementation of passthrough_hp, not every open does
> >> fuse_passthrough_open().
> >> The non-first open of an inode uses a backing_id stashed in inode,
> >> from the first open so we'd need different server logic depending on
> >> the commands channel, which is not nice.
> I wonder if we can just require URING registered FDs (using
> IORING_REGISTER_FILES). I think io_uring does checks on the file
> permissions when the FD is registered.

That's an interesting idea.
There are definitely similarities between IORING_REGISTER_FILES
and registering backing ids.

There is however one difference, which is going to be even more
emphasised when backing files are setup during LOOKUP -
The backing fd setup during BACKING_OPEN does not need to
be open for write - it could even be an O_PATH fd.

So fc->backing_files_map are not really fds registered for IO,
they are essential references to backing inodes.

Thanks,
Amir.

