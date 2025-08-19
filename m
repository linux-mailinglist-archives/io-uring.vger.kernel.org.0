Return-Path: <io-uring+bounces-9067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A16BB2C766
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA3DE19655DF
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7577B27511E;
	Tue, 19 Aug 2025 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q7faqE6Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29234262FCD
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614692; cv=none; b=RebVPuewYG7PKZOAk0dYC9o54attTINT6P1JWetU9VQv7tCKWBPExDFvlmuRBCPiNp3L5F1MNX4FU4wEmSekxM4bzYDUyBYE2lDSo2X+UFOLD5TDecp7UpquPzh9kyimr/yUTmjFRA11slLe3QWnFOQuBw22uipw9DgNKpTVe4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614692; c=relaxed/simple;
	bh=V8tPAHv7NGOFQz9IAhlOokTiF7/KRhJObmk/rM5XIeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ik9US76R89OZE9/2mZ5qPfUz5IEjCQ9sqwP+VmHQbohG+ypCl9/hb0hOw5CtFJ4xIlGPt5LL5XFQcV1qH8Roqwgxisrqt3qK0frbwz8LmTpt0W+AQdTjS7kiXwCtKlNnInnOVV/HrX7VUrTV27e8wh4mPNstlximpkGKkMEM2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q7faqE6Q; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88432e31bdbso386601639f.2
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 07:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755614689; x=1756219489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nhf50ikNzvmA+q7GfNoYfkdo9uzvXqOdl8fr2Wi2Y9s=;
        b=Q7faqE6Q7ti4gxvQ61+XY7dgnBu7iMkFt9to1eUB49LCk3wH4xFYSQq5D/uVdnFcry
         ynumZrIzbnhJ8dUnJx4mjTicbXtDuSaZpZyXnxzsQMErJd4n3u885aoRI3w9Qf4yOdme
         ulWzjFSJe+VmYxil0jh6wXsKehwHLcxeA0AU+dRs7cpJpX7zR4j40BgOl67oYUfp+247
         BAXYSGGg9dGvKmYYcKwFmXI3nbbJhSN32ZRXS2HPDYSA6jHE8xoT/tnTPyGR5xjVED0o
         NZi9ouDBdQjO5VHnk6uvzpFWr2y7Cf+HS3wKlWIHJ/o6hIa1hikodNEgCrUp6W94Yx+M
         zKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755614689; x=1756219489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhf50ikNzvmA+q7GfNoYfkdo9uzvXqOdl8fr2Wi2Y9s=;
        b=uPf3kycxPolqCUrGIWIMQafHaraRvK/huzQd4FcgshT+OtXErJ15sx+KZBDtpKUetg
         8tLtiKLpVZhLUDo0bwMmDnBTzmfQ43wyo/AKlP4yGIGlz38PFw06eAfFFJwPeZvCFY3z
         W78BvFXhkjHWRwV8cO8LYFgOXowrX+B3ZXqtw53gyESlnP+2uXG8pwUS361omZU/0/8X
         QtCzO+W9m2X+0nt8g8NhHv+2Nr0ccyMfNACEaSW96nSj8n3836dNgfZtkTAC9c+6d3Ry
         eHmFkr6yPaId/liyDftGSXd8CQuopP7wUG5gwKxsu4k11fdWNicVY8GnNe6oQSckOudb
         gouw==
X-Gm-Message-State: AOJu0YzQnXYC6FctCg9dwS16x1n0bGVupSAz6OQFeaIBv+BCP7B2RJDK
	2qoEzpVuo5bRXWbS1p3h1NMArQ1euKsqUNasBSHyESSZozCeDK3fs/nQ96SKUESQpzE=
X-Gm-Gg: ASbGncs7cZV4sp4U7ofBBhSERBpOeTJqNkjZhnqYaGReWFsV3/R+iddo629qHd8977M
	8cfVL4T+AQOzfQM5WZ2/Ow5lBPg0r1xUN/leYyERWJqVWLGYUVF7zRIK6FlP8Kb/gpGhA/Z9ho7
	bOpVnvbdNcqysK6GLyw6guAxKU+iqmAk9TJ1tFBCACE8VdOC/nQ+tAoN+augrYUJR9CghiMxpuO
	fk0mXn1bC7FaXc5mkOwD/ja2+2NRhS63blL2+mfOOuY6pHFd6UmDuXvDOCqAaEnstgKSFbMTeqb
	uh/ZMkCtz41wZqmRwcmx3/kNs//ISbfS3+CjRQXZbTn/z3praCtICP50BMP4DjzfakviycsA6mD
	hdIO3TQpBB08Koo0GMBBttRn0Ohxv2A==
X-Google-Smtp-Source: AGHT+IFVGSDs7d44KayFUWza2HUJxaGC6fgs6e/ZQvTF8Ldc5fUpQhaxJ5zBGsEWpunwgPMBYCKHiQ==
X-Received: by 2002:a05:6602:608b:b0:881:9412:c917 with SMTP id ca18e2360f4ac-88467dc220fmr474328839f.0.1755614689086;
        Tue, 19 Aug 2025 07:44:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f89b611sm422851039f.15.2025.08.19.07.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:44:48 -0700 (PDT)
Message-ID: <9b8c9a80-4ab9-4d06-b357-228ac5beca8c@kernel.dk>
Date: Tue, 19 Aug 2025 08:44:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250819114532.959011-1-ming.lei@redhat.com>
 <9290b8d7-d982-4356-ac7f-e9fd0caea042@kernel.dk> <aKSLjwcqr1Mq3AES@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aKSLjwcqr1Mq3AES@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 8:34 AM, Ming Lei wrote:
> On Tue, Aug 19, 2025 at 08:11:23AM -0600, Jens Axboe wrote:
>> Added a comment on v1, but outside of that, do where's the ublk patch
>> utilizing this? Would be nice to see that, too.
> 
> It is one big patchset, which depends on this single io-uring patch only,
> so I don't post them out together.
> 
> Here is the whole patchset:
> 
> https://github.com/ming1/linux/commits/ublk-devel/
> 
> Basically any ublk IO request comes from /dev/ublkbN, its tag is filled
> to the multishot command's provided buffer, then we can avoid per-IO
> uring_cmd. Communication cost is reduced a lot, also helps much for
> killing ublk server pthread context binding with driver.

Sounds reasonable. We'll have a slight dependency with that for 6.18,
but that's not a big deal.

-- 
Jens Axboe

