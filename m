Return-Path: <io-uring+bounces-6404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 103C0A33FE1
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 14:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8468188EFB7
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 13:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD72823A980;
	Thu, 13 Feb 2025 13:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOIaBnkg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E20221732;
	Thu, 13 Feb 2025 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739451925; cv=none; b=gSWvja54UMHxmP2X36D78j4Yi4DUjYhmCRz2zXq+cJjbJZlOL281F7ZGajipQMa6hYO+OVRbyvtZvwpg0wL4t3JNckB1VtdE2h81AxxrXugxuFj9PD7WGLYIu+8LW7za6cuKrzradGe78B4AuHRmmxkVXlQA4tHTG9/TKZQ9GkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739451925; c=relaxed/simple;
	bh=5sRXnAuIDnV9G1PR0cGWGV+JxP3Fg8Z/BulcXwoHT64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ncBi1IPJ3zoHbmS2UkfmeOx+Py7vpc8iHtrIQZfetNc0VkgV9yFgbGodzuH2s3rxQXYvFN65pPNejehvmj6McwER6vGhDNLzrHNF8Bv5bEP2Viwm9M8HoRbR3HoBKWWX3Qdf02p2YOvVgntMlsG3xHrjCc+XU3dHmW5CqlboKUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOIaBnkg; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaeec07b705so135504166b.2;
        Thu, 13 Feb 2025 05:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739451922; x=1740056722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j7nlq4sRW/jfEWtTZUkxQePXzlNZHm3lMS/O1Lofcy4=;
        b=IOIaBnkgVLsxooh6iwUh4L8KUVr03mncaSDgIVlZ/YzMf2kYjMdIcgGU/eCtN6aK9L
         BGqKaFZDZLqi+mfa78Ieo3CBE/Ciq/FgmwtLFmhSDnUnetMJ3+GuiY8Ur/jJ6a+BcLtC
         C3AdVdBOzFlSC52r5GfOEGQEtNqFJ5PP7cNLQGHLnm176vmi+eKv55F+w7E0QWoDVhg4
         Kcb85/Fh9WDZLbNOczYp8QzwXCqe3GdB1X3tp5wzYuzlnLAHonbTZyGVX2B3cgD61mq0
         o1wkW65tPNQ8nF8FrqbYxtcXMDlJ8kuAMb99xs9fyvLuXO9Yp5W5hzotV6hwpoRVhki7
         9qFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739451922; x=1740056722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7nlq4sRW/jfEWtTZUkxQePXzlNZHm3lMS/O1Lofcy4=;
        b=ZH0U5E6fCQJd+oDRctXrme3W42gpbAoxGuAW6l3zyH8K5RtootWFU5RxaeDc4iVXml
         bkC59q0qGMQgTe5yNrieFFCkJaYXg7oJYJNjaEG8fAQstKJ7jL/KH0w0tg2PXhrIWEN2
         5Fpk9sORppnQhDeE0tZr7al9f0kAgeAvkFMwtS364guCiBp6Yk3N8pA9W4sV1hh/A80B
         Za2Tdrp/DlskPiLPLFtnQgnlKj9eh+1w1Xk2yRjvP3lp/vbOWFN2rd0SKuGyb8j+h44R
         6ffMkJ+soKGsc+cfUhHl5yf4U9NXFxQjDBYQFvHOmINeKAUB9W4FGC4kZJXgfhktB1pT
         9r1g==
X-Forwarded-Encrypted: i=1; AJvYcCU+hjVfuRPlzqFKPNXQvjWuY0sDvxX1f9TQx3DHTUSMMz+fGPlNidi8vZDScrrcYoXTD4lPfq71X7g3CnA=@vger.kernel.org, AJvYcCXJOtxk2TnZO9xuzyB61d92LdVKttWqqdQ6dS4sfhcOZHbeLNFZo33a+773gWch0HjHpiD/0K94fw==@vger.kernel.org
X-Gm-Message-State: AOJu0YywWErcndeTXALXLq0Bg1dX/eqQf+RbskygS3mySYGwBLy+NYy0
	UHrkd8OEZ7QMXz1mhqyOX33U9UUPhOxkzSuT3qMkeImpPr/JhelA
X-Gm-Gg: ASbGncsjpDO+nFmEMvGdMY71WfA0MqQuDb+s7U1SR5xQ21QCXOC1j/KxdLZSwfO90wB
	pTFv+O5yWbTZHSBPcinbolIzlrwerkrq93fgTIZ5acxJbwiSqidueCzP3YflKQbZhUKfdD+/XNu
	rMvZPDP6YMD03eGVwaPD8+rPGy/B65skBCGxXEO5dOkBM0yWhkN6iLphz8qSLvm/0HTW2m2Q63V
	mKDv0Iu++/sZYKnYQCARyodz4dmuav26TsQ+nmIfRwJ3JiZvSt9phbIRiJ4/DBtZ64C4UrmuDU8
	296tbQKUafZO+rFpxQWGT1Idgq5J/xHqA/cOYzGIPB+hET8L
X-Google-Smtp-Source: AGHT+IE3E4rGqxr3FNOBb/jDXogjBKuZT/raDLcNUJEcKCyILbMeEgGu7eOnXJDCmMpoxLu4NGs+UQ==
X-Received: by 2002:a05:6402:4303:b0:5d3:bc03:cb7a with SMTP id 4fb4d7f45d1cf-5deade00868mr6858071a12.27.1739451916024;
        Thu, 13 Feb 2025 05:05:16 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1ba9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece270967sm1149131a12.55.2025.02.13.05.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 05:05:15 -0800 (PST)
Message-ID: <1f751a9a-fbf9-4375-a3c9-293d265b6c82@gmail.com>
Date: Thu, 13 Feb 2025 13:06:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 2/6] io_uring: create resource release callback
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-3-kbusch@meta.com>
 <d24b097b-efea-4780-af67-e7a96eb1d784@gmail.com>
 <Z61RyrzGbUopEJiV@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z61RyrzGbUopEJiV@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 01:58, Keith Busch wrote:
> On Thu, Feb 13, 2025 at 01:31:07AM +0000, Pavel Begunkov wrote:
>> On 2/11/25 00:56, Keith Busch wrote:
>>> @@ -24,6 +24,9 @@ struct io_rsrc_node {
>>>    		unsigned long file_ptr;
>>>    		struct io_mapped_ubuf *buf;
>>>    	};
>>> +
>>> +	void (*release)(void *);
>>> +	void *priv;
>>
>> Nodes are more generic than buffers. Unless we want to reuse it
>> for files, and I very much doubt that, it should move into
>> io_mapped_ubuf.
> 
> Good point. Cloning is another reason it should be in the imu.
> 
> If we want to save space, the "KBUFFER" type doesn't need ubuf or
> folio_shift, so we could even union the new fields to prevent imu from
> getting any bigger. The downside would be we can't use "release" to
> distinguish kernel vs user buffers, which you suggested in that patch's
> thread. Which option do you prefer?

I think we can just grow the struct for now, it's not a big
problem, and follow up on that separately. Should make it
easier for the series as well.

-- 
Pavel Begunkov


