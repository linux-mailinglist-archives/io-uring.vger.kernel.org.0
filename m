Return-Path: <io-uring+bounces-9040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A397B2ACA7
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 17:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74D877A4B56
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 15:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5135024A05B;
	Mon, 18 Aug 2025 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kaU+AkCj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E9512DDA1
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755530695; cv=none; b=cjtubERZfLD2qfqr06xMG5KSSeORoNWZd55Qkn3QKP1h+qrqSvw6w6y4Os06k4XqWvdceatFSs67CwlIOCz3RNQr50y4+Yg6OijQwRPuLlcC42wpIX9Wp/RQ2lJml9mWQLZsVcLeO2GZpycoJOvr4eKjtttSs7CPIUaWuJlXuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755530695; c=relaxed/simple;
	bh=cMgs8LSeHRaPpOxIVALe5k8py0xxOX7loPJIi6rJoqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hv0Zx6RQ/NcvBw1EJxUATbKZQJWz8mnkb31KmUPjUoMiaQ6n/vkh2tDCF44kNj2jYz4H1IdzOOTMI/a2w9L7U4rmTuVRAFQc4pUq/zRwcAL6ZgpeN54D/nLaxUpPKmTnzufxD2GCvNU7mnzLZYHyIiLfFEHwZTHJrlaJkz58x6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kaU+AkCj; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-88432ccadeaso311570039f.0
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 08:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755530693; x=1756135493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZKDeHJ/xMPBJRwUIzup8k3lnV+Xm0VOlvVLCeRBIn0Q=;
        b=kaU+AkCjKCRHbIEVdorpi2h93iwCGBEhlyRq6boc/X7t3v3t3x5qbPgIFBL5F46Ioo
         V7IrpghmytYLze98RG0mwMSdi45udQGf2A9wd0Ox+PG/5HH12lEpNqMh/DgdEQo5mRcQ
         UXHEv3EOv0qYLx2EusTV1Lx/2gCYBWcGyTngkxt936t7QTMz3qEnx7D8epUqIvXwrwK7
         EBkL074QP7Y5flBw9ttiymE8poKXSS+it59BYud7zcjNOVfhQFGukAhi4qfq9bSCkUYz
         lFbvKm8MwK9QrtY6BJqJbrQpQT4PdWeEy99aFXferpt6I2LsxecVRPzQZLhWZw14Utin
         ZMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755530693; x=1756135493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKDeHJ/xMPBJRwUIzup8k3lnV+Xm0VOlvVLCeRBIn0Q=;
        b=mesJbAkfb49u3wOQCFcI8IYTTFg8mq0JxNNHi9qNFWwpTPnMH0AnCMqJJT8zw5Brei
         RKXilVAvLWKSPT+F8DAUh2uQGUNwaHaI8grWZHK6Ez69yRE5IBl7SyMhsmDIO6H5XJKB
         LnL/ghDWLtj4FTP0jYBKmEVV/rpp6wDWRTiTtqiRCbf1EIwLuKA6GCfPmrwyyrErKEBR
         CEDV5uC5tOKIs6NjX2oyTGPN2XSHkNcFO3Ug04cpWU0bZiIK32lk8FI20Fne0cvlyI2a
         A5ePZqmwc4RDNrlGoXHoeKUrmT0Xt8VpnFBNK1779jtDDOf4MpeH8LeGbtQ6DQ9mDDRM
         2QZA==
X-Forwarded-Encrypted: i=1; AJvYcCXEESAz2pLE3ab6HU6/8aDrh+FZAHialVBATOoThgsVebqTp3VuxDrU13Djf3kBS5iHtonaBmx6YQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuHOczA0kvbL0yTExQKj1v++A3l4kQ/GWdJfq43j3U7NHgwl2n
	qH4G2KVjj7FjAmbfrDon38mPJpz78p6w086VCgYrU6vwrdo6fMGiFKbOFFmH5JFamBQyncYMlvp
	j+cWW
X-Gm-Gg: ASbGncv9ob5eR7Z9rlTIjAyMuRRoitfdEaadY+j2HkHkTp+VEt36fhr2wwXdLzXFtHm
	wuJ95W2tWimyn/DYwP9pLKMkP6K3RSIr8KVvf+R8n9/SvmQbAU9XZ7oCTy7NE67ycT+K/MrcccV
	9rp9SkIuIPmsiKaU549YIxyNoGaPLgF//t0EV6ssXPyNASq7iY3kpbI1stZNCGx6SVBo4ZbLes4
	qivMwzrCWmyOzS48oNigXABackWDzKfeiNNxYeoyKtcC/LpfZ6wjNPo0HWsBwnSn/f+Tnhf8FrC
	0Vf4sf6W1NGdKcCPyZO7JiDPFxvCVNin3uM56sLetVsFmZsK4f5ETBAKfQA3sR97C2Fp2wq4yhh
	nir37VwePHhlzG72iT14=
X-Google-Smtp-Source: AGHT+IE+46aJ7jdK1FUMx4+K1JoKYKllHFZu4N+8xqrXpgq4fWejIFdRflOdq9Of4Ui/oJGed645XA==
X-Received: by 2002:a05:6602:494:b0:883:e9e5:477e with SMTP id ca18e2360f4ac-8843e4e469amr2533277339f.14.1755530692621;
        Mon, 18 Aug 2025 08:24:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843fa05047sm324808239f.28.2025.08.18.08.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 08:24:51 -0700 (PDT)
Message-ID: <9f10e444-fe32-4b98-b7c7-29e02e7ce5ba@kernel.dk>
Date: Mon, 18 Aug 2025 09:24:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/25 4:43 PM, Pavel Begunkov wrote:
> Keep zcrx next changes in a separate branch. It was more productive this
> way past month and will simplify the workflow for already lined up
> changes requiring cross tree patches, specifically netdev. The current
> changes can still target the generic io_uring tree as there are no
> strong reasons to keep it separate. It'll also be using the io_uring
> mailing list.

I'm fine with this, as long as it doesn't bifurcate the management of
the overall/main branch - eg patches will flow from the zcrx branch into
my main branch, always. I've got many years of experience of managing
downstream branches with upstream trees, and whenever there are
dependencies, it's a pain in the butt. Don't want to add to that pain.

-- 
Jens Axboe

