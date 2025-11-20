Return-Path: <io-uring+bounces-10696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1F4C74A59
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 15:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 9908A2ACD0
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 14:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA99A29BDB4;
	Thu, 20 Nov 2025 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FYynZRC3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFCD2989BC
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763650142; cv=none; b=S5P2CADPJ9hLSzOAX9IpOPChApvrJKrdQTvq8GtQAcPayl0Kffggyp1xIveqBINFckAUyL+r0smGa00jofQJjpb4ej6/YlFXiy/vzOyIEbjRbDpHZ9bfMi3dTsjPkjToKCWUQH7/U4YHtXI8ocoq2WYdJWndSuAE0RxpqpRXJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763650142; c=relaxed/simple;
	bh=KWsRWeLMm+PpkVB9K+oAnltoFBUD3/MHwGoxJBpQTOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VZSn3qJqA51rCyBoWK2DshdXuPJcUJjDyicsT1BILVWRDeHArNOkG5r5fPtOqTL15Jovgq9gE2JDJwRHktcbM81kdvSUMnwEslxAU2URCIO33oVDsXFGbvVgyp5PdKM1R39KRzpNS85rXHDCTFU01NDw2cXNJ+cGCZusFOBhltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FYynZRC3; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-4336f8e97c3so4601715ab.3
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 06:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763650139; x=1764254939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rfbv2NtpIQppLBY5/BQ8tB9GqtYpuR7Mn6LVQ5lIa2M=;
        b=FYynZRC30xtHX8v4yzDq/ThOV66Ryd81E31M2dnwDTbI+xHDPF76AgirjUkedvp2Gz
         5owQPqF6qWBAIr8CusmpM3LHoROJ9y7oDu/YOclPtuHO/gEuRN3AGASCZ0fizQQliTDh
         n2iIVX/BGBicD8fe4flbDaC4D2c8G77GuARmrliY16kSsXHXR8eQj3l2on0QpZl5r4eB
         QBMcchEO6qQxvbjucOXYK00g46gXqaGbkqGWOxhmOCrHMflgoHfyKN+4uqG3f1n5QkUl
         kxAIz7n3O+NiBmDvnB3+4lb47h2x0qB6OEKns6PQK7dbUQk50ZmfiViu35CnPHczw842
         3+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650139; x=1764254939;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfbv2NtpIQppLBY5/BQ8tB9GqtYpuR7Mn6LVQ5lIa2M=;
        b=fKh+K0zQcsKCWIQ90pOKkKwBu8EYgUQxp4d1GLRoegBjH//D5fR7yuUqU/eLYU1TIK
         Foom/lPQWqoJAYyiChdgngR9x2g9wwdyEbs9E2qd/fMP6u+k/beW/yA3cfGf5U/VYX2g
         Y1K0V7oQgStVXvFw+eSOr6/nTYe+lQN206x6JL91jNh6f0PHMyTWu6cvlaaqji+5kt7n
         9h4W7qOysjKiOdZeHJFvYunRs4aELFWUQ83gmgG5ogmsCsuZZ2ZZpArjL9EaUqpJpLUv
         WP0QxUnicLxo5TbVek9f5CoW8Nub/sZUIYtIDeeSphTZQs3Wr1AxB1B3KxhBCEPW1dqr
         SOHA==
X-Forwarded-Encrypted: i=1; AJvYcCWpt4QHy7aeGxGlTJQ63dHlwJyStvhWSteARi+vPDnhUiwJXnhotLP5ZCx7jigt1LVP5/toDI2Prg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbsQxaPrRhhaizDzXokfIrVP2V4MOXMOr7KvpReGnyXsqg/30f
	6rHPdZXJAlQZYwzVKkq78YE/IjDt0SzGCysrTh//3CJrfy6Og0ox+AzDpcm4tXC69Jh5Fg+ZG0X
	pDrPZ
X-Gm-Gg: ASbGncusthVSv5cQaDhXS05A6HKPw5Yx8qAX8aclq4ZVcM6mDthp5AAmaKwX2edoHbt
	7a4c/KuA1IO0dreHGqqjxJaZLo7KxdFXW0f5RPqp49OMu3bzCmb0/Mm7hzRJOz5p0j863yZwIYS
	h546WRq4eGDc9FLfIugP0feu+NmJXMfDK6/HRaLQn5q11iA3V8uGUt3YjL1wVEB27lElOCP/r2R
	q88OZ1enc6YiECeDcmHK3Qrf+yZX/q7+zdyRk2gAiHxbavhfn1X1WKQGc+pYKerTSPz7kdGvAIV
	I4HpuPTs2TfZnrq1PgqkrQjy9iOOzLyGnTtYdSRnPcZZRFmGT0ulAnkCh6Pl0nFfwZxIxU86FOa
	YhW/jrfEN1PlQugy42RQEIsevtjQvIlk8kB4dutOSWqOfDkWwA7EY+61Cz1qSkKWKDQJ3dT8Pzv
	2ugeJmWg==
X-Google-Smtp-Source: AGHT+IFU+LbPtYHGtnihd0hMBrawdDM9t+rTv0K5oNUVO485o9fqhxn3iGCA7d5pEEesqA56nABXdA==
X-Received: by 2002:a05:6e02:3e93:b0:434:96ea:ff7b with SMTP id e9e14a558f8ab-435a9e2425emr21452625ab.35.1763650139232;
        Thu, 20 Nov 2025 06:48:59 -0800 (PST)
Received: from [192.168.1.96] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90e9b61sm11300185ab.34.2025.11.20.06.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 06:48:58 -0800 (PST)
Message-ID: <3202c47d-532d-4c74-aff9-992ec1d9cbeb@kernel.dk>
Date: Thu, 20 Nov 2025 07:48:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/44] io_uring/net: Change some dubious min_t()
To: david.laight.linux@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-5-david.laight.linux@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251119224140.8616-5-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/25 3:41 PM, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> Since iov_len is 'unsigned long' it is possible that the cast
> to 'int' will change the value of min_t(int, iov[nbufs].iov_len, ret).
> Use a plain min() and change the loop bottom to while (ret > 0) so that
> the compiler knows 'ret' is always positive.
> 
> Also change min_t(int, sel->val, sr->mshot_total_len) to a simple min()
> since sel->val is also long and subject to possible trunctation.
> 
> It might be that other checks stop these being problems, but they are
> picked up by some compile-time tests for min_t() truncating values.

Fails with clang-21:

io_uring/net.c:855:26: error: call to '__compiletime_assert_2006' declared with 'error' attribute: min(sel->val, sr->mshot_total_len) signedness error
  855 |                 sr->mshot_total_len -= min(sel->val, sr->mshot_total_len);
      |                                        ^
./include/linux/minmax.h:105:19: note: expanded from macro 'min'
  105 | #define min(x, y)       __careful_cmp(min, x, y)
      |                         ^
./include/linux/minmax.h:98:2: note: expanded from macro '__careful_cmp'
   98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
      |         ^
./include/linux/minmax.h:93:2: note: expanded from macro '__careful_cmp_once'
   93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
      |         ^
note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
././include/linux/compiler_types.h:590:2: note: expanded from macro '_compiletime_assert'
  590 |         __compiletime_assert(condition, msg, prefix, suffix)
      |         ^
././include/linux/compiler_types.h:583:4: note: expanded from macro '__compiletime_assert'
  583 |                         prefix ## suffix();                             \
      |                         ^
<scratch space>:319:1: note: expanded from here
  319 | __compiletime_assert_2006
      | ^

-- 
Jens Axboe


