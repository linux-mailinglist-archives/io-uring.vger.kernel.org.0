Return-Path: <io-uring+bounces-330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE0281A3AA
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 581D8283F8A
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C077640C04;
	Wed, 20 Dec 2023 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bHDOQ1Gx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A358D4779A
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7b714a7835cso70109339f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 08:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703088117; x=1703692917; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DcPluFRGpggHy96amEkA7xW2rTce18tDWJabwptLjLY=;
        b=bHDOQ1GxQ8Yp1oP7Z1viVusZcCiM0FEYQlxe8+at0oCig/v/2IjgmLZVFi9AZrrNVJ
         YglNAsSwDkSAwN9xeHW0dK0fQqKCddl5YwX6PA+1Zt6kw3c7RY4578FMhSzxXlWm93Iu
         nAOwKmUv18sVa+JoiJVYq7xnteapWbPS17pQvVJDtYWzfdOmhEvTiA61ew5nxqyQIiJD
         KVrJt5c1c2p3ddC3o+GCtTSuva5LPrtAVdRDeZUDZc4I25SLgz1AKIn+gNDZWSPq06gD
         3JIA6/MwG24sd4hLhV47AmaDo4B4HoFLc2LbtZVD6+dRWBPwXspleP6PC8el1jdgO09P
         vtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088117; x=1703692917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcPluFRGpggHy96amEkA7xW2rTce18tDWJabwptLjLY=;
        b=XjeL5r9kjam2S+JJEdThyxPeyDwBj0AIqZgezhjDYzLkBW5c5P3YBevqAzs3uANMf7
         XEyt9DnQnNIblmfp0o9glGjUByW5lH+MvZslqZVXZfk8+HAsX+6CCmisdElIyr+lGU7X
         AZTuMaQv/8ObqWSpSgMNbC2sxlaFiyloxFgNOx+qPZ9YF9aikdU6O2XozDHT04SmFBbB
         QUxR7JC7ZnA9l3yRorEIKXuAhsDr5p4Pn2dwnGjtrxAo/KzHVIlCd8cqrNhSaR7rQo3t
         GcPWaQseWxOvVpVAWSbIaNV1wlgz8AMac1/V+Df2Z1ZpqLjceHQCs5KWV0kf0ncRoe1z
         VFAg==
X-Gm-Message-State: AOJu0YwPsJsGvd92K49VuioNQYlV7qTsKzOjXqXaoVYaMaYUSjylNU24
	x8oirwvlxUUkbKKPag46dEf8tFrmOrjNloAWS1IX7Q==
X-Google-Smtp-Source: AGHT+IE94XHZiXNj4010rjiK9IYLWbQeslWZq7W3grQ3wlqAe4nOcprSIxzt6Fc/CX1vAmlDJY9Syw==
X-Received: by 2002:a05:6e02:1b08:b0:35f:b559:c2c7 with SMTP id i8-20020a056e021b0800b0035fb559c2c7mr9877173ilv.3.1703088116729;
        Wed, 20 Dec 2023 08:01:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j9-20020a05663822c900b0046cdcd20b6fsm209616jat.163.2023.12.20.08.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:01:55 -0800 (PST)
Message-ID: <57580a95-685d-4920-acbe-dc4e71f70bf5@kernel.dk>
Date: Wed, 20 Dec 2023 09:01:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 06/20] io_uring: separate header for exported net
 bits
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-7-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231219210357.4029713-7-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 2:03 PM, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> We're exporting some io_uring bits to networking, e.g. for implementing
> a net callback for io_uring cmds, but we don't want to expose more than
> needed. Add a separate header for networking.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



