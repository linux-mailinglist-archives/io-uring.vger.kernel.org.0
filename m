Return-Path: <io-uring+bounces-738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1050D8679CD
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6429D1C2119C
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6763012BE87;
	Mon, 26 Feb 2024 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H9fx9Gyw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82612FF63
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959815; cv=none; b=JGbdmz3l5t+hrO42yG4vsZyTo8g+RrCydK1x4xX49ZIRiry2j+IfKXCww92Fvaz47lxHTrOlo+naZMRcZZQ7TU/rlqUJ6cJjhDoWA3DsQKUWvECcnHAStCsWjT4BF5EUNFRvyOk63wfLOerKG8Q/aDq4kAv+t//BfKgXQCVjfkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959815; c=relaxed/simple;
	bh=dipoYC7H4kofgrryqaIEJuX52ZzYNbOhtQQG9eKDWmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZS6Ui0i+T7ujbYADWFx7MwcaX/T3R4SjffWexETTpeEeoAAB88dei+Wa9gAu8YxhLxkJrz9ZHqAc9iZp1MgzmK2pBlqLwxfTZMB9U47mKuC/bakXuc0NBwSFmn5XpaO7vjiTauC5PK/LHUJXmqXOrstiDyC96otRU04l06qp3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H9fx9Gyw; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c787eee137so34391539f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 07:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708959811; x=1709564611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xleWGmUQO6yMJX9DvBzkvRDMWTN479x9Ndfm0goZLfI=;
        b=H9fx9GywMAylYYv+a2YvvQS8oLATZk3i+eYFSc7X8la4WyQ3J5Gt0MCtEoLz0mFfSP
         0Ttsy7dra/gnx/jaY6dDqQ1mQTcrKpCTqhiAqo0O2xbgDDRVYtLz05xrEODhFtS1Siad
         6EhvcSwvuJBmS/g+T0uW7XDQMsu355jll1QrGcBrE27dbOs0PCplcarTmwluWffvzavH
         kcKRCSsEWmBI1Yy37lcLIWBY+CyBJ0shT78RMIprtctpLlBsoUbMX446wrr8mvXfEjat
         ufiCflLCXUmR8Ph/Id3auQ8+oleBDJEeh2yb37zKR/y21k0qjISy18GH/p9VCkI3EkCA
         FAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959811; x=1709564611;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xleWGmUQO6yMJX9DvBzkvRDMWTN479x9Ndfm0goZLfI=;
        b=k77qSfw0bqUTO2igOrahZ3ohc57DzcEs9JdPvoiog8sRgrm0ADJsf0Yko+znY1zJyy
         VWIoAEOLxSByR+yvZhhU65LXd4a9Hv7GjC+O/PzM11UD7mgs0dltv6daIdPAfxzBcpaL
         OvhWxvp0Ba4/+dq0JWdfEW6heKS9nCyGB8V7UIfuRVE1s6ZW75C9MhoBipYz50CUsgHv
         vnPHGqBnXTmeRMJ+2PBnuDlrJV0onJbC386CiJ16qGLpFBMVx+U71jeTs8iswaMR3tgB
         xfXWjdTJcScr2u+RSHYi/tMJC3j9pjcTWMOCAD8ArNA7eMlo6kvL1m7KNVAuIa0I8TpW
         g5gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUq030A4YGCIwOaoY2I5J8ehTKGx9cKXlNPXjfetYuX5henGXEra1MTazs2TwzMOaplQbRwbDW0aqb7KugCGjuUYz1kPpgAAE=
X-Gm-Message-State: AOJu0Yw8mvpWsFnWCpIio3hrKNdGAKp1Le6FDwCW5FWRBB+Cvn9vuiMF
	HNMk4mGxzIAK6CPnf/dokoagUXZNrW6FZqYDwzh7NDNcowVopsW4EH5/KbNcHcw=
X-Google-Smtp-Source: AGHT+IHG+qN4CqTz5Q1kmw6TGHTChKuNqYzwz5yJCFwMMYRd5e6n5Cz+78CKfUXJVQt2S+gv7R3LEw==
X-Received: by 2002:a05:6e02:1d16:b0:35f:bc09:c56b with SMTP id i22-20020a056e021d1600b0035fbc09c56bmr6665415ila.2.1708959811466;
        Mon, 26 Feb 2024 07:03:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y7-20020a92d0c7000000b003657f6b23e4sm1547226ila.68.2024.02.26.07.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 07:03:30 -0800 (PST)
Message-ID: <579a7f57-f971-4b47-8351-631a5a1389c0@kernel.dk>
Date: Mon, 26 Feb 2024 08:03:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] io_uring/net: unify how recvmsg and sendmsg copy in
 the msghdr
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-2-axboe@kernel.dk>
 <88b9251a-b195-4a2e-94ba-f81e17d9de54@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <88b9251a-b195-4a2e-94ba-f81e17d9de54@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 7:41 AM, Pavel Begunkov wrote:
> On 2/25/24 00:35, Jens Axboe wrote:
>> For recvmsg, we roll our own since we support buffer selections. This
>> isn't the case for sendmsg right now, but in preparation for doing so,
>> make the recvmsg copy helpers generic so we can call them from the
>> sendmsg side as well.
> 
> I thought about it before, definitely like the idea, I think
> patches 1-2 can probably get merged first.

Yep, I'll queue 1 right now, and then just send patch 2 to netdev once
patch 1 lands upstream. There's no rush on patch 2, half of it could
have gone in months ago in fact.

-- 
Jens Axboe



