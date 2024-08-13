Return-Path: <io-uring+bounces-2751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3049950C5C
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 20:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11EE51C20A4D
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 18:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2091E1A08AD;
	Tue, 13 Aug 2024 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dqcOayPA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76CD19E81D
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574027; cv=none; b=FGAWmFtPc/I6SIgg3PtaKPhruHtS3PDHQ8GnxLOWfAkroHR+gCTnS2M8HnCgOTK4uJdXVcQzDr07xIUGvUHNKKdIZTnqy3WRJBvzb+3uuGLx8JlZJKV+IlBCB/Qbx0ddJWHXylKwtu2iSxZUPr3eRp0pBxtbubAu88ZdFtrgdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574027; c=relaxed/simple;
	bh=gdVCYl6k5olH+glQKdCRmNrRYORXNf/bK/WIRF3gY7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rTlmUmdw1VinLt6uvqPdlRmRfEitcCoTIK7fTYXZeX4/fdsqpH/VOZQXjNyzpEUCbFsngY35MN7ARKEbj5fUUfENqvhLbz4QlxWd96jkhLe0NN41t5LLIDlnqm0kMVY1eLSjPbSRoLHgLyPbdBhWcFQvltgZ5rBGwM3KM8M1Kow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dqcOayPA; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3db1d48083dso468024b6e.3
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 11:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723574021; x=1724178821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QfSJvcpDTfYlxLE4aDnkt5z2XRFsvVtQJoQF7+pYDck=;
        b=dqcOayPAO4Bu+mcxO13O3CtSusQP9uQjuK01Ys6qNtkmdBWeckLATdgRSUN/IfxJhI
         qzPBQGLsb7GuuefJDum20aVEDbZZB0oXoA8KIMaYjcUa6nKEMnpI0VK3jEyLHhLbedha
         CbTT9b/r+1k3da9KvnQeA5Nl6jtvqnprH0Si/23xUutrcsfPwzBI2PsOzJpOPn46bD2L
         YKPi8curXCAomFdgBO8dhswZ83Gk8MTtpZK2oX9urJRkzpCNJ3oo0Hq891cwmyseya8v
         P08Vh6DlZ1CdeSXyMqq1Ubr6WY9FFiHdIQ6Jw0XiUnmH/ewJNQD9b14vunHZtnwK1xM/
         14+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723574021; x=1724178821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfSJvcpDTfYlxLE4aDnkt5z2XRFsvVtQJoQF7+pYDck=;
        b=Fn6qn2pUanfKj5pxMT9zBiamdow94TBlldlxpWlmUCJ5YiX6aLCUBfH1ZqJ8qVELG1
         ZRwCY0lp6V524u1EeupT3tXZHNE7Ys2MxP2Q8P+vc+3jyOLfNRbxe5pg1wsaO0Rst3WM
         l9y3VjFygtRj08N47IM0JpfQRfwmGuqi/Sva1SJcUtqqOaTmiQXrQg4OxdnYtK3gtqPH
         IglKI5QiYDS7kx1Gm5NfS08q3wKgRsgPcepirnukiDVOofHuiQva0n7GIMG4cPO9Y1eQ
         BNAc2HU7SBOIV//y3ppSfP6KoijjHB6kRFD6QsICOIwVIEbGTaSop2B7yYTFWP2ZeeU6
         yJHw==
X-Forwarded-Encrypted: i=1; AJvYcCXdGb96D4hja9sz21Zsn62e77jU4OuENzkvnoN2oViIQhUNRN2fH2NxbcNWF4JHhr3PV3heubuCm6WQh1buC5+f6/i3TJ+Is7c=
X-Gm-Message-State: AOJu0YzEiIIL5HhsUdjVAFIAVqKg5TKCWybCl+J7X8IRxD4o2Tj+0fsR
	b+6pkapuAaB5CB/bEGRm6ZukJ+fBZtb2RbRj5ozV3ucTWquFP6WznehSoP4JRDY=
X-Google-Smtp-Source: AGHT+IEZyjtH3gFAA3RjWnvCqweMGPkyOGilHJDb5e1LGS/aMKbU1iLviDfidybQhSkjjD6bSFCS7A==
X-Received: by 2002:a05:6870:2195:b0:260:f1c4:2fdc with SMTP id 586e51a60fabf-26fe5cfc907mr265894fac.9.1723574021431;
        Tue, 13 Aug 2024 11:33:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c697a4b9f1sm1820192a12.75.2024.08.13.11.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 11:33:40 -0700 (PDT)
Message-ID: <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
Date: Tue, 13 Aug 2024 12:33:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1723567469.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 10:44 AM, Olivier Langlois wrote:
> the actual napi tracking strategy is inducing a non-negligeable overhead.
> Everytime a multishot poll is triggered or any poll armed, if the napi is
> enabled on the ring a lookup is performed to either add a new napi id into
> the napi_list or its timeout value is updated.
> 
> For many scenarios, this is overkill as the napi id list will be pretty
> much static most of the time. To address this common scenario, a new
> abstraction has been created following the common Linux kernel idiom of
> creating an abstract interface with a struct filled with function pointers.
> 
> Creating an alternate napi tracking strategy is therefore made in 2 phases.
> 
> 1. Introduce the io_napi_tracking_ops interface
> 2. Implement a static napi tracking by defining a new io_napi_tracking_ops

I don't think we should create ops for this, unless there's a strict
need to do so. Indirect function calls aren't cheap, and the CPU side
mitigations for security issues made them worse.

You're not wrong that ops is not an uncommon idiom in the kernel, but
it's a lot less prevalent as a solution than it used to. Exactly because
of the above reasons.

-- 
Jens Axboe


