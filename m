Return-Path: <io-uring+bounces-7494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9CDA90B3E
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6842F3B0739
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 18:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778BE20E6EC;
	Wed, 16 Apr 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NAu9E1uI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3193188735
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 18:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744827954; cv=none; b=izSURE1hZNaFc+RfIbstNg3K/utZQifNwsla9NjS3IlGTKY56wyzfnbG2/97iGRZU5ScFrgTK8PhfUnuwD1JfWCqYT0ZdEVlvB/Oa72bThmNdrTZWXHvY2PX0BYw3dQtsGyeRzpWrZrGlRyXorHU6ygvTsNN0hoOW49zfyr9/60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744827954; c=relaxed/simple;
	bh=Xd1yhYRZtSnl04cMfGxOguGhij2E/y6WbAM7M31Ihy4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Atlu+XxdYfsqWs0WzlZ1ifBCMOto6lYoQJqZjIG3b1J+j0zx1wfiorqk7i5xIRrN+izIQdfVUJA2FS6IDyPbfYFEzQMdQYOmYPLdz4us4e2kvnUEXF6IentXCc3pLjaevUgtvfWmWaaEafGguPoavGQo1ncxmddi9rklbKD7EjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NAu9E1uI; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d45503af24so62355465ab.2
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 11:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744827951; x=1745432751; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cSV8msU5ydMZIeT/VWFRVjbjIuGrEmQM3VJY/v4kBEU=;
        b=NAu9E1uIC1FexSs+X7ixxiop7MZsfCNtBHVvBdwLEgYCqPzKzU5kTnCnrQX9ji5Qse
         xUabtlHtf67WsGqieT/IEufH73DEFrQMGzOcdoNK8TV/FZekqe+AzjDkci8C+b4+Gb3g
         cMqJPhD3Lkrlnzann6M5vFixFL1lXK3tYJz2npIic10+zlYA6l8VCDFrQkTZ4Q6lkN9H
         9vIgmsq4aS6j5gXL+PcVaGJZXP7JE0S/hQiavtBrufuIl3p3VXa53zlNIge2VQkDr5HE
         CMXgUHwI23Vl6a1kiQCPjjnTt2J3KRfr7nloY0rsYWVIlcf8TSm1Fcsv3mSBfG/w8lL7
         Mm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744827951; x=1745432751;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSV8msU5ydMZIeT/VWFRVjbjIuGrEmQM3VJY/v4kBEU=;
        b=gCju/ct2Mr3NTPVNEWFEMKRH8uU9VbD1hYOESKkVAi6ldSytEoMpglhN4EEtxvP3bg
         aiPKokU0BSIU98nKBPecg0DufSY+ITP8D/OtIxVhZObKUOUFL1gMt92vEY/TcmkcE7fD
         yHMQOFpK0QWhPdSmLnSU1S4IRj4zP+XPJ1aA9kCalHGCAET+0xyt+zAinvtIEkVrGVYC
         8j/3LgaKIdliPsn7yzhUMwxsXv2K3TrL2zyAS/l84bXvB8gRpnFZp98aCtARSPLX02t/
         WCmG9IeCvG7rnwrHPqltMdAXAv4iaPZL9C6B30PBXauCaXNYjtBGs9uamozYunjEpFel
         58QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyZgGn4bZntpzBJA+gnwTwibh9p8Udn7lT4qCcoChEhEc8vNbkya4CWH4QExLo/hogS486AmzLFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyATbN+JPjo8vkxesSPFp8DOwkDRfQMjdUqz2FvZiUlDtdUS6/B
	WjB+9I3sPHY/pbMIb1DKdhqj6pbXg7qhPlLs0LLtaiFZPRit9FSYcPcd2phrRaQ=
