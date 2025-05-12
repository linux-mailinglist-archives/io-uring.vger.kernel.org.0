Return-Path: <io-uring+bounces-7950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EFF2AB39BC
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 15:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A707617E43C
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 13:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC781DE8B3;
	Mon, 12 May 2025 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vpvJP8n6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661881DC9BB
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747058066; cv=none; b=U4u1W7EkkQ5OIFaGUyvnZTuOtMwdmVwjI4R1RHnGRWE8fQ/N8cuH3Z/PElpvzHHdZ7zH7Rh5l96fqTqhxUxHCFu0jVHawcZ8I2qA8mYTfug6tEq9J2+aqJtxV1TjDD2P8LKOwrCy8ebPwA60pKYXLCCL2S6D740YOXXx9qPh8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747058066; c=relaxed/simple;
	bh=K5So4E+5ZzIEkl1ufQUddd0Ww7QeK3E0fAkXYOcdhU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UBu6Wvc5BTz7dDfqyJ8A4NA6x7agU3hEepf8ILTkQtThpc+gWbtQ8k1g3wzTbKvilZo0RGjJRCTFY9P8m/75emt7VZOJQUUYp11K7wJQuC53sy/WlhPaW9NXU++gdg+Rkqog6pR8JXXoDLQjaeRlHkiZ9aY2sNfBV6qgTI0eUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vpvJP8n6; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d96d16b375so21363205ab.1
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 06:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747058063; x=1747662863; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QZC+FT+3/ECRzzto0i4IWsZAQZXeUa7QBF6chjuUw9U=;
        b=vpvJP8n6MNTRCNU2W9iI2pgl8kdqt7QS+yg4fjwpaNzbo4x3wI3W1YxiMHznkpjvDC
         lut6Y44C253K8ULt9Jtwi5OgnYPF1/fTr7P9NfxxfT5namjbMT+MBgzFhhFjIegb9sbl
         SjxrceRsrQGFVNE/s2OmCM3yF/sXdQm9e9XyVrZRzVALGgiWEOZ+KeS7qgyFrf9gVK+0
         x5M4tRjfZ22t49CdNExujmBNosf2IXykAltgoPgDVJn6+WUNXLS56mm3ID3Ia4d1V+xC
         SowoGj2I+DVQdyt+/um0tO03AZST3oAKf486nSWmIjZf1aLkHS4MlB3cHyPLEgc0IgKL
         YuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747058063; x=1747662863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZC+FT+3/ECRzzto0i4IWsZAQZXeUa7QBF6chjuUw9U=;
        b=loqlOTys5JYsV6GhebAHJNvL6C6+ZuJTz04++u6WqHq9CIAfhYsimQwwHhLlKTdFDQ
         5o2Uz22qnIX91wbRfeN3ZMrvYSOA0GBqzqyJXIEG8cA8bu86EulGAmIwpO9ON3b4dK4D
         l+wrNcy9Za6JLx6mRIR/adqzwAewZbjRJ5l4BjGV4GF8oAM4+bNOhyx11n4xAOSPZUTd
         TBmf5bLdmmnbm6fhNa+UR0m/vZ+KLScTDrxE0hO9gpGkoy+UYBQpyAfAZEzwJpBraNCw
         ohooiF3Hfgl+okGQm8Qhnjl69dmfHSJl+SztlBv0bp4wfDI3dy02N1mTlMlhR405y8ai
         OpXw==
X-Forwarded-Encrypted: i=1; AJvYcCXelmlXio08vtvVHhs/9Z3AT6Wy3NwaFaCC+sMQdelmID4dfXOIYR8WWugQhluYZasRkavx3gNT3g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3FsADblmQjxXtcylGPNiTgU/DE/ayivJB3kCI8ob1RsTxFSCB
	Ry8WVCtuudbt05bSJQoOGiOuiUSQxhSlMp1VNXx9lCkO6PKla1HQwa1p5bjGdUUlZGQOkFRlsDw
	G
X-Gm-Gg: ASbGncvP4mLKn4D8rVVXGAkzO9Z5+/WXvkVSFyy2kNO+MWHU5LtMMfWxbBrw+vLlC22
	rVHYUDfAYdK1EMczTCU3GOAhcs9FQej+ONzEIlwExfumOH0ujpXso4yBjuXI661LzG/Rk3wK4Yl
	vGwUtU92cL/LKNdvtPiuo+QCX91pz9pMwm9dCkp0IQvi59TIqeOITnAunAS0XzJXfbiwZew5pMw
	0Z8BRGQbxCYkxvVcHGi+1AicIi32HrYGh+mSM8WRwSS3exfGbtTlYfqI6uFYA9juVaRzmjooGLW
	b3DlvyzWI2+MN0dWo1Kfp5upOQ+4bHvJC3v/TiPfHPOffp4=
X-Google-Smtp-Source: AGHT+IESipRbGRz4tfvO4FQjbMwuam0nD+n0ts7HYyu3uaEbEV6EYRjVrU9gu3XpnQ0tJtAs/YvBgQ==
X-Received: by 2002:a05:6e02:2509:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3da7e1645b1mr145890065ab.0.1747058063310;
        Mon, 12 May 2025 06:54:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e161765sm22769985ab.67.2025.05.12.06.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 06:54:22 -0700 (PDT)
Message-ID: <c2f9f8cc-a05f-4167-9b2b-ab083ef1548d@kernel.dk>
Date: Mon, 12 May 2025 07:54:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove dead code after drain rework
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <24497b04b004bceada496033d3c9d09ff8e81ae9.1746944903.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <24497b04b004bceada496033d3c9d09ff8e81ae9.1746944903.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/25 2:01 AM, Pavel Begunkov wrote:
> io_drain_req() uses a helper function for counting the number of
> requests in a link, remove unused open coded accounting that
> was accidentially left.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505100200.cyy3V6oJ-lkp@intel.com/
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Should also be fine to squash into the original patch

Squashed, thanks.

-- 
Jens Axboe


