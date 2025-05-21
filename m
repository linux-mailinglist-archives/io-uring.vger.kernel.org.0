Return-Path: <io-uring+bounces-8057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E595ABF5A1
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4AF11BC4023
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E352641CA;
	Wed, 21 May 2025 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="16QdzwzY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16B2D613
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833022; cv=none; b=haHThovl++PgAWGA2sRxhtz93TDiKvToG8dx6/qV2DQ9kyQeJbsXDBJnUSb4PwZJgvC3NodwMQomciIx7CvzprZbO1KxvhOF4/+ZDl/+6hlATquSwdGHOWx2JN7qegeTwesfVNjXDpyYUacfUjueT731dFoD2f9PcdIBEaVUNWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833022; c=relaxed/simple;
	bh=D0UN9r5G6cseOnLyeb/cZ9pWLTKQoX2q2NNAaxDUGFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fYNnJ+ApQwYjSEZ1pTdxcVAEtLGTZX5ZdEtO92ynPxJi/HQITPUi/ivYtRaeS+Oe91HedMNDh1Ns8Lscm5wydUca6z6UZ8xucREXyKdzCWXqWWx6hb/BXkRVJIyQdSnbFwFi0/JV5W9H+pyBIENJTnzGVa/8sTAQ+qGD3YPvrJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=16QdzwzY; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85dac9729c3so697525339f.2
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747833020; x=1748437820; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qQZuFff6C7lNwYAxPy5ySQ67jHchTpc/yCT6GhhDW34=;
        b=16QdzwzYO10BMu2AzodgRanwDby6W7xi5tG7EzNSsZIS0mzzVlh+d14ULoesfsaBYn
         y+8I7JAX9H8z092ckUmfNie7ppEga3flZKatXuzJZCu7iJGs6PvCk1p3WT3S/uUWcLdj
         h8xpCDVZ5Pj7hT1ChWVybbRkKNVlLdOsVKnQHFqW27B6PheUGD3vTAjZNXTkMJrCvnoD
         sts0g/fwG8s1Ju1tsc5BVO+02h+OIs4PeyYMWH9noPhLGOhjVB8yNCBzVpHY7MS620fc
         YcFgDJWGYajQTjvcdGa5/vDY/Ln3SA19mA+fZCmZtawB/5gjhfL8mikb/bIzyr1hDDUJ
         o/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833020; x=1748437820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQZuFff6C7lNwYAxPy5ySQ67jHchTpc/yCT6GhhDW34=;
        b=DkLQZH6PEkDb+s/Ui5DnKGAOxKOsQf9h4gkHaoqrZ/bOULi+yPp9I6QrjdjkGSWJNX
         tpvBYI64PnKQx1BU9xxSiD2q3168si07ncvwb+AM+oE7/WVOms1Z2Cbzno6B8SIGnvjZ
         aD0abofuKc2u/uVExYWe6+sLGkH004FIOF/uDi2MxaHhSmjfmR6g8UHpk5ulqDfWf4yT
         ZBfZDzOC8D1ucO8hUOFN99SNPBNIMnv/irc6SQ6DBUEQGhba2vR05OBc7Lj7diRuMeiO
         B6yTIhC5+W6yjo/zTS3Pa0nXF2azHYZwOGUcK+x/tbiQJ4JIzwvbM5xGNS7XjK6qKtfl
         A3og==
X-Forwarded-Encrypted: i=1; AJvYcCV7KtIRj9WYh5eM/L4pf/dhwytkYMhXmQz+wiil0+9xobWhGVfevSh5HNY3biAdvScKQDpHW/7WiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YydYtPUsNH3iWmsICGFihzgbYhp4ULnXiSneguZk5snDe3OS0jq
	bvhJrMc59gGmm6Jxgz9RVCJ0QKAQ+Sdi75MYAnX8qXmsWrZSCC//UOVpnlvLN2qqkLM=
X-Gm-Gg: ASbGnctItWwLVUlJjo085STTwl5nDlH86ZJith+FuW/OXZCUiD7uhOT/KvE9Lmy+GUo
	SSELkdTKObi33AaaiROdIQNfsPFim84lUq2yqxoIKEo+HF86M+7xbz4zehBFvjDtX3UFmVQBWI7
	d9vK/jXElkJ9FldfQUVf39X5X2TWTmkJrNL3XVdaXGtRuFU1sBcvFPYUKtzwlY+EEgQe9GHYi9M
	A/J/Yy9+vAI1L3KCXdGKXd9LK2LZxWat+dRTXSG6QJDkcQS/id4mICSNtAEjXU53LiaCZ0WxOT2
	0ocQmbAGpd2vYUjON8S/CP5qWXz2BpH/qTCp0XSRo8rGXWo=
X-Google-Smtp-Source: AGHT+IEv8mj/IbuRsry5Cchrdy6htke+YHXvEpLiprdbro8dFjH0xO+gq+ooHELvdpYbIKGyUWy/mA==
X-Received: by 2002:a05:6602:750a:b0:85b:43a3:66b2 with SMTP id ca18e2360f4ac-86a231bf7c4mr2716134039f.7.1747833019805;
        Wed, 21 May 2025 06:10:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a5b2sm2696459173.9.2025.05.21.06.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:10:19 -0700 (PDT)
Message-ID: <2f4cbebc-987a-4c82-b51e-64e47cf2c683@kernel.dk>
Date: Wed, 21 May 2025 07:10:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: remove
 io_uring_prep_read/write*() helpers
To: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 anuj1072538@gmail.com, asml.silence@gmail.com
Cc: joshi.k@samsung.com
References: <CGME20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3@epcas5p4.samsung.com>
 <20250521123643.4793-1-anuj20.g@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250521123643.4793-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 6:36 AM, Anuj Gupta wrote:
> io_uring passthrough doesn't require setting the rw fields of the SQE.
> So get rid of them, and just set the required fields.

This conflicts with the patch you just sent...

-- 
Jens Axboe


