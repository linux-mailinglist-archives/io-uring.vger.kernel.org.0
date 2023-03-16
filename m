Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6082C6BD074
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 14:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCPNMD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCPNL6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 09:11:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B9DC8890
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:11:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id o12so7401569edb.9
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678972315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lbfWtAUJSpUXceN5/a6zBDEdmI2s0L+KF732llDeAOs=;
        b=ZT3uC0U907F3LfzY4s0V1g/POVMyfisYQJLZAFcYEWMT4uGYEsGg+XTKyB9n1A7Bup
         H9WSAuXGCf0z5bf88TvKlEmDP/8r4m8OODH2NjnZ5gD7L82AvfgJgMNrSmsq0zHGsGQ5
         WHE0FQtoX64c8DhxByc4kQZGKWvUwo3jxxRQT6SXIkVye+ng+IKDbA2p3wdzDDdaB8IE
         Z6nmt0lQhppPWWJeJa0W90lxfF6eYMVY1eSRwoqT4SqNIFbA+5YmhxrTqa4UcbUqD3f9
         2NSLRV6Ux3k9BEqB/jjU4Y7YBm6Czics7C+7F9zD/77F3s/pXfmwY/CTD9XT60CzwNed
         WCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbfWtAUJSpUXceN5/a6zBDEdmI2s0L+KF732llDeAOs=;
        b=hHtM+4W3zOFg1PhshCT1FXIwEOHm+YULy3uHHCIL+Sj2lLeel7jmJ0c/LwJbrqaKZ1
         +39D5g3EvyY0L/q1sirlINxul2Sul2XP//UjzEtikIeejvEWwvjJh++20O7rG9oTHaAu
         QFFbV2DYmsw0TgaS9cj6+grtPTY2KVoKNUzS0TcLub8LsEtLatR4LmybedUS9UX+loxl
         aeiwjheuqehCVB9uFa5QaYR78VOsC7G5WRLSbuPNYKRMsMu0Sf7nyeILIjLxtswijvO3
         zPqvy/EC0dPNZIojZYkA6K6zkqUG4+sB6PPg9qk1ITsdMXLQkO6trx+RIY+HtcqJsjEn
         5EtQ==
X-Gm-Message-State: AO0yUKXVvALlDFv547WRSgJUDRfiRE4TTgAEhgWSLDM0WPQ9Qp/084ca
        rWM5fvk89Mic8IIgTctcWqd5zZPnE5w=
X-Google-Smtp-Source: AK7set+fpwcHW264+FbFLp0foIhJHx6kX25j9u7e+JzfT6AqCM8NaNV2D2oK1uZhxvQQnIyFaNencg==
X-Received: by 2002:a17:906:2dd2:b0:8b1:a3c7:a9c9 with SMTP id h18-20020a1709062dd200b008b1a3c7a9c9mr9635851eji.70.1678972315228;
        Thu, 16 Mar 2023 06:11:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id u1-20020a50c2c1000000b004fc6709cdd6sm3822556edf.35.2023.03.16.06.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 06:11:55 -0700 (PDT)
Message-ID: <aea9792e-ebd0-091c-068f-9bff1602583d@gmail.com>
Date:   Thu, 16 Mar 2023 13:10:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/1] io_uring/msg_ring: let target know allocated index
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 12:11, Pavel Begunkov wrote:
> msg_ring requests transferring files support auto index selection via
> IORING_FILE_INDEX_ALLOC, however they don't return the selected index
> to the target ring and there is no other good way for the userspace to
> know where is the receieved file.
> 
> Return the index for allocated slots and 0 otherwise, which is
> consistent with other fixed file installing requests.
> 
> Cc: stable@vger.kernel.org # v6.0+
> Fixes: e6130eba8a848 ("io_uring: add support for passing fixed file descriptors")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Link: https://github.com/axboe/liburing/issues/809


-- 
Pavel Begunkov
