Return-Path: <io-uring+bounces-2274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6EA90EF4A
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA111C24300
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 13:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7856E14E2D7;
	Wed, 19 Jun 2024 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GacLqhJd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E23143865
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804670; cv=none; b=QFraSZAjEvMRCbxFxqhlL/bJ5VbBcgwUKzeMsiENLiWYPP22OldUuFwTdse1JWhdYTVZTfFg5LNUlaCBR9EQNsebNAbxxzC+Mn29MF0k3kpqLYCwfoqUonhWJwmhFl95zee5pzIxUxVjH+Fsn6XqSCFhtsUELrxXrbH2BPSokUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804670; c=relaxed/simple;
	bh=d1evMQ5TDD3KQVw9f3rCGHJuhjPG4IzWDJgNFXrQ11g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvzYnZcljIkZV2JPgvRy2rONwrvvWkBmoK/C3gYEXkX+4NhzWIwbTY45Y9OdCRPsGzAaSLoQn2mgfgRyDzT6cV1J+Dhgq0kvDgY8yIQw01aTJPH3Kl6od4wQ8tB6hADisfTIekp90SdEtGbYAz2qIkOvZQ7hpOgkbNjtYcx5qxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GacLqhJd; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f6daf644b0so4819795ad.2
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718804668; x=1719409468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unFPkxNaSRmyqZLjefhV/swvPzm0YvsHiWDHOnQO/ls=;
        b=GacLqhJdayjaUp25pWoXObny7Cgs7Kg5ISwVphM26bKBoJLRp2ixOFhcxzma2BFdhK
         blxroyX8L2Ws9HGWzkb+6v5qsUxTb7Ag12xaK02l7x545JmS/SpDgZcvp4aV3MgYtQtC
         P5Sqjpg5F0QwT1BP//GeKCqxZFLllNCZGFbYkdd5xVcPqg/YGEhtLJLaeorR+Jy4J56P
         XfVJHdksWRqvQ3TD/Me2DoyXXQU9smfT4vagPFaeijGKgeqG/n6vxYTHc6mk0UCCzyWe
         0hLDGkGSGn3i80zcq00ljaOI+XefNDH/yJU7IBn1oTkkmSNV3rjkfA9d9M90VYuMot6J
         2vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718804668; x=1719409468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=unFPkxNaSRmyqZLjefhV/swvPzm0YvsHiWDHOnQO/ls=;
        b=YHHSASeFs7vxrhcZZC67l/QiRNaFUr8oWAmaw6dW1EW8FPWdewo5Hy7OEFS246vjzC
         Uq6G8jIQ/MZNK/tx7SsJmACUCt6SG8MxzcIyaPdOdXXm4lh2sycrZYKXM02Z9NlT9URL
         u6wmMCOAVYUsj+iNUWkzycdqVn3pgX4JQsEI7Dn8Wwb3I57l7xgsmUu3zseKQi2Dy8Ue
         azLmMRKHPvIpf4FYMegRwIEF9cFnG0UK0vG5q5ve9N0LZS9vCR40KVf6k+eR25VnB1Yh
         1D1jul6WfMC8+/5NAyw13Y82PBtxLmtGh0PtvUcpZ0/L0/wGlAP0i2tG7SPH/H7aNFnn
         lqQQ==
X-Gm-Message-State: AOJu0YxF34EPhrrp8KnPY2kNHGADATu2yajvZ+XQ6gScocgZMZ64mcUL
	srYv9XIJQvYI+4mmsN3TLWEXYg0BQ0gqkp5rVmv4TxM3V/AZjkI1URtoQSwK5nKzEDGTavDs6zW
	t
X-Google-Smtp-Source: AGHT+IFd7LQYUGCDwqA6rM4G8Uj3zaO7rorlM+W63aToL0LN9z+6zxn+pDkhi4lgm8HfSSvRiLejfA==
X-Received: by 2002:a05:6a21:99a0:b0:1b6:d2e7:160 with SMTP id adf61e73a8af0-1bcbb151a6cmr2638819637.0.1718804668224;
        Wed, 19 Jun 2024 06:44:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f04c81sm116488915ad.205.2024.06.19.06.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 06:44:27 -0700 (PDT)
Message-ID: <007e7816-64dc-4f3a-b35a-5fed4625c697@kernel.dk>
Date: Wed, 19 Jun 2024 07:44:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: Don't read userspace data in io_probe
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240619020620.5301-1-krisman@suse.de>
 <20240619020620.5301-4-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240619020620.5301-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/24 8:06 PM, Gabriel Krisman Bertazi wrote:
> We don't need to read the userspace buffer, and the kernel side is
> expected to write over it anyway.  Perhaps this was meant to allow
> expansion of the interface for future parameters?  If we ever need to do
> it, perhaps it should be done as a new io_uring opcode.

Right, it's checked so that we could use it for input values in the
future. By ensuring that userspace must zero it, then we could add input
values and flags in the future.

Is there a good reason to make this separate change? If not, I'd say
drop it and we can always discuss when there's an actual need to do so.
At least we have the option of passing in some information with the
current code, in a backwards compatible fashion.

-- 
Jens Axboe


