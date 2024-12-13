Return-Path: <io-uring+bounces-5492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C90379F1753
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 21:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93211631D3
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 20:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B7118FDC6;
	Fri, 13 Dec 2024 20:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EK5nINVA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0879618F2FB
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 20:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734121158; cv=none; b=JkW4Jrrop/WMcyYrKCFNgJGO29Pvyb5MlWMSuOzP+82QrHM0vVYsnSOJme/kZCU4LWoLFjjDaoyot2UZpaTTun8JNidypeYdagzhFUD6lcuN0CbLKcCeSWWWZBWNHr8yUa/L9MNkSNSKJMrwZRPIn1SSGehuRDHQUiAtd+M2ICA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734121158; c=relaxed/simple;
	bh=smCs9UmXtJPjFiU3uifpihSrf85xBBxVxy499zh6onM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vFYLHOZvkffDr6zv657TrdoH7IJmK/hjyN6c6DYUj+6A+BlWm/Crgdik5zuuRc0wsBOH5ON7fUBjnYC/IuGeBLWS2JF1qjqAGPbZMPSPNL7OulWhrAnnrBNPjTPMg4ipKVtOrF01Bp5FUhg+OBND/24/13d/aYxzgmOvCNHLLgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EK5nINVA; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-85ba8b1c7b9so1082029241.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 12:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734121155; x=1734725955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/lDloO6Oi1p5gWtp9SabZKV2wm3DDD9SCjB4kdUqBlg=;
        b=EK5nINVAp+eoPEzjtuqULaYEyH+HFMeZaTb4rnVglnsx29HQw1VVBc9+DO7WWNCtIl
         Usw9BF4pAGlWHxpf6j3QwSXseBa5zEz2byqWTesgTsAN1njEA+akNEud2dFX/rQzpcWK
         I7KG8Enr+eoyVoBhtMibjGQl8mVqlQDelrP9KnR8rXIZ86iMETZ77giFCDTmj53IQOuC
         DiEz/DDEqikJ5Q1sYhYt/fLKLaaW9tCpFsfYOXa0DzV+45l57sbdsmwZfuTPcFVg2WyC
         bMScuHCzKXE5Zed6+In8PEbA+YY6ICajd7FAl2lq8MTrNmEqL4CRs+T8a6bmAMrY4LSt
         qnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734121155; x=1734725955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lDloO6Oi1p5gWtp9SabZKV2wm3DDD9SCjB4kdUqBlg=;
        b=m3ZFKV60WEXPdHIRScIF4zppb3ivIQqAeSStSmIusgTnR9k6hIrFuQTfzsRi3DInCu
         0D7DigzNQ86OZgA3fRCUTiArOEnNsBZChIgyaTLr+2lqLZYkXSxN3/cqc73aqWnH4XiD
         VjyqQ5B7eLvFG3lrfu/H7CgpMb0fYj0OG1DedPIFyYuqHvspJI73CRDAliXziNSU+Mdk
         fYV8IC6dZHpgV8+9R+yILNd3W/lYXdcniAuzRcuL9bTdXa1RK31UneJobFlODI4dFiPo
         CaUwXDYV6LszBvnFt3vhRh6fLwX428P73mZT37ZW25jqBfuwlkN50lQqp2CHJpCBpR6V
         fHeA==
X-Forwarded-Encrypted: i=1; AJvYcCXNFhkUT3XL+mF+NPXPJd4p4ld+rn93wyBQiSPeUt31l//d2cXzzN4pcyU8zC6k9Li0Pp/o2MgIzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuKTXSS8mnXf84bIdp2aS10WxYtK1vr0i5Jw6fKqJErbk+KZT+
	b01U0XBBnAmQ875LC+w2q0StyEmegJVnQne6gi+WFr/EdaIgPGM1/uCxfLQFzYsO701nkxTL/M2
	V
X-Gm-Gg: ASbGncs+pNrcMCQFFRA4GDEeIYY27nCBhXXTSC8avqW37flkW8fA3J2HIIayB4SdGEn
	VWMjFLY06nCG7KhhDj02YAeeGiT8aDd7RmniXzOWspPGtWvtH6mpEeOKfrr9zqXkQqPh4mutexu
	WkipfNj4ykcmeS3xF6xgu1rOeQpjKCP1G6Aias7UbTipfNHcMY01gWpEYAgldk4duD9SmeTpCPS
	MrO1scvfLYtu1fJIUyOgUsVp8olEP0AbYY9urnhTQ8+s8ORDAO0Vw==
X-Google-Smtp-Source: AGHT+IFWQ8O03w9sCZX7QdUh3+tEkrMGP05QEC0pcj2VGuP/WOMg+0K2J7T30/VuJZglaUiqpxb4ng==
X-Received: by 2002:a17:90b:38cb:b0:2ef:83df:bb3b with SMTP id 98e67ed59e1d1-2f13aba96a6mr12293455a91.8.1734119432568;
        Fri, 13 Dec 2024 11:50:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f142fa1cd5sm3566691a91.34.2024.12.13.11.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 11:50:31 -0800 (PST)
Message-ID: <3464006e-e1a5-48e4-b229-4c1c8609164f@kernel.dk>
Date: Fri, 13 Dec 2024 12:50:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] btrfs: don't read from userspace twice in
 btrfs_uring_encoded_read()
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241213184444.2112559-1-maharmstone@fb.com>
 <20241213184444.2112559-3-maharmstone@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241213184444.2112559-3-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 11:44 AM, Mark Harmstone wrote:
> If we return -EAGAIN the first time because we need to block,
> btrfs_uring_encoded_read() will get called twice. Take a copy of args
> the first time, to prevent userspace from messing around with it.

Looks good to me, however I think you'd want to add:

Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")

to the tags, but probably whoever applies this can do that.

-- 
Jens Axboe


