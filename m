Return-Path: <io-uring+bounces-12216-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAWeJXY/kml8sQEAu9opvQ
	(envelope-from <io-uring+bounces-12216-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:49:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F124213FD1C
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:49:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9DDC3028ECD
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CB31C69D;
	Sun, 15 Feb 2026 21:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N0WWeaSR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148B2FB0A3
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771192180; cv=none; b=bPzzNk/ITbOo2EWkPdE+MSTmlMa1EGrffXThgnjmmkBm7xeWHLzbDnb1wo62YFQiTceKc055vbsb3xvTY62LKC6a2borS6hN2R23sLUP3Dp5M56jaRp5U2OsVq+KLPvLIVKnj2uNdRYNrBmAB8x9ctU2o36XmoAFjdG3yf7wpkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771192180; c=relaxed/simple;
	bh=7HVhe/DfYShgIGWXWpxUxGUKYO6YjXLOrca2JZIGxqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EoA+sMhhLV7IfdxDKyc3fqY105Irt7IzdvHqrnvMx8O8Wl96PLQS1/3wjFqrwy/yrKi7CAYfqNF6bKlbvJ0vFzalR7QNQ0XgoRiXD+cYTL2Peryn5IKWpKFQUVAvoarsB0B5BmfNLsWd9kAl/nbM5eGizeRERGt1G17OhpHUMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N0WWeaSR; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d1890f5cafso902842a34.1
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771192177; x=1771796977; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HY4iKSdZnOC2lD9r2U/xlpJrxAQ+ri4/u1JX8B2xnrQ=;
        b=N0WWeaSRia/VO19q112Q3BLQdYXnRswu9GG7YV5wPazRLgtDedQTLhGJk+o3NEMv3r
         Steyaadr6zfVaLu0zad0U2ERQJCZv5DzBDlhrBWiCMJdtemW+gUtvWeVmb+wku9J9q16
         9+At/L4fUvKo0nFbcH28OBOdSnUMrXS+FoXM/Cdo0/PN1AltLWUSVuyUF5Mt8cdhgums
         B8DgBjPLAKzYGPvdBt4tXybxfSItVZ9/v1pVgggIj56YjcIMpDv7oP+Xo6JFWTKJAc6g
         qC6UD0umffssA9y3zn3JrVIAMrWOPAgE6c1O+fp18YtPzVr6b6ujE9+LX7NWrPe9MRU7
         lZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771192177; x=1771796977;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HY4iKSdZnOC2lD9r2U/xlpJrxAQ+ri4/u1JX8B2xnrQ=;
        b=EzAKTag+F92boRG7+7XRiU6TpPD2brfRGxXWcPL7g9QQYrSJVGU5P5lXglv8Io3LEy
         Yw7pW1ARV+Ch3q2G9iJ0LeQz5IFzhNsiBlekRwxqQfSH/upzbKgxnc828q4dRcaMMuFr
         Jc3CjfKfWC3m9qyNO5eKybKIensPgIa61ZMsL/S7eZ2+7qRwdfNf3Q4jvyV2RzhrkYxr
         791edzIckUPUAAqxns6xcdZ6ia2J+ALQqQUPBoLRZ8Idwp8gDsgY2S2nFsf2A4g+ktFx
         Ku6znIc8B0jg0lQNjHnX6dQmwcTvgu7PrxdKA5j+UHcSTOJPEvFW59Ln1FDJMpAfX3TT
         0MVg==
X-Forwarded-Encrypted: i=1; AJvYcCWVuyOn64+dGhH1+l+S+Qgny2XXyyjqAKTdFRuG4RRjSkpjlWf2gmQCScdX2tVoRNEhwd1gqWiEbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyveGMTflI17JR9Qi480qRb2jXk43MPdUpyL+cw4pqhsUFvNvDF
	iR+Dy12oFZIs17thpSLo71YmKjeAL9VQ4cMx8lCzlqdixK63icO+OkGv0T6xQn83Nsc=
X-Gm-Gg: AZuq6aIC3U8zWjqiVkk2gge3/bKGGPB5ytlQwrCiQ56yhsC7mtikI3kdxwlQrzYvxvH
	lv0yhxR5OecIL9xsW3raxthXIeEn98UbQ5tYR/dVk7EhTwLR+UDMoWsMB+mZzCD1rOJcQQMzybj
	LtuzK9ZkAOf77sColEO/jd0ejbxKwqmvDBOY5hCQnOHdodFRF1tBmXZhr317pnyX9fs7zIc+eC1
	eWM4wixnDSC3LzV29r4/S7ZGimsFPZj3hJkvInsId+zsR4QunMmL25DzM6PsML8ct0cR26aFIMI
	++8sHPEjyk+ioqidHuQuyDvx0hoOFJw4M7bJwDOv6v8tNSHmsctghzyNzGh4BDptqo5UOYhXL2M
	cf1jBW339HwtrQ0dwJ4p61Q+sdVZOe4xTMTvsSCyr4GiFFRXcOYu3xbIUA65B1DjvIjufH6KnID
	bVFCzpB0wRM+1FZLJqUkcC00wyzkZEcZ/8SqdtyzE6EQifcObSw25KhKZx7YZHxaKcrob0cr8OS
	F+850hdBA==
X-Received: by 2002:a05:6830:a90:b0:7cf:d9ba:c9a6 with SMTP id 46e09a7af769-7d4d090525dmr4389599a34.0.1771192177368;
        Sun, 15 Feb 2026 13:49:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a75309bcsm11301383a34.1.2026.02.15.13.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 13:49:36 -0800 (PST)
Message-ID: <540635ba-d96b-449c-95f8-bc2a0ad7931d@kernel.dk>
Date: Sun, 15 Feb 2026 14:49:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.0] io_uring/query: return support for custom rx
 page size
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12216-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: F124213FD1C
X-Rspamd-Action: no action

On 2/15/26 2:34 PM, Pavel Begunkov wrote:
> Add an ability to query if the zcrx rx page size setting is available.
> 
> Note, even when the API is supported by io_uring, the registration can
> still get rejected for various reasons, e.g. when the NIC or the driver
> doesn't support it, when the particular specified size is unsupported,
> when the memory area doesn't satisfy all requirements, etc.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> It's a simple change, would be great to have in 7.0 so it comes in the
> same release with the feature.

Looks fine, only replying to say that I think all of the ones posted
today should just hit 7.0, no reason to defer any of them.

-- 
Jens Axboe


