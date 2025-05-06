Return-Path: <io-uring+bounces-7875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1712AACCEB
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 20:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 060A41C039DC
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BA92857DC;
	Tue,  6 May 2025 18:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DcrI+Mt8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12EC283C93;
	Tue,  6 May 2025 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746555296; cv=none; b=NVFm3zyICAKYYiCMgC+UHctdWHvjiaubvRHOzmK188JfjTSn9MHjkbn1yRcyrgFkfq6BFlthuZtM3np1eU/dWgLF6MTIWUAHK/2n7s1DuGSqbRk/aWzE/PnlxyZCZvjhgadfH9pLgVw6mPO575m6z50HInU15h+jiVxPGAwuT1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746555296; c=relaxed/simple;
	bh=aZkpd2dcF5uB3syEqGA8WZiEqSkxrG768idsWlJZohA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uj8U95vUoZbvIfx/7S5rolbKKNXYmd7bVulvTMo5I1TDixEnA1GvwS26QO5ADmex8rP7+tzb/HBthVNsocpK6mKl87Yg2zm36NzPd85UrgME2vtYtBWYVeqzjrM0rxw1UuWWyakHgwgr8qaO36yT4n21MEvKiwnJvxK5HZfqMGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DcrI+Mt8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30a452d3b38so5300939a91.3;
        Tue, 06 May 2025 11:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746555294; x=1747160094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LgUTLFyRDWkYKDEpuIhDqP9z1m1Yv8U7iugtqQBuYj8=;
        b=DcrI+Mt8RujXBdJgfpEHGVuXWW/OIOe4zk5wKTDDHDVsbXGotXaaIkClQQyw41h6y1
         iitityQ6AR2pmKGhV/eTtqWDCMxbJ6mlQEaEFSCwBqY/jZXtyuhWc3elYph8xsVsCmyl
         QAm6gS+J6RGbsW3A8qlKVy1WDEJTYF/SNlwvJxnP+lf7SnCCdEzJ/3lfMgEIYvbRHIYE
         bURN21F/1D2PIkPaeOPtV4n1OtvoPf0Aw9y3M8ucZt1tWLlhdgujU75qudTmg3B0Li7Y
         Ogd2nmKzsJdovc7jRamsnoTvI8ksDFKZIO/JEEye5a74WjpeIPwP2YST6n9vW6N8W/ht
         Y0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746555294; x=1747160094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LgUTLFyRDWkYKDEpuIhDqP9z1m1Yv8U7iugtqQBuYj8=;
        b=RkVxVdUWgH9prykgyg+5cRtWc1/3e9AEND/+peqeihABdMUceWmr1OdbwDspreak0K
         011BtSi8RYLaADOeYuwPz06JYHxokei69/1OQG+78l4FoCVArDOxU2wrzpn/+z1nqtvQ
         VSUFxEx97IOhitoFBLPvQjZp82+sA7jQAyYH3XjC5ARoiUuOuMQo5b0uMx9laBUyPm/B
         fSs3EkMs4/z1nLdAsULOMQs140NNh8+Lb5ywgtxkSJpNjlWoXwS3j9F/icmk9/xdIqnt
         SkTF70NfBe55JOpcSjduQEfaWw1W/jBZHM2/KtkcWDXHeEx58jVLaxKqILZFF0hEVSYY
         wlPA==
X-Forwarded-Encrypted: i=1; AJvYcCUggVTu6e78MMyS6XE54ecU2UPFMwHpeyrhmP/HjhiOk7B35Zv1o3SUfpJaEJclrnEQJ3TTHRjR9aF4Ks4=@vger.kernel.org, AJvYcCVaUzFjUOUTD1t4bm1568Tt+na8xK5Jcwv1id1biWij7lMYutV675yM58qBnwdDcwsVcT+oMy30YNNCanOjFQ==@vger.kernel.org, AJvYcCX7uGGTAgeiL7q34An/2jdQBtg1JNYZ98XF4CvduZ0tF6LfNxH+RrvRCu+zt0QnYYdfdMYkwJZcug==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRidb95n8c91IOHYYi86QSwDIM7ZFdGp2JvE5QCkQNCZpaedDN
	faEzo8l80jIa6xmnFiKqCN7JavMEnkkN9FhyL7y2Jb90kbE4wHcA+sV+De1S0oLxTMaAB6rjhNH
	I7DlDlDifTmXUZo37GRqPbe8Joqs=
X-Gm-Gg: ASbGnctA7UDQs9O+656zEGTOL4lMSKQFfIV9WHcg2sSzlqP7oCdJ0+0sn5+e1pC+waG
	B9Hbx8UnzXGrVKjdiBOnC0bvf65cEfmw/yvQvECgFz+H1hOF1pe2aDONVHexekEXquf7Ozp9M0W
	4j4lBhqvJC51zRXqy73FmN8DEFGIvvrSau6BhYMuvKl8ewHYnYqpveWhgP
X-Google-Smtp-Source: AGHT+IGwp2IFUitVkyl1IAWa+05GwLKsvMJm418R5rpT8coYjf649UgitPuIXI5xNWy57+nYxUYyxUOZvofrUpHZ/pg=
X-Received: by 2002:a17:90b:394f:b0:305:5f55:899 with SMTP id
 98e67ed59e1d1-30aac184a9fmr718325a91.11.1746555294071; Tue, 06 May 2025
 11:14:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250506122651epcas5p4100fd5435ce6e6686318265b414c1176@epcas5p4.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com> <20250506121732.8211-11-joshi.k@samsung.com>
 <CADUfDZqqqQVHqMpVaMWre1=GZfu42_SOQ5W9m0vhSZYyp1BBUA@mail.gmail.com> <aBo4OiOOY3tCh_02@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <aBo4OiOOY3tCh_02@kbusch-mbp.dhcp.thefacebook.com>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Tue, 6 May 2025 23:44:27 +0530
X-Gm-Features: ATxdqUG9RIoJxTdSYclAXfevasZNEUaF6CXTR24bqSobnO_8A3U2eC19Wgde8B0
Message-ID: <CA+1E3rJx3Ch2POT_t4DWiqb2nJiX7bHPrGVMW_ZviJ_b0o9UvQ@mail.gmail.com>
Subject: Re: [PATCH v16 10/11] nvme: register fdp parameters with the block layer
To: Keith Busch <kbusch@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, 
	hch@lst.de, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>, 
	Nitesh Shetty <nj.shetty@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 9:56=E2=80=AFPM Keith Busch <kbusch@kernel.org> wrot=
e:
>
> On Tue, May 06, 2025 at 09:13:33AM -0700, Caleb Sander Mateos wrote:
> > On Tue, May 6, 2025 at 5:31=E2=80=AFAM Kanchan Joshi <joshi.k@samsung.c=
om> wrote:
> > > @@ -2225,6 +2361,12 @@ static int nvme_update_ns_info_block(struct nv=
me_ns *ns,
> > >         if (!nvme_init_integrity(ns->head, &lim, info))
> > >                 capacity =3D 0;
> > >
> > > +       lim.max_write_streams =3D ns->head->nr_plids;
> > > +       if (lim.max_write_streams)
> > > +               lim.write_stream_granularity =3D max(info->runs, U32_=
MAX);
> >
> > What is the purpose of this max(..., U32_MAX)? Should it be min() inste=
ad?
>
> You're right, should have been min. Because "runs" is a u64 and the
> queue_limit is a u32, so U32_MAX is the upper limit, but it's not
> supposed to exceed "runs".

Would it be better to change write_stream_granularity to "long
unsigned int" so that it matches with what is possible in nvme?

