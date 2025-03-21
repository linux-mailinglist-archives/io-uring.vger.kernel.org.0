Return-Path: <io-uring+bounces-7156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FC9A6B8C4
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 11:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E351E3B1A1D
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 10:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B484C1FFC7B;
	Fri, 21 Mar 2025 10:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZVH63ge"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16F20B20A;
	Fri, 21 Mar 2025 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742552843; cv=none; b=EUjjOfW4wevXKR9LYU1zLp0lyJqpTWiWJKvsPSixvFeXv4FstJfw8Mq6dh5/KhFyiKHdMafG2Hxl8BUAXTMfcY6yQa+mJTfLFYqVBEoq9LT74usjKId7sxlI2JoaLDeyWVA6a2+YuQIWckXDfsgUPEtM+OtiLHvYtvbeJt71YDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742552843; c=relaxed/simple;
	bh=imUR6PLo95tiJzxLNzsMyiDnmu7u6xwtSjqyOg7ZicY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GADwDNrr0zX1BcbWpO3Bt8SfzNobaxAenpgBqGVsRChboHC5rFYsEaTApPdcGc9rqswdrWV6f/XVt/PtotCsLdh5es5Y1GjwCO9MIZ3ICBGvmkeml9GMQvdvLakYCBgwES2bIkmQm4GwDYaFICQD6Vps4LqV0artLICF1Kv+7Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZVH63ge; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac345bd8e13so322097166b.0;
        Fri, 21 Mar 2025 03:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742552840; x=1743157640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzyjBm2EYqeQrBTSgKit4AgE1JZmqApLPAOxaryRyV8=;
        b=DZVH63gejHW+STCeLzhNUZU97lly/vqWLsBWK8KvquPOlnDJhnRUdSum+wQmzUQjF6
         iNOswy+NM9Cy1IfGq/3yuKB/wId++ku2o8/9TpeaBc7GzAo0fCFxW4QjVnogQ2tyl5Ue
         vtpVHXeQuJZnuny+eaRRVQeGcD/PCvYI/yc82CECr5Hi/8WyDRhc+gvleiDLXIHuyse4
         KnMWTUTIBZIhrt3Wr9wYG3L6ho0YRH1JMhSyhCxQeCIX2jrF9EXmo/q2Zwu4pBznvEJn
         9kfxAJKMHbpPqsmktmWPHKto4AA3+3W44uEB2j///t9eXEcihYJM15jgMmV2HSaCQgcy
         cE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742552840; x=1743157640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzyjBm2EYqeQrBTSgKit4AgE1JZmqApLPAOxaryRyV8=;
        b=tC6m5ZzAwtpCDbTZi1rT3/lehvlftgHHZqrN6MrT46GenFCCISVw6S7OmWfKrt4f24
         TB5ENPKXJF9kN/Wg6Bho7mQ3iSytOWCFvFBNADfNUwZmKIQ0f7b+V46GnBzvFlOa5BXv
         Rb8/nT9TGQQujPKYRc9h49XzMevmkoM+rWnOj9RJEB2QNzxHfjr/ckZkjMwPqd6SqBF3
         BhNpWaNRfplMpmDgVT01TM4615p6rz+wFcI3LqhFxk0v6BYMIThlZ2XYw6IA7ygwT/up
         g9MiCJkik0nilaNwmT0WBYKigVm5EBnve8SPZUXLmZcEnBiz2D3DNC6sLZt8rzG5BNOZ
         g5XA==
X-Forwarded-Encrypted: i=1; AJvYcCWWSAJJ87B6EV2Zmr+9ba1Ek/BRSdSFdshLOjs3CqEUP5yipCM33F8qYZ1sP80v7R53ILvAEQEUVQ==@vger.kernel.org, AJvYcCWvzhWWisWTd04htKzQxKkDOzShwtWs5muMP8YXV9k1TAbLGSgrPmwCjJbr/eON6bc3tY7uZJ0MWemeOjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIlL0qZXiVNyhYx302HwudIALqCJgVMTeVvkLEa/5TkQ/AO2KW
	OH8Co5dJKQSllKCXRmMasN8LPOu10dflxV8mOa1wyabX4NoJnpq/
X-Gm-Gg: ASbGnct1kE50DH8M+eb+j9dxSlGRcqZf1aoVGd5X1/euzxhlR6bMqB9DwOJogRUm0ke
	aX4mrlIDX5mi6dbfSoI5NnEFXKpf0acA/wW0r+pdBHAoddSsej/EQFc0A+1txmvazhVo1YLxOkk
	XUfNDO1LfLSmxeQCQ+d3jDX9YCdgL1Yl3DwLQa0p0CYFu8OF1S8otrC2y4jilPdR2b9D4tnleMa
	57FUxhoJC0n6wYn2zxnFGuUbr2Af+TspykPE3NsVYtLOg/FFVndRLvnRitgb/fMABbitcx+jCHG
	swkjrALPx7eDvgNuV8TRM/mWYU+6HXa7hS2dThio690Edg3g7UZFyQ==
X-Google-Smtp-Source: AGHT+IHor5hxivejUzn4LpCJTPWXVRlk3laGsP9D+83u93hHqavWD/kc43hNyq+9V2w6U72DLejjPA==
X-Received: by 2002:a17:907:3f24:b0:ac0:b05:f0c0 with SMTP id a640c23a62f3a-ac3f20d767fmr230447866b.1.1742552839950;
        Fri, 21 Mar 2025 03:27:19 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb658f9sm123644366b.120.2025.03.21.03.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 03:27:19 -0700 (PDT)
Message-ID: <c9a3c5bb-06ca-48ee-9c04-d4de07eb5860@gmail.com>
Date: Fri, 21 Mar 2025 10:28:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 5/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <20250319061251.21452-6-sidong.yang@furiosa.ai>
 <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>
 <Z9xAFpS-9CNF3Jiv@sidongui-MacBookPro.local>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9xAFpS-9CNF3Jiv@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 16:19, Sidong Yang wrote:
> On Thu, Mar 20, 2025 at 12:01:42PM +0000, Pavel Begunkov wrote:
>> On 3/19/25 06:12, Sidong Yang wrote:
>>> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
>>> with uring cmd, it uses import_iovec without supporting fixed buffer.
>>> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
>>> IORING_URING_CMD_FIXED.
>>
>> Looks fine to me. The only comment, it appears btrfs silently ignored
>> IORING_URING_CMD_FIXED before, so theoretically it changes the uapi.
>> It should be fine, but maybe we should sneak in and backport a patch
>> refusing the flag for older kernels?
> 
> I think it's okay to leave the old version as it is. Making it to refuse
> the flag could break user application.

Just as this patch breaks it. The cmd is new and quite specific, likely
nobody would notice the change. As it currently stands, the fixed buffer
version of the cmd is going to succeed in 99% of cases on older kernels
because we're still passing an iovec in, but that's only until someone
plays remapping games after a registration and gets bizarre results.

It's up to btrfs folks how they want to handle that, either try to fix
it now, or have a chance someone will be surprised in the future. My
recommendation would be the former one.

-- 
Pavel Begunkov


