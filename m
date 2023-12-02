Return-Path: <io-uring+bounces-203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0B4801985
	for <lists+io-uring@lfdr.de>; Sat,  2 Dec 2023 02:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D36171F2112C
	for <lists+io-uring@lfdr.de>; Sat,  2 Dec 2023 01:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705DB17D1;
	Sat,  2 Dec 2023 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RsQvkHUT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47110D0
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 17:31:57 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6cdd2aeaa24so547813b3a.1
        for <io-uring@vger.kernel.org>; Fri, 01 Dec 2023 17:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701480717; x=1702085517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+i59c5r8CvAOU1fRMlh/sDl0jjO0yhkohmNQVmJktOk=;
        b=RsQvkHUTggK20t+xxIy4/Og6qmX4PTlS5b0qVYBQ4+sZtuTVcG/H4Y/1qKGbGQtLkm
         6JkpzV9E6hjXLU2bxEqT2iKsy+v4qTkCxZAVMkCTjrAZaFLJiB15kREkDf97Jn6bMi00
         sKjo2BnaVTIyhU4QJZ5/pwBc1IW7wE65un04+/us4n51ScQROauIvIYyc1zZ0Uj7V19/
         FfQhQoMdRKvJf0aVD/GEJlXNKdeGxjFqSQ6IgAl5cMgzP7dUF/eIapB/xIxGm3CXxU3l
         BnbSzhWhCfrY+0LzpmLnoaR54Vfwj7jlALWXvVsYEIF/1Hkdv8UsYL2quoBDkcGaQTbo
         AjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701480717; x=1702085517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+i59c5r8CvAOU1fRMlh/sDl0jjO0yhkohmNQVmJktOk=;
        b=MVxI6iAjdkbRWt6B/o2P78pZegv3mKkjf3Ijdl/7WWoBm7Z2zLmhVdpo29w9EqTqUH
         2fto1GPk/l4oqAmLWYkizZ4QG4UtBwEhM0ZPyYlDzz2oVriX1EsxtMO7zgTjfv0qwn+L
         J02qNThWP2OJ3Nr/u4kgsWBam5P31OsXgjX10SCW02pfAQlQ2UE+VQVvGARoKi2Aqu9d
         v6zooD4NW8KTS7jgI4SQhDPsBKyYQzb+U55Si1ObTPOmN4CXdgkXkRjYoLc9kryx2Nn+
         G+TPsjpU/O5KWgC9CYa9kInavaXy/gg5WQ1yR97SRwF58Jwz9jC1aEXxTrFuMmqT5vny
         T2zA==
X-Gm-Message-State: AOJu0YzoNnhl1hqw1Y+LTW4qz4sdJXIBwT4Pr2MeVmFaeijExeaCQhLg
	2kwkzJ9sIkPvqFOudzLnFI+PNg==
X-Google-Smtp-Source: AGHT+IGRxMfE3pAUV7zySyktGbmVuI16+3DjOSiEOaMv/EKu5JQOTXoLip0S7qmFA14Ls5ggCZoE6Q==
X-Received: by 2002:a05:6a00:18a3:b0:6ce:5b6:4cf7 with SMTP id x35-20020a056a0018a300b006ce05b64cf7mr3548767pfh.0.1701480717186;
        Fri, 01 Dec 2023 17:31:57 -0800 (PST)
Received: from [10.0.0.185] (50-255-6-74-static.hfc.comcastbusiness.net. [50.255.6.74])
        by smtp.gmail.com with ESMTPSA id gx9-20020a056a001e0900b006cdc6b9f0ecsm3597657pfb.81.2023.12.01.17.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 17:31:56 -0800 (PST)
Message-ID: <ac5e99c6-7297-4c56-8f3c-98755c58092b@kernel.dk>
Date: Fri, 1 Dec 2023 18:31:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 0/4] block integrity: directly map user space addresses
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, io-uring@vger.kernel.org, hch@lst.de,
 martin.petersen@oracle.com, ming.lei@redhat.com
References: <CGME20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c@epcas5p3.samsung.com>
 <20231130215309.2923568-1-kbusch@meta.com>
 <e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>
 <ZWopLQWBIUGBad3z@kbusch-mbp> <ZWpjBCF4KueqKlPN@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZWpjBCF4KueqKlPN@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/23 3:49 PM, Keith Busch wrote:
> On Fri, Dec 01, 2023 at 11:42:53AM -0700, Keith Busch wrote:
>> On Fri, Dec 01, 2023 at 04:13:45PM +0530, Kanchan Joshi wrote:
>>> On 12/1/2023 3:23 AM, Keith Busch wrote:
>>>> From: Keith Busch<kbusch@kernel.org>
>>>
>>> This causes a regression (existed in previous version too).
>>> System freeze on issuing single read/write io that used to work fine 
>>> earlier:
>>> fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -cmd_type=nvme 
>>> -bs=4096 -numjobs=1 -size=4096 -filename=/dev/ng0n1 -md_per_io_size=8 
>>> -name=pt
>>>
>>> This is because we pin one bvec during submission, but unpin 4 on 
>>> completion. bio_integrity_unpin_bvec() uses bip->bip_max_vcnt, which is 
>>> set to 4 (equal to BIO_INLINE_VECS) in this case.
>>>
>>> To use bip_max_vcnt the way this series uses, we need below patch/fix:
>>
>> Thanks for the catch! Earlier versions of this series was capped by the
>> byte count rather than the max_vcnt value, so the inline condition
>> didn't matter before. I think your update looks good. I'll double check
>> what's going on with my custom tests to see why it didn't see this
>> problem.
> 
> Got it: I was using ioctl instead of iouring. ioctl doesn't set
> REQ_ALLOC_CACHE, so we don't get a bio_set in bio_integrity_alloc(), and
> that makes inline_vecs set similiar to what your diff does.
> 
> Jens already applied the latest series for the next merge. We can append
> this or fold atop, or back it out and we can rework it for another
> version. No rush; for your patch:

I folded this into the original to avoid the breakage, even if it wasn't
a huge concern for this particular issue. But it's close enough to
merging, figured we may as well do that rather than have a fixup patch.

Please check the end result, both for-next and for-6.8/block are updated
now.

-- 
Jens Axboe


