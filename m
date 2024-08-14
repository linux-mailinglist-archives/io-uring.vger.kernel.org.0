Return-Path: <io-uring+bounces-2769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C2F951BAC
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 15:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFA521C216E2
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 13:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65B01879;
	Wed, 14 Aug 2024 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o6m9NlFq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1851DFE8
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 13:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723641484; cv=none; b=WkU8rxEEdxpryL8EdtoLyF5zsMCjxMUFfYxUBT+eUW8Cc5V+MehT3Y6KL7zz0FHXRYmlTC5GIxyhsc7c0PpE6z2ouurKXOb8cZa8Gy6tzvUoZj1x+Dg/xmUd+S5etpXlLvlxfa6dZ9+C7arNflnDAUCKUt3kdRk19ual8DjK0Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723641484; c=relaxed/simple;
	bh=1I+cTPzjcUxDabUKeaUo2ikK2SYrm+UZ3pWr1dbAhfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AtOJlukzm3HRNkR9Ir4bY0fwjREH9RER6Vd46xDHD7uvLnB9KL55wNfbEb5Ea/0u0oyY/ZfkyL1JPMYCGVNbuGRQAAxJ6DCPrS+sgpn4XlF46ZtBBGN3KMq7LsyWvM4TLjgfhAHsErGOWkI/JSL+mHfAO3tYycYcT3qIY9RTtRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o6m9NlFq; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-72703dd2b86so33579a12.1
        for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 06:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723641479; x=1724246279; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SmVq3vPDAtlzq78jyyu5NlxulBiXolyiYgJIgR+2Wow=;
        b=o6m9NlFqp0XmY5xX4qKhriIClM/FLlSwxvSryff62ca83cseYtfG5PgtYhnvVaXmxS
         Bi/hUQnza7m/R2HcbIv9CeaxVU6z39OjSwfgVS3akV8uQ/jg2ZaRtZxHriJUWWPOhgUF
         m22dWIH+I+RexZ4oq/jn6q2jW1s0KZv4KbYFUERmvDXz+PkWDcC+as8opz+iBItQeM2h
         Jj4u1BFSINhImjxezXROkDTe7AQ1gwZkpi254tTYzfHf22WijyDDHdAXFZELry4Q6Hev
         OqqsDaBhqWCuxZXmbyIlgq/0i91ZFGnNEWPsgX7vXH6Hvp93znrkWO20DwoGmvAG9N8z
         jySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723641479; x=1724246279;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmVq3vPDAtlzq78jyyu5NlxulBiXolyiYgJIgR+2Wow=;
        b=rzQCvfNYNmKMHDN5gTUDvE9pudpETMD1eOEfJdgZ6ETRS/vYjfsY16v2WLiqCfIG7G
         pUIvbmm/BdXEqY6O0f32wgJlBdxJB0SKblAlW86NQJsmAHvhdKqKnhDswqMYBHLhlJJu
         UxXzFdijeDOlZWcemMzTN4FK5kowcDa+RO5B8ZzP0sb/kfHoIyQN/k28S3z2RB/Jlnr0
         t8W4M8/YD9geoNEkR431H+Rj7tkDac2EUMuj7V5EM1fd5AWmwt4//2aA+Kr/KFskDzlf
         9OS/UyXFC6bODQgPRp7ouWcdFir5VdxpxkN+2kR9BkRuSyRcBVlQXY6Zh3041c0bh/Sx
         jwGw==
X-Forwarded-Encrypted: i=1; AJvYcCXkMbcOhnVibYKELqE19VhKRYVABbF1Huy6bglNPesZ2Yo4eslAwVl7vkU+qUcN79vQvmR+AoRB+Li5/5fDWbv5DkaHLjDcaxQ=
X-Gm-Message-State: AOJu0YwAFMt8QEtASGl9cakdyt0Bk0Ndkq1SxuoAZWRcsBrNwUZXAUeE
	YOJT7oYYLPlIoAYi7wPVrZvInp0H1aEVv6Utdu/PRpQTNb8LA8pb6H5nYvmL8s8=
X-Google-Smtp-Source: AGHT+IG4mZKe3ml0zKtydBNHaK1yxKDC7TxC2dMWsAY/wttfvKmaUbw8Akgd8LDrnzSeVz/gDXdL1w==
X-Received: by 2002:a05:6a21:3286:b0:1c4:84ee:63d1 with SMTP id adf61e73a8af0-1c8eb050722mr2128608637.9.1723641479537;
        Wed, 14 Aug 2024 06:17:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3ac7f9dc6sm1681361a91.29.2024.08.14.06.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 06:17:58 -0700 (PDT)
Message-ID: <db299eac-8a5f-4cb1-9b1e-ab6e86fea9b9@kernel.dk>
Date: Wed, 14 Aug 2024 07:17:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/napi: Introduce io_napi_tracking_ops
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <bfbb03a7ad6256b68d08429c0888a05032a1b182.1723567469.git.olivier@trillion01.com>
 <f86da1b705e98cac8c72e807ca50d2b4ce3a50a2.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f86da1b705e98cac8c72e807ca50d2b4ce3a50a2.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/14/24 5:44 AM, Olivier Langlois wrote:
> At this point, the only thing remaining point to determine is which
> between calling a function pointer of calling a 2 conditional branches
> code is more efficient. and I am of the opinion that the function
> pointer is better due to my C++ background but this is debatable...

As mentioned earlier, your C++ background for systems programming isn't
super relevant here. Even without mitigations, a perfectly predictable
branch is surely faster than an indirect function call. And with
mitigations, it's not even close.

It's a single handler, just do the branches. I don't think this is worth
fretting over.

-- 
Jens Axboe


