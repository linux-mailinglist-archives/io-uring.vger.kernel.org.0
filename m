Return-Path: <io-uring+bounces-7070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BB6A5F12E
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 11:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6431B3AB161
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 10:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAAF264FBD;
	Thu, 13 Mar 2025 10:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="W5ZpnldR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837161FBCAF
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741862661; cv=none; b=hp91IBdUsl7w9dh7zLPr5XfjpY2iGlfOC2GKZFaj07v+Yp8A44PN8BTyhbGth1dc6KfGUk1HKRaSOFesEOpA71oeJO4pTtMMT7Yu9xd5a6hJx00/unmwgxxv8a8fafUe0xcr/fEF+v3Wzo1O3QJdSXvsW/ib7ncmqtCldVM159U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741862661; c=relaxed/simple;
	bh=cdJZRMBGrkonFB3hvNUzys+FuUKN9910SmSB9F1d9xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlPeFJKUx8meD+y5ltE93He9kOcPTftAN1Fl+o5jsTfoDgCMi0ReZZYOHFPSH9jhPRXTSCSdcAkakneKo/vkfqkNYUGPKQ4x8Z7CH9GrFX2ogomTCZmriIrH3Kzy1gboeJAmDb1EJbasE9AFkQvS0rSOKVsWiGy+Ort7610VtUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=W5ZpnldR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ff65d88103so1367819a91.2
        for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 03:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741862659; x=1742467459; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ek1S1M2Z/3jRrIpDz7olPRb3vs2yw04VJj39Sas7Xhc=;
        b=W5ZpnldRQfxcSJJinZVeOcGGXQfAX49Kypw13lm1k9ifGsLkO2alZ2e/WEcN9RxQA0
         D54te9B60rKU0TItcrivmXHWUgw1+VNTi8TWTL5aKNhu5bG+Kgh+VAFPGdgdWLJmn2Qa
         G/Gbn5Il1b+KVPrdM0fE4ECOns6zvhuEugCN4+FLA+kBK2UIeLIP8ZGTOllycjybHD19
         PsVKL7TGiKDcRtt8dLu8RG4snOzZvJtt0MpH1BIHlDk3GO67DZElgpaNPXtAyKBlG+86
         TXwhrYFzhZNyYQVZjN8e/IyxV/caOpcn8ev4/g2wrzLGAeslKn0TUkfI+lPtF2TIyu+y
         hkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741862659; x=1742467459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ek1S1M2Z/3jRrIpDz7olPRb3vs2yw04VJj39Sas7Xhc=;
        b=d0lpM2EbhUrYoE+lEhQSeuSmLUa0wT+OUFZfWW/I+bkiqIjy33RmSBnmTyykKdGY8O
         5rg8Y4mKsdu4lUsQcjYDf6RREx37aWcXg+shPsN7zECsB1ogsCm0meDQBy0xVvVFroz0
         nUg8OgI0uF/0wUUbR5ed08b0M2U33wvYWsHZ3LqQILjeHz9KJMm/VDr05TpqqMU4BkV4
         04AU3+1+utTjd10MrN8ebEWR/VAiRoAh2se5PToOnRK2e5jbTKUk2AU2Oiwj4m2kTgLo
         hNCRgxboqEGf6K2sWzA4IWxtQcFTMJxiLzB8UEvbBI62vAlWEn8Ak6JgAjYsgK/BEnwQ
         ZU+A==
X-Forwarded-Encrypted: i=1; AJvYcCUnXuAuhqSexHgMlcLyrPZyRJgJsIyJHUv6VG+Zl1Ona2x9UDPHM5Qq+JtzW7BO/FXXHz32tu95lA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj3nWRwdtuu7yz/AxXUdDqB9xIb3aWzF5Lg9ukYu/E1ONd1PaW
	7zNaJUb6XO+gPXBBuvPNvM5QznYk5ze1FEA24yhgkJXSMhoIuiKMs6z3TeQ5u7/WTfgZ11iYOPO
	V
X-Gm-Gg: ASbGnctc4xkNcfVVnkLj5TJZ1hOVuo3Z4NT1JSOI8EDpcn6p51fTyqLIt69gJg7fy0H
	BT0MoCB0B78lPE5XPE9PpgeN14ToFUiqNsAKi1jLMOZHVYIiGCnU+KPDLXBzFysBLFS9nmt6qnF
	uEfsoayws9jyd4CNWJffVLXOVxllGm0dZNNoLriy2zjATUxErcs62SIT98XxXOzFUoXE7hEHnbX
	+kaL64DlR9OOeSmLAEFdBChJ+7WAaCvdLfr4+wOB7sjodYLBmk5/q2LTwIgJjH3Uq3VA1WV/jzC
	aNFXvLULrfZq9keGUBlc8rfRtvGUN+uBR0HmvG8NoG32AoO+u5T129OJZKpCeHEuPAYlKgBOE+T
	D
X-Google-Smtp-Source: AGHT+IHsVelts5SRr/WJziCKIuWWVYPcap8L5SU4CGAcvx6m6TS5z81715eoW1D7sFPeTWFvFyFeiA==
X-Received: by 2002:a17:90b:17d0:b0:2ee:ee5e:42fb with SMTP id 98e67ed59e1d1-2ff7ce7abc1mr36460554a91.13.1741862658705;
        Thu, 13 Mar 2025 03:44:18 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3011928706bsm3493605a91.46.2025.03.13.03.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 03:44:18 -0700 (PDT)
Date: Thu, 13 Mar 2025 19:44:10 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
Message-ID: <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>

On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
> On 3/12/25 14:23, Sidong Yang wrote:
> > This patche series introduce io_uring_cmd_import_vec. With this function,
> > Multiple fixed buffer could be used in uring cmd. It's vectored version
> > for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> > for new api for encoded read in btrfs by using uring cmd.
> 
> Pretty much same thing, we're still left with 2 allocations in the
> hot path. What I think we can do here is to add caching on the
> io_uring side as we do with rw / net, but that would be invisible
> for cmd drivers. And that cache can be reused for normal iovec imports.
> 
> https://github.com/isilence/linux.git regvec-import-cmd
> (link for convenience)
> https://github.com/isilence/linux/tree/regvec-import-cmd
> 
> Not really target tested, no btrfs, not any other user, just an idea.
> There are 4 patches, but the top 3 are of interest.

Thanks, I justed checked the commits now. I think cache is good to resolve
this without allocation if cache hit. Let me reimpl this idea and test it
for btrfs.

> 
> Another way would be to cache in btrfs, but then btrfs would need to
> care about locking for the cache and some other bits, and we wouldn't
> be able to reuse it for other drivers.

Agreed, it could be better to reuse it for other driver.

Thanks,
Sidong
> 
> -- 
> Pavel Begunkov
> 

