Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26ED6379EC
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 14:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKXN1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 08:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKXN1d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 08:27:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A099FCA
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:27:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mv18so1412179pjb.0
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6PUjkejs+nls1t0g8306qXKrK0t8sq0eiojWBp1T41k=;
        b=ygwjtPLkzl+RyY/tk3SD4LOBlJUDjJnwGvA8ADxDdx138iq9g9xHwOimu7NGC8wczQ
         +Nh7QsgWnkfvaf6F12mOXbx0NoIKOmtU/5LV5IHADEWQ7vL1yz69987iL/sQsMUE1ZXm
         tDNXfDAqDhtAmIzF1Wm8oDBqqp2fRSKpVqhtizA3bjryXHl9JQIkSTl6Ebt0zCyP0CbF
         1humz6LK/mFefZKTqkGOIMOlqy2P54dIIJypDkMn5MzdPWtHvUoXNev/y6BdD6WiNndx
         GCmi6Y/GL86qcLkq4QqDvIB4BHnkndG4QXyLH/nKIsNBX8xt6wOJ/tJQISYVvGsUNd8i
         1NFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PUjkejs+nls1t0g8306qXKrK0t8sq0eiojWBp1T41k=;
        b=aIpo3s4DXPJy0tJ4B/Z22SibU/t3mcaO5eEZBBx1A2P4Jw57MYZ0AsRqeDOvb7uxq0
         5YtqCRRVrvJy0OA8yfdCDfMARC+CO27MuXfJz5qde3kMAH9mtaxIqhNb/VljZrwvcAes
         urytTSnM2WVK+GWGC5j0APbkBinY9bBaGvpriTbFOnPxOjh4h1dkFk2A1BX1OHWssHfw
         hU9kyd1OjN0WN7pqEEjKuGcPdrQxtK9Ya9jA7LL2kMZbEQgv21aSmsC4VRGQUNr3hIVA
         2I1LvUrP4HmX2C66mIx4XKyba2Sl+pUpMMmksFnN5dxYu/e4AHh0TxEK8bMNKWjN0cpo
         2djg==
X-Gm-Message-State: ANoB5pmp4da+Lkf5Bd2+YneHHijUlwkR8tkjEpCEZO3rbi3fnAYm+YHI
        Bmh3vndpGnfS9Y7euLlIGr4zSVg2QGbl5fT3
X-Google-Smtp-Source: AA0mqf53lyI6J898djDryaNUL6PElJapvl4Kf9JYydoaSogpRMuJ8FYENAEMKZQB4XYCVvASJIM1FQ==
X-Received: by 2002:a17:903:26ce:b0:187:31da:a27e with SMTP id jg14-20020a17090326ce00b0018731daa27emr13389502plb.111.1669296451473;
        Thu, 24 Nov 2022 05:27:31 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902e8c300b00186c3afb49esm1251774plg.209.2022.11.24.05.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 05:27:30 -0800 (PST)
Message-ID: <6491d7b5-0a52-e6d1-0f86-d36ec88bbc15@kernel.dk>
Date:   Thu, 24 Nov 2022 06:27:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH liburing v1 1/7] liburing.h: Export
 `__io_uring_flush_sq()` function
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
 <20221124075846.3784701-2-ammar.faizi@intel.com>
 <f750be65c33e5d3a782cebf85954319caa77672f.camel@fb.com>
 <b303bde6-91b1-2ea2-7b1d-e64546c8ae7f@gnuweeb.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b303bde6-91b1-2ea2-7b1d-e64546c8ae7f@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 4:47 AM, Ammar Faizi wrote:
> On 11/24/22 5:14 PM, Dylan Yudaken wrote:
>> I think changing the tests to use the public API is probably better
>> than exporting this function. I don't believe it has much general use?
> 
> But there is no public API that does the same thing. I'll mark it
> as static and create a copy of that function in iopoll.c (in v2).
> 
> Something like this, what do you think?

Yeah I think this is better for now, and then we can work on fixing
the test. Sanity of the core parts of the library is a lot more
important than some test case.

-- 
Jens Axboe


