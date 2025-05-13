Return-Path: <io-uring+bounces-7970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C3BAB5E23
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 22:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B57EC3B3EB0
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 20:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5051120127F;
	Tue, 13 May 2025 20:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hMn80fDe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3312C085F
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747169244; cv=none; b=pEd6ryBBY6Ptmt5f0qjuQFpJPPuCfxtn7siCZblv39tHA3zo1F7ewtKo/f7j/t2liF83uKFBKnDAgUJswgzDX8XZESpwsxeOWAHtSzuHOYhMKo39xc10y/k6ljUjrb6WiEz/MfvHBdBUrAr1D3TqPVdQMSzuL7kEmZzwTyAym9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747169244; c=relaxed/simple;
	bh=7Lcx6sCiUIa58Jw0X4B2KNufTO4yVkETeGwQAWUGNGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Jrw6dRb2EWH0jmTedD9zAdDEd/S3F5SAGUhOLxV7pKPT0DqgicRbRN1UxGQiHR6Ik+Lia+QosUPORjD3NlrRap/mVNztCHal7y3Ivyg81Ztdo+X4F1SM+0t1gufNc0G6fko05B0uDDzk2DCngH+gIcHODRIkomLGIKfNFTZPIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hMn80fDe; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3da73e9cf17so57072875ab.2
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 13:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747169238; x=1747774038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EGVVtZmbJExuZHlTmIw6cQSDPfennwhpoDEhj2L/jGw=;
        b=hMn80fDeKWdlHlhs2sEHsP+DJIEUtATuhCwVAMVnXkP6czGDaEL9INKn99+DydiJlu
         vUGuRUmg8FYWynFeSH4mKaFAjGIgwlYDoSxp/r8AM0+CLkwzL7K36TeEXWcSQ+NcT9w/
         6hCbZCb+7ZVi/8KEF7JX35m0CLT5mio7/PxWFWi9ngmj5Gqitrx4PaAa6wJaQpbkwKeQ
         talBqPgD0xbJwOauzpYu4CXqp7I++72QsFAKSie8UqElcqEpWBKugSo3egh3X5VpMBgQ
         d94DW8C7/TCxucS2msoeefqiRFpnkfNe3Wt7xsgj0GOxJvEhUyvSsOlEvfN5pD5Uq/7+
         E2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747169238; x=1747774038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EGVVtZmbJExuZHlTmIw6cQSDPfennwhpoDEhj2L/jGw=;
        b=CvSahY7AB1FokCjcf0JnLPz0/450ua+DPT2ix/mk7bJ1GPLx74UKX0BcICuGJwPq6M
         jDoi60Tep7JtAwGKXp4sSy6fDRfi2fE5pT7kNWpRhGN1N4SX9hZSWe/cVY/lde1ODsi5
         JMQLsxs4hneuJ4zW1QOFD0rHC42w/NkZz3PzL3ncnmyW/47crafvbEnMb6/w07M5w9FQ
         Aa4rITN7Rsa2Omr+bQlObHKPqYjDSgov8AezCxWuPdaVJ3yiNxUHgl5Plf+Tp9wg2JpX
         pR3o8tVJ5rpINa2Ik+dUuxIkW94oLiIxnJJ++voFRxLgsby1Dlr7KycdgXd/1YRuqIEV
         AMuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrbO2A+XcuhE5VOiB74BtQ64aDcV/PerwE1/CFjTYDNWUHzvjuQYn7O0MCgcJYEFe3OmTPAIlhMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv+iBfxQTPrQwOnCLogX+t3zHVKj5xYrSNzFo4J6W+o/ndqGhM
	VfTLDp7RhelIsYRoUuT15z/r58w9iI8QWdOFgh7NMDEicXmhgR/1JtOWmyqXhE7nSA6LoQ9i0EM
	V
X-Gm-Gg: ASbGnctkQSm5KBO0lD9oGNvyr0xryH0fVfTbHGJNicoWh9zq+7aZBV7xzfChmb9Y4s8
	8ai8GX2dfmcLqp32TfmWd4CkMnsGmU4pM6HJrqdpLITx1wvufKh0DN9C/RIHGddrK2fgPBNdfLA
	Rh8r9Yk7+XU0sMAzfjVMWdo453anelE46feEAShsGqh9G7VznkXHHzw9ddzZ9tZ4INvtLRYsyMN
	dedqcPo5sy48GrPAUCLVYnx6neqKEdwrRFvPPTzaNqV3/07UAl0LeFQyIM4Kb5Z1cuVYY2xG2Y/
	b6lEYmVRIOWwhbWI5zDy7szDrB3aDuQPPC7TzLWUiMTB17/WmWFbZll7oA==
X-Google-Smtp-Source: AGHT+IH8LBsf1MkPCz//Bcd32LUq/g2Lh27dOZ36r6iL3p5P3n+4nvEnhXp7PkRl2x1CM6sDqLRrzw==
X-Received: by 2002:a05:6e02:1945:b0:3d3:d823:5402 with SMTP id e9e14a558f8ab-3db6f7a4c63mr13862245ab.7.1747169237785;
        Tue, 13 May 2025 13:47:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e102ffbsm30888365ab.22.2025.05.13.13.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 13:47:17 -0700 (PDT)
Message-ID: <098af252-bb43-4777-bdb3-a8b753eca4d9@kernel.dk>
Date: Tue, 13 May 2025 14:47:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring/kbuf: account ring io_buffer_list memory
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1747150490.git.asml.silence@gmail.com>
 <3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/25 11:26 AM, Pavel Begunkov wrote:
> Follow the non-ringed pbuf struct io_buffer_list allocations and account
> it against the memcg. There is low chance of that being an actual
> problem as ring provided buffer should either ping user memory or

*pin

Outside of that, nothing to complain about in this series. I fixed
it up.

-- 
Jens Axboe


