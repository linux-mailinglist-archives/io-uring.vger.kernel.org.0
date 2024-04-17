Return-Path: <io-uring+bounces-1581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709628A85F3
	for <lists+io-uring@lfdr.de>; Wed, 17 Apr 2024 16:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B891282E54
	for <lists+io-uring@lfdr.de>; Wed, 17 Apr 2024 14:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86FD61411EE;
	Wed, 17 Apr 2024 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aMMgJ+QN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1356F141995
	for <io-uring@vger.kernel.org>; Wed, 17 Apr 2024 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364178; cv=none; b=pO0G38NFJZHLUxIX0iG9S8bxwT/ZFEzHOfo0Kk6FOX6XC/Wrr4EllbxpeY6bqESV5J1ZUtfs6tWjcR18RVLAD/AkgXMYZWrB7SlYDO/UtTyMPGaPUclGTV1D5I8urUhfswsqWJQqeZX9v3JZe5pkx0RV0aPPUbimy2MHopT2LmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364178; c=relaxed/simple;
	bh=gsYJCOiVUe5elGsoQjeHcvnGTNG66kad0sKx19MtyA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sItL86DfcJDkuSlwymP4Vc2qvsi7BUGwCF/ZxWl0t2W1Uy2p9TzuxyHHGBo8DRsDXcLEsoLJ5X7w0YqCnx7Ajjx/czYg9PLPtgVpSYABrWY4OPOmmEWGObh/zAsao4LZP3nAuodygxCr3DO4yV4VzJ3nhUQE3XPdCln6CFsq3ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aMMgJ+QN; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d9f3704154so5497839f.3
        for <io-uring@vger.kernel.org>; Wed, 17 Apr 2024 07:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713364176; x=1713968976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5a9vPPJyMn8oxgKdl/CvCQnt2UwRYN3jvuRtkeCoRx0=;
        b=aMMgJ+QN48nZzHdejUEoWMAzG/S8gZiG2OVEBmx9Gn4AIHZ70j75AVbUJgtFxjipBM
         h26+MJuSDkQFhB+f0zyioO55d+Sy9IoWb6kVon9JG4k7lyffSQWEVTqRDyl+YmLQh0Xb
         hfWP5SMCBiNA0klKy5NEMr+k/rWy53Q3ybX8qrNUh+Nvtl46zAQhg7VKmka3GMIBS1PD
         ksoflY1bswJk7iIwgDs7P+H8KRWeSVwRH00yYluVyMc1EcTytDDTchLwu2GZsxqcUZzM
         eq/CONSg7mY1ymUcpyDXzV5uBRXozozDCAaw1EUShDgU/DYqRHxdys+HBNG2f8k6xz1/
         tlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713364176; x=1713968976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5a9vPPJyMn8oxgKdl/CvCQnt2UwRYN3jvuRtkeCoRx0=;
        b=sueoNf/otswiL4nBKX2SdMp2yREDROdHa3bAIFfufbNlfCNO8I9krnKagdxN581Bc6
         EV3QlrPsZKBehTzr4aXmnSzfKGfpDrtVMZFVbI+if/HIrL6Wiow++fZ1xHFartHylTvF
         L4J+Rer4g7srycLeMiU6iDJuqEL7jhGG1ItZYidcGzWGlTYB6TGCE0r115q8i5kNN8aP
         wPmRdhB6SP4+XpSHAkD23y6XsDD7xCllXnZu1BzMONJh9q/6ojzfTiQZBpuCJSMCVEaV
         IP3YWS+XgbuW38zHoyjypSBhoKe0FhuxLLuquR9NvM/WAHVWLSl7lE1FB8c2aHE3v+Ew
         tVbw==
X-Gm-Message-State: AOJu0YwNF3p7F6DmiegfMziRYvzO6b4KYTgS/r7DYuYtM06xTfyLgwHM
	TXsn6Hz3uKKLJ5UPn/p3tQ1ysFlspkJ9hAmmvtahkFWY+CPbRhIpHjdHuAlnv8gxo3W1wn4+sm1
	I
X-Google-Smtp-Source: AGHT+IH4JVeCGCYX2kxUYUw7ezKVLUvrvIHGVg30Ees54jbQpMcCS6YJei5GHp9R7BRFXM+U8vN01Q==
X-Received: by 2002:a6b:5b10:0:b0:7d0:bd2b:43ba with SMTP id v16-20020a6b5b10000000b007d0bd2b43bamr17992001ioh.0.1713364175902;
        Wed, 17 Apr 2024 07:29:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y14-20020a05663824ce00b00482cebcd13bsm4378309jat.142.2024.04.17.07.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 07:29:35 -0700 (PDT)
Message-ID: <5e04bbf4-a434-4fe6-ba2a-efdb0ede60d8@kernel.dk>
Date: Wed, 17 Apr 2024 08:29:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] io-wq: cancelation race fix and small cleanup in
 io-wq
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240416021054.3940-1-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240416021054.3940-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/24 8:10 PM, Gabriel Krisman Bertazi wrote:
> Hi Jens,
> 
> Two small fixes to the wq path, closing a small race of cancelation with
> wq work removal for execution.

Looks good, and cleans it up nicely. Thanks!

-- 
Jens Axboe



