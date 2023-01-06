Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5679165FE5F
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 10:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjAFJvY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 04:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbjAFJvT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 04:51:19 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4500143E6F;
        Fri,  6 Jan 2023 01:51:13 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so3180456wms.0;
        Fri, 06 Jan 2023 01:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XrvSssTB54upRg+amSTSh/m+siv7swZXJmxro5GGQhE=;
        b=DkMJEdErIM0JJ4Lsey5FNClcs15i1jkoL40dFVWuKQBG1HJHG7jCqEVxfF7pZUKOH4
         f3+tns/BVe41pT5SG9WNVhMZOgxWzzfWdW37h5QK6gXVXQX/guMyw4smWUmB3KLjFOqp
         JUBJLynSuNdC1E6rDaL3YcDvQNo/w0w1qChXa+YUCXwH8UzihQgxFkxM4mAffSBA9jws
         MDeHP7FegRPVUgUjPQmjP4PbAzaRef3WMb89myLHqCd2fv+On9aOvCWG28Zw+iCSVecc
         d+e5j65HDoBbW8G5J8MRCyYgsLmSNvyinldoEoPxbhNu7OIArj8tYpQeKbNY/k7daeKK
         8TAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrvSssTB54upRg+amSTSh/m+siv7swZXJmxro5GGQhE=;
        b=009aFAxoqt6QFOHB0Ak41MQsjpOydaNeEN/k6H4hyu8ATN9kg9RSyRnnD5EFg6ZF16
         4uZ6KsB9RqVieGdcEGP8S+0R6sGl5fGxb8FpLNARQk2zSwloZ3dzIztpMLCYG0kWsGDw
         /G9QBBpkyMAJcjVGvZS8nYYxTwfN4fcEC0tkkUOsAVxWBU1TsjAV+ZWcKMEkdPHyrQaC
         LUWtoG7vafgEPBPemjin8Oaeaj12WjCjTHbHRfprmtFZkArj28lx7oWLkmYyUMKiFeAm
         NDKci397MqywUIRFQDiTm6WmI4+NH12ufEMaFt2bgksHAvAZIUOHXxNRwYvCxshvnVYx
         5RTQ==
X-Gm-Message-State: AFqh2ko9ck5qOtMjMRFpgoRdXRjRlFHupm7iFX1ZESdfkH2YlMjGpOAG
        pGQsuoIYwwCdCkXOAQeQkY7WNkIjTsoBuw==
X-Google-Smtp-Source: AMrXdXsQ24CbKi7l5KynCzOUOI0ucQ+COq4HrbvltkoDujLgok5MIgKicQzXltu7ybAXDYYigIpAyA==
X-Received: by 2002:a05:600c:3d86:b0:3cf:9ac8:c537 with SMTP id bi6-20020a05600c3d8600b003cf9ac8c537mr40063633wmb.14.1672998671819;
        Fri, 06 Jan 2023 01:51:11 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bg24-20020a05600c3c9800b003cfa3a12660sm13770079wmb.1.2023.01.06.01.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 01:51:11 -0800 (PST)
Date:   Fri, 6 Jan 2023 12:51:07 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
Subject: Re: [PATCH] io_uring: fix some spelling mistakes in comment
Message-ID: <Y7fvC+3qjMPvAQIG@kadam>
References: <20230106091242.20288-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106091242.20288-1-yuzhe@nfschina.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 06, 2023 at 05:12:42PM +0800, Yu Zhe wrote:
> Fix typos in comment.
> 

The cancelation vs cancellation thing is a British vs American spelling
difference.  (Leave it as-is).

regards,
dan carpenter

