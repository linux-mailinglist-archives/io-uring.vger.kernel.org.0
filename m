Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38D2588F0A
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiHCPBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiHCPBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 11:01:54 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6A43343E
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 08:01:53 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e69so13078808iof.5
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 08:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=LaTAyQuC6zp7HjW7YrOqIxfGo+OzbCrZrQxTTedix6E=;
        b=XMAFzAldVK50WL4WTO9TQkAdU5sy/kqMuzrqilqmhYWd93rO8qum7C8RqdYUdhs1LY
         iEL+Pl7JeO+hQogjbAhFaqkgkgWRAXY+WzJWaN/hcThJDSlcbjTgsVAeL5iDQYyL46r5
         rpJGxlm1XtLGi7Sswnunch4Fgc0G5W9Rs5jtmeWEypEp7ElKefeimQ7nA/RKtL8yRIM8
         4CEXCiy+cM1uCW99F6VOlIXqFuwZg5tXrJnljsnArsg4S0VBOGs5jUZW5iwGv2I+j5/I
         LXcIPo54WD2zk9m0PF7ov/skisTz+pSzam21AEdqU+wYjmqroaAn+tjQiBW03bqVYqh2
         aX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LaTAyQuC6zp7HjW7YrOqIxfGo+OzbCrZrQxTTedix6E=;
        b=4dKRfHBaVPRiGKFeHdPtLM5Ns+awd0FUZouSGjZL3f7HY0gY9xkRLGglGdJ2N/fjLf
         xJSwbxQwkhk1iqipgVur3hTdwfESgFZCgwRa9hHrZAn6pGJiuJQgyKobr1+0Rz/l3qoB
         Dadhpvss3fn0W+KiYjxGVnErf5MTl/5GLPoipDZx8NEMBJkBd2ZgJv7cuojgJhEHGBQf
         Sa/NcBr//w7aXsZd3G2MdvmnHO2/YzVe6XYCqURWTp+kvEf8j9vHIShophUnlt4rzUbf
         /M4UWZscm1sc5FyNV+BkyjlysCdylTlMCMlooxfaXc80VUitwtNtV34tmBBeeV/5cGdF
         PUPg==
X-Gm-Message-State: AJIora9PGzxOKCkcmJqdnqJizg0EPPJxBwenTu3wUUH6RFwDV+7hOdC+
        6eiZuvOn7sd8DpAjs7YTmD4yuCwgB4kOeg==
X-Google-Smtp-Source: AGRyM1uBtly/QJM4Kpli3Ukp4hDqGh2kjZiqSkjvvm/JZUJUkdpLQhW1PSvNUZzSOZAh7UkhmQ1wCg==
X-Received: by 2002:a02:c045:0:b0:341:a08c:f72f with SMTP id u5-20020a02c045000000b00341a08cf72fmr10660585jam.121.1659538912559;
        Wed, 03 Aug 2022 08:01:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f2-20020a056638112200b0034268b833f7sm2052587jar.146.2022.08.03.08.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 08:01:52 -0700 (PDT)
Message-ID: <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
Date:   Wed, 3 Aug 2022 09:01:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Adding read_exact and write_all OPs?
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/22 3:04 PM, Artyom Pavlov wrote:
> Greetings!
> 
> In application code it's quite common to write/read a whole buffer and
> only then continue task execution. The traditional approach is to wrap
> read/write sycall/OP in loop, which is often done as part of a
> language std. In synchronous context it makes sense because it allows
> to process things like EINTR. But in asynchronous (event-driven)
> context I think it makes a bit less sense.
> 
> What do you think about potential addition of OPs like read_exact and
> write_all, i.e. OPs which on successful CQE guarantee that an input
> buffer was processed completely? They would allow to simplify user
> code and in some cases to significantly reduce ring traffic.

That may make sense, and there's some precedence there for sockets with
the WAITALL flags.

-- 
Jens Axboe

