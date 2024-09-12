Return-Path: <io-uring+bounces-3176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 057D6976EDF
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDCA52839EA
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA072186E4F;
	Thu, 12 Sep 2024 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUKKtEkh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469F11AC884;
	Thu, 12 Sep 2024 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159097; cv=none; b=gmSKUlmMIXNsr3IOktNcm70cJJIXmeQvWiKpYgcLq8mlpZVbNHx14d13VaLBhXFPgnat9vxk3kagiocK1sIbWef9lreCrRwSZAxcPLlN/iiwfvH5zI8yzOP870caFe0YR5CckFXFd0S8GST48tC0NeN1hXU+5uOp5bhKVrTvLDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159097; c=relaxed/simple;
	bh=q629/gqs6q30LbTxAw2qgfnGCkzh3mltH+MjSMsSC+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QerJMRmkEsmZHYVGWh+cMoeTHcIRwpu+VW6PtZjbeJiDBw++YaQLiuM20GMo0l0/C2x5fgb/k+NhST/WudAGjAnV1HRrfTEokOCSMaYCGqUOrr7AuUip1rqq5vrtDKhayioTpMNe8Nc70bup0+b/wQNDlqBd+tnIP8RXXcuNNsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUKKtEkh; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-374c7e64b60so791569f8f.2;
        Thu, 12 Sep 2024 09:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726159094; x=1726763894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ke8B8ei/VwftxZT7up985lGEeDI1fMW74nZ+B/Yl1e0=;
        b=MUKKtEkhkRKHdxPhEaYjoKSLmSA/WBP7ixcoBcpj7GLyqZlFbyqzHsi1uMko/1o+0Q
         p9Dmn2bFL5hyo/J1uFes8DvaYnDderjVWbXE3Aq3RzqpdqWXQClva/w3NAbSz1HaVzbs
         TH/8cx7Zz0a44KL77aDEYLChaQXxXIWp/M7Yjf2VFCu1tXs1Cy+dxWOa0zpi/sNWMQc7
         Bycqo7mW8Gc0XxV27tMWg1U+cUYGh+me1d2e3AQdHhq9CxKOwS+EQEj1KDNBgMzwa2KR
         /Be3N4Qx+GQncS4Jv6JyT0OTCx8X1/rFfufZt/GgD6aFKMFHxWZcroJA00PbBSfR5xLd
         vCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159094; x=1726763894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ke8B8ei/VwftxZT7up985lGEeDI1fMW74nZ+B/Yl1e0=;
        b=xEBWejKsDPi9z5+r9zH/B+2vN6D6zsdEqW+M9Z3ly52UNqXDdZmV8paNyjIbuczgBo
         XYCdpdygTbDRSdRX6ZLQLXRCImstAtN3GF+616O8d3KOWl0PF2kZirlft9xX6wa2Vcav
         MpVvNVDsVsKkcY79iCg7b5GDwgqqWE2VAKQsXUmPR2XiUENC7GZ/rL2pHGi8n0ivitV4
         3OIMVLUBWOItqDOqA/kmXY6T3n0KVFWwai707hfdOPY6DOmCGos/i/VSmDiAg7H87anf
         VL9hzupPZ11tNm8HNe2p0daUvoY3AbXXVO2ohPEI4yjS/ZzHBiTpmvsIuVKEPiW/A8CU
         0+dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnGLThlseWpmExLpi9FaZfTlrWHB0TSzky7txlQBV2UZomPQIPw9vtYwfMpsh9lbT5aWFxLnoaPKyQVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyI6raf/sDn1fN/UhNlluEU4RTzM0GTMDEA6oA7zbCAOombBVD
	ywQm3YLDCEigiENFgPK6SuPDWXGn/2pKMluybjychNweseeVnMDD
X-Google-Smtp-Source: AGHT+IHS4iIBmRPXS44yHXJrmVIJWvFhF6iTvnEiniY4uPDRvmSCo0v65F86PcBLdF4iVV2pB87G5Q==
X-Received: by 2002:a05:6000:1561:b0:374:93c4:2f61 with SMTP id ffacd0b85a97d-378c2cfecaamr2880974f8f.5.1726159093692;
        Thu, 12 Sep 2024 09:38:13 -0700 (PDT)
Received: from [192.168.42.65] ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956dbf58sm14795352f8f.94.2024.09.12.09.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:38:12 -0700 (PDT)
Message-ID: <c8963fae-8163-4e9d-9d9e-2284c080d564@gmail.com>
Date: Thu, 12 Sep 2024 17:38:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
 <Zt_9DEzoX6uxC9Q7@infradead.org>
 <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
 <ZuBVy2U7Whre7EnU@infradead.org>
 <bea206da-d634-4e34-8d69-94a024721f21@gmail.com>
 <ZuKzwSA79NtLAMcH@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuKzwSA79NtLAMcH@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 10:26, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 09:10:34PM +0100, Pavel Begunkov wrote:
>> If we expect any error handling from the user space at all (we do),
>> it'll and have to be asynchronous, it's async commands and io_uring.
>> Asking the user to reissue a command in some form is normal.
> 
> The point is that pretty much all other errors are fatal, while this
> is a not supported for which we have a guaranteed to work kernel

Yes, and there will be an error indicating that it's not
supported, just like it'll return an error this io_uring
commands are not supported by a given kernel.

> fallback.  Kicking it off reuires a bit of work, but I'd rather have
> that in one place rather than applications that work on some hardware
> and not others.

There is nothing new in features that might be unsupported,
because of hardware or otherwise, it's giving control to the
userspace.

>> That's a shame, I agree, which is why I call it "presumably" faster,
>> but that actually gives more reasons why you might want this cmd
>> separately from write zeroes, considering the user might know
>> its hardware and the kernel doesn't try to choose which approach
>> faster.
> 
> But the kernel is the right place to make that decision, even if we
> aren't very smart about it right now.  Fanning that out to every
> single applications is a bad idea.

Apart that it will never happen

>> Users who know more about hw and e.g. prefer writes with 0 page as
>> per above. Users with lots of devices who care about pcie / memory
>> bandwidth, there is enough of those, they might want to do
>> something different like adjusting algorithms and throttling.
>> Better/easier testing, though of lesser importance.
>>
>> Those I made up just now on the spot, but the reporter did
>> specifically ask about some way to differentiate fallbacks.
> 
> Well, an optional nofallback flag would be in line with how we do
> that.  Do you have the original report to share somewhere?

Following with another flag "please do fallback", at which
point it doesn't make any sense when that can be done in
userspace.

-- 
Pavel Begunkov

