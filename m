Return-Path: <io-uring+bounces-1984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7E28D2889
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 01:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8575228A151
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 23:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F36913CABA;
	Tue, 28 May 2024 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i9dE4Axf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC9617C6A
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 23:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716937486; cv=none; b=uyvp07r/zxtrO2Wx3p3AwPctWKPUicHbsZyd/D6t56n4dnxp4/UqtAwqwb8DGT9SYYsokdcMNguL7KIHLCtthqDHZ0Q6rc45HzMAiZVM1g7Pi6IHPNNADlqkbLyVJRr7btXHgyKsvPEiEGtGKUNb59kfJIC2wKFhM3pOVUvUHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716937486; c=relaxed/simple;
	bh=CdXfWGHfpYKwMYjQRX3Sh7jedByNYcVgxljdlB68Oq8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=T5ZPGjWUBnHL/mU4UOPK5ZFsX3Quie3TSYlbkOSHqIn44IOfa1um4x1cdJ+C6ksdejusoyUWvmF9JAB6W5JvtSljLIHe7hVVOJLQ+vvzy3mFhjPORBzwZPNknGUO/EYw8shGrc4Wz5aUD4q6QssYFhl0AkqnZUz3k7jFOxf57ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i9dE4Axf; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2bde882ab2bso243852a91.3
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 16:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716937482; x=1717542282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2j+Zr8+Gjz9tKK4GkjZ4F059BXd14JVf0V7vRzwPFN4=;
        b=i9dE4AxfONqSnRQxpT0A/id7G5oq0D0tJKNac43mh6XUicn2oNWI7mm2sCjQjBAdiE
         v5+Kb5NhBgT8k7UUL0fuJ+M5/W4mMGgKr8mcnEsL2qLK7wRgHCkMwAzwO7f8k1D0xBGB
         r+riUHJ5lB7QfH8zieBQ7lx5REcl1XAatraEVC4kfxoEj7zdmBb73nD5tf47KNSGFRkq
         fIH4jpCEJhbveFIRxAH+K5k/+b5Jw+9UYGA1CcSAE8qc+6btkFBKhMz3w45wp9KO/kms
         UZSqqBROk8OFM84OTeE+gINsE4POhYD+r4gAJA+T/JrsGJVMgOe80bSvbHZsklsJ3us3
         KW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716937482; x=1717542282;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2j+Zr8+Gjz9tKK4GkjZ4F059BXd14JVf0V7vRzwPFN4=;
        b=krz9nW+YaFd8gX+kAUJ/jPZ/ykxMnmHYZHx04ai7k9GoXwBgO+J+bjmTR591YiCc7a
         RzHHW43KVjz4x7bzt4z5CYan8EpuX7ef+lyC1sXZgLHMHt98qN2Bns9ORMG0WNa68zl6
         Y/6/eUpbRFrbXjSSkpS5BG6vk9mJp8cHqNWG+ZkKnVRalq59unoN4WklIBKlEkBW9Ls2
         EantaNe0yu6NrZFQ/7jpqwprjpeGkUirIawaZqb2vLo0FZxHkfzZxCZELKemMf8Kjiv5
         xkC2KbGEGXoj4giACQ4IvGN/7tk8+uUQ3wqa4ohQWpPEN8rOVabyXqNyh7WiJopGDATV
         lgcA==
X-Forwarded-Encrypted: i=1; AJvYcCV9amHSJhhoqlK8Yc3/B2XbxvNuaw5u27HQlodQ3R1MwPRb81xq3lVYaTIAnpLdCEpEWXLwYhIJOhJblrMm+pswGXXluBo10AQ=
X-Gm-Message-State: AOJu0YzmYD1nNnep/HXuVXo1oEsaL0tdQ64DVEmyjhhwZ0QHwNablU9x
	FN+4jXqJMNddbW+juA40/BB5bVhvs/wy7KphjPZszPGJGOydFzgYE28zlGuSzNw1m23vdspGZUe
	e
X-Google-Smtp-Source: AGHT+IF8gbgYzGnab4MnVxOuWfFC0VwouYYf3y1JiSnVx0DvDCKpP9QAlw4Kvs6Ylj7BHlct171AJw==
X-Received: by 2002:a17:90b:a58:b0:2bd:e950:dfa5 with SMTP id 98e67ed59e1d1-2bf5ee1f6c6mr12579894a91.2.1716937482215;
        Tue, 28 May 2024 16:04:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bfe78d3a2fsm3681573a91.36.2024.05.28.16.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 16:04:41 -0700 (PDT)
Message-ID: <6ceed652-a81a-485f-8e6e-d653932bb86d@kernel.dk>
Date: Tue, 28 May 2024 17:04:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
 <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
 <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
Content-Language: en-US
In-Reply-To: <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 12:31 PM, Jens Axboe wrote:
> I suspect a bug in the previous patches, because this is what the
> forward port looks like. First, for reference, the current results:

Got it sorted, and pinned sender and receiver on CPUs to avoid the
variation. It looks like this with the task_work approach that I sent
out as v1:

Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[ 2160],  5.0000th=[ 2672], 10.0000th=[ 2768],
     | 20.0000th=[ 3568], 30.0000th=[ 3568], 40.0000th=[ 3600],
     | 50.0000th=[ 3600], 60.0000th=[ 3600], 70.0000th=[ 3632],
     | 80.0000th=[ 3632], 90.0000th=[ 3664], 95.0000th=[ 3696],
     | 99.0000th=[ 4832], 99.5000th=[15168], 99.9000th=[16192],
     | 99.9500th=[16320], 99.9900th=[18304]
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 1528],  5.0000th=[ 1576], 10.0000th=[ 1656],
     | 20.0000th=[ 2040], 30.0000th=[ 2064], 40.0000th=[ 2064],
     | 50.0000th=[ 2064], 60.0000th=[ 2064], 70.0000th=[ 2096],
     | 80.0000th=[ 2096], 90.0000th=[ 2128], 95.0000th=[ 2160],
     | 99.0000th=[ 3472], 99.5000th=[14784], 99.9000th=[15168],
     | 99.9500th=[15424], 99.9900th=[17280]

and here's the exact same test run on the current patches:

Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[  362],  5.0000th=[  362], 10.0000th=[  370],
     | 20.0000th=[  370], 30.0000th=[  370], 40.0000th=[  370],
     | 50.0000th=[  374], 60.0000th=[  382], 70.0000th=[  382],
     | 80.0000th=[  382], 90.0000th=[  382], 95.0000th=[  390],
     | 99.0000th=[  402], 99.5000th=[  430], 99.9000th=[  900],
     | 99.9500th=[  972], 99.9900th=[ 1432]
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 1528],  5.0000th=[ 1544], 10.0000th=[ 1560],
     | 20.0000th=[ 1576], 30.0000th=[ 1592], 40.0000th=[ 1592],
     | 50.0000th=[ 1592], 60.0000th=[ 1608], 70.0000th=[ 1608],
     | 80.0000th=[ 1640], 90.0000th=[ 1672], 95.0000th=[ 1688],
     | 99.0000th=[ 1848], 99.5000th=[ 2128], 99.9000th=[14272],
     | 99.9500th=[14784], 99.9900th=[73216]

I'll try and augment the test app to do proper rated submissions, so I
can ramp up the rates a bit and see what happens.

-- 
Jens Axboe


