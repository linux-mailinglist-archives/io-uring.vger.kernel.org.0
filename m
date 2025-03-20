Return-Path: <io-uring+bounces-7142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE46BA6A272
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 10:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 439D0172772
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 09:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB17221DAB;
	Thu, 20 Mar 2025 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwQ7KV7a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D96620E32B
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742462487; cv=none; b=jniv2SdHg85X4e6dJq4egTiMpN8m+beVRzAZ5+5sZ+4gP26kepbVe8LEvFA8xQIzKisOnhTYjCbtN+7L88JOLioHoGJAKTUf71ydDLNRC/B53+hKxYAYL/QjE0KgaR32/jYIGi3tGna++oKsaP67DU/VsEfk5GJj3kCov4TQNLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742462487; c=relaxed/simple;
	bh=B0JAlTU2Lrs+p1SZVC6fwyOTpIRXTAa/82MtATFwaxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MhZu55q+VtJaQm2lvfygo+CHLafQZrGfgQxm2TfVQ/zi1qR98pYB7AStbgppn0l8+mm3EIy1Ei7XKalzHMaB+RPtt7F0u3fdGUetSRXl9MQWa8fuuJ4rtYuCnqCcRdu16qTBqVf1HPA+N+8xc8VKKVCrQnND+M2eWRQQtX3C5sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwQ7KV7a; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abf3d64849dso98212466b.3
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 02:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742462483; x=1743067283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iXNQhbcnozQYz7LTEqdUcjwhK/f7REcf7kqt99LpgX0=;
        b=cwQ7KV7ap55BLJ2EEu4eiotRPJ7ukPh5PbcxF4VUODU9FjN1YC0WxzJo3b2MuPIExE
         if1iCwa6RIRDdVD7Nb31cryYKqTl6Hrhtp5isnf8v/BGD/pphvf+6maj2/LLttyr1NQd
         pjIta9hZIT1iZPGsDPyiYipmFrUYkBQFgkAaazRw2SO/bfYF4V+sIkLs0/C4Y2VOoqz/
         cmy0oatcp12xawFbG7OjpEuiaxNS3+cE35lrXCNPSkgBQq32LVVgLq6OYmy7nII61nh+
         A8tOc7gD48tVODXnfZ47oaE+AAR1LOovPRgv0I0AfUf0WYA7MdZN1uJ2wKF2hY9iyPwU
         jzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742462483; x=1743067283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXNQhbcnozQYz7LTEqdUcjwhK/f7REcf7kqt99LpgX0=;
        b=DXkmlWfhgv5c4JjglJG2t11Xfae+BWY+9hgAkrraEMcr8DRH6dgpPAYhtPbJkA42ws
         MOlMFoDSiTWavRepiiCczhhpFy9hmeFNgIozN/Z0fen2aPA87z00xfDXH2i1n36hYrp5
         qRAmK35XmstVmuwVJOXryoRe88ZRJrImWl2XnEt4KKXdmW1pNL/Fm3Sbci5hiPf+2dl5
         r0DIhna9P2vWHd/2sg5uezGihLAqNC5s4g+KWwuL4GqiA7sMj8/tTerGMebACFn9ESE8
         YxHO9Nx9wp04fWIsg7jTt7gR4+uWQCTli2RSOEHsgh+9HatDdEHo8ZUXuCSEVD4sKBSx
         AESw==
X-Forwarded-Encrypted: i=1; AJvYcCWL74ScHqL7yFbaHWWlp44+ujdK1xGjSrvVUFAaU8l8QjL4SF5sNfrzTQ8TQrAoJWFI23LBh6sLxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw67f1hR11wATADAQQY+nRhL9lmC1pHK0IezRBn3PgpOhJbCmfP
	pTp9kvdcjeDFTIlm7a0kI11iGZ1YTfwpYKqlTf/JTCwU7DuyXtQZ
X-Gm-Gg: ASbGnct6cYHUvQUORTiNAlBR8PXbj2YfeyCwpBUNeVN1QG3NOcAfTnElFP6nGCORLQ8
	1G/5jFLyV3tFZCKCk79DtoZ5IvAtk+AoEp93oKfF5lOZQoE/LXxCZ3FTec5jCB2hWM/YX9xkntX
	vNHog/SJXC20jL20LRzrMuFxQbVqLRFk8MZ8lZBe7qOSPpnE/tKNnpU62m/4NX3CltAz4u1rFk9
	Hym0kgwmF1AIK+197nftdCnQ347eXAeX7EjG0wUFD1Xb120hqdkuWZcdkDf5UR7+picrpJSOdW2
	2orwtKyk4iHgnhT848UIMGtQkdMxhsGyS0W4uXxrOp0b3g4PseqMggKZeZLP/uQaj8IbcnJEPgE
	uvg==
X-Google-Smtp-Source: AGHT+IGL6+UdYq3CVhEemPuEiGsaz2vIKFwg4WpD3fJLmY1RQwEX7vaKgGG/iqh/qp+NfXSkj1bKEg==
X-Received: by 2002:a17:907:3e90:b0:ac2:4bfa:6f33 with SMTP id a640c23a62f3a-ac3b7fa5e0cmr558933666b.54.1742462483201;
        Thu, 20 Mar 2025 02:21:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5148])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3b2b94da0sm257965266b.148.2025.03.20.02.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 02:21:22 -0700 (PDT)
Message-ID: <639d82f9-4a49-489d-a933-2324f3786e10@gmail.com>
Date: Thu, 20 Mar 2025 09:22:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] liburing: test: replace ublk test with kernel
 selftests
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
References: <20250319092641.4017758-1-ming.lei@redhat.com>
 <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/25 13:47, Jens Axboe wrote:
> On 3/19/25 3:26 AM, Ming Lei wrote:
>> Hi Jens,
>>
>> The 1st patch removes the liburing ublk test source, and the 2nd patch
>> adds the test back with the kernel ublk selftest source.
>>
>> The original test case is covered, and io_uring kernel fixed buffer and
>> ublk zero copy is covered too.
>>
>> Now the ublk source code is one generic ublk server implementation, and
>> test code is shell script, this way is flexible & easy to add new tests.
> 
> Fails locally here, I think you'll need a few ifdefs for having a not
> completely uptodate header:
> 
> ublk//kublk.c: In function ?cmd_dev_get_features?:
> ublk//kublk.c:997:30: error: ?UBLK_F_USER_RECOVERY_FAIL_IO? undeclared (first use in this function); did you mean ?UBLK_F_USER_RECOVERY_REISSUE??
>    997 |                 [const_ilog2(UBLK_F_USER_RECOVERY_FAIL_IO)] = "RECOVERY_FAIL_IO",
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> With
> 
> #ifndef UBLK_F_USER_RECOVERY_FAIL_IO
> #define UBLK_F_USER_RECOVERY_FAIL_IO   (1ULL << 9)
> #endif
> 
> added it works as expected for me, but might not be a bad idea to
> include a few more? Looks like there's a good spot for it in kublk.h
> where there's already something for UBLK_U_IO_REGISTER_IO_BUF.

It might be easier to duplicate ublk_cmd.h under tests/ublk, hmm?

And just a reminder, liburing and hence this test will often be run
on kernels that don't have particular ublk features or where ublk is
not implemented / available at all, and we should skip the tests in
such cases, that would be the main difference to a typical selftest.
But maybe it's already handled, and I worry for nothing.

-- 
Pavel Begunkov


