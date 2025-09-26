Return-Path: <io-uring+bounces-9882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B7DBA53C7
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 23:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E489B625CFC
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 21:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A1627875C;
	Fri, 26 Sep 2025 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YXcTxPRN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AB7277016
	for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758922986; cv=none; b=Dc9kUnDjiRuFsbYA0JFifkQxNvTEMx+ZxiWRo0B5ZwKmL3rlAeQyXjGsRyjd2zMn8XkMW2z1gCmH4CnzhGooaLvPRNgHleSzB6wB7WrJvRO4w6szWgGtnxRnx8WO171C/LWdY7B9zlZW8eXOlZAj26kuAGMWj8H5cab9yuqReMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758922986; c=relaxed/simple;
	bh=RtJpfdW1DBdsJ4EGN60Q1xzhg/pxn25sXor+x4iAVfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=en+xOV8sNwb18Ft1+7BDbalQrfEw8B7jAl5sFr756B2xGu653yesOjN2NHMqvoKi9Jnq1CYCC/42//X/LRR6dkkQJk2HyzMsZ0H/9FHQNs1I5jbhRoMJvviLmQlM/1dSguhM4lcFfQeDaf0QwGMjYaecbCEEl25LSeLCrW2VCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YXcTxPRN; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-85780d76b48so268584885a.1
        for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 14:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758922983; x=1759527783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ahijqo+X3W2mSX+C9u0hosbBI8MhvcFM77+PLbqsoEo=;
        b=YXcTxPRNOmeE8+2DswHxbQcEg76iArCkv/8GvOWrENYuXBHu+TC4nKvIgyqa14m2u1
         0uM29peh7wlIkKO1/km/PuLFT1X20UTkQMjqx7Dwtbg//uQ/sj8UOyhQDp8EDqIjZ9yO
         yjacyfEgpr2RqB9fv+aOyAh1OYOAw4uHwgkq6DtqJ1Vd61FDluhTC3Easqtq4N6WcGvj
         YN6jVzq360nR6z4q3heLF9kOmUWvpk4Xgpik4dzCkDnXBZ3C/7STxOf1hJTKAjDyaSMm
         dpouJZbk5GvUwxb81BFpgKn9JYZdD/VpfxLcOcNFxIrfpRlkgPrkSo61kQhndJSvEZk+
         JyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758922983; x=1759527783;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ahijqo+X3W2mSX+C9u0hosbBI8MhvcFM77+PLbqsoEo=;
        b=tr7sbvi4/EyrVE7oaqvEHcxDS/PwL0ToOfeOwi+FXskd/2vHC8LzDBPexjkRoJW6y/
         M6sNxPC3Rtu3oRvEBRRGB47gE9NBhibolhxZUINwcdqHN9BgX/PczkLbVgUNX/NED/pq
         VpT4w39nS0XTH6wZvcjMeZeegQXkdcdA10AWX2dgxLin31iBZDiRM+Y8JtVV9XRgQHdG
         u0Lj5+ibPjQpcmBApcqHBpHUt3HswJiX6BZfMimOXLWK3E/WbuDhm9u9aX2aijYp9FfD
         nQe4wod26FUeJN1oQDtuzAOt1+9EMu6OLoF40EdupPkYQqDhUUYO1H3JpFOIgM28Ad2D
         9oqw==
X-Forwarded-Encrypted: i=1; AJvYcCV9h7s09Qc6YZhuAkhhROEDI9AmqnBEt17fUDWoKxZNcsaXekFNmVmFTLfVTMe0A98YoRiIT0tYVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9f9XXtncUMAwUiSt2Fk9xnE8gnIcNq9Le8YLam0g6dyMPdrv8
	blyXpT85FzfB/gElMfG718wg043WdKVBAx6ZxqvgJHD44Q6UP16pDQLnSsdQN60es+c=
X-Gm-Gg: ASbGncvgkCS8WK5kus2HZVq9y0MfhjX6xCAZgcgpin4XwVJu5bPfyGO6sTm5n4huXQK
	DJch0KE7tguiAhumo3ds3ZFlbbzgG8xiAxQnCZFIP3npKQDNE6Z2NLIt7vdRBNGeBQjoOwknHOg
	1IFOgowBbxOPM4e9c1mLslujaz6daTIFX3uempRMTN2nw4TOUt859ug/02mVjQR7AvCz1Udh1P6
	ZKFOkAuAAl24eVO8hviumIL2m2BnDwYAZDptxFyV/ta0SNRrxbCy4vPTeM0JFLqxzPkusNpaXEs
	Blgg+VjpTChUn6QhVuGlntGmhR3pVHpgFZKCdJmfYyqVEFVzQFPjizCGn0zScK4HthVhuHrd7EE
	hshbV/1kkVvT9DLopkg1DfdX2CTt6r3Ykjk8=
X-Google-Smtp-Source: AGHT+IHAK9+uXDWazOkRmiJXKa0I29LIdxG1cgI5ldIUFiHB3bASn3xyl0i61DIdGti8nJcG5Ek0dw==
X-Received: by 2002:a05:620a:29c7:b0:859:be3b:b5ae with SMTP id af79cd13be357-85adeb4db37mr1160319485a.11.1758922982941;
        Fri, 26 Sep 2025 14:43:02 -0700 (PDT)
Received: from [10.27.121.144] ([104.129.158.226])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c28a8a7e0sm349404985a.22.2025.09.26.14.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 14:43:02 -0700 (PDT)
Message-ID: <1394af5d-ca1c-453f-8a66-f0f3a53702cf@kernel.dk>
Date: Fri, 26 Sep 2025 15:42:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: fio: ruh info failed
To: Shivashekar Murali Shankar <ssdtshiva@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
 <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
 <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
Content-Language: en-US
Cc: Ankit Kumar <ankit.kumar@samsung.com>, Vincent Fu <vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/26/25 1:30 PM, Shivashekar Murali Shankar wrote:
> Hi,
> 
> I am currently testing fio with io_uring on an FDP-capable drive, but
> I see failures such as “fio: ruh info failed” when trying to run FDP
> job files. This is run on an XFS file system on a mounted drive. Do we
> have support for this?
> 
> Below is my fio job file:
> 
> [global]
> ioengine=io_uring
> direct=1
> bs=4k
> iodepth=32
> rw=write
> numjobs=1
> group_reporting
> fdp=1
> 
> [largedata]
> filename=/mnt/nvme/largedata
> size=30G
> fdp_pli=1

It's generally a good idea to CC the folks that worked on this, and
probably use the fio list rather than the io_uring list...

Adding them.

-- 
Jens Axboe


