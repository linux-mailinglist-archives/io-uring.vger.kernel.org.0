Return-Path: <io-uring+bounces-8535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D80AEE610
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3987189A301
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865A62D130C;
	Mon, 30 Jun 2025 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iF/8spBt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C96C5695
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305407; cv=none; b=liNuFjwI8WuviQMBdPewmsz8Mi4tp933RcDvWCpObIWLGSsp3+l0VvbTKSFQb5FzNT4/omql4GiK7IuAgROpAJNR4hkzFr+fmv2pgTFxNhpB7ouWRvwVXIMOFsY93g+/VCdAzw3U6D7BKBpWUNGRQ/0qFmvMh06/7O/EJvXNQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305407; c=relaxed/simple;
	bh=/YTjixIt9t4o38HhpGLOZMwTS7UUSR2LXVqyqfIlls8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YwX3RucGtyJokwgjLu/U3kBGPSMyVQRdZF2z7si8duMC6aazndjdN/S+YRLnWImk9Oyhpcirl52Mc6k8KNU4WcLU4MTyXL8qw/dkY/bIEcEAr25R5M5i0IRYTLeKhwLzduBRiKJfOJRmUcENPCSDssw2TBQnuxf3WQvwMJamlJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iF/8spBt; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b34a71d9208so1873862a12.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751305405; x=1751910205; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JrZdSwi0jqyB7dqvs+d885rzoxETI1TRuwzDVnyIFJM=;
        b=iF/8spBtz4Zo3P3e7XH8RSMlVT6mFyhmnncnbGPQIm+iuaDYP5qQeUkp9kGsCS7yGn
         R2YcyzIuK1HvH70g3wRO0iKHC6/B+FA4lV29KJRReyqm8lu131RmE07MP11ySNnUiAeG
         jIOwMMcOFl+ATxZgl8PvzhaTVGYmOv0hatqI6GV6FnLug97UeZ/07naM/B0o9XcBmSFq
         aPi0EFkHWBlkNzAh7AYTPrEQAQaVEeaOzZrEoMoggzlviEAy4BJ6anBE9gtk83B2qKuJ
         pmOXR+nKsRbI/qU54sqdCPmiTZ0wyJNy/S6QpTpJugY/Aa3fi380sxHlNCUYFOBNprg1
         yjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751305405; x=1751910205;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JrZdSwi0jqyB7dqvs+d885rzoxETI1TRuwzDVnyIFJM=;
        b=XWt8aiIbXn3UuTNxxOxVI4va9sBS0kNifvrT4kLBQzQ2/Dg5VwFbv2VNYBXpM9JiGH
         6y8Il0is2mJPFh1AsJOup8hoZ9rBFq85EePQcLeDgLjRznwZ+0OyaxCDZsiIa0w6IQ9o
         7T92xD+KgsEsGr9LksRE3Qg5Y9eNMVno8PB+kFxxstICD0PVlWWqPm7odAsEvEDjXttl
         g5nytONPbtMgc5MoaTfKV7kvDDJUUFpRU0jyPDaMiATWcbgVVHR0oW9f5H8DS54BYthg
         +wnRwN8fdHS5eFQUisunWYnDivpAVLs6Bajtxmjq7LVcc3/MXxXoFC3YE0MKc3yU6EFq
         xLnw==
X-Forwarded-Encrypted: i=1; AJvYcCVmuzn8W9RA436l+mP5ILIzI4RBixZO6Uw5URlT1ZMKtMjXhiMj98QPSVxufSm9E1fvS3y3FT9RkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfQTqp6aUReFSpUiTh3RdeLI7W5SPSxKVpoX90PKYjcnfKAziS
	kzwp6sqyQBgeGhlYu3CunKg7MNVTdYFDp1s2mB4OmsNKLFT9WiYFRD8mmk842Fg0
X-Gm-Gg: ASbGnctPUbQ6W+u1NbyeeDuf/m4nCSnuK8rwzOrDLIoagXwEihQXd/VXRj2q2IIhA9n
	/wkGsHo48bZsCJYBFCEtHA3WcKpYNFCJePl+S+Dr7RWX2wnRx/LMpYmkBOsk2vc9G43L1HkxYSz
	7zc+rlYwT6ABnxx8hJ6NKz7dWR+khDQdINsAqMj3IjkUc857JkvovudMoVDA5QcyKOyGcBVb8pF
	MKvBmIw29X6kTvSKKnLLLxyHhC36C+215h6nsO3Y83UrlSNPA4+MEtbLoUn52vgks0yJBfppu1E
	sgmODs9uto2sBYlBFm/dWAX8qhu7vkmAYc4u28dhH85GfFb5AI970KiwEZb7pYY9Zn+MNRkw4lQ
	=
X-Google-Smtp-Source: AGHT+IFDjhGTUEMeJ4+d3zGzuEKyOLms1pRm0SLzO5ob14DDRaLrJYXX+FnBthxqP6WWkXxptBvYxw==
X-Received: by 2002:a17:90b:2c85:b0:311:af8c:51cd with SMTP id 98e67ed59e1d1-318c92b78f1mr22601512a91.18.1751305405304;
        Mon, 30 Jun 2025 10:43:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:106::41a? ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c14fd27fsm9491820a91.37.2025.06.30.10.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 10:43:24 -0700 (PDT)
Message-ID: <3864fe41-25d1-45c0-81e6-877d06629524@gmail.com>
Date: Mon, 30 Jun 2025 18:44:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] zcrx huge pages support Vol 1
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>
References: <cover.1750171297.git.asml.silence@gmail.com>
 <34125872-bc2b-4b49-8331-d85587bfdb9c@gmail.com>
 <99fcc8c2-a721-406c-b420-decbd591d7ce@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <99fcc8c2-a721-406c-b420-decbd591d7ce@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 18:31, Jens Axboe wrote:
> On 6/30/25 11:12 AM, Pavel Begunkov wrote:
>> On 6/17/25 15:48, Pavel Begunkov wrote:
>>> Deduplicate some umem vs dmabuf code by creating sg_table for umem areas,
>>> and add huge page coalescing on top. It improves iommu mapping and
>>> compacts the page array, but leaves optimising the NIC page sizes to
>>> follow ups.
>>
>> Any comments?
> 
> I'll take a closer look tomorrow, it's on the backlog after being
> away for 10 days.

No worries

-- 
Pavel Begunkov


