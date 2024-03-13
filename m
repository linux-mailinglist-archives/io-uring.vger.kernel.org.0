Return-Path: <io-uring+bounces-934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B5D87B3B9
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C36F286BD9
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41E026AE8;
	Wed, 13 Mar 2024 21:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z2Slq5iY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3354919
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366341; cv=none; b=MYF79y2vHbxwRJdt5BCd1zi+Up3bnsl5g7gRgZ2u5skNSsBFLQBZ0Ip5RR4FD08zpxIbu9KjMULMYANpTSUy/M18hlI7gmkNxwmi+9iye6hV+ZZ7utvbYMRNhqD4hMfbxAf5Zer3KheC5QAiaZjgyACuUpjzT/vyrMb8X1/frE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366341; c=relaxed/simple;
	bh=o1NYvylDLI0jHSB+1v1xdn7j48XRLCvTK7RjrPIWKqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2BbQlTEXLrdExEg3PSCwqCySDj1fptj7A6IfmhlwVECxXWrGZnT9sdyY4gtLiPmOPI/xbze0AWPuuhCIwx8uGp/DF1j0wvSxJLxKRh80zqXsIz6EAc5SgIXE/3VgvxM5sJopSGOK3mkcngrVSTmRjeP3x6dhLRe85D8U5dmO7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z2Slq5iY; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3663903844bso549845ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 14:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710366338; x=1710971138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SrtqkPUIXRCerNELY8daCQI9SSrcolNTP7GKhl7vVdo=;
        b=Z2Slq5iYREgJOundQRcEAGGY15ZkyXvbsXFJjkd8NfMZHxUKPDyjd5oRw9QRVs6hkp
         LMqmFZGoTbxkz3M23AxuQalf10X3d8Sxgq2E/JnAv2MvYOld+M8e6YtlxXUDh3gKCUpD
         5URmopp0kdk4RM1foYUTFlseciycqtT7GFWtYVtONa9qJdKwIXputVLIW3+buQgz9itI
         /LBKvPopnfDpYmOoEYkd6A6hQItQC2WHElCM4ITITn2IgL3wUXRsGCWy1j4J2X6eFWAd
         LTZkw0sT+y8UUgc0zZW8pw1XBS5lCuXp6Ntx7YSdgfXMgLzpPnvF8D1p8GxJM/jOqCdn
         KPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710366338; x=1710971138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SrtqkPUIXRCerNELY8daCQI9SSrcolNTP7GKhl7vVdo=;
        b=ZZHslwJxOLyZLHpPh3GEyb3W9tt6LtOaHWUvgiXVBfexY3GDebovdo6MKi3+GzIx7+
         mT+HXPc2AZm+UtFvhztoyn07JgjVoXalQlsuFt4yU1z7Lx84QQytSqJ1abXG3X7Q7W8w
         P4pj3jJ8TunM50pHkvTiseoiaUFCY4eHiOpRfQ9jE5heib5vbiCqcKI6KpPm8nPb2QJE
         mqsDpv3JxOCiqt5NsQN4IrV/JnV8wfV2efkQoS4iaqnbtYjK9YN52/SbixQ7cOs9/E/I
         M2U2jUg0vOFsfDHS6Yq+YlUmYTHXzrut1Hb9HJsoD74iwftVhxKsqebXvYxOxQxj6pdd
         DUrA==
X-Gm-Message-State: AOJu0YwNglAyvzrLbcvSNJcC3MFsHVRZbduOefrHswRC6do4Qs38aawC
	2uzx0CAZPmAX3RUQt25HXowEj6WbjPm8AH2HXxdkz/pQ9Sdh6wV3Jlm/nQ2RxX0=
X-Google-Smtp-Source: AGHT+IFGI2cN0OYzmmLAAKVMCrW2IPUnyv8c4GTqvRc/dQjSFskIkdBq3m3xEtUbBwx3SkzWO9rR6Q==
X-Received: by 2002:a6b:5c0f:0:b0:7c8:d3ac:2d31 with SMTP id z15-20020a6b5c0f000000b007c8d3ac2d31mr194077ioh.2.1710366337775;
        Wed, 13 Mar 2024 14:45:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f7-20020a6b5107000000b007c8aef05508sm36112iob.53.2024.03.13.14.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:45:37 -0700 (PDT)
Message-ID: <27a9a6ef-c28a-4252-8b43-2b5a056da376@kernel.dk>
Date: Wed, 13 Mar 2024 15:45:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Fix release of pinned pages when __io_uaddr_map
 fails
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240313213912.1920-1-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240313213912.1920-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 3:39 PM, Gabriel Krisman Bertazi wrote:
> Looking at the error path of __io_uaddr_map, if we fail after pinning
> the pages for any reasons, ret will be set to -EINVAL and the error
> handler won't properly release the pinned pages.
> 
> I didn't manage to trigger it without forcing a failure, but it can
> happen in real life when memory is heavily fragmented.

Good catch, fix looks good to me. I'll add a:

Fixes: 223ef4743164 ("io_uring: don't allow IORING_SETUP_NO_MMAP rings on highmem pages")

to it, however.

-- 
Jens Axboe



