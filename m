Return-Path: <io-uring+bounces-5728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F4BA0429B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C733161137
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 14:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293871E131B;
	Tue,  7 Jan 2025 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CzDjCrZO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778152940F
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736260351; cv=none; b=YN3pBCClGd+zIUgrp+UYPfImGHitJGUww/lFxBtk+sQz5zWYUrd+h1LxawZJV+ug8tiSZj/b6gvliWDJ4YmPHPpNawk3JVlRyqcIMRBsZvylI1iTCm/wmJ6TH/G50srz2W2Amoc2aI12T9k+y7PY0yy1ULjVs8KKBHTkrl3cHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736260351; c=relaxed/simple;
	bh=hJneiDjDMgTQcL838+5qJIxPMw7HvUEH5mnf09NuzBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UQEoPqrB+f8Hmj1cqwXiJ7DoBvXEOPozen/jgM6XZGzbTX+sHV/cdbrqxr6HEj5AMd9FY3qAJyUQzAGdoWtZS6ewGCauIYUuxRrzihAC3ovhC784zBVrS+Oy1thMEI/LaiAskZTPNtyILAmt6seWKD9JCRkZ8DgR2og1W4ksRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CzDjCrZO; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-844d5444b3dso590321239f.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 06:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736260347; x=1736865147; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPcN8d2I/iCmqp1AscGx7152N/qGhMDr9UQFfGA8QFI=;
        b=CzDjCrZOyoYsCpRjYw8GTPXkb8gAfF3mECBcTHQigtFHe7tKSP4rw4QjTqbXzzgVl4
         l2FEAbfkrXymJ+4YOacaCqln9wMQ3Z7fWxOOzds6CqHM2uQrzi0PF/F5YjaaAv/O/nV8
         ZMvN5cBkWwZHLND/+HFGlosB+N9/mE6sGR1/uLf1duR79fEBeh8fiXGroU0wJsACRVUd
         vprVT0dqTfS5SknZRhLQuIQdk9fPZv4SMbVG6StE9KDoGhVgdHU43HWr+bhrMamFNJ/Y
         2F1Oau62JLfSsY/rmCLNcAb/F8uztitDFBTMc4T3QN9mzUb8NGqlqDj7E9BtFkbrDTEp
         PIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736260347; x=1736865147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPcN8d2I/iCmqp1AscGx7152N/qGhMDr9UQFfGA8QFI=;
        b=YBgX63M0OHexrlDBCi/HGBhxjsj+zehAxWEoJO/jPsQHhGC+yB7ukVkX7AJjVPV/F3
         Al+fTPGSsk6dJWn09tKT3Gcf0Fsyzys1tus8HkbHL5FNG+Hz6paArAfLkTqRzRVukagN
         mb+ewmtxIg/Pij8Sq5IyE84QckgsJOSi1kb09HvAYEgzsI8sy1kSk6RGkEkswK0FqWBa
         cqU2zLvz0LlddSxrSZ3ku5beA+KQJSugdbjPgoeemsrVpoJaRWzo/LY9mLBv9sNeGr4Y
         tc4v1Ge8pgoInQ3iJHBQxPVJP/4ccYzyefFoW4jsf14mY8SBsLnyoRWwdoIvaUiRaynG
         QFjw==
X-Forwarded-Encrypted: i=1; AJvYcCUkQDVcjJ4w2FleymdmOUv5uk3xfbDbOEPjQGKP/BMuMiuxqZRVpxvbk5ee9A9EPMYAk8Xb/jYAVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxecOWrhvn/BmLlWvxfvM/ZdKDBrvf5J3IDQdcuBN9LQvJupiyK
	w31GGkrlv75FdUWVFpaqo+mWr7jFfvHQRQ+phPpTauLIGQ8jD7VVMMYFNQt2CNc=
X-Gm-Gg: ASbGncuBY1EmlGxzx/x/5aOSKDFDrkCQjcAjbJvMGwQyInuFExjeIEaHP5+teAaja/4
	VWbUcL/GPlmy3wQrrsdrKPfM8Lu/GvZUXY6GwrBkChUhwLZVXDSemA4Th75XkAK66wRudl2fhnZ
	kkIU+KebDZmFFaPzYOkjm0+7tjuqqPh+mmFU1Sbed0oaELcvsnMF5FXSEdqplZNu2sfnzTScqUx
	zrScbX+nAh6ANNc47r1VtDpAYrPbMfEtGaDffiZyb/efiAhm5zP
X-Google-Smtp-Source: AGHT+IGe/lXj5gyiWqbp6rP9b14lFc64wN53iEHxB9kz1N05/nd8fd0SZZ+4eJ7ot3k2UB9OtLLing==
X-Received: by 2002:a05:6602:7519:b0:844:2ef3:a95a with SMTP id ca18e2360f4ac-84cd2e8318amr264273339f.7.1736260296161;
        Tue, 07 Jan 2025 06:31:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d7dd8c4sm924819639f.12.2025.01.07.06.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 06:31:35 -0800 (PST)
Message-ID: <66a3fab2-dc5d-4a59-96a0-3e85c69fad03@kernel.dk>
Date: Tue, 7 Jan 2025 07:31:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: reissue only from the same task
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e769b0d12b3c70861c2144b3ea58d3f08d542bbc.1736259071.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e769b0d12b3c70861c2144b3ea58d3f08d542bbc.1736259071.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 7:11 AM, Pavel Begunkov wrote:
> io_rw_should_reissue() tries to propagate EAGAIN back to io_uring when
> happens off the submission path, which is when it's staying within the
> same task, and so thread group checks don't make much sense.

Since there's the nvme multipath retry issue, let's skip this for now
and focus on sanitizing the retry stuff for 6.14 with an eye towards
just backporting that to 6.10+ where we have some sanity on the
import side with persistent data across issues.

-- 
Jens Axboe


