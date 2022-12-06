Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C58644A31
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 18:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiLFRT2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 12:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbiLFRT1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 12:19:27 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D756326EB
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 09:19:26 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e189so10149227iof.1
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 09:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ho2UpcLMhRNuYRtkKPXaTs04lnlhHdiCpV5pfyBU2e0=;
        b=O/Gsv9qAY4e7C++ZiWlkamAbqOqEfs9rfdJEeYT8rz+0Aeq+zMCcSDxwply7RNFF1E
         oxYdAC9l7a2OAMitJrSnU9XwUZWi7GrwL25XG8nAi1JKImZELtHIvaJ2HGdIFg1AVVAs
         0QQSDQ3cHru3qBXXjA4CCoECcbFZkRQuT8XTuDLQde5N3AcFVnF+RAOb4vabg3nu4Bp/
         9cPwBOl3ApYnKT45WEDW4dL1IQHQSzIf+TaK06/Vu5I+AJl+dwdvD00ifsKozhIbODCm
         NnB5XezJJpBzc5mc8uTYJK67rgax0sIrbV/CxhT3BKAQbbrK4bR0ngfklHe0aRuDuKQc
         QYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ho2UpcLMhRNuYRtkKPXaTs04lnlhHdiCpV5pfyBU2e0=;
        b=Nez69RZNjTx9EjN72y8ylyIWNdNtzCkEgcIrvZz0sRTeoQfkRJFpGz81DJg3M6ILtM
         HPS7ZqgmqTnBxVetFJ2P4azOEpxYjiHYHEdDB+tC+2p/7jh/ZWiWRwAeciZaAf0q2kr+
         veL5E1FBrYNFklkmW02gtLadhoxIrmBmfMdn54iRiYrNbVuO6XquyP/cwOU2Uuqyz//a
         a9N84ll37YY3EdayjptFceMAEJKauuKSKzuWP1xQbHWZXXk8qzNAvqya9Z1cGWH/MGEL
         4voBeW0ofCaG1hRfYuKztj5nai6kjHixL2fZMApDmb0oELcHaIM3KgpzSAg4du/GLAOJ
         Atjw==
X-Gm-Message-State: ANoB5pmxfUIOak4xL+iuhHdL9zu7YrTOPxbwtaNhxNrmclPhnaqyIfWb
        z6NX+j/UpvNNuQmORN1rFCpHTKhjGu2kzUEuUlo=
X-Google-Smtp-Source: AA0mqf425ziTVSq6LvQzghyGOjhArYMq6J10nW3sW2rDmedn6aVP/xT2l+C+y4EDw0rOTlVbGdwEqw==
X-Received: by 2002:a6b:cd8d:0:b0:6e0:d9a:2898 with SMTP id d135-20020a6bcd8d000000b006e00d9a2898mr4391901iog.99.1670347165642;
        Tue, 06 Dec 2022 09:19:25 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a056e02104600b00302bb083c2bsm6272285ilj.21.2022.12.06.09.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:19:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20221206121831.5528-1-joshi.k@samsung.com>
References: =?utf-8?q?=3CCGME20221206123005epcas5p474a1374f850c47f2c9af5ef8c?=
 =?utf-8?q?8cc6509=40epcas5p4=2Esamsung=2Ecom=3E?=
 <20221206121831.5528-1-joshi.k@samsung.com>
Subject: Re: [PATCH liburing 0/2] passthrough test fix and cleanup
Message-Id: <167034716498.331979.3198100086235204136.b4-ty@kernel.dk>
Date:   Tue, 06 Dec 2022 10:19:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 06 Dec 2022 17:48:29 +0530, Kanchan Joshi wrote:
> This series does a fix in test/io_uring_passthrough.c and a minor
> cleanup too.
> Please take a look.
> 
> Kanchan Joshi (2):
>   test/io_uring_passthrough: fix iopoll test
>   test/io_uring_passthrough: cleanup invalid submission test
> 
> [...]

Applied, thanks!

[1/2] test/io_uring_passthrough: fix iopoll test
      commit: 6e86d14a0a88e41c442a4a9c37effc55ac00d2ff
[2/2] test/io_uring_passthrough: cleanup invalid submission test
      commit: 29ec9d9fd3262034e4dce32cb75c0faaad158d1c

Best regards,
-- 
Jens Axboe


