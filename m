Return-Path: <io-uring+bounces-8560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E69AF0349
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 21:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D3D21C06095
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1656722A7E2;
	Tue,  1 Jul 2025 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KrGHFDHq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2A626E6FE
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751396644; cv=none; b=Qqg8mslDeaXMVdh31/JZL9kzuHebPzVWnqYn5SjnYludccxMBtvSrX+FSKSdtoOSWrY7An2TA2ZCyeADaWrTo261QrvQzUhHQ/8nqOkCc7StWwLwRLGIpwFXQe/8Nu5/05g0bqHIlQlGHIWXadjnE1BV4T4U258O8QBu+gH8aMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751396644; c=relaxed/simple;
	bh=cwAPXgdl+hKLrBAUN++bv9WfGRh0/jEqtxFs1hUDy+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbDI1dAED2WIFmw8jS4bruthAIVnbrByOv+r/81qVs1yqYSDsjDBf41/APYulbwK2OK/M8/oPTdiahpsTNYoxU6npP8mmyzJ4fSa/0h60gymIq2FnkW+Z//1omKg1IhR0JKmRaMlJBvbji4ycvMvghGHL0UWOIRPbrbsd8OkRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KrGHFDHq; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3df2e7cdc69so16943525ab.2
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 12:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751396640; x=1752001440; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B1OO9XKq5rOhwEPdCxdc4lC2/SKoAK+PxaPLLCcb7dc=;
        b=KrGHFDHqFa1Xh63PvlFyS6Wjnrd7ik4zMEAcs8o0uWHPAz8KILJWgOXpUlicUgexAb
         CkqP9UihNXPT7+O9aRExZXsKbEZevyE9tN9Sm0sC10XE5V6BJMjblVzuUG9cfyk/O8P5
         FJKQsXE1TBiPrxXSs4p9GCuXj5txC5KP54Md1P3UHdOozdQ63bqU3phyGCugyQAtLDdv
         oiU3OZg2413JKlaIt0bzL2VkT95rfs4DEMhxnpPFgncE+RK5katI0rkhQUf1sIHAa37/
         QuzHbCfVrKvKL4XsdBzkgKCMWX4oy/0HTJiF6lwwJx97ioKdtfZoe36vWlC6x/V6crk8
         ZIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751396640; x=1752001440;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1OO9XKq5rOhwEPdCxdc4lC2/SKoAK+PxaPLLCcb7dc=;
        b=FSiBydgjhJyNOztyysGQmkcKdRF1n51dTVZM6eMuKteRiYONMvUb5asp7GDHS9cBBk
         w1vK7BJsR+zyEwS0C2nJI5LGB+0JreH2bYC7+fckafUWPp7583yPP6jThalR1/uxm60o
         huQiSKto4f0AyHgKWFRxovtO1WwcyazViq1kfhoNqAyCTGe7DwKVjN0vcvDdoykK0XC8
         H5LBdATGT1dqBKZYOFaw1oKH84VALuqAALCKcnCiCkoPVlbMbGs+FSxINwrcWFrTdYFt
         DoCXom+8ydwZygXPu17ROtO9fbuNVbyeHI9UJKSJUT3xflzbjGHrJ8uiqAZBKe3mX0DL
         feqg==
X-Forwarded-Encrypted: i=1; AJvYcCUJrefLnNOPXNXLGe3M6p1GYXs28iAXbQiAOXc3T+ABOX6d4AJ4Owmk2hTTqT3bU7JwMwO8KG5zJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzleHg6/LiGOBRn+a6bg4KlFrSTbkiWJamVlFJSRtOUpjt62j79
	b5wX1qr6ip+kVtHqJu4oJMgSwwEAkUx8Ps95SaBxFTg3Uk70+2WZpNiFJif9aW8aHx0=
X-Gm-Gg: ASbGncuX+vgqAakXT6Uisxk44+aJM8Q2/XjJLC/tD9Bu0oHDtlD3vbG4yNgPBYJEKHY
	P17WKD8cocfeI33RkKJ7oPMX3Dy1p9Nl3HpxKMIxOEf88+ujmUqHhc7BxUvZrWwD/JC5oE4p1Mq
	TqAyNPgXtaUanRH68fxJ/2z+k/f/6yPLW/gWMRMS3rkkcsSKFgIeif6LVRASX+UmbtwdhYgLjzw
	aKw/LXuGQkt4aFoxRiBMzgQOFiFn1h/1ttLrbEBC+OzITDD3uquYIKrO3ZOYapM9UCHlyfdGtvz
	sLlvRtoAzb2e8WTtpOGms67RqfueBv5Q+95ZsXr+A6G8qU+zcSCzSDAwM8cQcB+jyIDs
X-Google-Smtp-Source: AGHT+IG7i3qoJ1qUqfQDZSOEDLwZsJ/iz/Ni2hzM4Q/Bn5B1fjgADlo2DriX2xo8k7cBTXFyqEIbVw==
X-Received: by 2002:a05:6e02:1d8b:b0:3df:3bc5:bac1 with SMTP id e9e14a558f8ab-3e05495ef63mr1597045ab.5.1751396639972;
        Tue, 01 Jul 2025 12:03:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204ab618bsm2596889173.124.2025.07.01.12.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 12:03:59 -0700 (PDT)
Message-ID: <76d3c110-821a-471a-ae95-3a4ab1bf3324@kernel.dk>
Date: Tue, 1 Jul 2025 13:03:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
To: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-3-csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250619192748.3602122-3-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/25 1:27 PM, Caleb Sander Mateos wrote:
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 929cad6ee326..7cddc4c1c554 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -257,10 +257,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  			req->iopoll_start = ktime_get_ns();
>  		}
>  	}
>  
>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> +	if (ret == -EAGAIN)
> +		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>  	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
>  		return ret;

Probably fold that under the next statement?

	if (ret == -EAGAIN || ret == -EIOCBQUEUED) {
		if (ret == -EAGAIN) {
			ioucmd->flags |= IORING_URING_CMD_REISSUE;
		return ret;
	}

?

-- 
Jens Axboe

