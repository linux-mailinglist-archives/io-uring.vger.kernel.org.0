Return-Path: <io-uring+bounces-974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB4387D151
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DD781F220C3
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B7044361;
	Fri, 15 Mar 2024 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mjcTznr0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C8B3FE47
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710520998; cv=none; b=tXegLLgkp66JJOZ8L1kwtJ7c8526GatiDXZ6lZ2D/5fEjL9aKqjaPWv6Y8qZQpA4IehjKoUpQw9VIBkFCCQ8VNnpjnQdE311rL7gGdLDBlnfj4un4UnfX1Kr/iEL/rAsBCZrGRYHUH2tfxP+HffY9rATlWnVwHnn+oJ/9DFm2og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710520998; c=relaxed/simple;
	bh=KL2SdFZI6xj14E9gdnKkJmRkYlKkUmM4EoGRsI93QtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DToLJ6emmcx1geA4SISHkQbGqjEH4j8yXGEgcrbrvTt7K68bgkxcg/n0agrDhKLt66MH2uRKeVe48wusCRqI8+u5dIqp0m0xko3vnXF3L25+H6r1TGxC7r19Vn/yijzT43HwuN46MkwDkPRVvG3NceH0hadJ8oc9+NLFHfUyCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mjcTznr0; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3667b0bb83eso3086675ab.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 09:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710520994; x=1711125794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NnYrkeEuyooTzIwqpfS+gG0pSUcxJ+MtV42LbV77NO8=;
        b=mjcTznr0AnttCmWs8R630cdqUoVvTyRfA2XvIzaCYQalCB+oC+Dn4yVxntdM+c7K4o
         ISpJMxFnoyZCUP3zbAPIeRcopPEjjbuBW3UDAZYZBMCZ8chnvewDkygBrQqMNmwhrtBf
         voqsNaeq7k6ua5gktQiGIwWGBb1mjSj5T+Dw8+YifwOeTjJBlKczopztKOzh90LsLE+B
         uzPDaBw1VXpUvU/QKmBhFj2T3IhdqczIL4IAFS+xsNjkP+BW2KfgdxgCCDX2CqErBIIt
         xdfz66AcD2KrOH4JhCoLQTylykypZYxKLyuzRXpvlDql22u2LOknTwcwwGRYAPAH6Pt2
         2seg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710520994; x=1711125794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NnYrkeEuyooTzIwqpfS+gG0pSUcxJ+MtV42LbV77NO8=;
        b=X/K6572s1jIYAbcUcSZ5JhyUhHe4co4VPXVPdb9xme+6+XXtpHnNXGdg7rokPPwuhw
         u1xX7IMuJUTxad3N7mXMrPGwIMmx+W3lMWFpbDKoZJOspL1WrxUkHNQElfjGyfjX2Zob
         0qByqoqMCQA+e1qiRZ+RXu5wYIsuUS+9AI83eMT1lBVl4nBtBwQuEsbcg38wJ/D0xtY3
         G9drY/3IKcfGdXpz+D+8Qz7yXhMZkZYt2rJY5bekg49VdovlAwZRoRmWInILkt3gS7Ht
         6S6+5HmO/C8Csyvw3mmR0koInwZdlhkc9MAaHc/J70IKNqpeGiXIZR+uyPXIh0D+yOYc
         yYww==
X-Forwarded-Encrypted: i=1; AJvYcCWvhFaK7QhiZ8cihreB9J0mREz3iRkGZuTz+U5HNOVPKg2tULqSGddSWIQEnlFnJ1IxlYXhm00nEgZvXHX6WB3ei2/KFlgoZ9I=
X-Gm-Message-State: AOJu0YydryjE1ddvY9k1Y5l3Xpvigk+XMiS0pDs3NZd/k3z8Tr0Jboev
	nHQL8BKzd1IsKGiBUWmH1xGGK173ReCqj5D18lA2BPFZ0+4timN4ERmmXEiy0PU=
X-Google-Smtp-Source: AGHT+IHw1pzzO7Lbgj3rvUe5D+ef6Gi98W/ojPiEC7bSUDtyXI2fQLppD6zQr3heqjbpOrSMGqElPA==
X-Received: by 2002:a05:6e02:1745:b0:366:7443:c9f7 with SMTP id y5-20020a056e02174500b003667443c9f7mr6765962ill.3.1710520993934;
        Fri, 15 Mar 2024 09:43:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a11-20020a92d34b000000b00366958eb5e8sm505837ilh.74.2024.03.15.09.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:43:13 -0700 (PDT)
Message-ID: <ed44cb26-7d23-4391-89c5-0e7b59d019f6@kernel.dk>
Date: Fri, 15 Mar 2024 10:43:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
Content-Language: en-US
To: Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, io-uring@vger.kernel.org
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240315100159.3898944-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 4:01 AM, Sascha Hauer wrote:
> It can happen that a socket sends the remaining data at close() time.
> With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
> out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
> current task. This flag has been set in io_req_normal_work_add() by
> calling task_work_add().
> 
> This patch replaces signal_pending() with task_sigpending(), thus ignoring
> the TIF_NOTIFY_SIGNAL flag.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

Should probably also flag this for stable, 5.10+ I think as the task
sigpending got backported that far.

-- 
Jens Axboe


