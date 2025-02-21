Return-Path: <io-uring+bounces-6618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B28A3FE81
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 19:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE5A13BFFAB
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF762512D3;
	Fri, 21 Feb 2025 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E131DSoE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1141E5702;
	Fri, 21 Feb 2025 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740161589; cv=none; b=tfeUuf1ModTZMqUfrIYhvxuwHTbgcdzo6jQhE6VdMj0+Ic+xVZqkQeUfUw1IsmIfj8vMK0ru/mEjXeX3VAuqo9uPTvkhrUTbTunIQa0DgoURD7ceDZcjkHqBkZNGCqWgb9GQIC9nRoyLk9lRp6HMUcK6ToKJyqcFEkQxqR+oHBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740161589; c=relaxed/simple;
	bh=94MPtl9456igP7e29KUYjgdlNRR3nKkzpc9IoVSnjGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKYi4uvwpgnmwxCaFfJ6pDjCcX4kCtShZKTj3qIwcj29uKLISIAEflhJyYmPk2bjUFgtyp92d86bdy+cEmsgMpIQkdwt9vwPhB+sdkS6BNbIq3rPPIwkkWrBP6coweVTlYJ0DdFabl3MhAZB9Iv/r9hSuQDWrbmoPww6iCEK0FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E131DSoE; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2bcca6aae0bso1375514fac.1;
        Fri, 21 Feb 2025 10:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740161587; x=1740766387; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8O3LA2XsRXgIC4YeeB3PLSvsHSYCGgA3WvbJnl9HPGs=;
        b=E131DSoEGJ7KDVcn4FhdFEZvwNlD0/M6NRhLUWup1JPFjUYLIaXpElH/NlCrC19Caz
         Hm8jUy+wTJmNoMRGSLEDhtTe/AUuUE4dxY9TXQRutCYW7omWFperGhL4glWVukapPw9h
         Pf7pj4TnH0tXDrXisfBjHqGtUxi9fwqxPFclkzJXK/VszpDN93wpSnOxYLAZZy9HmizC
         UF4+CmLiO5hluzVN+E5poKV3u/AhhES01I4u1RgJTChcoU8yS1gjMV1NLDtemIJ4WCHq
         sArLjavncwyHju3qP3UXBbiCoxjTIDOUJHdswL7Xy5RWp5g3Xu1tEDi+I2pj4D22LJnf
         ckxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740161587; x=1740766387;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8O3LA2XsRXgIC4YeeB3PLSvsHSYCGgA3WvbJnl9HPGs=;
        b=FQTlgoYZwPPkeRdHzvcZBPo7NMV28B/DS41UwMencoD/ColyH07q9v3Un4s5ZiWORZ
         vgEaUa2uxMv0TrZUHI8vKjNtBU1ebX2YxMChgoi8OVUW+deiPmx37XIhJ/+7guyfzdSz
         7GdcM4u9YgQ8ptq1+aJEPdgbFB3gkcuwJTHIIbyKDPJ92qW0SK8mg18OD6pk7v19qptv
         P1WFWgWuTV+GKmTcPEBq4HfALfrK2VLVgk9eb6ZAhBSZukOPlDLpPJKOnTrGpI1BzR/M
         IEqAeeH5K0AN2bu3nBR60C7wSBIS1/kH5DOAJoihRMk77u8MwAI40OYY4klYQRo1B3BZ
         46jg==
X-Forwarded-Encrypted: i=1; AJvYcCUtqexiU9rbENghP4mZO2iAM/xXiZPgEBGVpuItT/hK3zeSQVVo9dRy2YL3fEA2Ih0h6cQ/HSOtWTTbFrwa@vger.kernel.org, AJvYcCWIoK8v0sSfShJt5uHOPho98ICuescHl1+WTtxdLlEs750Ia8qf1ONPWQRSkJXFW6BdISxPZiEk+A==@vger.kernel.org, AJvYcCWyrUg17kPtl99vgjW136J+L59Tcw0NGT8+QZ2+Siyj5zcU1G2iwEuogl7BQkKn8oI125Wz3ZQ8E7ccHmLdrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeaaI9AxEBFyPWDPPFUbRm9PtQYU1BC3/ILKDMkLu2vheOW5MI
	l7SSeHWq/FxlWyEyS8sPv8XhhkQdel258bzhy9U5KIyPKzyckG4E
X-Gm-Gg: ASbGncvAvkNIey/ULmQstgxtDIBETAkkwREHCJqdyYSd2dFjZxlv9Ik1myFmgDePOgw
	BeDkH0x0jnczQBz+c/VPHT8muxDowMASt3u9f7LuIoCOZj/qTyXcjxYhRKHvy/dIdbqb5BbboEZ
	iMN9H97/ybRUDO1LoA9dxjNrLpx0xx66sBzRuqZ+1dE39frQi5IVak5rEkazc42ThYi8mhstphu
	SHuoze5JhG18EEOESfbqQZW4EEzKivdJhsLZAk/4Q8Qtp8No6FqCtlriKJHH/nkd3iMRQ0yIeRv
	6oX9mJCSQLCjclAM3cMPhqiYMJHzvKuU5ydrhwLwyk1lCfCFeltWQTZRvtjr1VamveAGcuWOgwa
	8vaYXgAAlFYI6azerIVg=
X-Google-Smtp-Source: AGHT+IGFejK1vySZy/WaN24shXKnJGX3OMsLqzOYf8HrXyomyOQ/LAMUprupOck9gH9z5ZQ2WtZqgQ==
X-Received: by 2002:a05:6870:212:b0:2bc:66cc:1507 with SMTP id 586e51a60fabf-2bd50d01bb7mr3252648fac.12.1740161587211;
        Fri, 21 Feb 2025 10:13:07 -0800 (PST)
Received: from ?IPV6:2600:1702:4eb1:8c10:3167:4d82:8858:3dfb? ([2600:1702:4eb1:8c10:3167:4d82:8858:3dfb])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7272b73b400sm2502437a34.65.2025.02.21.10.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 10:13:06 -0800 (PST)
Message-ID: <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
Date: Fri, 21 Feb 2025 12:13:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
Content-Language: en-US
From: Moinak Bhattacharyya <moinakb001@gmail.com>
In-Reply-To: <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I don't have the modifications to libfuse. What tree are you using for 
the uring modifications? I dont see any uring patches on the latest 
master liburing.
>> It is possible, for example set FOPEN_PASSTHROUGH_FD to
>> interpret backing_id as backing_fd, but note that in the current
>> implementation of passthrough_hp, not every open does
>> fuse_passthrough_open().
>> The non-first open of an inode uses a backing_id stashed in inode,
>> from the first open so we'd need different server logic depending on
>> the commands channel, which is not nice.
I wonder if we can just require URING registered FDs (using 
IORING_REGISTER_FILES). I think io_uring does checks on the file 
permissions when the FD is registered.

