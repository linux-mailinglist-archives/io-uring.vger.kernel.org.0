Return-Path: <io-uring+bounces-9829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D05B802B1
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 16:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33B7A3AE932
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 14:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431B32E11CB;
	Wed, 17 Sep 2025 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rFNSSOWP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6622D8383
	for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120259; cv=none; b=FVkaiJlu2OE6SyDkP9bJWVrXRX7yoz5cli9G8/ItgyuD3HZwGEgkAy+AkXwPZt8Fychvth7bnUBpR4n4A/HGeDs+/6MoxRDQH28tbz7ESe4AklQrS1ejczfInfR5cSkJ2T2FBvvJFhQC1cgWdxBYrM0CfXVMigzsytQQblANg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120259; c=relaxed/simple;
	bh=djDgKHf0X85ABiEvNl3O2na2h1FP/uTy7dE0b+0bCgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3Jzv/pto2ZaJnv0ANJ0YiMIKKZFuyOBYVLV3QwbUMj+PpYIcFSVPhsU0H4/GW0u3Y4zda5ReBr74T8JCIZU8OlBEHmaQpegPw1MSFR0w2OE/6q13IzMPVaz/X5udWcrlI7aZ3syrze+3WVVryCwFCTIGtwm64E8f6RZLE4/t3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rFNSSOWP; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-424081ae9f2so15180485ab.0
        for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 07:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758120255; x=1758725055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6a65Zaa+Y03GkO/fZ+UqxGc7vwN1C2Jv3Vt4W2t6oKc=;
        b=rFNSSOWPxwVPWOwlh7MxQ14dFTzXdrnEDR7IsU6U4sZN59aNlnzsgxgAl4qw39hUBm
         rDbzCbmf82r7602XZJYF2RABAZwtrAB1Mvk553ijtCDK9GfUdH+4hzSyElgu2N3+/c9z
         pCQ5zIcmS/1Qqss4g6jGdYpuVMF9SarRrBhFESZGqsgk0GlPpn4sNOhJ9+dZrQAiUgRa
         hTcQNphnAVf79yg+LwaBlol/UmgnHodbXfu5Y/w/1QsW+n9B+Zwnw8mWDHLHkyqS7e5D
         JQbwGCPhmEVF9D2Y2uwkDCtEMBir40a1mbeXDt+tsXYycISaCyJKzOEKe02VS8w6Orh3
         kJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758120255; x=1758725055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6a65Zaa+Y03GkO/fZ+UqxGc7vwN1C2Jv3Vt4W2t6oKc=;
        b=EMSaNqZTITg1UNH3cgb/TO8sh5zHnJ2h/f+ntDkLNekUy+waQdo8dp9Ji7dIMIFPvf
         3kDa51mikY+cPtg4QYVVasCIdFfwH2NbXlXRizymbXDSs0G/bPYv0E6f8yQruSVzjLuI
         63O8q/28gMalT5/0TquoMMW0YFQXZO0AAwG+ulZC3l/zliQA2TIQ0MznuWgnPUhStTS3
         MXfDnmz/5cMtLuoCc/DpgLebC95SiHEgpXaVoGjcbo+dmM3T7J6Uwj07rNuTar+I9ngq
         qY9+Qa7b6YvgzvkCPCKiNX+bJMLiTP6vIQywleNuyqpvRL+O41kq0XTXHqCySl5Qy5qy
         Cg8w==
X-Forwarded-Encrypted: i=1; AJvYcCUOpaGnSPa+BmQux6JffRUsQpBrB1YQ/a7c1QjVntbUvzi7etzbeDov+A99un8Ph4gwA4qjN+ERiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZBJK6mm1xdvf3UclSaIvguTna0lGslYXHMHb/XuLmJ5295LEB
	jwUnVGiveWPys2lxuS3O8hwckrfw48QfRIsbkQv6MwZS/j9cjgqukNBiFSWOxjivN9g=
X-Gm-Gg: ASbGnctQfsBBrUrcsM6qnT6uvOpmVfp8iXBD/LuF2EsW5KsL3+vemxi7tmXN56Gw0Nu
	fs3akdBg5oVRo7xA/NuC59+ai4tMAtXAZw1Sdc/CVGmNCVU/PlLxIIu/VmWY74lZH01XXehxhPB
	km460cFgf+LRNePJEoAAo32jNqkkcFH8J/1L11CtEEDsUiFzMHuoSD2HQ+NcyBWAnv+FIClodn8
	7pYsU/ZxsqPQB1hAdFreM11XR9v/tcmExDJimKMZzc45OvXLODzyDxIW+vQBgzIoOe70mMXW6Vk
	t+nLeZ0FNO3KHokY04soSBtxy3RR4qhUBG9kgtvVebfmJ0ToZzQxXP+IV+VE5KhC7ckILE23C99
	oK2IkJiq2ZnjhIT2Ra+mlj+B+VLMRnA==
X-Google-Smtp-Source: AGHT+IHRQ4LjNyH1XnxTlUwm5+0KeohUvPdU7GhxdYRu/ONePaIFdgpQupeYMIpSqTF6I1lp8RZOWQ==
X-Received: by 2002:a92:cdad:0:b0:420:f97:7446 with SMTP id e9e14a558f8ab-4241a533165mr27232095ab.22.1758120254740;
        Wed, 17 Sep 2025 07:44:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5120ef21180sm5121447173.55.2025.09.17.07.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:44:14 -0700 (PDT)
Message-ID: <c68af2c8-4b2f-4676-8e0a-d3593e462986@kernel.dk>
Date: Wed, 17 Sep 2025 08:44:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
To: Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk> <aMIv4zFIJVj-dza5@fedora>
 <aMIxmiGv5D0GvSro@fedora> <aMLIU19CfgOAuo8i@kbusch-mbp>
 <CAFj5m9Kbg_S_rES1BXRXpaGGnatiEmwEsN+-f4t6zGUH79LPCg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAFj5m9Kbg_S_rES1BXRXpaGGnatiEmwEsN+-f4t6zGUH79LPCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/25 7:07 AM, Ming Lei wrote:
> On Thu, Sep 11, 2025 at 9:02?PM Keith Busch <kbusch@kernel.org> wrote:
>>
>> On Thu, Sep 11, 2025 at 10:19:06AM +0800, Ming Lei wrote:
>>> On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
>>>> SQE128 is used for uring_cmd only, so it could be one uring_cmd
>>>> private flag. However, the implementation may be ugly and fragile.
>>>
>>> Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always interpreted
>>> as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.
>>
>> Maybe that's good enough, but I was looking for more flexibility to have
>> big SQEs for read/write too. Not that I have a strong use case for it
>> now, but in hindsight, that's where "io_uring_attr_pi" should have been
>> placed instead of outide the submission queue.
> 
> Then you can add READ128/WRITE128...

Yeah, I do think this is the best approach - make it implied by the
opcode. Doesn't mean we have to bifurcate the whole opcode space,
as generally not a lot of opcodes will want/need an 128b SQE.

And it also nicely solves the issue of needing to solve the flags space
issue.

So maybe spin a v3 with that approach?

-- 
Jens Axboe

