Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD0598A02
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 19:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbiHRRCy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 13:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiHRRAv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 13:00:51 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A653FC00DC
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 10:00:40 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y187so1563572iof.0
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lYKXgue+zNpIvfPSql7O+R7TEPDE0QJoKDwJiREWf7Y=;
        b=Yf1ObBTNqWoadaVv8CCeNUYTVV68c76B6bJj+OWtTMqEm6y9RVLZxi8pXcWODx7ozI
         ysK0w8bPJ3a3/qEWgxWHSf8bNRPyd+gQ7P8S6Vy+EiuTtxmLhLMP9IGRbIxjif5isELg
         CkB/mjrtD+rDJdFW9t9OnB0z1vy3zsqUsMw+O7MfuvbBQUojyYNprPOTHqsI050/FEBC
         0AUP1wXNqc+Dc8g1iMp63xR65paoeeLq/qNmRaUBSjL51/fm5ViMoCa1vMcMTpN2Hzka
         HZEvd1RftSYXrbo47FE9XPrlCNrx7zuzMGz7N92/ip6K6zZM5wea7ywlo58ZwoXdj0Nq
         rIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lYKXgue+zNpIvfPSql7O+R7TEPDE0QJoKDwJiREWf7Y=;
        b=4BWC4VGNOx/4XrTwunYaSCGBYs0WyZiHt1r6WLHtF/0lCBMKE0zDQi1i2jF33XyWVo
         syn8Oz4UVQVSQ/q9Kwvk2v3MBFmLhtKVgJlw1DsmGQfwnxfkoXInAgSIGNuB5WpwJs3b
         kvyAWsmWMDUw/1mBHmUmWAwFqfOk7ILUsLdpuHLxUti/di6aCv5LVWrJz8xZOssx4yTB
         0jcBLAWrwMQGDp9lBNN9BxtfPgthfFyb/pLGzacUX5Rwr5W9Hp/piY6nngcxCuEDfTDO
         eFoeKAbag3VqgqT6Fuhkhz5ZGFKbIFUsYtVRn3vcX+tSlvzYmFgfBa/bD5BaUcRWvJFu
         hv1w==
X-Gm-Message-State: ACgBeo1t/RHY+ct/nCifAmg44udOikpz2vELy6rTj4up3A/kr/zobn2P
        G5oT547Zy18KrCj1I/cwx5Claw==
X-Google-Smtp-Source: AA6agR5Qa8kN5z58ES35WCTjV5f+v9cONWrgP5RrInMX13yzSlj1T9r40gTJhrGdtS/rCxl6RfxTMA==
X-Received: by 2002:a6b:3b87:0:b0:688:9085:cae8 with SMTP id i129-20020a6b3b87000000b006889085cae8mr1861996ioa.118.1660842039991;
        Thu, 18 Aug 2022 10:00:39 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bp17-20020a056638441100b0034366d9ff20sm754283jab.160.2022.08.18.10.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 10:00:39 -0700 (PDT)
Message-ID: <b2865bd6-2346-8f4d-168b-17f06bbedbed@kernel.dk>
Date:   Thu, 18 Aug 2022 11:00:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: generic/471 regression with async buffered writes?
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        willy@infradead.org, Stefan Roesch <shr@fb.com>
References: <Yv5quvRMZXlDXED/@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yv5quvRMZXlDXED/@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/22 10:37 AM, Darrick J. Wong wrote:
> Hi everyone,
> 
> I noticed the following fstest failure on XFS on 6.0-rc1 that wasn't
> there in 5.19:
> 
> --- generic/471.out
> +++ generic/471.out.bad
> @@ -2,12 +2,10 @@
>  pwrite: Resource temporarily unavailable
>  wrote 8388608/8388608 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -RWF_NOWAIT time is within limits.
> +pwrite: Resource temporarily unavailable
> +(standard_in) 1: syntax error
> +RWF_NOWAIT took  seconds
>  00000000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
>  *
> -00200000:  bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> -*
> -00300000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> -*
>  read 8388608/8388608 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> 
> Is this related to the async buffered write changes, or should I keep
> looking?  AFAICT nobody else has mentioned problems with 471...

The test is just broken. It made some odd assumptions on what RWF_NOWAIT
means with buffered writes. There's been a discussion on it previously,
I'll see if I can find the links. IIRC, the tldr is that the test
doesn't really tie RWF_NOWAIT to whether we'll block or not.

-- 
Jens Axboe
