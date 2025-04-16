Return-Path: <io-uring+bounces-7504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E29EA90E95
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 00:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EAB417592B
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756F0233132;
	Wed, 16 Apr 2025 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nEfMgfYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C0230BD1
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744842226; cv=none; b=PErQIQ+9hq9dRuaR2A8r7ETtS8tnBENMV17xMMyCj5E2+lv4VMO2LaZs5lfAmrJ1zCQ5ZZDiKVyGDGAuXqeLLF9jcbpk2++KjUMBbeYqQJ3P/0cJ07vlJ6OkNf7QlQm5cR7A76rJfv77TN5pDMfTNOA/5h+b1t7qGgOSiEFUKeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744842226; c=relaxed/simple;
	bh=Y27MUmW9HKLdfUR7l351fH6hAowu+E/Wg3zWAORG01k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRYik771Mrfrp7CM2AtjJvkBmJhmM/G7B2dZFUfl5zxmBKpeaVZoHscZPb4jnLkXqphPguLzoReCBBvcHaYtmSsht5ALFANecqN3uxDYOrOsFMao993fwGlH+TldY7/pON8SuZr+JxrFWiukG3+KinjbnArPEbB263vk1olKsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nEfMgfYM; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d6e11cd7e2so1489405ab.3
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744842221; x=1745447021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aKAnG5LmOoa/Zsp5Z3rL4NzmzViuHw//GPi9fJlFzxw=;
        b=nEfMgfYMeLxHZNzNfrwH/yfeKwrvB5hw9OFMArPji173fSp0mJhqYb6qTbW6FUrDrI
         t9ExgjgAvHi58uf2LjZ9cgGCDkYVnTgcTJ2yEUO0Yr1z1IkolygBT2TWRbH+aSyA4aIJ
         pzO4fKQzpJyH3kXapvQuNlXoY49V++L0u/FRRRKWtrYET+tkQo8vtmxOOEuHYJt8l7SV
         AhBIzGP9KqaGB8ubx3nZAa4xH27BuG740hM19Y/MW20nRgShlt6lWm4voIGw14pBWkSA
         350D8DTDyS4uN7rbTip813XnsUfsIz2iu1JW0iInQLlvJsttI3Fa+e028A5i1HC/Wr18
         5zRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744842221; x=1745447021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aKAnG5LmOoa/Zsp5Z3rL4NzmzViuHw//GPi9fJlFzxw=;
        b=Y9rxr3uQLgg6+iwZb3Lvs87z2nqMBTOKxHZZDwLtNkieG7sv0Q+LOPmZjQOAxX4OyQ
         tOJa1xOJnFf3JlPNoO0T1ULjrFf6OWvXo1W1NUVeUxtZCvLHInO9S5SZJJuLjdRTm1lN
         XeE8G1COmgJyeyTItUtbDpGALOoOZF6FVFvcqivKHs0WdBMQ4iIt9vWkbtoFlol31ZzX
         +cQLE/+0o1phAjj222fCoi9S9qqeyonJTLW5+3Fka1WG0G+9Suu+XqvL5LkrRbmbgxbz
         fXdsv/klws/ok7mZkahw/l47v6OYei58few8WNtjYY3D2OrW5w68BlouJvoYTzPZZv0j
         VVFA==
X-Forwarded-Encrypted: i=1; AJvYcCXJJhptChog/A9hA3W5FOphuGyJ3mR/BS3sqxTNKEzUJjh53ZALeEnPqQuwtqrBALE1s3QXja9sew==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoVN8FYXDcx7wU99VXVKNXGM/lj0t+wOQdd2gYGoVrbizDua3V
	gIUb6WiL/nNtBScRO4J50DCCi0Z3jg/NixJgk88iLd8et5AsQuyNF201hBg8OVg=
X-Gm-Gg: ASbGncsqcXTKZpceGcRUn8RR24ndFD7kLz4Zq7+BI41WUI/TJ4qYICz5/xrRI4dZWvg
	YmJ9Qm8D9QMQ6hvYFqaTWqnpMPDji9nT7GanhXheTQ4drP9XeyNlmyR3rqbKWnQuk2LeUhHSrFG
	AT1n8gflVsT7k9ftTBvEJCCyHep8dqRpCHuh4hfY8CrwCZho2KJHH5geJ5hVpoL9/fIBWhbfz4j
	NStn/2jddMAD7y47InUf/zNP+wTtq3LYeMLtCW91fC14+HIdvyClADJuwJ9AD6mca5oghH6NOft
	EDLR/O45ryvMaRTsX3OuxzGZT2I4lNCJd0ERbw==
