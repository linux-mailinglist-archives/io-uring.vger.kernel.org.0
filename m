Return-Path: <io-uring+bounces-1023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A79C587DA9B
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E7621F21728
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 15:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93A61B968;
	Sat, 16 Mar 2024 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UaMF2i1O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874A819
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710603986; cv=none; b=DjkGTwukiTPs3wa0VH6N469pDFBT1/S/CL8xattlyqy5sKK1p7dMhD6rHcXs3HSs5rQq3FntxH5eO5FVTL3852iFa0r/sNzZUrM/i45+Z7vVz2S2sNn5OAdzp140KACfWG06PDyU/baycIkmAUPbDh9FneaCW14BKmwxWMik+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710603986; c=relaxed/simple;
	bh=2ByWo2corbpanCdZc6olc6MTEjRFTonpZg23vADVL84=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZRt35balOSHUT5LYhRM/rs4p6Mvx07RRzp7rdqgUY0GrnLgNe0FuHXZkRW0BVGHJQkjFOxVs1QQRxkWNz5Pkx3ylkeMIooyyUW13QjFQlamVNiP1mKN1uVOtSUmaBTsrJQvg/g0tKXrWLQSOQ/YJH/A619yb96mWrkn9pmcZEfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UaMF2i1O; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-29f8403166aso59155a91.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710603982; x=1711208782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l1GX3XIfnZMHp3GXaXprqRG733TAKKEo6zwMZIVGMWI=;
        b=UaMF2i1OogRmHaxO/GIIBpNqd2e9LwgNRC/rZSYg/9f97htIdjvd4qMQ2JKLgYcAJd
         fQ6OmotpU47dnbOnhWdsJPScDLl4pghSj3UVSpfNSx22FtWYL3Q2eHx5bLIBx4s7jYIA
         /mkdFFPXKzgSgUv4lT6hFrc69kdrFvH6vo/dvvJJCz3N8T+NhDMYUaCXtHM7vmwHvyTI
         hRQO7BE/QwDKVG0J+eyeY+oGB8p5GpmuAOan3pio0njmhjYkoYQN7ARssjfDuEsYj/kq
         mX0xUZFUN7pwrKmtyQgDOCb2+JTPDLbAD5qqEPOmcBpTl71Pj6se+gXr9vet1yiw2t/W
         T9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710603982; x=1711208782;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1GX3XIfnZMHp3GXaXprqRG733TAKKEo6zwMZIVGMWI=;
        b=jLD+WZ8vRj95biVyz0SMCMRNBZuZx9map463VpVKkBBwXOolWd/a3eOOsu882ey7Rt
         XIdXtYWP3MwG097nGQw7fGFfqCR43CLkEYpSKzEebS2+ITjodLPF6EiZ6UxDz9Okm2bC
         Qxs37pX/+4Th3X2FwExG4VVV/Uu9zxCQcAewXuvK6QURSwo1bd8TPQPLeQhftVlXx+/7
         62lyQYimVsHmXPISYh3r5sbkyY5IHkOeYS8zVKbsWejnkQf/EqZAoCGSiYc2Hff0vi0S
         DBdi/irIETwpfG12bnAds3KOz8N4WBYPpUGUuPgjwpFRwEqLgxC4UGlORinLnvJBkTiE
         O4Kw==
X-Forwarded-Encrypted: i=1; AJvYcCWa5Y3dPhKJMet3FG9wblIoICbCUQjsnZ6S4HjDAZHuvKLsWYEIBOW7HAepBBwFz3MImuUg9Md0SArK6Cfu07xAkpm2WKodJXA=
X-Gm-Message-State: AOJu0Yy4x+PJZUrkoRZ+l/pKA+fk95UbkAvp0fb/4peYyk3ZaF1HBuYG
	nRi2sFnqGH1mKBQhY4bkCNSYzfbB89JLn6hChRL/fMw7G+DacRhOWeqr/rvvYCA=
X-Google-Smtp-Source: AGHT+IGBgfJzKl16vn3WodT4a3V5+e4fWUcA5KI0QVDIB4IitGGDkgQJEOeInxPG2sNQXaCnMHgpxw==
X-Received: by 2002:a17:90a:9f87:b0:29b:ff24:4426 with SMTP id o7-20020a17090a9f8700b0029bff244426mr7024721pjp.2.1710603982514;
        Sat, 16 Mar 2024 08:46:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x1-20020a631701000000b005e83b64021fsm652474pgl.25.2024.03.16.08.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 08:46:21 -0700 (PDT)
Message-ID: <4febd8ae-8d25-41b1-81cd-da79002b09d5@kernel.dk>
Date: Sat, 16 Mar 2024 09:46:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <0000000000003e6b710613c738d4@google.com>
 <fab71bfa-7657-4379-8c79-1f92766a7b17@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fab71bfa-7657-4379-8c79-1f92766a7b17@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 9:28 AM, Pavel Begunkov wrote:
> On 3/16/24 13:37, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> KMSAN: uninit-value in io_sendrecv_fail
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 3ae4bb988906..826989e2f601 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1063,6 +1063,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>      /* not necessary, but safer to zero */
>      memset(&req->cqe, 0, sizeof(req->cqe));
>      memset(&req->big_cqe, 0, sizeof(req->big_cqe));
> +    memset(&req->cmd, 0, sizeof(req->cmd));
>  }
> 
> What's the point of testing it? You said it yourself, it hides the
> problem under the carpet but doesn't solve it. Do some valid IO first,
> then send that failed request. If done_io is aliased with with some
> interesting field of a previously completed request you're royally
> screwed, but syz would be just happy about it.

Yeah I agree, as per my email. I think we're better off just doing the
EARLY_FAIL in general, and forget about the specific case. I just wanted
to make sure I wasn't off in the weeds, since I can't trigger this.
Could probably write a specific test case for it, but the syzbot
reproducer didn't for me.

-- 
Jens Axboe


