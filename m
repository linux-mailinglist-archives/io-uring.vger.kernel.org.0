Return-Path: <io-uring+bounces-2571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E3193B32E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 16:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12EF0B241BD
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 14:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D62158D80;
	Wed, 24 Jul 2024 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fgb317i2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE815B0ED;
	Wed, 24 Jul 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721832840; cv=none; b=DL0pxFizTGPEIZrKS7jciXkehgeYXYsFfzKFxwSxeXYxfCy7y9v2AlEXzL3Lx7/FZLdY+erVpwZ6QH5qI+6zdH2q+8FC0L3q1xV5fb9xMoL9ZCZm9vK08bIL37u4nyLyPlBPsnX0YvijpaAlSEqIF0gAa03HcLRa/7sL1eYtOSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721832840; c=relaxed/simple;
	bh=WNzOf9x61mMuDRez1uJMbxBR6eqhL7BIbfckeqnYXUw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VqRIN52TjXGZG3NnJiN4cUr0lYoUz6IDBO6tsDuOYD/Jsjkk39Ko3/ZlAr2js6awnleoCq4oX/Wd1eKF0o0P6zTeMiAtauADE2Tv1X42M2gj4V9mKRqq5mbd1mS0/KWYNtPcO9S+Zmx76nCJEkS66yFaBQzwsndn+YyKc0VBDSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fgb317i2; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7a9a369055so195824966b.3;
        Wed, 24 Jul 2024 07:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721832838; x=1722437638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0MgXC9MqivH0JROXD+X8B13PkkRSopqzKEyAhb3+nXA=;
        b=Fgb317i2hvuFtAow/UpcBG4/qhwm6tpCcy77y9UzX5GXFgEzcMh84X5FZ5+Ho+Vkdm
         aZ0OCDMI1yGiD2Myheyq/tW/VAWYKcIrCVTqUVHPhmumlNFWN5gIMfRKYZHQlBpaTyfI
         GUaGe+tAzEroNaWEA/71PeWfXZNCZNbxJeWp5TJNupFeJvRb0KdCdCdryfxnqS/IcbOb
         NBZILFC3tnHYs+xjXMtjX2GJUTQSWy3hiuzV0A5i/VyxqZShsH0aqIkFZbqf+77KKnWy
         zCpl1nn2yiSR+252UYtOmmx6oCawTV1y89hKmHoMaGFt2nOwq/voD/Wd6qSz/VF83uRP
         St5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721832838; x=1722437638;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MgXC9MqivH0JROXD+X8B13PkkRSopqzKEyAhb3+nXA=;
        b=Gsh/XCSAhxQM3kTFyWX4Y5dxdjXXUAP4ZBT39DeSX+xuh2qlfcR9nlN4dqtlnbvvKU
         1ai3O9Ss2lQ4LG1dFHCNHdv2Bg77TXNyme3H6VwCYFWqvpuSon56fpBgM1cI+c+r0W3E
         Ba5X2sB+CxcoRfFbMl6PFrycp+K7QAWs8hnScxDFyEU3efU52IggcOfXb9ljcfTG2kGX
         IxP8WYU3ninNuMD5lzVCGz4KpmZQyIBALKj1ApMluVw7hPZU2qFQMWvzr0Mq5hUk00F0
         /b023bnd7zABJQrGPyjmFxHZMg2kfEY4Gc4n79CWdbpOCF/nm0TCTLJiT/Y70534Lv6N
         rj7A==
X-Forwarded-Encrypted: i=1; AJvYcCUBUbMRdWbMf/05rfyuVLUGDn/NULPz+a5e/017UVzv8M+22a5t5a1Ds08bT04iBH09cs2qTD927IKYJNIzqTi0xefyQZyqZq8pq9mRfaBjSfP72qxw9iT+OpFnN5j3V/3BEyAiWQ==
X-Gm-Message-State: AOJu0YwK7CmHAVh7gTGOMPpKAc8+pN1XYcQhj0W6gHFWan0ggIwXyohi
	iTGr4PKAsYGrIqM6Lhs9x+r11sSNv2C/2uhhWytFT5MZgrP7TTeCnz2PDg==
X-Google-Smtp-Source: AGHT+IEzhsL+reKAEC2aXIzwA37y8ftrpeNTJ05+SvlV0WiidMattXMPIdgeunWG7gPAVX2yeZ/o1g==
X-Received: by 2002:a17:907:2d0a:b0:a7a:b070:92c6 with SMTP id a640c23a62f3a-a7ab10c3cc7mr173609866b.50.1721832837587;
        Wed, 24 Jul 2024 07:53:57 -0700 (PDT)
Received: from [192.168.42.176] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7aa439e40esm139350066b.48.2024.07.24.07.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 07:53:57 -0700 (PDT)
Message-ID: <cb88fbce-fbae-456e-8f8e-e49202fc7149@gmail.com>
Date: Wed, 24 Jul 2024 15:54:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
From: Pavel Begunkov <asml.silence@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com> <Zp+/hBwCBmKSGy5K@fedora>
 <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
Content-Language: en-US
In-Reply-To: <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/24/24 14:41, Pavel Begunkov wrote:
...> io_free_batch_list() {
>      if (req->flags & GROUP) {
>          if (req_is_member(req)) {
>              req->grp_leader->grp_refs--;
>              if (req->grp_leader->grp_refs == 0) {
>                  req->io_task_work.func = io_req_task_complete;
>                  io_req_task_work_add(req->grp_leader);
>                  // can be done better....
>              }
>              goto free_req;
>          }
>          WARN_ON_ONCE(!req_is_leader());
> 
>          if (!(req->flags & SEEN_FIRST_TIME)) {
>              // already posted it just before coming here
>              req->flags |= SKIP_CQE;
>              // we'll see it again when grp_refs hit 0
>              req->flags |= SEEN_FIRST_TIME;

Forgot queue_group_members() here
  
>              // Don't free the req, we're leaving it alive for now.
>              // req->ref/REQ_F_REFCOUNT will be put next time we get here.
>              return; // or continue
>          }
> 
>          clean_up_request_resources(); // calls back into ublk
>          // and now free the leader
>      }
> 
> free_req:
>      // the rest of io_free_batch_list()
>      if (flags & REQ_F_REFCOUNT) {
>          req_drop_ref();
>          ....
>      }
>      ...
> }

-- 
Pavel Begunkov

