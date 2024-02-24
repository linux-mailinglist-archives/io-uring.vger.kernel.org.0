Return-Path: <io-uring+bounces-691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8718625CF
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 16:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46DBA283109
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 15:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F763F9D8;
	Sat, 24 Feb 2024 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XFym9LLT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B772AF04
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708788504; cv=none; b=dUVJqw6mqEhk+gCdUks3GdiKEGIE7BFUFU3ECgNmXC8Ht8JD2eTcPuJtOvgaNoydy7gbYuqofWvMsbUWMKF3ixEfmWDP0ij84/ze1uNmLtmgor/mluCUajknQDDD0yiGKE9jQAqD38oXOjj+7gTnfIsON0K3nZxEet2mJrN0Q7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708788504; c=relaxed/simple;
	bh=9Ea4FvsTlV2P26WHmG32F0GNmGHjhOOrd35rDFfkv/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ont6sXyZXyJpRAVAS4efLK4AlXXdG7vn+2P2WLA1p8+gGjBBbhDtQLnov9d97Lq0RRG5iAzEyujSFcgPD8YY16UWtIbhTdWo7SU5CXNmet/ZCz+LqGEdG4okb3icA9Hqtm2NMie9YehaqczfyXUdDuupoGbYGef38WSwxE3a954=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XFym9LLT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d748f1320aso1577355ad.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 07:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708788498; x=1709393298; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z1o9bLxDlaRpdza1gjx8HIzd6nHhiLbDwObdsItndfI=;
        b=XFym9LLTCzK6kMxqZzre1kVx7jDcXzcjtf/cZ+9Ii5h4bVHkrwkIGTkooAMQ7GKXQ6
         fBu+fZN+R7cAVL2Gn+EMj6GI8Kq55HErikVqTyQFsQU5SQTI+YPTwCkki+oUM3OqTWqI
         6B8g0cqdpnSfozofuN6DOcxOCbQxRlMc2Gm0V7752FSBg+Ph3jNYFcq9u+CP6CdFAiCm
         IlTzKXwFLWz6pIoQbB6Mv4TFOvSppeJbCuSv8zlmry0aieDRoeiMsCPKfDyHLciwqq6+
         PDsRJJCAX3O5I7m5ZMNyEcK7MDEN7tP75M6MocwEzvlp4udRNg/aZCKVDp2w8cB1fH/M
         y2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708788498; x=1709393298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1o9bLxDlaRpdza1gjx8HIzd6nHhiLbDwObdsItndfI=;
        b=mxkc2mgb4kbsREDa855J6/rZxXRxDg1cYevaI/83TUP+YncYBTESGzTBVXNWe1wzCn
         uNHbFcGEAonl5H9t5C4XxmA5x/gBNnLKvw2hZoNJppddVB+betPwq7Cz2oxDLG48aiGD
         wjOlvkWCMnKG68yRIaw7Qz4xpunuLWiiwWujTuwn44BTqQQi1kMEOZdGqRWy0TdyTK/x
         3Mrn0xtTbRo84PU9hw8+IXkQTu5vqQ7iuIdR/Rj11t22R0YEUnIASBerWTLKP+yt6f7I
         kAQnpnMVDvsH5gUcNGKFMN3MlLJvmgXbdHurPkhuPvnwFnmpN1yw/bHj9xqorEK6R8sz
         1QpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYv054DWtDWszGQxaRepGkqCihMrwmH7VPVIY5gaO2WwkJDtMV7HRme77XjKkOFFP29qGiagM1T/huRFEWY1oL7FxKTr6swdc=
X-Gm-Message-State: AOJu0YxaYLPe3dq39A70WjVFw7ntMRKK3gnT8CGQZeYqj6ZOaQZImHHz
	S5ASObY/G4XOEOoihZe/atNw4f7xH9rsrT7t0rdMqLGHsZZ8+k8dtNwzUiBp2ls=
X-Google-Smtp-Source: AGHT+IH9CRnn4wnlEfG/buvrhk9yOrP/0mPD61T5LoOdj/K06+P/pOwrQ9AglLTpO3nyYd4DQGVQnw==
X-Received: by 2002:a17:902:e98b:b0:1dc:82bc:c072 with SMTP id f11-20020a170902e98b00b001dc82bcc072mr1926163plb.1.1708788498211;
        Sat, 24 Feb 2024 07:28:18 -0800 (PST)
Received: from [172.20.8.9] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id i19-20020a170902eb5300b001db5c8202a4sm1143844pli.59.2024.02.24.07.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 07:28:17 -0800 (PST)
Message-ID: <9b3cfb0d-8f90-4802-8039-5363dbaf0154@kernel.dk>
Date: Sat, 24 Feb 2024 08:28:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240224050735.1759733-1-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240224050735.1759733-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/23/24 10:07 PM, David Wei wrote:
> Currently we unconditionally account time spent waiting for events in CQ
> ring as iowait time.
> 
> Some userspace tools consider iowait time to be CPU util/load which can
> be misleading as the process is sleeping. High iowait time might be
> indicative of issues for storage IO, but for network IO e.g. socket
> recv() we do not control when the completions happen so its value
> misleads userspace tooling.
> 
> This patch gates the previously unconditional iowait accounting behind a
> new IORING_REGISTER opcode. By default time is not accounted as iowait,
> unless this is explicitly enabled for a ring. Thus userspace can decide,
> depending on the type of work it expects to do, whether it wants to
> consider cqring wait time as iowait or not.

Looks good, thanks!

-- 
Jens Axboe



