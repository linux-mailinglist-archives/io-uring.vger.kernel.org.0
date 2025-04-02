Return-Path: <io-uring+bounces-7363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C23EA78DA2
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 13:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A080C188685C
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 11:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801D9238143;
	Wed,  2 Apr 2025 11:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wEXxbYAB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1338D23771C
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 11:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743595170; cv=none; b=r1GjlEiuFU7U8SNObuCqfoS658K3vzRb9ChR99Q5hANv0rPlWKUBSDeLOWyilGD0Bl6GrWaGgqqe+03diNiRIC0oc0VjAVzFMi7plFXxlkL2/4MEQV1tTxaSLOVHilRByG6Q1901t/L6pU+1+Tkzhj3JdeyaPJyEMgBAjZ+5P88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743595170; c=relaxed/simple;
	bh=Xk3cjv3oTeKPfz9Y/a0Cos8E/vkDvqH/5KYuc4gy/ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KOgnVoO0r5bTJBDTIYV4jlfxvkdIs+oN5urta30bbbvDJVlyxLxP0FFsGxAHVFhq1Q9kbsTQ0VLDPbsa5BvtSfrHGFD2Zj21jaDCfjVZbs3jzxdRIjfa4kQm258W+mZrjBVAKyIaLC7wKbEeTPnAqM5QCin9iPqF3kO3GbCH0qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wEXxbYAB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d6d162e516so9284575ab.1
        for <io-uring@vger.kernel.org>; Wed, 02 Apr 2025 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743595165; x=1744199965; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R7CgYEaCMI6oMSjmp9/STYVMMNXW2Hgery+aAaHuHIo=;
        b=wEXxbYABvXMF4oVTCi64G0i/NFalGtY78od9S/EqW+2YB8GwjvTb1i62/CeAra3ISU
         Zxovt/n1Lq75ClKtrpfKlGcmmtWWsZjtGqGFpa/ALf+UMk1bQmCVCvhG7k/F0AUFDhlN
         KkEsaSFxCgdFu+Apoin59yxl0vDReTuSw9R7HoFSD5svSafv/0HQd2tZxzjtsVXUQF3J
         V5amY/ITE7rj9ukPkIQhrNSZOzVAyYasx07tq01hlFxJUvr3fVVPPcvbEIjosRKxh1Gj
         0/uUb9ts4SyKq1aoKfaPsyla8B65lNyQf9WmXK5T0cnhcdbb66KDy7BFNoCrrONm91rR
         Bhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743595165; x=1744199965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R7CgYEaCMI6oMSjmp9/STYVMMNXW2Hgery+aAaHuHIo=;
        b=VVGwhgftiNMqBx5qF7yfibU2sNfasAIA5dYeBiq5IU/hEXJC1kvRmVdkWMOHPrmk5W
         4kB1VKolU6aUdw+XVGs9t/zHMd8NaOxy3yEou7NubC/xgqthp1MbgBeLg9hos6umBfG8
         O+74TNkxKgV2FNmOxojavNcufDX/SiXVGoceQyJhiXr0sBmVwYQAeLH90Md39MtwV6T+
         Dzced470s9jSU66WGisgVTTC358QF1PDQi2Zt6Io2LmJ9BY5k48xWE3VzhxMqxJXXr60
         KWfYl8P4Jr5Aiv6iIk24RdDWFCAcTLXRL2hz5smkqQ5GlFFo4hQMCX7CiV89yTEYFBA2
         Co+A==
X-Forwarded-Encrypted: i=1; AJvYcCUpxMLV6HjCnZ6S1NYEgfu0RltgH9ZUIhYrVzY4RwRRCxHqERbB2HhsuUzzO/XjdC8zlVThCbnVVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtxS4BdCAhzM4z+7duT0VR7fmfNFriMHOmYEquKbw3RyZaqyDZ
	B5McU92VyKUqIAnpchswqrCr21PzhIwAMQmKqLqhC40/lruKSigwhFlwQI2DD1+5O6AUpVaJAwb
	b
X-Gm-Gg: ASbGncscWUqk60IS2DiY8koq6bu0QUgVcUtcBbpetTH6aHA1pemrnMPJ9kz6QBmRINP
	VMhJuEx44wP0zTItCaCAAJxk0HgI/cYO5ofm+avxWNfA2B6jSHZPCVbo3B/bLnlZbQ5KtfSqx82
	+QealpQgK2NITsxNEabYWguBuZlmnU3jcQ0O1UVe+OHHWnzu/XxQ1Xacw+/1crbvP3W06rzhMMK
	4qpnJJ/l7vdY5oJYIRsW98tmPC+bypKRiUTAzR7VaoTN69Y1U3Wt914xv4ZpSC6v4AJ9/1V71sM
	fgEz2tH5tq3kwt5GMLHyZLtu9pUJs158qAedrbDq5g==
X-Google-Smtp-Source: AGHT+IGjjD+gpgwdUpGmR7IXAB4CEz6i9JZVB2iOmPZ/aTSlgJKkyfoHSo/tH+SjPOUEJ+1g2llQ+Q==
X-Received: by 2002:a05:6e02:1a48:b0:3d5:d71f:75b3 with SMTP id e9e14a558f8ab-3d6d55438f0mr20557455ab.15.1743595164892;
        Wed, 02 Apr 2025 04:59:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4648715d1sm2939316173.95.2025.04.02.04.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 04:59:24 -0700 (PDT)
Message-ID: <c252ec4e-aa97-4831-8062-43fcd1065324@kernel.dk>
Date: Wed, 2 Apr 2025 05:59:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
 <Z-zt3YraxRSHVIWv@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z-zt3YraxRSHVIWv@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/25 1:57 AM, Ming Lei wrote:
> On Tue, Mar 25, 2025 at 09:51:49PM +0800, Ming Lei wrote:
>> Hello Jens,
>>
>> This patchset supports vectored fixed buffer for kernel bvec buffer,
>> and use it on for ublk/stripe.
>>
>> Please review.
>>
>> Thanks,
>> Ming
>>
>>
>> Ming Lei (4):
>>   io_uring: add validate_fixed_range() for validate fixed buffer
>>   block: add for_each_mp_bvec()
>>   io_uring: support vectored kernel fixed buffer
>>   selftests: ublk: enable zero copy for stripe target
> 
> Hello,
> 
> Ping...

Looks fine to me and pretty straight forward, but it was in the merge
window. Anything that makes this important for 6.15? We can still
include it if so. If not, let's take a look for 6.16 when the merge
window closes.

-- 
Jens Axboe

