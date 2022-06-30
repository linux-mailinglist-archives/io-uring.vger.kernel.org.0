Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8A8562088
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiF3QrQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiF3QrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:47:15 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A53EAA1
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:47:14 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w10so12774905ilj.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=CojSMT6k69Q2g5FIT1lrcZhxfv2R7BVXZhjcFi8iXOU=;
        b=RejmqWvOoo1CFI8E7qrHmm6qrPxl/duuGiif9CxWponL0sNrvw+X+hocgQVZJfDP6x
         3kABaoH5onPVpvEncByLVseBprxXQn+x3lryOxPTU15CkR1DA8fL9f0mXyWO5uDXJDWp
         Dzwq2TC6VEmDp6hPLglCIgHIo3WjJFc2rmCzK08L83oUOebkaHB7u7/Nf82KgUjDM4e6
         LdXyoy5gdXVKUCRuUou1m1ctQFq2Xe8VKeUwSAkC1g2Lhb+AA75OW1ot0QAyIi6/ACSF
         1eOfBOhlw92EHZqkboaMPqW0TlibPti4gURsQBW8lm0zMN4tbVvzfs71rGt5/oFwqmN2
         /AgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=CojSMT6k69Q2g5FIT1lrcZhxfv2R7BVXZhjcFi8iXOU=;
        b=YNL9fMnWmZXSwvXxh7I8z54qGS1MjgMixyRU7WsXdMXdc4fe+77F8DkZfNEMHDFyek
         BP/idDfEwJRtWWNko1ssKqVbY/wlQhZEUCWVf1jWR9V7Qnu24qzfb0zX2dVXrZZ7jrM1
         bNgF88GdTqV9i8Kmy9nZxrHtZr7+V9H4yoqWCOoJdzXOsEmCfjyQAAEd2ijQnMjwW85L
         lker6UwzqGqHEpjBw7LmOdgDYJULcmC2zbzb/zgCDaHJuF3aA8nQO+bouDPzoclFX9wZ
         d++5Q407cGksdR1LjaLbAkt1ysEFHXnDFkmGP+sulZNr1hhibxLlV6oHp50NI+yIpuzg
         ajFg==
X-Gm-Message-State: AJIora+KaMU9XnXSl8nc32Q8hf4Xz9NV35JX1a8W8RlQM/vqjg0PxkVE
        LzD7PVF8HdXs8Bbj5QkUd5sjjpl47KFOkw==
X-Google-Smtp-Source: AGRyM1uX7P5dAAMRezwC/FlcUGWt1MP3lFWIyQ11fe6PZarFKuJJ0HNnGHE2a9c8e8jSpGVLViQj/A==
X-Received: by 2002:a05:6e02:168c:b0:2da:971e:700c with SMTP id f12-20020a056e02168c00b002da971e700cmr5544694ila.311.1656607633486;
        Thu, 30 Jun 2022 09:47:13 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q4-20020a0566380ec400b0033de67b2ae3sm882223jas.122.2022.06.30.09.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:47:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
References: <cover.1656597976.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/5] ranged file slot alloc
Message-Id: <165660763257.631691.15649768713459002333.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 10:47:12 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 30 Jun 2022 15:10:12 +0100, Pavel Begunkov wrote:
> Add helpers and test ranged file slot allocation feature
> 
> Pavel Begunkov (5):
>   update io_uring.h with file slot alloc ranges
>   alloc range helpers
>   file-register: fix return codes
>   tests: print file-register errors to stderr
>   test range file alloc
> 
> [...]

Applied, thanks!

[1/5] update io_uring.h with file slot alloc ranges
      commit: 98626db560568fc6f572f829930798f48d226f63
[2/5] alloc range helpers
      commit: 161c6a65bd079872fb938665d15802d0e62a9cc9
[3/5] file-register: fix return codes
      commit: 52c3bea1ce9926e656b84fb050b61a57f0c3cac8
[4/5] tests: print file-register errors to stderr
      commit: c60c80b99f2f425423a7e57a97e359d295b8851c
[5/5] test range file alloc
      commit: 5829a98f5f5338502572392de4ac60e0865a44ac

Best regards,
-- 
Jens Axboe


