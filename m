Return-Path: <io-uring+bounces-2695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAEE94E3AD
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 00:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 639F3B21E03
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 22:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE9C158536;
	Sun, 11 Aug 2024 22:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2YRREAa5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3018E06
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 22:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723415488; cv=none; b=cmr4iOey8ftTN3rCRnUKc0iHW4AOPsrnTDdp1Z3FnQMe1YmcKOlG8g8xiKVqjmZVXdOdW++Praq8w7YBYPwIi700VOFyBdUwOZ+HSeK0UHzN0Xn5w/OHEhKEU9SJsagLGYhp7qat2f/voabUE/gyLj/Wga7rdbfqGZw41vwqn+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723415488; c=relaxed/simple;
	bh=+OfdfTWrZamD35pL9yYktI+Dt5/eUQ9Fm82jA9qASaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYeH7UPgCfuCiE9D7+B0mOtXKdjF5SSU90Yp/62oNY/Tn/dk9jLjXsFcuV8jHifwEIH8qaaScv3jl3CKBrW/sWXscukvWwJ7iTrRIHsyLN73gUoYrSYf7nPWYq21fcAub2mhGsTbgwyzpGv3F9Kc9XZDjibM2XuHT7+BgvPrYs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2YRREAa5; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cb4e1dca7aso779099a91.0
        for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 15:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723415485; x=1724020285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7af1Z8J1ZYV7CqYMAIhhKthQdQLBBbwUtlUS/K7Ttwk=;
        b=2YRREAa5RtGY4ZgkcUy8zXfROXC1nordwhFC6XNUqFrn6cB8ZHtKx+DIYr0UWD/9St
         FjyajqA2pdPuJXmtMXAY75hAvYvl3yIIVuYEw5QPnteONTTInTWQvM6lPI6DqfiM6vFu
         7szgxMfnKXaXbU+wO32NPU/lywW966HjMEZbR+nucKB85IulWOc5tGi4eySWAB09lHbs
         uMtJqsDFWImTKldvxP2Vhfj20OH5yQBJCdNeDefBjkqXV5LahLMkygLwO1Z6Ua6fl/Bb
         qUYRkDKS+b95dTb0sM0X0I7qp+XNtdOIIqOu8oZ4N0iYQ3saarZ8trw62RTNJw4ED764
         GfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723415485; x=1724020285;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7af1Z8J1ZYV7CqYMAIhhKthQdQLBBbwUtlUS/K7Ttwk=;
        b=xGjHKuijGyQO6MU/VN6Sedj+Qxh8hFT22Qz/vmVfIrc7I6Xj2sT6ei8Nubsd5zJz6q
         v/kDvhidOBGIUbxYBns1YmpiIbBS4Mm2bGniwq6N1dKXJJjPZdyEOAcqfKRhymW635hO
         ONnlUg9OlAFd4BqRsn7RbUQZVWbDlBWbltm/4Ak+uIfrgxuW6/pkcZkA+tyrWYxTqk7q
         GaECXh4GtY3iUQDDlcUpdAK5BHukNwyIy85i88XhO+6A5PBdboCCDudYOPUdcbw99ygv
         Cdlcd05XrSqaUafum4H4BFug02NFvc1ysPliTJuPpwAY2LacsfVq0n4sFjGwMyJz5e9w
         BjhQ==
X-Gm-Message-State: AOJu0Ywwfy+hjSncNuQ1Qfmha4NVI9iAVUYA4E0CGpEU3jlmgY7QLnAn
	uP4mn9H+uZrfrhWW52YbiYemRMB0XdAFyONuHFoqy5ciY9qeIHQDE50TKhi29W4=
X-Google-Smtp-Source: AGHT+IF1MMidK6QQRpKC6RqrJWEuJ46WY0ivcHc1VEvrmSGeMYZFhKc5OEo5DEy4elsAcIrheg1QfQ==
X-Received: by 2002:a17:902:e884:b0:1fd:d740:b1c4 with SMTP id d9443c01a7336-200ae50e1a4mr62708625ad.2.1723415485466;
        Sun, 11 Aug 2024 15:31:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm26429095ad.213.2024.08.11.15.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Aug 2024 15:31:24 -0700 (PDT)
Message-ID: <1207e17b-7a32-42b1-8047-b01e221ab3a9@kernel.dk>
Date: Sun, 11 Aug 2024 16:31:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: Remove unneeded if check in
 io_net_vec_assign()
To: Thorsten Blum <thorsten.blum@toblux.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240811222638.24464-2-thorsten.blum@toblux.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240811222638.24464-2-thorsten.blum@toblux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/24 4:26 PM, Thorsten Blum wrote:
> kfree() already checks if its argument is NULL. Remove the unneeded if
> check and fix the following Coccinelle/coccicheck warning reported by
> ifnullfree.cocci:
> 
>   WARNING: NULL check before some freeing functions is not needed

Yes it's not needed, but the NULL check is done after a function call.
For the hot path, it's FASTER to check if it's NULL or not.

I can put a comment on these, but honestly I wish the ifnullfree
thing would just go away as it's hardly useful for anything. It's
not like it's a bug to check for NULL first, or that it would find
something useful.

-- 
Jens Axboe



