Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604C86F7328
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 21:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjEDT1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 15:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjEDT1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 15:27:36 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC37AB4
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 12:27:33 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-763970c9a9eso2279239f.1
        for <io-uring@vger.kernel.org>; Thu, 04 May 2023 12:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683228453; x=1685820453;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FLj2Iv8mcMb8PQZbE5/bOGODHpBaLUqjhieHeG2zWaw=;
        b=e8YZhsVB1dJuc2Z27t7pe3NDZPDnB5Jxy43gxwxpuaPglSbnIXxdTwr/iTMyRoS98R
         f0NQDmFEIFTkTNV84B0D9jA/F6mGL107VNgP63bqOHSXQeeF5AB4bAieAgTmngkJMBqj
         Iorhc2e9aN3Fi1dDYKW/6U8oaKFXCkO7OePu3qKFOSi7KEMy0fdKpyVOG7WY5Ip7b6Fv
         vkUEvPF23ootvN5rehIDlhIahAQvCYXDLn2QPNQDS7p3Dq3rBQLkAxu3JhoayUcxGwVa
         QQOzXxj47h8PZnNQO+4wGuVTUoYqyCgh0GWRXCiDC+XR5zgRNmgSkZuTIDl/FEJP3Cd/
         TCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683228453; x=1685820453;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLj2Iv8mcMb8PQZbE5/bOGODHpBaLUqjhieHeG2zWaw=;
        b=lgIEdq77FcUfHdMLgC1npy4H21bfG5oIqjb1C9WLkaEY8mW4kAt3RWMeF+RQ0M+HF6
         BtsDodSoyjdVNtZYXmTkNKatjMwrkYgqCOusOvkC0c9bbzFHYo1WLxwB1doofChLgq2H
         kxUD3wRTKDNFRfLfWVYXqg/UgOsdvKqUfhNhFKvITLBX0N+iBEwSbSBPTBmykN8lP054
         ZenZWOn3QWdngVoqq86MalWzyTO8Mi3OlPIBA/AI8cuZ136ZM1Cf2muo3j6e+3JpLnra
         pazwnDpS2Jgls0cqUHC/khmstGr1hPoupJY90GV6ciR6lhaSUFmXZRQvhTUEslYUVcuC
         H8Qg==
X-Gm-Message-State: AC+VfDyabwOlgaJT60DFFth74J58xJjxOo+AwpmsRjA/lsiJ5vBR3XlL
        Zv3iK2jGs8cKbXEolOf6zXV6z8u0S7hyABdIx9s=
X-Google-Smtp-Source: ACHHUZ7sKALwzJ1fuJb3CgBfxQoPXPTRX+zzn8uXOvwFmt/rzClFu4i8JasB/j/UDnboNp00GGYMXw==
X-Received: by 2002:a6b:3e57:0:b0:763:542a:f26e with SMTP id l84-20020a6b3e57000000b00763542af26emr5630010ioa.1.1683228453121;
        Thu, 04 May 2023 12:27:33 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eq18-20020a0566384e3200b00411b2414eb5sm51582jab.94.2023.05.04.12.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 12:27:32 -0700 (PDT)
Message-ID: <6171ec94-150c-e277-d495-aaa3e1d694f7@kernel.dk>
Date:   Thu, 4 May 2023 13:27:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: io_uring is a regression over 16 year old aio/io_submit, 2+
 decades of Microsoft NT, and *BSD circa 1997-2001
Content-Language: en-US
To:     Reece <me@reece.sx>, io-uring@vger.kernel.org
References: <23940f55-9905-4e4b-48dc-31d309c9e363@reece.sx>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <23940f55-9905-4e4b-48dc-31d309c9e363@reece.sx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/23 1:20?PM, Reece wrote a pile of garbage.

If you have constructive criticism, the list is open to discuss it.
Sending trolly garbage anonymously is, however, neither welcome nor a
productive approach.

-- 
Jens Axboe

