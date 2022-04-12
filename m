Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C144FE60F
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiDLQoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357780AbiDLQoN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:44:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA14580DE
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:41:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so3627051pjb.1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3LCjjulilVCC1fbiBIwkl13y7xhoya92h9KhSw/9YUE=;
        b=S/8zRV85rHaaFtPdfqa0eHP7b9LjzKV9h8Uuzl6sEcliosCVAllvdwZcM6pIhwUbgF
         LF0Sa0gk1x/D37eKpWsK1+SS8+eAMWoERU5EGdjPOVJusWHBR7UFl0cN3WGb8VQTfjnR
         IJ1dPwdyGTorUrQnUyuAPLkWj3mFbn9C3D64NYfaZh17gV3Qu+t80JMcFrWeesnV6ExN
         XvzGshY44MQZD5b8szsOjrCr1Xp6aNmhS+en+6q+JF65eglSJYiNFQQtgiqYgC6Q9Gt2
         V27aGK0Lw1F8GkXhU3g6GViA3ISpeIRBjVMntO47Iid97n07SvMDsk82S3QPrR+/x6ly
         DXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3LCjjulilVCC1fbiBIwkl13y7xhoya92h9KhSw/9YUE=;
        b=WzIG6ddgtnRVJVAqo9JO1ATwmD/re37zHZpoJf645HlEzl+YLATzThB+OjjXwrLxA3
         fl6N66UI7OzgH9i4sH55z+gbkV7JmWd5hnYLnnDKUyjrsQoUop+9xU5MxMYxVyIDspXP
         JovkrJBBmaqSMxStg8cLZa00xiYIAgO3u+C+b9d8ibPRe7MSJcfnMH9txHK6805Q28Xo
         8anRKXb1L8y6GljVj+V70x0xj6nqrr+6ePmB5sBgi8onsAJx5YdhORB+kS4iqKRV9YV0
         wYPJBE87ZOAEOGEk5sXpU7H+H5Svh7QO81ufBneyb2WlFzNh1l9u9nsQ1NERpzcc+qOQ
         kUSA==
X-Gm-Message-State: AOAM530Ik+HKK6OGd0ej+jhRICJy+TWJ0Kelgplqo7OvmI6DsYeFweDy
        3ixBsPUtg9LKohRNMaDInkCynA==
X-Google-Smtp-Source: ABdhPJzDCIR4Gi5yvfASXWw1zWOATUDnUFW/Ev9WdA9Ad/X7xQN+tduNAHsUmZd+h1Qaqhv6PwIB/w==
X-Received: by 2002:a17:90b:3b42:b0:1cd:42bb:844a with SMTP id ot2-20020a17090b3b4200b001cd42bb844amr1084614pjb.239.1649781714799;
        Tue, 12 Apr 2022 09:41:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h19-20020a632113000000b0039d9c5be7c8sm2466022pgh.21.2022.04.12.09.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:41:54 -0700 (PDT)
Message-ID: <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
Date:   Tue, 12 Apr 2022 10:41:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 10:24 AM, Pavel Begunkov wrote:
> If all completed requests in io_do_iopoll() were marked with
> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
> io_free_batch_list() leaking memory and resources.
> 
> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
> return the value greater than the real one, but iopolling will deal with
> it and the userspace will re-iopoll if needed. In anyway, I don't think
> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Ah good catch - yes probably not much practical concern, as the lack of
ordering for file IO means that CQE_SKIP isn't really useful for that
scenario.

-- 
Jens Axboe

