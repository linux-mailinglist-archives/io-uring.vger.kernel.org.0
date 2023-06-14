Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB06C7304AB
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjFNQPD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 12:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjFNQPC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 12:15:02 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734C4210B
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 09:15:01 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-760dff4b701so66484839f.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 09:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686759301; x=1689351301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QqoWj6DXTQFZb+D9M2TrBVvRLV18GMfvul29IQg5Gis=;
        b=D0rQKJvogSBcL6Ew/xXqeIOkKjP5e74xrqeBAX3dE5kr8SvhvWqE/D34hWswLn3JGD
         +hu1n20ssaF7MldK4cZeD1JoQRfWJhgb2f58Hr2LAhHFB4BFn34+2HE64bRhv2+mT/qc
         YFdBhceVz8T0h2gQnCaQeuC6+Zj6OXGovY/KQXy2P0y6i/PuAqW/+z7Vy8a4A8bm6NOo
         1UDMEbuJDlpfqFkCtpjbXHNwf7sKpfvUBG5mvbghLBR+V1EsVQkCEtnfB6OnaKmTA2XL
         83W6vBU9YkxnqN2DjDXUW75Xu/7/BwK3aKzL0OaQ5UnbT5Du34Sxhao3w4G/mxxHNiEo
         ReJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686759301; x=1689351301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QqoWj6DXTQFZb+D9M2TrBVvRLV18GMfvul29IQg5Gis=;
        b=BsRyDsysGeNufpqNmiTVTOxl4WIuVc5THdAn9VoHt0BUmqm94zJgHRIEleLbggJTuY
         MSL90Z8q5yoJoKwfUzGlaDOhBflJiWN0g1wNr9C7wnlFYdzGSCejMk3UIbPA7WZfZLP+
         XwIqVnmhJmp/msIXed48BVaat/vTYWyaAxjqFXvyXdwl08ypympCMHFBrtlrHXTYIUQO
         nNIcy6R3Zp/NQmXxPf9GycCdtEq2oIMd3AXjj328sid1eGuEcbrfQ9ccuW7C10TrJA8S
         I6xB2QN11Ek/6tYcDz4PdrrZupJUeICOREQlzVhQeGCDjTPi0cbBBw/eAjRp09qFdlGo
         meWQ==
X-Gm-Message-State: AC+VfDxw5+epuoSEZ0vhD/CFCY7HL3EisOypiud4s+KfCbka7iW5pHuB
        3k2gH7ccJOGJIYDcxTIhiUSqFQ==
X-Google-Smtp-Source: ACHHUZ5ST2haJD41nbXw8NLonRVc10C5MxNRZnlLDvSU9Ipj0PvMrjMi2qQ4z9uyf738G/kKTadVQw==
X-Received: by 2002:a92:440e:0:b0:33b:e24b:ca46 with SMTP id r14-20020a92440e000000b0033be24bca46mr9516858ila.3.1686759300824;
        Wed, 14 Jun 2023 09:15:00 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f27-20020a02cadb000000b00416789bfd70sm5112511jap.1.2023.06.14.09.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 09:15:00 -0700 (PDT)
Message-ID: <eaac6a37-66bf-d244-bf08-0f717feb495c@kernel.dk>
Date:   Wed, 14 Jun 2023 10:14:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/kbuf: fix missing check for return value of
 io_buffer_get_list()
Content-Language: en-US
To:     Chenyuan Mi <cymi20@fudan.edu.cn>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230614151246.116391-1-cymi20@fudan.edu.cn>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230614151246.116391-1-cymi20@fudan.edu.cn>
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

On 6/14/23 9:12?AM, Chenyuan Mi wrote:
> The io_buffer_get_list() function may return NULL, which may
> cause null pointer deference, and other callsites of
> io_buffer_get_list() all do Null check. Add Null check for
> return value of io_buffer_get_list().
> 
> Found by our static analysis tool.

Ah, was going to ask about a test case, but I guess it doesn't exist.
I don't think this can happen, as the legacy buffer groups can only ever
get added, and only get removed when the ring goes away.

-- 
Jens Axboe

