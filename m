Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF6523340
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 14:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiEKMjm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 08:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiEKMjl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 08:39:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119F92317FD
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 05:39:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so4832766pju.2
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 05:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mDgJVk1jb2BJYaDBi6ahGttjBE3dgYIJSjB02LvY/vo=;
        b=wQs8BBF2HMKjw6dfNwvZOpr3bx8ORtweCVG4t8qAH53r49dgsDRQjoliIa4lm+LW34
         neIvP8q2qolPr/e82DXDuGNg/5BHn8GpnWoqfRKL2qisdueFr1ozgZMbpi7QJs6ol0yJ
         ies1mmmqeY2sJ0q1mmq1XSVV/BK1XUiDwgPZcXavvNlBXUi9eSbVS58QtwhP5whtAkhg
         ZldSg6CScfldrV7cwW/JNgGDR2ZFfwuWc4t5ijWbUMLTZ1yIrfLCzYYK0/JjM08LWO8P
         ZUAPxdSicykW002poNpoxO1+rugZe6vJmkRwSNk2cqOzmKTYG7A1gfdkh1fPW2LTuZ7G
         YAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mDgJVk1jb2BJYaDBi6ahGttjBE3dgYIJSjB02LvY/vo=;
        b=reXAK1MzGkwJBiDax1oZm3dpBD9o628fFl9pZQmCiCp5q95D13SwTgi+QNrL2m3H1y
         mUHhDqSD9wyCDeCmQaU03Pf5IWNDK5bGAj2UiRWGMBJnnrRs/8mCm4OABx4maLH3JT+X
         xFYvOo6nxd4UQ/IkplN9H2uFD3dvHh6womFHlMtGM3Z73d/NEArFJDCY9cmeA8R3Kcfs
         E7ZCpKuFi4XDDc9YIf5c4cuv9ZjFYRakTzSsUaz3chygaOu1Z4RlCX6rhwGGP7jkJztU
         4iXZjrV+UHLssZ2IEo1l+3vb1C8mUcpvUj1D6J/srjaJSSRweAn41rCAO0uJNIZg7fjs
         UBvA==
X-Gm-Message-State: AOAM531cJnFgpXjhwJdMQX1pkZZOVzuEEco+UytnkZ2Br2+nPULfjJ61
        D8nMpHdRKUvECXjuUD+O+//boQ==
X-Google-Smtp-Source: ABdhPJz0HBHEzBcSiQ/3TGRCJbZoltpT077/zkszvcIOGyQ2i7rb7znEFv8iio93DabsXXdmNio35Q==
X-Received: by 2002:a17:902:c2d0:b0:15a:2344:f8a4 with SMTP id c16-20020a170902c2d000b0015a2344f8a4mr24954011pla.28.1652272780569;
        Wed, 11 May 2022 05:39:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902784700b0015e8d4eb1b6sm1828180pln.0.2022.05.11.05.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 05:39:40 -0700 (PDT)
Message-ID: <b7f8258a-8a63-3e5c-7a1a-d2a0eedf7b00@kernel.dk>
Date:   Wed, 11 May 2022 06:39:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 0/6] io_uring passthrough for nvme
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <CGME20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da@epcas5p3.samsung.com>
 <20220511054750.20432-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Which patches had changes in this series? I'm assuming it's just patch
1, but the changelog doesn't actually say. Would save me from comparing
to what's in-tree already.

-- 
Jens Axboe

