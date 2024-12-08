Return-Path: <io-uring+bounces-5297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 794F89E8886
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 00:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23B4A163D65
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 23:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8211189BBF;
	Sun,  8 Dec 2024 23:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jz6PVCv4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102223E47B;
	Sun,  8 Dec 2024 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733698901; cv=none; b=n+3kn6HAc2Y1FhGjTLKg5IwLWdY6bISn0DLRUZjXouScJUh8+iXMrIphgn/e0FuY+5dUbHQZNsjzxZfUSnX0qcU4HPPmrraaLSEzv/ePH+GdsY2SuDoQyNArWXbtGBE90qbsXVlCvG09pgw1VHnbaGaYXy93VoKO8sLte68YA20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733698901; c=relaxed/simple;
	bh=pRSew8ldoZx/D99IdRzn1/vkfDdMrL1DzAZxkm/FVpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CenPd3cyOajUQIgNjvZS8qcWJzc9iXn4jISqwWgiTQX+mrBfCeIEUqFrd6MDVIuNGXfCkLw1djXwucGUJo+/BnG72mz9BOfOFrIgj65KnXMOBukhdjg648+0GFCUXQQn/lZoxYA5zpkthczkbp3GLdVx76uZ8pp++DdLtWQE+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jz6PVCv4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434a766b475so37030845e9.1;
        Sun, 08 Dec 2024 15:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733698898; x=1734303698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xh/bXe1Vc0rOdhZWhLPWkB8OfSUsx5Drgeinzv4BMNI=;
        b=jz6PVCv4rdquWd8ydQWOhxzzdSRuRrPDPRCnP63MbWDN1hqYDtx+ItqB3cxAUZZEUX
         R8e/mtLb9MVMKbplyhiOo9MtKDEGZxT662l2GJGNKLOg+q7cF+Mup4f+Y5b/a4gH04Wc
         OYgUpWMMUoAXE9mbpg91/AIUd2r3zi+cwf+RmViZcuSD/zpO1Gc7HCwzwqE3llVPqNhm
         CPJHUmwJ+Cfo/1lwnxGmw92iBCPKGx3dDuQWUEY2kPoMSZih+HWEhlWat9Jsl92KoKmF
         nCCFDUpaniiXHtH+44jn57+2XecNwgcXNlHUHnqj3AIyV6gQ39KEzsH/8XjuYtLdIdyK
         msVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733698898; x=1734303698;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xh/bXe1Vc0rOdhZWhLPWkB8OfSUsx5Drgeinzv4BMNI=;
        b=mQsHdD1cgpcEcGV6pAETs4kEbWu176PIhnNj2OWcRppRC4++wiG0C0Nwc8dOzG7Sao
         B3XfhJpLc6cc8XcHBuwVjrEBW6b9QH+mgSl+WScJrfaUURN4NDmNCDaKuap7UQyxF7QP
         f+yjdAtr3xT7ObZ/D5uvua9LUpYFo/3fg6NX9+1thrbqmaKFIIlfTdjvXPmdZ7vZ89t4
         mOxXXS2k9SZ/LI9CDrGOAvkR0k1JgiJwDo0GeilEHJdouzueroLLSbvh5+BwLJJ9P344
         6F003AQmsS1wVOsNXXoGpoCixSEZJAf3ETKVDF9zLm4RugmaJ/k2APA9GPPKgG4744y9
         PfQA==
X-Forwarded-Encrypted: i=1; AJvYcCWRfASe+0UKhYQmAnNZk4cFegxaxbI7Rs/SZSt+PcDPZCR6k9ctDeIAQJf8A89560+2ILR7J+kRod4TXBZ0nw==@vger.kernel.org, AJvYcCXYdmQLcf59vXAY4Q0ZA0lCNOVNSv9FLjo/DzRKWN29Eu0HLiDZcu6AXaLpWNRGkXB3vbprtZwagw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVrzgaWwz67D6rXwh9xolHtAFqZ3thJKyMEDk9OYJScvXrSSJq
	9/444PA4s/376KKqlU/sHJ03VNPvWnnUwzvuCCz2/LsTxr7H9i86
X-Gm-Gg: ASbGncs1mYlkIADPKYd0qvrOlF0lbS4tk2IJDvo5Farnqn88MAjgNtATLEhh4iPj3qY
	SjnYYnqNE3arv2OI9K8ZLasASbrhJIQ5+fU3LEToqQzvlfDPWnOTyP+s4gXX+/7AjI+s3JeHuSW
	liUD0B+0DFmqPZSuLNnDglc4Qf5DsmDJkRAZOzjsCLMKFh+Sb+Pc3xp/XLYil7d4OnI16wUW8fO
	cQw871Zm1MKfr8XAStfV2LuvCOAw7pjCPqoMZz/g83HKaIny7xtW61ovPRB
X-Google-Smtp-Source: AGHT+IFAyt0wmMH4s9Gbe/djteRJfvFEoO1Dao/RIidu7UAW58FhR5lvZj/wh95zw7kEOVQizxTA7Q==
X-Received: by 2002:a05:600c:4f02:b0:431:5f1c:8359 with SMTP id 5b1f17b1804b1-434ddeb7f8emr92333635e9.15.1733698898075;
        Sun, 08 Dec 2024 15:01:38 -0800 (PST)
Received: from [192.168.42.233] ([85.255.235.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52cbd42sm170454285e9.38.2024.12.08.15.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2024 15:01:37 -0800 (PST)
Message-ID: <e19b9e3b-5723-41fd-ac4d-26247369ec13@gmail.com>
Date: Sun, 8 Dec 2024 23:02:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 11/16] fuse: {uring} Allow to queue fg requests
 through io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> This prepares queueing and sending foreground requests through
> io-uring.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
...
> @@ -945,3 +988,119 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>   
>   	return -EIOCBQUEUED;
>   }
> +
> +/*
> + * This prepares and sends the ring request in fuse-uring task context.
> + * User buffers are not mapped yet - the application does not have permission
> + * to write to it - this has to be executed in ring task context.
> + */
> +static void
> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
> +			    unsigned int issue_flags)
> +{
> +	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;

Please use io_uring_cmd_to_pdu()

-- 
Pavel Begunkov


