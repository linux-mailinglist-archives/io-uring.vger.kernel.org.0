Return-Path: <io-uring+bounces-1687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 168698B7688
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 15:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9B681F226C4
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 13:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9CF171089;
	Tue, 30 Apr 2024 13:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IBJ7k9qQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076317106E
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 13:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714482126; cv=none; b=dlZ9A7vS+HghW95/hf98v9wgwXMZa1PMWx16Ezt6lhayePD0JMXA33KWueK6Yp79jgsH1lNy/iyhwm744a1DDHKMeDQSEzdFZdBfHfLBPpE3Vp7BwM6Fzqvy7uzf5SYKjCOM4JLj+dyl0GynX6hQE9IEZvq0hXSLibMgjEvesm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714482126; c=relaxed/simple;
	bh=x0I1Qmj51HRd25CAGrC7huRkSBCL0Ec9BX63V+G601M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBZkLZdYTVFgivPZcNXB7PdEON1noJhsobv1O+tvgy7A/KPCwaeK5RdpWACWEpoZ4QbaImUIAcw8VC+GBwBUymY+pI97WqiBJi4azZO6F/NwLYAWWYGfZBstyyYWvUH5hGyJcbWESDT9+Q2RrgfXvzqU/JOxrzPkB2VuEGg1dL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IBJ7k9qQ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2a2cced7482so1435272a91.0
        for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 06:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714482124; x=1715086924; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bBUn4zIkOBOgkUtqDlT28nvngjs1bCytM1U3h36CBkU=;
        b=IBJ7k9qQBiEvx/yGpQPlaKNo4fCojxg+ACV+CMk101GaoMCDtnV0aIvfYOG0r6RfSO
         j/g/Le6z1CT6u2SM8OoGHKplS2cW1T7XuBH+i0uhOEEm/WHV2c4N0DddZwCJL8K3H4Yr
         HtnOYDoOJYnqtfGzv6+XBurnmVP4ayxIl8tihdeq15UQnsrm/A6kD9CR0cnF9KR4NHeq
         V7vDfrA11XhZNLAxsaoHpiqslvE9t0D7Q1wJn0Sw4UluMKuGI0g6xRtge9ZYCyRoSpjF
         dixiDi/tVfjm1epmIOzi9OPRfTewbXz1limj2YCG5ktFR3cPGALUkADQ/TyabpjwBBQi
         g0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714482124; x=1715086924;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBUn4zIkOBOgkUtqDlT28nvngjs1bCytM1U3h36CBkU=;
        b=ap4FpHrmapyhC3U79V304efg+1SiFALUsMwd0MYJZY1Xcrf6annypZn9qnce42od+1
         2zUhm+Xx+Bk23Ukz0m7Qm0AqiycwaF1kbjgTJu65et+aGpWuMjRVyuK0iVUriTdnJ0Op
         iIW7LFBDHzVZvXh9Mnx6NB0qD+zALepFUn+jCvbkmzieKFpAKdCV1SRwKPwrSgi+tZRW
         gr1gce/dxq+OiayYKcjK4cFISj22MoFrjBBDZtU5IDkNwMEK+IMF+o3KCdK4X+oumBaN
         DTINsG7gEHR3/C7DLzJiToyBO6/5HG+5rvo+jQ6Cb0AULbrlgdPLm9Pm1pv/dt7wgtHj
         qg3g==
X-Gm-Message-State: AOJu0YzZDwan8WJmN+vSbX+5/kRdDnRybZg1bK76zUvxxnGGJz487/5o
	lNGHYZv+qNUz+Y33NlGdpAkf5U+9ansx8tHPsKU5ye8ZilxmhNm9tXpLoFrUPmc=
X-Google-Smtp-Source: AGHT+IEwCau5D6ffEzepu2nZ04nv73SBmrr7WDPQNqrTkl3UqxrS70xHHNnPUNDZJyzdotBjl689IA==
X-Received: by 2002:a17:902:d482:b0:1dd:da28:e5ca with SMTP id c2-20020a170902d48200b001ddda28e5camr15691830plg.0.1714482123533;
        Tue, 30 Apr 2024 06:02:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902b94600b001e426094bbasm22230246pls.289.2024.04.30.06.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 06:02:02 -0700 (PDT)
Message-ID: <909e44a9-c9e2-45aa-9eba-fcf10904e503@kernel.dk>
Date: Tue, 30 Apr 2024 07:02:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Require zeroed sqe->len on provided-buffers
 send
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240429181556.31828-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240429181556.31828-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/29/24 12:15 PM, Gabriel Krisman Bertazi wrote:
> When sending from a provided buffer, we set sr->len to be the smallest
> between the actual buffer size and sqe->len.  But, now that we
> disconnect the buffer from the submission request, we can get in a
> situation where the buffers and requests mismatch, and only part of a
> buffer gets sent.  Assume:
> 
> * buf[1]->len = 128; buf[2]->len = 256
> * sqe[1]->len = 128; sqe[2]->len = 256
> 
> If sqe1 runs first, it picks buff[1] and it's all good. But, if sqe[2]
> runs first, sqe[1] picks buff[2], and the last half of buff[2] is
> never sent.
> 
> While arguably the use-case of different-length sends is questionable,
> it has already raised confusion with potential users of this
> feature. Let's make the interface less tricky by forcing the length to
> only come from the buffer ring entry itself.
> 
> Fixes: ac5f71a3d9d7 ("io_uring/net: add provided buffer support for IORING_OP_SEND")
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  io_uring/net.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 51c41d771c50..ffe37dd77a74 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -423,6 +423,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		sr->buf_group = req->buf_index;
>  		req->buf_list = NULL;
>  	}
> +	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
> +		return -EINVAL;
>  
>  #ifdef CONFIG_COMPAT
>  	if (req->ctx->compat)

Why not put it in io_send(), under io_do_buffer_select()? Then
you can get rid of the:

.max_len = min_not_zero(sr->len, INT_MAX),

and just do

.max_len = INT_MAX,

instead as well.

-- 
Jens Axboe



