Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F94D7882
	for <lists+io-uring@lfdr.de>; Sun, 13 Mar 2022 22:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiCMVyu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Mar 2022 17:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiCMVyt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Mar 2022 17:54:49 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA5B15A10;
        Sun, 13 Mar 2022 14:53:41 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id r13so30080277ejd.5;
        Sun, 13 Mar 2022 14:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GhvMlaLXIBl69d2e2I1DBwNJZfAkADFlzhCg7cXuE7k=;
        b=xT+6CZydUyXijY4NFZ9DRytUZo0z1IGpqYev9Pj8Fi+PcOMVpkbby4+2KjOR84qqXS
         8n2AmNX5Du8M7s+P3JTgHHRuGF0/08St/iVyuie22ERNKpxa6eYfGRrs/Qsa/m2ZT3nI
         nW3zxLtEA1rUybxfYqB3yCZ6P6DyjrRTOYprg4o9Oo6Krcy6otqMigWBGwACenLJHyJh
         z8noWqHXuB7yIbiw9KHAXNrPTCEEsQpVvV8BQtz3QxzT58FJqRdjG9QNCN3ovIywpkv1
         twMkkgEKK4p/jkyUcSJwoFJSynsLxQs6wK6eIA4pvHVHyfc/P808I3JT0a1UQ+yBZbfp
         Bk0w==
X-Gm-Message-State: AOAM530cr8efXgywVbiCno2XJjfCV7ew/yJgBC/v8baTkpD6fQ3IL0js
        kAqPtCtgUh1XRyuR6UdMSCg=
X-Google-Smtp-Source: ABdhPJxed+q6AT46dUxx+14XZWsrYC4Q4t/biXHM77QpXqFMCGdDrmRX1buo2MOHsW3KyPhpW3Z1qQ==
X-Received: by 2002:a17:906:2695:b0:6cf:e1b4:118b with SMTP id t21-20020a170906269500b006cfe1b4118bmr16156282ejc.348.1647208419888;
        Sun, 13 Mar 2022 14:53:39 -0700 (PDT)
Received: from [10.100.102.14] (46-117-116-119.bb.netvision.net.il. [46.117.116.119])
        by smtp.gmail.com with ESMTPSA id q16-20020a170906145000b006bdaf981589sm5997845ejc.81.2022.03.13.14.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 14:53:39 -0700 (PDT)
Message-ID: <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
Date:   Sun, 13 Mar 2022 23:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220308152105.309618-6-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> +	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
> +	int srcu_idx = srcu_read_lock(&head->srcu);
> +	struct nvme_ns *ns = nvme_find_path(head);
> +	int ret = -EWOULDBLOCK;
> +
> +	if (ns)
> +		ret = nvme_ns_async_ioctl(ns, ioucmd);
> +	srcu_read_unlock(&head->srcu, srcu_idx);
> +	return ret;
> +}

No one cares that this has no multipathing capabilities what-so-ever?
despite being issued on the mpath device node?

I know we are not doing multipathing for userspace today, but this
feels like an alternative I/O interface for nvme, seems a bit cripled
with zero multipathing capabilities...
