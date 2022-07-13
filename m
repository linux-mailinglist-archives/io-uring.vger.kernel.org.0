Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D15E573DC5
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 22:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbiGMUZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 16:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbiGMUZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 16:25:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950EB27B16
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 13:25:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so5634378pjm.2
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 13:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KNxdzYJ31Vhyt7oycuRbMlgHEjW6wotI0WNAdQq4UMw=;
        b=t8kPJVCKtimxDlTtyzRgs6JNvOaLECNuXxarQU5OqBNA+ziab/DxNvRTorr+G98Cl5
         2n5ZybUVwcbsU+P2E2FnhFqF/mDjUjQRVf+6EFKX70Vbyzk6vKllj0cfGMjRaaH7wV46
         OJqqnL5CnvYZ/tMqCZLuH5USn/gtG52kAARi3QGK/WoJbpmkwcRGlqfg+bv7QswLkwWF
         sqTDGUA8vN6GDwxQrdyDse3TUfWV6rQR1erg83hXbDszgJFa74wrL8rWeUtIlOlOn2rW
         idSQYSMMEmA6NKhXQnU+1DLRu0Ph3fLJmWMrp5S4wqtLYYQgpiVlQDtmbrMJhScjh0kg
         U6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KNxdzYJ31Vhyt7oycuRbMlgHEjW6wotI0WNAdQq4UMw=;
        b=oHM59jH+3+Ejan/2WqtkgRREvqTrmIzAAqND6/SzU/LE+rP9fHoJ2b/z23w4FbjEd1
         Pt9WIPkLqOjrLEcIcyTPdysWfjeKzlZOc0uWXk3C8PHXFFi3NF7W5J6ccGCh6/mwFgFz
         NKWzUd3j+FkBjw5YofSkhTDRWIgF99mzFSfMmxSJaXhxUxCws1zfMOsg8lpXvS9rD6sB
         o9xfl5+jk/9fZczn1T3plREgrQhjtUsbV0oXJnHNgjWY1jckuCcCx7LCroAS6wm6OOXz
         06JunKIK+Ye/PJqpRkEAXClJ2l/A89F5nJ3mNgcsZUFoRvDfjZcQecLOiiJ1+r5RqDW0
         IqYA==
X-Gm-Message-State: AJIora+l8D9UxxaX6JXd0qjWdIjPn+d3ct7silZBO4hOy8EdiQQdbe0f
        0aS9ENcueMMb6QAbY6ah9mcLmfZJtdDjwA==
X-Google-Smtp-Source: AGRyM1uMWJM21AdMA4hg31Ti1BfbhNdmhNhNqXCJYSv6TufmkF9YayM6wEk9gfkZAYCsy7kM3FFnog==
X-Received: by 2002:a17:90b:240b:b0:1ef:8a68:1596 with SMTP id nr11-20020a17090b240b00b001ef8a681596mr5542909pjb.234.1657743927006;
        Wed, 13 Jul 2022 13:25:27 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b0016bedcced2fsm9332014pll.35.2022.07.13.13.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 13:25:26 -0700 (PDT)
Message-ID: <6e5d590b-448d-ea75-f29d-877a2cd6413b@kernel.dk>
Date:   Wed, 13 Jul 2022 14:25:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V5 0/2] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220713140711.97356-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220713140711.97356-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/22 8:07 AM, Ming Lei wrote:
> Hello Guys,
> 
> ublk driver is one kernel driver for implementing generic userspace block
> device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
> ublk server[1] which is the userspace part of ublk for communicating
> with ublk driver and handling specific io logic by its target module.

Ming, is this ready to get merged in an experimental state?

-- 
Jens Axboe

