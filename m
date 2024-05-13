Return-Path: <io-uring+bounces-1889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9408C4076
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 14:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32D67B219FE
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 12:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B05114D293;
	Mon, 13 May 2024 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="br9Y03NW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E650214C5BA
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 12:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715602218; cv=none; b=QalbzQ4zXpl/5+Mm1qyl+3vOhQieiy1Prtk+BdBcNDRyxM4ecJBuGPLxjnh9WDNFiZHfzmqzuqzVnYcHJv6BSbxaeuPDYFsRabyYCh+xZ79IyzXtrcMoWMCQ3ULYa1+cHC/DR4EFItiv+taJZrPCAxNcxdUmjSbFmsmdAJRLqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715602218; c=relaxed/simple;
	bh=//Nxr4lS7sPYC+plv3wfdvchHwkqVDhzTMI613WRJoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqA0rMzdnMWPAwAwFalP7e9ENrSH5lgPVO5IYRo9qApJN0Ssv48WvM6Ja3g+Bhh/yzH9Lrx93OImuqJAC6ym8KItB5CKPGYiSSolQm/5nYBsgomO9UeyrlHlZEwBulNRsz+Sg7iiok3HZLyhc4kf2M7Mc45OGd6uSRIoJiQzab4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=br9Y03NW; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7f63961bed8so1326849241.1
        for <io-uring@vger.kernel.org>; Mon, 13 May 2024 05:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715602216; x=1716207016; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//Nxr4lS7sPYC+plv3wfdvchHwkqVDhzTMI613WRJoM=;
        b=br9Y03NW2BLeOTvC7DZSHF9OKlv2jG9BHHiKcGFCPIt8A19p+NhujHgs3yW3aPBRgf
         DFLCBd2Ya8SQBgrubalHXeDm4m83CcQDrXviIowPdPeOButC9wBiY1dEBdySMUHWSlmO
         /Xz4CDKYPN2NJMd1tPpK8bx3PFlV2PzgH9oyiHqvQhPjA4FemQ2s8v0WDb3oYNDlTL7h
         XKa8ZGxiSnO/rctENB/fBHczdvsIQSU/ghjoKbMpuPzL5wgPWOcbyyAG5RvO5C64xVHx
         njXY7zxCp6DShpikR38StY0qOZTIfCGchsV+R9L9UAzes7AQcaqAYAHbBWDlQs1uEtVz
         YYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715602216; x=1716207016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//Nxr4lS7sPYC+plv3wfdvchHwkqVDhzTMI613WRJoM=;
        b=MmqFA/cyM6W7yBagzCwuQH+tVgumZd7FB4VZodO1ncWDBoN//DfQsG2PBJvntyB1Qg
         aIxjPuh2xQ24ADfHxuLI3vgD73gKuO85l+N34Y+R3FjUdyWMc29ypY71oWPPVq6x8UWT
         yj46iqMpGwQtiToK3GN11dDDXttNpprkb4lDXYUMiNDQnOyWxAtDTUucaGBx2306D6lH
         TPVtJq4AZdxYs3Lsf6P160JS+oeLO58hBkkS/3fg1UGL8D0EwpX/ffGDx82HAHnXWAIP
         jMeAS7nFDonNlmkjq28lUAziLlzzhc22FTV/dMsHeT+6cW8QseMicGWCm8Po40eU74aD
         KOGA==
X-Forwarded-Encrypted: i=1; AJvYcCX2aNHNs5PIP+hK/l36AQBKVWGGMZmatQXu5kBCNV7cz1op0yjkx+0gL5t8OyK/TXspWDr7un5y3ZMlEjNzZp9tzfVRYuZs71s=
X-Gm-Message-State: AOJu0YyETTxLT6jgQd5FjEmpM6nbauTYG/nxOT8DHy7BW98r5d8k8I54
	yDQQIWsAMYG1IIizja2/PR517wJISVJEmiJN1HQQl+6Zl0O6qBxa/wjZvylixVrr0f+gV91scQw
	ZLEudJKH08WZjfV9scPG75s4yyQ==
X-Google-Smtp-Source: AGHT+IEik0WCzzdEdxH6YbAzfrmyx6xrTKHxqnEaHQ+6j9JMBZ/GFERy6WmQxbsi3Vz5EIIvYg9paRELRWYInhsdII8=
X-Received: by 2002:a05:6122:2a49:b0:4da:e6ee:5533 with SMTP id
 71dfb90a1353d-4df8838064amr6917617e0c.16.1715602214287; Mon, 13 May 2024
 05:10:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97@epcas5p2.samsung.com>
 <20240513082300.515905-1-cliang01.li@samsung.com>
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 13 May 2024 17:39:37 +0530
Message-ID: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 1:59=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Registered buffers are stored and processed in the form of bvec array,
> each bvec element typically points to a PAGE_SIZE page but can also work
> with hugepages. Specifically, a buffer consisting of a hugepage is
> coalesced to use only one hugepage bvec entry during registration.
> This coalescing feature helps to save both the space and DMA-mapping time=
.
>
> However, currently the coalescing feature doesn't work for multi-hugepage
> buffers. For a buffer with several 2M hugepages, we still split it into
> thousands of 4K page bvec entries while in fact, we can just use a
> handful of hugepage bvecs.
>
> This patch series enables coalescing registered buffers with more than
> one hugepages. It optimizes the DMA-mapping time and saves memory for
> these kind of buffers.
>
> Perf diff of 8M(4*2M) hugepage fixed buffer fio test:
>
> fio/t/io_uring -d64 -s32 -c32 -b8388608 -p0 -B1 -F0 -n1 -O1 -r10 \
> -R1 /dev/nvme0n1

It seems you modified t/io_uring to allocate from hugepages. It would be ni=
ce
to mention that part here.
--
Anuj Gupta

