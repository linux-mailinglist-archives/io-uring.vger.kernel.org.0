Return-Path: <io-uring+bounces-7247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 850E9A7144E
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 10:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C396B3A5884
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 09:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B134C96;
	Wed, 26 Mar 2025 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/k8wAlL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46A15C15F;
	Wed, 26 Mar 2025 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742983149; cv=none; b=aWQwxT+2Yo288bup3fw9prWDHubzIy6pEhTSdQzQIIx7s4nvwY96Ll/EHi7i5ldIasJsDGfR22BDRJPSevaI1KccgapZjluEjFxafMX+1OVieLzKq11wnJEHvQYuzvNYHVovhRXDcRWwq9BfKLxNGjb3ZoFNBS18ZVUgzzW08IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742983149; c=relaxed/simple;
	bh=y9tztuk299UdRpNXuGaiAjztVPhr6IFGxoAeNUIdyd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l33kOMiJlVNEBpgFzRg7LqE9AZWWDCoUEN/173dw/y7q/mrJ3MOHN9p34CSPURV7NgjwX75DTNmwNv9Whcy1XkQw5vB9BGOWX5ju7JLWh7ABXcXh9191163hNPh6Ze83byLlekCQVgwYukdG7FjY0gZbZG65aPaNMyz/PBCHXqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/k8wAlL; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so48403066b.1;
        Wed, 26 Mar 2025 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742983144; x=1743587944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qiqWVPCXem3FfY1XVeoubEGVf4dSq/BF3TTDSEeU8p8=;
        b=i/k8wAlLjXLPxlVhgkdL8B9ihudlaUb24r2T/3Rfj64rULgSJWKgnUE2yankFzlDtQ
         sGm079AiETZRLFRF9MIGdNhJC23CcQcJZ3MXxg9cRAutFmxn6A8e2ncRhu/9KIU5B5A1
         /b8D+zrJJwY3LDz4aVwylittsJtptuaJVX9VelUhT/IcobGh7MyLBYoXCNhwXPQMcKjT
         rz04kFgpGlGw7rvOdrd+j6r5lrBWvuLTLYh75DiIHoB1dsljhYq+Tp3GNu3/+OENEZrh
         g21SkqNx3T4tms/Al9mU+vp+TzDx0SZsxk7DGyqM4C/uDJFjC+FA4Tlz2YHwTmo88qCB
         xZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742983144; x=1743587944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qiqWVPCXem3FfY1XVeoubEGVf4dSq/BF3TTDSEeU8p8=;
        b=BIQGmmoEFPFvxeuUHhrEPhJHfNAQRd8RYbrSL52M7+VLIUhaUFxnxOqItsfpZAHev4
         mIzLf8+jA0wJBwX5hYA99n7vXIzpB9sMG+muOi7DOUJ9SBSjavjVGBI3hKexkMEgq2Zy
         nHLKM2q06h+dEoRH8qW+UxYTtKZloPmymLlkgTui+uB/QOH4Z0aRD8pwJ+gsoNrFVffZ
         WLegmbXU6ZuGmteZCEdkIzrTxEj4yoWp9BMCfXZqiDmAP2FKczTNnoGWoLJK+MLtocWu
         bnxqqyLcdGHtXRfo+wi0dEabW97dXMkoiF4hrWC5skawwteZfg00jYTC6ftCUdHQ0Izy
         JuOA==
X-Forwarded-Encrypted: i=1; AJvYcCXq/JVdFSYjJC5siceXyfAoWx0dEfccIRngGL37JRZm1g+5DzUO3j5hRtOfvmyqIWP/x349GPH0ott0958=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9/bRveS8VEyizmsjACgFxyenkF5fs3/EASW8Pne0WRyzt8wN5
	4zdN+lt3Ejbf2gw3N9/EzfBE1WYSDOgRPF7YI45fBo7qrWpviGVa
X-Gm-Gg: ASbGnct9/0opyG2FI6kTq0RAQpmV0PetuwzNWRjzvohXfLlNaf3dRK+7yOCe0urBXKc
	/0g14Ly3Xm4IgBy4o0pc9ENLAbthsATXcxjCIYvk60RmpFICwpxZFwox1X66Xmsjbfvrtgp4P6V
	HwwbMrZL92FCZ5s2xW8LtTsC+Fe4zIGfOfeecEFtFkzSV9yNQyUAKTI17JOJUG/AvBho6KT8jLs
	VDJmTKzt76cIBy/EqFA9mGrmGcTPISIWyn21D6pA49P9h+K75WuWZwx4NljOZRu6lAWsn3HYtIC
	ZW0MQCrPmPdMc4103TQR92NXP/e4n7g07wpfJMeqw6ioqGHb/TLSgauI8B0uFPYpD2iuWB2kxa3
	JKA==
X-Google-Smtp-Source: AGHT+IGeBRgDYY50CDoknrhda7Ms5GbnFvV0WYHzbanX9icy62oc1vnlv8etVZsU4A5JAEaU6OYpyw==
X-Received: by 2002:a17:906:c14a:b0:ac6:d7d2:3221 with SMTP id a640c23a62f3a-ac6d7d233d6mr355594066b.24.1742983143503;
        Wed, 26 Mar 2025 02:59:03 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cd60])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb52c3asm997008966b.110.2025.03.26.02.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 02:59:01 -0700 (PDT)
Message-ID: <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
Date: Wed, 26 Mar 2025 09:59:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250325143943.1226467-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250325143943.1226467-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/25 14:39, Caleb Sander Mateos wrote:
> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
> track whether io_send_zc() has already imported the buffer. This flag
> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.

It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
looks good.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>

Note for the future, it's a good practice to put your sob last.

-- 
Pavel Begunkov


