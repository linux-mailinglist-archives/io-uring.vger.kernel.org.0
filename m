Return-Path: <io-uring+bounces-12584-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEl+DDvJrmlwIwIAu9opvQ
	(envelope-from <io-uring+bounces-12584-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:20:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB102399EC
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F413A3074F16
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C583BD63D;
	Mon,  9 Mar 2026 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFwF94Vj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4586E3A4F4F
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062284; cv=none; b=R0I2c5yu+9ZtD0fdpfeU+GIdrw7Xt8SGB5YtQt+bsH9sirg6Ng2lCJnZZDgIcR7pggqmle4fkudmmkFSBf2oOufX8efBb6lJGnA9YBm0GoH+zfKqtjGujwkpRyZIQZxiQQNM2SC2PwtHk8SlX4inQt2MNBH5Z8KJos9xYkD4AxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062284; c=relaxed/simple;
	bh=jO6U2dGUAuVA6pCERH5JKoZiL7gIaJOZTvzuqXbbk8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZYBs5qTzOlKU5Oj9GSLvJSKichEVF9YpVfZataeXu+8SFLmd+bHCnnxXYi6GfuNrAU6ka6Iox/9BGJpdMtEX8qioLOISWws1iCJfulUonNXz6CxUpvB756+CvPnnc39P5XkyGMiv+pd2+Ck6pwO/XCMWxANOOB0f+wwU8NzcvHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VFwF94Vj; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4853510b4f3so20003685e9.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062281; x=1773667081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F/M8koHQQcqN1D50ayC+74APGxi6p7SHExtM1JxyxXs=;
        b=VFwF94Vjd8/0o7nkQXxCbYLzrP7LfI9CzuxBCvKPt2iaI+0LZGpEVGaZshftx8zGYS
         mHv9SrmN6mAvTBNN37uv1StvTiN8JXjftIbN3BKQF7iGvfzDV8yDe7VO/wpEPV+gc/zQ
         UQQKzZhobr6uUuBp2PJFUEhUrXwRWVrdw+UFhMww1LhNTtp/QaNGxLo4XDXRzn1Kswmr
         Zz73ChMHNySe5e9Eed09AdjaS9GSNxAUNi3wm/c+NrFX43PGcY1pKdaMQF/Xcwp81UQR
         kJwWHwU1oakGydj613wcUy7Jk5NhvtJo2h9N4C/AMBA4VC08i7UL8i1FtvA/HzVL05Os
         GpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062281; x=1773667081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/M8koHQQcqN1D50ayC+74APGxi6p7SHExtM1JxyxXs=;
        b=PT98B0eejBbTW5LKW/lBoMawrnRYu5Kepmz8hcO0MHXPKeVkOjkVFIvImNk+ZPvYgV
         WFClSQ2CIcsVlM7J/b5il6qCgAuOxqUrIXEBh14lIoOkMbXiqKYJuBPPJhfie3dfoP8X
         RWF3IcJBNbfytKnepTLvIz56rSkRp9n4CP7+Nn09NiIzyG3k1YODVPfewZ844lr9CxEA
         1XA7Tnc4O2R3M24Dhsvdg9uRKAv0B9ZDp53/nD/N9ec1os7QqFhsESbj/m8kJ41Av6pm
         Rg7n3S+v1Q/SvcSwTjVI5LdjbYrrLpCSqbiTpb0qTc8qXRpJ2UGnArVGglbtUOy9IEJA
         qhZA==
X-Gm-Message-State: AOJu0YxqF3IQ3lVQj+gqmRIiOfI717WV/0XJbdkehURBjNT0GabTK0Bn
	XduFgoI6naYo53EgGeLTVSNG2LqWcns51WqjxtjLJxpPcCMXb72aVNGu/wccpA==
X-Gm-Gg: ATEYQzzrNpVht2gViUX4JRnkEKT3hEcyd9MmjCIEDmgJLtNQ/lG3TkwOhFSZmt1Mj4/
	DgXzmQ7OrmP6/d6PCaUOsHxd0Pj7XtCOhv3MjDxaboeSE0Y9iPup062iWM4ntsNrej9g2q5CMik
	XlyPnz5iuA6YmubTJUHrE1D3FtRv595DIi1D2ewfMrCjU6SItqMM5nIX6yW2RUjRA1p8l6iaiJN
	LV6UZJt40r34ygZ73rxFpIfjkyao2UGWcNTT9WP+7zwiO1xj/92oJo8zQEhA/rsKFH5ds/1pzes
	1oqbG/v6DzlIi9Wh5s365M+uyUR2JiWCTCVFxAC/5R7lCVkWA3pgwGnCLIXJiA8b0aRykDJGpjo
	goDE3BUSZQPpX5BJDi+2vLsduAhoY68NVCRFDFnV39Q4gpLj0Eh/xQbwP8NBU61VcY41HfbQTnS
	EA6hdVWqzGakbCS6pFR/hc1zcpdzLaT4MoqMAYVMicZ8GDS2wurZP8SLfUvYKnDNOkKzzD2siNS
	LLz6E/r1+Qk/GKk02cIyWSF0jwJ35cz19wpgvg3bwwwhvQMRKOH/h5jQzmMBwmpar3ZS86W9hsM
	VG7fMbwxxEqC
X-Received: by 2002:a05:600c:c4a3:b0:483:9139:4c1d with SMTP id 5b1f17b1804b1-4852692c943mr193509075e9.14.1773062280888;
        Mon, 09 Mar 2026 06:18:00 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485237e8095sm159915535e9.2.2026.03.09.06.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:18:00 -0700 (PDT)
Message-ID: <14f88099-6c27-4dd9-8868-f7e61ce68474@gmail.com>
Date: Mon, 9 Mar 2026 13:17:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CEB102399EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12584-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.934];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/3/26 12:32, Pavel Begunkov wrote:
> Enable IORING_SEND_VECTORIZED with registered buffers for
> IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
> to differentiate if the vectorised version is expected.

Any comments for this patch?

-- 
Pavel Begunkov


