Return-Path: <io-uring+bounces-6859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E963BA49910
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 13:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E257016A73D
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 12:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9B725D91B;
	Fri, 28 Feb 2025 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYzRiVeU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769BC1C5496
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 12:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740745275; cv=none; b=GKi08mfYYbzhJHUl2KDITjH4eCWotdhYML8Y4Hw4KIlt1jj8dNuFibQor4tW+5hJMCZPxZttILQdIxMOqZBLlSfP5oFJdeHUHxLaMBrZC8aX7ioasCROP9TJ+JAEGQzAeH/7dLHkRq7whqXf9lwNcG76j2fHuazOxj1JBIY5kG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740745275; c=relaxed/simple;
	bh=m5eThtBoB9Vx6bwMVly9u42jOAxO4dC5R9+nEOA+ojQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTRvDILsGUWwdXSMnx1A+1hYpRuv2rnoLz2OBvbZRcOviWiy10vvCFEQUrWtpXeuM7p3aJkJlmZMhyy4VNO0F6xH9fcBF3nDc8FbLxHAlTXIIztdpcHT/Nhl0gy48x+qA3QTpF7YiW4g7DY6bt1RM2OHAanS9h5g7YVzhIzay2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYzRiVeU; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abf42913e95so30882366b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 04:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740745272; x=1741350072; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9JyvQuomlKlMCkYsRja/puIHYlOc18lsOUoQ/F+kioo=;
        b=iYzRiVeUyvRhDlUB1YMLpBL2Cw3IwKxXs1JQEndaBMGGu8R8Zq0CCavweDgJNglrxo
         TjMlw1qI9wFlAeBZW47z7BOe6h4+NyXs/TR5gZxUtbnhxYvikc2Lok3kObHda5dhnA4v
         UKbk5N6wpQ/m9fUgv3ZrGvNoTcNF+73ziJW2cf822JOEfyg5U52JwjoJV0oaViBY1QI2
         4DdwPabDqtcW0658w2ody2fDzxSCSPqfEbMJMmziUU2RUGheY3yzima2tmS5v8m45Jh3
         6yCcjVAGii2wnfhsL/EWMq4yS01eNyZ9FSiEWMW2EMMMmFBuJxB0OEJinRn4Y72my85d
         bIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740745272; x=1741350072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JyvQuomlKlMCkYsRja/puIHYlOc18lsOUoQ/F+kioo=;
        b=VuvBuM01P1FNlf0tymegrHSR0QNlVdarCY4pb5biGk359iJUsm78YhTGdcMTAJTMYo
         jaB/W+m/O/9y0ILbDdsBagOqYbm/+v08I1brlffLXxn2Jp7D0Gqi3HwAFRVkDgDRPuNS
         guqeLItnPf+sBkAQm9ooTEfv8PNjKCWF8hIIdRn6BGHvM9teW3C0cKsR57xVn11dHPlb
         hnZTtVPUHteUh5kv9wb7kmzeuFZoFl7ckscrPF+VdI/g/0FBAoEjyZ78MG5BePro7w8r
         4uxXVwWtN7HUHjcFf2AzKiLzHMnA0ODamHn8d7fghR3S2nvezjkmXJZbXFA1uF/z7HXU
         0M0g==
X-Gm-Message-State: AOJu0Yx66f6uydOjF7X5m6OEy61S3N5J1v6+CpFO03n5BU7aCKhwgB95
	vSGm/sIHN1KpeFYcAoFuuERJD1tqhG7eiEfnTP2FrllEu0VD+xUvW3OE/A==
X-Gm-Gg: ASbGncu5zcNHJTHGaTE3Ut4usVL2YbcJ7B033UInTtdTaqMFBKHmr+WzGrIky6bCICc
	OdsF5RbfpxHUkxY/UPDTH8SxYrLESUBlHmwRdTiZu+NFcHyA0mQGqHZQdDo/p31TmTq5XJeicXh
	GmWp84EWuKoL2lRs4adbxydEub29fjZqA/MbdT2aen0KjtMoSetatI/nTv0a+jd4cEsWKvU1XJo
	gA2T6k/2ZKsUaqe0JZeYjCBEKVSJQgcFLYBXIJ1sgzKNnN6+D6lhP+eUmwjR330hRcjMfnWTz2w
	RppnkNveaC4Scg6ICEWHvDWaHsBPDF41ygb3eDq/U0s9jlQzfqTrDiET+48=
X-Google-Smtp-Source: AGHT+IH5rQS1V/9iqaeh+TCzqWUSBPzVsZ1M9VVOuDvHwYl027/k5psd+khmmfYu462WxDqEITlxaw==
X-Received: by 2002:a17:907:7211:b0:abc:269c:56d5 with SMTP id a640c23a62f3a-abf2687deb8mr329438866b.40.1740745271467;
        Fri, 28 Feb 2025 04:21:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:aa16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0b987asm287135166b.17.2025.02.28.04.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 04:21:10 -0800 (PST)
Message-ID: <ab609821-006f-4957-baa9-dea4fd566507@gmail.com>
Date: Fri, 28 Feb 2025 12:22:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/net: simplify compat selbuf iov parsing
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <54e4c311-3c64-4bb1-afe8-ed1b32bfaeaf@stanley.mountain>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <54e4c311-3c64-4bb1-afe8-ed1b32bfaeaf@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 09:19, Dan Carpenter wrote:
> Hello Pavel Begunkov,
> 
> Commit c30f89f1d08b ("io_uring/net: simplify compat selbuf iov
> parsing") from Feb 26, 2025 (linux-next), leads to the following
> Smatch static checker warning:

Thanks for the report, it should already be fixed up in the tree.
The check is not needed, it's inconsistent with the !COMPAT path,
and import_ubuf() should verify the len for us.

-- 
Pavel Begunkov


