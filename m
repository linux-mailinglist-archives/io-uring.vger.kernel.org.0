Return-Path: <io-uring+bounces-2047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A62C8D6C88
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 00:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D249828939C
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 22:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95340811F7;
	Fri, 31 May 2024 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wfrwp7EE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3105D33DF
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 22:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717195110; cv=none; b=npa5BpiVkROsbt8zN3L5l8xE/+UNSXmNokivwCwE/Jxj2Z8HKkMHYcdOhgraMcylsgezaLFmgg8rH7crzj6bc7VconZx8G6T2rGo6kb17OdlTIftsqvrQZeAl32UZjxvWRmGn2hIDNBsD5VbMO3weCRqu+NS4pSIOZyrExdFId4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717195110; c=relaxed/simple;
	bh=h4JyXrJi+gBSa5lLBkpIihcCtI/uR8QvrlmlmKu42No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtCbmfw7s6nhezvjErLsmte1qRsAZMZa1U0OQKmPUXlgazmG0DUcSEj4v7OHahg6lSg0ZiY0DL19PDqw/3JBvrIgdviJ/bvmvpPl8vkzy5sbpSivPhXBwtYdnBLwIo/SbMyoFzmk5m3Af5ElYkAapxM5eYt4A63dQOkwsnz9dH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wfrwp7EE; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2c1baf8ff31so199867a91.1
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 15:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717195108; x=1717799908; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2yYK2uE8Kpg95mWVCP5Xxcz1E+wUtLeP/0NDnddLETU=;
        b=wfrwp7EEPtW85tEnOvNqi31OOQmAL4ZI7w/Rxyq0wpgouTx/3nRC2azUzB9cIirIms
         3uPQOpvftObmN/Ppp2Rj6Nz7UhFb5+KSsmX9Q2OLUKtVpqUVVgvWGhNQhDUY+Ez6iLQq
         8/UMS4VKOS04voejLbfFp1mZvZO1gJbz7Rdoz19B40WfV4nAo8TNMQ3TTiOiSx/NVD/r
         EIbH4+TOt7cj2ZcH0TgJb1RsNmRtJcPBTM5JYqZPDkr1WUIkzuYEHlXi9xf2HppHWqLD
         xXVaph3f8sOuhwjkjQ/Cb6PEaE9ppeyVs7AqiTRmesm0t5DA1b4idCDqaq9swZgqwEry
         3PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717195108; x=1717799908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2yYK2uE8Kpg95mWVCP5Xxcz1E+wUtLeP/0NDnddLETU=;
        b=HuT94xJrF3Z17p8EoGkBR2auQBwvSinVVu35dLjfy2QUggCD9qshaYbw46c+fUrQcA
         GvqgteA8fptg+S8iJlcfw5EugYUvQJhmcW+6fHnCzOUgTyIuIeM6QE6kU803dSoWw1lg
         JuThP7peXAyDWsU4g+6O9lJMJcc2PZRzyMxA+91mKv/O4KzkWaom13c249azVi8mJ9q4
         ap5djm8B3u3Jg/yvnfjGEQ/rel+7HCfXgaJpcTMSZqznT9mvlDWWg/vFVO4wW5WLi3PE
         mPsfYuAj1+vqqWhn4pPGvqoUJztwbdMA+uC9aFLcACyynpc9I1WSvgWNKJZ+L+4IIluW
         qrGA==
X-Gm-Message-State: AOJu0YxkiMBmslT96jJg/thbl/+8ip17o0a2uCfmcPNhk+8PpUZt0pua
	UsvRdMmCUy+ERaVqsPPGSJWWqd+2JSUnymwqOfRgvrefwA7gnYRmbPqou0PR0p4GelurbPQOLYN
	4
X-Google-Smtp-Source: AGHT+IH0rfXY9n2YUbV2OZkf1RvycKt9vdR1xSxO+Y7/mUA2cYgzYFf0Av+XrevlzMEpeatPy65HkQ==
X-Received: by 2002:a17:90b:805:b0:2bd:e340:377f with SMTP id 98e67ed59e1d1-2c1dc5ff523mr3031107a91.3.1717195108508;
        Fri, 31 May 2024 15:38:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c030fc6e7dsm3201061a91.1.2024.05.31.15.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 15:38:27 -0700 (PDT)
Message-ID: <9764e3fe-36eb-48f7-aab1-e302fb9906f8@kernel.dk>
Date: Fri, 31 May 2024 16:38:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] net: Split a __sys_listen helper for io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240531211211.12628-1-krisman@suse.de>
 <20240531211211.12628-4-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240531211211.12628-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 3:12 PM, Gabriel Krisman Bertazi wrote:
> io_uring holds a reference to the file and maintains a sockaddr_storage
> address.  Similarly to what was done to __sys_connect_file, split an
> internal helper for __sys_listen in preparation to support an
> io_uring listen command.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


