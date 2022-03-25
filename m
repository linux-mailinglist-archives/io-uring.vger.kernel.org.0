Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEE4E73A2
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359163AbiCYMjI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359139AbiCYMjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:39:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B702AD0839
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:37:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso8187641pjb.5
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jUjH/a2X4nCuaK3pNJFUl97yPJfSzMi3kUPEgbxow4A=;
        b=dQerxJAoi50MRb0M9LLvk+4EWciqQf906eKmMsIQ5aRUSLI1yhcvgVTMnWrRKxCkw2
         IRoo+VxwwIQHNrAUYDjsfzP9GL3bCknYdRkw9Mr1+UCXECkdFzsBfUQTWG8n+NeumYbZ
         2OrUcvjqU+chlpSDJ2KrfbOqveGNrIVXSgTA9v+Kgb5aE+XDF2O6K+TiUPxtloU0pC+b
         Y/DCQ7iBdhafVv+SUBbkILNQaMiJ0reXscVnluUyCJD/B5dJuwov7AtzNK36bCYHUvYn
         sOq8JjEbWCd8rq0YbTvZl2ya6pzkKRlpq0Cq65U+indeal/VnGxy6ItfDWvwkd6GXIwD
         N/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jUjH/a2X4nCuaK3pNJFUl97yPJfSzMi3kUPEgbxow4A=;
        b=xKV28jEr1QIFzwVTjwAKZcw3keo4Y3RZZhKSfOizy8kPWKirVt8OBoFAI5lQi4Qrys
         TlvTnhnPei1Ji2f5MfP8+I5lmmbGyc8ww+LQE1kpHIpaTcAdp3YCWhEXjSXsawcbdj1Q
         il+AFrbAqBbNXc8yQ3enxvoTB9fkjXv6Nyk1axYxbIuqZ9fK6gSlnQnIWEXF8cm0031U
         F8UcEUxDUGKONJpG288yuSXzc3NQL0IIYhIE+zNCxqDnHe5cOBdMPAikfOMI1XertZUF
         +HC1e/j9mkhiT7geGcKKOFq+/oh7vYaS3tGGc9JYluttU+RXN8zeybnh7kMik3KeYzJe
         lBPw==
X-Gm-Message-State: AOAM532iFq7Q5ce5fXp/l9ZV86ca3zCIONkuN4JY6A7yMynFD6lMIqSv
        op2NJyLLS8ZmNbYScsYCMgDTKyzS3riu7cIQ
X-Google-Smtp-Source: ABdhPJxaIFDjRMFvmfa5kLTt3ochGMLJl9wSy19t0g7KPaUddSv+EzO5I1IssWpbNPnHhB/VP0zSlQ==
X-Received: by 2002:a17:90a:1951:b0:1c6:2fa1:d83d with SMTP id 17-20020a17090a195100b001c62fa1d83dmr12447963pjh.116.1648211849122;
        Fri, 25 Mar 2022 05:37:29 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z7-20020a056a00240700b004e1cde37bc1sm6919240pfh.84.2022.03.25.05.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 05:37:28 -0700 (PDT)
Message-ID: <8f65bb9c-d50e-515e-86f8-7c0510e51e2a@kernel.dk>
Date:   Fri, 25 Mar 2022 06:37:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5/5] io_uring: improve req fields comments
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1648209006.git.asml.silence@gmail.com>
 <1e51d1e6b1f3708c2d4127b4e371f9daa4c5f859.1648209006.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1e51d1e6b1f3708c2d4127b4e371f9daa4c5f859.1648209006.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/22 5:52 AM, Pavel Begunkov wrote:
> Move a misplaced comment about req->creds and add a line with
> assumptions about req->link.

I'm going to pick this one for 5.18.

-- 
Jens Axboe

