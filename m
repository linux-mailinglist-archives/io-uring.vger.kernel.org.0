Return-Path: <io-uring+bounces-1369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7463895CCB
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 21:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84081C213BA
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 19:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341AF15B99F;
	Tue,  2 Apr 2024 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Kfj3SS09"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44FD15B985
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086616; cv=none; b=c0QS5oDOYtqDcDolIY+UfMubNd2MMXVpV3BqVRlRw0+yk6CLLLxV4f752gXM9wakJXyO0DV/LIrQLSSv7MBriZ5tBjKwIXvTl67F7JNZemVoBPA0Z2neAdTYuvxvuGkcRllJSoXXkWZ0hmxAqvnjrSg3iOIlAguspICws4+H9Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086616; c=relaxed/simple;
	bh=Ajif/9j7M/zsqMVNXdBm2tkQBVeG6jrR2PglV/6xi7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lT33r0b7RZzjYwvmXJozPLpuoZGsdVEqCiKqWv4QGliTK9hxph+IxEZsKCk9s+tOva2OV1YKr6+r1cNbRGcVmaahkoza4sC07sSuHq+rfQa98Ncyh1iXxpCbIjZMEq2J2TpTpEEfp88C6QotZ5579RRNVN4C1KBXL5SV0kzWHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Kfj3SS09; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso34066939f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 12:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712086612; x=1712691412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ffbeIo6yT2gnuWj86yFH3HoV79Ov5Gn0g1nar2qmPdk=;
        b=Kfj3SS09wl8NNNp8wBeLKn4Fb9EJokqF1eQIr2FgIdxJWqnmxY89FAX4eZ62j5bPGa
         15w4Smq2Ob/iPLhZZDIet7pzOTuBpKtuUw58970nbPF5P3uY+pWoF6M4x8CnGweE0RWm
         M9njRWMllpJEmGLSPCpHvzD8tZvW7HHZJ7as0kgZakFSFB+bcg7hf2WmkhWKjWc2dCkZ
         aYTk0Qd4KZZVGDxHIKIwFqk9T5wB/CmS3NHkL+xftfctSW9efQjkjkWZc+YL6GDNxuxH
         KKDZfIrK7iSnbEklqaY/V0EmuDHlAgvNtQiCG/LgCotVYHdvJFCFR1KD8Tzr6RbWHNs7
         BeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712086612; x=1712691412;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffbeIo6yT2gnuWj86yFH3HoV79Ov5Gn0g1nar2qmPdk=;
        b=OWg2ezoRU3CQ/OmRVBE3maQDOufNQLwN3KR9bHkUL9ulgz0q6L/ZyemA3udM4CeUZI
         bSD7V3oha3JcZfBuOPbE3qzFClEh/3x0Fj8Hkvn1R7vtwrroCInCzQTqXJmup76/UUw9
         QvfqnBqKuh6r0lAVkUjtV+rh8c2kGMsivnEkherwcUYG9+JlavVTDu2N5W11K6oKLd7D
         EHIc6TXJ21sHtPtszp19svicMGoZh47+9HIPB2d8+br71G0nlfZT9SvnbPZ2iJ7eRwyZ
         93/4PhEEB7DWW4oN9fijypswAVNBiaA+MKKDZ9N0UUcOhts+KJjRRg/eTjgseVHiemLk
         Bfig==
X-Forwarded-Encrypted: i=1; AJvYcCVtAOteESwW3Ygn4Is3hBdnGDiwuYCftyxapx0GTqR+kRyt6ghWjyua97bbAlAFtgupUkUpOjKU5BkaHVm6b3xWklpbFmpxe7I=
X-Gm-Message-State: AOJu0Yx+xUR0eH3wA88Nkdm1eurxr8Gjrow4sEtikHkLGfbibUeCdUzV
	V5AmMo0dGMkJGuGWkBNh/SFW2MkWhiGNC82V1WWUgxHqhb11c3SV4wI4pk5SCBc=
X-Google-Smtp-Source: AGHT+IGkboOTfjsINZ2pc3fhknP/0plt8MY2ueAtvzQtuiRK3voiGIWqMn9regtabe/Az8LfA2D3MQ==
X-Received: by 2002:a05:6e02:350c:b0:365:224b:e5f7 with SMTP id bu12-20020a056e02350c00b00365224be5f7mr14486036ilb.1.1712086611839;
        Tue, 02 Apr 2024 12:36:51 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l5-20020a92d8c5000000b003688003d036sm291713ilo.61.2024.04.02.12.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 12:36:51 -0700 (PDT)
Message-ID: <7bfa6e57-11e2-4a48-a024-e92a379b45cc@kernel.dk>
Date: Tue, 2 Apr 2024 13:36:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in put_page
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <0000000000002464bf06151928ef@google.com>
 <a801e5e8-178b-41c5-bf76-352eabcabf45@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a801e5e8-178b-41c5-bf76-352eabcabf45@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git for-6.10/io_uring

-- 
Jens Axboe


