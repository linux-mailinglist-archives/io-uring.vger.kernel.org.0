Return-Path: <io-uring+bounces-2578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7468393B855
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 23:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 271331F23AE3
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 21:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86CA13AD3D;
	Wed, 24 Jul 2024 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xnZO97pd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744BF136E18
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 21:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721855091; cv=none; b=bRFkf4S1/kvp/yyAPm4GcvuCO1cEjzpKd3SL7i4UWwRIkJ2pYEF7mjxO48lKhMesgB8YIEHpZVfa2Kw6+RzOoJRZqfILCZtn8/FGUvE8whzAmRdjB2DyjG6pe3+vbr4iPLfsz/O9A/vgYSegwsir1EVfKLKlixsA+olWKDALU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721855091; c=relaxed/simple;
	bh=CHeYC9W1d47b/aww8k8E62+pwbJuSkQOvj4cEP+1CrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nUWsELIYS3DF7RhD6R47BQyC835aAKVWcLD2wPDSQ3rFTG44c/E9uCu8qpqBYA5cpPfxkJu7B2YDUil6TUt5/8gYjYxGeLx596O/5Hoh2OOlggMbrtc3zbQd3taXDf+K4WzRvlLOBtc97EYKmyxGIuQL4tuxkItiqz6J2WTBnQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xnZO97pd; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-804bc63afe2so1540039f.2
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 14:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721855087; x=1722459887; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P5FR53FnM4j9bsqovYq3dRDA4fvBTAx/Np2/J5mAWYc=;
        b=xnZO97pdrJ+/q9Cbmo6rjCOfoCp8zfWOVaP2Dspi4g+Ycc5DEHmEl7UTEmWsyblBV3
         OR8+Dc9LHohxobcZZTm7TIzhDy72OjAqN51EVSk97zOP8++xqehQ14BKDMnqxIyuI13d
         fwnUxyq/JF0oCtkd7Mag0thw78cllNl4c07Va2jcnMxHmCTAGrrjigtXsnl+0wiyLtEu
         q8gj+aDMlpRRPSHtlKTAAEqHIVfUn0bLuth5f8R7+SCG20rWdq9xXvgAkbMKjt/wiLDa
         q7/iVYKbwpq0vMGvpt0gXawJ4w2eVb4bBdFcQl6ggCeQnM1AovjU5SdryIugCvEV4tdh
         ieNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721855087; x=1722459887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5FR53FnM4j9bsqovYq3dRDA4fvBTAx/Np2/J5mAWYc=;
        b=KS2Ij/QiKKF20SJvHp8cXhIenDDPx8lqSbufRBreTygMN5JwEEVJ6FT4MARqvra9R/
         zq4WMOYuh4aYc1QiGBnq4V63tGdxQwotuZ+08ivVzmHR0QRCJ0Ps+NN8XweqsXRAkXHj
         8VmQEoIcIeQnvujYMfM/dkaIh4lZrfvLrbUcr4TOqBB+Kwns6ZSw20vcpFMzNpWPqKo8
         VkU4UNPg02rz+xosfFiaWXH5yUu6bDFYtmZldQ+0f4it/8neT2Ne5DJOqRvqX3dKft0J
         mNlzdeGjb00lXb8U3vwWu3AS5JVdrUfRj0mOZn64RQkHGuVyIl5ysgAvOoqFcUj1++Hd
         NhWA==
X-Forwarded-Encrypted: i=1; AJvYcCX8Hj1jewc4RFPa3yDud0Bj5Uk7B2WWkpZwbHEt/e/KViXi2pgqlePCtPkciG2E9hfDjjZ1v51Vky2/SlWXDaAPy2BRviGxlNk=
X-Gm-Message-State: AOJu0YyzDqn03YjUuRE5K3y/V/g6gpYPof/QZMYl8CFrRXv2MgaIzSTs
	HXy0ciOCS/RXNR3CNMNQCp5uW8k3afBAn2mkO7/NxpXj5+61u5tCQEKvjOWQphM=
X-Google-Smtp-Source: AGHT+IEaOzeK0O5UbyTTDtFYjiHqeN5WenoQZb1OoHTZenXrLhcCOyFGivw8jmZhFIRfjQBImMMn1Q==
X-Received: by 2002:a5e:c105:0:b0:7f9:3fd9:cbd with SMTP id ca18e2360f4ac-81f7cf3f757mr33863139f.0.1721855087435;
        Wed, 24 Jul 2024 14:04:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c28c9384bcsm584489173.100.2024.07.24.14.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 14:04:46 -0700 (PDT)
Message-ID: <82a0cfca-c1d2-4d53-a00d-8283ddd81621@kernel.dk>
Date: Wed, 24 Jul 2024 15:04:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in
 io_req_task_work_add_remote
To: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4fe65061e049a02@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000a4fe65061e049a02@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 3:03 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
> Tested-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         c33ffdb7 Merge tag 'phy-for-6.11' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d29bb5980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f26f43c6f7db5ad2
> dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=120b7dad980000
> 
> Note: testing is done by a robot and is best-effort only.

As I figured... No idea what's going on here, nr_tw is what is being
complained about and it's _clearly_ initialized. Randomly disabling a
branch that won't touch it off this path (hence it should be a no-op in
terms of code executed messing with nr_tw) makes it go away.

-- 
Jens Axboe


