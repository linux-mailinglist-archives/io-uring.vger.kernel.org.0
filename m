Return-Path: <io-uring+bounces-9909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8C0BC11A4
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 13:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9A6CA34DE1C
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 11:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE612D9782;
	Tue,  7 Oct 2025 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RfbOpB3J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57F192D68
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 11:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759835533; cv=none; b=GWdH/Xero4chjbdFuYZ1ccScrNzxWcS1ZrN012eVrRUVhFeW+RPTsH4s3HvXTXJUHiNCwFcE/8yF4Era70qhvzBNTTd+8aZKZNtV07TX4vTv/E1LWycG98HzcZUwLrciDb0/lr7NV3vsYjQxjzoK5w0eQL8M2mz8i5VlEIRp59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759835533; c=relaxed/simple;
	bh=0tRTQVIxs/q5Q+Hy3g5FmzBunJcJwAq3/m8TJlQzte4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pfYIZLorz2ikSGUmSICBe8L7Q45IKQC1gyL/RIs9J9D6p6PRjVu3Hp2RWQ/8oQi9fbd0tKgCtdMTclwQxRceM4GXUctvUGkwSnpulwN88+vi5eBPkxEKQ+INoC7GsEojGgj6FJv4UYfFXiQw85yFAySBLbMo0UJG71NF1YpqxFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RfbOpB3J; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee15505cdeso4865866f8f.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 04:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759835529; x=1760440329; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ocYnZTYhvxaa0KoO8huddSXbdFmRkGMfcfmF/WCGuz0=;
        b=RfbOpB3JGA4TYkT3UFFvRFQqZ1wThfcWIci7RLeJH9mYX0kZAd8YhC/CjhZwC60+92
         SKmaKLO/+oncK6PbOh1pEZDEm99EmYFjUHhpLvYYrHFZtarJ8LwHeAG8gfOPNHDUG0fs
         sngMzwmrUMPuza9pTF6gYK/N0pJam3M1DV17SxxvC5CIaWbtzEF8W4fT0tJbYaVYc4+g
         Lho722Vugj4wxLGIkwjqESKR9Xkz4cU3P+cxe11Bf/YyK0EUfwPjjOERr5dy9BxeoX4m
         dNFk44JksVxR8nDTpnIHnitAcxeg7SvRzAAkglJY7Ejs+r7xJN6UFvA938JJg4G3jlVD
         NLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759835529; x=1760440329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocYnZTYhvxaa0KoO8huddSXbdFmRkGMfcfmF/WCGuz0=;
        b=pLkCJx7XBq42ToLp+tpfBv4tJDKxU9WQS3KFIGv/A+y0VN2ZAfjLXpfQ3R4f008ejz
         RbiciLfvpP5JPmKTjloAaWdrhrnTPx8D1dpT4V++E5KZAobivd4BZX/7CydIzdYsJ8N4
         krfW0W6Favh3jZCQ3UW/x26RNJuyjTadJRecqg7/rufxXUnE6vxMrcz2MTSM8gz2osQ+
         T9xDccNQQX226EBulZB5aYdo/BLOLyhwS3Gvqm04RQpZ5AkPDrv6pf9BzS06WVusnUS/
         0uEWcVFGbZa2JPhlZjDYDiz0qT6t/6Bf6Q9ih6wTNv5aBuDovMI/eZLUT0m2A4St1/h9
         tm9w==
X-Gm-Message-State: AOJu0YzG/ZJVHvhk/YWV1Nyff5Fpy4/gtAroA3hjFoMPLhbD6C4ZuuuL
	cJWbRc4ZgfRb1CKMJ7xNko3vEPeDeGdO8bVTefLr9uDtrADgHT8jibuh4VCZsg==
X-Gm-Gg: ASbGncuigR8GwplBuTgECUSNqS9vLKhGoCbskaLG1KIUftYPveYWrziarmGjqVOK2p9
	lCs7r5jE6BUO88LfVYH/ele4VNiWj6E7nuNAFzkywofWdwGFXukrOupAd6PAyztG4L+zg3IgvPA
	p2KdY0rAgyu1me5u21tDq36GRng2crBdCuyTYxEr19C6GEqcQ6wxRIRAA2TfGUlYP8CznptEewj
	dUxUhBunAYpLwXpK6bTcnQu9eJLCeaZPMv8HhAQ3Ak+rtbtW7pecx3JDBapfa//GlZGYQfk6/Nn
	THatVgQRs8EOjvtRb8woCqruNtU3g0CpyHeqKpPrzr01IBJEEX9dHKID/hPJozE1w7fjQbau0it
	Mg0nmoNOIOLla7Uk0l52IOM1jaIyVZ6q9nALxA+ksb8t3AXSxNbXzVfGuN/bxzEqBG/nbTrwTqN
	LdPB5Nr6hHthPPF8etqXnpy0Pyn/WMQBwY
X-Google-Smtp-Source: AGHT+IGN+cc5ZZpnHcEXI8f0KHWUoIw898vV1d9Wme0Eh5+yRRXXdczmyz6c9IhuGVi+7ydolzC3Ng==
X-Received: by 2002:a5d:5005:0:b0:425:8334:9a9d with SMTP id ffacd0b85a97d-42583349adamr1261124f8f.1.1759835528500;
        Tue, 07 Oct 2025 04:12:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b40sm25122214f8f.2.2025.10.07.04.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 04:12:07 -0700 (PDT)
Message-ID: <584d69ee-512a-4940-8348-d67f8b57fce1@gmail.com>
Date: Tue, 7 Oct 2025 12:13:46 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/zcrx: use folio_nr_pages() instead of shift
 operation
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251004030733.49304-1-pedrodemargomes@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251004030733.49304-1-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/25 04:07, Pedro Demarchi Gomes wrote:
> folio_nr_pages() is a faster helper function to get the number of pages when
> NR_PAGES_IN_LARGE_FOLIO is enabled.

Looks straightforward, I'll take it into a branch.

> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   io_uring/zcrx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e5ff49f3425e..97fda3d65919 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -172,7 +172,7 @@ static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pag
>   		if (folio == last_folio)
>   			continue;
>   		last_folio = folio;
> -		res += 1UL << folio_order(folio);
> +		res += folio_nr_pages(folio);
>   	}
>   	return res;
>   }

-- 
Pavel Begunkov


