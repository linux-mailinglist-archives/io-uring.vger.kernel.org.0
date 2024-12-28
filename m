Return-Path: <io-uring+bounces-5623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9474D9FDC40
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 21:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB0DF7A13D4
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7102198E92;
	Sat, 28 Dec 2024 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Am/PDj42"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B991940A2
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735419474; cv=none; b=nX75xTS329jociBSl2DcTGZj6+0FQEvaB5SbbRMEjwb7AeIfFppf5KBYc+Oaxl4qzL2VIqW3FpZgpHU2F1e8FcN7UDCJMEwVtW1tXQ7YTlrcARcpzuj9IfDbXMVe5QVDxreA0ZNJdEp16dDWrPiaoXb0kLDP3UT6QGAyLGVKX6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735419474; c=relaxed/simple;
	bh=e303w4tcLm5YyCF2TwZA3O59xcExz7hXhcGR8ejMpw8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=uxvzYwN4fP4NuhN8PIdLcR62EhrZsYc3uGItR9vTD0Vrxe0JZS422Pk76OiW3zM8LmWBtyhHD5Fpcmxj6bkENkqHBFua3ny/3YcvIfxxVtKgoHh13aVUZ1loych/K+l9PnIYMCTnd9eUYAoP0s6hygOLiF9/jcujDm4AL7d0hSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Am/PDj42; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2165cb60719so103607485ad.0
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 12:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735419471; x=1736024271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k2DOIcwAfGwnYzcdiIszZ+Rc+WkbTYCmxZzTdwLguZk=;
        b=Am/PDj42R5Q0k3picO6Gnd2arP9LIZaApLZXpktrTR3wuyGWhgyuzeuSA/6vYxxQ5h
         gjipy0vUTH9pVl6z5DS5cBWIC2h8H/rZ96FKxsywWcFqBUGB7QkvElMFh5g1XBMZ1qyO
         g8a0J/SMG3ImpyQ/n9IeSFtnFpxo57eBtMnll0IY/rfToxysckOy7x9+UlFrfbOi2+IN
         pCaWbnPDNwDKk7VhxLSzJeVxMyQlH+raCVHXzQ9z47YWpzg29NmVdrdTBgti1XSQ49+l
         Rud009lKFFxwbXjRZc5ZIoxJ+d07c7+pmdLfH48il4M3siBCk4m7qxOznUf6HkxDS+dN
         sdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735419471; x=1736024271;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2DOIcwAfGwnYzcdiIszZ+Rc+WkbTYCmxZzTdwLguZk=;
        b=WEjm3Y83SuORPWYJg7cZffe+jDda+rykMD2bIK1ljsz5RZ28pZAuahydoudMFUWsxE
         BXZztO1wPHkFZ/KdH+lPM2YfN4y1KXtA1tcsxHfXKjxCqkjJAYeMk0bXRezg+iAaLjzv
         9G1LSsLuRnB0NGrtyhW92IiiO9nf53EHIbumNV3HOWVSsmzbpYqx3ZW9jtgKm2DJ7LZd
         df9bOlBnamzuCif3OjgmNt+yz6pL2xcvT8dBb0BaE3Ck2ZDUcRCQ05bUfwM8nRsWGNpQ
         Te1i6DQHF3LCiGhfVDpqr6AN9j+ufZnLn+e8AwDA0pB0K9F1CFEJj8LnMWuqKAFm4sVf
         lHww==
X-Forwarded-Encrypted: i=1; AJvYcCUq8LcYymo1s607IAnHNsr9f9O5kV4sN8Ivxl97/KsgHZRe3yhRekEF1lMgmjMD/HUW2/q4feIzLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoKm3FpJmKE2nIKAcfBj9mz5W+wtmk0+nexxpgef2K3JMRSK8o
	t1BFE+OsuErpV25WrwC2gkLrqezSzoEIyQQYPAlp/vAF5gmYhZ1Eh9CfxwY9d24=
X-Gm-Gg: ASbGncvu2ScttUCm6lZfvovlMwc9L9ZyNivh3QqND90VNtwKSWtn5w6w6naxH9WUjJi
	qqLdmFin94hVM8qjQGUjVP9lBxnpBAeD3i0EPVj2fzESF4oBLuPkPZlT9ugEwvm7vDhhlZkqbeu
	EiAYLNI92ZAamuVV9IvtpIgHlsrG/0KiKgUhGQly/9HG0XTHd7KukgL+pMISI0LB6GwUa1O/osu
	u0Jshz0KDqn/jf1qr4r/Hurgji/T5Y6fC5p3bYN3i6vG5P+us02yA==
X-Google-Smtp-Source: AGHT+IFTUgCxF6uzXRRagS1HIXJ5TfNGwvMPXQ5hx7BAQzX3/gQ1fZgofRedLgDih/Y7lwP8VC9cvA==
X-Received: by 2002:a17:902:d502:b0:216:4348:149d with SMTP id d9443c01a7336-219e6f25d60mr484722485ad.53.1735419471375;
        Sat, 28 Dec 2024 12:57:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f51c2sm153174585ad.190.2024.12.28.12.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 12:57:50 -0800 (PST)
Message-ID: <0ffbbde1-b5d8-4a53-91e3-80e16da18e28@kernel.dk>
Date: Sat, 28 Dec 2024 13:57:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
To: syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6728a3a7.050a0220.35b515.01b9.GAE@google.com>
Content-Language: en-US
In-Reply-To: <6728a3a7.050a0220.35b515.01b9.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Should be fixed in upstream for quite a while:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

-- 
Jens Axboe

