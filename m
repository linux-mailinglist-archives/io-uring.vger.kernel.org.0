Return-Path: <io-uring+bounces-13294-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPVVA5iHA2r46wEAu9opvQ
	(envelope-from <io-uring+bounces-13294-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 22:03:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 582E8528EBC
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 22:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A0B03044543
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 20:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B553A8384;
	Tue, 12 May 2026 20:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="RoMHqMkC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881343A7583
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 20:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778616210; cv=none; b=lvkTwKl/uqS3MTJOsy+6b7NEP4PX6NuCYxOYhXKQZXuOJRvdGsNRXYChzYwqriZHr9/8AYe9ZzecdRbBRTYIMN87VXEjnVssFtD/3brLrmt8QlVf5/QITRE5wfyVteHXsj6bbJlUDW5k3QA2GHIscY6+C7gnm3TXWp212csq7RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778616210; c=relaxed/simple;
	bh=icfVQZTDpssRWG9KVcnT5QAPQw3lAHsnDTRA+hX/t/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFhuYtjQVZtLaF7b9XJJIuD3+/57K9elnPRoQxD25SDksUMMb7MHITnvARqunMttu7Ir9nEUZq1Q/39VgluubQWQ/JuVm26gpP1z0iIxLu8SNc8TjrEqA7Oci6xDOgUkCJUmiFa4vrFfqCSV6C5VrW9+/VIdZ3/lEYv3D7lzXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=RoMHqMkC; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7dcd17e19b6so3433737a34.1
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778616204; x=1779221004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4sFjsl7rX9xdwkM4JBePDQqpzlupaZEv/JzhTJF06DY=;
        b=RoMHqMkCDa0J5TOYNDw5ySapy7HT8ta6dSP8gai1NHt6+tZnvx3jKXfq9V8UM681vE
         QrRcKMw2axa5ue46xYUedDVq/zFCHE0Y0NuaHdk9GaxSQ78GEFQeZflydEAFaWBPdboc
         hfOi30sH/y+Z6EEBUCDqSPxYucpywviE7RAxKNpVOMQn309Lu+VfkRPZWI9TaE00h/So
         L2jhxzX4zUdTvi1wqhLJ774Mgph/KwNVs+x5po3zaquh8AuRnyIQ+kwcX35nsI+k7hYi
         2VvkRFWOFhoLK29MpAa4WtK1b2hN7d9T2OIm6dmIgOzZHuZXSnayrfWAa95eO72kl97f
         112w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778616204; x=1779221004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sFjsl7rX9xdwkM4JBePDQqpzlupaZEv/JzhTJF06DY=;
        b=diXhiYU6V9sjNPtfjv8Sjb6P0E+9TfnasdmB8PazdOvjE8NNMn/jhosAT9tU/PLi7E
         PnrKkGlK2jnF2yECov84PihI9EigvXsoGkg7tmEznUnbX4FbV1wBGIp7Tmvaaw6UhUm3
         4gbrrXeq27HfSXIhP4FKtnB/6vwNW6M/2RlXB0yNcb2DUTyeZUGzhVel/RFMRU5hL7/4
         n4tK5AmmEU91TniZzRR+INWw/QlH8ZFgHiSItisuFLqXZR5EjwxyOEyHhWI+TkJnumlo
         eYN2YfMZuJVBP8twvF7hdEAxfM0D16Sdm/FmBehlRFQclD4ClHXYqPCRi+BQDrIyRlFJ
         kPTw==
X-Gm-Message-State: AOJu0YzqZ+vg/eEkrpga5jKqLlvhdBSnBwzvZV07J85o98rrrC5NFiRN
	6fPHWcMJXsa2r7JNO16tfBcoKBCyyaK7C9MoikIQUJ9y4Q5XZVPEKq5tBZHD14VIe8Rg/a9YnpV
	GrnJq
X-Gm-Gg: Acq92OEGK87GC69pjyGK6r1r6i4rMR4FU3kp9vNni0Kt2SqbEcVBW1PNmuygiXBuRrt
	yVGhcrj2AZ0O+iBRr02hkJpXzV/fjytGkRbPl9um5mU+urs8h5OlcrjcURFw7+nhz8/H3tARnPI
	up1KsFo6MTDFcLYWomgJ4eYuvFNrfi5+AOl4CuB9dwX1Uqlzw80zWx6mS/INPzba8Px6N/QrMEL
	9gsDf7qXUXCdt9p9bay5ghjaK7BggjlhpsauPveBbtbMfRrwmnJwlPTJjeiZ3Upir6X6tesutIu
	/u2iJcV/ox6oGhV7IjeMz6pXc0Yv/IAMChlcaKhoRUIguJuSxWNpyt1FIk5b9bzrAfI36ntrPYx
	Qr7XA5+DsXOdDoe6T3NcEVZ3m/T54kNyTSisRjkOWv7NIzGmUm9BDDIkSuy8ETjz//Tigts1E2p
	gQzj6x1tHNF4KnMwx7EI/chGB7vZBVegm+iL3khM486D2sGvyhAze0/bXeQ01bAYzM9oq1CZWp2
	/ue3XaIMKbSh6tL/vWC
X-Received: by 2002:a05:6830:6310:b0:7dc:dd19:7f69 with SMTP id 46e09a7af769-7e3da4427afmr94184a34.17.1778616204344;
        Tue, 12 May 2026 13:03:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e367d8feb1sm9193403a34.23.2026.05.12.13.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 13:03:23 -0700 (PDT)
Message-ID: <0eed0ed6-7e56-4dc2-acbf-7a221012e08a@kernel.dk>
Date: Tue, 12 May 2026 14:03:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] eventpoll: add file based control interface
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260503085101.112698-1-axboe@kernel.dk>
 <20260503085101.112698-4-axboe@kernel.dk>
 <177861542130.846060.12151691690322065378.b4-review@b4>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <177861542130.846060.12151691690322065378.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 582E8528EBC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13294-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/12/26 1:50 PM, Christian Brauner wrote:
> On Sun, 03 May 2026 02:49:14 -0600, Jens Axboe <axboe@kernel.dk> wrote:
>> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
>> index 7bf30e9f90d7..4a6fe989810b 100644
>> --- a/include/linux/eventpoll.h
>> +++ b/include/linux/eventpoll.h
>> @@ -61,6 +61,13 @@ static inline void eventpoll_release(struct file *file)
>>  	eventpoll_release_file(file);
>>  }
>>  
>> +struct epoll_filefd {
>> +	struct file *file;
>> +	int fd;
>> +} __packed;
> 
> Since you're exposing this in a header now can we please rename this to:
> 
> struct epoll_key
> 
> This weird {file, fd} pairing is strange enough as it is.

I'm all for that, but let's do that as another cleanup on top. This way
we can keep this one purely mechanical.

-- 
Jens Axboe


