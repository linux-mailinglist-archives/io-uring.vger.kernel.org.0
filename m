Return-Path: <io-uring+bounces-10977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 65CFFCA6141
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 05:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 332213090644
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 04:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B3F28726E;
	Fri,  5 Dec 2025 04:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zn5wxoef"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805A8C1F
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 04:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764907521; cv=none; b=LKo8KFyhUF7Wvev1Y2XypvfOkAZqw+GdBgzuo4TG2WYBOmRTAC/1VDA56fZdnpMNn4FXrXy+dQ8pdMbiM+Rm/MyqdkpYIbjoBE+NMevW8oZ8ntmUvhmky0NFxdhIT0D5oUfMqq5NW7U6SgNgvP2nfpHSvo9zamUAP2zD3+W3YM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764907521; c=relaxed/simple;
	bh=GyIAzkZAg3GkX5CTyJK9ydPuCSSUC+26lX7bugcM1Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZZWBtsvlaPTnYenMGccGKracRvevqKYa5scxuJXHKfNgAsPjsFzIhMgF67Dom+Ny7Ny0rBVQo2mkaEfVHP4lXn7HZZtXQiXDvzimDWBnLvCordfhRa9y7/4UlAjuh8sz29v91SPfs263EdPowByt7jKInc202vDOzUZ+2T+DEy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zn5wxoef; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-656d9230cf2so1146557eaf.1
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 20:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764907518; x=1765512318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JQ03qJzwSGNPzbadSoBvMIxT2cnpqtrGFQzqppycE5A=;
        b=zn5wxoefKrUWje/lhPhLheZCKaM+lSCMYPPkLsONA+cKVu0OKArVaeR2qiFj+9jJy7
         jxQ3NJIzJS3E8ZzpfzKO2Iw6AeU7Sls1WuzQudZnLt+jnhxOfARTz7xXeyOz1bUdulAf
         4g/U7wtCUVVNgSnbiYZbEKncRSB/P3B3ju/ZONk3T2np5ml/lDSwQzjGMWZsG060LuR4
         b6Iq+S0TL37UiLcogSEPdQg7JECHKKBviBo7gYS7yjL/gshzYDGyPFLfnhB2uGtU3ZsQ
         xxpckgjpWQLGjEZMDCHILfA20N/BwKd1A5qwTbpGPS7EWVcuUTty32qaXbW2K7F6auKT
         QH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764907518; x=1765512318;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JQ03qJzwSGNPzbadSoBvMIxT2cnpqtrGFQzqppycE5A=;
        b=j9oUaqk3cHc7P0sUXHKVo2BcqVKH04aagPAtlSlEbQObpbChYv2pCcLzmVWrPkLiRd
         X1VJdx4a7hq3j1rrtauhxPw5tvTUjGqZ0lKQbtgP09F4NXUIffonc22RQQ1e0VwvWphN
         1Psnd/RazIltkLrrINEskWEEJ3Bs0FM1zDzMwFTH5FxftCPp09f+VWsFX0OgF2SJXWMZ
         tCQNx7EgqwM+NZb85cNCCBOAAR6u7EhGKnkvfbSm3iQi718gacsiZj439pMv4XocM+Yh
         FzBvLh0xCR+0KvPOcz0d8WYe+0FRXlkV5yFtaa0uC9AQr+lz6GsdC540L8XV2SIFAQyZ
         Sh+g==
X-Forwarded-Encrypted: i=1; AJvYcCVoP2HE1i61wa3uo+2VVqe+rGkbNLQeqxwphi33YI40k4ZkfkuqehOSuTSyR33gp0vUYxQ2FaJlFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLA6gEExwtT71gs+4RdC5kA3aHZEvPImIu4X6kMc481tnfPjoe
	rL3g6EWtnk/fF1BWvo6F1y6CxZQo+a3s2fYAH0AhF9xdmQFgdgawSWXYECjnn8/D8WY=
X-Gm-Gg: ASbGncun1JNASfsOOm6Wr+BMnc65mpx2aAqd6p0kNoasBnBBavwcKDmmCHIToHUj78W
	YsDknkIvQtIzeqdfBTyAmAiY7h4LMUieHFDONkkRr+IGFE/9Ljl/856jbfi/CWxlFCV3mfSSqt2
	Xl/oZvZUwc39tWWfBu2EarjJBkd95tbXF79huQMH5+S9yL/pNVN3CTt1HMTR6FvQOeq/N2LwRd/
	GHwNG1Zomum6YXWsZWRqVL1GKm5L1FZr4ZahF85TGZvTiJSlgC8dDN1TnR1OBRMqV515U1oj+qd
	9L/9ANyQzW9VvyW6YIQGG9VVyv8WF5xMfbBuZ+nN/dL1goHUOLsi0TVW5/yfJBzPkf1KXBhOKsz
	oHR962fMtOVJpndK215oWXbR9ziTakn3c4gMWfBpXimtyU9KdHaMGsJRunyuD1Qh1QmWHDPbTpu
	6iYlm8XFy2
X-Google-Smtp-Source: AGHT+IFoW4OlENKlkoahMbh8zbazPyj1qkqtwg7srDB76rJfxwtoYnGEVrudV9eOmRQV0L3vNwmpbw==
X-Received: by 2002:a05:6820:2085:b0:657:4bbd:49ed with SMTP id 006d021491bc7-65972735988mr3896218eaf.3.1764907518587;
        Thu, 04 Dec 2025 20:05:18 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6597ec61d03sm1712918eaf.8.2025.12.04.20.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 20:05:17 -0800 (PST)
Message-ID: <9f1d144a-56b8-481a-bfdc-409f3b7e7e3a@kernel.dk>
Date: Thu, 4 Dec 2025 21:05:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] Monthly io-uring report (Dec 2025)
To: syzbot <syzbot+list2f3a8c0dbf1ef5c21483@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <693213bc.a70a0220.2ea503.00ea.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <693213bc.a70a0220.2ea503.00ea.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/25 4:05 PM, syzbot wrote:
> Hello io-uring maintainers/developers,
> 
> This is a 31-day syzbot report for the io-uring subsystem.
> All related reports/information can be found at:
> https://syzkaller.appspot.com/upstream/s/io-uring
> 
> During the period, 1 new issues were detected and 1 were fixed.
> In total, 3 issues are still open and 128 have already been fixed.
> 
> Some of the still happening issues:
> 
> Ref Crashes Repro Title
> <1> 4212    No    WARNING in io_ring_exit_work (2)
>                   https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
> <2> 46      Yes   INFO: task hung in io_wq_put_and_exit (6)
>                   https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588

FWIW, I think we'll keep hitting variants of this, as syzbot tests with
tons of debugging enabled (for good reason), which slows things down a
_lot_. Then it floods the ring with work, and cancelation/exit can then
take a long time. Whenever I've tested these reproducers, they finish
quite quick. Until you enable all the gunk and run it on a slow CPU or
two. Hence not a real bug imho.

-- 
Jens Axboe

