Return-Path: <io-uring+bounces-5924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D27FFA144F1
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5053F3A1148
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 22:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A4122F3B4;
	Thu, 16 Jan 2025 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oj83f+BO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9EE1DDC3A
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737068289; cv=none; b=mDVQUNm7K4NtfecDvmd7JEjZ373SCMAvj5rpFp9L6GD8XpJbauUh/sMpNPzgekJzM2qM+27Dqm/0Mreu2dcRNiVb/8X4BRZKdPBicRhRiuSPEUKNFdzlqfWVVPrZUsEY7o61agwTvXyHzWUFA+ZzgO7zBfSNcdhF5oSznt4oCxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737068289; c=relaxed/simple;
	bh=wG8ybrhQPlH0qgHahqRIXyGbDXwdRiujLfSLDG4DwgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJPuOxTve2IDEOX0JXW2HXrPVNs4QAVBJMzgCx8sPS603t6Ts0fgpJlmgUIxKCz/TXiYFiEDaZDQQlSiccUzqVqc34jpM/RPlwIJmyobcYn+RprwXlwLacQZqsJLbH0g6gpoEFTLdgh1C3ICr8eaj76Khl0MQu//FaqYjrbE/OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=oj83f+BO; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21634338cfdso37402545ad.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737068286; x=1737673086; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAdViO412rJBSMd5ZtC7F7X2xdparF+/AAUXhyFpiWo=;
        b=oj83f+BO6Jy8/LK1H1uQAaoDdbQ2wV8wl6B1dmO2qLMFWD9Uf03I9T0PC1/1CkwCXE
         JPTb/A0+xZyRmZDMbLqNGRVNzb9o1ixGK6XtTshZol+JBpiWt2pF8BTT1IA0pjrx1gpv
         b32BRdp0X+b+w73M5pyfh4gGHMN8lKz8exsjY8zxCEJh78D0OD78oCjxhkZF7zj3Jy5v
         SnSrctEtXS8hZDwkBOCRmMYVrJoAUWw7IO6r/bEcYuLUXbT/qfMSvJLoXeR3Rsz0790d
         nk90D9JwPEkcCsRi8fOhSIsFUwA1TD9NlAC3KfyV/YtGbdAf5XorG+muWQDThZDrBktI
         0HCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737068286; x=1737673086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAdViO412rJBSMd5ZtC7F7X2xdparF+/AAUXhyFpiWo=;
        b=I2tBBDUOywTFPcG72In7a9+mWyQ5DbaHgYhHGciz8D6vTkUJDtmGzfCS3bSMBv7Qlk
         tbaHEzU3RH6Al3UpzhlW7hZwWC+nyULfbLHTghZae91JQeXDiDggcHApFGqF70mH2l5/
         MjHLfSIlWljmKBp+e6A1Tfa5kn2crYHAoo/aHlwuRPYWmxS2ZB5IIFiRrRFEh6zssQfn
         5GyQhgEYfLKiRiNJGKLQn2UcuiImioNNTB3oDNC8d1ZSuhu+f9iwq/o0LdLDjC9nFExA
         wL0h5yinjr6N57W2b037pPAZsDMC4ovNhe+fW9Z0+OjlqSVLlSVhVu1ekAq9034/lrw0
         Nakw==
X-Gm-Message-State: AOJu0YyIzz4TLRuPhuTzCDo5p3z6zcrw1b2GUwMDYaJwnjeBWdbFZkSu
	mDQcsq3Agorjsn/nnSw+ENSSrDDSHP8FWBL00i/1ma52aFcH4Tf/X8Hqp0T4rdw=
X-Gm-Gg: ASbGncsoL8J8th07gzW66O41t/C1eineWBOC/WU+Bx0NXnQ2CCVOlnq7QCEmDtxxC8i
	NCV+i5ZIeQ8qEMU6d+rmYuuOyyBlMca55Jet0FC/G488X+TQcaqu5V7fZepckJTrWwaQHHVH65E
	X8s+EIK+l4B52LFedDgIXMsZBMtyzf5prCZ626DwYzIBgnMXC1qXs6tfp1XJcw00jXogcSHKPUE
	ur5ymvEnYBcEMe1HwClLthAHgCH6JG5mFcqskerg/rZRMpeJ0PceueC9PsunY/EgZOn4g7cXFAJ
	gREVXUERsMA/fOCjag==
X-Google-Smtp-Source: AGHT+IE13QruiHE5aVNpWWSj1YlneuGOMx0Sf8O089Rg0cxn/Gn+XUzaYoa9zTvZqQPknrNIUV3Hxw==
X-Received: by 2002:a17:902:e802:b0:21b:d105:26b8 with SMTP id d9443c01a7336-21c3553b20fmr7413555ad.7.1737068286225;
        Thu, 16 Jan 2025 14:58:06 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:cf1:8047:5c7b:abf4? ([2620:10d:c090:500::4:b8ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3d86c5sm4747925ad.161.2025.01.16.14.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 14:58:05 -0800 (PST)
Message-ID: <08b34f6c-9516-4bb3-9a41-a547305176a7@davidwei.uk>
Date: Thu, 16 Jan 2025 14:58:03 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 22/22] io_uring/zcrx: add selftest
Content-Language: en-GB
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-23-dw@davidwei.uk>
 <20250115165309.52e94486@kernel.org>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20250115165309.52e94486@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-15 16:53, Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:43 -0800 David Wei wrote:
>> +$(OUTPUT)/iou-zcrx: CFLAGS += -I/usr/include/
> 
> Hm, that's the default system path, do we need this?

Removed, can still build the test. Sorry idk why I added this to begin
with.

