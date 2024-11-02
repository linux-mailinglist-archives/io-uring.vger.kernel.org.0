Return-Path: <io-uring+bounces-4358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BDA9BA0D7
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 15:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C14B51F21983
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 14:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA68189BB4;
	Sat,  2 Nov 2024 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i/CK/uPX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1699A5A4D5
	for <io-uring@vger.kernel.org>; Sat,  2 Nov 2024 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730558652; cv=none; b=ashLqq/5diu1eIebJZWSRPrhOTy5nSqHs+c7vhoiUYNwdynY91eo+qY3+lEmq6MPP4pIFirfV3zF3xckF66LIGpQxO6Mi4dB0YLqTJasquEnC3k7BIzZnaySUnYcaqHzEPNbioodOd647u0cAAWjLAe2lIzinNgOcQ/b0yqv1Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730558652; c=relaxed/simple;
	bh=NAtK0BpfLQweZNEDiMddK8CzHueYVP5sSNFYzYeYoP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n/aEmrGvS3e6jBcyV6vS6m7FzKErqah6Nv/BORFEjswUJJzkdj9xOgsN3a9UNu7juhxJDaz0jXsW/UrXk9OO4Ara4XIVgNqiNJhLpsfsaWXWPKFQu10U8PpdACE7f2JBqlOqA6plmO6XjX0GHb1CRAP8twVKwSBLr/2xKAwIKvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i/CK/uPX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e79f73aaeso2422683b3a.3
        for <io-uring@vger.kernel.org>; Sat, 02 Nov 2024 07:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730558650; x=1731163450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pXIG4VWB6B4B6GT6n5+B3SAd2bpC2cvEV7gDXJ3W7y8=;
        b=i/CK/uPXEd4vA2X6vg3pYxdzE408WOZjH6rfQ4YzHI7Fb+6nX2iNFg4ZK824d7YF5e
         8QW8uB2BdYY9+4h+zhjcd9cmGXMjwn65XH7WKBiIeCJhTc1ZlV/nfZhOz+UQhJyLDxO1
         Slcpg4TW8fkGzCi0Kr/LDjbBAb1GKVPhqcjAOeDNq3ramPVlaIH/8ULSNOCzF3a9/Qu6
         4GYeXTxH/VlIVGdvUAYJiCwXQAI5189N7evi3w7fd/7SI/v6mXGtbsOqQevRyIEibXsj
         KZdG3TgUERrJHon8Iu41LhkN3tlDKCUeQTGDVW5BV+W6Cf8Yf/IhUezFDTrKRcH999Kp
         a3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730558650; x=1731163450;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXIG4VWB6B4B6GT6n5+B3SAd2bpC2cvEV7gDXJ3W7y8=;
        b=Q80SiDKGA9zPlRPX3wggjeLMRZrJFSGPvA1KUawxTNDScAHy0Pjx7Qd485Mgt8tTyQ
         JSnR+EjI1lKPot5bbQ44j3dl/SmGXhEFcY2U+oJvTDyfAU0EdSLJI6OzeGAsNI0hShEt
         2TFe1WjF30N6shJDFqzQGh+8weO9hWJxGvn9r3NoQN8WXOp7zGpKdZ+6WBp5ENWaDtGZ
         MH9i+hKbdwm27V8rI0TiG0watmeSk5Kt+NynD3PPTql/kGd8QpFNhhzNxra+mKL7qxhn
         0kHpdcjYUztZnCultn7f8V2M/w4/J8mbwhTtr47pb64SE+guexfLq0Yot3hdCXpZkntK
         4OjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdk9XjnJVaeAKjTnF00AAZXwdr4be/iugHFDr8vqzfId+Qe7YfrFu1ElGEDLwrlAqisVE5ORW9eQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywkbtvl1X1+uAUpHn2o9lyC1cyfEVxlkwtiY3VsKObHHM/+M9DT
	jHwJYt9jEVl1apPQsd1ALAgjizBfh1aM9Tfmh414y4Izns3vDladty7wZIMW10GGUiDdUsC3+KI
	J4UA=
X-Google-Smtp-Source: AGHT+IFibsSIRdCwmEeU6S8d2/XwR8LxZJfykax4TcgNvqtUkbWwJBcYMlM0hMxEMl0gCP2ibwfRCw==
X-Received: by 2002:a05:6a00:845:b0:71e:6e4a:507a with SMTP id d2e1a72fcca58-72062f4f6c2mr35374210b3a.3.1730558650398;
        Sat, 02 Nov 2024 07:44:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2c58f7sm4302022b3a.140.2024.11.02.07.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2024 07:44:09 -0700 (PDT)
Message-ID: <bf55cc60-09d3-41bc-ab36-e4e460d8d664@kernel.dk>
Date: Sat, 2 Nov 2024 08:44:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] io_[gs]etxattr_prep(): just use getname()
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
 =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
References: <20241102072834.GQ1350452@ZenIV>
 <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
 <20241102073149.2457240-4-viro@zeniv.linux.org.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241102073149.2457240-4-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/24 1:31 AM, Al Viro wrote:
> getname_flags(pathname, LOOKUP_FOLLOW) is obviously bogus - following
> trailing symlinks has no impact on how to copy the pathname from userland...

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


