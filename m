Return-Path: <io-uring+bounces-3610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB87499AE21
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 23:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CF24285486
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 21:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A721D0E11;
	Fri, 11 Oct 2024 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dg3GKUYP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245221CF7BC
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 21:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728682709; cv=none; b=ttXxYnFDqWuTpCYp+ltuPXo7IdyC2B607tC9/EQQF1tqGtdv/dUNRkRDJZ/FNzlYgXfqsLl0W5EsFDQk95JN3rbxWHcMcjFvzDTsRCJXbJ6B402Z4xMrSpJo5rGVhsDpIwgztrIpsnnPQRhg6nkdtSyhO21Gh01QhGgHlUdH2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728682709; c=relaxed/simple;
	bh=yq+iA7obx5qu+EWHRyDrGUnwTQyEjaYDg5Td5yaL7B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNPcCdq5a4NdmjsTPdsKAuxydU5VvAG/vtpYeMfrXGb67CAmw0Csz03dIIT78KT4MX4hOUnxNHBleNWaKWiqmWgLxnzOmmyRtkSf3A1kaXvpYztcntRDbvFqor3vkduy/Y5/kkzLPZDKcTJkvY1We72bXujWr0kDcNG2Z4bFIRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dg3GKUYP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c721803a89so3358562a12.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 14:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728682705; x=1729287505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ezX1BK8VWUms9bu7sFqQ55U0b5j0mewquCGqW0+IeE=;
        b=Dg3GKUYP2WOfoq/tSvSDYqikOZFqlTrVSXGHbjnk26ZKKrLI1J4mdoL/56o0L9hW1y
         xz0991oAYbuZixD15z38Yfh/irICCS46jmWH62g1bvegeFnunWHJPK/XdAVzh8niPV/q
         5JEOrvPaiW5FX7999437D7QLWmtJk9W+unqwmjJpynsOzIwjviG/riZRk5fc5u2xiUnd
         MmxSwiS2fPEZRUaJBmx3bn8DVK1wjhK5ESVPehAFENLz/PdLxk3LCYBF8jGmZ11TQJZf
         H18qCGXMck1zxTybMEuyRUtiL25AUOGT8zFx2sObm/gKmyUM+F0sk3v+9ucUR39ELZR/
         I6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728682705; x=1729287505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ezX1BK8VWUms9bu7sFqQ55U0b5j0mewquCGqW0+IeE=;
        b=BTDaue7Vithw2cwfFo+/WYXhv8Fz+R2iX/NtLQAn2zC/CYt+ZtLcY9LTO4//8ofj8I
         +ILjoZSzQp2983iqXu4WjQ+PFp4HIqD9hUhwI0gniOdavSopADOvaGlAhZwv7L+0I8QE
         XFpSjnlPVTJqpu6Gx2/HbytmC7cHms5vBNTEgzhhz0RAaFpksXTd/ghCJaNHB7AmcnJN
         YwtF551XF1bXrnfVnyPYPNEh9KMX1XU15DlJEcinwT2K/V2GtwF4xI3BBh/gzNAwtMxM
         1PwA6t1HEpLwjgFuIk1SUgXqzlssway6KaBTuAgNJW0+k6tQwZFn7Kk2/stEj2z4aqht
         8Kmw==
X-Forwarded-Encrypted: i=1; AJvYcCXIy8PChDLzN6I3pBe26zSuKWxAEA6vn5X2uYJv/Lj7l8rFshlJnxWhQHGFqSiILrjE/59ZM308bA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLc7GP9VEbOHaWw+flXsV5KsA54lduDs1NQ9jat689hNDHXdSN
	6j4jApbXhYbyen2Mf0OMGnJXfXubUGtIonlm8wNAXAAyaYKj100SmhxQgg==
X-Google-Smtp-Source: AGHT+IG0U6PEKyEpVHTkLs4wG10hBkCd5O39efW0YlT24T5Z9kpLMvJxrbZ78Qeze8VN9atpQzrgmg==
X-Received: by 2002:a17:907:3da3:b0:a99:5ad9:b672 with SMTP id a640c23a62f3a-a99e3b20bfcmr89845266b.10.1728682705136;
        Fri, 11 Oct 2024 14:38:25 -0700 (PDT)
Received: from [192.168.42.194] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a7edea69sm252891866b.7.2024.10.11.14.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 14:38:24 -0700 (PDT)
Message-ID: <98b1e1b1-ec11-490e-b1e7-46b75d6584ee@gmail.com>
Date: Fri, 11 Oct 2024 22:38:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 21:56, Bernd Schubert wrote:
> Hello,
> 
> as discussed during LPC, we would like to have large CQE sizes, at least
> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
> 
> Pavel said that this should be ok, but it would be better to have the CQE
> size as function argument.
> Could you give me some hints how this should look like and especially how

I remembered it as SQEs, which would've been much easier. In the current
io_uring infra, usually to post a cqe an opcode specific path stashed the
result value in the request structure and then the core io_uring code will
post it for you. We won't find space for 256B, however, and it'd need to
happen right from the cmd path and follow the rules when / from what
context it can be posted.

I'll take a stub to see how it can look like.

> we are going to communicate the CQE size to the kernel? I guess just adding
> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.

3-4 special cases is already odd as an API, we should rather just
pass the desired CQE size.

> I'm basically through with other changes Miklos had been asking for and
> moving fuse headers into the CQE is next.

-- 
Pavel Begunkov

