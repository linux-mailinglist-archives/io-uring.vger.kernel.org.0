Return-Path: <io-uring+bounces-12500-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NBtFC0NBpGkgbQUAu9opvQ
	(envelope-from <io-uring+bounces-12500-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:38:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA0F1CFF83
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2434300DE31
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 13:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B404E329C73;
	Sun,  1 Mar 2026 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Sce0xO42"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E5F2EBB90
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772372287; cv=none; b=S5KyU+UTmUmjQ2RTWjYoGdCzhpaIJCZMb5pkmnot6n07/wdM4cd4ykx77zq2gg4abw5/Di69t6jOLGA9AeIi1yEHLAfMpe+l0wP/jpQbyo3EbPmefg2YoOWszBuiGWdXYzW+pucb3nqjRkXZw9PvJJl9/W+4XtePzoSNBYMrDUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772372287; c=relaxed/simple;
	bh=714Js2ZtyF/O6QAGmmnMOYvEDX97G6IGDo7RFN7QFhA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jBtf1D8n4nBWYTZ06TBuQpNthlU8TJ2OqPu60cvlRiDybumA8SUYVINw6Rjy2WNjho8jLTtjorRYxqZ8W5vpeSSCFcauruH9MLsMfaZeBNKssc+IEeT+QHi0eTnughlUjdhKswzd1eGQy+0/mY51C5IPMzMSME78L9c7oFT7EnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Sce0xO42; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45f18e8f2f5so2355040b6e.3
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 05:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772372285; x=1772977085; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ikDrTtNvVWdmHaLLfiBeHI2Rv9gpJepuTevXezdKDBc=;
        b=Sce0xO421gB9xEfuFmqu50yUsllO0bw970VhffiuixTD0IAaNcYgjnk0QWTIn8CccW
         slJEE1H+l5ANoK2mvMCRsRkEAotUcY9GE10MlbbR8XlAjGmnuOsYFnL4m8juTwD6GUp1
         Z7SZrErhXKoYwQdM6plBfRkpKTYNPq9X1TxBApVrmALc2Y0NM38pv6g8dYbHegSGLrjD
         eqTn6C3mhSRBTXk9/wXdNNjb5ZJ7sjBikFimXiHPrEFh/THU9qkXe6LycAnf3Zz5QLLM
         q/8GiHO9qQW1GpNEy1lKD6rWUEGK5aKMsx53AU47uua/igta/pbvgyI0M4EpyW5vlYkj
         HviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772372285; x=1772977085;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikDrTtNvVWdmHaLLfiBeHI2Rv9gpJepuTevXezdKDBc=;
        b=UOmtjQlU+dWE9nHMfysZCIc690RuXwEpiX+YPdARoVaB5ib28QVnLJ9ZiZ/xrx2A9t
         h5Ewf3PZTS0hJX3XmXbtLYiwcMSF3ZGPkMQRBmX3V1pvkLcMJE9R0v62m+WOlh6oYcr0
         4md3MrVXg5tCX+0yCnUFmIvplIyVKRU47PADJJJKlVfHtaWzcDZozR4Pz+iObzBHSU03
         CmcXL1iHQIaSJBWn62oic17FBOlKINNwUsh0+HKMtDdJIscoNzbPkKBHz5kMV8atOIP6
         YWUl0tPKj8y2MSVlV6UGngNfeZilDbljjuTrN4ly3l2BznoitMd87P684gUuJBZUWQT6
         16LQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3PaTUaDHu/VlA8jZnbEqSFm0ePBkECteXnjaiLtanQ4aJcrKoGhV6bQuo49vcnUoSYjScbuehQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvQJkM1CCt7uzxUAmwpFKAaYbPbnwnIqJExP8hLAnflgYb3ozk
	OHZH2oJ3Ie0k/qfeHWTWCPqtpRpKtBIlBcvNT5pSuHixkO3s8aDBjELOIYWV2wmOPFU=
X-Gm-Gg: ATEYQzwxZreods2CVRg7PlBYgokJZzNRzhqfaJWfhBCKzy8oKe5unhE1Xkao64kJ3Z6
	7GdEN9EvHoxa+jy138xvRn4AwBPNHMOM1dT8hd60LV4Pz0DT27pTUVo1do2naXAxdS25Kzsv6jG
	4SmBsqZFl7hesVTQPgu3cuLLN6NVnFiML6FvVn+HkxoNr5e2s7LBjdcMxx7oV/evGvpNCbRnmmM
	fdbp84f+ec6IOGBO5JVRqi5nHBUOl0wPFhRaPWRl1Du9k5wYHyM7JEvyThc51Pb/CiEi/ANqM6O
	Eprcg55iLAm7wUkWgzf07TCU64M1/geGtVuaj6way2SLNmH/CqgDJBruKMhbG+ty+RJJWrqSZ0i
	4l/UonQt/OtZlPtUKTa3+hTkSDYb/bLO8aDJTIDzBYPo9AQAOPtLt5vqI3skgauw2Z10XYJXRAp
	XgHC9mYEiQ4lqdvewdTt3hAR/r6ghI4vLk7McCKp43aV511cKYraNLj5klhMpsrxeglDr51eNTI
	QEUT5ddxA==
X-Received: by 2002:a05:6820:1994:b0:679:dcd7:fbe6 with SMTP id 006d021491bc7-679fae7afb4mr5753920eaf.31.1772372284839;
        Sun, 01 Mar 2026 05:38:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bcd3c5sm7121302eaf.1.2026.03.01.05.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 05:38:04 -0800 (PST)
Message-ID: <dd1a6849-12e7-4ed3-87cf-544748fefb10@kernel.dk>
Date: Sun, 1 Mar 2026 06:38:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/cmd_net: fix too strict requirement on
 ioctl" failed to apply to 6.12-stable tree
From: Jens Axboe <axboe@kernel.dk>
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, ast@fiberby.net
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
References: <20260301012914.1686902-1-sashal@kernel.org>
 <b83dc35f-37aa-4b2c-9ef2-aa189ded8448@kernel.dk>
Content-Language: en-US
In-Reply-To: <b83dc35f-37aa-4b2c-9ef2-aa189ded8448@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12500-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6AA0F1CFF83
X-Rspamd-Action: no action

On 3/1/26 6:12 AM, Jens Axboe wrote:
> On 2/28/26 6:29 PM, Sasha Levin wrote:
>> The patch below does not apply to the 6.12-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> Here's a backport of this one.

https://lore.kernel.org/all/20260228180858.66938-1-ast@fiberby.net/

Asbjørn already sent this one in yesterday..

-- 
Jens Axboe


