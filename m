Return-Path: <io-uring+bounces-10064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E80F3BF206B
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B2C40521C
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 15:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FED82472A8;
	Mon, 20 Oct 2025 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v9y2Wxxc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0362923D7D4
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760973162; cv=none; b=JQG389CMseU4ex3NWJ0sUw5wQ4DukJXfxOKmatc0LPrkIdeI7ANITSq0R1WL665ddrffJmQ3O9NXUyaNHrD4qmHYxv02p3Ybi3P2ipZiw6Hhk8+0h72wtWcM87S7/w6/5V1whbAocpqi3oAr7nQq1XwkK0tRWV0Thx6Pqvrtyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760973162; c=relaxed/simple;
	bh=o/WXo1AwVxAasCxfTqGZfee5TnP+SejYoVO/FHBNe7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsR2BPXYvbV9rmM8qgFTP68ClceQhxUcB53iXx2hKDh2yUKKmC5CkviZltkfH/u5YZWPo+I+nXWw4NL+gmsrqFCZ7rYsQL3egjNMc48w6xVIqibcPf4kxuToX8aWk+wJx8JoiNzSbvUtfu3aDEA67fNwcRslgr1WSKi8JTzPPr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v9y2Wxxc; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-430b45ba0e4so19905265ab.1
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 08:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760973157; x=1761577957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jb3EMCuGZdGviJFLLgQe3oeYSU3LFd1sZoiqv3u/0q8=;
        b=v9y2WxxcgdPkWkcDNj9D22IgcVuXWUuBN2QshIDPQWj/3azuegdOgmxJVHwJYqOLK+
         bhuRh4orYaSMWSi4YUdmMCgELipnyj8sO9nHT+6G/NDPVOgkxgbCTQSndYghq+yBIHSy
         yiJGziD0AYpFLy49iJBvS7k9CL800RnDmPUFoLWNbVs6+kpCLyek3hrJEj/vsBQjIB1C
         Hh4bV/5DI8WfWufs3IJuhtE9y1w0VRpnsijoNHBhdR9Y6lV2j3/SL4T37s1rI1TKngwf
         ATgHZwmHyUesJbgq/zemTAaFBEPZfBrTiDBJ1n82Z9CsM/XsozaRysEUmyso+XdfCb0O
         hlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760973157; x=1761577957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jb3EMCuGZdGviJFLLgQe3oeYSU3LFd1sZoiqv3u/0q8=;
        b=Rnl2QfStjoL7dbWtQG7YnwrNEwGEZnHj/UuHVfH2TUu/g52v6nNhkdsZaRqN0ndCUx
         IVQZ9bMX3XgHDiPAQoTj7Nbh+BM63OBl8ZLRTR5t3XDjpGFeY6KbCwj7TWqD8aUJ3ZRk
         iMXKr4CxF+LUGi3e9tMD6DW45PDFA3YaQgsJC5QTUrwuq1os4PzfOT6erysFHw7cJYdD
         Ix5pWhbwddKWCNQmp5HQBkNayizL1P2G9od564ahkCPtHIJCfXKSnd/SrfyZxomflONL
         qfPpGdWUqoyWtHhnE9v35Y9bVnvNl7K8YkeoqnI1c2f0Z1+VdXm/6m+wfEs8T3rW8mfK
         j65w==
X-Forwarded-Encrypted: i=1; AJvYcCXhZ8jmLV6683JJnbwxt8t80wAchNhSN4dk3V9FXvyzRfJ6uEEJYETOqzgzpvCVeXhalarLmMfxGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxqK6XlQnRI8s0Ku/3Hds8+feO6G7YlIrGH2lwYGpfYTK70w4B
	tslbzByP20+BVoSiHOzIhUMNuYpy1Ds6NY0r67WYWKdvS6CMdcL5pqXxF33ODQ7eKN0=
X-Gm-Gg: ASbGnct81VgHzbn73WgJpBTpZinmwMW7lkVAcxzsMwTbz/PZ9j/OoVqk4Ly+L0+wTZq
	O5cVXN/pgNG5i7R3DXZmoK+MXwWsRWz/7Ju2WVj/rVfGQORdUAlSRTUV8h/tqfwW58DMgYjeegB
	CIkaJdw8LAawV4HZUXDQGXFv55eU4yyncsfRT1+LX5Ag9RqKWxTm9OAUkJiuSw8HswBtvmHYXLT
	HTv+4o9xteqjYt2Vhv+1p2lXYn0C3vq5wvdPzWvZTLpfCAjMbk40WvCaMbth8ndi+GGQnnawrmJ
	i6A7tNm8dslR5gENOUJj+7fdDM1hF5O5640XU3Zj6bucvpkkZwZbilbvWx9EvbDZCdR7F49sSfk
	Fl1UjK17L3tF1nVuHVFStbUE6WPNqc24j+SE9+mJoIt3mD8el78pyyoQLqCGgj33lDnM7uP1B
X-Google-Smtp-Source: AGHT+IE22rNafzorZNPyruMi0QV8ZbbeCArb1xzhhCvTr8HHITqql03cttgZFQPpox5KUZcR/+05oQ==
X-Received: by 2002:a05:6e02:2511:b0:42e:7a9d:f5ee with SMTP id e9e14a558f8ab-430c527d3f0mr202894955ab.15.1760973157412;
        Mon, 20 Oct 2025 08:12:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9768b98sm3013871173.46.2025.10.20.08.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 08:12:36 -0700 (PDT)
Message-ID: <8ac97b77-4423-41cf-a1f3-99d93ac65f9d@kernel.dk>
Date: Mon, 20 Oct 2025 09:12:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_SETUP_SQTHREAD_STATS flag to
 enable sqthread stats collection
To: Fengnan Chang <changfengnan@bytedance.com>, xiaobing.li@samsung.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org
Cc: Diangang Li <lidiangang@bytedance.com>
References: <20251020113031.2135-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251020113031.2135-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/20/25 5:30 AM, Fengnan Chang wrote:
> In previous versions, getrusage was always called in sqrthread
> to count work time, but this could incur some overhead.
> This patch turn off stats by default, and introduces a new flag
> IORING_SETUP_SQTHREAD_STATS that allows user to enable the
> collection of statistics in the sqthread.
> 
> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
> IOPS base: 570K, patch: 590K
> 
> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
> IOPS base: 826K, patch: 889K

That's a crazy amount of overhead indeed. I'm assuming this is
because the task has lots of threads? And/or going through the retry
a lot? Might make more sense to have a cheaper and more rough
getrusage() instead? All we really use is ru_stime.{tv_sec,tv_nsec}.
Should it be using RUSAGE_THREAD? Correct me if I'm wrong, but using
PTHREAD_SELF actually seems wrong as-is.

In any case, I don't think a setup flag is the right choice here. That
space is fairly limited, and SQPOLL is also a bit of an esoteric
feature. Hence not sure a setup flag is the right approach. Would
probably make more sense to have a REGISTER opcode to get/set various
features like this, I'm sure it's not the last thing like this we'll run
into. But as mentioned, I do think just having a more light weight
getrusage would perhaps be prudent.

-- 
Jens Axboe

