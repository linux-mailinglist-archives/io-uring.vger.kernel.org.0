Return-Path: <io-uring+bounces-10545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AB5C544AA
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 20:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D47B14FF9CD
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 19:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4DA212F98;
	Wed, 12 Nov 2025 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ukysbo/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92827E07E
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762976045; cv=none; b=NV2vSakQP/4ptY2LCZ6qy44OhLmDf9nuiyS2+wzpoqok+KVeQ3AnoRrT0EPdj50V+/g9z73Z3W5Pjol3res1Qqx1ZGUlSGK3YzBNtYY83pt57sE+n+98RuKDYLoQbLSx+JXMqzHfMPRicxseVfp2W6cMm/3j/7rtd2R+eC+SHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762976045; c=relaxed/simple;
	bh=VB1yNAC6xes8L85n1r2Yg3uabvlzArRcT8goMrtcsdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=indN50HUC50E3gxBFaBEdFY9RSvCMBIaP9CrWw60TP2fclEZCdwHnD2dYnjydb3a/VYTLwdRfb9RPjqg41O+ClGPW9kzUNkHawfYVtacB28jNtLPCnEkpiDJlJzWdmtNVLxL7PaSXAihxP2Wa6+6+0B5WEJRZa6M+EaRW1k78lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ukysbo/Y; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-948a023a8f4so2963939f.1
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 11:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762976040; x=1763580840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4eMd+XPlQTOSEnI/02oQRtyFxaHkopUP7FiN85S5sDM=;
        b=Ukysbo/YXYgerPtWaIku5K3vTtz6nlnap9N3LWLp5ks1Ncvo/HEOkCuUWp9GLI7ES6
         EBFZJ7Kd1HICtaz6I0tpR9iXd/ZXXRoORVCiL4FLTrbtN00EQ/WMGODR7UOARcBLI+mQ
         VPUBCxo78wJlACO+8K/pN//c92fjVFYs4Bl41bSMKMniznAPNhfnHniQ40g33WNlUmRZ
         kQ1RgO99rIdHWBwY/fUhqGkUOzRVfP8/iuBKOxdG8KtI2qZMjrLpdIqH/rmGTRkS6DXB
         frsZQW091Ctxm6x/6odIatZwjZ4RF1v2eJFwuAIYfOjIJ38Sb8a7SQjAiKdXU9VQGtoG
         7u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762976040; x=1763580840;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4eMd+XPlQTOSEnI/02oQRtyFxaHkopUP7FiN85S5sDM=;
        b=Rlp1+kiKQZUG5WQVWLPex7vZa3xZ+uVN4BciZrjvCI0Yb921RLc7CDICy7JD1eU8IE
         fDIuWEixVLto56Tc+53rXBXVCQbCbs/Wsmp+UO6QIzbDorPYdb5ry4YGRr6HApGCRNpF
         Yh1TcYvnf49vaWQJWabxvKq6Pt/h+ejlgIkQJmcU+S5I5IuSWbxBQGlN6E2XZWfV5U6c
         UuJPudJxdbabmwNXi6Td4OzgefP9Ktyd/Oh1BmRMH5xOtiFFUd9vLmnJtTd+XmHreBOL
         5FXvthDirycYlcu3FGYVQ3yvFC78AcCDpSqrUKemb2rkYQnNZXjyxMNPt3DxDZWPhGcN
         Lqcw==
X-Forwarded-Encrypted: i=1; AJvYcCUowkaifhc0s4KmYhElphFyNXp+56rYFbCF4klJsq/V/Y8gRsgSSA4o2TFcI2vA3noxYFykg/3mvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCUoPRnC1ScqroyDSQLgcXakf/r7LMjV2jOt4MY/yw1fAumdu5
	AyL8yhO4kKK4bNkoYviVLuKFm+Hd3bRM9f/9F250RSnvQhNV4Vr/lQC7QTSueykS/foTrP11lwc
	yPkat
X-Gm-Gg: ASbGncuoe5QKxxfj47dbc+Bq5IVJPDm9382sdr2/N8bqr+Qb2B9Vc1cyPQOA/SQx3Is
	8tKiAxZR60x+0/H5VuTE5nNiDYXFtx/09DwAjNKQDY9gteKGYZvdgizYoxczH0kOfUtbn4gDfHJ
	wsMU4bFOcz/sl9BR+hzqOgncHgtf2q+e7aWRpYstrk3SwFXD9IyQaSylBHNBYm15oCzquTytJkE
	Le0m+c8rX90yjYqIX0EgB2+0A33vek45PZu7GovAGs8FTr+jo3pptrSbzhi8S5dG8QetfHKsLWe
	3+IjemM3PHFShx/2Tlle7/r3IG3TpCcazI1HhgWARvEfil+/PZ2ANZWUeOGZsMOH2X3q3fTWky1
	HhfxZ9Sw/XWHBpHCb6FT0M1gNmxOfVISruJrodQQ9NLp8pSttkB+FJ4E/v3I+UEGIZivWflKF
X-Google-Smtp-Source: AGHT+IFKrf3iO+ZbOX0XnTUFjt/X/9kDuGQmwRT9IUDOemLQ6OoKoQtoDzKC8SsRViSdMu+a/KGqIw==
X-Received: by 2002:a05:6e02:3e89:b0:433:6943:6c70 with SMTP id e9e14a558f8ab-43473da486fmr53554925ab.16.1762976040283;
        Wed, 12 Nov 2025 11:34:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-434733a3854sm13564535ab.34.2025.11.12.11.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 11:33:59 -0800 (PST)
Message-ID: <d1f1392e-c14a-47a7-83c1-e9f9e0f3b852@kernel.dk>
Date: Wed, 12 Nov 2025 12:33:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] further ring init cleanups
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1762947814.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/25 5:45 AM, Pavel Begunkov wrote:
> There are several goals for this patch set. It deduplicates ring size and
> offset calculations between ring setup and resizing. It moves most of
> verification earlier before any allocations, which usually means simpler
> error handling. And it keeps the logic localised instead of spreading it
> across the file.
> 
> Pavel Begunkov (7):
>   io_uring: refactor rings_size nosqarray handling
>   io_uring: use size_add helpers for ring offsets
>   io_uring: convert params to pointer in ring reisze
>   io_uring: introduce struct io_ctx_config
>   io_uring: keep ring laoyut in a structure
>   io_uring: pre-calculate scq layout
>   io_uring: move cq/sq user offset init around
> 
>  io_uring/io_uring.c | 137 ++++++++++++++++++++++++--------------------
>  io_uring/io_uring.h |  19 +++++-
>  io_uring/register.c |  65 +++++++++------------
>  3 files changed, 119 insertions(+), 102 deletions(-)

All looks pretty straightforward to me. I'm going to let it simmer for a
day or so to give other folks a chance to take a look too.

-- 
Jens Axboe

