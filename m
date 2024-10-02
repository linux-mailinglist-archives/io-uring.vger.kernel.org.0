Return-Path: <io-uring+bounces-3376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1303598DE49
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44C551C22832
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D467D567D;
	Wed,  2 Oct 2024 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xGLJdNMe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B00912DD90
	for <io-uring@vger.kernel.org>; Wed,  2 Oct 2024 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881406; cv=none; b=EFPNp+H44sEtujixFeXC1DhCaKKKhH561jsu7C5J/Qek3kpUlhGD/L4gpot9Ijy2lLUgH8ow1dbAbMxnpv2YZHrUJP21EQ6GPkLjCxN9kuLlVrACBr4VJ5doLimYSxQsEV0+71vxpoh2HYcpM9ccMv4FJqUxGcTUu9ao6GPkAmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881406; c=relaxed/simple;
	bh=A5bkOqDxFmnjWOcQv7M8QGENshtutAhVmgSm7Ft1O2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AAxf5/+cmmuEHUbLlpSm1Za+I89dcOLICjYhedmHFIpEwF2b8x/R/ajoPKakjCLvtKwi5BCDyjT0cV64jupdcOIvQPghpaJz53+HQeGniG1IahutRHGaWMJgxfWkK8DIl4tANYaEGu8nkEpOKsKXN7iDlPyRjE0gF6X9uFdxbxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xGLJdNMe; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82cdc21b5d8so356441539f.3
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 08:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727881404; x=1728486204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YN8tLxTNLoc6Z+6iyULY22+FNGpb/PmZBsYC0aDr5nk=;
        b=xGLJdNMeYj1JJFCK5pq/+u/EqfTPs2viaPoMJX76e+b6EtIzioliSstzI9B12w5/e/
         C7vHhzNJ/AXyhBVnvDyNlTbKfwdd8AQnn0WgmUgSAG7F9xzg2FvZS2hYUi7Z8J8m4P+A
         Fm4nxBK/NHZQJOML9UgGK28nAT0iEj9sBAgkjHL+Tqhwo9/nvW8zcAMHEWFHjJP8qTH+
         I7rUI0zQVqtgJFj2g8Ss0mM8up848OHXG2rRMp3YxlUd9RqaX/l2q41M6nCJsBIi/2fo
         4QZtmAeIxZh7PXIn+UAELBbSzMIu4NL11WT3V9gDMCufWpFbhF927tUrqyU+leXObu9n
         AzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727881404; x=1728486204;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YN8tLxTNLoc6Z+6iyULY22+FNGpb/PmZBsYC0aDr5nk=;
        b=dTRzCTEnn3UEg7RIsh8MLiDi3FrtTVcaAL6/8T7znaXTls/pGQ2C6T6DgO7PB4FZUG
         Nsf05kTHQkc040HpWedxo2r8XpGwBEStUYc8U1qsmCBgD0lTc00gmapHc5pbtID7htpy
         1IVfujgaYV7C7udwtI/cUYWf3hLAamLdSRGyzvXX7DgXuRG/Qfs7UoQ3YbgFGLXAq5HW
         vPPM2mlLVjLR1zXgkwubHWL09J47sSqI4x7gRFivdVgbzuyf1j2BtFbEH0QrVPwrk0jX
         dFlDY/fyyLLFULWP+1qnh3FJjnI0Nm4hiR+RxphbzFfi7MABAMog3ksbdMvGYWQeApfH
         F0cA==
X-Forwarded-Encrypted: i=1; AJvYcCVbsbr5Pjxg34hUWptaQsspWEKkpOt3fFPOaNTMy/UD0QeuaDoMLKwqbBBBhmtqbskPXDZrUMlWag==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdzpzcmED8AAMDmLclsr4z7XB22maoMUUo628zOFu1sWN5ehFL
	0yj6QCQekZ5gijZejUUWQjYA1jbJPNuRjcm0T/0/Rz9u/HpEIDy6HBltyVY8kaA=
X-Google-Smtp-Source: AGHT+IHxepFVron7PObO0zlx42lsa/dU5NCcXVtGwmYpMS9i6sDKEx8F2iCKxC41JSaFOYey3Om7Gw==
X-Received: by 2002:a05:6602:60c1:b0:82d:8a8:b97 with SMTP id ca18e2360f4ac-834d8519045mr390417439f.10.1727881404221;
        Wed, 02 Oct 2024 08:03:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-834936c8597sm334094439f.16.2024.10.02.08.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 08:03:23 -0700 (PDT)
Message-ID: <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
Date: Wed, 2 Oct 2024 09:03:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org, hare@suse.de,
 sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
 viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
 dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241002075140.GB20819@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/24 1:51 AM, Christoph Hellwig wrote:
> On Tue, Oct 01, 2024 at 10:18:41AM -0600, Jens Axboe wrote:
>> Have to say, that neither have your responses been. Can't really fault
>> people for just giving up at some point, when no productive end seems to
>> be in sight.
> 
> I heavily disagree and take offence on that.
> 
> The previous stream separation approach made total sense, but just
> needed a fair amount of work.  But it closely matches how things work
> at the hardware and file system level, so it was the right approach.

What am I missing that makes this effort that different from streams?
Both are a lifetime hint.

> Suddenly dropping that and ignoring all comments really feels like
> someone urgently needs to pull a marketing stunt here.

I think someone is just trying to finally get this feature in, so it
can get used by customers, after many months of fairly unproductive
discussion.

-- 
Jens Axboe