X-Gm-Gg: ASbGncvibPD7Xo6yUjOiBk0ekpRVBI2hV82IG9JSPD/Pfg3DZwUpiM6TKV9rGDHydBP
	AlxWh3lw/eb5egstCKXszUilqaf58RI0A9W0DqbFZsQ0VjfJsDY/OxaKjCnaFEDc0v+GMn+HkFU
	WzCZzJ0eYT4wwdhSWjHcNcwm5Eb4cGR/Mk4klZrX1ro8jkIMfmA//PPKzthwgnuJ63anZMYJJ6/
	WuXEms00Hw4mnOISJr+gFCo19UljhWjN1VJtPuL1eFaMhd98ozQ7oEr84L2Mf9fwjZzmR/0hGkz
	TSBcDwY+xncKM9HDBBIDn+oCO5qkB5BP6xUL
X-Google-Smtp-Source: AGHT+IF1+5zuKXNJMIaZzyxvorkQrC63hc4slnYn6CHFkd1ncN41QiNzf1vL5MHBnYzdV8iMfvjQgg==
X-Received: by 2002:a05:6e02:188e:b0:3d3:dcfd:2768 with SMTP id e9e14a558f8ab-3d815af439emr31657045ab.4.1744827950843;
        Wed, 16 Apr 2025 11:25:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc582737sm39156255ab.50.2025.04.16.11.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 11:25:50 -0700 (PDT)
Message-ID: <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
Date: Wed, 16 Apr 2025 12:25:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
Content-Language: en-US
In-Reply-To: <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 9:07 AM, Jens Axboe wrote:
> On 4/16/25 9:03 AM, Pavel Begunkov wrote:
>> On 4/16/25 06:44, Nitesh Shetty wrote:
>>> Sending exact nr_segs, avoids bio split check and processing in
>>> block layer, which takes around 5%[1] of overall CPU utilization.
>>>
>>> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
>>> and 5% less CPU utilization.
>>>
>>> [1]
>>>       3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>>>       1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>>>       0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
>>>
>>> [2]
>>> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
>>> -r4 /dev/nvme0n1 /dev/nvme1n1
>>>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> ---
>>>   io_uring/rsrc.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index b36c8825550e..6fd3a4a85a9c 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>               iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>>>           }
>>>       }
>>> +    iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
>>> +        iter->count + ((1UL << imu->folio_shift) - 1)) /
>>> +        (1UL << imu->folio_shift);
>>
>> That's not going to work with ->is_kbuf as the segments are not uniform in
>> size.
> 
> Oops yes good point.

How about something like this? Trims superflous end segments, if they
exist. The 'offset' section already trimmed the front parts. For
!is_kbuf that should be simple math, like in Nitesh's patch. For
is_kbuf, iterate them.

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index bef66e733a77..e482ea1e22a9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1036,6 +1036,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
 {
+	const struct bio_vec *bvec;
 	unsigned int folio_shift;
 	size_t offset;
 	int ret;
@@ -1052,9 +1053,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * Might not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
+	bvec = imu->bvec;
 	offset = buf_addr - imu->ubuf;
 	folio_shift = imu->folio_shift;
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
+	iov_iter_bvec(iter, ddir, bvec, imu->nr_bvecs, offset + len);
 
 	if (offset) {
 		/*
@@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		 * since we can just skip the first segment, which may not
 		 * be folio_size aligned.
 		 */
-		const struct bio_vec *bvec = imu->bvec;
 
 		/*
 		 * Kernel buffer bvecs, on the other hand, don't necessarily
@@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		}
 	}
 
+	/*
+	 * Offset trimmed front segments too, if any, now trim the tail.
+	 * For is_kbuf we'll iterate them as they may be different sizes,
+	 * otherwise we can just do straight up math.
+	 */
+	if (len + offset < imu->len) {
+		bvec = iter->bvec;
+		if (imu->is_kbuf) {
+			while (len > bvec->bv_len) {
+				len -= bvec->bv_len;
+				bvec++;
+			}
+			iter->nr_segs = bvec - iter->bvec;
+		} else {
+			size_t vec_len;
+
+			vec_len = bvec->bv_offset + iter->iov_offset +
+					iter->count + ((1UL << folio_shift) - 1);
+			iter->nr_segs = vec_len >> folio_shift;
+		}
+	}
 	return 0;
 }
 

-- 
Jens Axboe

