Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE573BA13
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjFWO0L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 10:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjFWO0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 10:26:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0217B2681
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 07:26:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6687b209e5aso107461b3a.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687530367; x=1690122367;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JYu13eONCNFmjIPXSm+Piyo6Z+O1GMrrjDqpnbpbBY4=;
        b=ue5D34tBN1Oc/U5J3UbcLzikCv04JzE6A/E3GCcyct2rXeAhT3pMWjhgOw/srrkvu0
         YxylFZiZI5a5KTO8vc0KTQeDSB1W5S7eqgYlaSFRsmiTpV86m+SjvSziFBGv+eMcjOJ2
         uC9ok9oYh22/OY5mwRpjc2ZrMIrP5xqtUjvXnVwtQMKYYzyMD90qA8nBCBDD70/7aF9i
         BaEkIj0GiiUapLEvD8StsNA/NKJMBGqWDRNhUsv5AG9lXBikBc7S3S4hvsT3Zidubef+
         s1kSLxL3yJI7TNmtfB+8vrVIyjJqvwUpte9aCWzEq3UAPF68r/h/fS7SM70ezBiFFQ33
         Pb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687530367; x=1690122367;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYu13eONCNFmjIPXSm+Piyo6Z+O1GMrrjDqpnbpbBY4=;
        b=XuVNYxl0xFf0ZNGbz/TjTZJDvyJMRJP5p28B88HVty7Gz+89cYo6f17X8HXeLBLmwo
         pALukjAIZPQyZ/Cs6OVEjMFXVc+UtTZ+kVk6m95Y3rqQVVM0LYeE+ifvw9wwa1ZimPoK
         qwodp4S00JmPRO5MV8h6KOlgjkecpYTevE1z8LxKEryXnUJ2ZtthB6LcuiFVARP2Ofem
         jbrAkFbwvAnuNgObHU4g7Jf/sM5oYgTyHHf6wHhr6lro6/BodqL+rmLAqSgC/KJVIIJV
         JuZUNZp5b563e0BKaga5vkEJug2O6r+qUJhonnqSLqQ0Jbr8g4ATWennRZIKf2IzyCCG
         kg7Q==
X-Gm-Message-State: AC+VfDzaBQkEtR/xb9IA5rmrl4C5ZYUYw6K2/a8zi3V++9gARbBqnph6
        VhA+a0vQr8QkiGCY3rYLRp1US8c5URdBShqutO0=
X-Google-Smtp-Source: ACHHUZ6O7KpOOIkmkCMlpIYyuBMqGgpV7GMlTJmKvt0ZoCDIKZXvQnw3lOv4D0kO4Saa+i5BhY7SjQ==
X-Received: by 2002:a05:6a20:5495:b0:121:9d6b:51f3 with SMTP id i21-20020a056a20549500b001219d6b51f3mr18304443pzk.2.1687530367413;
        Fri, 23 Jun 2023 07:26:07 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x21-20020a056a00271500b00663b712bfbdsm6177391pfv.57.2023.06.23.07.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 07:26:06 -0700 (PDT)
Message-ID: <2bff7d71-662e-aa95-1bd0-72089482da50@kernel.dk>
Date:   Fri, 23 Jun 2023 08:26:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 00/11] clean up req free and CQ locking
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1687518903.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/23 5:23?AM, Pavel Begunkov wrote:
> Patches 1-5 are cleaning how we free requests.
> Patches 7-11 brush CQ / ->completion_lock locking 
> 
> Pavel Begunkov (11):
>   io_uring: open code io_put_req_find_next
>   io_uring: remove io_free_req_tw
>   io_uring: inline io_dismantle_req()
>   io_uring: move io_clean_op()
>   io_uring: don't batch task put on reqs free
>   io_uring: remove IOU_F_TWQ_FORCE_NORMAL
>   io_uring: kill io_cq_unlock()
>   io_uring: fix acquire/release annotations
>   io_uring: inline __io_cq_unlock
>   io_uring: make io_cq_unlock_post static
>   io_uring: merge conditional unlock flush helpers
> 
>  io_uring/io_uring.c | 223 ++++++++++++++++----------------------------
>  io_uring/io_uring.h |   7 +-
>  2 files changed, 80 insertions(+), 150 deletions(-)

Was going to say that it's a bit late for 6.5, but looking over the
patches, it's pretty straight forward and mostly just good cleanups and
code reduction. I'll queue it up for 6.5, thanks.

-- 
Jens Axboe

