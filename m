Return-Path: <io-uring+bounces-2721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D570694F768
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C1CBB20FB0
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E35F18E022;
	Mon, 12 Aug 2024 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5cP387E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5DC189B8E;
	Mon, 12 Aug 2024 19:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723490237; cv=none; b=RMFVaLd72rUaupImOX3scrXwzw2x34xLUUbgryAJ0YtXwyMlcZXCsS7ddAwA3mih20NPkDh8Weyu/4RB6SMaiJF56J9eoArqAIxeLVsm364W4cwwTbFEVhMI+pVlhtwy8EUtkE0miVy+nSuViWGEfGplyd4tnVIAuw/70Gv0W/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723490237; c=relaxed/simple;
	bh=7sz9CvjuNPNfRUj401aRDYdR71/hzNHxmi51yCiqR8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzeLctNdY+le+0PxLEJCKlTggS2PKftyJhvmHXhc9Ay4UeVp7y0q6Y5p/qNSbLJWWhfryEQYk3b4nc4x3Rj+bT7/bKikbie1RUygSLQ/fDHuszuqmvoJwHAZFcm5U6vv2U8m7NqgBmlzFE5hibQVWsYreYSAarniHYu//lEZHv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5cP387E; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3687f91af40so2857619f8f.0;
        Mon, 12 Aug 2024 12:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723490234; x=1724095034; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZ2s+/2JnPwbi3dFixsI4mcIdp5l6wIAA6n3/8G6GFM=;
        b=U5cP387EODO8WhwQWHeE11qMLUfQesj+LCtIPD4BVDdFooHeh0hyEdOAWxuHoWxzW0
         vSn+MUhQ5BJEULzw6aQf9KzlVxXTUBEkkU2Q8ZlbhRfkZqidzACKK0ER73wUlQy9Zqu9
         ZKTeFL3icu/w96hnH4XEX8I8Ywbvp746k2Bj/Exnx4UirRDMDreJ63x72SreMUhjLnvc
         IQHeCrRoNIHqsUrT37nGdwPH07GXG4qCWRZOLA60wKVgIpUYf1HrM6FwKM15LGNsUADg
         YnzznQoFKXDMA8XR2p93snsd00ZHM/M2aJTnioEYFrkQoNSpXROsRlhJDwusBlM9fiWj
         QC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723490234; x=1724095034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZ2s+/2JnPwbi3dFixsI4mcIdp5l6wIAA6n3/8G6GFM=;
        b=bOrY6w3szlpEm9mgoPyNQak5+xPW2/c7dGQEKLes0ZPNjrWNpiHmRaWf0RC0sdw9gK
         CPRzhA+lr7cM5w85NErsT4jhq3aEEx75reWm0HXna/KDJ+EQgQZzqX7NCmF092Cl87bN
         wvSICWUNKyA03lDxzobbOITvAmliOLKDnuvI7QgYkMz2M8oF842nP7gUydAhvQpJNt1v
         Vop9hUe/Hzd31xDPQTqwXdqedb/jdmfPPs0xWOq1oBA/Dk4SZvSeoh6ehRAYIf9XItwg
         voDDhGiR7A6Kl3tfiyiWGTXB6JBnKDeA7claUbkONzEGOcPkYKDgFoDSbFGNUMVWiQQ1
         GXng==
X-Forwarded-Encrypted: i=1; AJvYcCUyF6m8LTqTM7uTQdSVfiYgpYh5KiQGpv0MRFiG+twY+x+R8N8XW0hbIs4fPXl33MV6+P6UePk9hpZONBHki0d3eypWVo2mBwhZQ8mXqyqlaFPGYlcN0r5CBuAci7jTGSNlxmaN8A==
X-Gm-Message-State: AOJu0YxTLa4bSHgUgyfHp2F5LteDRZXJYqEmhq9XIEqAhw9O5GkE92Bh
	EMzPqU72WcNFO8Eqa8/pw+VcxhR7cbzPdv3WleoL90yFEYG0d/Xl
X-Google-Smtp-Source: AGHT+IHaQryJyN5kIZ1vwYW6VL1wfVvUPGJcEKHI7Z98ZKU9xJd5e+GBDGzPZE0bwY0wuFV9BcPeyQ==
X-Received: by 2002:adf:8bcf:0:b0:36c:ff0c:36d7 with SMTP id ffacd0b85a97d-3716ccd82c4mr945101f8f.2.1723490233799;
        Mon, 12 Aug 2024 12:17:13 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4cfeefedsm8270166f8f.58.2024.08.12.12.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 12:17:13 -0700 (PDT)
Message-ID: <8d8e24bf-95d2-418e-b305-42eec37341c7@gmail.com>
Date: Mon, 12 Aug 2024 20:17:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
To: dsterba@suse.cz
Cc: Christoph Hellwig <hch@infradead.org>, Mark Harmstone
 <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
 <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
 <20240812165816.GL25962@twin.jikos.cz>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240812165816.GL25962@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 17:58, David Sterba wrote:
> On Mon, Aug 12, 2024 at 05:10:15PM +0100, Pavel Begunkov wrote:
>> And the last point, I'm surprised there are two versions of
>> btrfs_ioctl_encoded_io_args. Maybe, it's a good moment to fix it if
>> we're creating a new interface.
>>
>> E.g. by adding a new structure defined right with u64 and such, use it
>> in io_uring, and cast to it in the ioctl code when it's x64 (with
>> a good set of BUILD_BUG_ON sprinkled) and convert structures otherwise?
> 
> If you mean the 32bit version of the ioctl struct
> (btrfs_ioctl_encoded_io_args_32), I don't think we can fix it. It's been

Right, I meant btrfs_ioctl_encoded_io_args_32. And to clarify, nothing
can be done for the ioctl(2) part, I only suggested to have a single
structure when it comes to io_uring.

> there from the beginning and it's not a mistake. I don't remember the
> details why and only vaguely remember that I'd asked why we need it.
> Similar 64/32 struct is in the send ioctl but that was a mistake due to
> a pointer being passed in the structure and that needs to be handled due
> to different type width.

Would be interesting to learn why, maybe Omar remembers? Only two
fields are not explicitly sized, both could've been just u64.
The structure iov points to (struct iovec) would've had a compat
flavour, but that doesn't require a separate
btrfs_ioctl_encoded_io_args.

-- 
Pavel Begunkov

