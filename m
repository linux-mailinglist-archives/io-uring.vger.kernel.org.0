Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB10565E94F
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 11:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjAEKuN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 05:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjAEKtv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 05:49:51 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC83559C8
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 02:49:45 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so994000wms.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 02:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ri+Bub48EcHsJG5UBrlWlSq020EU9r9aculOc9B3z7s=;
        b=hzkGFzeyUAyw7hDl1UEDchf+UIO5P8daPOMPSwibdv5At1ft9JpYSnfOvNpEa8r6OM
         jWXF7l4yVvoIvw/XtjUPxfmjl2/wvz9/CL7Mud5yGlPKjRzqZ9YY5KXP6s4HKlzSOD6W
         UY7Vs2i3QUGhmgA+oM+fIOvsKbwiCdiUzBlGqfRZ2rNQTUlYFbTcrCRqs8bj3dBjFwhx
         jIw5odhW8yYALmTV78wObuS3N85C0TtvwqG7LiwXyJN9ixe/qBMH6ii6ArSpEVvCEdY4
         QMNYxHFf75XDi3OhJKLsypqzy+MEEmbkDY7Y/Jl2XIFhSgiO2jEJYTXuF3PMu4xTgTMX
         hXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ri+Bub48EcHsJG5UBrlWlSq020EU9r9aculOc9B3z7s=;
        b=DkKYrQN6DgaO8ErI/+WZAJD3pzSGR9fcbQMO8/ddCKOzi9GNlB430WXpaWXhrYOeIo
         SoAwMi2kyahvcFxu3E/5Tkdh6fTlfBfIErW8ipUsr4Lq6Ee8qyfvOv/VGRsBpIiq5ii5
         Lv8VM23+ClWk+GX4iqWuoeSr8NKiMVfpMq1nSRZWz9t8vZBnhaS1ufNRmeXkyHauQzCb
         Z3rdxjWRHlAsq7zmj1H0HVwAnKhlDFCAvP/mrBbU+xzcfrdPh5uvZXuPop17eZTB/3YN
         w2+N/HVBCGQ+xY0RQPEk8XYwg7Jxq8zZkH/aKIiUf9NTjUZmGPfteyFtjMvQNwCDSvkc
         q7wA==
X-Gm-Message-State: AFqh2koZbABtpFQFWRNcH9RpgmbzihzTxQSbab276B9tT9EJp77p7g7J
        1eBdW3IZJ9PJRnzoeLQ/pb54MSXKAnY=
X-Google-Smtp-Source: AMrXdXvtNVJtdbEdLilP4JTdKdyp77rk4cTKLvbTx38MawTm8UN3Wv8xWrrdLlIyCWCRwOj4z9G5oQ==
X-Received: by 2002:a05:600c:3d05:b0:3d3:5c21:dd94 with SMTP id bh5-20020a05600c3d0500b003d35c21dd94mr37658082wmb.9.1672915783487;
        Thu, 05 Jan 2023 02:49:43 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id h2-20020a05600c350200b003d9b351de26sm2262143wmq.9.2023.01.05.02.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 02:49:43 -0800 (PST)
Message-ID: <35a01aaa-cc37-6359-67fe-0fcde546947d@gmail.com>
Date:   Thu, 5 Jan 2023 10:48:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] io_uring: fix CQ waiting timeout handling
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <609a38a65f91643f9f9706b983a8aaa0e3001d77.1672915374.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <609a38a65f91643f9f9706b983a8aaa0e3001d77.1672915374.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/5/23 10:44, Pavel Begunkov wrote:
> Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
> particular we rearm it anew every time we get into
> io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
> CQEs and getting a task_work in the middle may double the timeout value,
> or even worse in some cases task may wait indefinitely.

Wrong base, will send v2

-- 
Pavel Begunkov
