Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE4550A8D
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 14:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiFSMP5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiFSMP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 08:15:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F28BC2C
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 05:15:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r1so7485746plo.10
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 05:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YgxjGZdQaBeR/oHVwc4ZoktGlSsQsePTQFdkY3TGNFk=;
        b=3h3+GdZiq9Dn5Rl1yIAyUCB+WgpDyfifjIoktg3XLUajRSOnXZdaeXMv2PZKySpXnD
         z/k27RJWRrIT0Oc6v+m9VrCOXFn3GLqzog+AVdA/v78Hctn+AbbsB+ZhVB6eWpkVOwim
         69snhOVgZpjOa0RAGxC6WfU34f/5bQpu8vSoLXEM8iRc8zVOJhXgxyfA0Lk/+GOPZyGZ
         0VtZYWdKempD8qUEi9yX569x61l6H7KgHoOyocESoh2covq/ELTVGZLWYNNChNXCpLWF
         LJDP1m7Ez3IJIJFwcJA0iWdDZWKIMtnnSCgsuv9ZF4331mgbBaG/EJg2hpWSgu+1CacX
         RB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YgxjGZdQaBeR/oHVwc4ZoktGlSsQsePTQFdkY3TGNFk=;
        b=vYTYu81NZda2/B+t9InAU8x568af7Lj4mOIl5toB4dYYdEWarF2IjEKI0zk2XEieIb
         DrOW1wd2SNNbRHEqo5xR/nJoffUWFsAU8VwfyNE0Cd9yHuE2EG0o2okVdxkbkx4Z3qS0
         O3gVPLN8sdq7/SGKkR37EcBvma3gD0ogIhMl6tCHEAcn7UCKsFTTsM/ZqA2f/fqlriZh
         3bX/Rvk4RIGvlAN72TEVNEtGJM1wRrSKmZE6WRlmbVyklYPbgcdTtTjBJSwxZmOB5yWu
         o9LSMpd6+xdu9LDEEkTY9zigdtiSRbUMv6prwXSGU99aizK+O+jzCPvH3EoigsZXQVcQ
         pS5w==
X-Gm-Message-State: AJIora8zewum99o0VNMeTEvJknwxt7w+wAHA1CGml8wW4P+BO/LkG6ww
        Xf14FfFad3ENuEjgCX53KsfC6mwTcmGUKA==
X-Google-Smtp-Source: AGRyM1uy7vtZ5i/DkpPuBxPDlP7ssn2CNQxLuM/Xq0K/zRtdxjGDNbIUiXbKavfcY000JYUXdAyNfg==
X-Received: by 2002:a17:903:2290:b0:167:59ad:52fb with SMTP id b16-20020a170903229000b0016759ad52fbmr18083526plh.78.1655640955253;
        Sun, 19 Jun 2022 05:15:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y6-20020a056a00180600b0051c147eee7bsm7034135pfa.110.2022.06.19.05.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 05:15:54 -0700 (PDT)
Message-ID: <c3511b07-9f36-eaef-531a-13103604fe86@kernel.dk>
Date:   Sun, 19 Jun 2022 06:15:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] io_uring: add sync cancelation API through
 io_uring_register()
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Carter Li <carter.li@eoitek.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220619020715.1327556-1-axboe@kernel.dk>
 <20220619020715.1327556-4-axboe@kernel.dk>
 <786492be-f732-59d0-ccef-e7be6a101002@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <786492be-f732-59d0-ccef-e7be6a101002@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 5:16 AM, Ammar Faizi wrote:
> Hi Jens,
> 
> On 6/19/22 9:07 AM, Jens Axboe wrote:
>> +        cd.seq = atomic_inc_return(&ctx->cancel_seq),
> 
> Not sure if it's intentional, but the comma after atomic_inc return()
> looks unique. While that's valid syntax, I think you want to use a
> semicolon to end it consistently.

Oops. Not intentional, that line was copied from the struct init at the
top of that function. I'll fix it up, thanks.

-- 
Jens Axboe

