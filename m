Return-Path: <io-uring+bounces-4694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BBD9C8DAE
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 16:15:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B796BB2A3FD
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 15:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA38A13A265;
	Thu, 14 Nov 2024 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqtib3in"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351F127E18
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731597256; cv=none; b=jTB6lijkfXEIauIauMY9TYLOhNlB/UcOHtP/Q9xCisCAizll7CNbBQag9at2FZ2KQxBS/Rqs/q2X4cyQkrNzL7f13cWv3n/TaAPJ1etZTCc59gzQ2yknm1iy4RB7SdVZ4WYel+Go+CmXOCgCZkaESAkoo5YL7PGbeWFOpsFZTm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731597256; c=relaxed/simple;
	bh=YlVM+LEv9LGONPaBNGD3rkx5AFkjzIxe52fag5cpHew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+9ALJHpsqo6/+R/Wh/rJNsDBfM0RuIZYWr6fh3ArQHGQ+2tG3+nAabYKbqB4US0vLirvh38EA/AOAfTKJvdOu9aDA8LjTc62pTjJAGbSNTObACMwDRQNGZQA6v0332TmNwOB//pj8nHLUs3/gyXx+XMfmYtqpH9KvFSaQEJE3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqtib3in; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-71a6c05dc10so469040a34.1
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 07:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731597253; x=1732202053; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCl2BZ11vNdK4BSvhzgpyWsQe6+TxyyUP/YQKxpwnUk=;
        b=oqtib3in+j2TAx1IQUlgsUyYXyyFuB3iMpRYfvC6yJxXKl6rABZaXa51srW/eFgfAY
         JpK2/+XesYOOwzO0oHk+RhS52RNRSa3OMy5XaMpGw09cIfDWPegiSKdqkmMFlVRipyeI
         Vrvr5mMJTCYVkKC8X4oYJ9sJPEIfDNhqEqJpmQicvsAwf3OI8wZOGzn30Aa+NcSDvSS+
         7Q40fqVpwvj0qE6G5My4i+VbNYEg9YO27FKjb6QizVdCHfYF0aU6EJzR25srYhZTj9fh
         HJ3yybv1zGWqouAuA7z/t0Us4pPidKLNBKiYUGfbsUTo96dbkChFxvcdYeHQ0Wsxls65
         Xmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731597253; x=1732202053;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCl2BZ11vNdK4BSvhzgpyWsQe6+TxyyUP/YQKxpwnUk=;
        b=uEF1m0BMxk3heNePh3UUsnJE0Ae8phDmi7n3LwPe+B3PmD4KRdI/zhSM4QLhU14rHJ
         3UORMHkHfh98brYLAZQixx0gyIYF0UwC7L/TO0RmHlo5oYyxi4IDOV2NGReKu4vo7g7f
         ih7P2ad6PCs/PhFmUp+q6pQCgAwkoCJWIJ3hjs/dMHA0DEb6OYxwrjts0joAQcCdMwVg
         raNWZ5RXLaSXFRxYFr/mhaHhv8at8YR77lxEHflIEQk9RKVOCUUULe0eVUrq6OxTxpXU
         glYrY59KBfs5ZaUz/q6gsesZ6Idb7bVu7FoGg/89RSvitjbISAxSXMEpdsamm3F3HFV1
         j5Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWhRAhv2SnhBAgrTzX4VcTeHm0izWyVJZVLPG6Vm0DbEn1TGpxEYap2roRVmcCbg734wipsw3uR8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzB0NZ4jG5haqS2aWrSwAdgUCR5kYV0ad2Ie4/to8+s2SEBgg9q
	4kWNxLWeQ0qAY/DOsnYyOKX9OPkLweNBOPd2NQinZDniwZ91GIDNINQTPswsunY=
X-Google-Smtp-Source: AGHT+IHNdCNa9fduW+ReDmhoxPJTTc4XLsVRba132OXrM8wujEioBQ6IKE0m5EgBdKU01FI9D7cHPA==
X-Received: by 2002:a05:6830:3591:b0:717:f7b9:e167 with SMTP id 46e09a7af769-71a6aed5f10mr2644003a34.15.1731597253478;
        Thu, 14 Nov 2024 07:14:13 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a6eb73b60sm413694a34.68.2024.11.14.07.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 07:14:12 -0800 (PST)
Message-ID: <0236980b-b892-460c-802e-a87a79b7ac0b@kernel.dk>
Date: Thu, 14 Nov 2024 08:14:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't reorder requests passed to ->queue_rqs
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20241113152050.157179-1-hch@lst.de>
 <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
 <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
 <20241114041603.GA8971@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241114041603.GA8971@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 9:16 PM, Christoph Hellwig wrote:
> On Wed, Nov 13, 2024 at 01:51:48PM -0700, Jens Axboe wrote:
>> Thanks for testing, but you can't verify any kind of perf change with
>> that kind of setup. I'll be willing to bet that it'll be 1-2% drop at
>> higher rates, which is substantial. But the reordering is a problem, not
>> just for zoned devices, which is why I chose to merge this.
> 
> So I did not see any variation, but I also don't have access to a really
> beefy setup right now.  If there is a degradation it probably is that
> touching rq_next for each request actually has an effect if the list is
> big enough and they aren't cache hot any more.  I can cook up a patch

Exactly.

> that goes back to the scheme currently used upstream in nvme and virtio
> that just cuts of the list at a hctx change instead of moving the
> requests one by one now that the block layer doesn't mess up the order.

I think that would be useful. I can test.

-- 
Jens Axboe


