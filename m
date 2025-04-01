Return-Path: <io-uring+bounces-7349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BB0A7814D
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 19:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D44188C04E
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 17:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8A920E334;
	Tue,  1 Apr 2025 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oz+Yd8cS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906620C480
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527897; cv=none; b=BgvOHJvJrovTPUuJWU9mKpXNrZ6wzzpLQAgSTO4h+DEpb+LZ9DQS+ysE1XkSnVBYsVP5AVg9dspxj6oivsVH0OGX4ko93VNJkWS0e8hXNuMBsWmCkVPTizfzmI2SsbL5WX4jaJMujL4xTu9JVwrkJBAcRp7dl3pQ2X4eEmcAbRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527897; c=relaxed/simple;
	bh=c9F26dTKGULRsZ+ipnvpBi5H0aWxEsYfF90m4ej8LBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BYXzDNQTyvKP4nRLzjPjtBig44kvGYBNI1Cr6ucJoU8er1lAKsPdJ32WaFemw7xKuDA5FFwVmxAb2gz9sCxNVSVAlW8gXdpkgD8aoYMGZtWRr34rBDkTytOB8zF1xS2i31igJkR5uF7+gLQmCopfmdfIp3Rqc18XPpmj1oY+HcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oz+Yd8cS; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac25d2b2354so949984966b.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 10:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527894; x=1744132694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MgDEZmDXtzHHUT2QfdLbDoGzzXca0leBt5wptEur18Q=;
        b=Oz+Yd8cSNCnpvAW2IW2cCwArDG3c/jdOgJC7OyRZ4AUDtY/afTYcPvqZ9n7BqZNufu
         CJqbypX+nto7t6JGIgkIay7VkJ4SmqxqMWdMF+rLV5fa1erM2lshz9xKUFApqUJR5okh
         fSKvMFsbn0+EMc6QxUn3g2WUhNKjWtquSkz8UmvAGSKvnj6KtS8q4gnKdd633dB2sfsQ
         kWV4upntfjTEI3iV/y3Uku6IBHRq+KN2peLtxEBkUlIS6w4acSVJIgf3UZgTSvdte6xV
         sDofENiohwfXuQ8iCLo6rBsTwsQOI1sJ3JgDKDYryXVdkcBwAh/4wcKu/5rev6RLSRY6
         FK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527894; x=1744132694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MgDEZmDXtzHHUT2QfdLbDoGzzXca0leBt5wptEur18Q=;
        b=JzOZ01HPk0oE9X5acdb5zXN9ewP4OXi3cA2fOwZWt0sP94BFxB/8i21xb91jGoQsUJ
         nomfGcnuN74Pn1htwh7fusTt7sI93yUmH25gujP5L9vcf8CDEBYq08V4EBYNC/N/TNc/
         fjAf6yCRvUlKcs5Lwef3wLj+oxhl+fKy12GWxBck0VdJ3I1epfKFbrW9dL03iDf1Tz5M
         191wf2r6ZRaVbyPE5NADmymddo2mwHzivSkyM+WzfdGMETSg5cONyWFqU/hagv6soTXo
         qP2cFd/k3d+f+RNkH3fLBgln8lznmhJ5KFjyMVbMpGbJo2Hrh1nUfGqsOWPp5j3ZPWnI
         dHrA==
X-Forwarded-Encrypted: i=1; AJvYcCXME4wjIx33pWbwDPOXwx5xEi/BNCRSghHu1STWcb2rgax386+iDNEJRDwCeFOf1YaswkDYx1yICg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1WQ6FR7hEPRLOMqdleBFWK1pQ2BBHF60knpO1GTM1Drja7cbY
	I0esAVj01DuLnGwswC7nISdeKJQGZ8UZfzdPWivsjPw/ovJzlH0dCMfMGA==
X-Gm-Gg: ASbGncs/eCBXgFPk7wmDpAx62/cI5Sak2dMKIiDo11ZWl/PhoSYWVK6Mp0LYrfu5uK0
	ot52wakLO4M9qMFdAXRCMKe+R44uxDTEVqMCZvsqsUduvaZisT+QU+xWJ5/jFbw8SSCOUmIEsBu
	ohQWKyEje6Yfem5bC3vQMUZfALknkSIRsuz3+v6uovABu8LhhIqoZBnkS2gB3UfD4ZPMp5eRPiU
	dOyBvXDUTcXo90pxw4CrSL/t2g7WflFTO8FUyGBJQBvv3B5Di3upE3+9f7NYMHDQJY5Z4bRzedV
	QlvG+0rrsRcCrVla5gFaFMmmtk9vq0DmwcSp0w5DcloWIMFPcJP3eCn0QOgeI5p2Eg==
X-Google-Smtp-Source: AGHT+IG9UOWgoPI5/iEZl0ODej1EUw+IejW3ErIECRRameMeudvuPLy2ZDWLXiKhpb93AsBZ4QbN7g==
X-Received: by 2002:a17:907:3d8f:b0:ac2:4d65:bd72 with SMTP id a640c23a62f3a-ac738bc07e6mr1155154066b.36.1743527893421;
        Tue, 01 Apr 2025 10:18:13 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.143])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922bf0dsm795489266b.25.2025.04.01.10.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 10:18:12 -0700 (PDT)
Message-ID: <b0d73d31-ae08-48f8-a4a9-30f6ad0f1e6b@gmail.com>
Date: Tue, 1 Apr 2025 18:19:31 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: add lockdep checks for io_handle_tw_list
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <ffd30102aee729e48911f595d1c05804e59b0403.1743522348.git.asml.silence@gmail.com>
 <65765d68-cda0-41fb-acdf-58e7b5c1243f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <65765d68-cda0-41fb-acdf-58e7b5c1243f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/25 17:13, Jens Axboe wrote:
> On 4/1/25 9:46 AM, Pavel Begunkov wrote:
>> Add a lockdep check to io_handle_tw_list() verifying that the context is
>> locked and no task work drops it by accident.
> 
> I think we'd want a bit more of a "why" explanation here, but I can add
> that while committing.
> 
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 6df996d01ccf..13e0b48d1aac 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1054,6 +1054,10 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
>>   			mutex_lock(&ctx->uring_lock);
>>   			percpu_ref_get(&ctx->refs);
>>   		}
>> +
>> +		lockdep_assert(req->ctx == ctx);
>> +		lockdep_assert_held(&ctx->uring_lock);
>> +
>>   		INDIRECT_CALL_2(req->io_task_work.func,
>>   				io_poll_task_func, io_req_rw_complete,
>>   				req, ts);
> 
> If the assumption is that some previous tw messed things up, might not
> be a bad idea to include dumping of that if one of the above lockdep
> asserts fail? Preferably in such a way that code generation is the same
> when lockdep isn't set...

We can move it after the tw run where it still has the request
(but doesn't own it).

-- 
Pavel Begunkov


