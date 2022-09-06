Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7563A5AE8DA
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiIFMyI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 08:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbiIFMxe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 08:53:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FDA74CE6
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 05:52:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t6-20020a17090a950600b0020063f8f964so3969925pjo.0
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 05:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rIGwfqHtW9WzkpUNvXNvcoWEtS49I/sGyGVwgJDhuGs=;
        b=ZuDfhLqihY6zE46gerJ4vnbww8+j6U7nbZoSW+NgicAzrVGxpOLpocTZhqyYxleSw0
         b4kkVyRkMqWNNZfYAsdiW0ejfCRozM33wuJwCgOEgiJJoLrZfhQSrGfyQyqCF8yOYPEc
         MtUHiEdDMMOVd1iYw0D0UJ/OPa6FLjP079zVzWZKvs+KaFImSwOyUcXw3Pk0OL9IjhpT
         rifG9D+eePsfq2FukbuBNSW0hsCQL+GKr3yEGas5sHGE6rO5Y0o2nO1vOTrN3MDzgCix
         rFb1m2gQAu9xwf6rxlxRzd316ahX05LbijnEZahbYkdoQG2H8Zekmark9vnCWSrQEOcG
         pwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rIGwfqHtW9WzkpUNvXNvcoWEtS49I/sGyGVwgJDhuGs=;
        b=KnKJIX+ARIaviAtlb8zuoPrKVVWtafvDmKVkifkIGN0C2NPnSO/bMJOXOtYWm8/IXE
         avb7ITevuQGvrwXgj0dG9ub31TJeKQISy5ObcPNykyevz983RfAyQUavkpXrKbIiArGa
         YU7FqWhBZWjxbAIjRbBVPptYW6YtYVMqoSVkUCsbxM2TKYGMsNUN0foPbaYJNMUg18eu
         i7jECt5B8jfSjtWfgbBPnLmpX7ItK8FBSjkElMuvtIJS0rivA7GjXBTsnbGKNMT38OVr
         izLy04QQGjkheCQxPBR1qx29nxSRgb21hlK3mlox4oIkS1n7zTnEkJndZNP3LOkvDK0E
         dfgw==
X-Gm-Message-State: ACgBeo2JK3SOdywlIk9/AglSK3kmbwUOWUo2n+sRgHeWwipRCtfaFkCk
        /FRv6oCkQq0x3JVf2gEuq+WHOCcOcQRZhg==
X-Google-Smtp-Source: AA6agR60UsINQZwjXXjTm/s9NRJyb7YZNpKrnVMONj1GRYqzqafOebZrxB02bCLA7Mlb133LPyH5lA==
X-Received: by 2002:a17:902:8ec8:b0:173:12cb:e6c1 with SMTP id x8-20020a1709028ec800b0017312cbe6c1mr53729235plo.64.1662468774377;
        Tue, 06 Sep 2022 05:52:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b17-20020a170903229100b00176be258f41sm3396718plh.91.2022.09.06.05.52.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 05:52:53 -0700 (PDT)
Message-ID: <b08b7ac8-7111-5328-4277-c393c0590893@kernel.dk>
Date:   Tue, 6 Sep 2022 06:52:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing v2] man/io_uring_enter.2: document
 IORING_OP_SEND_ZC
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e876fa3c0de9d45db41a796eb8ac547e298a8787.1662459139.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e876fa3c0de9d45db41a796eb8ac547e298a8787.1662459139.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/22 4:17 AM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Pasting a text-only version right below for convenience.

Thanks, appreciate the plain text one, easier to review. Pushed
this out with just minor edits here and there.

-- 
Jens Axboe


