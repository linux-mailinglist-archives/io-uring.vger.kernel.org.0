Return-Path: <io-uring+bounces-2778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8CE9538CD
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 19:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 197AE1F24DEB
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 17:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2241B4C2D;
	Thu, 15 Aug 2024 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxIHUF4c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6880C147;
	Thu, 15 Aug 2024 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723741918; cv=none; b=QCQd1YRs9cuwGmgdEv0JHR0bpiBaej+kk6i4jRdN2NeQqYNYT8MQVIJ1kyJSlSodBEgOBDkbSkvayTEPF/qTs5HnFihlZgsAhBiEXihnFjI3DkRmt8zp8y6AuLe1k+4eQFFNshWWyBKcps6Z73WKma9XqOEQfERRsdxb+gROV7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723741918; c=relaxed/simple;
	bh=H0ZlsMjuOpPdDe678YJZT8KBDRkqNbUp2T0cZHBbWXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=svdtm6okYiqy4WCkpaqaXqbYLUP7YiXBNNjvVhwqjQjBMav70mG/kn0u+zaYo4dv+EEKHzPkYPCJRgiFl8Xwn+fnI8AXVNvmzj5y4ntho3VxTRSln98sCDGgSWutxNSuIO0OgAOFB0SqAR/WafrVEkpDrk7XTG6XvR9yKRf4dBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SxIHUF4c; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5bd1a9bdce4so1544013a12.3;
        Thu, 15 Aug 2024 10:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723741915; x=1724346715; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tEDqj5AZHKQomSC6+htxpXUh32AukOgHaSJDacyC2bs=;
        b=SxIHUF4cWIbzjuEZbjSG4mZABu21HF9CrRPcwkIYOaXbt95hZYgd+uIzYBUs9ciLYN
         EGdtXtCfhpf19bK4D4Lc2mOWHQtJDl0esm8utOG3mxv+Kmz7kLi71IqxFvSNOUI4obwY
         Slq2PCFUN8gbitSo44SxAGjbuhd0lC1UHL36wi+GH+Xxm0VgfVIj/IkH5B1RUbJ09nWs
         lsVBCIbUslBbQFQ4LZHGFNsI+4kzuVqlx1wVwxAI410UXmh8JHmN8oc8kfYU2jzKyE3T
         61YmmKRsyTF11LgNO6dDXX8VLu8g97zD8tLGXi1hfzg6d/6OIfIR/ueg+0UhdCRbQOIa
         kECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723741915; x=1724346715;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEDqj5AZHKQomSC6+htxpXUh32AukOgHaSJDacyC2bs=;
        b=gR4YiCfd7ZMiKyecqcd0x1CkV+A/18bC/VS/+wQqQWd7vuhUXiZdudSBQZFZolMmes
         K1WIFOZITGXSr34mFAhTafQBQm8xOr6rvTjAYo2w+3v1pGY3qaVLMfKkT/CbJKSrU0eT
         SzsRef8HB9eMAw7SumYIKFLSocDb7PdUXkJBwIDPpbLM2fBeG7Qajp5Ywi/uCEjkigMR
         d/zIBL/QBCGq1USBCE3yp58WAdhcaqc/Oef1W0wez4n7c0y2tNzP3rvmP3Vcz7/kqGg9
         0l8mz/gnztr+Q477V3Cqlu6w6+2ck8MsLYL9uEgq0zMo3gT1eaR8istFwK7/BL5eavZD
         ZAww==
X-Forwarded-Encrypted: i=1; AJvYcCXaoAX+2tpYC/hkkaejiqNRbT1yun7fX4+pnSgqK1S4p8hlwDhslceeC6Jp47eoM2jeSBCqmDMSBc0tbcxuoWlK5K8Kw1StWjtpe4g=
X-Gm-Message-State: AOJu0Yyuruk6SdEzW2+1v5EQsjntREK7gLHbrcv/UeM3I2NXZYtGbWVI
	ipArzOqlE6p6LHk/1dsd3nY0+SsX+wk9wkgsT7XQmOpp7iqHbcbB
X-Google-Smtp-Source: AGHT+IGjsj5rtDTfutpHi05OqRVtFGshwby5fAPW/SVT9PnSsBjS3YTpO3WRKIhhmdAdhbwqHjJ+yA==
X-Received: by 2002:a17:907:c885:b0:a7d:a4d2:a2ba with SMTP id a640c23a62f3a-a83929d3666mr17484566b.49.1723741914995;
        Thu, 15 Aug 2024 10:11:54 -0700 (PDT)
Received: from [192.168.42.192] ([85.255.234.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838396dfddsm127380066b.214.2024.08.15.10.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:11:54 -0700 (PDT)
Message-ID: <43d30d3e-b1a2-4ec4-b0dc-ede94d5a4f39@gmail.com>
Date: Thu, 15 Aug 2024 18:12:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/5] implement asynchronous BLKDISCARD via io_uring
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <yq1frr5sre6.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <yq1frr5sre6.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 17:15, Martin K. Petersen wrote:
> 
> Hi Pavel!
> 
>> I'm also going to add BLKDISCARDZEROES and BLKSECDISCARD, which should
>> reuse structures and helpers from Patch 5.
> 
> Adding these is going to be very useful.
> 
> Just a nit: Please use either ZEROOUT (or WRITE_ZEROES) and SECURE_ERASE
> terminology for the additional operations when you add them.
> 
> DISCARDZEROES is obsolete and secure discard has been replaced by secure
> erase. We are stuck with the legacy ioctl names but we should avoid
> perpetuating unfortunate naming choices from the past.

Noted, thanks, the ioctl names are indeed confusing.

-- 
Pavel Begunkov

