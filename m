Return-Path: <io-uring+bounces-8564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E49DAF0C1D
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 09:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76E774E0386
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 07:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5A8137923;
	Wed,  2 Jul 2025 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnDpyaZa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CEC8BEC;
	Wed,  2 Jul 2025 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751439625; cv=none; b=I/xjxRQQRUqLPh/km2Tbr1InRxkxx09XB8N3vYWmW8OsnMX76I6p/Hmcy1YfNl+0UVU9XJLmcfsMmvUpBR45mUEfNlM68ByDkuYBQ+pSRj/k8ynvgLtGO1r7MK979wfdGxGvC/lL3UxGIzxe/HRXId0N7qd/MCX+QIWUYHB8RRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751439625; c=relaxed/simple;
	bh=2tZo2cCjA0Y2GCvOVo50+39/Qu2y80q7jpcHyKlVS+U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZM1Lv2gDANoQZwHxO1aUWcL1+4KTwCvnw6xkhNqZYtfoLxuikVNQ9deZNblZG0OqUH0GfIkwrJNiKcL01fpsdPTLOHOAEiy6ZCgLr0UIBrNRsMjrm2XTiYBKPH/pHbUIwmv/gopI71Wh1gfZYdwrctIL/eSA4F7v63M16SlIoag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnDpyaZa; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2352400344aso61202815ad.2;
        Wed, 02 Jul 2025 00:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751439623; x=1752044423; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuJaex6WWCvWthSyFQwlZmsNHe6Z60g/4P8w8lI7ZPQ=;
        b=EnDpyaZaNJ7vAtqD4lZEW524XZwvImU7IEEmvl4lDfeh6ZeKvl/9ZiexO+Vuhv27+V
         u9SofFRqh79kPMvFDHbRbfg135DyHVGdoRKloJUnz9zPbVM8WHW7oeB/1yg9Yv09T1Ja
         FpLUAghZKKrojsoMmlnV2kghZTh3O1LLC2EriVg5iRGLqkxLm0zz0hW/nsF6cNN64i+T
         h79+zjVbRefrDQ7b+5R7ocCMMDpIaCOjedh7JiLphzJBfumm5JF7FtUSl2eY/YQVil6I
         A4Dlv0ysrrtLJyw6tLl2fEwjIOtNwmPrZiL61JGacINgtZxNFl8Pq6vbu4UHsidRp75V
         sGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751439623; x=1752044423;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HuJaex6WWCvWthSyFQwlZmsNHe6Z60g/4P8w8lI7ZPQ=;
        b=n0LM39WnjqL9yanr8C92R/1M7P9+XR/VgWA5wO1pQQv8OFo3In4bdUwsm9XRT1dH3x
         YFop4eNoVdtvWMGbAHHg4U7MrZQBvLlbym3U5e1YB5g83iaXJGAFdBVYpLmh6RWLbkyO
         SU5G1BDxJ9f+WVpCCNfSb5yPE12Amb2IoMMJeiiYCJP4E8buTET+hPoD9tBPJuVOopDa
         dJAgEteGwxsJ6OUq26wNltK+vuhuUfraLT6BSqtW5EySuqJVOEveZ/xybPuTWVVr3JcL
         CTcdGvCIMKdDgljKRPd2GNjAj+8+aLGPk1mFzVmPfo6KwKcHBfXnDiBva57tcWT9OwDt
         cKhw==
X-Forwarded-Encrypted: i=1; AJvYcCUXVa1mbA4v/YsDRJXFy1aHGACaX9p4Mkg+77QP2UQgjQhOjn5PaiMrD6ruOi68GUMV40ayTLwQqeMF2iY=@vger.kernel.org, AJvYcCV3b/GzWjuT2uzhyPwc23ORp9gZ9wxGpVMLcrj2+C0EoupRr7fcP0CsmNhcJ71fRvS/3pjtcE6tUA==@vger.kernel.org, AJvYcCVNz/7y6HGiTE7t02+daNhvQKXTgcGf99f45aXCAvInDi0AMav3cB3wslswEfSJ7y076y+M919HRy1tNhjQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzmCtSA5C7AJbARRRgAI0eOdToWs/YCCODvQwWZJf62Jv0q+0Zn
	3MTtuxT3y4pxeAbQpER7AvPawG9drUPFZpTwTn+W9OLLyWrHeYHSeich
X-Gm-Gg: ASbGncuf5mC/OxgxiJQeTz1gsPTI+GG8TVVnIT5TZD0Jxufp9SgzvZaDKpIfDE7LdzU
	RcFKVXFEmyWExzy3B3IPGZAbIOIRsJZShKYBMEgGbk0h6EXio0BWJzqY4pUub8AVDeQ72ADvpoJ
	JZaEbghY7omAIrrSfVp/vasX6Hxfp44VtPu1GLtzdjm8KDh4SJ27mMWZVpJSnc/XjODuwjytwFn
	Z8k3YUIVK0JnJVJuqB1hjniPpZ9wSG4RdSrKDHEa2b8wdr1NqrCix6y3PFMwFsO/PzEsP6ppppO
	FDGkBQLOnRaTGeOXlmZ+dCHezSsh/8hmmUU+Cf9yKZxf2Q==
X-Google-Smtp-Source: AGHT+IFOdpABx4MlRPwIZhUJXprp9yFf7WggnL876/MWdg4L4MqT/Gj2sYyf+A7M2qEqkz2SU6wlVQ==
X-Received: by 2002:a17:902:d2c6:b0:234:8ef1:aa7b with SMTP id d9443c01a7336-23c6e48f8admr21749835ad.20.1751439623346;
        Wed, 02 Jul 2025 00:00:23 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3ad188sm121967755ad.147.2025.07.02.00.00.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jul 2025 00:00:22 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <33d93770-886f-4337-a922-579e102c0067@gnuweeb.org>
Date: Wed, 2 Jul 2025 15:00:07 +0800
Cc: Daniel Vacek <neelx@suse.com>,
 Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>,
 Mark Harmstone <maharmstone@fb.com>,
 Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <07162148-1F57-4198-BC82-08501232C2A9@gmail.com>
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-3-csander@purestorage.com>
 <76d3c110-821a-471a-ae95-3a4ab1bf3324@kernel.dk>
 <CAPjX3FfzsHWK=tRwDr4ZSOONq=RftF8THh5SWdT80N6EwesBVA@mail.gmail.com>
 <33d93770-886f-4337-a922-579e102c0067@gnuweeb.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jul 2, 2025, at 14:44, Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
> 
> On 7/2/25 1:27 PM, Daniel Vacek wrote:
>> On Tue, 1 Jul 2025 at 21:04, Jens Axboe <axboe@kernel.dk> wrote:
>>> Probably fold that under the next statement?
>>> 
>>>         if (ret == -EAGAIN || ret == -EIOCBQUEUED) {
>>>                 if (ret == -EAGAIN) {
>>>                         ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>>                 return ret;
>>>         }
>>> 
>>> ?
>> I'd argue the original looks simpler, cleaner.
> 
> I propose doing it this way:
> 
> if (ret == -EAGAIN) {
> ioucmd->flags |= IORING_URING_CMD_REISSUE;
> return ret;
> }
> 
> if (ret == -EIOCBQUEUED)
> return ret;
> 
> It's simpler because the -EAGAIN is only checked once :)


Agreed


> 
> -- 
> Ammar Faizi
> 


