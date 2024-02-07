Return-Path: <io-uring+bounces-571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEC884CF01
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71AD41F21997
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF2E1E527;
	Wed,  7 Feb 2024 16:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vq77BLc1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179CF81AC7
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 16:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707323835; cv=none; b=KufXWDTjuaMa7jhg6dz0W2FAKkENg8Hf6JO74fmcc1G9ai1FOqV6h/++xfS8EDI0UaBKbMS+7Vigdm1ffSDtdlBoBPo173DoDDbDzkFDmSG5eIojzjeL9wQ1/xaBxR30W0Qpn0Lst3nlsLzjljva4GO75y4MPc8giaJXJHsKRMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707323835; c=relaxed/simple;
	bh=RYSO2FbsyUtFSzUQTCXFk2Hq2fLA6/1JXzENsM9trWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZLGLkleRfunFXmyzun8jPOWoHEMlAVMOXAMKwYrrs/yYT0aJ3IeTkNYjjA5LiUmwKjgDxUbYSR4mAiSTmoD3t9+kzAG0xha+AQ2WBk+2mnmS8yUIFqnBdXHf/icwVcF2qnFeYofxI7xnFokDYOHPRceWTWWiu2jKKjoVR1k0neo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vq77BLc1; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso487339f.1
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 08:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707323831; x=1707928631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wY2HuCa4eOpym238h592uLbJ56WIqRtYGY5h38Z5DHw=;
        b=Vq77BLc1/C8hXiIdYY7IHT6/VEoXF2vtHqUl9CXa51b3SPexCFq4lcZ5mJyF2wJWIu
         FSLx4k19lBzV4pK5+baqToh050oIHR1EZUSLo45JiOk2IcWAXx8zQxFm/VFn9+uClEGY
         kkuuRLEVX0MWrVb7fdY58o+H0uUfi/qgjzP1dqwMU76oUq5GH3/U+15bs1kAxaId1+6M
         YEewi1XbeNsWglSThVgV1e/HfBVvBPNFP6nYaHZxbPC85we5gfrR+3UlN2NuG0I/uQmX
         2mDCFzmKSrCX8PZPN5jlHgeA4Er8bxH+pHPK2wab2JIHFYcd8q39IV9WY2PocvC0RIEp
         ogRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707323831; x=1707928631;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wY2HuCa4eOpym238h592uLbJ56WIqRtYGY5h38Z5DHw=;
        b=Ev/YCe0t0EZHi6esS32EaqhECkDGZUREkzazAYdG7rlkt0K1l5tcChyoSXS/r/qpU7
         DQsgxALiHoCPS6QR3kAMYCP9a7LNfeWFuA+n6IkTtNUu1ALHgb7/0N/SoSNJx5nsMjzP
         TQecACk/QlgEf6y0pqyAolQktjFMrgau9uZSkMAYn1YAI20Ve9z5YI9ha/HYoVLmz6/G
         PkfPqPbwcoVayrpChdUkIhOHehIEdiVfYBJP9ukrcO2d+VCqSNX3Mqjyev0Yndddc9Sz
         NKcFhdjH6A9ZY9ENquie7bYUOe2rgpsk2b9+dTQojTlWD5VQUKCiMEdN+fTaO0GYm+Wr
         Lm1w==
X-Forwarded-Encrypted: i=1; AJvYcCUBmGReIAnS2+KRcBU3vuhTsCPkZ1FuvBpeQ72xkCKGAkM/wrlUFIMGwBZDqdJpDHnh0ZmPj4NDrnNfXGEFKYY044XdGroDH0Q=
X-Gm-Message-State: AOJu0Yxh0++j7ayb9bKbN9LDPvCqMzmiYeohw/gWy02pGIjXoNylhrhQ
	t7AsdofSckTKGzUxqIxCWf7iX7ByGGyYl5xVjd2BbJXWbbVntVa2m+7HtHsLTR0=
X-Google-Smtp-Source: AGHT+IHBekYriwzFUTmIs2HuOvJpILsbppgD4OcQlP8S9YNmgxXVN3UyHD4Ag57kljwURqP1sLZ4Cg==
X-Received: by 2002:a6b:3e42:0:b0:7c4:606:6501 with SMTP id l63-20020a6b3e42000000b007c406066501mr484657ioa.2.1707323830176;
        Wed, 07 Feb 2024 08:37:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX6R1qbJwxbKZcTPkOsFeXY98TBMZKhJmbLCybteGMar+zmb9vBZvWn3Q7539N8D3y4EbiyR6A+g18QfVjfQq/liMbjDzqIw5AldPvT5SqGZ+IpqAJf0W75xD6GO4x75tE3U7TcnN45szS9xsvpxRCu1LbeajMaFBRkVG/Hbo0Rn362pSeMrGAv/zSDN8o=
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a029704000000b00471294696e4sm400268jai.38.2024.02.07.08.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 08:37:09 -0800 (PST)
Message-ID: <b1668ac2-3fa3-45e6-ae79-a127cb095eba@kernel.dk>
Date: Wed, 7 Feb 2024 09:37:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] BUG: unable to handle page fault for address:
 00000002de3ac841
Content-Language: en-US
To: Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
 Ming Lei <ming.lei@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
 io-uring@vger.kernel.org
References: <CAGS2=Yr7_h6ZiOSjRNXjDeXDQJrcDE+4LW5cJYAuB_2WnZYGSw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAGS2=Yr7_h6ZiOSjRNXjDeXDQJrcDE+4LW5cJYAuB_2WnZYGSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/24 12:19 AM, Guangwu Zhang wrote:
> HI,
> Found the kernel issue with linux-block/for-next branch.
> kernel repo https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> 
> Reproducer :
> 1. offline_online_cpu_in_bg
> 2. some_io_in_bg

I don't know what these two things are. Would be nice with an actual
reproducer. I can trivially write something that offline and onlines CPU
in the background, and I did, but I cannot reproduce this issue. Ditto
on "some_io_in_bg", what does that mean??

-- 
Jens Axboe


