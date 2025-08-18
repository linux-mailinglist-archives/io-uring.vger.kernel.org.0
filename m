Return-Path: <io-uring+bounces-9042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4F7B2AE73
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 18:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 770AF2A3A36
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F98D2571BC;
	Mon, 18 Aug 2025 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMTsz5BX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77BA20C00B
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755535416; cv=none; b=qa6w2d4r/fYRqx57xkJrpfTZHUlKBDIJ/mcZPaIVPTJHtPT+r1eIuJyJxDyBzxh/2cCJBd/xfp33JOmPt8PBFwpZsDeIzupizdTaXvA/R+6tV3mcoNqkF6yvaz68D4b8pzf6bIjn8/HJBYNtIw8zr6X7aMqMAMgmzntxjq4Zt2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755535416; c=relaxed/simple;
	bh=zNsAVFoKqHXCqhx1cl6SAlN3OS9NY/7aFbJ1AnaencA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=reHlxusE3FqKqrfOt4xHsTwekBkwfcy2TelspvCnOffX41Z5cJUz21hziReE0ibMLunmwUYnp6Xftfvql03z0f+4UUHStFpdl+FO3fztEoqnQ+MKkpmUaNIXqYNwKR5zYwi3VO14znzjpyrl/BEaq1B3dhnopy24CCIAXIHxtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMTsz5BX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9e415a68eso2258261f8f.2
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 09:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755535413; x=1756140213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aSK5FXq2BdqRrbArFv011J6I2q+Mab27ZQJa5RRhkg4=;
        b=RMTsz5BXcCcFm/RQXLYPnESZ/fhSCXxhBCcjhhph+XHbYMX1dElK3q+N84gIwwvxOM
         Tk4hev3t2OfzC4eprKxhhd/o9AUbubtq7/50hN4pO9Nh/lHMSTj8ZooX7HNgdPhs3Z4w
         QE8g6pSbcQQlFXhXwTxzPONn8LmK7UxdQbeYrbG2/GSp/0o/7cwfKBPQXRCxUya2Q2tF
         1vfFb2j/HHle2UepK6qGqE9kVS0KdUVTTZZ7M0cDSN+Q+Pjb+MSXO3KxsA0NvTJpIpim
         7kR8nrA3GIXYEbDc9uo7rpUx0kzzrWqUUumA6F6bFEKNnJcwjh5s7EXRqEtAYerR4+lI
         g/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755535413; x=1756140213;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSK5FXq2BdqRrbArFv011J6I2q+Mab27ZQJa5RRhkg4=;
        b=wA/+3BsdGtPKQDLKhwKCj8+o/V+0Xj4Vy4pyKgI2Z24HY8c/O/IDYj2fhH+G+k/jhb
         mjZi/aBueQ6UUu9kBwjKDH58nhfJy1Ki00+TxkQLYr2RMAXLI/d75fkoz3QRE4BW5pga
         ZR9YkyA11aGz8NU68hU+MvRTdTkNmM4FNGnfGfFkQO8ocvtjBhnYnpXBs6bcHU2PjDT0
         ts59LbQVb6zd68zwsPuuzcvCrbTz9pqTgJEYJofo1pFrMcxF0kvEhsn26h2RT49UTP3+
         NN2l9reTf6QJpZ+td1UWMyB3qUFVSY5vp3jD0ts2qkM7/c5Z+sgRRxTp6EfOYIkVj70O
         Fopg==
X-Forwarded-Encrypted: i=1; AJvYcCViQQzZ7xN1aRS7hpeJ+NHhaSc0XlEbpUUATWAPSuzOOFJE7Zc5B3I8dv9kxbQq/1DHQSJOJL8DEg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3u+O/KfOZv3dIyJNCk4yWZN31jmWJdRVSzkb36UE6QEVIkrFo
	XZJOIUYcfdtjSn5/0WuflxlJPIwCk1aV5h+mINdbMIGhW6UrPvVk0f/0GpSHLQ==
X-Gm-Gg: ASbGncuqJbYCHPH2FEoo7ZjgF9qn53mu75B2T575OAwkq55NKWpCPUo6if5prI2cxT5
	2EDIWw2DTvLVCGHlCVU7z4r8UHFiCM1vkCAfT/eguXdSjyQ0mQfOiThX+wq0Towj/imijJiWtPp
	iq7Rbhkm/+E2bZvB+MRZdKrye7p0qtC1myixbrk1Bn6814/gf0ipgwcgVcM10iYqWJD8BqYpbFn
	gFyx9hfAg6tA/Of8iuCFetu04xboCEb1I9py0zeN/ENuikqrLXlqH8aoAX9I3BDWC7UaHmfv96j
	qdYB2O6+EgwLmSU2hlXIybd4D2cd8wNJd0K9g+rEj44PMx8L3qFLegXSod/1NZaimhBZi9HyVrs
	qxc9SQqxzXnDMN5fMuOO6Ru4+tyitEA==
X-Google-Smtp-Source: AGHT+IH7ms4bBZiJJHSQzAdf8wiynnMwb5napnZcTSpYgVhHlZMsrIBanVuf7uiEh38flMnl0SzLEw==
X-Received: by 2002:a05:6000:18af:b0:3b7:6d94:a032 with SMTP id ffacd0b85a97d-3c07e5f0e92mr72069f8f.3.1755535412782;
        Mon, 18 Aug 2025 09:43:32 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07520baf7sm191262f8f.28.2025.08.18.09.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 09:43:32 -0700 (PDT)
Message-ID: <440df16d-fd39-4d64-a1fd-7cbf9888f21a@gmail.com>
Date: Mon, 18 Aug 2025 17:44:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <9f10e444-fe32-4b98-b7c7-29e02e7ce5ba@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9f10e444-fe32-4b98-b7c7-29e02e7ce5ba@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 16:24, Jens Axboe wrote:
> On 8/17/25 4:43 PM, Pavel Begunkov wrote:
>> Keep zcrx next changes in a separate branch. It was more productive this
>> way past month and will simplify the workflow for already lined up
>> changes requiring cross tree patches, specifically netdev. The current
>> changes can still target the generic io_uring tree as there are no
>> strong reasons to keep it separate. It'll also be using the io_uring
>> mailing list.
> 
> I'm fine with this, as long as it doesn't bifurcate the management of
> the overall/main branch - eg patches will flow from the zcrx branch into
> my main branch, always. I've got many years of experience of managing
> downstream branches with upstream trees, and whenever there are
> dependencies, it's a pain in the butt. Don't want to add to that pain.

That's the assumed workflow. Apart from conflicts I don't want to
deal with, it'll likely be inconsistent and low volume; doesn't
make sense sending it to Linus directly for many reasons.

-- 
Pavel Begunkov


