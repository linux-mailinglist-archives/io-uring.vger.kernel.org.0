Return-Path: <io-uring+bounces-10816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C61FAC8BEA0
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 21:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B16E358D59
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 20:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBDE313557;
	Wed, 26 Nov 2025 20:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l7TdgKj2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21602FF149
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190193; cv=none; b=hNX0ZGpVo+3CubdXYr2Ku7d7kujLH75j5l99AJASqyUDDw8pznAI13cwYTxevQ2Lyy/8ZYb9MlwE01R/ClMOg2TMWON+gi/VcKVTHDfd8KhOPLEh8FS3bHGkbYFy5JMlTGc6JNQQx64T3WAcZy2Q1P4wNanq0z20pLd/TjftjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190193; c=relaxed/simple;
	bh=mwU6ARH4dgIjsQUURuQhHvvPdvSnBlU8v57ZDhQA4a0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRQjexryP+ENUZZZIjpLzqPkueQCsyKtfZ437JDn4EXnlBo3pU2m1vbun27+aFgNpUgtDflSPlWtNMWyi/t5eMPXXoKBKZ9ZKQOQeJXusqaXAnLS1NfY+ghBJQC4NR+KH89TlGAZlShec+U5KzzK2ue5x5j1hnAEigQKYwh04Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l7TdgKj2; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-9490a482b7bso7866939f.1
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 12:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764190189; x=1764794989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/8BMnLyOgvQ/XsvoY2PRkIINIcpo+TRhYitR1lqsdFo=;
        b=l7TdgKj2bOoCUueKNwCoJcToTzfKDAJAElv3kyTeHr8rjHxOAoIkwQ0tZW2He9LAEl
         BRMv6tYRC9rHFO9y8WT55DNyvDRUZBbpJpshpWgoweznBBCPXhmdUxcGXIwFJft972rL
         WuYsErbY16BbQSxSd5frafMiBEbUnt7TEj+r+Zb+guJd5PL0Y979uL8mLHv7t/sODmHj
         GSnG6jvjS5/3cGZ9Xrxl6dFtTQOLnm5AUq5Ssvk9mkGQm+6L3xY5aYNt9OWl/t9oj+Kg
         nmHu4hgae8CsNUxsQ7fUe+rT/diKI7htOz8Ct0FqZqQYtr+sqWmPrgXEQqJPnOchOqxp
         P5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764190189; x=1764794989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/8BMnLyOgvQ/XsvoY2PRkIINIcpo+TRhYitR1lqsdFo=;
        b=dTWfi4B6W9rFSxyamkX3qoKLVYULYca8GoC/OqudGzs/5oYV6oVmQ0JxW0vo2BMszN
         yDhv61gB7h0TJ/pHsWbkJv/tJaANhIWKqtvuy+kM1IJT1CZPyXUQTXDZz3d0XmcBMrXa
         44Nz7+wh/MIyaDaM3puIOiXHVRlxhg8jLnKc9+0Jz5mrSqTcu6RvVWtaJuFjDgRSWuwZ
         mwBlI8i3YqokngWMsnjnPayXms6lSfLINIiarVPP8rZkIuxAXYss/dAQqfUG0zlYETHh
         9ragoX8taV8jQtz4mv6nzEHB4STStGq8r9kk1j9NIx2UT60cQmPn+0RvX4oSzqcg6BnR
         3LPw==
X-Gm-Message-State: AOJu0Yw7blnE1DdQUYLIY7EdIM24X5jO9D64FmR1Qa8OjgKcA7yzw1K8
	R4vyw88xiyWO3Sbf9JBfb38NqRkO0ugYK8jyzDHXxKr7REhLHpWp7gYd3kOsRdS5EbuGeVTWBIX
	W64YiL1A=
X-Gm-Gg: ASbGncsLezwx3fgqtqkRRKrSIokA5rsWhRMKRBaefkRbw6FvvRKwEovg7haZLeSjWC/
	ypMFd1FRdRKCH63YKsVCbwMAedCe3hO56sMh0udLZgVGYSCLu7UCWuzKpF8KucnRZQj1V4yK2Ng
	4n44vDdeHyWGL6yEBg+KESPZlboYBPLNHNMfYfrrbcuhDAZd3zaENJ8ubiQv+YwVGgfurFJs4Nn
	jWD4bgEuhFid4wPDEJTWp96C/DlBlZWk0abIeAMxoOusCu4+KIik+ksbOqE6Yi9eDfF6FQivFHy
	tgyknzebPLA4vP6+YHlgcWh1t+0dE5wxYExav5Ta874NAF4L39HhOixVyMIR4INLkOj5AsnLNoo
	fqI5Qx9j5Pjxmv0Qsi16cbLUZ7DHnnZoEnrEjoABhHi8qr0DlBL6CT2L0lBdzGwR3Dy/X4o0Igr
	mj4Feq6A==
X-Google-Smtp-Source: AGHT+IFV2SlMhtsD9fP33WHeclr/rWc/5tYx77NGYma14hzX4gkKXm5HsbeXIyje8vEdIA6wZ4AJgw==
X-Received: by 2002:a05:6638:6a19:b0:5ad:762a:477a with SMTP id 8926c6da1cb9f-5b9995d68c2mr7007598173.4.1764190188842;
        Wed, 26 Nov 2025 12:49:48 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954a44d3fsm8598932173.21.2025.11.26.12.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 12:49:48 -0800 (PST)
Message-ID: <b8d9117f-7875-4b12-a747-5ee80eb5e1e3@kernel.dk>
Date: Wed, 26 Nov 2025 13:49:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 2/4] test/bind-listen.t: Use ephemeral port
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
References: <20251125212715.2679630-1-krisman@suse.de>
 <20251125212715.2679630-3-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251125212715.2679630-3-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
> This test fails if port 8000 is already in use by something else.  Now
> that we have getsockname with direct file descriptors, use an ephemeral
> port instead.

How is this going to work on older kernels? Probably retain the old
behavior, even if kind of shitty, on old kernels. Otherwise anything
pre 6.19 will now not run the bind-listen test at all.

-- 
Jens Axboe


