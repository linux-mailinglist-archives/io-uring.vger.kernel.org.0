Return-Path: <io-uring+bounces-6691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D30D5A42A2E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 18:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55C987A216B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD05B2641D0;
	Mon, 24 Feb 2025 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SGsrQj7X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647DB26280C
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419093; cv=none; b=qJePxW+HEdvw8ZedxlvRtNvxBgltoqgcBtnxHTWuB/ujlaa8ME50X4a8ixnDS7JK4YlK3cTn5j1mAgRCW79w4jH8+AKmFdoXh+4LN3E9Dj8407BCVzRYoPfpn0euy23WQg+Mk4lhjhmLlXK0s+LTMJce3KTTwC8ctBOc80bOnZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419093; c=relaxed/simple;
	bh=/wIuXP1CwOfD5FKUIOHFwNbyVgr6IBA4qqUVwMvdhEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kGwP4lkVmwuX0gg4/Z1k+6jmWUQRQ1RoXzlGtVuu6yvHeIOLOCC5dG/l4vU3YbUODTKTnVxPRJVieFaxiclB0GWGofFtSQs3GvO8bec4dm/lIsp2CLsBIeB/zE6jBlP7WoAePtqN1V2RWr7J9TI/uEqBsma+e73onsZeX2zdQM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SGsrQj7X; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d285a447a7so14093175ab.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 09:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740419090; x=1741023890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sFYgpHAo4G8yagE/n80s92o1BJfsNSB20MjCQ27CjnU=;
        b=SGsrQj7XN90Kcg16d/zhZyN9z+XezJ0kMumfqz314TbLxJg4yx0ghpbwyR6i9088dZ
         4Mwp8oNxaToCBJv06hU2u8OBrvKzky9OCZAiRcbSZyLZpqvOpGNyWaX9GwRoYhY+cj/p
         /fz/0RwpEy9tGcsz65MVlFMCtiHSHfQvQMh1LgLbb5ieFRSoiCpWd7IWHHpCgPcakil1
         UJDjKamc/rYqEZ90GriSHJx6ZicrBVlfrKHfZfygp6AXwkE6+1P6RCKiAQcoSXYw5DQt
         Sq60KKcpGinekHOdKMIWr7S1lFqapHdd0A3Ubl9UbX2A/dbNjVWH4cLFhQinzCP50Izt
         pWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740419090; x=1741023890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFYgpHAo4G8yagE/n80s92o1BJfsNSB20MjCQ27CjnU=;
        b=gYTUUdnAwv4xKqFdGuAR9dg5cpn522PSLmjrLzvke3LD+INVSVMLIWim+MBJWVa9wV
         DKo932pvJUD2d5zTpOKrsWt02qh049oratuehzJCgZElAxuMCL4nUBXpD44mcJKpqZ8v
         U6IxPL8xPg1G10dhmFRBbd0UPxGJGM2IuXojjDHSA1RmWajTmQA1NAXHqfL86EbyEGNI
         HMUP1NbRheyswaSRoTYpr6rBvqpW690sbUVfWUh9QLjXvGZa73UeSrEUCGNqLVvRW5j/
         PjTg77UYBY1Lri2Do8+RSS7djCxLUN0cd689caUzLUHFdsCgcDzEnFtXNVVG7G3ozSvZ
         DCkA==
X-Gm-Message-State: AOJu0Yz21UuvL63XzbC9uGUl6B1c86dWYf9yGbTyPflyB1MvIgAv9bD7
	CRUDbmcrg0RgWkcVL1ab+XBJ7lhNzGYcNE8rz2wCBjkMnH2d2vQ/7PvbebZMSM4=
X-Gm-Gg: ASbGncvfQvHn19MDT54ZZ9UvSsUQng3N8a7tTE5MRUHfY236P9frbtq+aNX2TQzAaqO
	4bingTE2w68DvvllDbWcqKpL6HHms34bA+QKvE2U7PGFZoUfZBqZ2IxGur3SBO1xdJFUvJxOKwO
	HsUdGKWHNyS6Q8t573akLJi2C1zFPpF8Mtelk5upyme+RoPIQDYNO6SGsWZ7vvQ0F7JfH+tu4af
	AT8ON7Iznr2w9Zsp1ZUPXkyJTJrz1r0UA0XhPU+wWepXGVmlXOs3YbANK29RewphXJVIrYncyyy
	yH6gEnzsS0RIHeO+SBYIuqg=
X-Google-Smtp-Source: AGHT+IET7VWvxOoimLSqiCoSqQxzK1UXWlBt1CdNLGlMCKraTG1S9SrVYIY6g/f5afjVCWtM1J9gvA==
X-Received: by 2002:a05:6e02:198e:b0:3d0:1ee6:731b with SMTP id e9e14a558f8ab-3d30487b68dmr3037665ab.15.1740419090502;
        Mon, 24 Feb 2025 09:44:50 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9a8a68sm52379905ab.13.2025.02.24.09.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 09:44:49 -0800 (PST)
Message-ID: <ebad3c9b-9305-4efd-97b7-bbdf07060fea@kernel.dk>
Date: Mon, 24 Feb 2025 10:44:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250224172337.2009871-1-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250224172337.2009871-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/25 10:23 AM, Caleb Sander Mateos wrote:
> io_is_compat() is already defined to return false if CONFIG_COMPAT is
> disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
> compiler optimize out the dead code when CONFIG_COMPAT is disabled.

Would you mind if I fold this into Pavel's patch? I can keep it
standalone too, just let me know.

-- 
Jens Axboe


