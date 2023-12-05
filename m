Return-Path: <io-uring+bounces-228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F15AE805459
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 13:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A72CD1F213D0
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 12:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5B83C48D;
	Tue,  5 Dec 2023 12:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zNdarjWd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FB51AE
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 04:36:56 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3333a3a599fso1657477f8f.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 04:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701779815; x=1702384615; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lq9Rg0YreoRF3xpt7wQKkV03N9XWMTQ7WfFbqJhw0lI=;
        b=zNdarjWdDSRTUOj633JpPcubhnFO7aEA8DaqI4u8ctm3b74tpJ1BnGHO5jwoVjsxyt
         3fbGYhag3+Dv2hAejjMDWOgRAk4b1kb/RaFyoE7aQJ+aLnjknQmR+3biZciCBQuL656l
         U1vT3sJCmfkz6aG4D5/Qm6E3cOuwVZPzjaiZ3mLjbR8JWJhtUJumS3/+CNijET2cLj0k
         gxc7RoLciySb3bDolcDfepAlObAnlBpYOuZwQ/5zap04q8HANaWwVezJ3LHqJqJkomP2
         qVtHdSuRBNHV2WEW9QIQj3PSi9V0UfJx+IdhaY7RqVuqVSp6pxh8nnrVE8bRqln9zyIz
         uDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701779815; x=1702384615;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq9Rg0YreoRF3xpt7wQKkV03N9XWMTQ7WfFbqJhw0lI=;
        b=qeue7y4wMpcFriG26euIePs/eQg4HuEvi0XRVVapLztxrJ7CaDXnpPOj8JenQVdBSa
         DG10Sv3/japi6PX3f+irTjD+aeyghYDeNku7l/L7fFkgg8KF+nIUmHkZg7sf1hZaVLhe
         T+s8409jD1XAYbJuEXfdQZGP70sdQ/m4wI25TbV1Sc9XZOq7sNssziz4Mg60n4EFZ/LS
         p1UUUBZ2vWAbLrWPU1uWuPi2LEQoDIvRRcIH2o6EEEsZtBoSMguT9v2mEyl3OKyhOuEM
         2slrQ6YwWZPGGVyc0eDpCHrbxKFsAW7tpPUMkBGCM4GIr7ocsWOW8+OgrDNBCdKAFsfG
         t7KA==
X-Gm-Message-State: AOJu0Yxq00+w9ZfOrB1yFyw2CShTvy1rd0rPuJQOQzaew7D62jppp+ai
	BpSVuO6tptrlCXHE0m+abogeBF8K1thUizGBdc8=
X-Google-Smtp-Source: AGHT+IHz5wL+rNeT5Ls5SBEOgspwq+7Tt+nvRRjtapYG0Ovyf/tXcniD/quRS2EQmEGjVc56/322Sg==
X-Received: by 2002:a05:600c:4927:b0:40b:5e56:7b64 with SMTP id f39-20020a05600c492700b0040b5e567b64mr556467wmp.173.1701779814693;
        Tue, 05 Dec 2023 04:36:54 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f15-20020a05600c4e8f00b0040b3632e993sm22180892wmq.46.2023.12.05.04.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 04:36:54 -0800 (PST)
Date: Tue, 5 Dec 2023 15:36:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring: free io_buffer_list entries via RCU
Message-ID: <9a411872-46c3-4652-8704-d1610f547583@moroto.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jens Axboe,

This is a semi-automatic email about new static checker warnings.

The patch 5cf4f52e6d8a: "io_uring: free io_buffer_list entries via 
RCU" from Nov 27, 2023, leads to the following Smatch complaint:

    io_uring/kbuf.c:766 io_pbuf_get_address()
    warn: variable dereferenced before check 'bl' (see line 764)

io_uring/kbuf.c
   753  void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
   754  {
   755          struct io_buffer_list *bl;
   756  
   757          bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
   758  
   759          /*
   760           * Ensure the list is fully setup. Only strictly needed for RCU lookup
   761           * via mmap, and in that case only for the array indexed groups. For
   762           * the xarray lookups, it's either visible and ready, or not at all.
   763           */
   764          if (!smp_load_acquire(&bl->is_ready))
                                      ^^^^^
bl dereferenced here

   765                  return NULL;
   766          if (!bl || !bl->is_mmap)
                    ^^^
Checked for NULL too late.

   767                  return NULL;
   768  
   769          return bl->buf_ring;
   770  }

regards,
dan carpenter

