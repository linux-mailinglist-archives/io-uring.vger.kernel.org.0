Return-Path: <io-uring+bounces-3858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A6A99A6EB2
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4878D1C227DB
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D679F1CBE81;
	Mon, 21 Oct 2024 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IaiR2C6I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE1C1CB51A
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729525757; cv=none; b=fzWme7DJB/WLLU/C+uWlxaCDXOqgaYHlImfxlvAK5KNXNVO8GMTncugC6zhR/SIsPUoHseKh/quYjRMxow2XDGpk+7xxwCxigo6G1BkHBEi1emAQ1Na3Gl5xgjlE/WpGUOMdc1RscWnZVpuy3/uAwpELbRZzA4LrGXYyQRFcrQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729525757; c=relaxed/simple;
	bh=msVZGDy4mVhsfLXGqHJJGTEHRskWWfG91uBjyKzOInU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HYU9NnXWnAzllIZJtDFNh1ps53S/Buj5u1K5P5Svz9Q2U9nWrsADDlLf0ypCt7/COP+Spy0YCYyZhhs620l5JUFwTZmRc27Ow/vP+ubWNv8ii3/yZ47Gj3ZoWeUf2cZbkEQTTVO6OUnWlv21FeDRa6lUas8qlUuNOZ0xpXAO+4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IaiR2C6I; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83ab21c26f1so174947439f.2
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 08:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729525755; x=1730130555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=niN3KOs1DPdEnajyxaJUtUR7GgXnkEyCWEqT0U12Yfg=;
        b=IaiR2C6I0jKRmCoSCqfrFlo6S+akQUxbFfF/QTBmohcl26mvKqb6zAjg8t6rLTb2F1
         ApU2jCGZ8YKtK1BddWM8FXhu3KxTSB/3SPDR6jQlrMYAD9Lxo2VYoPLJ/uvR/0eZeHMW
         9+ZaCriTudFFMNMvncShioEXVaNEXOKJ00uVsYo4DbaB4Xa48ns6QLia4GF3pIuv9Lg7
         9Z5jN5OfVk/YS6ex0MX7wVne4bfY82WFSZlA3O5Yfu/FiwkvOcIJerBBNI9yILjzb/Ph
         AzoLyHsnE4zBOpR7koXQnAg9VM5UJSRFHIURe1CVLwawZ+eq+Kd57eLMGyj8IwoOQvNh
         yVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729525755; x=1730130555;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niN3KOs1DPdEnajyxaJUtUR7GgXnkEyCWEqT0U12Yfg=;
        b=cevU4K+1zqn7LlOSVBH5iZXMzAe8lu5vbEGmZZP7WdLyUhkcMogMhSYJAz03JUOTSr
         2xS6Lue/s4rhqFJendBOOiWw4iEkkII8bpoUIgCODKr0kPI/S4HeLr32dpk1li9idc+D
         LUILsFeAHRVoQap6F/uV7dSgSmuc9pZj1Yly4oZyJ7HYDsda+liRjOXtqa7mlEPmqZ0T
         yLuiF1hEopcRF7PJUZkiHoUhp6e7v/f6KNBvp1CCkba+DiI9iD5BmBBlDjveTauOoqKv
         Zx5WNvd9rdKr39/ag/q9zvMRkq1H3rPM4+CYYbB2zdb6sOVbG8SUVS7gnSBoDKV9w/jp
         BDKw==
X-Forwarded-Encrypted: i=1; AJvYcCVJIL62+VXxYhR2f30xerB7SdfVFPXJfZVhiDwW3NZq6a5uceXjg8dc469xgDCNJU8CxitIACqevg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOC+5Dt+m0R1Xa57leUOYoU8WWSXnFqtldQHzb5wazV6Q7PPQQ
	B1v9knqSjrT9NcgKQsDTRYDVgjvkk/zKhjRPlyjbqUeK2jqBVYJF+ktNTpgHDz4=
X-Google-Smtp-Source: AGHT+IEO/WXKKacFYxC5i8N8E2bBsnOF2wP7wPz6jq06dzh2X2lthuK7oSFvYWU/9P+Nbnq6s4LCYw==
X-Received: by 2002:a05:6602:1645:b0:82a:a4e7:5544 with SMTP id ca18e2360f4ac-83ae8ace460mr45716839f.9.1729525755013;
        Mon, 21 Oct 2024 08:49:15 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1b0506csm109696139f.0.2024.10.21.08.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:49:14 -0700 (PDT)
Message-ID: <b5d1ce8b-fd7f-4c14-870d-a169d81629fc@kernel.dk>
Date: Mon, 21 Oct 2024 09:49:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] net: add helper executing custom callback from
 napi
To: Paolo Abeni <pabeni@redhat.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-9-dw@davidwei.uk>
 <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 8:25 AM, Paolo Abeni wrote:
> Side notes not specifically related to this patch: I likely got lost in
> previous revision, but it's unclear to me which is the merge plan here,
> could you please (re-)word it?

In the past when there's been dependencies like this, what we've done
is:

Someone, usually Jakub, sets up a branch with the net bits only. Both
the io_uring tree and netdev-next pulls that in.

With that, then the io_uring tree can apply the io_uring specific
patches on top. And either side can send a pull, won't impact the other
tree.

I like that way of doing it, as it keeps things separate, yet still easy
to deal with for the side that needs further work/patches on top.

-- 
Jens Axboe

