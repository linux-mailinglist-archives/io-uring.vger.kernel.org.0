Return-Path: <io-uring+bounces-2102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BCC8FBCC3
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AB3B1C22093
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A5E2F25;
	Tue,  4 Jun 2024 19:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xpmGRStj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA12913
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717530919; cv=none; b=IlFn5XrIy2XqWxbehZSiij/Vyl5oAvk1nCxBtZm+M2NHx+KWAX3empnJbqjGtOTCGg03CohG7raaXjhwVQqe2yaOltAv1YAWxBaJPVD9xJ5ZepxtjdMOOX85PmIUKnvfc2PFaQhRDNlgeA0DlG0zKBFIrsUqmoU+SyE1FAwG6SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717530919; c=relaxed/simple;
	bh=lZK4puTIXi4r9UiIKyj3L5flMgJeJynsOvKfoJgJ/oE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=u0ZBE/y80KHU9n5hqeeDhJjeQLHRIdmby9TytDebCtEN4KvcDd0bcdqtxB97E/QBjZ4z0tCqyXMHYPA92PWp3Fi/Swh0ppQzYI+Qyu72CfEiYmdFaTpzfs+7MR+szDFPbgOoV7aKsXZOtvUTotQ/OgXS/L3+cP+7/c5uqU6gHfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xpmGRStj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f2e3249d5eso4949465ad.3
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717530915; x=1718135715; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBUCLm6LnTxpKSgYKGJERdcZd6g7U+wCAhS2CoplCXg=;
        b=xpmGRStj6iPADcEJT6O40JVx8F1lfQE+3EtgAtRWtCZwYDiHNp2ilmvHZV63P6oslO
         nF7ikRibLR8S7P0PDmSP05JKMahnvS4hr966RbPtU8iTupYmQfJjJhTbcWR7VDLRbe4P
         2HOwEmAIDjgqy1oBM0ejKa5Jw+AoaQYb5bpdAQkMpHQaghroWufIiKIRIfYFxSxVpAmd
         fro+UTH2CHNWDRUH4yF0xyxJVfZx+Llp3E5axPl2IeJTghsXSdmeU003U1MSN3CZ61DE
         1GfNx8dSPhqBX7BwT+oh+8SszrRvtOx56iZMuzMm0tYXlsfLTKmC6ybD0pq4gSHtZ/IZ
         mHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717530915; x=1718135715;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBUCLm6LnTxpKSgYKGJERdcZd6g7U+wCAhS2CoplCXg=;
        b=RfDzwpOnu7/s3YjL7con9EcwLyOdwlEOzVbA5qYdU8urlWL+pD6dIyd6xApJyW9V+m
         dCJqd5/YNADlXix6S3r53aNaUBpmitaqAmRLe0pp3MBMjF9onTJTvfhK1x4GIaKKflre
         PnonTmTj1Axdrdq0tI/EaRLia+TJq5DWbvp/LmlVJhbDAzC6vmccxXV7ieOj7aiy9/qJ
         BtcHM7cz8hwisyFDLBVXe0TgY5MiHNhPLyZ2gmO/2ovrqgtHam7KRo0Au+rvdI5oLb1a
         WhtQKSbiemOlNps1q2jTSGdeh2kNhEFZFveTR4VM4QuEgrrOZQ7K3aEt/a8fSp7YWrtl
         6few==
X-Forwarded-Encrypted: i=1; AJvYcCV/kl4JFxhntF12oBO584j3zQVuL0ghx3Sj+wAeYgojMvKs1kaGypxvn8VEzsFCuyawIxnp5cERIquzHvZ6zHzYxcSJA5PSxJA=
X-Gm-Message-State: AOJu0YzA1Hq0m+oXf5nkTVcMQoW+pO596bYlAHUkM6nftXbKqpPfxLo3
	M1aBiJ4KHEQ8vrdjgRkv8SU7gOUcLVQ88742JK/kqMDwxt2V1vZ3kDjdqI7DXg8=
X-Google-Smtp-Source: AGHT+IGAX16IBR7yMo7Cos0TBn+QfzuooQPNPmiwpTZX4Ve7NeH9hc6HGebZkLx2yBNr78Pl7R04vQ==
X-Received: by 2002:a17:90a:a501:b0:2bf:bcde:d2b0 with SMTP id 98e67ed59e1d1-2c27de6cb58mr452706a91.4.1717530914541;
        Tue, 04 Jun 2024 12:55:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2793223c8sm749013a91.3.2024.06.04.12.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 12:55:14 -0700 (PDT)
Message-ID: <a42c7dda-1702-4977-998d-f68c72659d77@kernel.dk>
Date: Tue, 4 Jun 2024 13:55:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
 <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
Content-Language: en-US
In-Reply-To: <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/24 12:57 PM, Jens Axboe wrote:
>> If the swing back is that expensive, another option is to
>> allocate a new request and let the target ring to deallocate
>> it once the message is delivered (similar to that overflow
>> entry).
> 
> I can give it a shot, and then run some testing. If we get close enough
> with the latencies and performance, then I'd certainly be more amenable
> to going either route.
> 
> We'd definitely need to pass in the required memory and avoid the return
> round trip, as that basically doubles the cost (and latency) of sending
> a message. The downside of what you suggest here is that while that
> should integrate nicely with existing local task_work, it'll also mean
> that we'll need hot path checks for treating that request type as a
> special thing. Things like req->ctx being not local, freeing the request
> rather than recycling, etc. And that'll need to happen in multiple
> spots.

On top of that, you also need CQE memory for the other side, it's not
just the req itself. Otherwise you don't know if it'll post or not, in
case of low memory situations.

I dunno, I feel like this solution would get a lot more complicated than
it is now, rather than make it simpler.

-- 
Jens Axboe


