Return-Path: <io-uring+bounces-3927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D68A79AB959
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 00:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5486FB23A5A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5366E13B58A;
	Tue, 22 Oct 2024 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="PW1rkLr2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D7C1CCB50
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729635016; cv=none; b=WH0DLpfMTfJBs1ib3Toy/RZ8H5NrfqTZp1Snx5r+9zvaOcs7Sh1sQ39Y1oyPUrMzU28kHGRC6wRd1h2beNGgXOBH2y+xx1UdLoMlQGSe7LZSBmJFbHwGXQ/TzlqMF0GmVYC0e3ofBzXTJDxvXCrcq09EJwyD4JqyWgvzJe/VP80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729635016; c=relaxed/simple;
	bh=i5Dux+tu36s4j3bjtGaxVlsWNTwVxG8Li7ytEIfbz3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmL1rGprlKQ2n8xPiDxmNxNQg4q1KhDeqP1Q6woUsuw3fQuO6j5EH2DHgXeP+tGUhwTsUZ4dwYmz4bT6w9q+78nms5D/4yToDVZpfImQzOCS9fdjIZRyqasfy4pjxqvbc8amYDCWwi2UKhCXxB8xTObtaHDIQL6DR4v54cIFn50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=PW1rkLr2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20cf3e36a76so60181375ad.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 15:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729635012; x=1730239812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBS9NGU/A5YlWZkorpJxAKD2D/OcgCE8QaEbQhOrhzQ=;
        b=PW1rkLr2EoiyWTplnh1D5R8C0RY1wt8U2b//1ZpwqX6sHaOVUkiGmHZxoUuqjltMhR
         4+KeJEydSLY2nYwKb4+hya4k5Up7g7oMoW9ELRPHFKoHrqa4YgQdsjD6nSqglUJICbxW
         Khgrgf6K8h1yHj8Er29/++ud/mfvFH2xojJPccEm6Q1MkXE8sac13ZrB+Jvog0dIDXku
         /RS8Tyj8kQp9v8/3V/ZEVXgEExYgGVoe9OMYRuqRHZzSofWnN9zx1/D2a+Xga3GkD59y
         9tTWqW5d+bBF3S8SUtGxb34F7AwDNFzm7k/JsRc6k4iQ7wMbQg+UpmYA/7JkfP2cwYmB
         XRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729635012; x=1730239812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBS9NGU/A5YlWZkorpJxAKD2D/OcgCE8QaEbQhOrhzQ=;
        b=ecR7Zc6XFpRs2k7s+2Nk0Vdax1tN7dW2D8L+KU1qt0ll2rMh6HE8una1VNTkv1ieUj
         mjjE03DHF+W5jqIDtdwswxqUPnutrWXJLRNuooq5317EXBLUnpUPPlpG5X05zIMpJDKr
         Y9gys7jgQ1C0dF6pBDOdIcguNMgtYrLXHrS02NpuGp9m9gWYhfXiC+WVr5izpsCg3m1L
         fOVvc2mk0SC9CtM/GXw4pd+AHvfUBDwxpgE4VgTrAXZvwwiKSqvcNiD2DaEtA+FkHTrJ
         EuEaxlo8/bUcckVwGUvNgC9RpdJ2rR9h2ntsMmgiC4KsUC7aysYvEF4YSZsc822yo4eG
         WqBg==
X-Forwarded-Encrypted: i=1; AJvYcCUp9IAQqqgc5Q3bgRTiX9qDoH9Lspw95fj0sV7ZTnWG2Qoo3vwRaRy1VVZrrW8Y65aJMm5yZNGy3g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/FGH7RxzJTMJ6dHGlvYTsLV6z2wJIDeULJ2UTzvA6wSHOqnXF
	AaThSyyLBMQWsNphy+2zFvRCIR99usCgNzbzXIIbFm7X0r9vTdS+K45FGQP/Dwc=
X-Google-Smtp-Source: AGHT+IHYps5wy4yAP8JFwwnJ26Kg47RekaD9ISPH6q5Ssg2xxBuIMWOnmkAyFQ7ndX6rNgjJEMaZPA==
X-Received: by 2002:a17:902:ccc9:b0:205:68a4:b2d8 with SMTP id d9443c01a7336-20fa9deb634mr7955565ad.11.1729635012431;
        Tue, 22 Oct 2024 15:10:12 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::4:56f4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e9b0b33adsm16091475ad.237.2024.10.22.15.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 15:10:11 -0700 (PDT)
Message-ID: <070c7377-24df-4ce1-8e80-6a948b59e388@davidwei.uk>
Date: Tue, 22 Oct 2024 15:10:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Content-Language: en-GB
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-15 17:05, Bernd Schubert wrote:
> RFCv1 and RFCv2 have been tested with multiple xfstest runs in a VM
> (32 cores) with a kernel that has several debug options
> enabled (like KASAN and MSAN). RFCv3 is not that well tested yet.
> O_DIRECT is currently not working well with /dev/fuse and
> also these patches, a patch has been submitted to fix that (although
> the approach is refused)
> https://www.spinics.net/lists/linux-fsdevel/msg280028.html

Hi Bernd, I applied this patch and the associated libfuse patch at:

https://github.com/bsbernd/libfuse/tree/aligned-writes

I have a simple Python FUSE client that is still returning EINVAL for
write():

with open(sys.argv[1], 'r+b') as f:
    mmapped_file = mmap.mmap(f.fileno(), 0)
    shm = shared_memory.SharedMemory(create=True, size=mmapped_file.size())
    shm.buf[:mmapped_file.size()] = mmapped_file[:]
    fd = os.open("/home/vmuser/scratch/dest/out", O_RDWR|O_CREAT|O_DIRECT)
    with open(fd, 'w+b') as f2:
        f2.write(bytes(shm.buf))
    mmapped_file.close()
    shm.unlink()
    shm.close()

I'll keep looking at this but letting you know in case it's something
obvious again.

