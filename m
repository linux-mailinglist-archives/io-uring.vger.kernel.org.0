Return-Path: <io-uring+bounces-12465-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCLPAUDwoWnYxQQAu9opvQ
	(envelope-from <io-uring+bounces-12465-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:28:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5AF1BCC69
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42EBF3169860
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 19:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2619350A3D;
	Fri, 27 Feb 2026 19:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZPUUQQO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0333ACEFD
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772220217; cv=none; b=APDfWRlUA6vT13VStLGsCobmjFtT2sWL1N2rWqLtBl7VWcTJCmVXMQYPBMZY6dWlM2jkdNPoMvtoAaoZNPfzDXtjkvgIz8vRRnQKWJQVwkAO3VHLhbRiKagecGYmF4xc2SnZ0TeJcCXdPcGhNvd2Em71PJjRqTj0bFzUWYywo38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772220217; c=relaxed/simple;
	bh=Zditj/NKbpDW7loNEhrU3UvwmWRbTfwGW7sPkf+pGIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwPDQmJxGpbP4G9v1K5JjEse/i92IKgDq9rCVjcR+2g3DQuciHHoD1PVAjIjzcAmx1IwCOEpP+76/24bqLUXnqyCHQUq2QO+YEMvoGbejvFTL33PJXQY7wbpBYTzezDornnUFe5SP69YxL/SW5LyPiOTsWS9p0/m3fDV4VMQSsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZPUUQQO; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4398f8403edso1875219f8f.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 11:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772220215; x=1772825015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K5JwpZF9m73sgumtyMO1FvtEY+3qgUA9OtLlw1eJ9H8=;
        b=MZPUUQQOYNFmpgTrO+2JjOqDncRMgT4hMZslkK9hjP6XeHOL6hX5OHw+Tm1vOhiZGX
         q9dY2WeAU1Y8Oitfsz+5EyFvJW3zyMJi5+UzdlLUb5OJEjvbwBfvqnFkJX/awDJMu0jI
         rHbdT3fqjH+/SVy6ExHqMJZ62PBPV2UKvE4CBbyNWY3EjR48OC2Eb6puPIcWyeJounx5
         oxdWxa40/bFzYOOV7epmQJFhIM9TGQRdqaLqDU1DXIGW+/XQyioI80r+45vFHHR5GSdS
         QW2wiYLRgwVDsR7Co6nGG730hkmSol2Gv7twNv5CYeqjd0AYDpgWgFk+pgOPGuygDmVJ
         /PfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772220215; x=1772825015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K5JwpZF9m73sgumtyMO1FvtEY+3qgUA9OtLlw1eJ9H8=;
        b=dAEbZ+f/zjAB3W2B95jHbK/3EMG00kxP2VTLVxxzrbDC9gD6xA/t2HLdkIi6wR2aBq
         tR5AmesOiSBj5uzPdlrkenJtvSv0mccachB2ShukBXyaxnJASyT6aX9BKvID6JXOJyeC
         MZ2y2IgFMq4vSVsP5s1nVtTJwzyGaJG0p9gYF7JvMp+fCSxxXoNaA+yIckjYrKB5ERFo
         MhdODonxdvm/pnLiWzfXKb1zQkcY3zWq76zB1++0mI/yNKNVo/bzQZueXEMTVGkSoFAO
         9zUHQpaoAiE6qSjO7fNKy+feSRq9jf/7QUw80RllAKxwPqldmJGiWGbTdLkCGXsAWvgl
         VGpg==
X-Gm-Message-State: AOJu0YxSnsugXP0lGsqcmga7KkrGE/XEjX0/7Ui0Reh1ClLpLRtIUzWC
	CsH323NLX3gxW1aC3zSCvxdZ2ZGTX/mv+oth2sh+33kDgJVf0ZL2zvvi
X-Gm-Gg: ATEYQzw+y1+WPbJYMj+F6OLmXvzyo/GKNfUcPwSGowiLuEfIux53uVO6s4hOLa85ZCR
	XXaXvw9wlPltgG0e+6ZLD/u66dZLkSao3vL4jHpg5RduxA17h9OrQMOTdMyPm6Wflop6yf/m345
	mtl751PfrSVsLvtebydOc5Ddaw7MzBDWWNZyk5ch7Iu99yvpUD+WaUesJsT9+klKplzufrEuLfE
	onFi1oj7yFYRwUY+UxojVul2/1l4OH9BhjyupEBLxZmpWxp4RflzRbEMhgXhwtaKNPLOyuaQdTy
	V0WXu+ljKG3DIkq2ECc/y2uCDm3zrwEh5XdDmTuE7dQbZ0tDUjn4HtjAy4Hq2VWaZZK5ieaSulQ
	MUQAEG4knJSoxJ0YTY1vCuGyS/EMO2BTs3O9jWImOXIws2mZppdRaTYNwMmn9tV5OsJG4wPRfMw
	v8kDrca+vbzYR/HvMKRmGDAV6FF3wO+ivVd6+gDLNCdnesDflk6kBHEu1OOQRIhv+j77tkfQoh5
	3A7eKlB5gTsc5QC3xUJiIdNLpOKZTsjM2DMxYCW+ASbbZmt1WmbHz8RdLYFOkCi5FvE+BI0kEBn
	mQ==
X-Received: by 2002:a05:600c:1d1d:b0:480:6bef:63a0 with SMTP id 5b1f17b1804b1-483c9bbbe50mr61606195e9.21.1772220214636;
        Fri, 27 Feb 2026 11:23:34 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfec1a5bsm81259685e9.29.2026.02.27.11.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 11:23:33 -0800 (PST)
Message-ID: <148610cd-e0df-4110-a752-b24610c83226@gmail.com>
Date: Fri, 27 Feb 2026 19:23:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iouring] io_uring/zcrx: don't set rx_page_size when not
 requested
To: Jakub Kicinski <kuba@kernel.org>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20260227170745.2845550-1-kuba@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260227170745.2845550-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12465-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5B5AF1BCC69
X-Rspamd-Action: no action

On 2/27/26 17:07, Jakub Kicinski wrote:
> The rx_buf_len parameter was recently added to the Rx zero-copy
> implementation. The expectation is that when not set system will
> maintain previous behavior and use the default buffer size (PAGE_SIZE).
> 
> This works correctly at the iouring level, but we don't preserve
> the same "zero means default" semantics when registering the memory
> provider on the netdev. mp_param.rx_page_size is unconditionally
> set to PAGE_SIZE. This causes __net_mp_open_rxq() to check for
> QCFG_RX_PAGE_SIZE support in the driver, and return -EOPNOTSUPP
> for drivers that don't advertise it -- even though the user never
> asked for large buffers.
> 
> Only set mp_param.rx_page_size when rx_buf_len was explicitly provided,
> so that the default page size path works on all zcrx-capable drivers.
> mlx5 and fbnic only support 4kB pages in the current release.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Jens, can you take it into io_uring-7.0?

-- 
Pavel Begunkov


