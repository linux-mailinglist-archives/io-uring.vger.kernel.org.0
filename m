Return-Path: <io-uring+bounces-8408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF05AADDF13
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 00:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D0CE17892B
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 22:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ADF2F533D;
	Tue, 17 Jun 2025 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FrJSd+iw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8223208
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750200113; cv=none; b=sxHdPaUO7xZyc/aClUzDJwsv8CwpxNauoKD6s6ntmIKEAg+ZJp/Rp9ceOFTBkcVH+zkaE8el9Ag0hdaQmC2eA3ha6Mee9SeVnCxI1juk/uany+f1j4/NTfCvBXsyuk9VS/h69seMLxbcz1f9Uzvpyk4RNmdajFn1BQoB3Hi20s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750200113; c=relaxed/simple;
	bh=Wyltk7WgG08mOczXamgtSq84WvzFMAeDsL758G/jJsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZ+GYawFZrSIQSIBXACihq4CxTOriZkX7hqLwJs7tcMEuJjuIDs1WelL5CcdNgiA9ACpIxcPfnBTfpXY8tSQc5rousnfX1nWSYb60eX443vYY+zTIMTk5I3tci/eV8j6V2vBe0PDju4r84VR5JCOdr0uPn6rJQ/UDh9ZS153MeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FrJSd+iw; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8733548c627so208662139f.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 15:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750200111; x=1750804911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=88AIS/uYpf8Ers2JSTN9a2I7eTl96ZTUl8zjwBbs8g8=;
        b=FrJSd+iwLta6VuD1eoa0mqK7gXtGVyIVuLhKwHPRlrGi3N06PSsfzZ1JX+TbF5l8Md
         sJ/noldQceTRie2fgEMmhzKfb9tvl7sZQELadLH9EDy4n7P89sugYUXmwUGZ5Cn3ZgiP
         dNhwYKqU4GdfoIX/moJ75R8rocawHaTRQ2Jq8oPGY9YLaennG7fA7bR+QEEoTtDnh/tu
         Ml0AZdMLTd3kv+GSL8dHkmMPyJYkbNH+PkKgJUucFI8+iYmBUsvTb4bidYcB2da0+hGs
         BuEJtMmdLZEEUCTIbnfmihLI7okNfm0YeOWKe8MF5W7ALKubnBFyjCbkhbPlV3k3gjJ0
         w+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750200111; x=1750804911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88AIS/uYpf8Ers2JSTN9a2I7eTl96ZTUl8zjwBbs8g8=;
        b=YK8Imem6qB66p92hupMho/DleNlHilB+S+jtwfZUw+CiKC7dJmzKfk6B4vF4XCjD6r
         ZceAwIXsNeBRK/anHzYTJIAfHuM33/8QPUz+4ewbDs0CJy9V57ZlULRVPOha+dNTHtf9
         jdRWs9X45NJwO/OuZmRxqYxLSIHKaRQ73w6H7/yfpR89tzdqnOpNCo2+4MCgWuTlQbtA
         jt/F9Jl+RqSGLSV8ESvbPSCPEHToVeAKfBP/ZzKdar5JrsRydTHs14zFnwuPEDqhLu2K
         50hvlqghFPMbfBZ68/5X1P+Jid6gJqNEFBl97/zfVJD/Hizo+aqg6kXve5oUj+4INZim
         QjCA==
X-Forwarded-Encrypted: i=1; AJvYcCVQyIEjrBtVFwCRSZUQiUKLCIQxfMfc8fOl5sP3Gxk1SOg3q4FApgaraHdraDanVtaWs4EY7CmftQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMULs9ar3EMZkNmr1JkML+A1ABDVXZHFnYX65iHxu6IBwVval9
	oDTpYzXnYWZG9CWvLBXARh/8ykS7WSPlSGtZsyrzqNsVYWJ5SkmojOLL10rGyB/7eKc=
X-Gm-Gg: ASbGncuYkOxNKSbirPmBK/z7GASblN9w8hg2C6r/Tp7J5E6ZFVGpoaoJuw2WVG6tNww
	4sHgJlJ/h8mbBUrKN+Jsl/+lVbTF6nsoUiz7za3Wt30FO9dZZ4CHZp7fiChLKMbe9byL9p6A788
	DG/m7v8jw4aaGQL44EDNMKZO9OeWVAnTJ2XyCEPJHxaAC5UEy5J4Kdp75pUyMzKE3/pWbtygsMP
	deZG4oZ8A26/JyWRCdQuUciTV9Sc+VSn/0dKB7q+RzP88vN75c3E5C2I6wCfe1NSPfewSustXrL
	8Q5UOxvn5cdhbPO5X/oaaAyTycXOpGHSODEz0Bds+yOcinZGZJj6o2AVGcE=
X-Google-Smtp-Source: AGHT+IGabjx/K+Ldb960ZHsK5LrY46RJJYXxfIDNiBSQIP3DDgEsXOqQ/dovSOae+v/UL5y7DOAm5A==
X-Received: by 2002:a05:6602:3ca:b0:861:7d39:d4d3 with SMTP id ca18e2360f4ac-875ded02b89mr1630771439f.3.1750200111327;
        Tue, 17 Jun 2025 15:41:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d572b8bdsm240271139f.18.2025.06.17.15.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 15:41:50 -0700 (PDT)
Message-ID: <0e5399ff-c315-4810-bbdd-18c95a2afe78@kernel.dk>
Date: Tue, 17 Jun 2025 16:41:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
 <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
 <20250617154103.519b5b9d@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617154103.519b5b9d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 4:41 PM, Jakub Kicinski wrote:
> On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:
>>>> Sounds like we're good to queue this up for 6.17?  
>>>
>>> I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
>>> net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
>>> LMK if that works.  
>>
>> Can we put it in a separate branch and merge it into both? Otherwise
>> my branch will get a bunch of unrelated commits, and pulling an
>> unnamed sha is pretty iffy.
> 
> Like this?
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens

Perfect, thanks Jakub!

-- 
Jens Axboe


