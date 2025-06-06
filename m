Return-Path: <io-uring+bounces-8274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C0AAD09F1
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 00:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D86033AFA4E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 22:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A4B1DC98B;
	Fri,  6 Jun 2025 22:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fkYvc9fd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920C1A9B3D
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247736; cv=none; b=vEBID0tvLit7Ls3vp+OqVRfWSC0YqA79MaWNc4YI1DSdFy3+Kncu9+ZBKaAOtKphx6Hy8R3spJ+aG1TBSDclcCooTzqRo82jpVEZWZf10a6A7gTVM9d9k1Gl00mfCFdqf8ji3Mrryf2J47+rEqTqBajJZH0AQjE0+9PVi1SfZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247736; c=relaxed/simple;
	bh=utwIOl7d/gVYF7Na+FLO3u7pA7OFpbxXOc1eZbuELlQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ib7iWUt+uPRVfaYhsVBg8YZ7tYk3NT1gM8fjDT7A0voa150/iJrxFW2x8GnCuZf36tff8PGHcpcw5l7/IzelaTUVhEHhhj+H4Wr4CNZ3LcgLwe1IKso4uylyCkOQrdKZ6FYoCU2oAfyL4Kj0WDqex1B3Y5dW8cE5HGsp+zTW3OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fkYvc9fd; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-86d02c3aab0so71561139f.2
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749247731; x=1749852531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gOYeSGL+ChdCs0lRClk/E7f0w1DvoM//sd/DPK5iNEc=;
        b=fkYvc9fdZs0pesYziLVz4KkMjs0+EZhqMipwUgVxjVIJDNyHRpSU7vtHZAnSPS2dCF
         Pfx2NXaHIHAUQnypUWVC88Rvr1NpGAA02RuXOvppL9oBAoMFvCarI9uOzQAl8pO65fOv
         Z20DhJbvqF52t/nelluE+6Eftg6qZeWt2kUTcP/5KWRoRem6ynNrkHtgA3kyNNtgYDUy
         RWHUKifr6gqgdmY4xWv0gWyd+oPm3zvXe1ngpTJrzI/qVNp0rkor3Xe7Q/rlQ89MHRh2
         YXEo7hSLETVRDifaQue6YxvSOh6GIFenuBKMY6s/Zvg1gDPA+IWDQfRWp0gvnKdmSG/B
         GVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749247731; x=1749852531;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOYeSGL+ChdCs0lRClk/E7f0w1DvoM//sd/DPK5iNEc=;
        b=iGANmXVKsYIm8wwFbqTnPI5ERkaze05o9PmDThcAkP7aWF9Ny0bdZ+H2HqFBewZSLQ
         zYJHPM8DNmJl+4mJZ3VSEk/hWNTpDUEs7i9o5MBuO8G3m/p3v1rcndIvsImi61Cm/FVp
         HG7ldQn5+1TZODVSaBZAxPGMYXTattugbN6ThaKWz57vN1VrKPtS3bgmXegUTxkuQdWL
         odELZzyH1sjbFy4KqCwLn2Cq+Vo4o4ySIRNRD/E63tU7PZC4Lw76NBA0zTLCOVva1d+x
         u40PJ4PM/hpkK4Y8/xIZ4DFBAEOORm6TqTpgjnOYyn7JK5BQjNCiNFAMpjc+FIQE5FCs
         +Vpw==
X-Gm-Message-State: AOJu0YwzcLofVkHs6tN5bwJJZ6rYbRyqNfiNZp+d6+0nt9G4LZf73dvf
	f7uhTvQAj7cb3+v4VA/60nGx1qiErfm98r/AeQqTQD18OWHgwl34O619Q8MY4/pn0QgipDR0Y5X
	mebsS
X-Gm-Gg: ASbGncs2g2CuQZIj+1mrf4mSWWBsAmkUypQ5TLlwzkVNa92JF9EntoIyuFJ9ThwSShl
	fCILoJvmWuYB1lJH1qOlSmA7OVMsl06oUWgN5c+lVvXd0Jnui/URYq2+dLnQnroq4G3GjrnGQV/
	BoC+NfaVdtGsNrP95F5xrTiNPu0y2QSLT15QQPnNnncSr0B5JfN2QCISJKY/x3WBInaP2+6CHwF
	NWXfB6lJQzIOUPtpvloHqqWaWtdAddWZK1QsX+dXQRSWH6P6NLdOJf21QrLKPcWKtRNHxg+L+1t
	77FglR8oau80uN6DZ49cNHZgzlgW5vrVqXKry5FqahI/I3H9qcrh8vkQ15k=
X-Google-Smtp-Source: AGHT+IGzMdzNkCZJcTPyDE6xYkPtFZ9Mt/d6pgZzmfL7IjgDB2Ar+Ife0LU5OSPZWSFKM7mZJmduPw==
X-Received: by 2002:a05:6e02:148e:b0:3dc:7f3b:aca9 with SMTP id e9e14a558f8ab-3ddce44fb85mr53068645ab.14.1749247730910;
        Fri, 06 Jun 2025 15:08:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500f2500fdesm81705173.97.2025.06.06.15.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 15:08:50 -0700 (PDT)
Message-ID: <16075197-2561-4eef-bf4a-c50734021267@kernel.dk>
Date: Fri, 6 Jun 2025 16:08:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-5-axboe@kernel.dk>
 <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
 <98a6907f-b9e7-4331-83cc-855a64bb1eaf@kernel.dk>
Content-Language: en-US
In-Reply-To: <98a6907f-b9e7-4331-83cc-855a64bb1eaf@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 3:05 PM, Jens Axboe wrote:
>> Is it necessary to pass the sqe? Wouldn't it always be ioucmd->sqe?
>> Presumably any other opcode that implements ->sqe_copy() would also
>> have the sqe pointer stashed somewhere. Seems like it would simplify
>> the core io_uring code a bit not to have to thread the sqe through
>> several function calls.
> 
> It's not necessary, but I would rather get rid of needing to store an
> SQE since that is a bit iffy than get rid of passing the SQE. When it
> comes from the core, you _know_ it's going to be valid. I feel like you
> need a fairly intimate understanding of io_uring issue flow to make any
> judgement on this, if you were adding an opcode and defining this type
> of handler.

Actually did go that route anyway, because we still need to stash it.
And if we do go that route, then we can keep all the checking in the
core and leave the handler just a basic copy with a void return. Which
is pretty nice.

Anyway, checkout v3 and see what you thing.

-- 
Jens Axboe

