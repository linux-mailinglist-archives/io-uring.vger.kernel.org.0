Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D47C6F1D61
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 19:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346135AbjD1R1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 13:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346099AbjD1R1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 13:27:36 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB774C0E
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 10:27:33 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-760dff4b701so359939f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 10:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682702852; x=1685294852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rh6V4tYiLlllRSr0PfsNXhLUe9cYUsXg2EQxXpgmKK8=;
        b=q6MUYFZZqhT76ANijpfoaVA0+tjHHNSOMXOqFpKYothGCxai6tDgo9w2NZDUEzjHpK
         Kt7xDBwNDQjknpnwoCG1kbz09vVe8mPb8p8WSePXvS2bpSfUXvMCEVMMc6yuadU6CX7U
         G8z7LeT7M984KfYVP0u5fxprBvNwvnebY2yDKrWGsLBy7iuwHjSeClT2AucE2J1JG7Qs
         /SkTgEzOlgADHXS7UXQKbBIsiL6z7uFLxM+1XlUD8Ss1VP4lAtbUpiij18c8s0FSXY4B
         RlFTkhAVBl1GvPdPsfSGRWBjQC4PAXLyQQRRf6b+58D5hoz3Gmf4EwJqtQu6uoF0Bhh+
         eFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682702852; x=1685294852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rh6V4tYiLlllRSr0PfsNXhLUe9cYUsXg2EQxXpgmKK8=;
        b=CvY1odK9HEn9ir51uYW1670Kd8KM3HEMzK95Vgz+pOUMJMRbA6sYiHiYVvqZp8IrJ5
         i15IHZKeqA6N3EV2xOaVD2cI/KnMHpI00VEx8D/3roDP3EwRoeZqhymPTxvAWQWepg73
         PiQbh4HGSjWAQqv81iiMYgXeU5ZRBs8AKTeIm3jVLMOf9TIdlvHwmTSpsAjg1OYugPQU
         Jdv9kiE03Lj3ug3cglYnDNVR5jJVKHQTmhVjZoi2P04ZglQooGSv93VaEGX64jCDsYLy
         4yx2+teXxSLcxs06mBV2oTnLu1C8aYFH0qEpmz66jhJhjoUVH4zRIDqJrsRcmmQ0Ya/j
         o94w==
X-Gm-Message-State: AC+VfDzGpmd3Z1bS5Zip5LYWKMH/WLHpJgVBvbcjXEGrzsNH6iVJ59rY
        pxWQouOSAzyFXff9H2QzTb3L7HthhJarZR7qEhQ=
X-Google-Smtp-Source: ACHHUZ7TyzxVowF7SKHydjwyEQVrsACZzNuP633Lc5sSX90cvV9YVZ/rf28aj6JGV291hDpi2KxITw==
X-Received: by 2002:a6b:b412:0:b0:763:86b1:6111 with SMTP id d18-20020a6bb412000000b0076386b16111mr2820503iof.2.1682702852302;
        Fri, 28 Apr 2023 10:27:32 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d9-20020a026209000000b0040f9a41e06asm6398207jac.0.2023.04.28.10.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 10:27:31 -0700 (PDT)
Message-ID: <786c3e8c-5fc3-9ee0-e026-e32a4b061eee@kernel.dk>
Date:   Fri, 28 Apr 2023 11:27:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/3] io_uring: Remove unnecessary BUILD_BUG_ON
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
References: <20230421114440.3343473-1-leitao@debian.org>
 <20230421114440.3343473-4-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230421114440.3343473-4-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/23 5:44?AM, Breno Leitao wrote:
> In the io_uring_cmd_prep_async() there is a unnecessary compilation time
> check to check if cmd is correctly placed at field 48 of the SQE.
> 
> This is uncessary, since this check is already in place at
> io_uring_init():
> 
>           BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
> 
> Remove it and the uring_cmd_pdu_size() function, which is not used
> anymore.
> 
> Keith started a discussion about this topic in the following thread:
> https://lore.kernel.org/lkml/ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com/

Just turn that into a:

Link: https://lore.kernel.org/lkml/ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com/

instead.

-- 
Jens Axboe

