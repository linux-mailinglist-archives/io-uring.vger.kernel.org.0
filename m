Return-Path: <io-uring+bounces-482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C05E683AA52
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 13:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FA5E28A6CC
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 12:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645647763C;
	Wed, 24 Jan 2024 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oJ+RSQzQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE4860DEC
	for <io-uring@vger.kernel.org>; Wed, 24 Jan 2024 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706100749; cv=none; b=K3BNfgTp7sZfxUcw+fNL3EIWUB98mX1zUGr1XVMHBWjN3DrerpuZhMt1nwqvrGnAkX3lIvcGKQyzSWxB0uQ4t2jLY/pknj1XjXOl4VXe9cS92QjVVaOHWnkgIs3/FT9a6ZwFkLzIE2Yy05+ogm9wbp+n6qE1+Dad0S2tkI2PVk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706100749; c=relaxed/simple;
	bh=u87dgtOCnG858+2RLEm/eNuMK0BlwRijmTEReSQrCk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qs2ujSzp7mpludDuieFu+4n1irY3LU43amI5ld3tdecH7xJb9vFf9vUx7G5ZDbZvRwgCB+tO3fAWfeWvdpAu9W0K9e/T09K6D55snz9KwZ524QKRinGSq9iOBanWdhW1KmPtEPn9au56AUufPDiOBr3wTXrohK4TBUr//6ifYm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oJ+RSQzQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5992a529b66so856096eaf.0
        for <io-uring@vger.kernel.org>; Wed, 24 Jan 2024 04:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706100746; x=1706705546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RcSqh3U6uVN9tud0FaGQjxIaTxF3VYfhi3DfVDRmK/E=;
        b=oJ+RSQzQkC5D5Khb+wfZ7ugSP+IrJ2M4QfpGvrzmsObZWHQepayJg91ms388p+APHM
         vfB/UaCRoUh9IeXvMLXNDC+asyuyQ7N1ch5ODk+IyX/XtAsYdR/HTy6EgwIV/tuSmOXZ
         eE2IBjjPPXXbQ37z/RwkAVLStekEQ2XGZn59SKeB01TExfXCVDw/mIFQ9ftgCrnMy+K9
         tbS+kGfuNYh+G5n6o4/DOUHWfOkdeqODwX9BXjEJy7q0Djq6ePHDJnP4/O6zsg8cdlgD
         LmDdxrA5lsJ4o71oe9xNrjIFgMJo8tKoWurNmmNUEaNmFv6ytEd/O5ogHAb/YZ9TTVnr
         KmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706100746; x=1706705546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RcSqh3U6uVN9tud0FaGQjxIaTxF3VYfhi3DfVDRmK/E=;
        b=UfPW2V4tWpCpKTChQLh7gMY1oA4uhLfWO5zBRy5B3uLSd2VkNxbJoz49gIcXBYWBnS
         pAg6rdecWZyDQNGCI87ZERVx/az/EsOLdg6U+zxVYZ5GKbN1ZkIu8woyPkzUcA7qjxxx
         6tHDpMrdogBriXlukcCTUrZQNCULCdIVYkOGxgqlXJ+UNB6aylYLxwTAyEIGvJWi8gL0
         HvM0357tzVKmcym0yJ6SNsmvDmrdx7WB94MnO89h1/YqJ50eukvTy+EKzx8GzV2HfRVk
         FExFmmhGdaFIQbEmCFFouCijo8d9QMWC4RyoORtIkd019Vq1d8lfXBta3lcgH+XJ3Xs0
         cK8A==
X-Gm-Message-State: AOJu0YyJt1qyzGS+SRKc9o1qitZh1spy+Wd0137zw6+5dToMQC0wb4Fl
	+tdeSVnqbG5l446uOL5lRxXe6qeedjdl+Fpx3ihCKl92oy1hNRYypwDPgVbIeCA=
X-Google-Smtp-Source: AGHT+IEV9XPoTij4w6t/c3jamgPJzwbW0uxPDvd2LhSt/JNYV5z6Ri6q0YWVg7VwoBycESUWkXZj8w==
X-Received: by 2002:a05:6358:e48f:b0:176:6189:de7e with SMTP id by15-20020a056358e48f00b001766189de7emr2503685rwb.3.1706100745748;
        Wed, 24 Jan 2024 04:52:25 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h20-20020a635314000000b005d4156b3ea2sm2108542pgb.93.2024.01.24.04.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 04:52:25 -0800 (PST)
Message-ID: <fefaf2bf-64b7-4992-bd99-5f322c189e35@kernel.dk>
Date: Wed, 24 Jan 2024 05:52:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Cedric Blancher <cedric.blancher@gmail.com>,
 Tony Solomonik <tony.solomonik@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
 <CALXu0UdfZm-UJcPqF5H6+PXPp=DC2SA-QFbB-aVywmMT5X3A6g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CALXu0UdfZm-UJcPqF5H6+PXPp=DC2SA-QFbB-aVywmMT5X3A6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/24/24 1:52 AM, Cedric Blancher wrote:
> On Wed, 24 Jan 2024 at 09:33, Tony Solomonik <tony.solomonik@gmail.com> wrote:
>>
>> This patch adds support for doing truncate through io_uring, eliminating
>> the need for applications to roll their own thread pool or offload
>> mechanism to be able to do non-blocking truncates.
>>
>> Tony Solomonik (2):
>>   Add ftruncate_file that truncates a struct file
>>   io_uring: add support for ftruncate
>>
>>  fs/internal.h                 |  1 +
>>  fs/open.c                     | 53 ++++++++++++++++++-----------------
>>  include/uapi/linux/io_uring.h |  1 +
>>  io_uring/Makefile             |  2 +-
>>  io_uring/opdef.c              | 10 +++++++
>>  io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
>>  io_uring/truncate.h           |  4 +++
>>  7 files changed, 93 insertions(+), 26 deletions(-)
>>  create mode 100644 io_uring/truncate.c
>>  create mode 100644 io_uring/truncate.h
>>
>>
>> base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
> 
> Also fallocate() to punch holes, aka sparse files, must be implemented

fallocate has been supported for years.

-- 
Jens Axboe


