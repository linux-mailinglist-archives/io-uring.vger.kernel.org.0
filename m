Return-Path: <io-uring+bounces-102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B847F1800
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 16:59:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BE601F24526
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 15:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23361DA29;
	Mon, 20 Nov 2023 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kgmA+AVf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32CDB4
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 07:59:04 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so34054839f.0
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 07:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700495944; x=1701100744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BBubMyXeMdXPmziILbLDJOUb23evjUP9zHHjc1m1UWU=;
        b=kgmA+AVf1bqHdCcIeq04xHRa7SIKk9mZkp0aX9jE6fjDInfjNh1/bkr4ZQjGRs0Vuf
         4WbKUfFUmZyPkW9eoVSTQSKXSBNoEvzfelmquMgjfcr5iIIurskd2j8ZOdrF+CZd/YJJ
         Nvudq3O7pGhAdLOwDFqOJB9KNEuV9NvBiRR/2MB431cqmVUh1X+mKutocpRWzejItpxJ
         fhqqF3zCpc53p8zABT0vvsjSmi1WyT5t8n9KN4NLr0zWEGMw7klF1Uba+bZL0+lzV3gd
         sCes9BBdz54oAMT3xwZJPPRCfAJw0es3VTVVtp0yzGhWLPkQ1qRWWz55ZajBwCg3E34v
         9rrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700495944; x=1701100744;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBubMyXeMdXPmziILbLDJOUb23evjUP9zHHjc1m1UWU=;
        b=fc23iMTd4tLYx09l+28bnP4sRjUKIgy4Tna829JMabclgYMatRLcBRzNJIbWdfaJUa
         F7mIf1nuiUejylwpCAo+2xhyiseUcPbTvyGxpkvUyA3SxnqHOlAMdonk3rTJv4cCRkT8
         C8hW9YPLMu7dVC0OwTwXKCnonqS3onm3OWm2Ye/zI312s4M1c49OZPu107pvs4VHB/z3
         YUcnT9NWh5ioDrQZ/yK1c18IIjDSjNEhNnE3eXe69uw6nETj+WZFzJ19lAh0QEnwfEUp
         /k18jQY/KIprox765dIyJjhOuGIeokeY5AylR/a009eskQm+3kKJzZsjfbwZ8qEQc+XR
         blSA==
X-Gm-Message-State: AOJu0YyBYGSpice9/lNp80hjHI+9QTaLA5hPCid3sgVVck94uP8NUy2/
	cBJ3hTv11iGmkXQYfuxKLedONA==
X-Google-Smtp-Source: AGHT+IE5IFdCpMdxEiBvnNeLaVyJT3YUK2ggFvrK9aO4Q45E4aJI5sPQZ8IpJpBfrP5cXZo9/UGbnw==
X-Received: by 2002:a92:dc81:0:b0:35b:cd8:7785 with SMTP id c1-20020a92dc81000000b0035b0cd87785mr997896iln.1.1700495944338;
        Mon, 20 Nov 2023 07:59:04 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v10-20020a056e0213ca00b003593297c253sm2522408ilj.75.2023.11.20.07.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 07:59:03 -0800 (PST)
Message-ID: <8818a183-84a3-4460-a8ca-73a366ae6153@kernel.dk>
Date: Mon, 20 Nov 2023 08:59:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fs: consider link->flags when getting path for
 LINKAT
Content-Language: en-US
To: Charles Mirabile <cmirabil@redhat.com>, linux-kernel@vger.kernel.org
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20231120105545.1209530-1-cmirabil@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231120105545.1209530-1-cmirabil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/23 3:55 AM, Charles Mirabile wrote:
> In order for `AT_EMPTY_PATH` to work as expected, the fact
> that the user wants that behavior needs to make it to `getname_flags`
> or it will return ENOENT.

Looks good - do you have a liburing test case for this too?

-- 
Jens Axboe



