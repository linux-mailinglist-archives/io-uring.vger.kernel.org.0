Return-Path: <io-uring+bounces-9852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85119B8A194
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82C2817C620
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 14:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE955270EBC;
	Fri, 19 Sep 2025 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aiet7TSh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE5314A83
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293485; cv=none; b=qO89xor4up6ZjhXBVanaktVxEUSY69rzWkQwRAC7g0YutjVCCFE9CRjvOoPBVtgxcdW9kfgIXjwUl1D0/ukQ6wVHCJkltioJfOXsa7ZpSAx92lgezcDzFzLers4/qkXeqvBzOf4kcDKhi648ROfmn0n70PI9+5Uk0D1gXN3MYpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293485; c=relaxed/simple;
	bh=5KDuspJbYGae+JPY/jKuxXTR2Q2VNC55E/pVuRn/h+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hwlU2lArNd8tDu9rJD6iuvtWbbkAPy/K7r6aNtoITA8MeP2VJN3NjGriievLJ4o9mlooe4PdtBAsCcueDjsBc3NjAgLr7mqumn3QMj/yb/44YG/g41/yN6TQDqra5fNQD724C5GkGOsQZyxtx1vHVlOUWx1ToD5FTiga86n5O60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aiet7TSh; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-42487ec747eso3812395ab.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 07:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758293481; x=1758898281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CfbRT4tgBtwBX1pUoqw/SQaM76+rot2BaUNJL8J7NQo=;
        b=aiet7TShV7YJ1NUyhFdUShxpKJyVJNN/mlA8D8hapJZSlwm+HC7w9Y6mmBd1RLanZ+
         6tfRgimiLVHKvpZJ+sCXg8HELNqjeG4mrUj2PrRUtoA0su4iUmYafFdqDDKxs1cTRFq1
         RLEyPyv81WTP/E9ouIm1aaqryltm9iwbeCDUT3ioLk7FOlTnYqT6NVocxDFRpfxiTjqT
         uP12zyPk3MgoCKjgKDNBwPuZalVIDNb7uWZCRpvGP0nrcPaqryIcIZuKscP9FYxOejnw
         zxIz37nm9Ibilra41ykuynhn/ueXKImlORQMHP7kspGS92dluHld0P0fzFYNKrsYrlNk
         47IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293481; x=1758898281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CfbRT4tgBtwBX1pUoqw/SQaM76+rot2BaUNJL8J7NQo=;
        b=QFlsDXIWpGmVL5YLKKtPFKBhNG2Z1g7HEKr+rCdPo006SpbWvyyMwzWgIt7RN0fNTZ
         uSYNUTljpC9miY4ATipPwDTwbk/C9alGLrwjJ+AmVt1nUXi39eV4dO0SShZbKqDaADEM
         iY6dUZGNRUbdNERFmjhqptL9dAsFv/JAAySxSmVjFAUXkHJ6xmncCZRNDbvQGYhIQbXE
         WfvX+wmcBQbduy0iteJ2/jctpIvGwFpcyd1MvtznpZ/W5xtZ57YXCi6ySGh0sVEwAHWV
         jlRb0o0+jN4c9ItSWsr+Lrloh/c3WKtkizSdl/Lc+YMk7FcatoNWD8ca6DN+nqVhaGAX
         7zNA==
X-Forwarded-Encrypted: i=1; AJvYcCWmZQMUuFJiEob4ddOGan8Wc6RSVhMepXk3RfZEUhGCWgq3ASL8cmVGxfuDRUzLrZlPhI4KH0CtVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVn8cGDMnwhh61jt7awCG5RZmOk5FGVBFk5eQ5pOM0KZ+ehb+5
	vBfiyyb3IM4u9HH8B5mk3zh+j21q8dDShjsawcozVT9FE9Fj0oCVngW8KAB0dHxoESM=
X-Gm-Gg: ASbGncs/3fayqpsnPKcJxx0m/7L7qpOFnz0VPlaD4KbE20oobtPZZVq1Kra0a3C1J8/
	QJzg/tte6bZ+CC4eMdWdJtsU3AOuqgERh7DAhdVV07JLNN2RDdPa1Td97HddPhlyehR6wYhKQNA
	AqSOAI83Fn2jkfDbh2b01SwqmtMY6zX4L1uNS5XXguDO3DMt6XV0UkXzPetxn+R2o3JxOfqIjnF
	hUAmpqz+dzYnDRDtcqMMURLTrmAYJoefHS7y7Q7lf36mEbRz6IDJ4kXl+aMG9jVphOP8pTQhLmE
	YKDke4B+hALb4EAIXduz50wHYNk/L+Em2AdqFVLf9V4EVqkzR2CITIaHzE9DsFeqm8wms4Psimm
	r13n0N2KbSBcx+UzhfgU=
X-Google-Smtp-Source: AGHT+IGCdOOc6fRVmC7JHvq/8LDWUxUICqJk+yKrdkYYKbdZ0RzKn9OQgxFm8+PjIwp7b73kDyyM3A==
X-Received: by 2002:a05:6e02:17cf:b0:424:80f2:29b with SMTP id e9e14a558f8ab-424818f7eebmr63072975ab.4.1758293480580;
        Fri, 19 Sep 2025 07:51:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244afa9e9asm23256255ab.28.2025.09.19.07.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 07:51:20 -0700 (PDT)
Message-ID: <57346868-0da1-49e0-834b-a5e5d26e7dc3@kernel.dk>
Date: Fri, 19 Sep 2025 08:51:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/msg_ring: kill alloc_cache for io_kiocb
 allocations
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <0ee30a2f-4e36-4c0a-8e84-7da568da08d3@kernel.dk>
 <23a67fd6-0179-4578-82ef-cf796bea4346@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <23a67fd6-0179-4578-82ef-cf796bea4346@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 8:06 AM, Pavel Begunkov wrote:
> On 9/18/25 21:04, Jens Axboe wrote:
>> A recent commit:
>>
>> fc582cd26e88 ("io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU")
>>
>> fixed an issue with not deferring freeing of io_kiocb structs that
> 
> I didn't care to mention before, but that patch was doing nothing
> meaningful, adding a second RCU grace period rarely solves anything.
> If you're curious what the problem most likely is, see

Yeah I forgot it's SLAB_TYPESAFE_BY_RCU already. At least now it's just being
yanked.

-- 
Jens Axboe


