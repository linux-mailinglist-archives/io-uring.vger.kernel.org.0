Return-Path: <io-uring+bounces-11822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3717D3BBF4
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3DC0930275F8
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BB52DF6F6;
	Mon, 19 Jan 2026 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mwDuvD8B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A249D2DB7AF
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866018; cv=none; b=TWFCMT/+uMygjHMs7XkpM9aYQCmsnqWwEU1kOgWVukzv+h+WnOCpfm0kVumXrLUVJeQU9hywA0I0Y53w6FJ2bJrDSeKJNOyNZvGDyVNWJlx3QuyorkE/VdG6Zw7bHGgzewk1cB4hwPoNHta/wV6tBj2kRAWZHB+rqwT5dHeq1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866018; c=relaxed/simple;
	bh=xDk5I/bWBUtkAS07p0QFIcj4/yKHcCi5CfQsdmD194o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRLhKMFlo+tCu9/vWxcH5cbZzHNrdokOpFeeGqZRgyHmNuweQDC358nBUKsbKVcVJ4MNwHh7mlogIAiVPN+k5nC9ypfEI9OEPQsvvLjna0vPXEpyCACkHCY4kalDKJh08s0tWLGGoWcFD5MTOZVdxwJUATEIjLZNzDlDiMSyCqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mwDuvD8B; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7cfd5d34817so3198650a34.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866015; x=1769470815; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8auGIz9rpLAlTb9LV7N2WX+TwTyGKi6f9JrK1603mZg=;
        b=mwDuvD8BBLYIwfK7aRd7cBtlp956dutLFsat4KVz4keZHNONOawIJI0MG04fRhkuwy
         +2hV7oyCUmS/bYoICz3FyVhKQuj7RqQBTJfUzLVWZ6kVcRVlr2mkGMX2Hz5MoN/ExsSX
         6ljApE8ZFhsYVxFGOexbrKSEzUxjcbWLojHpbyaPuqIt0ciqRieYY5WjPHmPvphIx6+3
         E6ojyqE362rjJjROOhs4OmKnayzc/uf5bP12s2hDjJIwW9m3fjvQa/KAn6zs3cKgHQTZ
         uWnQoaCtZ1NVcF0q7o6H1UIrptrYSs1B1zC+43UYGC2L1IMlrfjOzA7HVzawOL/EFp7F
         d6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866015; x=1769470815;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8auGIz9rpLAlTb9LV7N2WX+TwTyGKi6f9JrK1603mZg=;
        b=KV1ogKpFJ7LNApY/Esxq2fMSrj336fJGsaS4ECC3MYk+5jml1qO7fcupQun6ELcg2L
         ng3mlCcKpvwga8fLeqy39xpUrLa5X8sq5uOhi/SqgCFYd4JgIJpcyG+NruwrIN2cCejV
         xqJdWqyFdyjVl6j6ZNQcYBfy+uXt6y62hA4rhjoDBb5TUmG45ENzjPLZyrMEyOs+3PbV
         Df9k6eLXL2O2jigW8iimxufDB1xqRulEBLr+GQ506GuQdJzTn9tCSvGDUb1EyoZIVmC9
         F0Jem3hieJLbSl0UC+q2GgtDpj+78q2nJvb2R5AQiPoqS5v489mZExGTwYYdcgcJjs6e
         FsUg==
X-Forwarded-Encrypted: i=1; AJvYcCUVOlKyMASA6bI8dORAQar6DzFCrrps2xlw11wieXy2SLkAE0JlGknv3ktiUWRJBwQaxOtCYmRiUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZO6HaDdb/C+4R2ae/OewDiRBotgb8E278p6/vgnfppdxOr/wR
	rVIUJlP8fk5rMb6WHUtZSwSMPF0iIPLdNjApZKfhjOJPEbLgVuCxFV7jK3O1SVN0+r1ao/impx8
	D7SbT+jI=
X-Gm-Gg: AY/fxX6L/0W5k1eLeyvHqYzoy39vs7ADXmpDdu2272oCrcmsONTBknApE1vSKu9WO06
	5fai9F2IzMeuHtaOXwWwDiwr8maZY57x62Q0IwEF93aaKWPuYEfoZDY4IZTjwD58A7t+BhVJrmQ
	v6Z+nT2OzTn8+UtWHsl11GKlsrp+Ns418/Ph8PbDX8usYz95221hvaJ49saQS2v+uhn1AT/xv4m
	CBHVrjfTLzCZ0k1gpCsWnIRaMbFUXER/sWndsPNnfCYLC4WzU6dXn2aS6+kE1xGfMUbAVm5mHE2
	oloIOVCE8Cr8gSqMRwnARm7uI8ffwF9MVEINEWtVQJuqeKD9W60nJL7jzldCLlxFkMZ7cr/KuJQ
	+fvDBEGig6xkGgokMlwuGNOHaFrJgxoiWMcNOsvua3bSEcAyuQS540vxMw0ak0pd8Zq7GTPuakH
	Y4BhPJMtWGCklGWKvngpU7TRARaNPnXW9O4KYJgn0C0qCXpzAxZqf6fyXu4boixA41JheDkQ==
X-Received: by 2002:a05:6830:380e:b0:7c6:8bfe:f5e with SMTP id 46e09a7af769-7cfe01c652emr6188480a34.32.1768866015139;
        Mon, 19 Jan 2026 15:40:15 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf28ef44sm7571251a34.18.2026.01.19.15.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 15:40:14 -0800 (PST)
Message-ID: <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
Date: Mon, 19 Jan 2026 16:40:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Yuhao Jiang <danisjiang@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/19/26 4:34 PM, Yuhao Jiang wrote:
> On Mon, Jan 19, 2026 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
>>> The trade-off is that memory accounting may be overestimated when
>>> multiple buffers share compound pages, but this is safe and prevents
>>> the security issue.
>>
>> I'd be worried that this would break existing setups. We obviously need
>> to get the unmap accounting correct, but in terms of practicality, any
>> user of registered buffers will have had to bump distro limits manually
>> anyway, and in that case it's usually just set very high. Otherwise
>> there's very little you can do with it.
>>
>> How about something else entirely - just track the accounted pages on
>> the side. If we ref those, then we can ensure that if a huge page is
>> accounted, it's only unaccounted when all existing "users" of it have
>> gone away. That means if you drop parts of it, it'll remain accounted.
>>
>> Something totally untested like the below... Yes it's not a trivial
>> amount of code, but it is actually fairly trivial code.
> 
> Thanks, this approach makes sense. I'll send a v3 based on this.

Great, thanks! I think the key is tracking this on the side, and then
a ref to tell when it's safe to unaccount it. The rest is just
implementation details.

-- 
Jens Axboe


