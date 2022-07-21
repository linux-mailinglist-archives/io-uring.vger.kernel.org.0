Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4219057CDA8
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiGUO3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiGUO3k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:29:40 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE628688D
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:29:38 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id n13so879604ilk.1
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=dv5Xa3sw79SKXhsKD0ky5VXyt/Mi380ArH09DvLLu8Y=;
        b=1C7Jn5oEOCUSUrknL+Aia81kMhNerZHzhQ/ugPmRb8IiJ5sklVKgQ9M98aigtTU8yN
         eywP/b4dHJfbilEyHZ2I2bNQCoGbB/ZU9rvnjfV715QEnkPCDhcQQWw+Gr2aZD4Ju+Az
         IbbWFbc6LRNXamSm3AQF3DUjsg1bqFN9rnpbOFH9wYMMF3qtxexCnbedtPVP669T5c3G
         5HdbSYo/kPzxiEU/LNQdVFJ3noo+IidPjjwI9kxF28yChhJB3plcD9LCDBblmaMlH4uY
         soFq+1tTkfNLFdBSr9fQqSYHvga/CJRhL5ePJZZaFsxRHdctPHetRfaNaetbiWhLiRa5
         zDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=dv5Xa3sw79SKXhsKD0ky5VXyt/Mi380ArH09DvLLu8Y=;
        b=x1xPRNyrbUcfRfOtfBxwXNbqai/Kb8zAK8iT2WddxG5/cWCe5R7qo6D/h36Feggzre
         aF0KrzEcJyBI/jjN83aDSm+NQc4iFgtxHBhZ9ndDr+WP7Mh0S0IBo5+HBqc+wnAFevES
         gx1/3JVBX4xYh5V4nVFv8fUjSb00v83Vk/hIL6vzqJxyb3lZ7oXZJhR/QYt+9Y/oSIOh
         25QGoaGy+cyc3R3JwgrZmXDTn/y2BJBQ/hVFwllrzVkm2fc6OuC8RhAbs9/GccUt1+Lb
         KEPi/dfvzN8LDX47HK7K4KU1NawT0IFsJopdsw/u09PX35jHAA0h3qo0s1SmHO8/TYso
         ajgg==
X-Gm-Message-State: AJIora83lSytpZjXa0rU2O2NrZwd1lpddVuJERxyfOoaDi0LWSCGnRqL
        3mTFujAZeEr33XWGANNiu2Quyc+g2rX5uQ==
X-Google-Smtp-Source: AGRyM1tTwb9Uc51X/JBwgiwuTs/fv8uITklVuIU49soA7CMiAzlJW6SnkT7kJxdJY4GiwMG+UiL0oA==
X-Received: by 2002:a05:6e02:152a:b0:2dc:3984:196e with SMTP id i10-20020a056e02152a00b002dc3984196emr20553813ilu.228.1658413777054;
        Thu, 21 Jul 2022 07:29:37 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a18-20020a92c712000000b002dd16300beasm381381ilp.51.2022.07.21.07.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:29:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com, linux-kernel@vger.kernel.org,
        mail.dipanjan.das@gmail.com
In-Reply-To: <20220721110115.3964104-1-dylany@fb.com>
References: <20220721110115.3964104-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: fix free of unallocated buffer list
Message-Id: <165841377614.7746.5269980516216984960.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 08:29:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Jul 2022 04:01:15 -0700, Dylan Yudaken wrote:
> in the error path of io_register_pbuf_ring, only free bl if it was
> allocated.
> 
> 

Applied, thanks!

[1/1] io_uring: fix free of unallocated buffer list
      commit: ec8516f3b7c40ba7050e6b3a32467e9de451ecdf

Best regards,
-- 
Jens Axboe


