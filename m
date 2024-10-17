Return-Path: <io-uring+bounces-3799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ECD29A3108
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 00:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 282AEB22AEF
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 22:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6391D7986;
	Thu, 17 Oct 2024 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0jhMNAoX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F241D958F
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729205486; cv=none; b=uIuIefsBooOOtHXxITHCe0Go56UmLkn3uKftevzt9f2ltx00wgx99p1Wx0wvKKNUfyMIWhVThN7WwTEh+Vthw8DKbbDgu2L1Z1nGFsJhYXuBBQA7IDAOFrAqU/+lasl/YOrFtIL22Ye8Vpv8E2GXztdYlpr5l4ip62PJ4xs6fI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729205486; c=relaxed/simple;
	bh=F6+p/UVIJr1f2Whg0Y2sN0nuRYlxV0q1v5Rz+NEfs/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=axEUHAn3DPT0j+IrPBRIPbrYFemAIlEZPyKWRfYIA1vnDSSn5AtMjzX7Z4hRuEeDK6/zJyFcM3VOX3nsh+31Eb/b6wFjl6ZVNQmfoSgcOIVuCW0vHoNyPdYUjCmHkKEU+xODwR+1azE/uhgnMhqsbNPOD687LFmCkhCe9yPsjmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0jhMNAoX; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71e57d89ffaso1156311b3a.1
        for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 15:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729205483; x=1729810283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+mw4EAmgbxRff1MICbmhx606Y0hdnGoOtoskp9RHouA=;
        b=0jhMNAoX2K8BlmnnQYbpF0nTmSEpMHhCsW0FIzrrrDRFDXhNF1SgQsYB+LJLeQg5iy
         4nZl/9LtrkggHx6YMBPDy0Rz1qAULIPm5NajSfY9s5y1jh9VwtimUY52GBXmUygKabNs
         LT9jtUOxx6PdE8v0Ee1X/4ge32hctElnKMFEN5k8LOnkEVN4smcwdqH9Oz2JvMkL3GnP
         58LSSJdIm5bC1tG9l4TBDRyDJ78b1DfcFDxit1ESPDe+OyCV7VzBDpxiWXR6LDa1zhKf
         81fByw0Y/VibHKYV7FMuyLTKPK4lPFs2M27nonx8ibHmLfI5XEtAgIqktIlaf7oSBhGP
         TTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729205483; x=1729810283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mw4EAmgbxRff1MICbmhx606Y0hdnGoOtoskp9RHouA=;
        b=srI5zoh+yLnJLzrlzFSeV7g1IW6VbkLBL3nl08W6KbVg3gh327r38zxWnpwCIYhmuA
         B7p4ivadNPaidkOC7GgljyBcJ2lunfLdFEkkFYaYDc7t6JpXpGbvcIdCcDZKh+1wqnP7
         MuLMdmjGuHlDPDQ7qd1cP55VfRwe9AljZgjZbAK9l59CJxzA0BEkvHRrQkz4Tj7IjwGq
         3Bkf6c98Cd4PPbjLTbmnpDiNus0hLorFZr/uOFiFLLaP3JA4u1E1BHsLPzBDvBYOa4IT
         enOGCOVAkIbKxX+S++OE4Azm0IQAIYblhGbETOKmQxqUwTdEmQE3IRkV2k7iV1cgBZd9
         ffOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeK82wl03DZDJC0FnhK6cnaQaQLwLC4XpLub0EMqxtgMlyDg7BsxgoipZ2TbUoM5Nraa0JpJ8U2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyG0xawgYm6gbfKVtzqst6TZAl1Op8HUFA+RGgsJYCeCOzczAZ1
	QNO/zsBBhKWTz6/A3ucvhKg07UTX5v0siH4KNtaKftBncs64pzGHoQZzfe1xhXc=
X-Google-Smtp-Source: AGHT+IElS3afcGyUGmbCSqMvboNjMAF5io0kozg4OeEcMlWoHPb2GAlJ9GXegxQOyjitJa1uX8Kthw==
X-Received: by 2002:a05:6a00:22c4:b0:71e:8046:2728 with SMTP id d2e1a72fcca58-71ea330863bmr671978b3a.17.1729205483507;
        Thu, 17 Oct 2024 15:51:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ea333efcdsm183159b3a.76.2024.10.17.15.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 15:51:22 -0700 (PDT)
Message-ID: <86072e08-bac5-4a4f-9c76-8b1eb53ea8a2@kernel.dk>
Date: Thu, 17 Oct 2024 16:51:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] io_uring/rw: add support to send meta along with
 read/write
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: kbusch@kernel.org, martin.petersen@oracle.com, asml.silence@gmail.com,
 anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 Kanchan Joshi <joshi.k@samsung.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
 <CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com>
 <20241016112912.63542-8-anuj20.g@samsung.com> <20241017081057.GA27241@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241017081057.GA27241@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/24 2:10 AM, Christoph Hellwig wrote:
> s/meta/metadata/ in the subject.
> 
>> +	const struct io_uring_meta *md = (struct io_uring_meta *)sqe->big_sqe_cmd;
> 
> Overly long line.

That's fine in io_uring, I prefer slightly longer lines rather than needlessly
breaking them up.

-- 
Jens Axboe


