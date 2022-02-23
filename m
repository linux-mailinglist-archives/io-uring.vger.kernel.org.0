Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BEF4C1F56
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 00:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiBWXH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Feb 2022 18:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244062AbiBWXHZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Feb 2022 18:07:25 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C8011C2B
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:57 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg16-20020a05600c3c9000b00380f6f473b0so2015420wmb.1
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DXht5QiO0hXb/Ggpab2+QkP0Eaos8xQns6oR63guU/g=;
        b=pbYT3zTSoQleFrr71I2DecDMPyL7+TGyAoiMDyxWSJh2DjsDPkr/rXlCT8FVDqMH9Z
         IgutYY7Ffvrps7O6mYCwBw41z5dbcE+v8ObJ7m4cjxOR1bR7FZNy6G+duE0CZZPbdkqG
         HoEUlSp9oPoLvnFzP0T4HIJ4L9BKA49DOfvVhUqZTJe/Rvmjhrebbkev7IjJCLpK8mGZ
         fP99zeG5MIvc8x5sImQW8gzTtkf4p+gsAjxNsQZpELQS+eyj/om9BbK/TbR+V8FMf5Gd
         pK3BSH59PHrUpNChivi/XmXqucD3RP8MSbPOci+1gmD/Vvfe037gG/+P6UOw+wVd5zjK
         5+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DXht5QiO0hXb/Ggpab2+QkP0Eaos8xQns6oR63guU/g=;
        b=a64B3pATxICtxCwyRhx3jyeTrOXdVP6SKubyAnkaAZfxTi/A6IdZsWse9ODtRhj3v1
         +3IHeYHVeCkdNKi+DY2s4SHrf2FOKzsoWCKBxzHLz3loepNfEnrcwO81YRbNbG63AqIs
         RxdL0Alfk4Rd7mxjqQM9qhpLMbeWf2goahA2MN+KNoj0m9ndmlLtqKFM66li3yHEKEkW
         KLT9fw/zB2w6do96UefVBmcp4miE5kPhKSUtBk0K3UILzB+NX70jwo0PW9/q502Gfev5
         j2a+ORIhN70qX5y5a4DysGReY9drVIyENuPKeKkgRPM63Ume3EY+k0337C0tHmkxfDa0
         kUfQ==
X-Gm-Message-State: AOAM530FFKub9ZEZAbDgJ5dEgtZ2AoH/F0K6pFQWW/+CcXyk0sua9Cid
        jZ4uXNoIvMHxtWurbXRz8fY=
X-Google-Smtp-Source: ABdhPJyGlzIyT7GJfdQc2njJ6aSmioM5xO4owf8PytVfQsR69ad0inQyyYpmfUsDBma1y2LuPblLaw==
X-Received: by 2002:a05:600c:4fc4:b0:37c:9116:ef3d with SMTP id o4-20020a05600c4fc400b0037c9116ef3dmr17194wmq.167.1645657615867;
        Wed, 23 Feb 2022 15:06:55 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.236])
        by smtp.gmail.com with ESMTPSA id c4sm236519wrn.116.2022.02.23.15.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:06:55 -0800 (PST)
Message-ID: <1fed35a9-e0b7-9f72-af12-64b9e6f6126f@gmail.com>
Date:   Wed, 23 Feb 2022 23:07:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 3/4] io_uring: do not recalculate ppos unnecessarily
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220222105504.3331010-1-dylany@fb.com>
 <20220222105504.3331010-4-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220222105504.3331010-4-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/22 10:55, Dylan Yudaken wrote:
> There is a slight optimisation to be had by calculating the correct pos
> pointer inside io_kiocb_update_pos and then using that later.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov
