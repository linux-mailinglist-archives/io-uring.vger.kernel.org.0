Return-Path: <io-uring+bounces-6505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE090A3A44C
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DBD3188552E
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D69A26FA77;
	Tue, 18 Feb 2025 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="R+Dv79IL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B426E15C
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899715; cv=none; b=JR1zbAfMos9hNy7vBx3mcCn5UuH4ejjzddgnt0FZ6Aya7qKwq79d74dtiUkePNf9jEH3NUpeEpaHwpK+QYQX5DjRziopG/U3Pg0xlu6Uv/om2NaAgC6KfHemK/tBstFbtufa2dPKDuIGhM0rkSAMiGRD4PJrgMY6TxvJQhvCmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899715; c=relaxed/simple;
	bh=gtjZGPF0rmKFeuxUIYXDUnAhDROLiC8Qq/MN+BecbC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1IR7R78Fn15lt4cgaKTchtX2WNycjl7K5dxfr8CtlsdGVQPOgPrtvu/A37rbeV5JcYCA2s4pP8MT0ejjyMs8K3WDbnjICzdd3Oa39izq6PyL4rkpFvfgf/O38TQdze7WTQx6LN7WBif1t6m9TGKRoFEsEyn2Ntx3WEHtvRF4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=R+Dv79IL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-219f8263ae0so106019135ad.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739899713; x=1740504513; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ww6QDRTleV+FNqDDD2oHhGQWIt1Qb7kbHQ7RmktExQ=;
        b=R+Dv79IL0vVCUNBVFzCj0wiY9JOt8m0usJhsKG+iJo2Tl0hrCPsbYVJDOilQjGIwWf
         xVtRwRyzHDPPJvtWFrzF/wxsWBoELX6KK8xbXofAcCFQQWMgS8cSwk88Tbz/ZZ39//B2
         bOHVMzoRYxmNvDWHbN1Sp4uyiSgqCer6rztqO9c+tQk5K9Gxx26Tms15eu7mvl5ZezmG
         Nydn1G42m4QwmOqD/G1dqaSx/bB9VG/jCJE+h68qtTF3A9iZVX8wermUJ8tBUmdHoigv
         yY7QpyARYNdZPlVmVIBI/93yJ0/yvyzPqreJKEbGSly3Yb8a3A0BldDer0bXamUq6+C4
         k4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899713; x=1740504513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ww6QDRTleV+FNqDDD2oHhGQWIt1Qb7kbHQ7RmktExQ=;
        b=F5wQX0vpaE2T9vCBpdxvhRKkLsvU6gR1Jjw5qW7S/QS48By1o5dHCxkzzCgwpz9awa
         SZtdJvlR6/G1WXpiS5WiE2DGEcMO3gkcOI9CfQjx1EHc05n0eUzzIolqR8YAEJ6jx0md
         LP3hQnWr8q12Nvy1AyF7KXEGsNzQ4f9otf2qmlA7Gs3nA3nVEiC1NWwA0VnW5jW9WC+W
         rynEZfxEitu6SLZqCJM6WPeQysC4M7VyBc3H9VJwRMN/wclYRd+DSkBXfvU3JCBB3oT2
         uHrlyMUtDSdFnPbTN5Y54py1WG/LaUSSZ1R4kEk+Ha3PPWUC+AooUCsg7uY4OlPtzfuA
         RPrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlaao4XDR1gxj39PmQVOt2rXNTA2Y8qLDbk0a/QZDdl2upVJm/jLWxI8/beEUQvQ3p9izyOkxhEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBumpSgMvrulG+ki0YEN7ZJ9bEwYR+hl5cpNk1y8UNrSKR3Y0O
	kwp0hxnp7sOdeRjF8eLSMkVHZRSNBoaXi8CkEhvhFsLgzxHxRsX4/GeLR3HnB50=
X-Gm-Gg: ASbGncu4S1BVoOoXaJkGWFEhnV5noErtugk7OGeNdgNWMns4piX5KNQXlaEZEI1+Nga
	EboZkE1HmCn2TK0yQWEgrdx/VH8wHRe5farDT8aRtfbNZh3pYTzVEoPWLr6QWM+U56x+hSkteCt
	DPmn5JbgU02qiGPHB+AL7+id7uxr+bcZqiWN+F64Pyr1NniIFLugQWGGDoVHqhLrBUUNjAJKTjp
	4eZgkknLKCsTwnIaeIVUfMShvgvEowBpq07X8p725uN9akBg8rTZVuYl1iQI2MTEN+fbRzaxtg7
	0hypGmmXJqGB4Ex/jKQ3rp0txwhUk8bbrA8qX1J3W79SSvZXMvDL/4tJ3eo=
X-Google-Smtp-Source: AGHT+IFALUQOn/fCxRypVo8rMA9ajVW4oqJfM6GB3xy+WhhucmtAEsdm/v/bghT+yE+5quTixkd2Jw==
X-Received: by 2002:a17:903:2cb:b0:220:fe50:5b44 with SMTP id d9443c01a7336-2210408280amr232112685ad.31.1739899713149;
        Tue, 18 Feb 2025 09:28:33 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::7:d699])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220eaded823sm77881265ad.191.2025.02.18.09.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:28:32 -0800 (PST)
Message-ID: <20247047-b9cc-467a-bafa-9d29c684e9dc@davidwei.uk>
Date: Tue, 18 Feb 2025 09:28:31 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 1/3] zcrx: sync kernel headers
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <20250215041857.2108684-2-dw@davidwei.uk>
 <ef292951-e868-4740-8d98-3beed25f81a9@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <ef292951-e868-4740-8d98-3beed25f81a9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-18 09:04, Jens Axboe wrote:
> On 2/14/25 9:18 PM, David Wei wrote:
>> Sync linux/io_uring.h with zcrx changes.
> 
> Some of these hunks seem like generic changes from io_uring.h not
> related to the zcrx work? Not a huge deal, but would be nice if they
> were split from the main change.
> 

No problem, I'll split them out.

