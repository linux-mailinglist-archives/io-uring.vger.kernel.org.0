Return-Path: <io-uring+bounces-12097-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JuvBsHaiWlFCgAAu9opvQ
	(envelope-from <io-uring+bounces-12097-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:01:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B9910F525
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B29533001A43
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 11:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE30B36BCD1;
	Mon,  9 Feb 2026 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RQFlvX7K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2798234A3D8
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 11:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770637352; cv=none; b=sjoXi2gPxlUJX48bCAvaqwMEa5q0V6gEXZhBE1mRi9/nj1sBIWrBDASXkyE7ocoKTp+Pyj7GL1I5NQ+slgfK4PUrF3o9+QyRizH+yyd2F1N7OT/JaIsCBES2PK8sIzXEvGvlcbugws0QKXLB9BokM/zrMRW/Rc9uJNAOvSh2qJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770637352; c=relaxed/simple;
	bh=ji1AgpKCjulKa+AcUZyjevj5/HRkjYQLsOunij6vvWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHMUmVNdn3IRqL3MfONLQkJczDh9oBEm4esk/RsWbR9MoHK+jk74KPOalLUaRHYBt4+CsXhP+IXIEWcF0Vcq/NFBRkoe3/Il7ZqJVsnmmkmZlAHc1eFQ3cTSLiz0mZWmxmNptHaW3EIv+7zIX4hduvgzeTiBM0BuTC+qeKnxD+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RQFlvX7K; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-662f74f653bso1505465eaf.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 03:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770637350; x=1771242150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6VEL6GJ8rfpS0fwA6CpGVvqyJpSWk3A9TgfLwgRClA=;
        b=RQFlvX7K3bp8B7nWeQ0nPz/LGMUXTACj50mnZ3LDgoMJL+8ljNfsUARAyv5UvIJwWR
         Dv8WEEkSMOCFjUpYMUacxQ82mIr82ECb+yH15nKMRPr5Ky4f5EMY72b0l88CAIQXgKKu
         1h8fLlJn/T6uO9dfBuS7+qNaSJmIHAQX5+F2Y15MK3lCYJ2zGBDjhwtN2qbsDxTa4vEu
         F+nRElPP0dVEoToupju5X8y4oXpDZDo0NJktDINyuozkt/J+fMTVfFzepdOsfR9z9KyE
         nV78HKuoOBpFIpyaygM697bLrF5GAoEhZZMY+rUBTnzdlPg0DC6Raxm89YI3NreY7LHo
         /iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770637350; x=1771242150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r6VEL6GJ8rfpS0fwA6CpGVvqyJpSWk3A9TgfLwgRClA=;
        b=YNDv/WB/I1Jue3AzOvcrKGQDWCjf3IBp5V3/Bkub9mB+/Kb7IhHwdzi6ZI5gdWCo8O
         8/K4QbVl0rkxaET2ds5nWqa66n7tPYTOsyODIOARZJTOgvEJd1pvu6XDG3dubL9NQWWm
         3Ax32irqAh/lE3p29HZoODhVQM3DxdmS25LGb+40MAkV/CEEj8lnNjYzjqiFhosqBSXa
         vgHdOa6KKIbugRaivPWVL+iR0Fz6yssxK7iRwm4d4MarreLIZ7Dx9T4U9JO0sJDW3uJX
         yWTK2xTW0qItTvNPnJqjEMigyyKw/1JtvvTAcVTVN4PRvvSNs+NphZGNGTaoMvETzYIl
         X7lg==
X-Gm-Message-State: AOJu0Yyq7YvMEsreyWhc6DyzVmm0dyHl8sDiiJjE5XNM+zpQtpuwZpeh
	aMevGuLIazdG4czyaeO+Rc/asMflWpxozK/cZ+CVbY1uOCWdLEV7G3Ytk5m3x1QD3Bd8401Dm0t
	u8HA2rs8=
X-Gm-Gg: AZuq6aK4vfxQpcn0AjZmHyXgDMpOnd6b0AlMfzf7YtYC9znzZ5zZSHo9NWR2NWKZt1g
	NWLtXeeezHgpq1Uwhwh4bmnuW5MH04eh+GhPJYAs3EFzsZ6rOZGrvVT/LlJTGwC6kygXw3o2tAW
	o8sJu158tFZrcLhgLNot1Lx99RCtXcvvtB42wSGd5DViplLcEbNZC6oMwitLdbNrDqY2v9+4Cah
	hiBPZpNseXeQNto4U8ijU1oVsocqTXi1k1nifuH+/2V2Ayvk5PIXw//rXSeniz5xpl61tRAXML5
	4V9BZ0keIrCv9YJpo1QjvAUWrNEWOI6vSVMQx2Tow3TzrMN8f5GF5AZxIu+4GIdFovYEADLs+se
	GjIJVbQ2xOuTDKI+/+z84bKSwTA7ZkZvIe7PcxvnHlZMlk3mMulmOiQUwm87nAvgx4r9m1t5Gt/
	UYcTsBQUTcO8jLx/MJE5s/N0lkxpi6Svk1DHx63qcWG/rBFwucB4lT4zme/q5xG6+uK3nIdg==
X-Received: by 2002:a05:6820:3093:b0:662:fd67:dca3 with SMTP id 006d021491bc7-66d09dad5b4mr5700502eaf.14.1770637350690;
        Mon, 09 Feb 2026 03:42:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66fdf303607sm2822823eaf.14.2026.02.09.03.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 03:42:29 -0800 (PST)
Message-ID: <63b52c5d-5c8c-4085-9d90-12374da974e3@kernel.dk>
Date: Mon, 9 Feb 2026 04:42:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/tctx: prevent loop variable modification
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260209061919.425074-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260209061919.425074-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12097-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 81B9910F525
X-Rspamd-Action: no action

On 2/8/26 11:19 PM, Yang Xiuwei wrote:
> Modifying the loop variable with array_index_nospec() can skip indices
> and cause an infinite loop when end > IO_RINGFD_REG_MAX and all slots
> are occupied.
> 
> Use a separate 'idx' variable instead.
> 
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> 
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index 6d6f44215ec8..fcf79df923a0 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -221,14 +221,15 @@ void io_uring_unreg_ringfd(void)
>  int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
>  				     int start, int end)
>  {
> -	int offset;
> +	int offset, idx;
> +
>  	for (offset = start; offset < end; offset++) {
> -		offset = array_index_nospec(offset, IO_RINGFD_REG_MAX);
> -		if (tctx->registered_rings[offset])
> +		idx = array_index_nospec(offset, IO_RINGFD_REG_MAX);
> +		if (tctx->registered_rings[idx])
>  			continue;
>  
> -		tctx->registered_rings[offset] = file;
> -		return offset;
> +		tctx->registered_rings[idx] = file;
> +		return idx;
>  	}
>  	return -EBUSY;
>  }

I think this is fine as a cleanup as it makes it more clear, but I fail
to see how you can ever have this cause an issue.

-- 
Jens Axboe

