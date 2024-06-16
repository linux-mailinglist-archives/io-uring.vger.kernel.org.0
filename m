Return-Path: <io-uring+bounces-2229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F36909EF9
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 20:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A69D1F2352F
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 18:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17971847;
	Sun, 16 Jun 2024 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bw5lCHO/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F2245979;
	Sun, 16 Jun 2024 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718561303; cv=none; b=ij87apTDf2e3N29/7LaMswcdYreXTtUnlGYazfw3zaWStuWeJqppzzaqnWFwv0yxTzE0LIUyjoxzVsCKz7UGUleSAFoH3H6ezM5YNJkUCY+681OzyGdcHyPLly2IpAWJRQgbs5F1EHEWtvnPf5wDIcqKvO650exSYQjzr2a0oJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718561303; c=relaxed/simple;
	bh=1uhZvGKbri1xOX6rBi5/6me1PZnwzaECzzClFjvB8YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIyCbyaQJXcAphI+WDxVPDze9YgusiE+zfYJ8qZH9grQCSHrVf3MEf5e2959XsV81ZEfiF/ICQQ42blyH5qREECwgaeOn11Co718AEdyOOCb1hF95HSpbMZEWunui6kSgomqtVU1tQXCeuzHVfWyLbJpJcSVoF3SLHUZ0EH84S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bw5lCHO/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-421757d217aso38867855e9.3;
        Sun, 16 Jun 2024 11:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718561300; x=1719166100; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xmcC3FJvn7LpiPvaCityDyaQLc5wEQ3ToOQhM/Ofe5A=;
        b=bw5lCHO/2FKjfT7k8LJG9u8/2O0OWeLF46OPzzw0gE4q2qcb4mBY+ciONGrFeMP5wP
         /R4mF8L9+5ZpMQv1m/64y2mKpJ1gmycY8h01d/x2CjHNIGddiNSp3zgoX7VLveDlr97E
         ipdrla5w95BAdt8jboEFfEUaw3DFmaxThMQwCMddkJkua40qwgi2oLvTrzDF3z88rLvs
         yaBusCl6OzCuwXheo2j0nkfGWJYIjgkoMjc+HUmpYaHbkI9bXYdEVjAvz5aCNezP6RpA
         u80mbjPXg+HvNsCG9JH3xm1b9bYQiecm7j8iiMsJfl/xS7tfg8sczYqfUQVC7aeGjS4Z
         3LEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718561300; x=1719166100;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xmcC3FJvn7LpiPvaCityDyaQLc5wEQ3ToOQhM/Ofe5A=;
        b=vpdhqeR+/ler410HXxBN9MrRVuD2GaeA15J4YtBeTxQtZGegMw5268vFyOZufAmGxm
         MvBPLaNhjw0Y+Ah2xHaRFi8CK1qiW7hWP06uW5JLL2zSMxBkXSwpFPccw09G4b9XrJm2
         rcBSHdDUY3PryZb9ZFDw1kyiVRd2KgqXW6xQYEmbJq1bCGm+MsG9p5o3dsm9y4qhRyU+
         tOJMDjmOCNKlLzthqKJY9gwRMOKpcz9+8GEsoPOa2HLuiqRR7DwBD7UpE7XAMYwiIFB9
         yUOU8nI5Z8OHMKKc4p09HTw9d8bTRrtzLid/RtuHHJjydlOUQ+0aLVg4dwbJ6zxCLvev
         Fmyg==
X-Forwarded-Encrypted: i=1; AJvYcCWAfErwxtuaR3iyUqs1zIhvaXmbP8109/CFAljUBD00DrzCfNNKKaw3JQ9spp23GjMW3JfnnYLvH2HRfJmXsRia8YxH2h5vUj0Ft8iK0obpJtQ+Nm2444kVECP/siLux377MPDb9Q==
X-Gm-Message-State: AOJu0YykqBpqgsF3S7cFx8YKQzTRzPPtCK/FJbDCreqjoC0gtvUKxMaK
	bXqVFra/5IZJANBHoUJ25QEY++drn/BXikUuLLPJtbZRdO8lF/oX
X-Google-Smtp-Source: AGHT+IGK6olIz37cd2rcPur+t/H736lQyx9+D8tcxsS6flf5NFktKp0ueqO1Ip5nuzh0MuWGRMMoGQ==
X-Received: by 2002:a05:600c:5487:b0:419:a3f:f4f6 with SMTP id 5b1f17b1804b1-4230481bc2fmr76578125e9.8.1718561300485;
        Sun, 16 Jun 2024 11:08:20 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.147.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286eef970sm171302355e9.10.2024.06.16.11.08.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 11:08:20 -0700 (PDT)
Message-ID: <0a9740ce-c78e-402b-99f6-046864025c54@gmail.com>
Date: Sun, 16 Jun 2024 19:08:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] io_uring: move marking REQ_F_CQE_SKIP out of
 io_free_req()
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-5-ming.lei@redhat.com>
 <f7b3164a-b9a5-4c61-84c9-ff5b18e2e92a@gmail.com> <ZmhQ8X6q2RvKpn38@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZmhQ8X6q2RvKpn38@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 14:28, Ming Lei wrote:
> On Mon, Jun 10, 2024 at 02:23:50AM +0100, Pavel Begunkov wrote:
>> On 5/11/24 01:12, Ming Lei wrote:
>>> Prepare for supporting sqe group, which requires to post group leader's
>>> CQE after all members' CQEs are posted. For group leader request, we can't
>>> do that in io_req_complete_post, and REQ_F_CQE_SKIP can't be set in
>>> io_free_req().
>>
>> Can you elaborate what exactly we can't do and why?
> 
> group leader's CQE is always posted after other members are posted.
> 
>>
>>> So move marking REQ_F_CQE_SKIP out of io_free_req().
>>
>> That makes io_free_req() a very confusing function, it tells
>> that it just frees the request but in reality can post a
>> CQE. If you really need it, just add a new function.
> 
> io_free_req() never posts CQE.

Right, that's the intention and that's why it sets
REQ_F_CQE_SKIP. Without it, even if you patch all call sites
that they set it themselves, it turns into a misleading
function.

> This patch can help to move setting REQ_F_CQE_SKIP around
> real post code, and it can make current code more readable.

-- 
Pavel Begunkov

