Return-Path: <io-uring+bounces-3416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3340A9904D3
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B07A3B20BC3
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 13:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9FF1BC59;
	Fri,  4 Oct 2024 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v3txtzRO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD520FAA2
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728049818; cv=none; b=P2sccCfc/3X4xUlwyPBGfzdkxn4X5+Wmp1m0CHF0Nlcb5GvbRpMMlOIWUY6Xk2fV8m3LnI7NRGAju+MOCBzQqgYDxmGvXLfqvrLuVeI2nnYRGTOhkOlAigh/CNiAhEY7sx55S2SSTa2daH0DAotWw3UulSd/FDUEYJHRnpZjSe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728049818; c=relaxed/simple;
	bh=vDW/Tb4/0/w2k1GStr4Bxd6VNyxBFmWkOjvgKb8O10U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfWH+6xmtdDEKTsZsEjcIjqB2SEPLjQOTjeCDq1YcwQ3wE5buDJap9j0lU9Tw1hNYlQEPAOJ06hRMmyHqYkKNlh45eCSsXGqJns8FAAcoS18UbM4wW4Qmjxxud2hvKPN2VTD8+EIcVxW3UZLufrA4NeJiKXLUz7doUKjyzrPW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v3txtzRO; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-82ce603d8b5so98149439f.0
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 06:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728049814; x=1728654614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vvfHmf6WgmPp7+mQWC0QYAt5wudV/fwmBgIGJSQerZ4=;
        b=v3txtzROjZ+SExHWpcbqz1BBP8XixqHR8HVL9SMtv+1A+AgJw4jPENIjsyjM8ss2DA
         uZDf7CYXaMSF8hwcpztW/USRRHHqUtfA+RydKe9HR0vAq06QX+Cd9ezjPhpbcd95miqp
         gmWA3zRGgsMWHvnku6v13Q+EkkqzIKQKyZTdt+02u9WYd0fUyMrjgQtfyLUmWGb+n6AX
         RF22elzssQYOstV2LR6ORFc5qrFW7LNamd4eVG3EwnDNUXRW2dFu26EUrGMLuE8wQxtq
         2T1/yHWvuEYuQ7Wh5ruK0/RnFpZdlg97L1Ld8A7wj1Y67zPfOQgv+081gba2PtEEtUae
         RAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728049814; x=1728654614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vvfHmf6WgmPp7+mQWC0QYAt5wudV/fwmBgIGJSQerZ4=;
        b=gET/74jyKi3XteOiwbxtUWMqPVnymNz+Q88+U/9CRTRAdogw8TP/hpKjcjIAYNMvdv
         7abW1+Shh9Ho6UUGl8tUboU24q0nnsWbviVaLbC5tos4tqzppQ0QvHT+Zt+MJ38HBB/Q
         jOFC7/WKAAHIUN9gRGkc752bGvcwXvnr1Ffzd4sUmLxMvG7e6F3Qn8ZXMSifq1cFQYm3
         5iFDHIiaoqH11NI+nqJUhD8NckCfTFVpFQ/tRZBWe/bDqOgF1AWfcmMTkyURDBM5hc8q
         lTwlq5GuizUP4VeabL/buy2xGOIQuWs27Yieu1XLv+SqMhj9K2zxeQI9brI2BJxzvIOI
         9hXw==
X-Gm-Message-State: AOJu0Yy2XvwU0tX9hlQcNDlMY+BV5dHCZgLcxB73TlPqjtH8wmUnXq8D
	YaFsftGO0N140bEX6WuY3+8npGJS/gu9tUZkhVoUvC2RGAIhPmi1s6gbsbxbqbo=
X-Google-Smtp-Source: AGHT+IHA+zI7dFTE2sm8wwiPyLYCf4QwJOQYInfNnQOTA42PBmHHr/XV8gsqM1gT5Rzy37HGCKU4KQ==
X-Received: by 2002:a05:6602:1341:b0:82a:a4e7:5544 with SMTP id ca18e2360f4ac-834f7cb2762mr348752539f.9.1728049813807;
        Fri, 04 Oct 2024 06:50:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db559b0099sm729613173.77.2024.10.04.06.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 06:50:13 -0700 (PDT)
Message-ID: <2f2cc702-609b-4e69-be1a-a373e74692f4@kernel.dk>
Date: Fri, 4 Oct 2024 07:50:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/poll: get rid of unlocked cancel hash
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/4/24 3:00 AM, Dan Carpenter wrote:
> Hello Jens Axboe,
> 
> Commit 313314db5bcb ("io_uring/poll: get rid of unlocked cancel
> hash") from Sep 30, 2024 (linux-next), leads to the following Smatch
> static checker warning:
> 
> 	io_uring/poll.c:932 io_poll_remove()
> 	warn: duplicate check 'ret2' (previous on line 930)
> 
> io_uring/poll.c
>     919 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>     920 {
>     921         struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
>     922         struct io_ring_ctx *ctx = req->ctx;
>     923         struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
>     924         struct io_kiocb *preq;
>     925         int ret2, ret = 0;
>     926 
>     927         io_ring_submit_lock(ctx, issue_flags);
>     928         preq = io_poll_find(ctx, true, &cd);
>     929         ret2 = io_poll_disarm(preq);
>     930         if (!ret2)
>     931                 goto found;
> --> 932         if (ret2) {
>     933                 ret = ret2;
>     934                 goto out;
>     935         }
> 
> A lot of the function is dead code now.  ;)

Thanks, will revisit and fold in a fix!

-- 
Jens Axboe


