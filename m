Return-Path: <io-uring+bounces-459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC088393BF
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22F101F22643
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3BE60DEF;
	Tue, 23 Jan 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oQIeXqjJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9E5FF0D
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024776; cv=none; b=S4N64wBvdfsaBzhaKYOjWGZcfi/hHa579NZiIjvMRPGo0Xnekyxaz5/A1L0qDIomBW8ARcxtflAgrQhTSn4IAYP4C9Kb+aSQmppK495uQCLqc49eMsW8esIx6N7rcL6BHs/I144kFlp1ayTZ8T13O0kb3nFBr0yK+ZerAcqn+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024776; c=relaxed/simple;
	bh=YzvZraO8rw0kFBrSL8/BsueWllTfD6wK6AyCtr6feqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K41VW276VPE9SQ+GgYbWeU14H84o8VPKg+pMwEzbLBVISBVsWyYLbpX/oN3ZfGDnv9YzsKFh4biSixWyuv4m6q1JabsICL9h3RghFBIaMP0B+v/KQyMK0VR60a88xmdrl2LR6z9OWXAKGPCbK+2zsjs1IUxfNuQYtSFDor/GYJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oQIeXqjJ; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7bee01886baso55525939f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 07:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706024773; x=1706629573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XN1rHQqby4DtyPh+BAvIGUb5SSQWMMne5XdiciAWWgg=;
        b=oQIeXqjJDzLz/zoZOtmzjbSJU7T5O5M4b0dk+HUCO7ZyeGv4F6lHjwRkcS24RdtU/M
         irogvNShRnArjAPHwZWMmNS7xIAdlCKs5/XNtheNfumebklAcdHDlCYquLeXFGgotCwZ
         APw2d24VB/4t/HsPKetsG+GjbYFSdiCsijJka4eiDURfx2ugaTdC4+T70w7ieTFtt/0k
         IdSQQ0Ss9CZPYGIO1gJnDHaNkUVCLSkiUlpns7Vv1wUlmWLFTwdnmjIehNAtxao5Zdi+
         O9ZDxOhXO4oDQJWd4voncy39VKC5dN+B7RPC1AegEpj6hhgiqSBoOehtEulfqU+iyVxV
         Lplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024773; x=1706629573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XN1rHQqby4DtyPh+BAvIGUb5SSQWMMne5XdiciAWWgg=;
        b=Wrach8IS7+2tCBMSNFAMAsehgFuAc3GeYh+uYM3h7B123Jpsn3H5tWZ1zPruswkGSi
         obkQnd6vX90cZatfrOCE1Se1vreaSBrDHgxucm9aXJJayvCeUUrB22BxijuSlq5gRK9B
         F0Q8ByW3DzwSaw+hbr/8gcZNkluVe2pJVi4nTIabw691Ke/vTU7UvAkxj/699JU3465P
         pLTfv6uwFy0g+DAKO8zEr7flW979jZCcMHCpj8ItKV9a7i/EIZeG/yI2d3wfJKW/Nw0j
         wlq6Jhg572pvIaTWLc5eUwGsScjVVr1VUAH3QpV6Lk6x1i5IpmlHf1kTL2YFuC+9qaD2
         LDaQ==
X-Gm-Message-State: AOJu0YwF6wPq7AjX6JM7A6R7cnH+QanB6LLtMMXkX1nNj9nU2Dzbzz2D
	qdlLRrkKbE5LabOOR1gUW70Dx80MVvifSKyDeviZzRkarsLJ7u8yYIUo458Ypds=
X-Google-Smtp-Source: AGHT+IGU1Ly5rX8oO3nd+ATfhXovMTQdaxJcqGK7A68SV/cLW5APhbT3HCpUlVVtQqYhsYqu1EbhHQ==
X-Received: by 2002:a5d:9304:0:b0:7be:e376:fc44 with SMTP id l4-20020a5d9304000000b007bee376fc44mr9195445ion.2.1706024773551;
        Tue, 23 Jan 2024 07:46:13 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w35-20020a05663837a300b0046eeb10f1fesm971247jal.110.2024.01.23.07.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:46:12 -0800 (PST)
Message-ID: <a144ef71-fc6a-4fa4-b5ab-b3fe3a974645@kernel.dk>
Date: Tue, 23 Jan 2024 08:46:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
 <20240123113333.79503-2-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123113333.79503-2-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 4:33 AM, Tony Solomonik wrote:
> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +	int ret;
> +
> +	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> +
> +	ret = __do_ftruncate(req->file, ft->len, 1);

Should this not pass 0 at the end for small == 0, as this variant should
be 64-bit clean from the get-go?

Another thing to add to the test case, create a large sparse file that
is eg 8G and truncate it to 6G. That would catch an issue with that.

-- 
Jens Axboe


