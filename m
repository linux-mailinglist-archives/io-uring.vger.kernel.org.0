Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39FD6D34F9
	for <lists+io-uring@lfdr.de>; Sun,  2 Apr 2023 01:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDAXUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 19:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDAXUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 19:20:10 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CF4AD09
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 16:20:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id le6so24794056plb.12
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 16:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680391209; x=1682983209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+PiZZyFAM1djSoWDmdc4U1VyAR4Y9fKfRL8ScC773gk=;
        b=6b1iovh3KOYqBkipk6zphpNWkTrpPlHcaIzKJtS67OEJHdtyGVneYK+ETyGKNymM0X
         Mbvj+47lhdTiFDe7yoy7sQHRlnTNqEn0bW0E1dJclsQXO1JDKVKce3TMumNBnngxQgMP
         wrsmPqZr0A6vFW5d1pWIS9iwMrll0q8w78y4EGRWWJ6jtyJrHYXp4B8jhnZPo4XQpYO9
         DcpwQntiQXWVM7k4Kd71fkkB07HhjKAET1VNEZXevGOF3vHkRZBL7fqJ8KatPCGhvVNt
         I7Xh1LAgQ/HZ5Yp+4JsDS4Xu8fhfLNtq2GR0IJ5JPwjzObkPIpbcbOvEdnvCcxgQCUqV
         m/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680391209; x=1682983209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+PiZZyFAM1djSoWDmdc4U1VyAR4Y9fKfRL8ScC773gk=;
        b=Vj7jY8B9HjBGlXDEHJ6qpNxUMEUZncwOKPSAXUDqLl1jmHJgk5vU6PDZ09axvLo47o
         8Oap5W1NnTp0MP7LVHg/pKMhcPPyqYtirXNwkdKVRrP0G2Kp/M4USxwgdZYiMapzqbCj
         z+ZhnpoyO0G2h0LHY9NiqdpL0/n+9G+P7PKb14/GF/dWDQOhRYo/q9ZElCDcdRV03heS
         JIAYbvfU5mKe96qt8RLWNnAhSw1oWxmcI7Tivs1x2F22+vjf5sC4USvuDhb1VwkVcs6t
         TKfIGTeCE/KM7HFRGC5p58eha8WHTNFiqvqSl54AdEZlHz4nVOfrfJgX48+owMQEX9Aj
         IqXg==
X-Gm-Message-State: AO0yUKXyynpqPe9tL1zqd8qOsj0xu40er3ORMMVwK8oOJWSzu5SdfXBt
        wykFK+VW7rnECt1d0dck+/HyydI18GEWhkkxgb+rDg==
X-Google-Smtp-Source: AK7set/cg+fOPTWHpoud49da0csl8bSFUZdGm+mqOiNxksOlN5KJDVIQZGE78LHqjk/MtAJoyTr75A==
X-Received: by 2002:a05:6a20:748c:b0:cd:fc47:dd73 with SMTP id p12-20020a056a20748c00b000cdfc47dd73mr37945324pzd.2.1680391209376;
        Sat, 01 Apr 2023 16:20:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006254377ce44sm4104013pfi.43.2023.04.01.16.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 16:20:09 -0700 (PDT)
Message-ID: <9e348f0f-0877-349c-3a58-7e4a80b9cbe5@kernel.dk>
Date:   Sat, 1 Apr 2023 17:20:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/2] fixes for removing provided buffers
Content-Language: en-US
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20230401195039.404909-1-wlukowicz01@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230401195039.404909-1-wlukowicz01@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/23 1:50 PM, Wojciech Lukowicz wrote:
> Hi,
> 
> Two fixes for removing provided buffers. They are in the same area, but
> otherwise unrelated. I'll send a liburing test for the first one
> shortly.

Looks good, thanks for sending these in!

-- 
Jens Axboe