X-Google-Smtp-Source: AGHT+IHsbw7WpqhQZO4g6jxm4A+zAkWdCfFqzZhDSjZ3Guj73ZtATaXJDHAlGMDsK3A90cXNTH0Htw==
X-Received: by 2002:a05:6e02:1c24:b0:3d8:1b0b:c91e with SMTP id e9e14a558f8ab-3d81b0bca0emr8440315ab.4.1744842221300;
        Wed, 16 Apr 2025 15:23:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505dff08csm3792558173.81.2025.04.16.15.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 15:23:40 -0700 (PDT)
Message-ID: <fe9043f2-6f80-4dab-aba1-e51577ef2645@kernel.dk>
Date: Wed, 16 Apr 2025 16:23:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
 <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
 <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
 <a263d544-f153-4918-acea-5ce9db6d0d60@kernel.dk>
 <951a5f20-2ec4-40c3-8014-69cd6f4b9f0f@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <951a5f20-2ec4-40c3-8014-69cd6f4b9f0f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>>> Should we just make it saner first? Sth like these 3 completely
>>> untested commits
>>>
>>> https://github.com/isilence/linux/commits/rsrc-import-cleanup/
>>>
>>> And then it'll become
>>>
>>> nr_segs = ALIGN(offset + len, 1UL << folio_shift);
>>
>> Let's please do that, certainly an improvement. Care to send this out? I
>> can toss them at the testing. And we'd still need that last patch to
> 
> I need to test it first, perhaps tomorrow

Sounds good, I'll run it through testing here too. Would be nice to
stuff in for -rc3, it's pretty minimal and honestly makes the code much
easier to read and reason about.

>> ensure the segment count is correct. Honestly somewhat surprised that
> 
> Right, I can pick up the Nitesh's patch to that.

Sounds good.

>> the only odd fallout of that is (needlessly) hitting the bio split path.
> 
> It's perfectly correct from the iter standpoint, AFAIK, length
> and nr of segments don't have to match. Though I am surprised
> it causes perf issues in the split path.

Theoretically it is, but it always makes me a bit nervous as there are
some _really_ odd iov_iter use cases out there. And passing down known
wrong segment counts is pretty wonky.

> Btw, where exactly does it stumble in there? I'd assume we don't

Because segments != 1, and then that hits the slower path.

> need to do the segment correction for kbuf as the bio splitting
> can do it (and probably does) in exactly the same way?

It doesn't strictly need to, but we should handle that case too. That'd
basically just be the loop addition I already did, something ala the
below on top for both of them:

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d8fa7158e598..767ac89c8426 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1032,6 +1032,25 @@ static int validate_fixed_range(u64 buf_addr, size_t len,
 	return 0;
 }
 
+static int io_import_kbuf(int ddir, struct iov_iter *iter,
+			  struct io_mapped_ubuf *imu, size_t len, size_t offset)
+{
+	iov_iter_bvec(iter, ddir, iter->bvec, imu->nr_bvecs, len + offset);
+	iov_iter_advance(iter, offset);
+
+	if (len + offset < imu->len) {
+		const struct bio_vec *bvec = iter->bvec;
+
+		while (len > bvec->bv_len) {
+			len -= bvec->bv_len;
+			bvec++;
+		}
+		iter->nr_segs = bvec - iter->bvec;
+	}
+
+	return 0;
+}
+
 static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
@@ -1054,13 +1073,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * and advance us to the beginning.
 	 */
 	offset = buf_addr - imu->ubuf;
-	bvec = imu->bvec;
 
-	if (imu->is_kbuf) {
-		iov_iter_bvec(iter, ddir, bvec, imu->nr_bvecs, offset + len);
-		iov_iter_advance(iter, offset);
-		return 0;
-	}
+	if (imu->is_kbuf)
+		return io_import_kbuf(ddir, iter, imu, len, offset);
 
 	/*
 	 * Don't use iov_iter_advance() here, as it's really slow for
@@ -1083,7 +1098,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * have the size property of user registered ones, so we have
 	 * to use the slow iter advance.
 	 */
-
+	bvec = imu->bvec;
 	if (offset >= bvec->bv_len) {
 		unsigned long seg_skip;
 
@@ -1094,7 +1109,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		offset &= (1UL << imu->folio_shift) - 1;
 	}
 
-	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
+	nr_segs = ALIGN(offset + len, 1UL << imu->folio_shift) >> imu->folio_shift;
 	iov_iter_bvec(iter, ddir, bvec, nr_segs, len);
 	iter->iov_offset = offset;
 	return 0;

-- 
Jens Axboe

