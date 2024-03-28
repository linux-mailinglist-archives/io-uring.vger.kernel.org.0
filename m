Return-Path: <io-uring+bounces-1288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF5E8900A7
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 14:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 951191F26168
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 13:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA9581ADE;
	Thu, 28 Mar 2024 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eALxJRbv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E62C8173C
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711633439; cv=none; b=NrvaS8oP0TqPVFqNLJAZOiEJm4cLQOurYX7HJyYIo59/tgGu/C69Zv9aNaSyJzVFFxO23X8lHVrbCW6SZJ7BgjfUxYiSm3x1fDqPqXDAW29yUUD1E1tnT8aAOLsUNLHMWiy+wTw2SMFuRbrERG8rObkMKeeHEuDqaGeuTPj84B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711633439; c=relaxed/simple;
	bh=qxebtBwnyGPsO2kNr2fwFrTYCj37epzSvHLje1owcyI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y7wrTnPybJImZoA+HFOXbjGLEOz4LduqwY8oPRO4anQPTIuENkGV03Hpcz8aE4QHnC1b9U5QrR5neZX1MMAK5dRL1HV7+v7pbY1lfHUh22k/9NP4Sr9MJhbjw7NDc8y/APJJPSiUKUYGzSqs4421auOferLJHR7xNHddZHfP4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eALxJRbv; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e21db621caso315775ad.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 06:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711633436; x=1712238236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0z5YahbsAjIT5061DUG7My51zSMHhvhSzF4hs3eYCc=;
        b=eALxJRbvLkcPw68Yc2Y728cC8WX2NkckD+ZZwmNG9obp9VoogGGjlsB+WtRiUD76AH
         i5UnV4yNLme7WlmEvtWSY6FPbsLggSgSm7oGktcloHCk0ZrTQZrQB2a3snmMxhkPZmXl
         KCS1/hhtaHlqWZDXF5k4Nvmzjsw/2AcCrMpAbn2HwrvXHXPbkhdOTgmf57f04U4SE8Zy
         lCmJWTknH9xsXN9QCagdiZr9n8BtrGdWY/hJ6gwCbIfMcU/YUtzxceeoD/OtRP+76TfW
         2hB++xk3IkL51YPpPandKgzcKEFbBHWHvJ0XcIbLFhmdDH5CA0Zy0lyl1pSSLjRM8BKA
         xEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711633436; x=1712238236;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0z5YahbsAjIT5061DUG7My51zSMHhvhSzF4hs3eYCc=;
        b=tgboJXwhlhP41DxTkTGBTSyajWXG7iLV5z6k1ehlH6YNcg/RCG8s+yHvEcj8D/8iyQ
         K2wx+UJyM780aebjC+Vu3GZ7EHTzs5qt8qgatZmYggRh2Kk7qZnWCQVMnJ8ndCbG8hIP
         nKw9I1jg+VOclh9QlEWuKRi2/vpY698JMgiyCPxG16uV68Axx8GSz/dGmjSgjKKVZWO+
         /uipqCAGl8TqW0RH00fw7eE7ohb5Xvrj3S437nzBpxOebLs3E4Meb/5HdjxfteFaRz+k
         UyNjy+/VARUI+0DzLqmDP9b1HU5r2jn9+jsVgk9X052qa8Bg0v+DWW375HsiGr/mjUQe
         kL6A==
X-Forwarded-Encrypted: i=1; AJvYcCVA6fLi7Wp3vEB6V2gQrzMvSv97LZyk4dNX5B53faFQHsblOE/nfbLhriv1ZLbGlZnY0YWlJD8GQahScVzSuSChPkmNRcwmzzA=
X-Gm-Message-State: AOJu0Yz2u1d4VAHv7wfIZK8nB+qNpTWtkc4EXwJyJJaZE/9eNH3cGDSz
	s+7YH/0/5fh4+Tb/Q64mSMOY+H8VdpaZoCGgIan22H7JuRQ3405nZnSGkaixbyddzorTZuG6S38
	m
X-Google-Smtp-Source: AGHT+IFnQRsHsmxK4vwmS9Tg55Qe1iLFntXEoAK8JTSx6l+VP7TfB+ycddefH0KZHVT5td0CkdLzTw==
X-Received: by 2002:a17:902:7b87:b0:1dd:e128:16b1 with SMTP id w7-20020a1709027b8700b001dde12816b1mr2739817pll.6.1711633435683;
        Thu, 28 Mar 2024 06:43:55 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id y4-20020a170902ed4400b001e0abeb8fb5sm1564522plb.271.2024.03.28.06.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:43:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
In-Reply-To: <20240328022324.78029-1-jiapeng.chong@linux.alibaba.com>
References: <20240328022324.78029-1-jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: Remove unused function
Message-Id: <171163343470.657312.11623417523875571291.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 07:43:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 10:23:24 +0800, Jiapeng Chong wrote:
> The function are defined in the io_uring.c file, but not called
> elsewhere, so delete the unused function.
> 
> io_uring/io_uring.c:646:20: warning: unused function '__io_cq_unlock'.
> 
> 

Applied, thanks!

[1/1] io_uring: Remove unused function
      commit: 976a421d86422abb554b4544ddcad31f1cade3a4

Best regards,
-- 
Jens Axboe




