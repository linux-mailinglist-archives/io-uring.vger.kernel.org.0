Return-Path: <io-uring+bounces-8239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AA7ACF890
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 22:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1910F1891234
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 20:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BEC1F8725;
	Thu,  5 Jun 2025 20:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qodfndVP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A404817548
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 20:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153948; cv=none; b=NNjSjObu4hX2Aml2w0c1W5a+5+zVqqzBeKQm1RtFq1GjROAmaxb+ezjIxNeCbcrklQJwEjhRD07cl1ETfL/PcTRuFf+cAuqlnbiphuuI7HZprd4iwspjy9KeePMA1bgPknPySbL4WfYJhZUIYgeMwaLtg8IYpkkXqXAetRNKVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153948; c=relaxed/simple;
	bh=eRWvchQ4fC33dOBfakUf1jUaVRk/fHJdVYnmboGr8UU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=flatYgwZOOSZPbuNDPYFhdAFE9CJWAvNHC1NGQdKzp7C1nCgNH+BPdfDjwwltjCfdtaLVGSLXTBflREZse0Bz499454qifOq0mP9N4C7UnVrAvtgYPwGVEluY6D1hbXZUv9Bn+s7sAo/GPFDQAgHKy+tzxEpMGvwSllWUCMMqLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qodfndVP; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso4697165ab.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 13:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749153943; x=1749758743; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avWjY4Bxh32oXpkjnl7j0F4XM0MmrhhcMnSe1LRctTw=;
        b=qodfndVP/08lLEb0K5T8fftnWzwg8YDFsmdt6cHZX8j7EV2tUAPIaGMylw66lCk2GG
         G31G8XIXRk/5q6UbD/5FnWdhS8lcUv4CEhyGINmmJyFyh8rwNGHsOvmU2KSjWwjtUfY/
         s8Bgzi8PiUTrPnrpD0cgVSiRCycBPOHJvzewJtwOEvyIlSE9p/Fkuf9tcV6LNZzF9wpn
         08HvZO9K2tpf+X/q9eXEinkGvISjkztm0rYu8WLHVzplLdcliFpQenUvb3pG/YwkXegN
         Z+fQXaToS32BZrfnXpB2mGsRF+Hd+ntdAwD34AEP7HRPDYYp0T/ptC954XBqLtXxxlre
         o4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153943; x=1749758743;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avWjY4Bxh32oXpkjnl7j0F4XM0MmrhhcMnSe1LRctTw=;
        b=qVWeKCNTTrOAp0h6bQAz2uoaWtYyIkNWfny5gZi8l6ZGV/lE+qtcQ3ewl4ZVu7LDlr
         +rQecqhSSm2w/m4CxYowcJkYn03CfHjXFQEc9LHm2kM7Ejb2Jdh6bi3DksZz0aLTSuIZ
         fJxOFbR9H3qWfLBnTO8B37KuMnDZm5nQgABz5GkQmYk7lZopToPY0ZwB1hUxIqr0Hu6K
         Jt5vniWh5j/YGqrcu13tWhWQnpeXGuAmEgucGbUCFgijNpFhK9hwmxWQrRReFWR83B+E
         rTR5Nqn/pDUwqcbNcsAi0wiDnb58xgUwkSPoTcFt9OpJvwyAew5DOZEnmUmsY0wjsUi7
         ZbCA==
X-Gm-Message-State: AOJu0YwZCRO777BEbHjlgIh1ocnk2B2C/E1ay5RAf5sgoEA6ujVM6tnI
	HCK9Vuq3oVOYx/Cg75a9/LtSJL4J9PXahwa6DnC4vJ/qWbgKi2gC1hY9MIAyNT7x195mVweRoSj
	LwjJC
X-Gm-Gg: ASbGnctRVHSVBPZjsANlKaOXWHphtI0NHSBEYPBuYpvZb+o/BMovTN7dyPzzcDKIcio
	OhoWGoqAKGTi9t0YyUfBY/jA8dzuPesrMPkkv3U01Emz3JPbDI2YUsLrvIvIBZvcTWbIB9PIJNP
	zVYpgDEPlfkjIkzjaYmx5rXqmY9BuZkeaSxrSj5IItNQB84gGSBgNuPFPQsUc9dav9ei1Dxls2P
	Lnbc1ews8RmSkFYQBArnqoqQMREcI06/HkDgKvjD6aJYU++INQV/QfUfWHeSQKwu0zMkMudj6s+
	WvcwG9BhlEKwdA9vAmnpnYTr1KG0xfLgFZ/WTsP0N1dlBBfv7TkpyjjOfA==
X-Google-Smtp-Source: AGHT+IGLRHhrJ2E0y80hy/n8asfyl5YJIbi0bPUScpW0u0dsgJ40LImWj74Ll1Y0FgLqtC6LfNgzzg==
X-Received: by 2002:a05:6e02:1fcd:b0:3dc:7f3b:acb1 with SMTP id e9e14a558f8ab-3ddce4610c7mr8451845ab.13.1749153942961;
        Thu, 05 Jun 2025 13:05:42 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf244b3bsm109015ab.46.2025.06.05.13.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 13:05:42 -0700 (PDT)
Message-ID: <ceb4398b-d26c-49d7-9891-722694d74d35@kernel.dk>
Date: Thu, 5 Jun 2025 14:05:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-3-axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250605194728.145287-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ran all test cases and found that...

> +static void io_queue_async(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> +			   int ret)
>  	__must_hold(&req->ctx->uring_lock)
>  {
>  	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
> +fail:
>  		io_req_defer_failed(req, ret);
>  		return;
>  	}
>  
> +	ret = io_req_sqe_copy(req, sqe, 0);
> +	if (unlikely(ret))
> +		goto fail;
> +

we of course need to pass 'issue_flags' from io_queue_sqe() here,
otherwise we risk breaking the sanity checks in uring_cmd later on.

The git branch referenced in the cover letter has been updated.

-- 
Jens Axboe

