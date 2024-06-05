Return-Path: <io-uring+bounces-2124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3997D8FD211
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 17:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9961281349
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 15:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E7A19D88D;
	Wed,  5 Jun 2024 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MGE5Wjxk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CFD2232A
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717602630; cv=none; b=axnrdo+B/7M1mWN2kMMRh9NGybqX8DXLPhOcvFs0Guhhqq3b6VrGfXjHb5L/X6JXLSEQR5ut4A727hhUnu3acg4roLmW7JzVqAAmMe3jvlqB3e/b4WlV0uoO30bS+5W7nDMvYF+5pTWhC5QigWp6kPVFh8xpq8sap8PCNEPgfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717602630; c=relaxed/simple;
	bh=Wskl+Ud+9hNgwDX5m4xc6kpU3xOguGZMELONQOM4t8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uYdyZpOZ4I0NZSPWTHtXVUnKF9valBp8T9PLAFlk5khOFGivgvm4YprYcgJgbJzz0dNhssClWYPFGZkgrkFTYN11U42TlXNHSRkQmYteBIh4IsizAgoOGqzaNIs6VZ2IrV0TG1EKus703Oe+z8REBO9VVWkh+YzTFIMhn8ws9Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MGE5Wjxk; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3d1ffa161c0so170926b6e.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 08:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717602625; x=1718207425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bsgLDm3pNR+rHLalVB4d2E2BtfKFVk/RoHFF/SuBDi0=;
        b=MGE5WjxkJIj6C44n3AxZHAjNT9WFmrWadd8QcMS5RPOttXBsUA25pjgrUZfTK+lBje
         lsrk2XZaVAknKrZeATPUzR6BG2zaddIR6mh541L4tyRQJj82KD40KKFRCGrqewxK1/zv
         Dh935QYnliYwVL91/MPluKI2jstT07a/VGO37HK2iizxJ9E0WggynpfPEVhylz3FvG7G
         o69Ri6bRNKnEA/FTQ9u2HPuj8z7O6WH8JHDA22iG/M2NgdFsU+uZDay+Cxt+LO0+lVOn
         8jcUqkAuyMt6AenezKO4cC7OdSfv9uur3U5pH0rNEUKnm5AxFdZnKY6QYvq5WNU3DYh5
         ULfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717602625; x=1718207425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bsgLDm3pNR+rHLalVB4d2E2BtfKFVk/RoHFF/SuBDi0=;
        b=sF2ICP+NPkZlFIvWW1tQ/sucKJvApVl9p0PTrD/WrVSVLGkS6obE3cxwBpVnRsc7W7
         mGZMeNVcVWWtA7qzK5+FjBt1ifRjRqmh35KagdgKZ/rYmQxdqDLzukSGKOZdo0SF2YTz
         LC6Yhd5qWGXBhGPqx9HEWBqvK1zSGrii4F497xXAVi/XuiOoPxQurUNFtJ7bj4jXkYJV
         E3hJ6/da9RYA5AgGv7bjATG8N8uIhvyFsgRSEYFErvOjJcTaL0Lde2CreG27V+FCIVmV
         ey0H75TXlERgRcdPSlx8Rs9qXfzpDc31kOz8axhz30vh2J8HEt8VcYUVDR4hxKz2pm5U
         QZuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbxZeI50sr5GAp4pN+Rvx0CysjSMLmA3Eyoh+L4IHSMMzn5Z4N6N6No6pRqmgh9a7eAr7glg6HU6q4Z8TXjw2QK2mOadq/1Uc=
X-Gm-Message-State: AOJu0Yw4wAOthaWQGAIKDF8duGGgXdlHoJl/SlWsvAt4mcVxZHBGUutx
	3fCOj7T6SeKiaqy2AhzZe8HnjZXyH67MIKfXVqUTUegEHTZLm+YLfEfBorWkwSHNRmKuR7EL3qh
	3
X-Google-Smtp-Source: AGHT+IGpz2cODiZjqfyUxFzyZVV1hlEkVnb5XX2SjF7HyQ+EnzlfoZ4V7tDz4b1LdPWN9DTqU0Tf7A==
X-Received: by 2002:a05:6808:190b:b0:3d1:df68:4fa with SMTP id 5614622812f47-3d204181020mr2707113b6e.0.1717602625316;
        Wed, 05 Jun 2024 08:50:25 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d205dcd5e4sm249377b6e.3.2024.06.05.08.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 08:50:24 -0700 (PDT)
Message-ID: <7fcfc2fb-fd77-4718-8daf-dacee64fb44d@kernel.dk>
Date: Wed, 5 Jun 2024 09:50:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] io_uring/msg_ring: add basic wakeup batch support
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240605141933.11975-1-axboe@kernel.dk>
 <20240605141933.11975-9-axboe@kernel.dk>
 <e5146117-b6cd-427d-a25e-366f73552663@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e5146117-b6cd-427d-a25e-366f73552663@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 9:32 AM, Pavel Begunkov wrote:
> On 6/5/24 14:51, Jens Axboe wrote:
>> Factor in the number of overflow entries waiting, on both the msg ring
>> and local task_work add side.
> 
> Did you forget to add the local tw change to the patch?

Gah yes, looked like that line got dropped while shuffling the
patches around...

-- 
Jens Axboe



