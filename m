Return-Path: <io-uring+bounces-12411-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBonBtzQnmnwXQQAu9opvQ
	(envelope-from <io-uring+bounces-12411-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:37:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70317195D91
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7197C302294D
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB127392834;
	Wed, 25 Feb 2026 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lob25UFG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756D223EA90
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015711; cv=none; b=OJKO8Osxni6mrZly/9CaLaWudgOL4HjFJ4EoEGxcGBSDaB0BaHCgdNfuuo9R9ur0nrx/dMPtDuSF7gkufFEiq4IyGIgi68Ao4Mmo2nI2kgdH5p60xx8/D/lCPSByCGF3K/BW6hYxaivDkCR+n2G4rmsqKtbLI3ZCQypBhJiOLWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015711; c=relaxed/simple;
	bh=b4JSMkr5hhW0mdPlOWbL9c7gCiDbklE6NtYE7yej/h4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WyXS9HBbqqU+UCS8z9YzkchbAC+imZHyOLOLinLsDTkBO/QeYMUP7tC8XcEXgD1TGdFigLrhoqLDRApjWl52tYx4vHqEMWEjOKEKEfOx2lQIjodz7amn8OCRCFl+Cs1aO5m3Q9UcdDD5w5EV6yvtrHrtCWgVPWS92MDtB4K6RPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lob25UFG; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b884d5c787bso1048255166b.0
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 02:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772015709; x=1772620509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eDHxX+1n+gS+PvzmP8xWAKJOhH9ifb3t9EIWP7G7auM=;
        b=Lob25UFGnlRdEfUoa5dp1/CUmiAzDkMNyOdLdaUa+MzNOAcY/OsxYxhHgpmOcusXNs
         S61RNvYt+DVvfCQMPLywzHejolI9R/X6QIFSuLDZGuQ9ZDO1/fkmkodnODu5jgrF+YTL
         IuQ6HepHYgrgwf7wgnICG95AMPDAQPF9DS67d3/EIRkYSJ0B3fbpnxnO3f2OspdIkxk6
         lDR/1CiGDm+FjfpSFbWuOMr95KRdmM5fx3qwWDK2ZsjA9JQJ1CpUqFlm3XcDOHuadXgs
         qnLDHtHPUS+8PWPsIRBDrb2UxVCh/ytc3qjEQiJ+i3H2dzgzs/pvFnLZ+GNZmIj/O3S6
         S4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772015709; x=1772620509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDHxX+1n+gS+PvzmP8xWAKJOhH9ifb3t9EIWP7G7auM=;
        b=grqWFR9cxpF37UtlrGmdmRQjgfNjNgehAGnrvt8KYKWL9d+Csg7ijVxS52F6JdsgoQ
         ec/H+p1U3AOO44R9DzaCIZWXQxKMP+WM36GbNZrQMzQS2KHP7J4IeEh/ExzLv8GI8bD3
         XolWU+UzVZjksh741PZ0fvFKprJsYo0X6RwJy/b/JZ06LSuMiu2EvghU7nUucCUHp1Q/
         HMsSph6f1O0d0oxCPcKQlJ15xumnqEVIDzUkGoY0qQ7uyBMrajycYwdnT0zOrUTrbrVh
         bvn4yQNfdyCJ3jGuxXWenHu6SWhXcz/4AMkaWI3dKEebSef92jhHRHcUTgryzFOPMfzG
         EWHg==
X-Gm-Message-State: AOJu0YzxqtMYd+/dnpoefoWlauDXxYLMf5Z/a5E25C0CTXQUwzlxMaUm
	6Mvr0qE4hMLdWZfeSJbdcKB06d6SC8cd494aMK0fzDCjF3bv6FdlV40j1TOYyQ==
X-Gm-Gg: ATEYQzy5GpCcn4Hdgryvd3jMo+OUiXA8gro1zedDYv5nk1y6ZRNesFTUBQk30c1siQO
	pjikyaZ/IOXsblsVycP8fSUTYk69b1MCjnj1R0yrjNEJB8mT/wHUeJ6FkEcI0veVO0pqtywq9e8
	qI9Yh9Os5z1zh9lbq2hHxZoqWwr3/MHDHbQjrpmkPwkdcyg+MHPaZPHkP1a8T8xpEL61Tp+Vfv3
	v49ttk1TeWvLiv7hS7fkqduGLfeKPGIhTyNlRMGD6WEVdAZ3lhcXMPasan1X+p4PyKmgC8AUR96
	iU7XuJyLJQEtLwUFf45qInQv9NOoaVjAkdsW5Zk5LaQ0rcDohbhxWLE50voy777V2PGpn3dZdP0
	UedM6twe23K3qvWgP4UcHV5PqRuBU1zDn54NYsRQobCAEAYoguF9bq8s1xxzYQG/6CLdExrtC9A
	m1XGpPR5ktogkVN/dLPBwuaN8TFFsfzIuxZLaFB8qAZDzEWZAFoqIl3GX5lDJrYuZHe6YhUikGr
	YUMd2Gf3xCbunPIADCCOCtJ8EOGKgQTMMLBX/moNKVbLfpsZRLn190Jeg==
X-Received: by 2002:a17:907:709:b0:b88:317a:3f40 with SMTP id a640c23a62f3a-b9341c19b80mr135264766b.38.1772015708410;
        Wed, 25 Feb 2026 02:35:08 -0800 (PST)
Received: from [10.112.148.141] (82-132-214-161.dab.02.net. [82.132.214.161])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084ea031bsm515328966b.54.2026.02.25.02.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 02:35:07 -0800 (PST)
Message-ID: <f9d85900-3353-49db-b98a-c8c8466956ea@gmail.com>
Date: Wed, 25 Feb 2026 10:35:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/timeout: READ_ONCE sqe->addr
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
References: <cover.1771949518.git.asml.silence@gmail.com>
 <8deca9c11a924888d317b4666c93c6ed2e719cee.1771949518.git.asml.silence@gmail.com>
 <aZ3WH6S7TjyvPd5V@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aZ3WH6S7TjyvPd5V@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12411-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 70317195D91
X-Rspamd-Action: no action

On 2/24/26 16:47, Keith Busch wrote:
> On Tue, Feb 24, 2026 at 04:12:10PM +0000, Pavel Begunkov wrote:
>> @@ -557,7 +557,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
>>   	data->req = req;
>>   	data->flags = flags;
>>   
>> -	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
>> +	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
>>   		return -EFAULT;
> 
> Should io_timeout_remove_prep() get the same update? Otherwise looks
> good.

good catch, it misses it as well

-- 
Pavel Begunkov


