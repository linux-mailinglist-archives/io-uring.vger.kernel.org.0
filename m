Return-Path: <io-uring+bounces-12126-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id HiYSIO2CimmfLQAAu9opvQ
	(envelope-from <io-uring+bounces-12126-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:59:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB77A115DBB
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60B6530DA04F
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57CA19CCF7;
	Tue, 10 Feb 2026 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bn34pXI4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D351EFF9B
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770684767; cv=none; b=T52SLTWdhrm8sR0Kr9DsVdc6SA9XFz7qWkRBnlR68iqLl5QfGaEujJrGauNrdpVubhcC1k03WbZI4X6qHuY/uy6B/N/Z5PNZneUgcjCSC4pSl1NXpq+6EpAYKWjdmNMxcIWL/yWWENFis22tcfPPiKOOD9ooI7etDhzGgMuvPrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770684767; c=relaxed/simple;
	bh=2x1c8y6EHqL6GVEB6jsoTKViDEvIoB31obecTcD7lDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WoA5L9PcB7wypch/DSMe/lAfqs+ot8ttIkJcYwcOpLp3niuOyck8AT+zVEsFQuhrBM2XONR88ffLwLYF5Hgh8QlcgJB3plbNQ3zMCr7/qKb3V3IEaEY0mp/bMiWfekt9V+NRVbwzygMVvH5cMMJ/It4iBA8iZHfgkB0g3ibnXwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bn34pXI4; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45efde72438so158264b6e.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770684764; x=1771289564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6P44jKVzv4rUr9Cf5g2WNuRnFwfE4L3v+WHDzRsUhzA=;
        b=Bn34pXI4dWw6zJwdmLRkoqqHHxFCksnkBnNYDqKrJQQeaERxfgMle3mgJoSOXLm1T9
         fpUiZnOPK3UKrjolh6Yi+QOzFO2T3l1RuSqW8ulsOQzMi2owxU6b9wKfndQxOGCKnP3e
         PpDVdwsziRRAgzkUljDqJRJHwjNj76hJPCDyZTGnwmOil/mGHiTiyzxsO9G6hyLCusVl
         /I+UkqtRQOGpyRtMcAnnfg0kVURhrPUSly2ghsMdpj5OLF5fmkmFJI7+B+QxcRVSWG2z
         UODCgeVu7gDLH3L27nRSJ/Xxn0DcYZCVCVRHavgcFnUSjjgygo4v0fGE0cVLMjvlzqE9
         /ZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770684764; x=1771289564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6P44jKVzv4rUr9Cf5g2WNuRnFwfE4L3v+WHDzRsUhzA=;
        b=gmtAJvcdMWY2PcnoWQYGJm3f88iRYJpqYTJtKaxMg/wVE4+yYdH36mA4/7Kf94mMEp
         2wErCnQ4RR4vKwq/HIizkq1tr8VOvwWO/+DDXZE4k3uHu2O1qUl+ovfrK03cBnQnPQTv
         9SbANFVBbKWVd54nU5lz46h2QaYQUFb4NIOWSNLS8nP4dMyZccY4jMYbhFoviL+KKHGD
         7Q4klONjARJuelKOOyX3rk7tQSp5hqXAGW/uynbQLk/WVkhhbDvLnggrZ3NCOao/bO4x
         LaAwIT7B1Be/1vMMRLMUjgpHXi7Ec/PwrfZNFlMkLHnyRIzLhD3sDuqO2PEyqUSdpalz
         T/Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWo0+TDHhcMeeLGduoP/1cfAl/t59gNSKjkMpp7cz7A+UjF8eYu5ixHw5JpqCUeMirHgH4/8XpY0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSnsA8reEQjFdAxCMJzt+CHeelJkrxGcFgKg5EGqxXq7e4izjG
	Ojxvh4KIDr9cbLjKT4VgWzQgVTmrl0MYtJX2n+0rEVI6XzdrPNgq37KV2xocv5N2sug16L4ED9k
	EaMrofiE=
X-Gm-Gg: AZuq6aLCpF1wkByec9sd4KgD7p+FY1yhiSompzAHzzkXjtmHfgxEKstaaj6oAYfYRXq
	EfNgEIq1SWQRqnFnXjKBJTEXMC8a4UzHdG2XL/5rP+ZepW3ytjbEZAFFXz2NXX47mRCevJHhKbi
	b+Z6Wx6d7cyw/UPmAxyah7cw1FuQATXT+0eJCJkRZskvvXtFvXfH915KE+AtgalQG8jvABrPpXR
	7FU+XH+qDdxKp8Js+p73fXBm5Qy3cm81xiTYul/GFIL5xFVQwxXqjiQcJlPpPXV/gEBTMzSz6pZ
	yvW/fPPiO/M5LDFtQO3gAqXXGupCpdCe7Ddau763aXTv5fm/wqagxwefL6TJw3zsZ8o6Hm6iQEF
	+FIcPUktUnQSUaMwyaE//jzWzRhOxjHVw77IMhWbSC0yghP3d1GtM70Sqj8Jvpyq50OaZGo87Ad
	vP7exA5GsN7LoUOsQA+D81NJFzY3+Y16NUXgdFwCDNa0um/KsG9BandVDGpNM8BguPQdlGETbiE
	RfztqFBMQ==
X-Received: by 2002:a05:6808:1520:b0:45a:552f:cbc3 with SMTP id 5614622812f47-462fcb63e27mr7069549b6e.61.1770684764458;
        Mon, 09 Feb 2026 16:52:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462feb5455dsm7256050b6e.17.2026.02.09.16.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 16:52:43 -0800 (PST)
Message-ID: <3eb1116b-f48e-4bfd-9a0b-798a147f54ce@kernel.dk>
Date: Mon, 9 Feb 2026 17:52:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/11] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org
Cc: csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com,
 hch@infradead.org, asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-8-joannelkoong@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260210002852.1394504-8-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12126-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB77A115DBB
X-Rspamd-Action: no action

On 2/9/26 5:28 PM, Joanne Koong wrote:
> +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
> +			   u64 addr, unsigned int len, unsigned int bid,
> +			   unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_uring_buf_ring *br;
> +	struct io_uring_buf *buf;
> +	struct io_buffer_list *bl;
> +	int ret = -EINVAL;
> +
> +	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> +		return ret;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	bl = io_buffer_get_list(ctx, buf_group);
> +
> +	if (!bl || WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> +	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> +		goto done;
> +
> +	br = bl->buf_ring;
> +
> +	if (WARN_ON_ONCE((br->tail - bl->head) >= bl->nr_entries))
> +		goto done;

I think you want:

	if (WARN_ON_ONCE((__u16)(br->tail - bl->head) >= bl->nr_entries))

here to avoid int promotion from messing this up if tail has wrapped.

In general, across the patches for the WARN_ON_ONCE(), it's not a huge
issue to have a litter of them for now. Hopefully we can prune some of
these down the line, however.

-- 
Jens Axboe

